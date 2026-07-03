import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String url;
  final String platform;
  final String title;
  final String thumbnailUrl;
  final List<String> tags;
  final List<String> packIds;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final bool isPrivate;

  /// How the video was added: 'url_input' | 'share_intent'
  final String source;

  /// Times the user opened the video player for this video.
  final int viewCount;
  final DateTime? lastViewedAt;

  VideoModel({
    required this.id,
    required this.url,
    required this.platform,
    required this.title,
    required this.thumbnailUrl,
    required this.tags,
    required this.packIds,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.isPrivate = false,
    this.source = 'url_input',
    this.viewCount = 0,
    this.lastViewedAt,
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Migrate old 'category' string to tags list
    List<String> tags = List<String>.from(data['tags'] ?? []);
    if (tags.isEmpty && data['category'] != null) {
      final cat = data['category'] as String;
      if (cat.isNotEmpty && cat != 'Sin categoría') {
        tags = [cat.split('/').last];
      }
    }

    return VideoModel(
      id: doc.id,
      url: data['url'] ?? '',
      platform: data['platform'] ?? 'other',
      title: data['title'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      tags: tags,
      packIds: List<String>.from(data['packIds'] ?? []),
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      notes: data['notes'],
      isPrivate: data['isPrivate'] as bool? ?? false,
      source: data['source'] as String? ?? 'url_input',
      viewCount: (data['viewCount'] as num?)?.toInt() ?? 0,
      lastViewedAt: (data['lastViewedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'url': url,
        'platform': platform,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
        'tags': tags,
        'packIds': packIds,
        'createdAt': Timestamp.fromDate(createdAt),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
        if (notes != null) 'notes': notes,
        'isPrivate': isPrivate,
        'source': source,
        'viewCount': viewCount,
        if (lastViewedAt != null)
          'lastViewedAt': Timestamp.fromDate(lastViewedAt!),
      };

  String get embedUrl {
    switch (platform) {
      case 'youtube':
        final id = _youtubeId;
        return id.isEmpty
            ? url
            : 'https://www.youtube.com/embed/$id?autoplay=1';
      case 'instagram':
        final shortcode = _instagramShortcode;
        return shortcode.isEmpty
            ? url
            : 'https://www.instagram.com/p/$shortcode/embed/';
      case 'tiktok':
        final id = _tiktokId;
        return id.isEmpty ? url : 'https://www.tiktok.com/embed/v2/$id';
      default:
        return url;
    }
  }

  String get _youtubeId {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.firstOrNull ?? '';
    }
    if (uri.pathSegments.contains('shorts')) {
      final idx = uri.pathSegments.indexOf('shorts');
      return uri.pathSegments.elementAtOrNull(idx + 1) ?? '';
    }
    return uri.queryParameters['v'] ?? '';
  }

  String get _instagramShortcode {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    final segments = uri.pathSegments;
    if (segments.length >= 2 &&
        (segments[0] == 'p' || segments[0] == 'reel')) {
      return segments[1];
    }
    return '';
  }

  String get _tiktokId {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    final idx = uri.pathSegments.indexOf('video');
    return idx >= 0
        ? (uri.pathSegments.elementAtOrNull(idx + 1) ?? '')
        : '';
  }

  VideoModel copyWith({
    String? id,
    String? url,
    String? platform,
    String? title,
    String? thumbnailUrl,
    List<String>? tags,
    List<String>? packIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    bool? isPrivate,
    String? source,
    int? viewCount,
    DateTime? lastViewedAt,
  }) =>
      VideoModel(
        id: id ?? this.id,
        url: url ?? this.url,
        platform: platform ?? this.platform,
        title: title ?? this.title,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        tags: tags ?? this.tags,
        packIds: packIds ?? this.packIds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        notes: notes ?? this.notes,
        isPrivate: isPrivate ?? this.isPrivate,
        source: source ?? this.source,
        viewCount: viewCount ?? this.viewCount,
        lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      );
}
