import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/core/services/plant_catalog_service.dart';

class PlantingImage extends StatelessWidget {
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
      if (kDebugMode)
        debugPrint(
            'PlantingImage: loaded asset manifest (${m.length} entries)');
    } catch (e) {
      _assetManifestLowerToOriginal = null;
      if (kDebugMode)
        debugPrint('PlantingImage: AssetManifest load failed: $e');
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
      'À': 'A',
      'Á': 'A',
      'Â': 'A',
      'Ã': 'A',
      'Ä': 'A',
      'Å': 'A',
      'Ç': 'C',
      'È': 'E',
      'É': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'Ì': 'I',
      'Í': 'I',
      'Î': 'I',
      'Ï': 'I',
      'Ñ': 'N',
      'Ò': 'O',
      'Ó': 'O',
      'Ô': 'O',
      'Õ': 'O',
      'Ö': 'O',
      'Ù': 'U',
      'Ú': 'U',
      'Û': 'U',
      'Ü': 'U',
      'Ý': 'Y',
      'Ÿ': 'Y'
    };
    var out = s;
    table.forEach((k, v) {
      out = out.replaceAll(k, v);
    });
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

    // Helper to add candidates for a specific name
    void addNameCandidates(String name) {
      if (name.isEmpty) return;
      candidates.add('assets/images/legumes/$name');
      candidates.add('assets/images/plants/$name');
      // safe versions
      final safe = _toFilenameSafe(name);
      final altHyphen = safe.replaceAll('_', '-');
      for (final ext in ['.png', '.jpg', '.jpeg', '.webp']) {
        candidates.add('assets/images/legumes/$safe$ext');
        candidates.add('assets/images/legumes/$altHyphen$ext');
        candidates.add('assets/images/plants/$safe$ext');
        candidates.add('assets/images/plants/$altHyphen$ext');
      }
    }

    // 1. Prioritize Catalog Name (Official)
    addNameCandidates(catalogName);

    // 2. Fallback to Planting Name (might be English or user-customized)
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
  Widget build(BuildContext context) {
    final w = width ?? size ?? 60.0;
    final h = height ?? size ?? 60.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: FutureBuilder<Plant?>(
        future: PlantCatalogService.getPlantById(planting.plantId),
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

          final String commonNameFromPlanting = planting.plantName.trim();
          final base = raw ?? '';
          final id = (plant?.id ?? planting.plantId).toString();

          final catalogName = plant?.commonName.trim() ?? '';

          final List<String> candidates =
              _buildCandidates(base, id, catalogName, commonNameFromPlanting);

          // Return Resolved Image
          if (raw != null && raw.isNotEmpty) {
            // 1. Network
            if (RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(raw)) {
              return Image.network(
                raw!,
                height: h,
                width: w,
                fit: fit,
                errorBuilder: (_, __, ___) => _fallback(),
              );
            }
            
            // 2. Local File (Custom Plants)
            final bool isLocalFile = !raw.startsWith('assets/') && (raw.startsWith('/') || raw.startsWith('file:') || (raw.contains(Platform.pathSeparator) && raw.contains('.'))); 
            
            if (isLocalFile) {
               final file = File(raw);
               // We don't always check existsSync to avoid blocking UI, Image.file handles errors gracefully via errorBuilder
               return Image.file(
                 file,
                 height: h,
                 width: w,
                 fit: fit,
                 errorBuilder: (_, __, ___) => _fallback(),
               );
            }

            // 3. Explicit Asset Path
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
                // return placeholder while loading
                return Container(
                    height: h, width: w, color: Colors.green.shade50);
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
