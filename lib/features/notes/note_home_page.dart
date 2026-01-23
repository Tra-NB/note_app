import 'package:flutter/material.dart';
import 'package:note_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import 'viewmodel/note_viewmodel.dart';
import 'widgets/note_card.dart';
import 'widgets/note_search_bar.dart';
import 'widgets/note_filter_chip.dart';
import 'widgets/note_bottom_item.dart';
import '../notes/widgets/note_app_bar.dart';
import 'note_editor_page.dart';

class NoteHomePage extends StatelessWidget {
  const NoteHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NoteAppBar(),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // SEARCH
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NoteSearchBar(),
          ),

          const SizedBox(height: 16),

          // FILTER
          SizedBox(
            height: 38,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: const [
                NoteFilterChip(label: 'All', selected: true),
                NoteFilterChip(label: 'Work'),
                NoteFilterChip(label: 'Ideas'),
                NoteFilterChip(label: 'Personal'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // GRID NOTE
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder(
                stream: vm.notes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final notes = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: notes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.70,
                    ),
                    itemBuilder: (_, i) => NoteCard(
                      note: notes[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NoteEditorPage(note: notes[i]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteEditorPage(),
            ),
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomAppBar(
        color: AppColors.item,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              NoteBottomItem(icon: Icons.home, label: 'Home', active: true),
              NoteBottomItem(icon: Icons.folder, label: 'Folders'),
              NoteBottomItem(icon: Icons.star_border, label: 'Favorites'),
              NoteBottomItem(icon: Icons.settings, label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
