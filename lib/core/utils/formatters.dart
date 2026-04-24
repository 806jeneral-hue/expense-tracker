import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount, {String currency = 'EGP', bool isArabic = false}) {
    final formatter = NumberFormat('#,##0.00', 'en');
    String symbol = currency;
    if (isArabic && currency == 'EGP') symbol = 'ج.م';
    return isArabic ? '${formatter.format(amount.abs())} $symbol' : '$symbol ${formatter.format(amount.abs())}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String getRelativeDate(DateTime date, {bool isArabic = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (isArabic) {
      if (diff == 0) return 'اليوم';
      if (diff == 1) return 'أمس';
      if (diff < 7) return 'منذ $diff أيام';
    } else {
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      if (diff < 7) return '$diff days ago';
    }
    return formatDate(date);
  }

  static String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.##', 'en');
    return formatter.format(number);
  }
}
