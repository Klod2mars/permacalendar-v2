import 'package:intl/intl.dart';

final NumberFormat _currencyFormatter = NumberFormat.currency(
  locale: 'fr_FR',
  symbol: '€',
  decimalDigits: 2,
);

String formatCurrency(double value) {
  // Returns "37,35 €" with correct locale spacing (non-breaking space)
  return _currencyFormatter.format(value);
}

String formatPricePerKg(double value) {
  // Keep €/kg consistent with 2 decimals
  return '${value.toStringAsFixed(2)} €/kg';
}
