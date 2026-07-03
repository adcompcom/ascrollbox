import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import '../models/community_pack_model.dart';
import '../models/user_profile_model.dart';
import '../models/video_model.dart';
import '../models/pack_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Path helpers ─────────────────────────────────────────────

  /// Top-level user document — read by the admin panel.
  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _videos(String uid) =>
      _userDoc(uid).collection('videos');

  CollectionReference<Map<String, dynamic>> _packs(String uid) =>
      _userDoc(uid).collection('packs');

  DocumentReference<Map<String, dynamic>> _privateSettings(String uid) =>
      _userDoc(uid).collection('settings').doc('private');

  DocumentReference<Map<String, dynamic>> _profileDoc(String uid) =>
      _userDoc(uid).collection('settings').doc('profile');

  CollectionReference<Map<String, dynamic>> get _communityPacks =>
      _db.collection('community_packs');

  CollectionReference<Map<String, dynamic>> _cpVideos(String cpId) =>
      _communityPacks.doc(cpId).collection('videos');

  CollectionReference<Map<String, dynamic>> _cpRatings(String cpId) =>
      _communityPacks.doc(cpId).collection('ratings');

  CollectionReference<Map<String, dynamic>> _savedPacks(String uid) =>
      _userDoc(uid).collection('saved_community_packs');

  CollectionReference<Map<String, dynamic>> get _auditLogs =>
      _db.collection('audit_logs');

  // ── Admin / Audit ────────────────────────────────────────────

  /// Creates or updates the top-level users/{uid} document used by the admin
  /// panel. Safe to call on every login — uses a transaction so createdAt is
  /// only written once.
  Future<void> upsertUserDocument(
    String uid,
    String email,
    String displayName,
    String platform,
  ) async {
    final ref = _userDoc(uid);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) {
        tx.set(ref, {
          'uid': uid,
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'loginCount': 1,
          'platform': platform,
          'isActive': true,
          'isBanned': false,
          'role': 'user',
          'videoCount': 0,
          'packCount': 0,
        });
      } else {
        tx.update(ref, {
          'email': email,
          'displayName': displayName,
          'lastLoginAt': FieldValue.serverTimestamp(),
          'loginCount': FieldValue.increment(1),
          'platform': platform,
        });
      }
    });
  }

  /// Appends a row to audit_logs for admin reporting.
  ///
  /// [action]     — e.g. 'video_added', 'video_deleted', 'pack_published'
  /// [targetType] — 'video' | 'pack' | 'community_pack'
  /// [targetId]   — document ID of the affected entity
  /// [metadata]   — optional extra context (platform, title, etc.)
  Future<void> writeAuditLog(
    String uid,
    String action,
    String targetType,
    String targetId, [
    Map<String, dynamic>? metadata,
  ]) =>
      _auditLogs.add({
        'uid': uid,
        'action': action,
        'targetType': targetType,
        'targetId': targetId,
        if (metadata != null) 'metadata': metadata,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> incrementUserVideoCount(String uid, int delta) =>
      _userDoc(uid).update({'videoCount': FieldValue.increment(delta)});

  Future<void> incrementUserPackCount(String uid, int delta) =>
      _userDoc(uid).update({'packCount': FieldValue.increment(delta)});

  /// Bumps viewCount and stamps lastViewedAt on a video document.
  Future<void> recordVideoView(String uid, String videoId) =>
      _videos(uid).doc(videoId).update({
        'viewCount': FieldValue.increment(1),
        'lastViewedAt': FieldValue.serverTimestamp(),
      });

  /// Admin soft-delete: marks a community pack as deleted without removing the
  /// document, so the admin panel can audit it later.
  Future<void> softDeleteCommunityPack(String communityPackId) =>
      _communityPacks.doc(communityPackId).update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
      });

  /// Increments reportCount and flags a community pack for moderation review.
  Future<void> reportCommunityPack(String communityPackId) =>
      _communityPacks.doc(communityPackId).update({
        'reportCount': FieldValue.increment(1),
        'isFlagged': true,
      });

  // ── Videos ──────────────────────────────────────────────────

  Stream<List<VideoModel>> watchVideos(String uid) => _videos(uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(VideoModel.fromFirestore).toList());

  Future<String> addVideo(String uid, VideoModel video) async {
    final ref = await _videos(uid).add(video.toFirestore());
    return ref.id;
  }

  Future<void> updateVideo(String uid, VideoModel video) =>
      _videos(uid).doc(video.id).update({
        ...video.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> deleteVideo(String uid, String videoId) async {
    final videoSnap = await _videos(uid).doc(videoId).get();
    final packIds = List<String>.from(videoSnap.data()?['packIds'] ?? []);

    final batch = _db.batch();
    batch.delete(_videos(uid).doc(videoId));
    for (final packId in packIds) {
      batch.update(_packs(uid).doc(packId), {
        'videoIds': FieldValue.arrayRemove([videoId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();

    // Also drop the video from any community packs those packs are linked to.
    for (final packId in packIds) {
      final packSnap = await _packs(uid).doc(packId).get();
      final communityPackId = packSnap.data()?['communityPackId'] as String?;
      if (communityPackId != null) {
        await _cpVideos(communityPackId).doc(videoId).delete();
      }
    }
  }

  Future<void> updateVideoPrivacy(
          String uid, String videoId, bool isPrivate) =>
      _videos(uid).doc(videoId).update({
        'isPrivate': isPrivate,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── Packs (private) ──────────────────────────────────────────

  Stream<List<PackModel>> watchPacks(String uid) => _packs(uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(PackModel.fromFirestore).toList());

  Future<String> createPack(String uid, String name) async {
    final now = Timestamp.now();
    final ref = await _packs(uid).add({
      'name': name,
      'description': '',
      'tags': <String>[],
      'videoIds': <String>[],
      'createdAt': now,
      'updatedAt': now,
    });
    return ref.id;
  }

  Future<void> renamePack(String uid, String packId, String newName) =>
      _packs(uid).doc(packId).update({
        'name': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> updatePackMeta(
    String uid,
    String packId, {
    required String description,
    required List<String> tags,
  }) =>
      _packs(uid).doc(packId).update({
        'description': description,
        'tags': tags,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> deletePack(String uid, String packId) async {
    final snap = await _packs(uid).doc(packId).get();
    final data = snap.data();
    final videoIds = List<String>.from(data?['videoIds'] ?? []);
    final communityPackId = data?['communityPackId'] as String?;

    final batch = _db.batch();
    for (final vid in videoIds) {
      batch.update(_videos(uid).doc(vid), {
        'packIds': FieldValue.arrayRemove([packId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    batch.delete(_packs(uid).doc(packId));
    await batch.commit();

    if (communityPackId != null) {
      await _deleteCommunityPack(communityPackId);
    }
  }

  Future<void> addVideoToPack(
      String uid, String packId, String videoId) async {
    final packSnap = await _packs(uid).doc(packId).get();
    final communityPackId = packSnap.data()?['communityPackId'] as String?;

    await Future.wait([
      _packs(uid).doc(packId).update({
        'videoIds': FieldValue.arrayUnion([videoId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      _videos(uid).doc(videoId).update({
        'packIds': FieldValue.arrayUnion([packId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
    ]);

    if (communityPackId != null) {
      final videoSnap = await _videos(uid).doc(videoId).get();
      if (videoSnap.exists) {
        final v = VideoModel.fromFirestore(videoSnap);
        await _cpVideos(communityPackId).doc(videoId).set(
              CommunityPackVideo(
                id: v.id,
                url: v.url,
                platform: v.platform,
                title: v.title,
                thumbnailUrl: v.thumbnailUrl,
              ).toFirestore(),
            );
      }
    }
  }

  Future<void> removeVideoFromPack(
      String uid, String packId, String videoId) async {
    final packSnap = await _packs(uid).doc(packId).get();
    final communityPackId = packSnap.data()?['communityPackId'] as String?;

    await Future.wait([
      _packs(uid).doc(packId).update({
        'videoIds': FieldValue.arrayRemove([videoId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      _videos(uid).doc(videoId).update({
        'packIds': FieldValue.arrayRemove([packId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
    ]);

    if (communityPackId != null) {
      await _cpVideos(communityPackId).doc(videoId).delete();
    }
  }

  // ── Community packs ───────────────────────────────────────────

  static String generateShareCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random.secure();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

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
    final code = generateShareCode();
    final now = Timestamp.now();

    final cpRef = _communityPacks.doc();
    final batch = _db.batch();

    batch.set(cpRef, {
      'ownerId': uid,
      'ownerName': ownerName,
      if (ownerPhotoUrl != null) 'ownerPhotoUrl': ownerPhotoUrl,
      'name': name,
      'description': description,
      'tags': tags,
      'isPublic': isPublic,
      'shareCode': code,
      'viewCount': 0,
      'shareCount': 0,
      'ratingSum': 0,
      'ratingCount': 0,
      'createdAt': now,
      'updatedAt': now,
      // moderation
      'isDeleted': false,
      'reportCount': 0,
      'isFlagged': false,
      'moderationStatus': 'pending',
    });

    batch.update(_packs(uid).doc(packId), {
      'communityPackId': cpRef.id,
      'description': description,
      'tags': tags,
      'updatedAt': now,
    });

    await batch.commit();

    final videosBatch = _db.batch();
    for (final v in videos) {
      videosBatch.set(
        _cpVideos(cpRef.id).doc(v.id),
        CommunityPackVideo(
          id: v.id,
          url: v.url,
          platform: v.platform,
          title: v.title,
          thumbnailUrl: v.thumbnailUrl,
        ).toFirestore(),
      );
    }
    await videosBatch.commit();

    return cpRef.id;
  }

  Future<void> unpublishPack(String uid, String packId,
      String communityPackId) async {
    await Future.wait([
      _packs(uid).doc(packId).update({
        'communityPackId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      _deleteCommunityPack(communityPackId),
    ]);
  }

  Future<void> _deleteCommunityPack(String communityPackId) async {
    final vSnap = await _cpVideos(communityPackId).get();
    final batch = _db.batch();
    for (final doc in vSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_communityPacks.doc(communityPackId));
    await batch.commit();
  }

  Stream<List<CommunityPackModel>> watchPublicCommunityPacks() =>
      _communityPacks
          .where('isPublic', isEqualTo: true)
          .snapshots()
          .map((s) {
            final packs = s.docs
                .map(CommunityPackModel.fromFirestore)
                .where((p) => !p.isDeleted)
                .toList();
            packs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return packs;
          });

  Stream<List<CommunityPackVideo>> watchCommunityPackVideos(
          String communityPackId) =>
      _cpVideos(communityPackId)
          .snapshots()
          .map((s) => s.docs.map(CommunityPackVideo.fromFirestore).toList());

  Future<CommunityPackModel?> findPackByCode(String code) async {
    final snap = await _communityPacks
        .where('shareCode', isEqualTo: code.toUpperCase())
        .where('isDeleted', isEqualTo: false)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return CommunityPackModel.fromFirestore(snap.docs.first);
  }

  Future<void> incrementViewCount(String communityPackId) =>
      _communityPacks
          .doc(communityPackId)
          .update({'viewCount': FieldValue.increment(1)});

  // ── Saved community packs ─────────────────────────────────────

  Stream<List<String>> watchSavedCommunityPackIds(String uid) =>
      _savedPacks(uid).snapshots().map((s) => s.docs.map((d) => d.id).toList());

  Future<void> saveCommunityPack(String uid, String communityPackId) async {
    await Future.wait([
      _savedPacks(uid)
          .doc(communityPackId)
          .set({'savedAt': FieldValue.serverTimestamp()}),
      _communityPacks
          .doc(communityPackId)
          .update({'shareCount': FieldValue.increment(1)}),
    ]);
  }

  Future<void> unsaveCommunityPack(String uid, String communityPackId) async {
    await Future.wait([
      _savedPacks(uid).doc(communityPackId).delete(),
      _communityPacks
          .doc(communityPackId)
          .update({'shareCount': FieldValue.increment(-1)}),
    ]);
  }

  Future<CommunityPackModel?> getCommunityPack(String communityPackId) async {
    final doc = await _communityPacks.doc(communityPackId).get();
    if (!doc.exists) return null;
    return CommunityPackModel.fromFirestore(doc);
  }

  // ── Ratings ───────────────────────────────────────────────────

  Future<int?> getUserRating(String uid, String communityPackId) async {
    final doc = await _cpRatings(communityPackId).doc(uid).get();
    return doc.exists ? (doc.data()?['rating'] as num?)?.toInt() : null;
  }

  Future<void> rateCommunityPack(
      String uid, String communityPackId, int rating) async {
    final existing = await getUserRating(uid, communityPackId);
    await _db.runTransaction((tx) async {
      final cpRef = _communityPacks.doc(communityPackId);
      final ratingRef = _cpRatings(communityPackId).doc(uid);

      if (existing == null) {
        tx.update(cpRef, {
          'ratingSum': FieldValue.increment(rating),
          'ratingCount': FieldValue.increment(1),
        });
      } else {
        tx.update(cpRef, {
          'ratingSum': FieldValue.increment(rating - existing),
        });
      }
      tx.set(ratingRef,
          {'rating': rating, 'ratedAt': FieldValue.serverTimestamp()});
    });
  }

  // ── Private PIN ──────────────────────────────────────────────

  Future<String?> getPrivatePinHash(String uid) async {
    final doc = await _privateSettings(uid).get();
    return doc.exists ? (doc.data()?['pinHash'] as String?) : null;
  }

  Future<void> setPrivatePinHash(String uid, String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await _privateSettings(uid).set({'pinHash': hash}, SetOptions(merge: true));
  }

  Future<void> resetPinHash(String uid, String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await _privateSettings(uid).update({'pinHash': hash});
  }

  static bool verifyPin(String pin, String storedHash) {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    return hash == storedHash;
  }

  // ── Security questions ────────────────────────────────────────

  Future<void> saveSecurityQuestions(
    String uid,
    List<Map<String, String>> questions,
  ) async {
    await _privateSettings(uid)
        .set({'securityQuestions': questions}, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>?> getSecurityQuestions(String uid) async {
    final doc = await _privateSettings(uid).get();
    if (!doc.exists) return null;
    final raw = doc.data()?['securityQuestions'];
    if (raw == null) return null;
    return List<Map<String, dynamic>>.from(raw as List);
  }

  static String hashAnswer(String answer) =>
      sha256.convert(utf8.encode(answer.trim().toLowerCase())).toString();

  static bool verifyAnswer(String answer, String storedHash) =>
      hashAnswer(answer) == storedHash;

  // ── User profile ─────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _nicknames =>
      _db.collection('nicknames');

  Stream<UserProfileModel?> watchProfile(String uid) =>
      _profileDoc(uid).snapshots().map((doc) =>
          doc.exists ? UserProfileModel.fromFirestore(doc) : null);

  /// Saves the profile and atomically claims the new nickname.
  /// Throws 'nickname_taken' if the nickname is already used by another user.
  Future<void> saveProfile(
    String uid,
    UserProfileModel profile, {
    String? oldNickname,
  }) async {
    final newNick = profile.nickname.trim().toLowerCase();
    final oldNick = oldNickname?.trim().toLowerCase();

    if (newNick.isNotEmpty && newNick != oldNick) {
      await _db.runTransaction((tx) async {
        final nicknameRef = _nicknames.doc(newNick);
        final snap = await tx.get(nicknameRef);
        if (snap.exists && snap.data()?['uid'] != uid) {
          throw Exception('nickname_taken');
        }
        if (oldNick != null && oldNick.isNotEmpty && oldNick != newNick) {
          tx.delete(_nicknames.doc(oldNick));
        }
        tx.set(nicknameRef, {'uid': uid});
      });
    } else if (newNick.isEmpty && oldNick != null && oldNick.isNotEmpty) {
      await _nicknames.doc(oldNick).delete();
    }

    await _profileDoc(uid).set(profile.toFirestore(), SetOptions(merge: true));
  }
}
