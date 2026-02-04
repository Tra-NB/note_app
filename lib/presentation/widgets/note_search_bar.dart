import 'package:flutter/material.dart';
import 'package:note_app/presentation/theme/app_theme.dart';
import '../theme/app_colors.dart';

class NoteSearchBar extends StatelessWidget {
  const NoteSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.item, 
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.commonShadow,
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.primary, 
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your notes...',
                hintStyle: AppTheme.myTextTheme.bodyMedium,
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(
            Icons.mic_none,
            color: AppColors.iconInactive, 
          ),
        ],
      ),
    );
  }
}
