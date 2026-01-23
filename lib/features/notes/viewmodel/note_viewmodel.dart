
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/note_model.dart';
import '../../../core/services/note_service.dart';
import '../../../core/utils/image_helper.dart';
import '../repository/note_repository.dart';
import '../../../core/error/failures.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteService _service = NoteService();
  final NoteRepository _repository = NoteRepository();
  final ImageHelper _imageHelper = ImageHelper();

  bool isLoading = false;  
  String? errorMessage;      
  String? currentImageUrl;

  Stream<List<Note>> get notes => _service.getNotes();

  Future<void> add(String title, String content, {String? imageUrl}) async {
    await _service.addNote(title, content, imageUrl: imageUrl);
  }

  Future<void> update(Note note) async {
    await _service.updateNote(note);
  }

  Future<void> delete(String id) async {
    await _service.deleteNote(id);
  }

  
  Future<void> uploadImage(XFile imageFile) async {
    isLoading = true;
    notifyListeners(); 

    
    final String? url = await _imageHelper.uploadToCloudinary(imageFile);

    if (url != null) {
      currentImageUrl = url;
      print("Upload thành công: $currentImageUrl");
    } else {
      print("Upload thất bại");
    }

    isLoading = false;
    notifyListeners(); 
  }
}