String convertTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);
  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    //Only YYYY-MM-DD . Add zero if month or day is less than 10
    return '${time.year}-${time.month < 10 ? '0${time.month}' : time.month}-${time.day < 10 ? '0${time.day}' : time.day}';
  }
}
