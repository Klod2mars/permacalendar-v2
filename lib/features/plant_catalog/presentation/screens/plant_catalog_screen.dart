// lib/features/plant_catalog/presentation/screens/plant_catalog_screen.dart

import 'dart:convert';

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

  // Cache de AssetManifest -> liste de clés d'assets (original case)
  static List<String>? _assetManifestKeys;
  static Set<String>? _assetManifestKeysLower;

  @override
  void initState() {
    super.initState();

    // Listener pour forcer rebuild quand la recherche change.
    _searchController.addListener(() {
      setState(() {
        // déclenche build() pour recalculer la liste filtrée
      });
    });

    // FORCER le chargement si nécessaire : on veut que le catalogue soit déjà
    // peuplé au moment de l'ouverture de l'écran.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final current = ref.read(plantsListProvider);
        if (kDebugMode) {
          debugPrint('DEBUG_INIT: providerPlants.count = ${current.length}');
        }
        if (current.isEmpty) {
          if (kDebugMode) {
            debugPrint('DEBUG_INIT: triggering loadPlants()...');
          }
          ref.read(plantCatalogProvider.notifier).loadPlants();
        }
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('DEBUG_INIT ERROR: $e\n$st');
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================
  // Normalisation & Recherche
  // ============================
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
      'œ': 'oe',
      'æ': 'ae',
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

  // ============================
  // Asset resolution (case-insensitive)
  // ============================

  Future<void> _ensureAssetManifestLoaded() async {
    if (_assetManifestKeys != null && _assetManifestKeysLower != null) return;
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final keys = manifestMap.keys.toList();
      _assetManifestKeys = keys;
      _assetManifestKeysLower = keys.map((k) => k.toLowerCase()).toSet();
      if (kDebugMode) {
        debugPrint(
            'DEBUG_MANIFEST: AssetManifest loaded with ${keys.length} entries');
      }
    } catch (e) {
      _assetManifestKeys = null;
      _assetManifestKeysLower = null;
      if (kDebugMode) {
        debugPrint(
            'DEBUG_MANIFEST ERROR: Failed to load AssetManifest.json: $e');
      }
    }
  }

  Future<String?> _findExistingAssetFromManifest(
      List<String> candidates) async {
    await _ensureAssetManifestLoaded();

    if (_assetManifestKeys == null || _assetManifestKeysLower == null) {
      return null;
    }

    final Map<String, String> lowerToOriginal = {};
    for (final k in _assetManifestKeys!) {
      lowerToOriginal[k.toLowerCase()] = k;
    }

    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (lowerToOriginal.containsKey(lc)) {
        return lowerToOriginal[lc];
      }
      for (final keyLower in lowerToOriginal.keys) {
        if (keyLower.endsWith('/' + lc) ||
            keyLower.endsWith('\\' + lc) ||
            keyLower == lc) {
          return lowerToOriginal[keyLower];
        }
      }
    }
    return null;
  }

  Future<String?> _findExistingAssetDirect(List<String> candidates) async {
    for (final path in candidates) {
      try {
        await rootBundle.load(path);
        return path;
      } catch (_) {
        // ignore
      }
    }
    return null;
  }

  Future<String?> _findExistingAsset(List<String> candidates) async {
    final fromManifest = await _findExistingAssetFromManifest(candidates);
    if (fromManifest != null) return fromManifest;
    return await _findExistingAssetDirect(candidates);
  }

  // ============================
  // Image building (robuste) + logs
  // ============================

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
    } catch (_) {
      // ignore
    }
    return null;
  }

  Widget _buildPlantCard(PlantFreezed plant) {
    final String? rawPath = _resolveImagePathFromPlant(plant);
    const double imageHeight = 180.0;
    Widget imageWidget;

    // --- Logs : print metadata + resolution attempt
    if (kDebugMode) {
      try {
        debugPrint(
            'DEBUG_PLANT: id=${plant.id}, commonName=${plant.commonName}');
        debugPrint('DEBUG_METADATA: ${plant.metadata}');
      } catch (_) {}
    }

    if (rawPath != null && rawPath.isNotEmpty) {
      if (kDebugMode)
        debugPrint('DEBUG_RAWPATH: "$rawPath" for plant ${plant.id}');

      final isNetwork =
          RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(rawPath);

      if (isNetwork) {
        if (kDebugMode)
          debugPrint('DEBUG_IMAGE: network image for ${plant.id} -> $rawPath');
        imageWidget = Image.network(
          rawPath,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode)
              debugPrint('DEBUG_NETWORK_ERROR: $error for $rawPath');
            return _fallbackImage(height: imageHeight);
          },
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
        // Construit des candidats robustes (extensions, chemins, lowercase)
        final String baseRaw = rawPath;
        final List<String> candidates = [];

        if (baseRaw.startsWith('assets/')) {
          candidates.add(baseRaw);
          candidates.add(baseRaw.toLowerCase());
        } else {
          candidates.add('assets/images/legumes/$baseRaw');
          candidates.add('assets/images/legumes/${baseRaw.toLowerCase()}');
          candidates.add('assets/images/plants/$baseRaw');
          candidates.add('assets/images/plants/${baseRaw.toLowerCase()}');
          candidates.add('assets/$baseRaw');
          candidates.add('assets/${baseRaw.toLowerCase()}');

          if (!RegExp(r'\.\w+$').hasMatch(baseRaw)) {
            final exts = ['.png', '.jpg', '.jpeg', '.webp'];
            for (final ext in exts) {
              candidates.add('assets/images/legumes/${baseRaw}$ext');
              candidates
                  .add('assets/images/legumes/${baseRaw.toLowerCase()}$ext');
              candidates.add('assets/images/plants/${baseRaw}$ext');
              candidates
                  .add('assets/images/plants/${baseRaw.toLowerCase()}$ext');
            }
          } else {
            candidates.add('assets/images/legumes/${baseRaw.toLowerCase()}');
            candidates.add('assets/images/plants/${baseRaw.toLowerCase()}');
          }
        }

        final seen = <String>{};
        final finalCandidates = <String>[];
        for (final c in candidates) {
          if (!seen.contains(c)) {
            seen.add(c);
            finalCandidates.add(c);
          }
        }

        if (kDebugMode)
          debugPrint('DEBUG_CANDIDATES for ${plant.id}: $finalCandidates');

        imageWidget = FutureBuilder<String?>(
          future: _findExistingAsset(finalCandidates),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                height: imageHeight,
                color: Colors.green.shade50,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
            final found = snapshot.data;
            if (found != null) {
              if (kDebugMode)
                debugPrint('DEBUG_FOUND_ASSET for ${plant.id} -> $found');
              return Image.asset(
                found,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode)
                    debugPrint('DEBUG_ASSET_ERROR: $error for asset $found');
                  return _fallbackImage(height: imageHeight);
                },
              );
            } else {
              if (kDebugMode)
                debugPrint(
                    'DEBUG_ASSET_MISSING for ${plant.id}, tried: $finalCandidates');
              return _fallbackImage(height: imageHeight);
            }
          },
        );
      }
    } else {
      if (kDebugMode)
        debugPrint('DEBUG_NO_RAWPATH for plant ${plant.id} - using fallback');
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
        clipBehavior: Clip.hardEdge,
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
                  if ((plant.scientificName).isNotEmpty)
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

  // ============================
  // Build
  // ============================

  @override
  Widget build(BuildContext context) {
    final providerPlants = ref.watch(plantsListProvider);
    final sourcePlants =
        widget.plants.isNotEmpty ? widget.plants : providerPlants;

    if (kDebugMode) {
      if (providerPlants.isNotEmpty) {
        try {
          debugPrint('DEBUG_PLANT_SAMPLE: ${providerPlants.first.toJson()}');
        } catch (_) {}
      } else {
        debugPrint('DEBUG_PROVIDER_EMPTY');
      }
    }

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
          final bottomPadding = bottomInset + 20.0;

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
                              setState(
                                  () {}); // force rebuild pour réafficher toutes les plantes
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 14.0),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
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
