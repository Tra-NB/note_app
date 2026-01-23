import 'package:flutter/material.dart';
import 'package:note_app/core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';

class NoteBottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const NoteBottomItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        active ? AppColors.primary : AppColors.iconInactive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.myTextTheme.bodySmall,
        ),
      ],
    );
  }
}
