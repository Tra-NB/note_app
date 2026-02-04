import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/presentation/theme/app_colors.dart';
import 'package:note_app/presentation/theme/app_theme.dart';

class NoteToolbar extends StatelessWidget {
  final Function(XFile) onImageSelect;

  const NoteToolbar({
    super.key,
    required this.onImageSelect,
  });

  void _showImageSourceSheet(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Chụp ảnh mới'),
            onTap: () async {
              Navigator.pop(context);
              final XFile? image = await picker.pickImage(source: ImageSource.camera);
              if (image != null) onImageSelect(image);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('Chọn từ thư viện'),
            onTap: () async {
              Navigator.pop(context);
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) onImageSelect(image);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
            ) ??
        const TextStyle(fontSize: 18);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.commonShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildToolAction('B', baseStyle.copyWith(fontWeight: FontWeight.bold), () {}),
          _buildToolAction('I', baseStyle.copyWith(fontStyle: FontStyle.italic), () {}),
          _buildToolAction('U', baseStyle.copyWith(decoration: TextDecoration.underline), () {}),
          
          const Icon(Icons.format_list_bulleted, color: Colors.black54),
          
          IconButton(
            onPressed: () => _showImageSourceSheet(context),
            icon: const Icon(Icons.image_outlined, color: Colors.black87),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 18,
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          )
        ],
      ),
    );
  }

  Widget _buildToolAction(String text, TextStyle style, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(text, style: style),
      ),
    );
  }
}