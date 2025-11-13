import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_app_bar.dart';
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
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = MediaQuery.of(context).size.height - appBarHeight;

    // Lecture de l'état de calibration : le FAB n'existe que si on est en calibration organique
    final calibrationState = ref.watch(calibrationStateProvider);
    final isCalibrating = calibrationState.activeType == CalibrationType.organic;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PermaCalendar 2.0',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: availableHeight,
          child: const OrganicDashboardWidget(
            showDiagnostics: false,
          ),
        ),
      ),
      // Afficher le FAB 'Valider' uniquement pendant le mode calibration
      floatingActionButton: isCalibrating
          ? FloatingActionButton.extended(
              heroTag: 'validateCalibration',
              icon: const Icon(Icons.check),
              label: const Text('Valider'),
              onPressed: () async {
                try {
                  // Persister toutes les zones organiques
                  await ref.read(organicZonesProvider.notifier).saveAll();

                  // Désactiver la calibration (et masquer le FAB)
                  ref.read(calibrationStateProvider.notifier).disableCalibration();

                  // Confirmation utilisateur
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Calibration sauvegardée'),
                    backgroundColor: Colors.green,
                  ));

                  // Retourner dans les paramètres pour s'assurer que tout a disparu côté UI
                  // (c'est le comportement de secours demandé)
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


