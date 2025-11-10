import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/plant_intelligence_providers.dart';
import '../providers/intelligence_state_providers.dart';
import '../providers/notification_providers.dart';
import '../../domain/entities/intelligence_state.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/comprehensive_garden_analysis.dart';
import '../../domain/entities/pest_threat_analysis.dart';
import '../../domain/entities/bio_control_recommendation.dart';
import '../../domain/entities/intelligence_report.dart';
import '../../domain/entities/notification_alert.dart';
import '../../../garden/providers/garden_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../app_router.dart';
import '../../../../core/providers/garden_aggregation_providers.dart';
import '../../../../core/providers/providers.dart' as core_intel;
import '../../../../core/providers/providers.dart' show IntelligentAlertsState;
import '../providers/plant_intelligence_ui_providers.dart' as ui_intel;
import '../widgets/charts/condition_radar_chart_simple.dart';
import '../widgets/garden_selector_widget.dart';
import 'plant_evolution_history_screen.dart';

/// Ã‰cran principal du tableau de bord d'intelligence des plantes
class PlantIntelligenceDashboardScreen extends ConsumerStatefulWidget {
  const PlantIntelligenceDashboardScreen({super.key});

  @override
  ConsumerState<PlantIntelligenceDashboardScreen> createState() {
    print(
        'ðŸ”´ðŸ”´ðŸ”´ [DIAGNOSTIC CRITIQUE] PlantIntelligenceDashboardScreen.createState() APPELÃ‰ ðŸ”´ðŸ”´ðŸ”´');
    return _PlantIntelligenceDashboardScreenState();
  }
}

class _PlantIntelligenceDashboardScreenState
    extends ConsumerState<PlantIntelligenceDashboardScreen> {
  bool _isRefreshing = false;

  _PlantIntelligenceDashboardScreenState() {
    print(
        'ðŸ”´ðŸ”´ðŸ”´ [DIAGNOSTIC CRITIQUE] _PlantIntelligenceDashboardScreenState CONSTRUCTEUR APPELÃ‰ ðŸ”´ðŸ”´ðŸ”´');
  }

  @override
  void initState() {
    super.initState();
    print('ðŸ”´ [DIAGNOSTIC] PlantIntelligenceDashboard.initState() APPELÃ‰');
    // Initialiser l'intelligence pour le jardin par dÃ©faut
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          'ðŸ”´ [DIAGNOSTIC] postFrameCallback APPELÃ‰ - va appeler _initializeIntelligence');
      _initializeIntelligence();
    });
  }

  Future<void> _initializeIntelligence() async {
    print('ðŸ”´ [DIAGNOSTIC] _initializeIntelligence() DÃ‰BUT');
    developer.log('ðŸ” DIAGNOSTIC - DÃ©but _initializeIntelligence',
        name: 'PlantIntelligenceDashboard');

    // RÃ©cupÃ©rer l'ID du premier jardin disponible
    print('ðŸ”´ [DIAGNOSTIC] Lecture gardenProvider...');
    final gardenState = ref.read(gardenProvider);
    print(
        'ðŸ”´ [DIAGNOSTIC] gardenState rÃ©cupÃ©rÃ©: ${gardenState.gardens.length} jardins');
    developer.log(
        'ðŸ” DIAGNOSTIC - GardenState rÃ©cupÃ©rÃ©: ${gardenState.gardens.length} jardins',
        name: 'PlantIntelligenceDashboard');

    final gardens = gardenState.gardens;
    if (gardens.isNotEmpty) {
      final gardenId = gardens.first.id;
      print(
          'ðŸ”´ [DIAGNOSTIC] Premier jardin trouvÃ©: $gardenId (${gardens.first.name})');
      developer.log(
          'ðŸ” DIAGNOSTIC - Utilisation du jardin: $gardenId (${gardens.first.name})',
          name: 'PlantIntelligenceDashboard');

      // DÃ©finir le jardin actuel pour l'intelligence
      ref.read(core_intel.currentIntelligenceGardenIdProvider.notifier).state = gardenId;

      print(
          'ðŸ”´ [DIAGNOSTIC] Appel intelligenceStateProvider($gardenId).notifier.initializeForGarden()...');
      developer.log('ðŸ” DIAGNOSTIC - Appel initializeForGarden...',
          name: 'PlantIntelligenceDashboard');
      await ref
          .read(intelligenceStateProvider(gardenId).notifier)
          .initializeForGarden();

      print('ðŸ”´ [DIAGNOSTIC] initializeForGarden terminÃ©');
      developer.log('âœ… DIAGNOSTIC - initializeForGarden terminÃ©',
          name: 'PlantIntelligenceDashboard');

      // VÃ©rifier l'Ã©tat aprÃ¨s initialisation
      final intelligenceState = ref.read(intelligenceStateProvider(gardenId));
      print(
          'ðŸ”´ [DIAGNOSTIC] Ã‰tat aprÃ¨s init: isInitialized=${intelligenceState.isInitialized}');
      print(
          'ðŸ”´ [DIAGNOSTIC] activePlantIds.length=${intelligenceState.activePlantIds.length}');
      print(
          'ðŸ”´ [DIAGNOSTIC] activePlantIds=${intelligenceState.activePlantIds}');
      developer.log(
          'ðŸ” DIAGNOSTIC - Ã‰tat aprÃ¨s init: isInitialized=${intelligenceState.isInitialized}, activePlantIds=${intelligenceState.activePlantIds.length}',
          name: 'PlantIntelligenceDashboard');
      developer.log(
          'ðŸ” DIAGNOSTIC - Plantes actives: ${intelligenceState.activePlantIds}',
          name: 'PlantIntelligenceDashboard');
    } else {
      print('ðŸ”´ [DIAGNOSTIC] âŒ AUCUN JARDIN TROUVÃ‰ !');
      developer.log('âŒ DIAGNOSTIC - Aucun jardin trouvÃ©',
          name: 'PlantIntelligenceDashboard');
    }
    print('ðŸ”´ [DIAGNOSTIC] _initializeIntelligence() FIN');
  }

  @override
  Widget build(BuildContext context) {
    print('ðŸ”´ [DIAGNOSTIC] PlantIntelligenceDashboard.build() APPELÃ‰');
    final theme = Theme.of(context);

    // RÃ©cupÃ©rer le jardin actuel
    final currentGardenId = ref.watch(core_intel.currentIntelligenceGardenIdProvider);

    // Si aucun jardin n'est sÃ©lectionnÃ©, afficher un message
    if (currentGardenId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Intelligence VÃ©gÃ©tale'),
        ),
        body: const Center(
          child: Text('Aucun jardin sÃ©lectionnÃ©. Veuillez crÃ©er un jardin.'),
        ),
      );
    }

    final intelligenceState =
        ref.watch(intelligenceStateProvider(currentGardenId));
    final alertsState = ref.watch(core_intel.intelligentAlertsProvider);
    print(
        'ðŸ”´ [DIAGNOSTIC] intelligenceState: isInitialized=${intelligenceState.isInitialized}, isAnalyzing=${intelligenceState.isAnalyzing}');
    print(
        'ðŸ”´ [DIAGNOSTIC] intelligenceState.plantConditions.length=${intelligenceState.plantConditions.length}');
    print(
        'ðŸ”´ [DIAGNOSTIC] intelligenceState.plantRecommendations.length=${intelligenceState.plantRecommendations.length}');
    print(
        'ðŸ”´ [DIAGNOSTIC] intelligenceState.activePlantIds=${intelligenceState.activePlantIds}');
    developer.log(
      'ðŸ”´ BUILD STATE - plantConditions.length=${intelligenceState.plantConditions.length}, activePlantIds=${intelligenceState.activePlantIds.length}',
      name: 'PlantIntelligenceDashboard',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intelligence VÃ©gÃ©tale'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          // ðŸ”¥ NOUVEAU - Bouton RafraÃ®chir pour forcer la synchronisation
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: _isRefreshing
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            tooltip: 'RafraÃ®chir l\'analyse',
            onPressed: _isRefreshing
                ? null
                : () async {
                    setState(() => _isRefreshing = true);

                    developer.log('ðŸ”„ UI - RafraÃ®chissement manuel demandÃ©',
                        name: 'PlantIntelligenceDashboard');
                    print('ðŸ”´ [DIAGNOSTIC] RafraÃ®chissement manuel dÃ©clenchÃ©');

                    // RÃ©cupÃ©rer le jardin actuel
                    final gardenState = ref.read(gardenProvider);
                    if (gardenState.gardens.isNotEmpty) {
                      final gardenId = gardenState.gardens.first.id;

                      developer.log(
                          'ðŸ”„ UI - Invalidation des caches pour gardenId=$gardenId',
                          name: 'PlantIntelligenceDashboard');

                      // Invalider les providers dÃ©pendants
                      ref.invalidate(unifiedGardenContextProvider(gardenId));
                      ref.invalidate(gardenActivePlantsProvider(gardenId));
                      ref.invalidate(gardenStatsProvider(gardenId));
                      ref.invalidate(gardenActivitiesProvider(gardenId));

                      // RÃ©-initialiser l'intelligence (force la synchronisation)
                      developer.log(
                          'ðŸ”„ UI - RÃ©-initialisation de l\'intelligence',
                          name: 'PlantIntelligenceDashboard');
                      await ref
                          .read(intelligenceStateProvider(gardenId).notifier)
                          .initializeForGarden();

                      developer.log('âœ… UI - RafraÃ®chissement terminÃ©',
                          name: 'PlantIntelligenceDashboard');
                      print(
                          'ðŸ”´ [DIAGNOSTIC] RafraÃ®chissement terminÃ© avec succÃ¨s');
                    } else {
                      developer.log(
                          'âš ï¸ UI - Aucun jardin trouvÃ© pour rafraÃ®chir',
                          name: 'PlantIntelligenceDashboard');
                    }

                    setState(() => _isRefreshing = false);
                  },
          ),
          // âœ… NOUVEAU - Phase 3 : SÃ©lecteur de mode de vue
          Consumer(
            builder: (context, ref, _) {
              final viewMode = ref.watch(ui_intel.viewModeProvider);
              return PopupMenuButton<ui_intel.ViewMode>(
                icon: Icon(
                  viewMode == ui_intel.ViewMode.dashboard
                      ? Icons.dashboard
                      : Icons.view_list,
                  size: 24,
                ),
                tooltip: 'Mode d\'affichage',
                onSelected: (mode) {
                  ref.read(ui_intel.viewModeProvider.notifier).state = mode;
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ui_intel.ViewMode.dashboard,
                    child: Row(
                      children: [
                        Icon(
                          Icons.dashboard,
                          size: 20,
                          color: viewMode == ui_intel.ViewMode.dashboard
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: viewMode == ui_intel.ViewMode.dashboard
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: viewMode == ui_intel.ViewMode.dashboard
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ui_intel.ViewMode.list,
                    child: Row(
                      children: [
                        Icon(
                          Icons.view_list,
                          size: 20,
                          color: viewMode == ui_intel.ViewMode.list
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Liste',
                          style: TextStyle(
                            color: viewMode == ui_intel.ViewMode.list
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: viewMode == ui_intel.ViewMode.list
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ui_intel.ViewMode.grid,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_view,
                          size: 20,
                          color: viewMode == ui_intel.ViewMode.grid
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Grille',
                          style: TextStyle(
                            color: viewMode == ui_intel.ViewMode.grid
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: viewMode == ui_intel.ViewMode.grid
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Badge de notifications (Mobile First)
          Consumer(
            builder: (context, ref, _) {
              final unreadCountAsync =
                  ref.watch(unreadNotificationCountProvider);
              return unreadCountAsync.when(
                data: (count) => IconButton(
                  icon: Badge(
                    label: count > 0 ? Text('$count') : null,
                    isLabelVisible: count > 0,
                    child: const Icon(Icons.notifications),
                  ),
                  onPressed: () => context.push(AppRoutes.notifications),
                  tooltip: 'Notifications',
                  iconSize: 24,
                ),
                loading: () => IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push(AppRoutes.notifications),
                  tooltip: 'Notifications',
                  iconSize: 24,
                ),
                error: (_, __) => IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push(AppRoutes.notifications),
                  tooltip: 'Notifications',
                  iconSize: 24,
                ),
              );
            },
          ),
          // Indicateur de rafraÃ®chissement avec animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isRefreshing
                ? const Center(
                    key: ValueKey('loading'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : IconButton(
                    key: const ValueKey('refresh_button'),
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Actualiser les donnÃ©es',
                  ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/intelligence-settings');
            },
            icon: const Icon(Icons.settings),
            tooltip: 'ParamÃ¨tres',
          ),
        ],
      ),
      body: _buildBody(
          theme, intelligenceState, alertsState, ref.watch(ui_intel.viewModeProvider)),
      floatingActionButton: _buildFAB(intelligenceState),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    IntelligenceState intelligenceState,
    IntelligentAlertsState alertsState,
    ui_intel.ViewMode viewMode,
  ) {
    // Ã‰tat d'erreur
    if (intelligenceState.error != null) {
      return _buildErrorState(theme, intelligenceState.error!);
    }

    // Ã‰tat de chargement initial
    if (!intelligenceState.isInitialized) {
      return _buildLoadingState(theme);
    }

    // âœ… NOUVEAU - Phase 3 : Affichage selon le mode de vue sÃ©lectionnÃ©
    switch (viewMode) {
      case ui_intel.ViewMode.list:
        return _buildListView(theme, intelligenceState, alertsState);
      case ui_intel.ViewMode.grid:
        return _buildGridView(theme, intelligenceState, alertsState);
      case ui_intel.ViewMode.dashboard:
      default:
        return _buildDashboardView(theme, intelligenceState, alertsState);
    }
  }

  /// Vue Dashboard (par dÃ©faut)
  Widget _buildDashboardView(
    ThemeData theme,
    IntelligenceState intelligenceState,
    IntelligentAlertsState alertsState,
  ) {
    // Ã‰tat principal avec RefreshIndicator
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tÃªte
            _buildHeader(theme, intelligenceState),
            const SizedBox(height: 24),

            // Message si aucune plante analysÃ©e
            if (intelligenceState.plantConditions.isEmpty) ...[
              _buildEmptyConditionsCard(theme),
              const SizedBox(height: 24),
            ],

            // Statistiques rapides
            _buildQuickStats(theme, intelligenceState),
            const SizedBox(height: 24),

            // âœ… NOUVEAU - Phase 3 : Graphiques radar des conditions
            if (intelligenceState.plantConditions.isNotEmpty) ...[
              _buildConditionRadarSection(theme, intelligenceState),
              const SizedBox(height: 24),
            ],

            // âœ… NOUVEAU - Phase 3 : Statistiques avancÃ©es
            if (intelligenceState.plantConditions.isNotEmpty) ...[
              _buildAdvancedStatsSection(theme, intelligenceState),
              const SizedBox(height: 24),
            ],

            // Alertes
            if (alertsState.activeAlerts.isNotEmpty) ...[
              _buildAlertsSection(theme, alertsState),
              const SizedBox(height: 24),
            ],

            // Actions rapides (Lutte Biologique - Mobile First)
            _buildQuickActionsSection(context, theme),
            const SizedBox(height: 24),

            // Recommandations
            _buildRecommendationsSection(theme, intelligenceState),
            const SizedBox(height: 24),

            // âœ… NOUVEAU - Phase 1 : Timing de Plantation
            _buildPlantingTimingSection(theme, intelligenceState),
            const SizedBox(height: 24),

            // âœ… NOUVEAU - Phase 1 : DÃ©tails des Analyses
            _buildAnalysisDetailsSection(theme, intelligenceState),
          ],
        ),
      ),
    );
  }

  /// âœ… NOUVEAU - Phase 3 : Vue Liste
  Widget _buildListView(
    ThemeData theme,
    IntelligenceState intelligenceState,
    IntelligentAlertsState alertsState,
  ) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: intelligenceState.plantConditions.isEmpty
          ? _buildEmptyStateWithAction(theme, 'Aucune condition analysÃ©e',
              'Cliquez sur le bouton "Analyser" pour commencer')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: intelligenceState.plantConditions.length,
              itemBuilder: (context, index) {
                final condition =
                    intelligenceState.plantConditions.values.elementAt(index);
                final recommendations =
                    intelligenceState.plantRecommendations[condition.plantId] ??
                        [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _getHealthColor(condition.healthScore)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getConditionIcon(condition.type),
                            color: _getHealthColor(condition.healthScore),
                            size: 24,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${condition.healthScore.toStringAsFixed(0)}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getHealthColor(condition.healthScore),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      _getConditionLabel(condition.type),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${condition.value.toStringAsFixed(1)} ${condition.unit}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          condition.statusName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getHealthColor(condition.healthScore),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (recommendations.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${recommendations.length} recommandation(s)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
    );
  }

  /// âœ… NOUVEAU - Phase 3 : Vue Grille
  Widget _buildGridView(
    ThemeData theme,
    IntelligenceState intelligenceState,
    IntelligentAlertsState alertsState,
  ) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: intelligenceState.plantConditions.isEmpty
          ? _buildEmptyStateWithAction(theme, 'Aucune condition analysÃ©e',
              'Cliquez sur le bouton "Analyser" pour commencer')
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: intelligenceState.plantConditions.length,
              itemBuilder: (context, index) {
                final condition =
                    intelligenceState.plantConditions.values.elementAt(index);

                return Card(
                  child: InkWell(
                    onTap: () {
                      // Navigation vers dÃ©tails (Ã  implÃ©menter)
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getConditionIcon(condition.type),
                            size: 40,
                            color: _getHealthColor(condition.healthScore),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getConditionLabel(condition.type),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${condition.value.toStringAsFixed(1)} ${condition.unit}',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getHealthColor(condition.healthScore)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${condition.healthScore.toStringAsFixed(0)}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getHealthColor(condition.healthScore),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  /// Message d'Ã©tat vide avec action
  Widget _buildEmptyStateWithAction(
      ThemeData theme, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _analyzeAllPlants,
              icon: const Icon(Icons.analytics),
              label: const Text('Analyser Maintenant'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Carte pour inciter Ã  l'analyse
  Widget _buildEmptyConditionsCard(ThemeData theme) {
    return Card(
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aucune analyse disponible',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cliquez sur le bouton "Analyser" en bas Ã  droite pour commencer l\'analyse de vos plantes.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Semantics(
        label: 'Chargement des donnÃ©es d\'intelligence vÃ©gÃ©tale',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Initialisation de l\'intelligence vÃ©gÃ©tale...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                final currentGardenId =
                    ref.read(core_intel.currentIntelligenceGardenIdProvider);
                if (currentGardenId != null) {
                  ref
                      .read(intelligenceStateProvider(currentGardenId).notifier)
                      .clearError();
                }
                _initializeIntelligence();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('RÃ©essayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFAB(IntelligenceState intelligenceState) {
    print(
        'ðŸ”´ [DIAGNOSTIC] _buildFAB appelÃ©: isInitialized=${intelligenceState.isInitialized}');
    if (!intelligenceState.isInitialized) {
      print('ðŸ”´ [DIAGNOSTIC] FAB NON AFFICHÃ‰ car isInitialized=false');
      return null;
    }

    print('ðŸ”´ [DIAGNOSTIC] FAB AFFICHÃ‰');
    return FloatingActionButton.extended(
      onPressed: intelligenceState.isAnalyzing
          ? null
          : () {
              print('ðŸ”´ [DIAGNOSTIC] FAB CLIQUÃ‰ - Appel _analyzeAllPlants');
              _analyzeAllPlants();
            },
      icon: intelligenceState.isAnalyzing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.analytics),
      label: Text(intelligenceState.isAnalyzing ? 'Analyse...' : 'Analyser'),
    );
  }

  Widget _buildHeader(ThemeData theme, IntelligenceState intelligenceState) {
    final lastAnalysisText = intelligenceState.lastAnalysis != null
        ? 'DerniÃ¨re analyse: ${_formatRelativeTime(intelligenceState.lastAnalysis!)}'
        : 'Aucune analyse rÃ©cente';

    return Semantics(
      header: true,
      label: 'En-tÃªte Intelligence VÃ©gÃ©tale',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intelligence VÃ©gÃ©tale',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        intelligenceState.currentGarden?.name ??
                            'Analyse intelligente de vos plantes',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (intelligenceState.lastAnalysis != null) ...[
              const SizedBox(height: 12),
              Divider(color: theme.colorScheme.outline.withOpacity(0.2)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lastAnalysisText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Ã€ l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return 'Il y a plus d\'une semaine';
    }
  }

  Widget _buildQuickStats(
      ThemeData theme, IntelligenceState intelligenceState) {
    final plantsCount = intelligenceState.plantConditions.length;
    final recommendationsCount = intelligenceState.plantRecommendations.values
        .fold<int>(0, (sum, recs) => sum + recs.length);
    final alertsCount =
        ref.watch(core_intel.intelligentAlertsProvider).activeAlerts.length;
    final averageScore = _calculateAverageHealthScore(intelligenceState);

    // ðŸ”´ DIAGNOSTIC UI - VÃ©rifier les valeurs affichÃ©es
    print('ðŸ”´ [DIAGNOSTIC UI] _buildQuickStats appelÃ©:');
    print(
        'ðŸ”´ [DIAGNOSTIC UI]   plantsCount = $plantsCount (depuis intelligenceState.plantConditions.length)');
    print('ðŸ”´ [DIAGNOSTIC UI]   recommendationsCount = $recommendationsCount');
    print('ðŸ”´ [DIAGNOSTIC UI]   averageScore = $averageScore');
    print(
        'ðŸ”´ [DIAGNOSTIC UI]   plantConditions.keys = ${intelligenceState.plantConditions.keys.toList()}');
    print('[UI] score=$averageScore, plants=$plantsCount');
    developer.log(
      'ðŸ”´ UI STATS - plantsCount=$plantsCount, recommendationsCount=$recommendationsCount, averageScore=$averageScore',
      name: 'PlantIntelligenceDashboard',
    );

    return Semantics(
      label:
          'Statistiques rapides: $plantsCount plantes analysÃ©es, $recommendationsCount recommandations, $alertsCount alertes actives, Score moyen de $averageScore pourcent',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive: 2 colonnes sur mobile, 4 sur tablette+
              final isWide = constraints.maxWidth > 600;

              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                        child: _buildStatCard(
                            theme,
                            'Plantes analysÃ©es',
                            '$plantsCount',
                            Icons.local_florist,
                            theme.colorScheme.primary)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildStatCard(
                            theme,
                            'Recommandations',
                            '$recommendationsCount',
                            Icons.lightbulb,
                            theme.colorScheme.secondary)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildStatCard(
                            theme,
                            'Alertes actives',
                            '$alertsCount',
                            Icons.warning,
                            theme.colorScheme.error)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildStatCard(
                            theme,
                            'Score moyen',
                            '$averageScore%',
                            Icons.trending_up,
                            theme.colorScheme.tertiary)),
                  ],
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              theme,
                              'Plantes analysÃ©es',
                              '$plantsCount',
                              Icons.local_florist,
                              theme.colorScheme.primary)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(
                              theme,
                              'Recommandations',
                              '$recommendationsCount',
                              Icons.lightbulb,
                              theme.colorScheme.secondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              theme,
                              'Alertes actives',
                              '$alertsCount',
                              Icons.warning,
                              theme.colorScheme.error)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(
                              theme,
                              'Score moyen',
                              '$averageScore%',
                              Icons.trending_up,
                              theme.colorScheme.tertiary)),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  int _calculateAverageHealthScore(IntelligenceState intelligenceState) {
    if (intelligenceState.plantConditions.isEmpty) return 0;

    final totalScore = intelligenceState.plantConditions.values
        .fold<double>(0.0, (sum, condition) => sum + condition.healthScore);

    return (totalScore / intelligenceState.plantConditions.length).round();
  }

  Widget _buildStatCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Semantics(
      label: '$title: $value',
      button: false,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsSection(
      ThemeData theme, IntelligentAlertsState alertsState) {
    return Semantics(
      label: 'Section des alertes actives',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alertes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (alertsState.activeAlerts.length > 3)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to alerts screen
                  },
                  child: const Text('Voir tout'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(
                  alertsState.activeAlerts.length.clamp(0, 3),
                  (index) {
                    final alert = alertsState.activeAlerts[index];
                    return Column(
                      children: [
                        if (index > 0) const Divider(),
                        _buildAlertItem(
                          theme,
                          alert.title,
                          alert.message,
                          _getAlertIcon(alert.type),
                          _getAlertColor(theme, alert.severity),
                          onDismiss: () => ref
                              .read(core_intel.intelligentAlertsProvider.notifier)
                              .dismissAlert(alert.id),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAlertIcon(NotificationType type) {
    switch (type) {
      case NotificationType.weatherAlert:
        return Icons.wb_sunny;
      case NotificationType.plantCondition:
        return Icons.eco;
      case NotificationType.recommendation:
        return Icons.lightbulb;
      case NotificationType.reminder:
        return Icons.notifications;
      case NotificationType.criticalCondition:
        return Icons.warning;
      case NotificationType.optimalCondition:
        return Icons.check_circle;
      default:
        return Icons.warning;
    }
  }

  Color _getAlertColor(ThemeData theme, AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.error:
        return theme.colorScheme.error;
      case AlertSeverity.warning:
        return Colors.orange;
      case AlertSeverity.info:
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.secondary;
    }
  }

  Widget _buildAlertItem(
    ThemeData theme,
    String title,
    String description,
    IconData icon,
    Color color, {
    VoidCallback? onDismiss,
  }) {
    return Semantics(
      label: 'Alerte: $title. $description',
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Ignorer l\'alerte',
              )
            else
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                tooltip: 'Voir les dÃ©tails',
              ),
          ],
        ),
      ),
    );
  }

  /// âœ… NOUVEAU - Phase 3 : Section graphiques radar des conditions
  ///
  /// Affiche visuellement les 4 conditions principales (tempÃ©rature, humiditÃ©, lumiÃ¨re, sol)
  /// sous forme de graphiques radar compacts et mobile-friendly.
  Widget _buildConditionRadarSection(
      ThemeData theme, IntelligenceState intelligenceState) {
    // Obtenir les conditions groupÃ©es par type
    final conditionsByType = <ConditionType, List<PlantCondition>>{};
    for (final condition in intelligenceState.plantConditions.values) {
      conditionsByType.putIfAbsent(condition.type, () => []).add(condition);
    }

    // Types de conditions Ã  afficher dans l'ordre
    final conditionTypes = [
      ConditionType.temperature,
      ConditionType.humidity,
      ConditionType.light,
      ConditionType.soil,
    ];

    // Filtrer seulement les types qui ont des donnÃ©es
    final availableTypes = conditionTypes
        .where((type) => conditionsByType.containsKey(type))
        .toList();

    if (availableTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Section graphiques des conditions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Conditions Actuelles',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Toggle pour afficher/masquer les graphiques
              Consumer(
                builder: (context, ref, _) {
                  final chartSettings = ref.watch(ui_intel.chartSettingsProvider);
                  return IconButton(
                    onPressed: () {
                      ref.read(ui_intel.chartSettingsProvider.notifier).toggleTrends();
                    },
                    icon: Icon(
                      chartSettings.showTrends
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                    ),
                    tooltip: chartSettings.showTrends
                        ? 'Masquer les graphiques'
                        : 'Afficher les graphiques',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, _) {
              final chartSettings = ref.watch(ui_intel.chartSettingsProvider);

              if (!chartSettings.showTrends) {
                // Affichage compact sans graphiques
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: availableTypes.map((type) {
                        final conditions = conditionsByType[type]!;
                        final avgScore = conditions.fold<double>(
                                0.0, (sum, c) => sum + c.healthScore) /
                            conditions.length;

                        return Column(
                          children: [
                            Icon(
                              _getConditionIcon(type),
                              size: 24,
                              color: _getHealthColor(avgScore),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${avgScore.toStringAsFixed(0)}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getHealthColor(avgScore),
                              ),
                            ),
                            Text(
                              _getConditionLabel(type),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }

              // Affichage avec graphiques radar
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive: 2 colonnes sur mobile, 4 sur tablette+
                  final isWide = constraints.maxWidth > 600;
                  final itemsPerRow = isWide ? 4 : 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: availableTypes.map((type) {
                      final conditions = conditionsByType[type]!;
                      // Prendre la condition la plus rÃ©cente de ce type
                      final mostRecent = conditions.reduce(
                          (a, b) => a.measuredAt.isAfter(b.measuredAt) ? a : b);

                      return SizedBox(
                        width: isWide
                            ? (constraints.maxWidth - 36) / 4
                            : (constraints.maxWidth - 12) / 2,
                        child: ConditionRadarChartSimple(
                          plantCondition: mostRecent,
                          size: isWide ? 160 : 140,
                          showLabels: true,
                          showAnimation: true,
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getConditionIcon(ConditionType type) {
    switch (type) {
      case ConditionType.temperature:
        return Icons.thermostat;
      case ConditionType.humidity:
        return Icons.water_drop;
      case ConditionType.light:
        return Icons.light_mode;
      case ConditionType.soil:
        return Icons.terrain;
      case ConditionType.wind:
        return Icons.air;
      case ConditionType.water:
        return Icons.water;
    }
  }

  String _getConditionLabel(ConditionType type) {
    switch (type) {
      case ConditionType.temperature:
        return 'Temp.';
      case ConditionType.humidity:
        return 'Humid.';
      case ConditionType.light:
        return 'LumiÃ¨re';
      case ConditionType.soil:
        return 'Sol';
      case ConditionType.wind:
        return 'Vent';
      case ConditionType.water:
        return 'Eau';
    }
  }

  /// âœ… NOUVEAU - Phase 3 : Section statistiques avancÃ©es
  ///
  /// Affiche des statistiques dÃ©taillÃ©es et tendances sur la santÃ© du jardin.
  Widget _buildAdvancedStatsSection(
      ThemeData theme, IntelligenceState intelligenceState) {
    // Calculer statistiques avancÃ©es
    final totalConditions = intelligenceState.plantConditions.length;
    final excellentCount = intelligenceState.plantConditions.values
        .where((c) => c.status == ConditionStatus.excellent)
        .length;
    final goodCount = intelligenceState.plantConditions.values
        .where((c) => c.status == ConditionStatus.good)
        .length;
    final fairCount = intelligenceState.plantConditions.values
        .where((c) => c.status == ConditionStatus.fair)
        .length;
    final poorCount = intelligenceState.plantConditions.values
        .where((c) => c.status == ConditionStatus.poor)
        .length;
    final criticalCount = intelligenceState.plantConditions.values
        .where((c) => c.status == ConditionStatus.critical)
        .length;

    return Semantics(
      label: 'Section statistiques avancÃ©es',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statistiques DÃ©taillÃ©es',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Afficher aide/informations sur les statistiques
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('ðŸ“Š Statistiques'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'Les statistiques vous donnent une vue d\'ensemble de l\'Ã©tat '
                          'de santÃ© de toutes les conditions de vos plantes.\n\n'
                          'â€¢ Excellent : Conditions optimales\n'
                          'â€¢ Bon : Conditions favorables\n'
                          'â€¢ Moyen : Conditions acceptables\n'
                          'â€¢ Faible : Conditions Ã  surveiller\n'
                          'â€¢ Critique : Action immÃ©diate requise\n\n'
                          'Utilisez ces informations pour prioriser vos actions.',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fermer'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.help_outline, size: 20),
                tooltip: 'Aide sur les statistiques',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RÃ©partition de la santÃ©',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Barre de progression empilÃ©e
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 32,
                      child: Row(
                        children: [
                          if (excellentCount > 0)
                            Expanded(
                              flex: excellentCount,
                              child: Container(
                                color: Colors.green,
                                alignment: Alignment.center,
                                child: Text(
                                  '$excellentCount',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (goodCount > 0)
                            Expanded(
                              flex: goodCount,
                              child: Container(
                                color: Colors.lightGreen,
                                alignment: Alignment.center,
                                child: Text(
                                  '$goodCount',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (fairCount > 0)
                            Expanded(
                              flex: fairCount,
                              child: Container(
                                color: Colors.orange,
                                alignment: Alignment.center,
                                child: Text(
                                  '$fairCount',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (poorCount > 0)
                            Expanded(
                              flex: poorCount,
                              child: Container(
                                color: Colors.deepOrange,
                                alignment: Alignment.center,
                                child: Text(
                                  '$poorCount',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (criticalCount > 0)
                            Expanded(
                              flex: criticalCount,
                              child: Container(
                                color: Colors.red,
                                alignment: Alignment.center,
                                child: Text(
                                  '$criticalCount',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // LÃ©gende
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (excellentCount > 0)
                        _buildLegendItem(
                            theme, 'Excellent', excellentCount, Colors.green),
                      if (goodCount > 0)
                        _buildLegendItem(
                            theme, 'Bon', goodCount, Colors.lightGreen),
                      if (fairCount > 0)
                        _buildLegendItem(
                            theme, 'Moyen', fairCount, Colors.orange),
                      if (poorCount > 0)
                        _buildLegendItem(
                            theme, 'Faible', poorCount, Colors.deepOrange),
                      if (criticalCount > 0)
                        _buildLegendItem(
                            theme, 'Critique', criticalCount, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                      color: theme.colorScheme.outline.withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$totalConditions conditions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      ThemeData theme, String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(
      ThemeData theme, IntelligenceState intelligenceState) {
    // Obtenir toutes les recommandations
    final allRecommendations = intelligenceState.plantRecommendations.values
        .expand((recs) => recs)
        .take(3)
        .toList();

    return Semantics(
      label: 'Section des recommandations',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommandations',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (intelligenceState.plantRecommendations.values
                      .expand((r) => r)
                      .length >
                  3)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/recommendations');
                  },
                  child: const Text('Voir tout'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (allRecommendations.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aucune recommandation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vos plantes sont en bonne santÃ© !',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(
                    allRecommendations.length,
                    (index) {
                      final rec = allRecommendations[index];
                      return Column(
                        children: [
                          if (index > 0) const Divider(),
                          _buildRecommendationItem(
                            theme,
                            rec.title,
                            rec.description,
                            _getRecommendationIcon(rec.type.name),
                            priority: rec.priority.name,
                            onComplete: () {
                              ref
                                  .read(core_intel.contextualRecommendationsProvider
                                      .notifier)
                                  .applyRecommendation(rec.id);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getRecommendationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.grass;
      case 'protection':
        return Icons.shield;
      case 'pruning':
        return Icons.content_cut;
      case 'planting':
        return Icons.eco;
      default:
        return Icons.lightbulb;
    }
  }

  Widget _buildRecommendationItem(
    ThemeData theme,
    String title,
    String description,
    IconData icon, {
    String? priority,
    VoidCallback? onComplete,
  }) {
    final priorityColor = _getPriorityColor(theme, priority);

    return Semantics(
      label: 'Recommandation: $title. $description',
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (priority != null && priority.toLowerCase() == 'high')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Urgent',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: priorityColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onComplete ?? () {},
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'Marquer comme fait',
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(ThemeData theme, String? priority) {
    if (priority == null) return theme.colorScheme.primary;

    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return theme.colorScheme.error;
      case 'medium':
        return Colors.orange;
      case 'low':
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.primary;
    }
  }

  /// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
  /// Section affichant le timing de plantation pour les plantes du jardin
  ///
  /// Affiche le PlantingTimingEvaluation de chaque plante si disponible
  Widget _buildPlantingTimingSection(
      ThemeData theme, IntelligenceState intelligenceState) {
    return FutureBuilder<List<PlantIntelligenceReport>>(
      future: _getReportsWithTiming(intelligenceState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final reportsWithTiming =
            snapshot.data!.where((r) => r.plantingTiming != null).toList();

        if (reportsWithTiming.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Timing de Plantation',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (reportsWithTiming.length > 3)
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to full timing screen
                    },
                    child: const Text('Voir tout'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ...reportsWithTiming.take(3).map(
                  (report) => _buildPlantingTimingCard(theme, report),
                ),
          ],
        );
      },
    );
  }

  /// RÃ©cupÃ¨re les rapports avec timing de plantation
  Future<List<PlantIntelligenceReport>> _getReportsWithTiming(
      IntelligenceState state) async {
    if (state.currentGardenId == null || state.activePlantIds.isEmpty) {
      return [];
    }

    try {
      final reports = <PlantIntelligenceReport>[];

      // RÃ©cupÃ©rer le rapport pour chaque plante active (max 5 pour Ã©viter surcharge)
      for (final plantId in state.activePlantIds.take(5)) {
        try {
          final report = await ref.read(
            generateIntelligenceReportProvider((
              plantId: plantId,
              gardenId: state.currentGardenId!,
            )).future,
          );

          if (report.plantingTiming != null) {
            reports.add(report);
          }
        } catch (e) {
          developer.log('Erreur rÃ©cupÃ©ration rapport $plantId: $e',
              name: 'Dashboard');
          // Continue avec les autres plantes
        }
      }

      return reports;
    } catch (e) {
      developer.log('Erreur rÃ©cupÃ©ration rapports timing: $e',
          name: 'Dashboard');
      return [];
    }
  }

  /// Carte affichant le timing de plantation pour une plante
  Widget _buildPlantingTimingCard(
      ThemeData theme, PlantIntelligenceReport report) {
    final timing = report.plantingTiming!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tÃªte avec plante et score
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTimingScoreColor(timing.timingScore)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    timing.isOptimalTime ? Icons.check_circle : Icons.schedule,
                    color: _getTimingScoreColor(timing.timingScore),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.plantName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timing.isOptimalTime
                            ? 'C\'est le bon moment !'
                            : 'Attendre meilleur moment',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getTimingScoreColor(timing.timingScore),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Score badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTimingScoreColor(timing.timingScore)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${timing.timingScore.toInt()}/100',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getTimingScoreColor(timing.timingScore),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Raison
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timing.reason,
                style: theme.textTheme.bodySmall,
              ),
            ),

            // Facteurs favorables et dÃ©favorables
            if (timing.favorableFactors.isNotEmpty ||
                timing.unfavorableFactors.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (timing.favorableFactors.isNotEmpty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.add_circle,
                                  color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Favorable',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...timing.favorableFactors.take(2).map(
                                (factor) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 2),
                                  child: Text(
                                    'â€¢ ${factor.length > 30 ? '${factor.substring(0, 30)}...' : factor}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  if (timing.favorableFactors.isNotEmpty &&
                      timing.unfavorableFactors.isNotEmpty)
                    const SizedBox(width: 12),
                  if (timing.unfavorableFactors.isNotEmpty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.remove_circle,
                                  color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'DÃ©favorable',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...timing.unfavorableFactors.take(2).map(
                                (factor) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 2),
                                  child: Text(
                                    'â€¢ ${factor.length > 30 ? '${factor.substring(0, 30)}...' : factor}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                ],
              ),
            ],

            // Date optimale si diffÃ©rÃ©e
            if (!timing.isOptimalTime &&
                timing.optimalPlantingDate != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Date optimale : ${_formatDate(timing.optimalPlantingDate!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Risques si prÃ©sents
            if (timing.risks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risques :',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...timing.risks.take(2).map(
                                (risk) => Text(
                                  'â€¢ $risk',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper : Couleur selon le score de timing
  Color _getTimingScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  /// Helper : Formater une date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
  /// Section affichant les dÃ©tails des analyses (warnings, strengths, actions prioritaires)
  ///
  /// Expose les donnÃ©es dÃ©taillÃ©es de PlantAnalysisResult qui Ã©taient cachÃ©es
  Widget _buildAnalysisDetailsSection(
      ThemeData theme, IntelligenceState intelligenceState) {
    return FutureBuilder<List<PlantIntelligenceReport>>(
      future: _getReportsWithDetails(intelligenceState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final reportsWithDetails = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DÃ©tails des Analyses',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...reportsWithDetails.take(3).map(
                  (report) => _buildAnalysisDetailCard(theme, report),
                ),
          ],
        );
      },
    );
  }

  /// RÃ©cupÃ¨re les rapports avec dÃ©tails d'analyse
  Future<List<PlantIntelligenceReport>> _getReportsWithDetails(
      IntelligenceState state) async {
    if (state.currentGardenId == null || state.activePlantIds.isEmpty) {
      return [];
    }

    try {
      final reports = <PlantIntelligenceReport>[];

      // RÃ©cupÃ©rer le rapport pour chaque plante active (max 3 pour UI)
      for (final plantId in state.activePlantIds.take(3)) {
        try {
          final report = await ref.read(
            generateIntelligenceReportProvider((
              plantId: plantId,
              gardenId: state.currentGardenId!,
            )).future,
          );

          // Inclure seulement si des dÃ©tails existent
          if (report.analysis.warnings.isNotEmpty ||
              report.analysis.strengths.isNotEmpty ||
              report.analysis.priorityActions.isNotEmpty) {
            reports.add(report);
          }
        } catch (e) {
          developer.log('Erreur rÃ©cupÃ©ration dÃ©tails $plantId: $e',
              name: 'Dashboard');
        }
      }

      return reports;
    } catch (e) {
      developer.log('Erreur rÃ©cupÃ©ration dÃ©tails analyses: $e',
          name: 'Dashboard');
      return [];
    }
  }

  /// Carte affichant les dÃ©tails d'une analyse
  Widget _buildAnalysisDetailCard(
      ThemeData theme, PlantIntelligenceReport report) {
    final analysis = report.analysis;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Icon(
              Icons.analytics,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                report.plantName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text('Score: ${analysis.healthScore.toInt()}/100'),
              const SizedBox(width: 16),
              Text('Confiance: ${(analysis.confidence * 100).toInt()}%'),
            ],
          ),
        ),
        children: [
          // Confiance (Barre de progression)
          Row(
            children: [
              Icon(
                Icons.speed,
                size: 18,
                color: _getConfidenceColor(analysis.confidence),
              ),
              const SizedBox(width: 8),
              Text(
                'Niveau de confiance:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: analysis.confidence,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(
                      _getConfidenceColor(analysis.confidence)),
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(analysis.confidence * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getConfidenceColor(analysis.confidence),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _getConfidenceExplanation(analysis.confidence),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Warnings (Avertissements)
          if (analysis.warnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Avertissements (${analysis.warnings.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...analysis.warnings.map((warning) => Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('â€¢ ',
                          style: TextStyle(color: Colors.orange, fontSize: 16)),
                      Expanded(
                        child: Text(
                          warning,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],

          // Strengths (Points forts)
          if (analysis.strengths.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Points Forts (${analysis.strengths.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...analysis.strengths.map((strength) => Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('â€¢ ',
                          style: TextStyle(color: Colors.green, fontSize: 16)),
                      Expanded(
                        child: Text(
                          strength,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],

          // Priority Actions (Actions prioritaires)
          if (analysis.priorityActions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.priority_high, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Actions Prioritaires (${analysis.priorityActions.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...analysis.priorityActions.map((action) => Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right,
                          color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          action,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  /// Helper : Couleur selon le niveau de confiance
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.85) return Colors.green;
    if (confidence >= 0.65) return Colors.lightGreen;
    if (confidence >= 0.50) return Colors.orange;
    return Colors.red;
  }

  /// Helper : Explication du niveau de confiance
  String _getConfidenceExplanation(double confidence) {
    if (confidence >= 0.85) return 'DonnÃ©es trÃ¨s rÃ©centes et fiables';
    if (confidence >= 0.65) return 'DonnÃ©es rÃ©centes';
    if (confidence >= 0.50) {
      return 'DonnÃ©es un peu anciennes, actualiser recommandÃ©';
    }
    return 'DonnÃ©es obsolÃ¨tes, actualisation nÃ©cessaire';
  }

  /// Section d'actions rapides pour la lutte biologique (Mobile First)
  Widget _buildQuickActionsSection(BuildContext context, ThemeData theme) {
    final currentGardenId = ref.watch(core_intel.currentIntelligenceGardenIdProvider);
    final gardenId = currentGardenId ?? '';
    final hasGarden = gardenId.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.flash_on,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Actions Rapides',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // Message si aucun jardin sÃ©lectionnÃ©
        if (!hasGarden)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'SÃ©lectionnez un jardin pour accÃ©der aux actions rapides',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Action 1 : Signaler un ravageur
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: hasGarden ? 2 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: hasGarden
                ? () {
                    context.push(
                      '${AppRoutes.pestObservation}?gardenId=$gardenId',
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // IcÃ´ne avec fond colorÃ©
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasGarden
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bug_report,
                      color: hasGarden ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Texte
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signaler un ravageur',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: hasGarden
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Identifiez et obtenez des recommandations de lutte biologique',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FlÃ¨che
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: hasGarden
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action 2 : Lutte biologique
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: hasGarden ? 2 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: hasGarden
                ? () {
                    context.push(
                      '${AppRoutes.bioControlRecommendations}?gardenId=$gardenId',
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // IcÃ´ne avec fond colorÃ©
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasGarden
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.eco,
                      color: hasGarden ? Colors.green : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Texte
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lutte biologique',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: hasGarden
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Consultez les auxiliaires et mÃ©thodes naturelles pour votre jardin',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FlÃ¨che
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: hasGarden
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action 3 : Historique d'Ã©volution
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: hasGarden ? 2 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: hasGarden
                ? () {
                    final currentGardenId = ref.read(core_intel.currentIntelligenceGardenIdProvider);
                    if (currentGardenId != null) {
                      final state = ref.read(intelligenceStateProvider(currentGardenId));
                      _showPlantSelectionForEvolution(context, state);
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // IcÃ´ne avec fond colorÃ©
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasGarden
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.timeline,
                      color: hasGarden ? Colors.blue : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Texte
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ðŸ“Š Historique d\'Ã©volution',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: hasGarden
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Consultez l\'Ã©volution de santÃ© de vos plantes au fil du temps',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FlÃ¨che
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: hasGarden
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                theme,
                'Analyser une plante',
                Icons.search,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                theme,
                'Voir l\'historique',
                Icons.history,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      final currentGardenId = ref.read(core_intel.currentIntelligenceGardenIdProvider);
      if (currentGardenId != null) {
        final intelligenceState =
            ref.read(intelligenceStateProvider(currentGardenId));

        await ref
            .read(intelligenceStateProvider(currentGardenId).notifier)
            .initializeForGarden();

        // RafraÃ®chir les analyses de toutes les plantes actives
        for (final plantId in intelligenceState.activePlantIds) {
          await ref
              .read(intelligenceStateProvider(currentGardenId).notifier)
              .analyzePlant(plantId);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('DonnÃ©es actualisÃ©es'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'actualisation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  /// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
  /// Analyse COMPLÃˆTE du jardin incluant lutte biologique
  ///
  /// Remplace l'analyse simple plante-par-plante par une analyse complÃ¨te
  /// utilisant `analyzeGardenWithBioControl()` de l'orchestrator.
  Future<void> _analyzeAllPlants() async {
    print('ðŸ”´ [DIAGNOSTIC] _analyzeAllPlants() DÃ‰BUT');
    developer.log('ðŸŒ± DÃ©but analyse COMPLÃˆTE du jardin', name: 'Dashboard');

    final gardenId = ref.read(core_intel.currentIntelligenceGardenIdProvider);
    print('ðŸ”´ [DIAGNOSTIC] gardenId=$gardenId');

    if (gardenId == null) {
      print('ðŸ”´ [DIAGNOSTIC] âŒ gardenId est NULL - ArrÃªt');
      developer.log('âŒ Aucun jardin sÃ©lectionnÃ©', name: 'Dashboard');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('âŒ Aucun jardin sÃ©lectionnÃ©'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    print('ðŸ”´ [DIAGNOSTIC] gardenId OK, lancement analyse...');

    try {
      // âœ… CORRECTION : Initialiser et invalider les providers AVANT l'analyse
      developer.log(
          'ðŸ” DIAGNOSTIC - Lancement analyse manuelle pour gardenId=$gardenId',
          name: 'Dashboard');
      developer.log(
          'ðŸ”„ Appel initializeForGarden pour invalider les providers...',
          name: 'Dashboard');

      await ref
          .read(intelligenceStateProvider(gardenId).notifier)
          .initializeForGarden();

      developer.log('âœ… Providers invalidÃ©s, lancement analyse complÃ¨te...',
          name: 'Dashboard');
      developer.log('ðŸ”„ Appel generateComprehensiveGardenAnalysisProvider...',
          name: 'Dashboard');

      // âœ… NOUVEAU : Analyse complÃ¨te incluant lutte biologique
      final comprehensiveAnalysis = await ref.read(
        generateComprehensiveGardenAnalysisProvider(gardenId).future,
      );

      developer.log('âœ… Analyse complÃ¨te terminÃ©e', name: 'Dashboard');
      developer.log(
          '  - ${comprehensiveAnalysis.plantReports.length} plantes analysÃ©es',
          name: 'Dashboard');
      developer.log(
          '  - ${comprehensiveAnalysis.pestThreats?.totalThreats ?? 0} menaces dÃ©tectÃ©es',
          name: 'Dashboard');
      developer.log(
          '  - ${comprehensiveAnalysis.bioControlRecommendations.length} recommandations bio',
          name: 'Dashboard');
      developer.log(
          '  - Score santÃ© global: ${comprehensiveAnalysis.overallHealthScore.toStringAsFixed(1)}%',
          name: 'Dashboard');

      if (mounted) {
        // Afficher rÃ©sultats dans un dialog/modal
        _showComprehensiveAnalysisResults(comprehensiveAnalysis);

        // Toast de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'âœ… Analyse complÃ¨te : ${comprehensiveAnalysis.plantReports.length} plantes, '
              '${comprehensiveAnalysis.pestThreats?.totalThreats ?? 0} menaces',
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'DÃ©tails',
              textColor: Colors.white,
              onPressed: () =>
                  _showComprehensiveAnalysisResults(comprehensiveAnalysis),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      developer.log('âŒ Erreur analyse complÃ¨te: $e',
          name: 'Dashboard', error: e, stackTrace: stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'analyse: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
  /// Affiche les rÃ©sultats de l'analyse complÃ¨te dans un bottom sheet modal
  ///
  /// PrÃ©sente de maniÃ¨re visuelle et accessible:
  /// - Score de santÃ© global du jardin
  /// - Statistiques (plantes, menaces, recommandations bio)
  /// - Liste des menaces dÃ©tectÃ©es
  /// - Liste des recommandations de lutte biologique
  void _showComprehensiveAnalysisResults(ComprehensiveGardenAnalysis analysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final theme = Theme.of(context);

          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                // En-tÃªte
                Text(
                  'ðŸŒ¿ Analyse ComplÃ¨te du Jardin',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'GÃ©nÃ©rÃ© le ${_formatDateTime(analysis.analyzedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 32),

                // Score global
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Score de SantÃ© Global',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: analysis.overallHealthScore / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation(
                              _getHealthColor(analysis.overallHealthScore)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${analysis.overallHealthScore.toStringAsFixed(1)} / 100',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getHealthColor(analysis.overallHealthScore),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Statistiques rapides
                Row(
                  children: [
                    Expanded(
                      child: _buildModalStatCard(
                        theme,
                        'Plantes',
                        '${analysis.plantReports.length}',
                        Icons.local_florist,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModalStatCard(
                        theme,
                        'Menaces',
                        '${analysis.pestThreats?.totalThreats ?? 0}',
                        Icons.bug_report,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalStatCard(
                        theme,
                        'Critiques',
                        '${analysis.pestThreats?.criticalThreats ?? 0}',
                        Icons.warning,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModalStatCard(
                        theme,
                        'Reco. Bio',
                        '${analysis.bioControlRecommendations.length}',
                        Icons.eco,
                        Colors.lightGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // RÃ©sumÃ©
                if (analysis.summary.isNotEmpty) ...[
                  Text('ðŸ“‹ RÃ©sumÃ©', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        analysis.summary,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Menaces dÃ©tectÃ©es
                if (analysis.pestThreats != null &&
                    analysis.pestThreats!.threats.isNotEmpty) ...[
                  Text('ðŸ› Menaces DÃ©tectÃ©es',
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...analysis.pestThreats!.threats.take(5).map((threat) => Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.bug_report,
                            color: _getThreatColor(threat.threatLevel),
                          ),
                          title: Text(threat.pest.name),
                          subtitle: Text(
                            '${threat.affectedPlant.commonName} - ${_getThreatLevelText(threat.threatLevel)}',
                          ),
                          trailing: Text(
                            'Impact: ${threat.impactScore?.toInt() ?? 0}/100',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getThreatColor(threat.threatLevel),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                ],

                // Recommandations bio
                if (analysis.bioControlRecommendations.isNotEmpty) ...[
                  Text('ðŸŒ¿ Recommandations Bio',
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...analysis.bioControlRecommendations
                      .take(5)
                      .map((rec) => Card(
                            child: ListTile(
                              leading: Icon(_getBioControlIcon(rec.type),
                                  color: Colors.green),
                              title: Text(rec.description),
                              subtitle: Text('${rec.actions.length} action(s)'),
                              trailing: Chip(
                                label:
                                    Text('${rec.effectivenessScore.toInt()}%'),
                                backgroundColor: Colors.green.shade100,
                              ),
                            ),
                          )),
                  const SizedBox(height: 16),
                ],

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                              '${AppRoutes.bioControlRecommendations}?gardenId=${analysis.gardenId}');
                        },
                        icon: const Icon(Icons.eco),
                        label: const Text('Lutte Biologique'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Fermer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helpers pour l'affichage des rÃ©sultats
  Color _getHealthColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _getThreatColor(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.critical:
        return Colors.red;
      case ThreatLevel.high:
        return Colors.orange;
      case ThreatLevel.moderate:
        return Colors.amber;
      case ThreatLevel.low:
        return Colors.green;
    }
  }

  String _getThreatLevelText(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.critical:
        return 'CRITIQUE';
      case ThreatLevel.high:
        return 'Ã‰levÃ©';
      case ThreatLevel.moderate:
        return 'ModÃ©rÃ©';
      case ThreatLevel.low:
        return 'Faible';
    }
  }

  IconData _getBioControlIcon(BioControlType type) {
    switch (type) {
      case BioControlType.introduceBeneficial:
        return Icons.pest_control;
      case BioControlType.plantCompanion:
        return Icons.local_florist;
      case BioControlType.createHabitat:
        return Icons.home;
      case BioControlType.culturalPractice:
        return Icons.agriculture;
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} Ã  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Helper : CrÃ©er une petite carte de statistique pour le modal
  /// (Version pour le modal, diffÃ©rente de celle du dashboard)
  Widget _buildModalStatCard(
      ThemeData theme, String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// âœ… CURSOR PROMPT A9 - SÃ©lection de plante pour l'historique d'Ã©volution
  ///
  /// Affiche un bottom sheet permettant de sÃ©lectionner une plante active
  /// pour consulter son historique d'Ã©volution
  void _showPlantSelectionForEvolution(
      BuildContext context, IntelligenceState intelligenceState) {
    final theme = Theme.of(context);
    final plantCatalogState = ref.read(plantCatalogProvider);

    // RÃ©cupÃ©rer les informations des plantes actives
    final activePlants = intelligenceState.activePlantIds
        .map((plantId) {
          try {
            final plant = plantCatalogState.plants.firstWhere(
              (p) => p.id == plantId,
            );
            return (plantId: plantId, plant: plant);
          } catch (e) {
            return null;
          }
        })
        .whereType<({String plantId, PlantFreezed plant})>()
        .toList();

    if (activePlants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune plante active trouvÃ©e pour l\'analyse'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tÃªte
                Row(
                  children: [
                    Icon(Icons.timeline,
                        color: theme.colorScheme.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Historique d\'Ã©volution',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'SÃ©lectionnez une plante',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Liste des plantes
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: activePlants.length,
                    itemBuilder: (context, index) {
                      final item = activePlants[index];
                      final plant = item.plant;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToEvolutionHistory(
                                context, item.plantId, plant.commonName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // IcÃ´ne de la plante
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.local_florist,
                                    color: theme.colorScheme.primary,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Informations de la plante
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plant.commonName,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (plant.scientificName.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          plant.scientificName,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // FlÃ¨che de navigation
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Navigation vers l'Ã©cran d'historique d'Ã©volution
  void _navigateToEvolutionHistory(
      BuildContext context, String plantId, String plantName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlantEvolutionHistoryScreen(
          plantId: plantId,
          plantName: plantName,
        ),
      ),
    );
  }
}

