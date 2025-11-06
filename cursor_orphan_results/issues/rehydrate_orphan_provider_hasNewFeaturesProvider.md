# [rehydrate] Provider orphelin: hasNewFeaturesProvider

- **Type**: provider (Riverpod)
- **Déclaration**: core\feature_flags.dart:95 【12†core\feature_flags.dart:95】
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/orphan_providers.txt
- **Plan de ré-intégration**:
  1. Vérifier exports/barrel files et références indirectes
  2. Rechercher usages dynamiques (.family, .notifier, string-based routes)
  3. Ajouter usages/tests et réintroduire import si nécessaire
  4. Faire PR et reviewer
