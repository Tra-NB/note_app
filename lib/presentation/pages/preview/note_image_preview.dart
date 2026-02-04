import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/presentation/pages/full_screen_image_page.dart';

class NoteImagePreview extends StatelessWidget {
  final XFile? selectedImage;
  final String? existingUrl;

  const NoteImagePreview({
    super.key,
    this.selectedImage,
    this.existingUrl,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    String tag = '';
    if (selectedImage != null) {
      tag = selectedImage!.path; 
      if (kIsWeb) {
        imageProvider = NetworkImage(selectedImage!.path);
      } else {
        imageProvider = FileImage(File(selectedImage!.path));
      }
    } 
    
    else if (existingUrl != null) {
      tag = existingUrl!;
      imageProvider = NetworkImage(existingUrl!);
    }

   
    if (imageProvider == null) return const SizedBox();

    return GestureDetector(
      onDoubleTap: () {
       
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImagePage(
              imageProvider: imageProvider!,
              heroTag: tag,
            ),
          ),
        );
      },
      child: Hero(
        tag: tag, 
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
             if (loadingProgress == null) return child;
             return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      ),
    );
  }
}