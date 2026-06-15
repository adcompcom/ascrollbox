import 'package:cloud_firestore/cloud_firestore.dart';

class PackModel {
  final String id;
  final String name;
  final List<String> videoIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  PackModel({
    required this.id,
    required this.name,
    required this.videoIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackModel(
      id: doc.id,
      name: data['name'] ?? '',
      videoIds: List<String>.from(data['videoIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'videoIds': videoIds,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  PackModel copyWith({
    String? id,
    String? name,
    List<String>? videoIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PackModel(
        id: id ?? this.id,
        name: name ?? this.name,
        videoIds: videoIds ?? this.videoIds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
