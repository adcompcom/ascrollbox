import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoMetadata {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String platform;

  const VideoMetadata({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.platform,
  });
}

class MetadataService {
  static const _timeout = Duration(seconds: 12);

  // Standard browser UA for generic scraping
  static const _browserUA =
      'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  // Facebook's own crawler UA — makes FB serve OG tags for Reels
  static const _fbCrawlerUA =
      'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)';

  Future<VideoMetadata> fetch(String rawUrl) async {
    final url = _normalizeUrl(rawUrl);
    final platform = detectPlatform(url);

    switch (platform) {
      case 'youtube':
        return await _youtubeOEmbed(url) ?? _empty(url, platform);
      case 'tiktok':
        return await _tiktokOEmbed(url) ?? _empty(url, platform);
      case 'facebook':
        return await _facebookScrape(url) ?? _empty(url, platform);
      case 'instagram':
        return await _instagramScrape(url) ?? _empty(url, platform);
      default:
        return await _scrapeHtml(url, platform, ua: _browserUA);
    }
  }

  // ── YouTube oEmbed ────────────────────────────────────────────

  Future<VideoMetadata?> _youtubeOEmbed(String url) async {
    try {
      final endpoint = Uri.parse(
        'https://www.youtube.com/oembed'
        '?url=${Uri.encodeComponent(url)}&format=json',
      );
      final res = await http.get(endpoint).timeout(_timeout);
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return VideoMetadata(
        title: _clean(json['title'] as String? ?? url),
        description: _clean(json['author_name'] as String? ?? ''),
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
        platform: 'youtube',
      );
    } catch (_) {
      return null;
    }
  }

  // ── TikTok oEmbed ─────────────────────────────────────────────

  Future<VideoMetadata?> _tiktokOEmbed(String url) async {
    try {
      final endpoint = Uri.parse(
        'https://www.tiktok.com/oembed'
        '?url=${Uri.encodeComponent(url)}',
      );
      final res = await http.get(
        endpoint,
        headers: {'User-Agent': _browserUA},
      ).timeout(_timeout);
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return VideoMetadata(
        title: _clean(json['title'] as String? ?? url),
        description: _clean(json['author_name'] as String? ?? ''),
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
        platform: 'tiktok',
      );
    } catch (_) {
      return null;
    }
  }

  // ── Facebook scraping con UA del crawler oficial de FB ────────

  Future<VideoMetadata?> _facebookScrape(String url) async {
    // Try both the facebookexternalhit UA and a plain browser UA
    for (final ua in [_fbCrawlerUA, _browserUA]) {
      try {
        final res = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': ua,
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'es-419,es;q=0.9,en;q=0.8',
            'Cache-Control': 'no-cache',
          },
        ).timeout(_timeout);

        if (res.statusCode != 200) continue;

        final body = _fixEncoding(res);
        final title = _ogTag(body, 'og:title') ?? _htmlTitle(body) ?? url;
        final description =
            _ogTag(body, 'og:description') ?? _metaTag(body, 'description') ?? '';

        // Facebook Reels use og:image, og:image:url, or og:image:secure_url
        final thumbnail = _ogTag(body, 'og:image:secure_url') ??
            _ogTag(body, 'og:image:url') ??
            _ogTag(body, 'og:image') ??
            _extractFirstImage(body) ??
            '';

        if (title.isEmpty && thumbnail.isEmpty) continue;

        return VideoMetadata(
          title: _facebookTitle(title),
          description: _clean(description),
          thumbnailUrl: _clean(thumbnail),
          platform: 'facebook',
        );
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  // ── Instagram scraping ───────────────────────────────────────

  Future<VideoMetadata?> _instagramScrape(String url) async {
    // Instagram is Meta — facebookexternalhit UA serves OG tags
    for (final ua in [_fbCrawlerUA, _browserUA]) {
      try {
        final res = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': ua,
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'es-419,es;q=0.9,en;q=0.8',
          },
        ).timeout(_timeout);

        if (res.statusCode != 200) continue;

        final body = _fixEncoding(res);
        final title = _ogTag(body, 'og:title') ?? _htmlTitle(body) ?? url;
        final description =
            _ogTag(body, 'og:description') ?? _metaTag(body, 'description') ?? '';
        final thumbnail = _ogTag(body, 'og:image:secure_url') ??
            _ogTag(body, 'og:image') ??
            '';

        if (title.isEmpty && thumbnail.isEmpty) continue;

        return VideoMetadata(
          title: _clean(title),
          description: _clean(description),
          thumbnailUrl: _clean(thumbnail),
          platform: 'instagram',
        );
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  /// Strips Facebook's "X views · Y reactions | " prefix from the title.
  String _facebookTitle(String raw) {
    final cleaned = _clean(raw);
    final idx = cleaned.indexOf('|');
    if (idx >= 0 && idx < cleaned.length - 1) {
      return cleaned.substring(idx + 1).trim();
    }
    return cleaned;
  }

  /// Last-resort: picks any <img src="https://..."> from the page.
  String? _extractFirstImage(String html) {
    final m = RegExp(
      r'<img[^>]+src="(https://[^"]+)"',
      caseSensitive: false,
    ).firstMatch(html);
    return m?.group(1)?.trim();
  }

  // ── Generic HTML scraping ─────────────────────────────────────

  Future<VideoMetadata> _scrapeHtml(
    String url,
    String platform, {
    required String ua,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': ua},
      ).timeout(_timeout);

      if (res.statusCode == 200) {
        final body = _fixEncoding(res);
        final title =
            _ogTag(body, 'og:title') ?? _htmlTitle(body) ?? url;
        final description =
            _ogTag(body, 'og:description') ??
            _metaTag(body, 'description') ??
            '';
        final thumbnail = _ogTag(body, 'og:image') ?? '';
        return VideoMetadata(
          title: _clean(title),
          description: _clean(description),
          thumbnailUrl: _clean(thumbnail), // decode &amp; → & in CDN URL
          platform: platform,
        );
      }
    } catch (_) {}
    return _empty(url, platform);
  }

  // ── Helpers ───────────────────────────────────────────────────

  static String detectPlatform(String url) {
    final u = url.toLowerCase();
    if (u.contains('youtube.com') || u.contains('youtu.be')) return 'youtube';
    if (u.contains('tiktok.com')) return 'tiktok';
    if (u.contains('instagram.com')) return 'instagram';
    if (u.contains('facebook.com') || u.contains('fb.watch') ||
        u.contains('fb.com')) {
      return 'facebook';
    }
    return 'other';
  }

  static String? extractUrl(String text) {
    final pattern = RegExp(r'https?://[^\s]+', caseSensitive: false);
    return pattern.firstMatch(text)?.group(0);
  }

  VideoMetadata _empty(String url, String platform) =>
      VideoMetadata(title: url, description: '', thumbnailUrl: '', platform: platform);

  String _normalizeUrl(String url) {
    url = url.trim();
    if (!url.startsWith('http')) url = 'https://$url';
    return url;
  }

  /// Respects charset declared in headers/meta; avoids mojibake.
  String _fixEncoding(http.Response res) {
    final contentType = res.headers['content-type'] ?? '';
    if (contentType.contains('charset=utf-8') ||
        contentType.contains('charset=UTF-8')) {
      return utf8.decode(res.bodyBytes, allowMalformed: true);
    }
    // Try UTF-8 first, fall back to latin1
    try {
      return utf8.decode(res.bodyBytes);
    } catch (_) {
      return latin1.decode(res.bodyBytes);
    }
    // ignore: dead_code
  }

  String? _ogTag(String html, String property) {
    for (final re in [
      RegExp(
        '<meta[^>]+property=["\']${RegExp.escape(property)}["\'][^>]+content=["\']([^"\']+)["\']',
        caseSensitive: false,
      ),
      RegExp(
        '<meta[^>]+content=["\']([^"\']+)["\'][^>]+property=["\']${RegExp.escape(property)}["\']',
        caseSensitive: false,
      ),
    ]) {
      final m = re.firstMatch(html);
      if (m != null) return m.group(1);
    }
    return null;
  }

  String? _metaTag(String html, String name) {
    for (final re in [
      RegExp(
        '<meta[^>]+name=["\']${RegExp.escape(name)}["\'][^>]+content=["\']([^"\']+)["\']',
        caseSensitive: false,
      ),
      RegExp(
        '<meta[^>]+content=["\']([^"\']+)["\'][^>]+name=["\']${RegExp.escape(name)}["\']',
        caseSensitive: false,
      ),
    ]) {
      final m = re.firstMatch(html);
      if (m != null) return m.group(1);
    }
    return null;
  }

  String? _htmlTitle(String html) {
    final m = RegExp(r'<title[^>]*>([^<]+)</title>', caseSensitive: false)
        .firstMatch(html);
    return m?.group(1)?.trim();
  }

  /// Decodes HTML entities including numeric decimal and hex forms.
  String _clean(String text) {
    // Named entities
    text = text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&laquo;', '«')
        .replaceAll('&raquo;', '»')
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '…');

    // Numeric decimal: &#NNNN;
    text = text.replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (m) {
        final code = int.tryParse(m.group(1)!);
        return code != null ? String.fromCharCode(code) : m.group(0)!;
      },
    );

    // Numeric hex: &#xNNNN;
    text = text.replaceAllMapped(
      RegExp(r'&#x([0-9a-fA-F]+);', caseSensitive: false),
      (m) {
        final code = int.tryParse(m.group(1)!, radix: 16);
        return code != null ? String.fromCharCode(code) : m.group(0)!;
      },
    );

    return text.trim();
  }
}
