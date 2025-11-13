import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../providers/planting_provider.dart';
import '../widgets/planting_card.dart';
import '../dialogs/create_planting_dialog.dart';

class PlantingListScreen extends ConsumerStatefulWidget {
  final String gardenBedId;
  final String gardenBedName;

  const PlantingListScreen({
    super.key,
    required this.gardenBedId,
    required this.gardenBedName,
  });

  @override
  ConsumerState<PlantingListScreen> createState() => _PlantingListScreenState();
}

class _PlantingListScreenState extends ConsumerState<PlantingListScreen> {
  String _searchQuery = '';
  String _selectedStatus = '';
  String _selectedPlant = '';

  @override
  void initState() {
    super.initState();
    // Load plantings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(plantingProvider.notifier).loadPlantings(widget.gardenBedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plantingState = ref.watch(plantingProvider);
    // âœ… CORRECTION : Utiliser le provider spécifique pour cette parcelle
    final plantings =
        ref.watch(plantingsByGardenBedProvider(widget.gardenBedId));
    final stats = ref.watch(plantingStatsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Plantations - ${widget.gardenBedName}',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshPlantings(),
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
                value: 'harvest',
                child: Row(
                  children: [
                    Icon(Icons.agriculture),
                    SizedBox(width: 8),
                    Text('Prêt à récolter'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'mock',
                child: Row(
                  children: [
                    Icon(Icons.data_object),
                    SizedBox(width: 8),
                    Text('Données test'),
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
          _buildSearchAndFilters(theme, plantings),

          // Statistics Summary
          if (plantings.isNotEmpty) _buildStatsSummary(stats, theme),

          // Plantings List
          Expanded(
            child: _buildPlantingsList(plantingState, plantings, theme),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _showCreatePlantingDialog(),
        tooltip: 'Ajouter une plantation',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndFilters(ThemeData theme, List plantings) {
    // Get unique plants and statuses for filters
    final uniquePlants = plantings.map((p) => p.plantName).toSet().toList();
    final uniqueStatuses = plantings.map((p) => p.status).toSet().toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher une plantation...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor:
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                // Status filters
                _buildFilterChip(
                  'Tous les statuts',
                  _selectedStatus.isEmpty,
                  () => setState(() => _selectedStatus = ''),
                  theme,
                ),
                const SizedBox(width: 8),
                ...uniqueStatuses.map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      status,
                      _selectedStatus == status,
                      () => setState(() => _selectedStatus = status),
                      theme,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Plant filters
                if (uniquePlants.isNotEmpty) ...[
                  _buildFilterChip(
                    'Toutes les plantes',
                    _selectedPlant.isEmpty,
                    () => setState(() => _selectedPlant = ''),
                    theme,
                  ),
                  const SizedBox(width: 8),
                  ...uniquePlants.take(5).map(
                        (plant) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            plant,
                            _selectedPlant == plant,
                            () => setState(() => _selectedPlant = plant),
                            theme,
                          ),
                        ),
                      ),
                ],
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Plantations',
                '${stats['totalPlantings']}',
                Icons.eco,
                theme,
              ),
              _buildStatItem(
                'Quantité totale',
                '${stats['totalQuantity']}',
                Icons.numbers,
                theme,
              ),
              _buildStatItem(
                'Taux de réussite',
                '${stats['successRate'].toStringAsFixed(1)}%',
                Icons.trending_up,
                theme,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'En croissance',
                '${stats['inGrowth']}',
                Icons.grass,
                theme,
                color: Colors.green,
              ),
              _buildStatItem(
                'Prêt à récolter',
                '${stats['readyForHarvest']}',
                Icons.agriculture,
                theme,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, ThemeData theme,
      {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPlantingsList(
      dynamic plantingState, List plantings, ThemeData theme) {
    if (plantingState.isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (plantingState.error != null) {
      return ErrorStateWidget(
        title: plantingState.error!,
        onRetry: () => _refreshPlantings(),
      );
    }

    final filteredPlantings = _filterPlantings(plantings);

    if (filteredPlantings.isEmpty) {
      if (plantings.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.eco,
          title: 'Aucune plantation',
          subtitle:
              'Commencez par ajouter votre première plantation dans cette parcelle.',
          actionText: 'Créer une plantation',
          onAction: () => _showCreatePlantingDialog(),
        );
      } else {
        return EmptyStateWidget(
          icon: Icons.search_off,
          title: 'Aucun résultat',
          subtitle:
              'Aucune plantation ne correspond à vos critères de recherche.',
          actionText: 'Effacer les filtres',
          onAction: () => _clearFilters(),
        );
      }
    }

    return RefreshIndicator(
      onRefresh: () => _refreshPlantings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredPlantings.length,
        itemBuilder: (context, index) {
          final planting = filteredPlantings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlantingCard(
              planting: planting,
              onTap: () => _navigateToPlantingDetail(planting),
              onEdit: () => _showEditPlantingDialog(planting),
              onDelete: () => _showDeleteConfirmation(planting),
              onStatusChange: (newStatus) =>
                  _updatePlantingStatus(planting, newStatus),
              onHarvest: () => _harvestPlanting(planting),
              onAddCareAction: (action) => _addCareAction(planting, action),
            ),
          );
        },
      ),
    );
  }

  List _filterPlantings(List plantings) {
    return plantings.where((planting) {
      final matchesSearch = _searchQuery.isEmpty ||
          planting.plantName.toLowerCase().contains(_searchQuery) ||
          (planting.notes?.toLowerCase().contains(_searchQuery) ?? false);

      final matchesStatus =
          _selectedStatus.isEmpty || planting.status == _selectedStatus;

      final matchesPlant =
          _selectedPlant.isEmpty || planting.plantName == _selectedPlant;

      return matchesSearch && matchesStatus && matchesPlant;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedStatus = '';
      _selectedPlant = '';
    });
  }

  Future<void> _refreshPlantings() async {
    await ref.read(plantingProvider.notifier).refresh(widget.gardenBedId);
  }

  void _showCreatePlantingDialog() {
    showDialog(
      context: context,
      builder: (context) => CreatePlantingDialog(
        gardenBedId: widget.gardenBedId,
      ),
    );
  }

  void _showEditPlantingDialog(planting) {
    showDialog(
      context: context,
      builder: (context) => CreatePlantingDialog(
        gardenBedId: widget.gardenBedId,
        planting: planting,
      ),
    );
  }

  void _showDeleteConfirmation(planting) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Supprimer la plantation',
        content:
            'ÃŠtes-vous sûr de vouloir supprimer "${planting.plantName}" ?\n\nCette action est irréversible.',
        confirmText: 'Supprimer',
        cancelText: 'Annuler',
        isDestructive: true,
        onConfirm: () async {
          final success = await ref
              .read(plantingProvider.notifier)
              .deletePlanting(planting.id);

          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plantation supprimée avec succès')),
            );
          }
        },
      ),
    );
  }

  Future<void> _updatePlantingStatus(planting, String newStatus) async {
    final success = await ref
        .read(plantingProvider.notifier)
        .updatePlantingStatus(planting.id, newStatus);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut mis à jour: $newStatus')),
      );
    }
  }

  Future<void> _harvestPlanting(planting) async {
    final success = await ref
        .read(plantingProvider.notifier)
        .harvestPlanting(planting.id, DateTime.now());

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plantation récoltée avec succès')),
      );
    }
  }

  Future<void> _addCareAction(planting, String action) async {
    final success = await ref.read(plantingProvider.notifier).addCareAction(
          plantingId: planting.id,
          actionType: action,
          date: DateTime.now(),
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action ajoutée: $action')),
      );
    }
  }

  void _navigateToPlantingDetail(planting) {
    context.push('/plantings/${planting.id}');
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'stats':
        _showStatsDialog();
        break;
      case 'harvest':
        _showHarvestDialog();
        break;
      case 'mock':
        _generateMockData();
        break;
    }
  }

  void _showStatsDialog() {
    final stats = ref.read(plantingStatsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques des plantations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre total de plantations: ${stats['totalPlantings']}'),
            const SizedBox(height: 8),
            Text('Quantité totale: ${stats['totalQuantity']}'),
            const SizedBox(height: 8),
            Text(
                'Taux de réussite: ${stats['successRate'].toStringAsFixed(1)}%'),
            const SizedBox(height: 16),
            const Text('Répartition par statut:'),
            ...stats['statusDistribution'].entries.map(
                  (entry) => Text('• ${entry.key}: ${entry.value}'),
                ),
            const SizedBox(height: 8),
            const Text('Répartition par plante:'),
            ...stats['plantDistribution'].entries.take(5).map(
                  (entry) => Text('• ${entry.key}: ${entry.value}'),
                ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHarvestDialog() {
    final readyForHarvest = ref.read(plantingsReadyForHarvestProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plantations prêtes à récolter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (readyForHarvest.isEmpty)
              const Text('Aucune plantation prête à récolter.')
            else ...[
              Text('${readyForHarvest.length} plantation(s) prête(s):'),
              const SizedBox(height: 8),
              ...readyForHarvest.map(
                (planting) =>
                    Text('• ${planting.plantName} (${planting.quantity})'),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateMockData() async {
    await ref
        .read(plantingProvider.notifier)
        .generateMockData(widget.gardenBedId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données test générées')),
      );
    }
  }
}


