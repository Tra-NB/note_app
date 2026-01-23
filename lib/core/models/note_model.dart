import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String? imageUrl;
  final String title;
  final String content;
  final Timestamp createAt;
  final Timestamp updateAt;

  Note({
    required this.id,
    this.imageUrl,
    required this.title,
    required this.content,
    required this.createAt,
    required this.updateAt,
  });

  Note copyWith({
    String? imageUrl,
    String? title,
    String? content,
    Timestamp? updateAt,
  }) {
    return Note(
      id: id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      createAt: createAt,
      updateAt: updateAt ?? Timestamp.now(),
    );
  }

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      imageUrl: data['imageUrl'],
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createAt: data['createAt'] ?? Timestamp.now(),
      updateAt: data['updateAt'] ?? Timestamp.now(),
    );
  }
}
