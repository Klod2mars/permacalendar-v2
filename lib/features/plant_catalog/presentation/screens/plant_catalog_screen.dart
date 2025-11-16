import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plant_entity.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../providers/plant_catalog_provider.dart';
import 'plant_detail_screen.dart';

class PlantCatalogScreen extends ConsumerStatefulWidget {
  final bool isSelectionMode;

  const PlantCatalogScreen({super.key, this.isSelectionMode = false});

  @override
  ConsumerState<PlantCatalogScreen> createState() => _PlantCatalogScreenState();
}

class _PlantCatalogScreenState extends ConsumerState<PlantCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Charger les plantes après le rendu initial
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
      // Empêche le redimensionnement automatique lorsque le clavier apparaît.
      // Nous gérons le padding bas via MediaQuery.viewInsets pour préserver
      // au moins la première carte visible lorsque le clavier est ouvert.
      resizeToAvoidBottomInset: false,
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
          _buildSearchBar(theme),
          // On a retiré le module "Saison de plantation".
          Expanded(child: _buildPlantGrid(theme)),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildPlantGrid(ThemeData theme) {
    return Consumer(builder: (context, ref, child) {
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

      // Liste des plantes
      var filteredPlants = plantCatalogState.plants;

      // Filtre recherche (seulement si non vide après trim)
      if (_searchQuery.trim().isNotEmpty) {
        final query = _normalize(_searchQuery);
        filteredPlants = filteredPlants.where((plant) {
          return _normalize(plant.commonName).contains(query) ||
              _normalize(plant.scientificName).contains(query) ||
              _normalize(plant.family).contains(query);
        }).toList();
      }

      if (filteredPlants.isEmpty) {
        return const EmptyStateWidget(
          title: 'Aucune plante trouvée',
          subtitle: 'Essayez de modifier vos critères de recherche ou filtres.',
          icon: Icons.search_off,
        );
      }

      // Adapter le padding bas au clavier pour éviter que le Grid soit masqué.
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // UNE plante par ligne
            childAspectRatio: 0.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredPlants.length,
          itemBuilder: (context, index) {
            final plant = filteredPlants[index];
            return _buildPlantCard(plant, theme, context);
          },
        ),
      );
    });
  }

  /// Normalise une chaîne pour la recherche :
  /// - minuscules
  /// - trim
  /// - suppression simple des accents les plus courants (français/latin)
  String _normalize(String input) {
    var s = input.toLowerCase().trim();
    if (s.isEmpty) return s;
    const accents = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'å': 'a',
      'ç': 'c',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
      'ñ': 'n'
    };
    accents.forEach((k, v) {
      s = s.replaceAll(k, v);
    });
    return s;
  }

  Widget _buildPlantCard(
      PlantFreezed plant, ThemeData theme, BuildContext context) {
    return CustomCard(
      onTap: () {
        if (widget.isSelectionMode) {
          Navigator.pop(context, plant.id);
        } else {
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
          // Image (metadata keys: 'image','imagePath','imageAsset')
          Builder(builder: (context) {
            final imagePath = (plant.metadata['image'] as String?) ??
                (plant.metadata['imagePath'] as String?) ??
                (plant.metadata['imageAsset'] as String?);

            return Container(
              // Image légèrement réduite pour mieux tenir lorsque l'espace vertical est réduit.
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: imagePath != null && imagePath.isNotEmpty
                    ? (imagePath.startsWith('http')
                        ? Image.network(imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180)
                        : Image.asset('assets/images/legumes/$imagePath',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180))
                    : Center(
                        child: Icon(
                          Icons.eco,
                          size: 56,
                          color: theme.colorScheme.primary,
                        ),
                      ),
              ),
            );
          }),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.commonName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plant.scientificName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      plant.family,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Intentionnellement pas d'affichage de saison ici — module supprimé.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
