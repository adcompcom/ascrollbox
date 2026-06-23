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

  CollectionReference<Map<String, dynamic>> _videos(String uid) =>
      _db.collection('users').doc(uid).collection('videos');

  CollectionReference<Map<String, dynamic>> _packs(String uid) =>
      _db.collection('users').doc(uid).collection('packs');

  DocumentReference<Map<String, dynamic>> _privateSettings(String uid) =>
      _db.collection('users').doc(uid).collection('settings').doc('private');

  DocumentReference<Map<String, dynamic>> _profileDoc(String uid) =>
      _db.collection('users').doc(uid).collection('settings').doc('profile');

  CollectionReference<Map<String, dynamic>> get _communityPacks =>
      _db.collection('community_packs');

  CollectionReference<Map<String, dynamic>> _cpVideos(String cpId) =>
      _communityPacks.doc(cpId).collection('videos');

  CollectionReference<Map<String, dynamic>> _cpRatings(String cpId) =>
      _communityPacks.doc(cpId).collection('ratings');

  CollectionReference<Map<String, dynamic>> _savedPacks(String uid) =>
      _db.collection('users').doc(uid).collection('saved_community_packs');

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
      _videos(uid).doc(video.id).update(video.toFirestore());

  Future<void> deleteVideo(String uid, String videoId) =>
      _videos(uid).doc(videoId).delete();

  Future<void> updateVideoPrivacy(String uid, String videoId, bool isPrivate) =>
      _videos(uid).doc(videoId).update({'isPrivate': isPrivate});

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
      });
    }
    batch.delete(_packs(uid).doc(packId));
    await batch.commit();

    // Also remove from community if published
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
      }),
    ]);

    // Sync to community pack if published
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
    });

    // Link back to user's pack
    batch.update(_packs(uid).doc(packId), {
      'communityPackId': cpRef.id,
      'description': description,
      'tags': tags,
      'updatedAt': now,
    });

    await batch.commit();

    // Write video subcollection
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
    // Delete videos subcollection first
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
            final packs = s.docs.map(CommunityPackModel.fromFirestore).toList();
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
      tx.set(ratingRef, {'rating': rating, 'ratedAt': FieldValue.serverTimestamp()});
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
      // Atomic check-and-claim inside a transaction
      await _db.runTransaction((tx) async {
        final nicknameRef = _nicknames.doc(newNick);
        final snap = await tx.get(nicknameRef);
        if (snap.exists && snap.data()?['uid'] != uid) {
          throw Exception('nickname_taken');
        }
        // Release old nickname
        if (oldNick != null && oldNick.isNotEmpty && oldNick != newNick) {
          tx.delete(_nicknames.doc(oldNick));
        }
        // Claim new nickname
        tx.set(nicknameRef, {'uid': uid});
      });
    } else if (newNick.isEmpty && oldNick != null && oldNick.isNotEmpty) {
      // User cleared their nickname — release it
      await _nicknames.doc(oldNick).delete();
    }

    await _profileDoc(uid).set(profile.toFirestore(), SetOptions(merge: true));
  }
}
