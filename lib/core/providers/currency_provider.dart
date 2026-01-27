import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permacalendar/core/models/currency_info.dart';

class CurrencyNotifier extends Notifier<CurrencyInfo> {
  static const _currencyKey = 'currency_code';

  @override
  CurrencyInfo build() {
    // Initial load
    _load();
    return defaultCurrencies['EUR']!;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_currencyKey) ?? 'EUR';
    state = defaultCurrencies[code] ?? defaultCurrencies['EUR']!;
  }

  Future<void> setCurrency(String code) async {
    if (!defaultCurrencies.containsKey(code)) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, code);
    
    state = defaultCurrencies[code]!;
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyInfo>(CurrencyNotifier.new);
