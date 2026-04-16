import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _shortFormat = DateFormat('dd MMM');
  static final _timeFormat = DateFormat('hh:mm a');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatShort(DateTime date) => _shortFormat.format(date);

  static String formatTime(DateTime date) => _timeFormat.format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  static int daysRemaining(DateTime endDate) {
    final now = DateTime.now();
    final diff = endDate.difference(now).inDays;
    return diff < 0 ? 0 : diff;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}
