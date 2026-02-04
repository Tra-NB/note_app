import 'dart:io'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/presentation/theme/app_theme.dart';
import 'package:note_app/shared/utils/format_timestamp.dart';
import 'package:note_app/presentation/widgets/message.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/note.dart';
import '../../application/features/notes/viewmodel/note_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/note_toolbar.dart';
import '../../shared/utils/confirm_dialog.dart';

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
                Row(
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
                    
                    // Nút SAVE
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
                                  await vm.addNoteAsync(
                                    titleCtrl.text,
                                    contentCtrl.text,
                                  );
                                } else {
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
                          child: _buildImageWidget(vm, widget.note?.imageUrl),
                        ),
                      ),
                      
                      if (vm.selectedImage != null)
                        Positioned(
                          top: 15,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              vm.removeSelectedImage();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              radius: 14,
                              child: const Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),

                      // Loading indicator khi đang upload/lưu
                      if (vm.isLoading)
                        const Positioned.fill(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),

                // --- INPUT TEXT ---
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

  Widget _buildImageWidget(NoteViewModel vm, String? oldUrl) {
    if (vm.selectedImage != null) {
      if (kIsWeb) {
        return Image.network(
          vm.selectedImage!.path,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(vm.selectedImage!.path),
          fit: BoxFit.cover,
        );
      }
    }
    
    if (oldUrl != null) {
      return Image.network(
        oldUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => 
            const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    }

    return const SizedBox();
  }
}