import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../models/video_model.dart';
import '../models/tag_model.dart';
import '../services/firestore_service.dart';
import '../services/metadata_service.dart';
import '../services/tag_classifier.dart';

enum SortOrder { newest, oldest, byPlatform }

class AppProvider extends ChangeNotifier {
  final FirestoreService _db = FirestoreService();
  final MetadataService _meta = MetadataService();

  StreamSubscription<List<VideoModel>>? _videosSub;
  StreamSubscription<List<PackModel>>? _packsSub;
  StreamSubscription<User?>? _authSub;

  List<VideoModel> videos = [];
  List<PackModel> packs = [];
  bool isLoading = false;
  String? pendingShareUrl;
  String _searchQuery = '';
  Set<String> _filterTags = {};
  SortOrder _sortOrder = SortOrder.newest;
  AppLocalizations? _l10n;

  AppProvider() {
    _authSub = FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _startListening(user.uid);
      } else {
        _clear();
      }
    });
  }

  String get searchQuery => _searchQuery;
  Set<String> get filterTags => _filterTags;
  SortOrder get sortOrder => _sortOrder;

  void setL10n(AppLocalizations l10n) {
    _l10n = l10n;
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    notifyListeners();
  }

  /// Tag → count of videos that have it, sorted descending by count.
  Map<String, int> get tagCounts {
    final counts = <String, int>{};
    for (final v in videos) {
      for (final t in v.tags) {
        counts[t] = (counts[t] ?? 0) + 1;
      }
    }
    return Map.fromEntries(
      counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  /// Tags sorted by frequency — most used first.
  List<String> get allUsedTags => tagCounts.keys.toList();

  List<VideoModel> get filteredVideos {
    var result = videos;

    // OR filter: video must have at least one of the selected tags
    if (_filterTags.isNotEmpty) {
      result = result
          .where((v) => v.tags.any((t) => _filterTags.contains(t)))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((v) {
        if (v.title.toLowerCase().contains(q)) return true;
        if (v.notes != null && v.notes!.toLowerCase().contains(q)) return true;
        return v.tags.any((t) {
          if (t.toLowerCase().contains(q)) return true;
          // also check localized tag name
          if (_l10n != null) {
            return localizedTag(t, _l10n!).toLowerCase().contains(q);
          }
          return false;
        });
      }).toList();
    }

    // Apply sort order
    switch (_sortOrder) {
      case SortOrder.newest:
        // Firestore already returns newest first — no-op
        break;
      case SortOrder.oldest:
        result = result.reversed.toList();
        break;
      case SortOrder.byPlatform:
        result = [...result]
          ..sort((a, b) => a.platform.compareTo(b.platform));
        break;
    }

    return result;
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void toggleFilterTag(String tag) {
    if (_filterTags.contains(tag)) {
      _filterTags = {..._filterTags}..remove(tag);
    } else {
      _filterTags = {..._filterTags, tag};
    }
    notifyListeners();
  }

  void clearFilterTags() {
    _filterTags = {};
    notifyListeners();
  }

  void setPendingShare(String? url) {
    pendingShareUrl = url;
    notifyListeners();
  }

  // ── Videos ────────────────────────────────────────────────────

  Future<void> saveVideo(String uid, String url, List<String> tags) async {
    isLoading = true;
    notifyListeners();
    try {
      final meta = await _meta.fetch(url);
      await _db.addVideo(
        uid,
        VideoModel(
          id: '',
          url: url,
          platform: meta.platform,
          title: meta.title.isEmpty ? url : meta.title,
          thumbnailUrl: meta.thumbnailUrl,
          tags: tags,
          packIds: [],
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVideo(String uid, String videoId) =>
      _db.deleteVideo(uid, videoId);

  Future<void> updateVideo(String uid, VideoModel video) =>
      _db.updateVideo(uid, video);

  Future<void> updateVideoTags(
          String uid, VideoModel video, List<String> tags) =>
      _db.updateVideo(uid, video.copyWith(tags: tags));

  Future<void> updateVideoNotes(
          String uid, VideoModel video, String? notes) =>
      _db.updateVideo(uid, video.copyWith(notes: notes));

  /// Auto-suggests tags from title + description using TagClassifier.
  Future<List<String>> suggestTags(String url) async {
    try {
      final meta = await _meta.fetch(url);
      return TagClassifier.suggest(meta.title, meta.description);
    } catch (_) {
      return [];
    }
  }

  // ── Packs ─────────────────────────────────────────────────────

  Future<void> createPack(String uid, String name) =>
      _db.createPack(uid, name);

  Future<void> renamePack(String uid, String packId, String name) =>
      _db.renamePack(uid, packId, name);

  Future<void> deletePack(String uid, String packId) =>
      _db.deletePack(uid, packId);

  Future<void> addVideoToPack(String uid, String packId, String videoId) =>
      _db.addVideoToPack(uid, packId, videoId);

  Future<void> removeVideoFromPack(
          String uid, String packId, String videoId) =>
      _db.removeVideoFromPack(uid, packId, videoId);

  List<VideoModel> videosInPack(PackModel pack) =>
      videos.where((v) => pack.videoIds.contains(v.id)).toList();

  // ── Internal ─────────────────────────────────────────────────

  void _startListening(String uid) {
    _videosSub?.cancel();
    _packsSub?.cancel();
    _videosSub = _db.watchVideos(uid).listen((v) {
      videos = v;
      notifyListeners();
    });
    _packsSub = _db.watchPacks(uid).listen((p) {
      packs = p;
      notifyListeners();
    });
  }

  void _clear() {
    _videosSub?.cancel();
    _packsSub?.cancel();
    videos = [];
    packs = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _videosSub?.cancel();
    _packsSub?.cancel();
    super.dispose();
  }
}
