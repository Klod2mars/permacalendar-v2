ï»¿import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import '../services/open_meteo_service.dart';

/// Provider pour la recherche de communes avec debounce et gestion d'erreurs
///
/// Utilise un FutureProvider.family pour gérer la recherche dynamique
/// - Debounce automatique (300ms)
/// - Longueur minimale (â‰¥2 caractères)
/// - Gestion d'erreurs silencieuse
final communeSearchProvider =
    FutureProvider.family<List<PlaceSuggestion>, String>(
  (ref, query) async {
    // Si la requête est vide ou trop courte, retourner liste vide
    if (query.trim().length < 2) {
      return const [];
    }

    // Debounce manuel : petit délai pour éviter les requêtes trop fréquentes
    await Future.delayed(const Duration(milliseconds: 300));

    final svc = OpenMeteoService.instance;
    try {
      final results = await svc.searchPlaces(query, count: 12);
      return results;
    } catch (e) {
      // Gestion d'erreur silencieuse mais visible dans les logs
      debugPrint('Erreur recherche commune : $e');
      return const [];
    }
  },
);

/// Notifier pour la commune sélectionnée
///
/// Utilisé pour synchroniser les données météo avec la commune sélectionnée.
/// Les providers météo peuvent s'abonner à ce provider pour être réactifs
/// aux changements de commune.
class SelectedCommuneNotifier extends Notifier<PlaceSuggestion?> {
  @override
  PlaceSuggestion? build() => null;

  /// Définit la commune sélectionnée
  void setCommune(PlaceSuggestion? commune) {
    state = commune;
  }

  /// Efface la commune sélectionnée
  void clearCommune() {
    state = null;
  }
}

/// Provider réactif stockant la commune sélectionnée
final selectedCommuneProvider =
    NotifierProvider<SelectedCommuneNotifier, PlaceSuggestion?>(
  SelectedCommuneNotifier.new,
);


