import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/core/utils/format_timestamp.dart';
import 'package:note_app/features/notes/widgets/message.dart';
import 'package:provider/provider.dart';
import '../../core/models/note_model.dart';
import '../../features/notes/viewmodel/note_viewmodel.dart';
import '../../core/theme/app_colors.dart';
import '../../features/notes/widgets/note_toolbar.dart';
import '../../core/utils/confirm_dialog.dart';



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
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<NoteViewModel>();

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
                //  HEADER 
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
                            content: 'Bạn có chắc chắn muốn xóa ghi chú này không? Hành động này không thể hoàn tác.',
                          );

                            if (confirm) {
                              await vm.delete(widget.note!.id);
                              if (!mounted) return;
                              ToastMessage.showSuccess("Đã xóa ghi chú thành công");
                            }
                          Navigator.pop(context);
                        },
                      ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primarySoft,
                        foregroundColor: AppColors.primary,
                        
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Save'),
                      onPressed: () async {
                        try {
                          String? finalImageUrl = vm.currentImageUrl ?? widget.note?.imageUrl;

                          if (widget.note == null) {
                            await vm.add(
                              titleCtrl.text,
                              contentCtrl.text,
                              imageUrl: finalImageUrl,
                            );
                            ToastMessage.showSuccess("Đã lưu ghi chú.");

                          } else {
                            await vm.update(
                              widget.note!.copyWith(
                                title: titleCtrl.text,
                                content: contentCtrl.text,
                                imageUrl: finalImageUrl, // <--- VÀ DÒNG NÀY NỮA
                              ),
                            );
                            ToastMessage.showSuccess("Đã cập nhật ghi chú.");
                          }

                        }catch(e){
                          ToastMessage.showError("Lỗi: $e");

                        }
                        if (!mounted) return;
                        Navigator.pop(context);
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
                        : formatTimestamp(widget.note!.updateAt),
                    style: AppTheme.myTextTheme.bodySmall,
                  ),
                ),

                const SizedBox(height: 16),

                Consumer<NoteViewModel>(
                  builder: (context, vm, child) {
                    if (vm.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: LinearProgressIndicator(),
                      );
                    }

                    
                    final String? imageToShow = vm.currentImageUrl ?? widget.note?.imageUrl;

                    if (imageToShow != null && imageToShow.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(imageToShow),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink(); 
                  },
                ),

                
                TextField(
                  controller: titleCtrl,
                  style: AppTheme.myTextTheme.displayLarge,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),

                const SizedBox(height: 8),

               
                Expanded(
                  child: TextField(
                    controller: contentCtrl,
                    maxLines: null,
                    style: AppTheme.myTextTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Start typing...',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height:8,),
                
                NoteToolbar(
                  onImageSelect: (XFile pickedFile) {
                     context.read<NoteViewModel>().uploadImage(pickedFile);
                  },
                ),
              
                // TOOLBAR 
              ], 
            ),
          ),
        ),
      ),
    );
  }
}
