import 'package:cloud_firestore/cloud_firestore.dart';

/// Stored at users/{uid} — top-level doc consumed by the future admin panel.
class UserDocumentModel {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final int loginCount;
  final String platform;
  final bool isActive;
  final bool isBanned;
  final String role; // 'user' | 'admin' | 'moderator'
  final int videoCount;
  final int packCount;

  const UserDocumentModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.lastLoginAt,
    required this.loginCount,
    required this.platform,
    this.isActive = true,
    this.isBanned = false,
    this.role = 'user',
    this.videoCount = 0,
    this.packCount = 0,
  });

  factory UserDocumentModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return UserDocumentModel(
      uid: d['uid'] as String? ?? doc.id,
      email: d['email'] as String? ?? '',
      displayName: d['displayName'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt:
          (d['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      loginCount: (d['loginCount'] as num?)?.toInt() ?? 0,
      platform: d['platform'] as String? ?? 'unknown',
      isActive: d['isActive'] as bool? ?? true,
      isBanned: d['isBanned'] as bool? ?? false,
      role: d['role'] as String? ?? 'user',
      videoCount: (d['videoCount'] as num?)?.toInt() ?? 0,
      packCount: (d['packCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'createdAt': Timestamp.fromDate(createdAt),
        'lastLoginAt': Timestamp.fromDate(lastLoginAt),
        'loginCount': loginCount,
        'platform': platform,
        'isActive': isActive,
        'isBanned': isBanned,
        'role': role,
        'videoCount': videoCount,
        'packCount': packCount,
      };
}
