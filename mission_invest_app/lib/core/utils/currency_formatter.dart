import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 0,
  );

  static final _inrFormatWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 2,
  );

  static String format(double amount) => _inrFormat.format(amount);

  static String formatWithDecimals(double amount) =>
      _inrFormatWithDecimals.format(amount);

  static String compact(double amount) {
    if (amount >= 10000000) {
      return '\u20B9${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '\u20B9${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '\u20B9${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount);
  }
}
