import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'ar',
    symbol: 'ج.م',
    decimalDigits: 0,
  );

  static final NumberFormat _numberFormat = NumberFormat.decimalPattern('ar');

  static String currency(num value) {
    return _currencyFormat.format(value);
  }

  static String number(num value) {
    return _numberFormat.format(value);
  }

  static String percent(num value) {
    return '${_numberFormat.format(value)}%';
  }

  static String date(DateTime date) {
    return DateFormat('yyyy/MM/dd', 'ar').format(date);
  }
}
