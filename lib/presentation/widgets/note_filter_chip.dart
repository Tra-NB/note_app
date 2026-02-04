import 'package:flutter/material.dart';
import 'package:note_app/presentation/theme/app_theme.dart';
import '../theme/app_colors.dart';

class NoteFilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const NoteFilterChip({
    super.key,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.item, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTheme.filterChipStyle(context, selected),
      ),
    );
  }
}
