# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/domain/entities/intelligent_suggestion.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
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
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
