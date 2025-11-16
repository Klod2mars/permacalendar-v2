// lib/features/plant_catalog/presentation/screens/plant_catalog_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modèle PlantFreezed
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

// Provider (source des plantes)
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';

/// Écran de sélection / catalogue de plantes
class PlantCatalogScreen extends ConsumerStatefulWidget {
  final List<PlantFreezed> plants;
  final void Function(PlantFreezed plant)? onPlantSelected;

  /// Mode sélection — gardé pour compatibilité avec d'autres dialogues
  final bool isSelectionMode;

  const PlantCatalogScreen({
    Key? key,
    this.plants = const [],
    this.onPlantSelected,
    this.isSelectionMode = false,
  }) : super(key: key);

  @override
  ConsumerState<PlantCatalogScreen> createState() => _PlantCatalogScreenState();
}

class _PlantCatalogScreenState extends ConsumerState<PlantCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final current = ref.read(plantsListProvider);
        if (kDebugMode) {
          debugPrint(
              'PlantCatalogScreen.initState: providerPlants.count = ${current.length}');
        }
        if (current.isEmpty) {
          if (kDebugMode) {
            debugPrint('PlantCatalogScreen: triggering loadPlants()...');
          }
          ref.read(plantCatalogProvider.notifier).loadPlants();
        }
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint(
              'PlantCatalogScreen: erreur lors du check/loadPlants: $e\n$st');
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalize(String? input) {
    if (input == null) return '';
    String s = input.toLowerCase().trim();

    const Map<String, String> diacritics = {
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
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
      'ñ': 'n',
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
    };

    diacritics.forEach((k, v) {
      s = s.replaceAll(k, v);
    });

    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s;
  }

  List<PlantFreezed> _filterPlantsList(
      List<PlantFreezed> source, String query) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) return List<PlantFreezed>.from(source);

    return source.where((p) {
      final common = _normalize(p.commonName);
      final scientific = _normalize(p.scientificName);
      final family = _normalize(p.family);
      final description = _normalize(p.description);
      return common.contains(normalizedQuery) ||
          scientific.contains(normalizedQuery) ||
          family.contains(normalizedQuery) ||
          description.contains(normalizedQuery);
    }).toList();
  }

  Widget _fallbackImage({double height = 180}) {
    return Container(
      height: height,
      color: Colors.green.shade50,
      alignment: Alignment.center,
      child: Icon(
        Icons.eco_outlined,
        size: 56,
        color: Colors.green.shade700,
      ),
    );
  }

  String? _resolveImagePathFromPlant(PlantFreezed plant) {
    try {
      final meta = plant.metadata;
      if (meta != null) {
        final candidates = [
          meta['image'],
          meta['imagePath'],
          meta['photo'],
          meta['image_url'],
          meta['imageUrl'],
        ];
        for (final c in candidates) {
          if (c is String && c.trim().isNotEmpty) {
            return c.trim();
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Widget _buildPlantCard(PlantFreezed plant) {
    final String? rawPath = _resolveImagePathFromPlant(plant);
    const double imageHeight = 180.0;
    Widget imageWidget;

    if (rawPath != null && rawPath.isNotEmpty) {
      final isNetwork =
          RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(rawPath);

      if (isNetwork) {
        imageWidget = Image.network(
          rawPath,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(height: imageHeight),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: imageHeight,
              color: Colors.green.shade50,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          },
        );
      } else {
        final assetPath = rawPath.startsWith('assets/')
            ? rawPath
            : 'assets/images/legumes/$rawPath';

        imageWidget = Image.asset(
          assetPath,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(height: imageHeight),
        );
      }
    } else {
      imageWidget = _fallbackImage(height: imageHeight);
    }

    return GestureDetector(
      onTap: () {
        if (widget.onPlantSelected != null) {
          widget.onPlantSelected!(plant);
        } else if (widget.isSelectionMode) {
          Navigator.of(context).pop(plant);
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardedge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: imageHeight, child: imageWidget),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.commonName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (plant.scientificName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        plant.scientificName,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
    final providerPlants = ref.watch(plantsListProvider);
    final sourcePlants =
        widget.plants.isNotEmpty ? widget.plants : providerPlants;

    final filteredPlants =
        _filterPlantsList(sourcePlants, _searchController.text);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Catalogue de plantes'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 1000
              ? 4
              : (constraints.maxWidth >= 700
                  ? 3
                  : (constraints.maxWidth >= 500 ? 2 : 1));

          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final bottomPadding = bottomInset + 12.0;

          // *** AJOUT ICI ***
          final double desiredTileHeight =
              constraints.maxWidth >= 700 ? 300.0 : 320.0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText:
                        'Rechercher une plante (nom, scientifique, description...)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 14.0),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [
                    Text('${filteredPlants.length} résultat(s)',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 8),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: bottomPadding),
                  child: filteredPlants.isEmpty
                      ? Center(
                          child: Text(
                            'Aucune plante trouvée',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,

                            /// *** NOUVEL ASPECT RATIO ADAPTATIF ***
                            childAspectRatio:
                                (constraints.maxWidth / crossAxisCount) /
                                    desiredTileHeight,
                          ),
                          itemCount: filteredPlants.length,
                          itemBuilder: (context, index) {
                            final plant = filteredPlants[index];
                            return _buildPlantCard(plant);
                          },
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
