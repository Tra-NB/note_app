import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/notes/viewmodel/note_viewmodel.dart';
import 'features/notes/note_home_page.dart';

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const NoteHomePage(),
      ),
    );
  }
}
