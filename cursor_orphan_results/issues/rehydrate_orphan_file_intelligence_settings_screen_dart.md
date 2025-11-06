# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/screens/intelligence_settings_screen.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:go_router/go_router.dart';
    
    /// Écran des paramètres de l'intelligence végétale
    class IntelligenceSettingsScreen extends ConsumerStatefulWidget {
      const IntelligenceSettingsScreen({super.key});
    
      @override
      ConsumerState<IntelligenceSettingsScreen> createState() =>
          _IntelligenceSettingsScreenState();
    }
    
    class _IntelligenceSettingsScreenState
        extends ConsumerState<IntelligenceSettingsScreen> {
      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final displayPreferences = ref.watch(displayPreferencesProvider);
        final chartSettings = ref.watch(chartSettingsProvider);
    
        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètres Intelligence'),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Retour',
            ),
          ),
          body: Semantics(
            label: 'Écran des paramètres d\'intelligence végétale',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    theme,
                    'Affichage',
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
