# [rehydrate] Fichier orphelin: lib/features/climate/presentation/screens/weather_detail_screen.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:go_router/go_router.dart';
    
    /// Écran de détail météo pour les zones TAP
    class WeatherDetailScreen extends ConsumerWidget {
      const WeatherDetailScreen({super.key});
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final theme = Theme.of(context);
    
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go('/'); // Retour vers Dashboard
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Détail Météo'),
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wb_sunny,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
