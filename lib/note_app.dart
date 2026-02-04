import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/features/notes/viewmodel/note_viewmodel.dart';
import 'presentation/pages/note_home_page.dart';
import 'domain/interface/repositories/i_storage_repository.dart';
import 'domain/interface/repositories/i_note_repository.dart';
import 'infrastructure/services/image_service.dart';


class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteViewModel(
        context.read<INoteRepository>(), 
        context.read<IStorageRepository>(),
        context.read<ImageService>(), 
      ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NoteHomePage(),
      ),
    );
  }
}