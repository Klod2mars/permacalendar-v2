import 'package:intl/intl.dart';
import '../models/currency_info.dart';

NumberFormat currencyFormatterFor(CurrencyInfo ci) => NumberFormat.currency(
      locale: ci.locale,
      symbol: ci.symbol,
      decimalDigits: ci.decimalDigits,
    );

String formatCurrency(double value, CurrencyInfo ci) {
  return currencyFormatterFor(ci).format(value);
}

String formatPricePerKg(double value, CurrencyInfo ci, {String unit = 'kg'}) {
  return '${formatCurrency(value, ci)} /$unit';
}
