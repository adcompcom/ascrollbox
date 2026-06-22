import 'package:cloud_firestore/cloud_firestore.dart';

class PackModel {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final List<String> videoIds;
  final String? communityPackId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PackModel({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.videoIds,
    this.communityPackId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPublished => communityPackId != null;

  factory PackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      videoIds: List<String>.from(data['videoIds'] ?? []),
      communityPackId: data['communityPackId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'tags': tags,
        'videoIds': videoIds,
        if (communityPackId != null) 'communityPackId': communityPackId,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  PackModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    List<String>? videoIds,
    Object? communityPackId = _sentinel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PackModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        videoIds: videoIds ?? this.videoIds,
        communityPackId: communityPackId == _sentinel
            ? this.communityPackId
            : communityPackId as String?,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

const _sentinel = Object();
