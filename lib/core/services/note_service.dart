import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteService {
  final _ref = FirebaseFirestore.instance.collection('notes');


  Future<void> addNote(String title, String content, {String? imageUrl}) async {
    await _ref.add({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createAt': Timestamp.now(),
      'updateAt': Timestamp.now(),
    });
  }


  Stream<List<Note>> getNotes() {
    return _ref
        .orderBy('updateAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => Note.fromFirestore(e)).toList(),
        );
  }


  Future<void> updateNote(Note note) async {
    await _ref.doc(note.id).update({
      'title': note.title,
      'content': note.content,
      'imageUrl': note.imageUrl,
      'updateAt': Timestamp.now(),
    });
  }


  Future<void> deleteNote(String id) async {
    await _ref.doc(id).delete();
  }
}
