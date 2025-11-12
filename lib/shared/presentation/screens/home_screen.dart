// lib/shared/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../../../core/services/open_meteo_service.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import '../../../core/models/garden_state.dart';
import '../../../features/garden/widgets/garden_card_with_real_area.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/loading_widgets.dart';
import '../../../features/weather/providers/weather_provider.dart';
import '../../../features/weather/providers/commune_provider.dart';
import '../../../core/providers/activity_tracker_v3_provider.dart' as v3;
import '../../widgets/organic_dashboard.dart';

/// HomeScreen - Ã©cran d'accueil principal
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {\n    return Scaffold(
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
      child: OrganicDashboardWidget(
        showDiagnostics: false,
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton.extended(
    heroTag: 'validateCalibration',
    icon: const Icon(Icons.check),
    label: const Text('Valider'),
    onPressed: () {
      // TODO: connecter à la logique de validation (provider/cubit)
      // Exemple (à adapter) :
      // ref.read(calibrationStateProvider.notifier).validate();
      debugPrint('Validation calibration demandée');
    },
  ),
);\n
    // Affiche uniquement le dashboard organique en pleine hauteur disponible
    final theme = Theme.of(context);
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = MediaQuery.of(context).size.height - appBarHeight;

    debugPrint('Validation calibration demandée');
        },
      ),
);
  }

  // ----------------------------
  // Intelligence section (organic dashboard + quick actions)
  // ----------------------------
  Widget _buildIntelligenceSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Intelligence VÃ©gÃ©tale', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomCard(
          padding: EdgeInsets.zero,
          child: const OrganicDashboardWidget(),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.recommendations), icon: const Icon(Icons.lightbulb, size: 20), label: const Text('Recommandations'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.notifications), icon: const Icon(Icons.notifications, size: 20), label: const Text('Notifications'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.intelligenceSettings), icon: const Icon(Icons.settings, size: 20), label: const Text('ParamÃ¨tres intelligence'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.pestObservation), icon: const Icon(Icons.bug_report, size: 20), label: const Text('Observation nuisibles'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
          ],
        ),
      ],
    );
  }

  // ----------------------------
  // Recent activity (uses v3.recentActivitiesProvider)
  // ----------------------------
  Widget _buildRecentActivity(BuildContext context, ThemeData theme, WidgetRef ref) {
    final activitiesAsync = ref.watch(v3.recentActivitiesProvider);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: activitiesAsync.when(
          loading: () => const LoadingWidget(),
          error: (e, st) => ErrorStateWidget(
            title: 'ActivitÃ©s indisponibles',
            subtitle: e.toString(),
            retryText: 'RÃ©essayer',
            onRetry: () => ref.read(v3.recentActivitiesProvider.notifier).refresh(),
          ),
          data: (data) {
            final items = data ?? <dynamic>[];

            if (items.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ActivitÃ© rÃ©cente', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Aucune activitÃ© rÃ©cente.'),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ActivitÃ© rÃ©cente', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...items.map<Widget>((it) {
                  final title = (it?.toString() ?? 'ActivitÃ©');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [const Icon(Icons.history, size: 18), const SizedBox(width: 8), Expanded(child: Text(title))]),
                  );
                }).toList(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => ref.read(v3.recentActivitiesProvider.notifier).refresh(), child: const Text('Actualiser')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}




