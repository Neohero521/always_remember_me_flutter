import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  DateFormatter._();

  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

  static String formatDate(DateTime dt) => _dateFormat.format(dt);
  static String formatTime(DateTime dt) => _timeFormat.format(dt);
  static String formatDateTime(DateTime dt) => _dateTimeFormat.format(dt);

  static String formatRelative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}月前';
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }
}
