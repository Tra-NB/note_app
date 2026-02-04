import 'package:flutter/material.dart';
import 'package:note_app/presentation/theme/app_colors.dart';
import 'package:note_app/presentation/widgets/message.dart';
import 'package:note_app/shared/utils/confirm_dialog.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/application/features/notes/viewmodel/note_viewmodel.dart';

class NoteEditorHeader extends StatelessWidget {
  final NoteViewModel viewModel;
  final Note? note;
  final TextEditingController titleController;
  final TextEditingController contentController;

  const NoteEditorHeader({
    super.key,
    required this.viewModel,
    required this.note,
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Nút Back
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        
        if (note != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              bool confirm = await showConfirmDialog(
                context: context,
                title: 'Xóa ghi chú',
                content: 'Hành động này không thể hoàn tác.',
              );

              if (confirm && context.mounted) {
                await viewModel.deleteNoteAsync(note!.id);
                
                if (!context.mounted) return;
                ToastMessage.showSuccess("Đã xóa thành công");
                Navigator.pop(context);
              }
            },
          ),
        
        // 3. Nút Sav
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primarySoft,
            foregroundColor: AppColors.primary,
            elevation: 0,
          ),
          icon: viewModel.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check),
          label: const Text('Save'),
          
          onPressed: viewModel.isLoading
              ? null
              : () async {
                  if (titleController.text.isEmpty && contentController.text.isEmpty) {
                    ToastMessage.showError("Vui lòng nhập nội dung");
                    return;
                  }

                  try {
                    if (note == null) {
                      await viewModel.addNoteAsync(
                        titleController.text,
                        contentController.text,
                      );
                    } else {
                      await viewModel.updateNoteAsync(
                        note!.id,
                        titleController.text,
                        contentController.text,
                        oldImageUrl: note?.imageUrl,
                      );
                    }

                    if (!context.mounted) return;
                    Navigator.pop(context); 
                  } catch (e) {
                    ToastMessage.showError("Lỗi lưu ghi chú: $e");
                  }
                },
        )
      ],
    );
  }
}