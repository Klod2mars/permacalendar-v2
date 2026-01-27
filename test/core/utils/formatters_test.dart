import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:permacalendar/core/models/currency_info.dart';

void main() {
  final eur = defaultCurrencies['EUR']!;

  test('formatCurrency returns french euro with 2 decimals', () {
    // Note: \u00A0 is the non-breaking space used by the fr_FR locale.
    final out = formatCurrency(37.35, eur).replaceAll('\u00A0', ' ');
    expect(out, '37,35 €');
  });

  test('formatCurrency handles integers by adding 2 decimals', () {
    final out = formatCurrency(20, eur).replaceAll('\u00A0', ' ');
    expect(out, '20,00 €');
  });

  test('formatPricePerKg returns value with 2 decimals and suffix', () {
    expect(formatPricePerKg(5.3357, eur).replaceAll('\u00A0', ' '), '5,34 € /kg');
    expect(formatPricePerKg(4, eur).replaceAll('\u00A0', ' '), '4,00 € /kg');
  });
}
