import '../../entities/note.dart';

abstract class INoteRepository {
  Stream<List<Note>> getNotesAsync();
  Future<void> addAsync(Note note);
  Future<void> updateAsync(Note note);
  Future<void> deleteAsync(String id);
}