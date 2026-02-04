
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'note_app.dart';

import 'package:note_app/domain/interface/repositories/i_storage_repository.dart';
import 'package:note_app/domain/interface/repositories/i_note_repository.dart';

import 'package:note_app/infrastructure/repositories/note_repository_impl.dart'; 
import 'package:note_app/infrastructure/repositories/cloudinary_storage_repository.dart'; 

import 'package:note_app/infrastructure/services/image_service.dart';

import 'package:note_app/application/features/notes/viewmodel/note_viewmodel.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Future.wait([
    dotenv.load(fileName: ".env"),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<IStorageRepository>(
          create: (_) => CloudinaryStorageRepository(), 
        ),

        Provider<ImageService>(create: (_) => ImageService()),
        
        Provider<INoteRepository>(create: (_) => NoteRepositoryImpl()),

        ChangeNotifierProvider<NoteViewModel>(
          create: (context) => NoteViewModel(
            context.read<INoteRepository>(),
            context.read<IStorageRepository>(),
            context.read<ImageService>(),
          ),
        ),
      ],
      child: const NoteApp(),
    ),
  );
}