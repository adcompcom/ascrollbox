import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPackModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String? ownerPhotoUrl;
  final String name;
  final String description;
  final List<String> tags;
  final bool isPublic;
  final String shareCode;
  final int viewCount;
  final int shareCount;
  final int ratingSum;
  final int ratingCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommunityPackModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    this.ownerPhotoUrl,
    required this.name,
    required this.description,
    required this.tags,
    required this.isPublic,
    required this.shareCode,
    required this.viewCount,
    required this.shareCount,
    required this.ratingSum,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
  });

  double get ratingAvg =>
      ratingCount == 0 ? 0.0 : ratingSum / ratingCount;

  factory CommunityPackModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CommunityPackModel(
      id: doc.id,
      ownerId: d['ownerId'] ?? '',
      ownerName: d['ownerName'] ?? '',
      ownerPhotoUrl: d['ownerPhotoUrl'],
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      tags: List<String>.from(d['tags'] ?? []),
      isPublic: d['isPublic'] as bool? ?? true,
      shareCode: d['shareCode'] ?? '',
      viewCount: (d['viewCount'] as num?)?.toInt() ?? 0,
      shareCount: (d['shareCount'] as num?)?.toInt() ?? 0,
      ratingSum: (d['ratingSum'] as num?)?.toInt() ?? 0,
      ratingCount: (d['ratingCount'] as num?)?.toInt() ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'ownerId': ownerId,
        'ownerName': ownerName,
        if (ownerPhotoUrl != null) 'ownerPhotoUrl': ownerPhotoUrl,
        'name': name,
        'description': description,
        'tags': tags,
        'isPublic': isPublic,
        'shareCode': shareCode,
        'viewCount': viewCount,
        'shareCount': shareCount,
        'ratingSum': ratingSum,
        'ratingCount': ratingCount,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };
}

class CommunityPackVideo {
  final String id;
  final String url;
  final String platform;
  final String title;
  final String thumbnailUrl;

  CommunityPackVideo({
    required this.id,
    required this.url,
    required this.platform,
    required this.title,
    required this.thumbnailUrl,
  });

  factory CommunityPackVideo.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CommunityPackVideo(
      id: doc.id,
      url: d['url'] ?? '',
      platform: d['platform'] ?? 'other',
      title: d['title'] ?? '',
      thumbnailUrl: d['thumbnailUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'url': url,
        'platform': platform,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
      };
}
