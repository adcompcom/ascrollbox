import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_model.dart';
import '../models/pack_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _videos(String uid) =>
      _db.collection('users').doc(uid).collection('videos');

  CollectionReference<Map<String, dynamic>> _packs(String uid) =>
      _db.collection('users').doc(uid).collection('packs');

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

  // ── Packs ────────────────────────────────────────────────────

  Stream<List<PackModel>> watchPacks(String uid) => _packs(uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(PackModel.fromFirestore).toList());

  Future<String> createPack(String uid, String name) async {
    final now = Timestamp.now();
    final ref = await _packs(uid).add({
      'name': name,
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

  Future<void> deletePack(String uid, String packId) async {
    final snap = await _packs(uid).doc(packId).get();
    final videoIds = List<String>.from(snap.data()?['videoIds'] ?? []);
    final batch = _db.batch();
    for (final vid in videoIds) {
      batch.update(_videos(uid).doc(vid), {
        'packIds': FieldValue.arrayRemove([packId]),
      });
    }
    batch.delete(_packs(uid).doc(packId));
    await batch.commit();
  }

  Future<void> addVideoToPack(
      String uid, String packId, String videoId) async {
    await Future.wait([
      _packs(uid).doc(packId).update({
        'videoIds': FieldValue.arrayUnion([videoId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      _videos(uid).doc(videoId).update({
        'packIds': FieldValue.arrayUnion([packId]),
      }),
    ]);
  }

  Future<void> removeVideoFromPack(
      String uid, String packId, String videoId) async {
    await Future.wait([
      _packs(uid).doc(packId).update({
        'videoIds': FieldValue.arrayRemove([videoId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      _videos(uid).doc(videoId).update({
        'packIds': FieldValue.arrayRemove([packId]),
      }),
    ]);
  }
}
