import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/core/theme/app_colors.dart';
import 'package:note_app/core/theme/app_theme.dart';
import '../../../core/utils/image_helper.dart';

class NoteToolbar extends StatefulWidget {
  final Function(XFile) onImageSelect;
  
  const NoteToolbar({
    super.key, 
    required this.onImageSelect,
  });

  @override
  State<NoteToolbar> createState() => _NoteToolbarState();
}


class _NoteToolbarState extends State<NoteToolbar> {
  
  final ImageHelper _imageHelper = ImageHelper();

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 18,
    ) ?? const TextStyle(fontSize: 18);

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
          _buildToolText('B', baseStyle.copyWith(fontWeight: FontWeight.bold)),
          _buildToolText('I', baseStyle.copyWith(fontStyle: FontStyle.italic)),
          _buildToolText('U', baseStyle.copyWith(decoration: TextDecoration.underline)),
          
          const Icon(Icons.format_list_bulleted),
          
          GestureDetector(
            onTap: () async {

              final XFile? image = await _imageHelper.pickImage();

              if (image != null) {
                widget.onImageSelect(image);
              }
              
            },
            child: const Icon(Icons.image_outlined),
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

  Widget _buildToolText(String text, TextStyle style) {
    return Text(text, style: style);
  }
}