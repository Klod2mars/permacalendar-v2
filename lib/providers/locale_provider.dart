import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const String _kLocaleKey = 'app_locale';
  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('es'),
    Locale('pt', 'BR'),
    Locale('de'),
  ];

  @override
  Locale build() {
    // Initial state is French default, loaded asynchronously
    _init(); 
    return const Locale('fr');
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_kLocaleKey);
    final String? countryCode = prefs.getString('${_kLocaleKey}_country');
    
    // Initialize formats
    await Future.wait([
      initializeDateFormatting('fr'),
      initializeDateFormatting('en'),
      initializeDateFormatting('es'),
      initializeDateFormatting('pt_BR'),
      initializeDateFormatting('de'),
    ]);

    if (languageCode != null) {
      state = Locale(languageCode, countryCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale) && 
        !supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return; 
    }
    
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString('${_kLocaleKey}_country', locale.countryCode!);
    } else {
      await prefs.remove('${_kLocaleKey}_country');
    }
    
    await initializeDateFormatting(locale.toString());
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
