import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import theo cấu trúc Clean Architecture mới
import '../../../application/features/notes/viewmodel/note_viewmodel.dart';
import '../theme/app_colors.dart';
import '../../../domain/entities/note.dart';

// Import các widgets nội bộ
import '../widgets/note_card.dart';
import '../widgets/note_search_bar.dart';
import '../widgets/note_filter_chip.dart';
import '../widgets/note_bottom_item.dart';
import '../widgets/note_app_bar.dart';
import 'note_editor_page.dart';

class NoteHomePage extends StatelessWidget {
  const NoteHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng context.watch để lắng nghe thay đổi từ ViewModel
    final vm = context.watch<NoteViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NoteAppBar(), // Thêm const nếu NoteAppBar hỗ trợ

      body: Column(
        children: [
          const SizedBox(height: 12),

          // SEARCH - Tách biệt UI và Logic
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NoteSearchBar(),
          ),

          const SizedBox(height: 16),

          // FILTER - Nhìn tên là hiểu mục đích
          _buildFilterSection(),

          const SizedBox(height: 20),

          // GRID NOTE - Sử dụng Stream từ Repository thông qua ViewModel
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<List<Note>>(
                stream: vm.notes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No notes yet."));
                  }

                  final notes = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: notes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.70,
                    ),
                    itemBuilder: (_, i) => NoteCard(
                      note: notes[i],
                      onTap: () => _navigateToEditor(context, notes[i]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: _buildAddButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Các hàm helper giúp build UI sạch sẽ hơn
  Widget _buildFilterSection() {
    return SizedBox(
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
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: const Icon(Icons.add, size: 30, color: Colors.white),
      onPressed: () => _navigateToEditor(context),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
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
    );
  }

  void _navigateToEditor(BuildContext context, [Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteEditorPage(note: note)),
    );
  }
}