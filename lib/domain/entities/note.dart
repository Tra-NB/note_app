import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createAt;
  final DateTime updateAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createAt,
    required this.updateAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createAt': Timestamp.fromDate(createAt),
      'updateAt': Timestamp.fromDate(updateAt),
    };
  }

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      createAt: (data['createAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp).toDate(),
    );
  }
}