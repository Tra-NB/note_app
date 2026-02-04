import 'package:flutter/material.dart';
import 'package:note_app/presentation/theme/app_theme.dart';
import '../theme/app_colors.dart';



class NoteAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NoteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background, 
      surfaceTintColor: Colors.transparent,  
      elevation: 0,
      scrolledUnderElevation: 0,              
      shadowColor: Colors.transparent,
      
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {},
      ),
      centerTitle: true,
      title: Text(
        'Notes',
        style: AppTheme.myTextTheme.displayLarge,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color.fromARGB(255, 245, 222, 222),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
