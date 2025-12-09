import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/organic_dashboard.dart';
import '../../../app_router.dart';
import '../../../core/providers/organic_zones_provider.dart';
import '../../../core/models/calibration_state.dart';

/// HomeScreen - écran d'accueil principal
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final topPadding = MediaQuery.of(context).padding.top;
    final availableHeight = MediaQuery.of(context).size.height - topPadding;

    final calibrationState = ref.watch(calibrationStateProvider);
    final isCalibrating =
        calibrationState.activeType == CalibrationType.organic;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: double.infinity,
              height: availableHeight,
              child: const OrganicDashboardWidget(
                showDiagnostics: false,
              ),
            ),
          ),

          // Petit bouton d'accès rapide aux Paramètres (temporaire)
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onSurface),
                  tooltip: 'Paramètres',
                  onPressed: () => context.push(AppRoutes.settings),
                ),
              ),
            ),
          ),

          // Le bouton de paramètres statique a été remplacé par la zone TAP configurée
          const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: isCalibrating
          ? FloatingActionButton.extended(
              heroTag: 'validateCalibration',
              icon: const Icon(Icons.check),
              label: const Text('Valider'),
              onPressed: () async {
                try {
                  await ref.read(organicZonesProvider.notifier).saveAll();
                  ref
                      .read(calibrationStateProvider.notifier)
                      .disableCalibration();

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Calibration sauvegardée'),
                    backgroundColor: Colors.green,
                  ));

                  await Future.delayed(const Duration(milliseconds: 200));
                  context.go(AppRoutes.settings);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Erreur sauvegarde calibration: $e'),
                  ));
                }
              },
            )
          : null,
    );
  }
}
