import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/core/services/plant_catalog_service.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

class PlantingImage extends ConsumerWidget {
  final Planting planting;
  final double? width;
  final double? height;
  final double? size; // Legacy support
  final double? borderRadius;
  final BoxFit fit;

  const PlantingImage({
    super.key,
    required this.planting,
    this.width,
    this.height,
    this.size,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  static Map<String, String>? _assetManifestLowerToOriginal;
  static final Map<String, String?> _resolvedAssetsCache = {};

  static Future<void> _ensureAssetManifest() async {
    if (_assetManifestLowerToOriginal != null) return;
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> map = json.decode(manifest);
      final m = <String, String>{};
      for (final k in map.keys) m[k.toLowerCase()] = k;
      _assetManifestLowerToOriginal = m;
    } catch (e) {
      _assetManifestLowerToOriginal = null;
    }
  }

  static Future<String?> _searchManifestCandidates(
      List<String> candidates) async {
    await _ensureAssetManifest();
    if (_assetManifestLowerToOriginal == null) return null;
    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (_assetManifestLowerToOriginal!.containsKey(lc))
        return _assetManifestLowerToOriginal![lc];
    }
    // try endsWith
    for (final c in candidates) {
      final lc = c.toLowerCase();
      for (final keyLower in _assetManifestLowerToOriginal!.keys) {
        if (keyLower.endsWith(lc))
          return _assetManifestLowerToOriginal![keyLower];
      }
    }
    return null;
  }

  static Future<String?> _tryRootBundleLoad(List<String> candidates) async {
    for (final c in candidates) {
      try {
        await rootBundle.load(c);
        return c;
      } catch (_) {}
    }
    return null;
  }

  static String _removeDiacritics(String s) {
    const Map<String, String> table = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ñ': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ý': 'y', 'ÿ': 'y',
      'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A',
      'Ç': 'C', 'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E',
      'Ì': 'I', 'Í': 'I', 'Î': 'I', 'Ï': 'I',
      'Ñ': 'N', 'Ò': 'O', 'Ó': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö': 'O',
      'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U', 'Ý': 'Y', 'Ÿ': 'Y'
    };
    var out = s;
    table.forEach((k, v) => out = out.replaceAll(k, v));
    return out;
  }

  static String _toFilenameSafe(String s) {
    var out = s.trim();
    out = _removeDiacritics(out);
    out = out.replaceAll(RegExp(r'[^\w\s\-]'), '');
    out = out.replaceAll(RegExp(r'\s+'), '_');
    return out.toLowerCase();
  }

  static List<String> _buildCandidates(
      String base, String id, String catalogName, String plantingName) {
    final candidates = <String>[];

    void addNameCandidates(String name) {
      if (name.isEmpty) return;
      candidates.add('assets/images/legumes/$name');
      candidates.add('assets/images/plants/$name');
      final safe = _toFilenameSafe(name);
      final altHyphen = safe.replaceAll('_', '-');
      for (final ext in ['.png', '.jpg', '.jpeg', '.webp']) {
        candidates.add('assets/images/legumes/$safe$ext');
        candidates.add('assets/images/legumes/$altHyphen$ext');
        candidates.add('assets/images/plants/$safe$ext');
        candidates.add('assets/images/plants/$altHyphen$ext');
      }
    }

    addNameCandidates(catalogName);
    if (plantingName != catalogName) {
      addNameCandidates(plantingName);
    }

    if (base.isNotEmpty) {
      if (base.startsWith('assets/')) {
        candidates.add(base);
        candidates.add(base.toLowerCase());
      } else {
        candidates.add('assets/images/legumes/$base');
        candidates.add('assets/images/plants/$base');
        candidates.add('assets/images/$base');
        candidates.add('assets/$base');
        candidates.add('assets/${base.toLowerCase()}');
      }
      if (!RegExp(r'\.\w+$').hasMatch(base)) {
        for (final ext in ['.png', '.jpg', '.jpeg', '.webp']) {
          candidates.add('assets/images/legumes/$base$ext');
          candidates.add('assets/images/plants/$base$ext');
          candidates.add('assets/images/$base$ext');
          candidates.add('assets/$base$ext');
        }
      } else {
        candidates.add(base.toLowerCase());
      }
    }

    if (id.isNotEmpty) {
      candidates.add('assets/images/legumes/$id.jpg');
      candidates.add('assets/images/legumes/$id.png');
      candidates.add('assets/images/legumes/$id.webp');
      candidates.add('assets/images/plants/$id.jpg');
      candidates.add('assets/images/plants/$id.png');
    }

    final seen = <String>{};
    final finalCandidates = <String>[];
    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (!seen.contains(lc)) {
        seen.add(lc);
        finalCandidates.add(c);
      }
    }
    return finalCandidates;
  }

  Widget _fallback() {
    final w = width ?? size ?? 60.0;
    final h = height ?? size ?? 60.0;
    return Container(
      height: h,
      width: w,
      color: Colors.green.shade50,
      alignment: Alignment.center,
      child: Icon(Icons.eco_outlined,
          size: (w < h ? w : h) * 0.5, color: Colors.green.shade700),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = width ?? size ?? 60.0;
    final h = height ?? size ?? 60.0;
    final userPlants = ref.read(plantsListProvider);

    // Try finding in user provider first (Custom Plants)
    PlantFreezed? foundPlant;
    try {
      foundPlant = userPlants.firstWhere((p) => p.id == planting.plantId);
    } catch (_) {}

    // Prepare future based on provider result or legacy service
    final Future<Plant?> loadFuture = foundPlant != null
      ? Future.value(Plant(
          id: foundPlant.id,
          commonName: foundPlant.commonName,
          scientificName: foundPlant.scientificName,
          family: foundPlant.family,
          description: foundPlant.description,
          plantingSeason: foundPlant.plantingSeason,
          harvestSeason: foundPlant.harvestSeason,
          daysToMaturity: foundPlant.daysToMaturity,
          spacing: foundPlant.spacing.toDouble(),
          depth: foundPlant.depth,
          sunExposure: foundPlant.sunExposure,
          waterNeeds: foundPlant.waterNeeds,
          sowingMonths: foundPlant.sowingMonths,
          harvestMonths: foundPlant.harvestMonths,
          marketPricePerKg: foundPlant.marketPricePerKg ?? 0.0,
          defaultUnit: foundPlant.defaultUnit ?? '',
          nutritionPer100g: foundPlant.nutritionPer100g ?? const {},
          germination: foundPlant.germination ?? const {},
          growth: foundPlant.growth ?? const {},
          watering: foundPlant.watering ?? const {},
          thinning: foundPlant.thinning ?? const {},
          weeding: foundPlant.weeding ?? const {},
          culturalTips: foundPlant.culturalTips ?? const [],
          biologicalControl: foundPlant.biologicalControl ?? const {},
          harvestTime: foundPlant.harvestTime ?? '',
          companionPlanting: foundPlant.companionPlanting ?? const {},
          notificationSettings: foundPlant.notificationSettings ?? const {},
          imageUrl: foundPlant.metadata != null ? (
            foundPlant.metadata!['image'] ??
            foundPlant.metadata!['imagePath'] ??
            foundPlant.metadata!['photo'] ?? 
            foundPlant.metadata!['image_url']
          ) : null,
          metadata: foundPlant.metadata,
          notes: foundPlant.notes,
        ))
      : PlantCatalogService.getPlantById(planting.plantId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: FutureBuilder<Plant?>(
        future: loadFuture,
        builder: (ctx, snap) {
          final plant = snap.data;
          String? raw;
          try {
            raw = plant?.imageUrl;
            if ((raw == null || raw.isEmpty) && plant?.metadata != null) {
              final meta = plant!.metadata;
              final metaCandidates = [
                meta['image'],
                meta['imagePath'],
                meta['photo'],
                meta['image_url'],
                meta['imageUrl']
              ];
              for (final c in metaCandidates) {
                if (c is String && c.trim().isNotEmpty) {
                  raw = c.trim();
                  break;
                }
              }
            }
          } catch (_) {
            raw = null;
          }

          if (raw != null) {
            // debugPrint('[PlantingImage] Resolved raw path for ${planting.plantName}: $raw');
          }

          final String commonNameFromPlanting = planting.plantName.trim();
          final base = raw ?? '';
          final id = (plant?.id ?? planting.plantId).toString();
          final catalogName = plant?.commonName.trim() ?? '';

          // 1. Network
          if (raw != null && raw.isNotEmpty && RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(raw)) {
             return Image.network(
               raw!,
               height: h,
               width: w,
               fit: fit,
               errorBuilder: (_, __, ___) => _fallback(),
             );
          }

          // 2. Local File (Custom Plants - Fix applied)
          if (raw != null && raw.isNotEmpty) {
             final bool isLocalFile = !raw.startsWith('assets/') && (raw.startsWith('/') || raw.startsWith('file:') || (raw.contains(Platform.pathSeparator) && raw.contains('.')));
             if (isLocalFile) {
               var path = raw!;
               if (path.startsWith('file://')) path = path.substring(7);
               // debugPrint('[PlantingImage] Attempting local file load: $path');
               return Image.file(
                 File(path),
                 height: h,
                 width: w,
                 fit: fit,
                 errorBuilder: (_, __, ___) => _fallback(),
               );
             }
             
             // Explicit asset path
             if (raw.startsWith('assets/')) {
               return Image.asset(
                 raw,
                 height: h,
                 width: w,
                 fit: fit,
                 errorBuilder: (_, __, ___) => _fallback(),
               );
             }
          }

          final List<String> candidates = _buildCandidates(base, id, catalogName, commonNameFromPlanting);

          return FutureBuilder<String?>(
            future: () async {
              final cacheKey = '${planting.plantId}|${catalogName}|${base}';
              if (_resolvedAssetsCache.containsKey(cacheKey)) {
                return _resolvedAssetsCache[cacheKey];
              }
              final byManifest = await _searchManifestCandidates(candidates);
              if (byManifest != null) {
                _resolvedAssetsCache[cacheKey] = byManifest;
                return byManifest;
              }
              final byLoad = await _tryRootBundleLoad(candidates);
              if (byLoad != null) {
                _resolvedAssetsCache[cacheKey] = byLoad;
              }
              return byLoad;
            }(),
            builder: (c2, snap2) {
              if (snap2.connectionState != ConnectionState.done) {
                return Container(height: h, width: w, color: Colors.green.shade50);
              }
              final found = snap2.data;
              if (found != null) {
                return Image.asset(
                  found,
                   height: h,
                  width: w,
                  fit: fit,
                  errorBuilder: (_, __, ___) => _fallback(),
                );
              } else {
                return _fallback();
              }
            },
          );
        },
      ),
    );
  }
}
