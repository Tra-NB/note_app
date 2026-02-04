
String formatTimestamp(DateTime ts) {
  final now = DateTime.now();
  final diff = now.difference(ts);

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
  return '${ts.month}/${ts.day}/${ts.year}';
}


