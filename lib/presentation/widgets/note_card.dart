import 'package:flutter/material.dart';
import 'package:note_app/presentation/theme/app_theme.dart';

import '../../domain/entities/note.dart';
import '../theme/app_colors.dart';
import '../../shared/utils/format_timestamp.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.item, 
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (note.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  note.imageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            Text(
              note.title,
              style: AppTheme.myTextTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              note.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.myTextTheme.bodySmall,
              ),
            
            const Spacer(),
            Text(
              formatTimestamp(note.updateAt),
              style: AppTheme.myTextTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }




  
}
