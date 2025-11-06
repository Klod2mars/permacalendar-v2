# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:permacalendar/core/providers/providers.dart' as core_intel;
    
    // ==================== PROVIDERS D'AFFICHAGE ====================
    
    /// Provider pour les préférences d'affichage
    final displayPreferencesProvider =
        NotifierProvider<DisplayPreferencesNotifier, DisplayPreferences>(
            DisplayPreferencesNotifier.new);
    
    /// Provider pour les paramètres des graphiques
    final chartSettingsProvider =
        NotifierProvider<ChartSettingsNotifier, ChartSettings>(
            ChartSettingsNotifier.new);
    
    /// Notifier pour le mode de vue sélectionné
    class ViewModeNotifier extends Notifier<ViewMode> {
      @override
      ViewMode build() => ViewMode.dashboard;
    }
    
    /// Provider pour le mode de vue sélectionné
    final viewModeProvider =
        NotifierProvider<ViewModeNotifier, ViewMode>(ViewModeNotifier.new);
    
    /// Notifier pour le filtre de plantes sélectionné
    class SelectedPlantFilterNotifier extends Notifier<String?> {
      @override
      String? build() => null;
    }
    
    /// Provider pour le filtre de plantes sélectionné
    final selectedPlantFilterProvider =
        NotifierProvider<SelectedPlantFilterNotifier, String?>(
            SelectedPlantFilterNotifier.new);
    
    /// Notifier pour le filtre de jardin sélectionné
    class SelectedGardenFilterNotifier extends Notifier<String?> {
      @override
      String? build() => null;
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
