// 🧠 IntelligentSuggestion - Modèle de Suggestion Intelligente Contextuelle
// PermaCalendar v2.8.0 - Migration Riverpod 3
// Clean Architecture + Domain-Driven Design
//
// **Rôle dans l'écosystème d'intelligence :**
// Ce modèle représente une suggestion intelligente contextuelle générée par
// le système d'intelligence végétale. Contrairement à `IntelligentRecommendation`
// (utilisé dans `IntelligentRecommendationEngine`), `IntelligentSuggestion` est
// un modèle de domaine plus simple et orienté utilisateur, conçu pour être
// affiché dans l'interface utilisateur et suivi (lu/actionné).
//
// **Différences avec IntelligentRecommendation :**
// - `IntelligentRecommendation` : Modèle interne au moteur de recommandation,
//   avec score de confiance, raisonnement détaillé, actions multiples
// - `IntelligentSuggestion` : Modèle de domaine simplifié pour l'UI, avec
//   message clair, priorité, catégorie, et suivi de lecture/action
//
// **Usage par les composants du système :**
// - `IntelligentRecommendationEngine` : Peut générer des `IntelligentSuggestion`
//   à partir de ses `IntelligentRecommendation` internes
// - `RealTimeDataProcessor` : Peut créer des suggestions en temps réel basées
//   sur des événements (météo, santé des plantes, etc.)
// - Providers Riverpod 3 : Utilisé dans les providers d'état pour l'affichage
//   dans l'interface utilisateur (dashboard, notifications, etc.)
//
// **Types de suggestions disponibles :**
// - Actions : Suggestions d'actions à effectuer (semis, arrosage, récolte)
// - Alertes : Alertes urgentes (gel, canicule, nuisibles)
// - Prévisions : Suggestions préventives basées sur la météo ou les cycles
//
// **Compatibilité Riverpod 3 :**
// - ✅ Aucune dépendance globale
// - ✅ Modèle immuable (Freezed)
// - ✅ Sérialisable JSON pour la persistance
// - ✅ Compatible avec les providers Riverpod 3
//
// **Exemple d'utilisation via Riverpod 3 :**
// ```dart
// // Dans un provider
// final suggestionsProvider = FutureProvider.autoDispose<List<IntelligentSuggestion>>((ref) async {
//   final engine = ref.read(IntelligenceModule.intelligentRecommendationEngineProvider);
//   final recommendations = await engine.generateRecommendations(...);
//   // Convertir les recommendations en suggestions
//   return recommendations.recommendations.map((r) => IntelligentSuggestion(...)).toList();
// });
//
// // Dans un widget
// final suggestions = ref.watch(suggestionsProvider);
// suggestions.when(
//   data: (suggestions) => ListView(...),
//   loading: () => CircularProgressIndicator(),
//   error: (err, stack) => ErrorWidget(err),
// );
// ```

import 'package:freezed_annotation/freezed_annotation.dart';

part 'intelligent_suggestion.freezed.dart';
part 'intelligent_suggestion.g.dart';

/// Suggestion intelligente contextuelle à un jardin.
///
/// Représente une recommandation générée par l'intelligence végétale
/// basée sur le contexte spécifique d'un jardin : météo, saison,
/// état des plantes, cycles lunaires, etc.
///
/// **Caractéristiques :**
/// - Modèle immuable (Freezed) pour la sécurité des threads
/// - Sérialisable JSON pour la persistance locale
/// - Suivi de l'état utilisateur (lu/actionné)
/// - Expiration optionnelle pour les suggestions temporaires
///
/// **Compatibilité avec les modèles de plantes :**
/// - Compatible avec `PlantV2` via `gardenId` (contexte jardin)
/// - Peut référencer des plantes spécifiques via `metadata` (extension future)
///
/// **Usage recommandé :**
/// - Générer via `IntelligentRecommendationEngine` ou `RealTimeDataProcessor`
/// - Stocker dans un repository dédié (à créer)
/// - Afficher dans l'UI via des providers Riverpod 3
@freezed
class IntelligentSuggestion with _$IntelligentSuggestion {
  const factory IntelligentSuggestion({
    /// Identifiant unique de la suggestion
    required String id,

    /// Identifiant du jardin concerné
    required String gardenId,

    /// Message de la suggestion (en français, clair et actionnable)
    /// Exemple : "C'est le moment idéal pour semer vos tomates"
    required String message,

    /// Niveau de priorité de la suggestion
    required SuggestionPriority priority,

    /// Catégorie de la suggestion
    required SuggestionCategory category,

    /// Date d'expiration de la suggestion (optionnelle)
    /// Si null, la suggestion reste active indéfiniment
    DateTime? expiresAt,

    /// Suggestion lue par l'utilisateur ?
    @Default(false) bool isRead,

    /// Suggestion actionnée par l'utilisateur ?
    @Default(false) bool isActioned,

    /// Date de création de la suggestion
    required DateTime createdAt,
  }) = _IntelligentSuggestion;

  factory IntelligentSuggestion.fromJson(Map<String, dynamic> json) =>
      _$IntelligentSuggestionFromJson(json);
}

/// Niveau de priorité d'une suggestion
enum SuggestionPriority {
  /// Haute priorité (action urgente recommandée)
  high,

  /// Priorité moyenne (action recommandée sous quelques jours)
  medium,

  /// Basse priorité (information utile, pas urgente)
  low,
}

/// Catégorie de suggestion
enum SuggestionCategory {
  /// Suggestion liée à la météo (gel, canicule, pluie)
  weather,

  /// Suggestion liée aux cycles lunaires
  lunar,

  /// Suggestion saisonnière (semis, récoltes)
  seasonal,

  /// Suggestion liée aux nuisibles ou maladies
  pest,

  /// Suggestion de récolte
  harvest,

  /// Suggestion de maintenance (arrosage, taille, etc.)
  maintenance,
}
