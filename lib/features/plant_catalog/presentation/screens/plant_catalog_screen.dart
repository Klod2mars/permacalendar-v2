import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plant_entity.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../providers/plant_catalog_provider.dart';
import 'plant_detail_screen.dart';

class PlantCatalogScreen extends ConsumerStatefulWidget {
  final bool isSelectionMode;

  const PlantCatalogScreen({
    super.key,
    this.isSelectionMode = false,
  });

  @override
  ConsumerState<PlantCatalogScreen> createState() => _PlantCatalogScreenState();
}

class _PlantCatalogScreenState extends ConsumerState<PlantCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSowingSeason = 'Toutes';
  String _selectedHarvestSeason = 'Toutes';

  // Saisons basées sur les mois de plantation et récolte du JSON
  final List<String> _seasons = [
    'Toutes',
    'Printemps',
    'Été',
    'Automne',
    'Hiver',
  ];

  // Mapping des mois vers les saisons
  final Map<String, String> _monthToSeason = {
    'Jan': 'Hiver', // Janvier
    'Fév': 'Hiver', // Février
    'Mar': 'Printemps', // Mars
    'Avr': 'Printemps', // Avril
    'Mai': 'Printemps', // Mai
    'Jun': 'Été', // Juin
    'Jul': 'Été', // Juillet
    'Aoû': 'Été', // Août
    'Sep': 'Automne', // Septembre
    'Oct': 'Automne', // Octobre
    'Nov': 'Automne', // Novembre
    'Déc': 'Hiver', // Décembre
  };

  @override
  void initState() {
    super.initState();
    // Load plants when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(plantCatalogProvider.notifier).loadPlants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode
            ? 'Sélectionner une plante'
            : 'Catalogue des plantes'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        actions: widget.isSelectionMode
            ? null
            : [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    switch (value) {
                      case 'refresh':
                        await ref
                            .read(plantCatalogProvider.notifier)
                            .loadPlants();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text('Actualiser'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(theme),

          // Filter Chips
          _buildFilterChips(theme),

          // Plant Grid
          Expanded(
            child: _buildPlantGrid(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher par nom, nom scientifique ou famille...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sowing Season Filter
          Text(
            'Saison de plantation',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _seasons.length,
              itemBuilder: (context, index) {
                final season = _seasons[index];
                final isSelected = season == _selectedSowingSeason;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(season),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSowingSeason = season;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Harvest Season Filter
          Text(
            'Saison de récolte',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _seasons.length,
              itemBuilder: (context, index) {
                final season = _seasons[index];
                final isSelected = season == _selectedHarvestSeason;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(season),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedHarvestSeason = season;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlantGrid(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final plantCatalogState = ref.watch(plantCatalogProvider);

        if (plantCatalogState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (plantCatalogState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  plantCatalogState.error!,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(plantCatalogProvider.notifier).loadPlants(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        // Apply filters
        var filteredPlants = plantCatalogState.plants;

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          filteredPlants = filteredPlants.where((plant) {
            return plant.commonName.toLowerCase().contains(query) ||
                plant.scientificName.toLowerCase().contains(query) ||
                plant.family.toLowerCase().contains(query);
          }).toList();
        }

        // Apply sowing season filter
        if (_selectedSowingSeason != 'Toutes') {
          filteredPlants = filteredPlants.where((plant) {
            final sowingSeason = _getSeasonFromMonths(plant.sowingMonths);
            return sowingSeason == _selectedSowingSeason;
          }).toList();
        }

        // Apply harvest season filter
        if (_selectedHarvestSeason != 'Toutes') {
          filteredPlants = filteredPlants.where((plant) {
            final harvestSeason = _getSeasonFromMonths(plant.harvestMonths);
            return harvestSeason == _selectedHarvestSeason;
          }).toList();
        }

        if (filteredPlants.isEmpty) {
          return const EmptyStateWidget(
            title: 'Aucune plante trouvée',
            subtitle:
                'Essayez de modifier vos critères de recherche ou filtres.',
            icon: Icons.search_off,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredPlants.length,
          itemBuilder: (context, index) {
            final plant = filteredPlants[index];
            return _buildPlantCard(plant, theme, context);
          },
        );
      },
    );
  }

  String _getSeasonFromMonths(List<String> months) {
    if (months.isEmpty) return '';

    final seasonCounts = <String, int>{};
    for (final month in months) {
      final season = _monthToSeason[month];
      if (season != null) {
        seasonCounts[season] = (seasonCounts[season] ?? 0) + 1;
      }
    }

    if (seasonCounts.isEmpty) return '';

    // Return the season with the most months
    return seasonCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Widget _buildPlantCard(
      PlantFreezed plant, ThemeData theme, BuildContext context) {
    // Get sowing season from months
    final sowingSeason = _getSeasonFromMonths(plant.sowingMonths);
    final harvestSeason = _getSeasonFromMonths(plant.harvestMonths);

    return CustomCard(
      onTap: () {
        if (widget.isSelectionMode) {
          // Return selected plant ID to the previous screen
          Navigator.pop(context, plant.id);
        } else {
          // Navigate to plant detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailScreen(plantId: plant.id),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plant image placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Icon(
              Icons.eco,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant name
                  Text(
                    plant.commonName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Scientific name
                  Text(
                    plant.scientificName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Family
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plant.family,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Seasons info
                  if (sowingSeason.isNotEmpty || harvestSeason.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (sowingSeason.isNotEmpty) ...[
                          Icon(
                            Icons.eco,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              sowingSeason,
                              style: theme.textTheme.labelSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

