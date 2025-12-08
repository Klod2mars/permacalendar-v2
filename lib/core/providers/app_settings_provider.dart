import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';

/// Provider minimal pour les réglages de l'application.
/// Fournit l'objet AppSettings et quelques mutateurs légers utilisés par le code météo.
final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    // Valeurs par défaut (tests & usages légers)
    return AppSettings.defaults();
  }

  /// Sauvegarde des dernières coordonnées (utilisé par weather_providers)
  Future<void> setLastCoordinates(double latitude, double longitude) async {
    state = state.copyWith(lastLatitude: latitude, lastLongitude: longitude);
    // Optionnel : persistance Hive/IO si tu veux ; pour compilation on met à jour l'état seulement.
  }

  /// Setter pratique pour la commune sélectionnée si besoin ultérieur
  Future<void> setSelectedCommune(String? commune) async {
    state = state.copyWith(selectedCommune: commune);
  }
}
