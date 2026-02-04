import 'package:flutter/material.dart';

class DialogUtils {
  static Future<bool> showConfirm({
    required BuildContext context,
    required String title,
    required String content,
    String confirmLabel = 'Xóa',
    String cancelLabel = 'Hủy',
    Color? confirmColor = Colors.red,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}