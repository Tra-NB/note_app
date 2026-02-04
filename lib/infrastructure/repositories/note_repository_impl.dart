import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';
import '../../domain/interface/repositories/i_note_repository.dart';

class NoteRepositoryImpl implements INoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notes';

  @override
  Stream<List<Note>> getNotesAsync() {
    return _firestore
        .collection(_collection)
        .orderBy('createAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
        });
  }

  @override
  Future<void> addAsync(Note note) async {
    await _firestore.collection(_collection).add(note.toFirestore());
  }

  @override
  Future<void> updateAsync(Note note) async {
    await _firestore
        .collection(_collection)
        .doc(note.id)
        .update(note.toFirestore());
  }

  @override
  Future<void> deleteAsync(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}