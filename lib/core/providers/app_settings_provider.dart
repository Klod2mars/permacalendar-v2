// lib/core/providers/app_settings_provider.dart
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../models/app_settings.dart';

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return AppSettings.defaults();
  }

  /// Met à jour les dernières coordonnées
  Future<void> setLastCoordinates(double lat, double lon) async {
    state = state.copyWith(lastLatitude: lat, lastLongitude: lon);
  }

  /// Définit le theme à partir d'un ThemeMode
  Future<void> setThemeModeEnum(ThemeMode mode) async {
    final tm = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    state = state.copyWith(themeMode: tm);
  }

  Future<void> setSelectedCommune(String? commune) async {
    state = state.copyWith(selectedCommune: commune);
  }

  // Ajoute d'autres helpers si besoin
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(() => AppSettingsNotifier());

