import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:note_app/presentation/theme/app_theme.dart';
import 'package:note_app/presentation/theme/app_colors.dart';

import 'package:note_app/presentation/widgets/message.dart';
import 'package:note_app/presentation/widgets/note_toolbar.dart';
import 'package:note_app/presentation/widgets/note_editor_header.dart';

import 'package:note_app/presentation/pages/preview/note_image_preview.dart'; 

import 'package:note_app/shared/utils/format_timestamp.dart';
import 'package:note_app/shared/utils/confirm_dialog.dart';

import 'package:note_app/domain/entities/note.dart';

import 'package:note_app/application/features/notes/viewmodel/note_viewmodel.dart';


class NoteEditorPage extends StatefulWidget {
  final Note? note;
  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController titleCtrl;
  late TextEditingController contentCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    contentCtrl = TextEditingController(text: widget.note?.content ?? '');

    // Reset trạng thái ảnh khi vừa mở trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NoteViewModel>().removeSelectedImage();
      }
    });
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
              
                NoteEditorHeader(
                  viewModel: vm,
                  note: widget.note,
                  titleController: titleCtrl,
                  contentController: contentCtrl,
                ),

                const SizedBox(height: 12),

                
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.note == null
                        ? 'NEW NOTE'
                        : "Sửa lần cuối: ${formatTimestamp(widget.note!.updateAt)}",
                    style: AppTheme.myTextTheme.bodySmall,
                  ),
                ),

                const SizedBox(height: 16),

                if (vm.selectedImage != null || widget.note?.imageUrl != null)
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                        
                          child: NoteImagePreview(
                            selectedImage: vm.selectedImage,
                            existingUrl: widget.note?.imageUrl,
                          ),
                        ),
                      ),
                      
                    
                      if (vm.selectedImage != null)
                        Positioned(
                          top: 15,
                          right: 5,
                          child: GestureDetector(
                            onTap: () => vm.removeSelectedImage(),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              radius: 14,
                              child: const Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),

                    
                      if (vm.isLoading)
                        const Positioned.fill(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),

              
                TextField(
                  controller: titleCtrl,
                  style: AppTheme.myTextTheme.displayLarge,
                  decoration: const InputDecoration(
                    hintText: 'Tiêu đề...',
                    border: InputBorder.none,
                  ),
                ),

               
                Expanded(
                  child: TextField(
                    controller: contentCtrl,
                    maxLines: null,
                    style: AppTheme.myTextTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Nội dung ghi chú...',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

             
                NoteToolbar(
                  onImageSelect: (XFile file) {
                    vm.selectImage(file);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context, NoteViewModel vm) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        
        if (widget.note != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              bool confirm = await showConfirmDialog(
                context: context,
                title: 'Xóa ghi chú',
                content: 'Hành động này không thể hoàn tác.',
              );

              if (confirm && mounted) {
                await vm.deleteNoteAsync(widget.note!.id);
                if (!mounted) return;
                ToastMessage.showSuccess("Đã xóa thành công");
                Navigator.pop(context);
              }
            },
          ),
        
        // Nút Save
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primarySoft,
            foregroundColor: AppColors.primary,
            elevation: 0,
          ),
          icon: vm.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check),
          label: const Text('Save'),
          onPressed: vm.isLoading
              ? null
              : () async {
                  if (titleCtrl.text.isEmpty && contentCtrl.text.isEmpty) {
                    ToastMessage.showError("Vui lòng nhập nội dung");
                    return;
                  }

                  try {
                    if (widget.note == null) {
                      // Thêm mới
                      await vm.addNoteAsync(
                        titleCtrl.text,
                        contentCtrl.text,
                      );
                    } else {
                      // Cập nhật (truyền oldImageUrl để giữ ảnh cũ nếu không đổi)
                      await vm.updateNoteAsync(
                        widget.note!.id,
                        titleCtrl.text,
                        contentCtrl.text,
                        oldImageUrl: widget.note?.imageUrl,
                      );
                    }

                    if (!mounted) return;
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