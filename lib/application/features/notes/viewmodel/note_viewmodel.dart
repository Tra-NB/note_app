import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/entities/note.dart';
import '../../../../domain/interface/repositories/i_note_repository.dart';
import '../../../../domain/interface/repositories/i_storage_repository.dart';

import '../../../../infrastructure/services/image_service.dart';

class NoteViewModel extends ChangeNotifier {
  final INoteRepository _noteRepository;
  final IStorageRepository _storageRepository;
  final ImageService _imageService;

  NoteViewModel(this._noteRepository, this._storageRepository, this._imageService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  Stream<List<Note>> get notes => _noteRepository.getNotesAsync();

  void selectImage(XFile image) {
    _selectedImage = image;
    notifyListeners();
  }

  void removeSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addNoteAsync(String title, String content) async {
    _setLoading(true);
    try {
      String? imageUrl;

      if (selectedImage != null) {
        
        XFile compressedFile = await _imageService.compressImage(selectedImage!);
        
        imageUrl = await _storageRepository.uploadImageAsync(compressedFile);
      }
      
      final newNote = Note(
        id: '',
        title: title,
        content: content,
        imageUrl: imageUrl, 
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
      );

      await _noteRepository.addAsync(newNote);
      
      _selectedImage = null; 
    } catch (e) {
      print("Lỗi thêm note: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateNoteAsync(String id, String title, String content, {String? oldImageUrl}) async {
    _setLoading(true);
    try {
      String? finalImageUrl = oldImageUrl;

      if (_selectedImage != null) {
        finalImageUrl = await _storageRepository.uploadImageAsync(_selectedImage!);
      }

      final updatedNote = Note(
        id: id,
        title: title,
        content: content,
        imageUrl: finalImageUrl,
        createAt: DateTime.now(), 
        updateAt: DateTime.now(),
      );
      
      await _noteRepository.updateAsync(updatedNote);
      _selectedImage = null; // Reset
    } catch (e) {
      print("Lỗi update: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteNoteAsync(String id) async {
    await _noteRepository.deleteAsync(id);
  }
}