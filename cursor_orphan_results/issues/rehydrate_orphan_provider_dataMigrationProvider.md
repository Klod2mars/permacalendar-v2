# [rehydrate] Provider orphelin: dataMigrationProvider

- **Type**: provider (Riverpod)
- **Déclaration**: core\di\garden_module.dart:126 【12†core\di\garden_module.dart:126】
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/orphan_providers.txt
- **Plan de ré-intégration**:
  1. Vérifier exports/barrel files et références indirectes
  2. Rechercher usages dynamiques (.family, .notifier, string-based routes)
  3. Ajouter usages/tests et réintroduire import si nécessaire
  4. Faire PR et reviewer
