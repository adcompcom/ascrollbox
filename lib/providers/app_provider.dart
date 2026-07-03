import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/community_pack_model.dart';
import '../models/pack_model.dart';
import '../models/user_profile_model.dart';
import '../models/video_model.dart';
import '../models/tag_model.dart';
import '../services/firestore_service.dart';
import '../services/metadata_service.dart';
import '../services/storage_service.dart';

enum SortOrder { newest, oldest, byPlatform }

class AppProvider extends ChangeNotifier {
  final FirestoreService _db = FirestoreService();
  final MetadataService _meta = MetadataService();

  StreamSubscription<List<VideoModel>>? _videosSub;
  StreamSubscription<List<PackModel>>? _packsSub;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<List<CommunityPackModel>>? _publicPacksSub;
  StreamSubscription<List<String>>? _savedPackIdsSub;
  StreamSubscription<UserProfileModel?>? _profileSub;

  List<VideoModel> _allVideos = [];
  List<PackModel> packs = [];
  List<CommunityPackModel> publicCommunityPacks = [];
  List<String> _savedCommunityPackIds = [];
  List<CommunityPackModel> savedCommunityPacks = [];
  UserProfileModel? userProfile;
  bool isLoading = false;
  String _searchQuery = '';
  Set<String> _filterTags = {};
  SortOrder _sortOrder = SortOrder.newest;
  AppLocalizations? _l10n;

  AppProvider() {
    _authSub = FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _startListening(user);
      } else {
        _clear();
      }
    });
  }

  // Public videos only — used everywhere except PrivateScreen
  List<VideoModel> get videos =>
      _allVideos.where((v) => !v.isPrivate).toList();

  // Private videos only — used by PrivateScreen
  List<VideoModel> get privateVideos =>
      _allVideos.where((v) => v.isPrivate).toList();

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

  /// Tag → count of public videos that have it, sorted descending by count.
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
          if (_l10n != null) {
            return localizedTag(t, _l10n!).toLowerCase().contains(q);
          }
          return false;
        });
      }).toList();
    }

    switch (_sortOrder) {
      case SortOrder.newest:
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

  // ── Videos ────────────────────────────────────────────────────

  Future<void> saveVideo(
    String uid,
    String url,
    List<String> tags, {
    bool isPrivate = false,
    String source = 'url_input',
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final meta = await _meta.fetch(url);

      final thumbnailUrl = meta.thumbnailUrl.isNotEmpty
          ? (await StorageService().uploadThumbnail(uid, meta.thumbnailUrl) ??
              meta.thumbnailUrl)
          : '';

      final videoId = await _db.addVideo(
        uid,
        VideoModel(
          id: '',
          url: url,
          platform: meta.platform,
          title: meta.title.isEmpty ? url : meta.title,
          thumbnailUrl: thumbnailUrl,
          tags: tags,
          packIds: [],
          createdAt: DateTime.now(),
          isPrivate: isPrivate,
          source: source,
          viewCount: 0,
        ),
      );

      // Non-blocking audit writes — failures must not surface to the user
      _db
          .writeAuditLog(uid, 'video_added', 'video', videoId, {
            'platform': meta.platform,
            'isPrivate': isPrivate,
            'source': source,
          })
          .ignore();
      _db.incrementUserVideoCount(uid, 1).ignore();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVideo(String uid, String videoId) async {
    await _db.deleteVideo(uid, videoId);
    _db.writeAuditLog(uid, 'video_deleted', 'video', videoId).ignore();
    _db.incrementUserVideoCount(uid, -1).ignore();
  }

  Future<void> updateVideo(String uid, VideoModel video) =>
      _db.updateVideo(uid, video);

  Future<void> updateVideoTags(
          String uid, VideoModel video, List<String> tags) =>
      _db.updateVideo(uid, video.copyWith(tags: tags));

  Future<void> updateVideoNotes(
          String uid, VideoModel video, String? notes) =>
      _db.updateVideo(uid, video.copyWith(notes: notes));

  Future<void> moveToPrivate(String uid, String videoId) =>
      _db.updateVideoPrivacy(uid, videoId, true);

  Future<void> moveToPublic(String uid, String videoId) =>
      _db.updateVideoPrivacy(uid, videoId, false);

  /// Records that the user opened a video — updates viewCount + lastViewedAt.
  Future<void> recordVideoView(String uid, String videoId) async {
    _db.recordVideoView(uid, videoId).ignore();
  }

  // ── User profile ─────────────────────────────────────────────

  Future<void> saveProfile(String uid, UserProfileModel profile) =>
      _db.saveProfile(uid, profile, oldNickname: userProfile?.nickname);

  // ── Community packs ───────────────────────────────────────────

  bool isSavedCommunityPack(String communityPackId) =>
      _savedCommunityPackIds.contains(communityPackId);

  Future<String> publishPack({
    required String uid,
    required String packId,
    required String ownerName,
    required String? ownerPhotoUrl,
    required String name,
    required String description,
    required List<String> tags,
    required bool isPublic,
    required List<VideoModel> videos,
  }) async {
    final cpId = await _db.publishPack(
      uid: uid,
      packId: packId,
      ownerName: ownerName,
      ownerPhotoUrl: ownerPhotoUrl,
      name: name,
      description: description,
      tags: tags,
      isPublic: isPublic,
      videos: videos,
    );
    _db
        .writeAuditLog(uid, 'pack_published', 'community_pack', cpId,
            {'name': name, 'isPublic': isPublic})
        .ignore();
    return cpId;
  }

  Future<void> unpublishPack(
      String uid, String packId, String communityPackId) async {
    await _db.unpublishPack(uid, packId, communityPackId);
    _db
        .writeAuditLog(
            uid, 'pack_unpublished', 'community_pack', communityPackId)
        .ignore();
  }

  Future<void> saveCommunityPack(String uid, String communityPackId) =>
      _db.saveCommunityPack(uid, communityPackId);

  Future<void> unsaveCommunityPack(String uid, String communityPackId) =>
      _db.unsaveCommunityPack(uid, communityPackId);

  Future<CommunityPackModel?> findPackByCode(String code) =>
      _db.findPackByCode(code);

  Future<void> ratePack(String uid, String communityPackId, int rating) =>
      _db.rateCommunityPack(uid, communityPackId, rating);

  Future<int?> getUserRating(String uid, String communityPackId) =>
      _db.getUserRating(uid, communityPackId);

  Future<void> incrementViewCount(String communityPackId) =>
      _db.incrementViewCount(communityPackId);

  Stream<List<CommunityPackVideo>> communityPackVideos(String packId) =>
      _db.watchCommunityPackVideos(packId);

  Future<void> updatePackMeta(
    String uid,
    String packId, {
    required String description,
    required List<String> tags,
  }) =>
      _db.updatePackMeta(uid, packId, description: description, tags: tags);

  // ── Private PIN ───────────────────────────────────────────────

  Future<String?> getPrivatePinHash(String uid) =>
      _db.getPrivatePinHash(uid);

  Future<void> setPrivatePin(String uid, String pin) =>
      _db.setPrivatePinHash(uid, pin);

  bool verifyPrivatePin(String pin, String storedHash) =>
      FirestoreService.verifyPin(pin, storedHash);

  // ── Packs ─────────────────────────────────────────────────────

  Future<void> createPack(String uid, String name) async {
    await _db.createPack(uid, name);
    _db.incrementUserPackCount(uid, 1).ignore();
  }

  Future<void> renamePack(String uid, String packId, String name) =>
      _db.renamePack(uid, packId, name);

  Future<void> deletePack(String uid, String packId) async {
    await _db.deletePack(uid, packId);
    _db.writeAuditLog(uid, 'pack_deleted', 'pack', packId).ignore();
    _db.incrementUserPackCount(uid, -1).ignore();
  }

  Future<void> addVideoToPack(String uid, String packId, String videoId) =>
      _db.addVideoToPack(uid, packId, videoId);

  Future<void> removeVideoFromPack(
          String uid, String packId, String videoId) =>
      _db.removeVideoFromPack(uid, packId, videoId);

  List<VideoModel> videosInPack(PackModel pack) =>
      videos.where((v) => pack.videoIds.contains(v.id)).toList();

  // ── Internal ─────────────────────────────────────────────────

  String get _currentPlatform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    return 'unknown';
  }

  void _startListening(User user) {
    _videosSub?.cancel();
    _packsSub?.cancel();
    _publicPacksSub?.cancel();
    _savedPackIdsSub?.cancel();

    // Non-blocking — failures must not break auth flow
    _db
        .upsertUserDocument(
          user.uid,
          user.email ?? '',
          user.displayName ?? '',
          _currentPlatform,
        )
        .ignore();

    _videosSub = _db.watchVideos(user.uid).listen((v) {
      _allVideos = v;
      notifyListeners();
    });
    _packsSub = _db.watchPacks(user.uid).listen((p) {
      packs = p;
      notifyListeners();
    });
    _profileSub = _db.watchProfile(user.uid).handleError((_) {}).listen((p) {
      userProfile = p;
      notifyListeners();
    });
    _publicPacksSub =
        _db.watchPublicCommunityPacks().handleError((_) {}).listen((p) {
      publicCommunityPacks = p;
      notifyListeners();
    });
    _savedPackIdsSub =
        _db.watchSavedCommunityPackIds(user.uid).handleError((_) {}).listen(
            (ids) async {
      _savedCommunityPackIds = ids;
      final futures = ids.map((id) => _db.getCommunityPack(id));
      final results = await Future.wait(futures);
      savedCommunityPacks =
          results.whereType<CommunityPackModel>().toList();
      notifyListeners();
    });
  }

  void _clear() {
    _videosSub?.cancel();
    _packsSub?.cancel();
    _publicPacksSub?.cancel();
    _savedPackIdsSub?.cancel();
    _profileSub?.cancel();
    _allVideos = [];
    packs = [];
    publicCommunityPacks = [];
    savedCommunityPacks = [];
    _savedCommunityPackIds = [];
    userProfile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _videosSub?.cancel();
    _packsSub?.cancel();
    _publicPacksSub?.cancel();
    _savedPackIdsSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
