import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String nickname;
  final String? photoUrl;

  const UserProfileModel({required this.nickname, this.photoUrl});

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      nickname: d['nickname'] as String? ?? '',
      photoUrl: d['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'nickname': nickname,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}
