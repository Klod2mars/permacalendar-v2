import 'package:freezed_annotation/freezed_annotation.dart';

part 'intelligent_suggestion.freezed.dart';
part 'intelligent_suggestion.g.dart';

/// Suggestion intelligente contextuelle à un jardin.
///
/// Représente une recommandation générée par l'intelligence végétale
/// basée sur le contexte spécifique d'un jardin : météo, saison,
/// état des plantes, cycles lunaires, etc.
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

