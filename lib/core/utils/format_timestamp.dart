import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimestamp(Timestamp ts) {
  final time = ts.toDate();
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inSeconds < 60) {
    return 'Just now';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} min ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} hours ago';
  }
  if (diff.inDays == 1) {
    return 'Yesterday';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays} days ago';
  }
  return '${time.month}/${time.day}/${time.year}';
}


