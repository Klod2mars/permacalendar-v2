# [rehydrate] Fichier orphelin: lib/features/climate/presentation/screens/alerts_detail_screen.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:go_router/go_router.dart';
    import '../providers/weather_alert_provider.dart';
    import '../providers/weather_providers.dart';
    import '../../../../shared/presentation/widgets/alert_indicator_widget.dart';
    
    /// Écran de détail des alertes météo avec recommandations jardinage
    class AlertsDetailScreen extends ConsumerWidget {
      const AlertsDetailScreen({super.key});
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final alertsAsync = ref.watch(weatherAlertsProvider('default'));
    
        return Scaffold(
          appBar: AppBar(
            title: const Text("Alertes Météo"),
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2E7D32),
                  Color(0xFF1B5E20),
                ],
              ),
            ),
            child: alertsAsync.when(
              data: (alerts) => _buildAlertsContent(context, alerts),
              loading: () => const Center(
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
