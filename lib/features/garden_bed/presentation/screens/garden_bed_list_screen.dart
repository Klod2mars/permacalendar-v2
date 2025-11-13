import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../providers/garden_bed_provider.dart';
import '../widgets/garden_bed_card.dart';
import '../widgets/create_garden_bed_dialog.dart';
import '../widgets/germination_preview.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../planting/providers/planting_provider.dart';

class GardenBedListScreen extends ConsumerStatefulWidget {
  const GardenBedListScreen(
      {super.key, required this.gardenId, required this.gardenName});

  final String gardenId;
  final String gardenName;

  @override
  ConsumerState<GardenBedListScreen> createState() =>
      _GardenBedListScreenState();
}

class _GardenBedListScreenState extends ConsumerState<GardenBedListScreen> {
  String _searchQuery = '';
  String _selectedSoilType = '';
  String _selectedExposure = '';

  @override
  void initState() {
    super.initState();
    // Load garden beds when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gardenBedProvider.notifier).loadGardenBeds(widget.gardenId);
      // Charger toutes les plantations et le catalogue pour les prÃ©dictions
      ref.read(plantingProvider.notifier).loadAllPlantings();
      ref.read(plantCatalogProvider.notifier).loadPlants();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() {
    final plantingsState = ref.read(plantingProvider);

    // Recharger uniquement si nÃ©cessaire
    if (plantingsState.plantings.isEmpty && !plantingsState.isLoading) {
      ref.read(plantingProvider.notifier).loadAllPlantings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gardenBedState = ref.watch(gardenBedProvider);
    final gardenBeds = ref.watch(gardenBedsListProvider);
    final stats = ref.watch(gardenBedStatsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Parcelles - ${widget.gardenName}',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshGardenBeds(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 8),
                    Text('Statistiques'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Exporter'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildSearchAndFilters(theme),

          // Statistics Summary
          if (gardenBeds.isNotEmpty) _buildStatsSummary(stats, theme),

          // Garden Beds List
          Expanded(
            child: _buildGardenBedsList(gardenBedState, gardenBeds, theme),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _showCreateGardenBedDialog(),
        tooltip: 'Ajouter une parcelle',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndFilters(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher une parcelle...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color.fromRGBO(
                theme.colorScheme.surfaceContainerHighest.red,
                theme.colorScheme.surfaceContainerHighest.green,
                theme.colorScheme.surfaceContainerHighest.blue,
                0.3,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Tous les sols',
                  _selectedSoilType.isEmpty,
                  () => setState(() => _selectedSoilType = ''),
                  theme,
                ),
                const SizedBox(width: 8),
                ...['Argileux', 'Sableux', 'Limoneux', 'HumifÃ¨re'].map(
                  (soilType) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      soilType,
                      _selectedSoilType == soilType,
                      () => setState(() => _selectedSoilType = soilType),
                      theme,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildFilterChip(
                  'Toutes expositions',
                  _selectedExposure.isEmpty,
                  () => setState(() => _selectedExposure = ''),
                  theme,
                ),
                const SizedBox(width: 8),
                ...['Plein soleil', 'Mi-soleil', 'Mi-ombre', 'Ombre'].map(
                  (exposure) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      exposure,
                      _selectedExposure == exposure,
                      () => setState(() => _selectedExposure = exposure),
                      theme,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, bool isSelected, VoidCallback onTap, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : Color.fromRGBO(
                  theme.colorScheme.surfaceContainerHighest.red,
                  theme.colorScheme.surfaceContainerHighest.green,
                  theme.colorScheme.surfaceContainerHighest.blue,
                  0.5,
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Color.fromRGBO(
                    theme.colorScheme.outline.red,
                    theme.colorScheme.outline.green,
                    theme.colorScheme.outline.blue,
                    0.3,
                  ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary(Map<String, dynamic> stats, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Parcelles',
            '${stats['totalBeds']}',
            Icons.grid_view,
            theme,
          ),
          _buildStatItem(
            'Surface totale',
            '${stats['totalArea'].toStringAsFixed(1)} mÂ²',
            Icons.straighten,
            theme,
          ),
          _buildStatItem(
            'Moyenne',
            '${stats['averageArea'].toStringAsFixed(1)} mÂ²',
            Icons.analytics,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildGardenBedsList(
      dynamic gardenBedState, List gardenBeds, ThemeData theme) {
    if (gardenBedState.isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (gardenBedState.error != null) {
      return ErrorStateWidget(
        title: 'Erreur',
        subtitle: gardenBedState.error!,
        onRetry: () => _refreshGardenBeds(),
      );
    }

    final filteredGardenBeds = _filterGardenBeds(gardenBeds);

    if (filteredGardenBeds.isEmpty) {
      if (gardenBeds.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.grid_view,
          title: 'Aucune parcelle',
          subtitle: 'Commencez par crÃ©er votre premiÃ¨re parcelle de jardin.',
          actionText: 'CrÃ©er une parcelle',
          onAction: () => _showCreateGardenBedDialog(),
        );
      } else {
        return EmptyStateWidget(
          icon: Icons.search_off,
          title: 'Aucun rÃ©sultat',
          subtitle:
              'Aucune parcelle ne correspond Ã  vos critÃ¨res de recherche.',
          actionText: 'Effacer les filtres',
          onAction: () => _clearFilters(),
        );
      }
    }

    return RefreshIndicator(
      onRefresh: () => _refreshGardenBeds(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredGardenBeds.length,
        itemBuilder: (context, index) {
          final gardenBed = filteredGardenBeds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GardenBedCard(
              gardenBed: gardenBed,
              onTap: () => _navigateToGardenBedDetail(gardenBed),
              onEdit: () => _showEditGardenBedDialog(gardenBed),
              onDelete: () => _showDeleteConfirmation(gardenBed),
              extraContent: GerminationPreview(
                gardenBed: gardenBed,
                allPlantings: ref.watch(plantingsListProvider),
                plants: ref.watch(plantsListProvider),
              ),
            ),
          );
        },
      ),
    );
  }

  List _filterGardenBeds(List gardenBeds) {
    return gardenBeds.where((bed) {
      final matchesSearch = _searchQuery.isEmpty ||
          bed.name.toLowerCase().contains(_searchQuery) ||
          bed.description.toLowerCase().contains(_searchQuery);

      final matchesSoilType =
          _selectedSoilType.isEmpty || bed.soilType == _selectedSoilType;

      final matchesExposure =
          _selectedExposure.isEmpty || bed.exposure == _selectedExposure;

      return matchesSearch && matchesSoilType && matchesExposure;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedSoilType = '';
      _selectedExposure = '';
    });
  }

  Future<void> _refreshGardenBeds() async {
    await ref.read(gardenBedProvider.notifier).refresh(widget.gardenId);
  }

  void _showCreateGardenBedDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CreateGardenBedDialog(
        gardenId: widget.gardenId,
      ),
    );

    // Si une parcelle a Ã©tÃ© crÃ©Ã©e avec succÃ¨s, rafraÃ®chir la liste
    if (result == true) {
      await _refreshGardenBeds();
      // Optionnel: afficher un feedback supplÃ©mentaire si nÃ©cessaire
      // Le SnackBar est dÃ©jÃ  affichÃ© par le dialogue
    }
  }

  void _showEditGardenBedDialog(gardenBed) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CreateGardenBedDialog(
        gardenId: widget.gardenId,
        gardenBed: gardenBed,
      ),
    );

    // Si une parcelle a Ã©tÃ© modifiÃ©e avec succÃ¨s, rafraÃ®chir la liste
    if (result == true) {
      await _refreshGardenBeds();
      // Optionnel: afficher un feedback supplÃ©mentaire si nÃ©cessaire
      // Le SnackBar est dÃ©jÃ  affichÃ© par le dialogue
    }
  }

  void _showDeleteConfirmation(gardenBed) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Supprimer la parcelle',
        content:
            'ÃŠtes-vous sÃ»r de vouloir supprimer "${gardenBed.name}" ?\n\nCette action est irrÃ©versible.',
        confirmText: 'Supprimer',
        cancelText: 'Annuler',
        isDestructive: true,
        onConfirm: () async {
          final success = await ref
              .read(gardenBedProvider.notifier)
              .deleteGardenBed(gardenBed.id);

          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Parcelle supprimÃ©e avec succÃ¨s')),
            );
          }
        },
      ),
    );
  }

  void _navigateToGardenBedDetail(gardenBed) {
    // TODO: Navigate to garden bed detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('DÃ©tail de parcelle Ã  implÃ©menter')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'stats':
        _showStatsDialog();
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export Ã  implÃ©menter')),
        );
        break;
    }
  }

  void _showStatsDialog() {
    final stats = ref.read(gardenBedStatsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques des parcelles'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre total de parcelles: ${stats['totalBeds']}'),
            const SizedBox(height: 8),
            Text('Surface totale: ${stats['totalArea'].toStringAsFixed(1)} mÂ²'),
            const SizedBox(height: 8),
            Text(
                'Surface moyenne: ${stats['averageArea'].toStringAsFixed(1)} mÂ²'),
            const SizedBox(height: 16),
            const Text('RÃ©partition par type de sol:'),
            ...stats['soilTypeDistribution'].entries.map(
                  (entry) => Text('â€¢ ${entry.key}: ${entry.value}'),
                ),
            const SizedBox(height: 8),
            const Text('RÃ©partition par exposition:'),
            ...stats['exposureDistribution'].entries.map(
                  (entry) => Text('â€¢ ${entry.key}: ${entry.value}'),
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}



