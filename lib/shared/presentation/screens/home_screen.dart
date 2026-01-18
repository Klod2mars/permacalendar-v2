import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
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
      backgroundColor: Colors.black,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: OrganicDashboardWidget(
              showDiagnostics: false,
              imageZoom: 1.18,
            ),
          ),

          // Petit bouton d'accès rapide aux Paramètres (temporaire)
          // Safety fallback invisible: zone cliquable en haut-droite qui ouvre Paramètres.
          // Ne supprime pas le hotspot orga dans OrganicDashboard — c'est simplement un fallback.
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: SizedBox(
                width: 56, // taille de zone fallback (ajuster si besoin)
                height: 56,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.settings),
                    // neutraliser tout feedback visuel
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: Semantics(
                      button: true,
                      label: AppLocalizations.of(context)!.home_settings_fallback_label,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Le bouton de paramètres statique a été remplacé par la zone TAP configurée
          const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: null,
    );
  }
}
