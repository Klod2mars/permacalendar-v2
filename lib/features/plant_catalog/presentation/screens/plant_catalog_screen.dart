import 'package:permacalendar/features/premium/domain/can_perform_action_checker.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Modèle PlantFreezed
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

// Provider (source des plantes)
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';

// Formulaire
import 'custom_plant_form_screen.dart';
import 'package:permacalendar/shared/utils/plant_image_resolver.dart';
import 'package:permacalendar/features/plant_catalog/application/sowing_utils.dart';
import 'package:permacalendar/features/plant_catalog/presentation/widgets/sowing_picker.dart';
import 'plant_detail_screen.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'package:permacalendar/features/climate/presentation/providers/zone_providers.dart';
import 'package:permacalendar/features/climate/domain/models/zone.dart';
import 'package:permacalendar/features/premium/presentation/premium_banner.dart'; // Added
import 'package:permacalendar/features/planting/providers/planting_provider.dart'; // Added (Note: check package name)


class PlantCatalogScreen extends ConsumerStatefulWidget {
  final List<PlantFreezed> plants;
  final void Function(PlantFreezed plant)? onPlantSelected;
  final bool isSelectionMode;
  final ActionType? initialAction;

  const PlantCatalogScreen({
    Key? key,
    this.plants = const [],
    this.onPlantSelected,
    this.isSelectionMode = false,
    this.initialAction,
  }) : super(key: key);

  @override
  ConsumerState<PlantCatalogScreen> createState() => _PlantCatalogScreenState();
}

class _PlantCatalogScreenState extends ConsumerState<PlantCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  static List<String>? _assetManifestKeys;
  static Map<String, String>? _assetManifestLowerToOriginal;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final current = ref.read(plantsListProvider);
        if (current.isEmpty) {
          ref.read(plantCatalogProvider.notifier).loadPlants();
        }
      } catch (e, st) {
        // Validation log only if needed
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // -------------------------
  // Normalisation helpers
  // -------------------------
  String _normalize(String? input) {
    if (input == null) return '';
    var s = input.toLowerCase().trim();

    const diacritics = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'ç': 'c',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ñ': 'n',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ý': 'y', 'ÿ': 'y',
      'œ': 'oe', 'æ': 'ae',
    };

    diacritics.forEach((k, v) {
      s = s.replaceAll(k, v);
    });

    s = s.replaceAll(RegExp(r'[^a-z0-9\s_\-]'), ''); // remove punctuation
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s;
  }

  // -------------------------
  // Search helpers
  // -------------------------
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

  // -------------------------
  // AssetManifest helpers
  // -------------------------
  Future<void> _ensureAssetManifestLoaded() async {
    if (_assetManifestKeys != null && _assetManifestLowerToOriginal != null)
      return;

    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> m = json.decode(manifest);
      final keys = m.keys.toList();
      _assetManifestKeys = keys;
      final mapLower = <String, String>{};
      for (final k in keys) {
        mapLower[k.toLowerCase()] = k;
      }
      _assetManifestLowerToOriginal = mapLower;
    } catch (e) {
      _assetManifestKeys = null;
      _assetManifestLowerToOriginal = null;
    }
  }

  Future<String?> _tryManifest(List<String> candidates) async {
    await _ensureAssetManifestLoaded();
    if (_assetManifestLowerToOriginal == null) return null;
    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (_assetManifestLowerToOriginal!.containsKey(lc)) {
        return _assetManifestLowerToOriginal![lc];
      }
    }
    for (final c in candidates) {
      final lc = c.toLowerCase();
      for (final keyLower in _assetManifestLowerToOriginal!.keys) {
        if (keyLower.endsWith(lc))
          return _assetManifestLowerToOriginal![keyLower];
      }
    }
    return null;
  }

  Future<String?> _tryDirectLoad(List<String> candidates) async {
    for (final c in candidates) {
      try {
        await rootBundle.load(c);
        return c;
      } catch (_) {
        // ignore
      }
    }
    return null;
  }

  Future<String?> _findExistingAsset(List<String> candidates) async {
    final byManifest = await _tryManifest(candidates);
    if (byManifest != null) return byManifest;
    return await _tryDirectLoad(candidates);
  }

  // -------------------------
  // Image helpers
  // -------------------------
  Widget _fallbackImage({double height = 180}) {
    return Container(
      height: height,
      color: Colors.green.shade50,
      alignment: Alignment.center,
      child: Icon(Icons.eco_outlined, size: 56, color: Colors.green.shade700),
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
          if (c is String && c.trim().isNotEmpty) return c.trim();
        }
      }
    } catch (_) {}
    return null;
  }

  // -------------------------
  // Navigation
  // -------------------------
  void _navigateToDetail(PlantFreezed plant) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlantDetailScreen(plantId: plant.id)),
    );
  }

  void _handlePlantSelection(PlantFreezed plant) {
    if (widget.onPlantSelected != null) {
      widget.onPlantSelected!(plant);
    } else if (widget.isSelectionMode) {
      Navigator.of(context).pop(plant.id);
    } else {
      // Si c'est une plante perso, on permet l'édition, sinon détails
      if (plant.metadata['isCustom'] == true) {
         Navigator.of(context).push(
           MaterialPageRoute(builder: (_) => CustomPlantFormScreen(plantToEdit: plant))
         );
      } else {
         _navigateToDetail(plant);
      }
    }
  }

  // Build Plant Card
  Widget _buildPlantCard(PlantFreezed plant, Zone? zone, DateTime? lastFrost, [int index = -1]) {
    final raw = _resolveImagePathFromPlant(plant);
    final imageHeight = widget.isSelectionMode ? 140.0 : 180.0;
    Widget imageWidget;
    
    // Détection plante perso pour badge (optionnel)
    final isCustom = plant.metadata['isCustom'] == true;


    if (raw != null && raw.isNotEmpty) {
      // if (kDebugMode) debugPrint('[DEBUG_IMG] Plant ${plant.commonName} raw="$raw"');
      
      final isNetwork =
          RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(raw);
          
      // Check for local file path using basic heuristic
      // We are more restrictive to avoid false positives with simple filenames like "brocoli"
      final bool isLocalFile = !isNetwork && (raw.startsWith('/') || raw.startsWith('file:') || (raw.contains(Platform.pathSeparator) && raw.contains('.'))); 
      
      // if (kDebugMode) debugPrint('[DEBUG_IMG] isNetwork=$isNetwork, isLocalFile=$isLocalFile');

      if (isNetwork) {
        imageWidget = Image.network(
          raw,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (c, e, st) => _fallbackImage(height: imageHeight),
        );
      } else if (isLocalFile) {
        final file = File(raw);
        // On affiche l'image fichier si elle existe
        imageWidget = Image.file(
          file,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (c, e, st) {
             // if (kDebugMode) debugPrint('Error loading file image $raw: $e');
             return _fallbackImage(height: imageHeight);
          },
        );
      } else {
        // Use centralized resolver
        final base = raw;
        imageWidget = FutureBuilder<String?>(
          future: findPlantImageAsset(plant),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(height: imageHeight, color: Colors.green.shade50);
            }
            final found = snapshot.data;
            if (found != null) {
              // if (kDebugMode && index < 3) debugPrint('[DEBUG_IMG] Found asset (central): $found');
              return Image.asset(found, height: imageHeight, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,err,stack)=> _fallbackImage(height: imageHeight));
            } else {
              // if (kDebugMode) debugPrint('[DEBUG_IMG] No asset found for $base (central resolver)');
              return _fallbackImage(height: imageHeight);
            }
          },
        );
      }
    } else {
      // if (kDebugMode) debugPrint('[DEBUG_IMG] No raw path for ${plant.commonName}');
      imageWidget = _fallbackImage(height: imageHeight);
    }

    return GestureDetector(
      onTap: () => _handlePlantSelection(plant),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    SizedBox(height: 180.0, child: imageWidget),
                     // Season Status Indicator
                    Positioned(
                      top: 8,
                      left: 8,
                      child: FutureBuilder<SeasonInfo>(
                        // Use immediate computation since it is sync
                        future: Future.value(computeSeasonInfoForPlant(
                          plant: plant,
                          date: DateTime.now(),
                          action: ActionType.sow, // Default to Sow for grid view
                          zone: zone,
                          lastFrostDate: lastFrost,
                        )),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          final status = snapshot.data!.status;
                          return Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: statusToColor(status),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
            if (isCustom)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Perso', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
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
    final zoneAsync = ref.watch(currentZoneProvider);
    final frostAsync = ref.watch(lastFrostDateProvider);
    
    final zone = zoneAsync.asData?.value;
    final lastFrost = frostAsync.asData?.value;
    
    final sourcePlants =
        widget.plants.isNotEmpty ? widget.plants : providerPlants;

    final filteredPlants =
        _filterPlantsList(sourcePlants, _searchController.text);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.plant_catalog_title),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CustomPlantFormScreen())
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une plante personnalisée',
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 1000
              ? 4
              : (constraints.maxWidth >= 700
                  ? 3
                  : (constraints.maxWidth >= 500 ? 2 : 1));

          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          // Add extra padding for FAB
          final bottomPadding = bottomInset + 80.0;

          final double desiredTileHeight =
              constraints.maxWidth >= 700 ? 300.0 : 320.0;

          return Column(
            children: [
              // Premium Banner
              Builder(
                builder: (context) {
                   final count = ref.watch(globalActivePlantCountProvider);
                   final limit = CanPerformActionChecker.kFreePlantLimit;
                   final remaining = (limit - count).clamp(0, limit);
                   
                   return PremiumBanner(
                     remaining: remaining,
                     limit: limit,
                     message: remaining > 0 
                        ? '$remaining plantes gratuites restantes' 
                        : 'Limite gratuite atteinte',
                   );
                }
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 10.0, bottom: 2.0),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.plant_catalog_search_hint,
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
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SowingPicker(
                  plants: sourcePlants,
                  onPlantSelected: _handlePlantSelection,
                  initialAction: widget.initialAction ?? ActionType.sow,
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
                          child: Text('Aucune plante trouvée',
                              style: Theme.of(context).textTheme.titleMedium))
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
                            return _buildPlantCard(plant, zone, lastFrost, index);
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
