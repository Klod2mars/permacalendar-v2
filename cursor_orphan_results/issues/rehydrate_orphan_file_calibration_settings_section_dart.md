# [rehydrate] Fichier orphelin: lib/shared/presentation/widgets/settings/calibration_settings_section.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:go_router/go_router.dart';
    import '../../../../core/models/calibration_state.dart';
    import '../../screens/calibration_settings_screen.dart';
    
    /// Section Calibration dans les paramètres
    class CalibrationSettingsSection extends ConsumerWidget {
      const CalibrationSettingsSection({super.key});
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final calibrationState = ref.watch(calibrationStateProvider);
        final isCalibrating = calibrationState.activeType != CalibrationType.none;
    
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.tune, color: Colors.green),
                    const SizedBox(width: 12),
                    Text(
                      'Calibration',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
    
                const SizedBox(height: 8),
    
                Text(
                  'Personnalisez l\'affichage de votre dashboard',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
