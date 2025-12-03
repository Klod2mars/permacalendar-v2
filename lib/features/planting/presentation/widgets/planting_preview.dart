// lib/features/planting/presentation/widgets/planting_preview.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/core/services/plant_catalog_service.dart';

/// Compact visual preview used on the garden-bed screen.
/// - shows image (network / asset / resolved heuristically)
/// - overlays status pill + quantity badge
/// - below: plant name, planted/seeded date and simple harvest estimate
class PlantingPreview extends StatelessWidget {
  final Planting planting;
  final VoidCallback? onTap;
  final double imageSize;

  const PlantingPreview({
    Key? key,
    required this.planting,
    this.onTap,
    this.imageSize = 110,
  }) : super(key: key);

  // AssetManifest cache
  static Map<String, String>? _assetManifestLowerToOriginal;

  static Future<void> _ensureAssetManifest() async {
    if (_assetManifestLowerToOriginal != null) return;
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> map = json.decode(manifest);
      final m = <String, String>{};
      for (final k in map.keys) m[k.toLowerCase()] = k;
      _assetManifestLowerToOriginal = m;
      if (kDebugMode)
        debugPrint('PlantingPreview: loaded ${m.length} manifest entries');
    } catch (e) {
      _assetManifestLowerToOriginal = null;
      if (kDebugMode)
        debugPrint('PlantingPreview: unable to load AssetManifest: $e');
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

  static String _toFilenameSafe(String s) {
    var out = s.trim();
    out = out.replaceAll(RegExp(r'[^\w\s\-]'), '');
    out = out.replaceAll(RegExp(r'\s+'), '_');
    return out.toLowerCase();
  }

  /// Build a list of plausible asset paths to try (ordered).
  static List<String> _buildCandidates(
      String base, String id, String? commonName) {
    final candidates = <String>[];

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
        final exts = ['.png', '.jpg', '.jpeg', '.webp'];
        for (final e in exts) {
          candidates.add('assets/images/legumes/$base$e');
          candidates.add('assets/images/plants/$base$e');
          candidates.add('assets/images/$base$e');
          candidates.add('assets/$base$e');
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

    if (commonName != null && commonName.isNotEmpty) {
      final safe = _toFilenameSafe(commonName);
      final alt1 = safe;
      final alt2 = safe.replaceAll('_', '-');
      for (final e in ['.png', '.jpg', '.jpeg', '.webp']) {
        candidates.add('assets/images/legumes/${alt1}$e');
        candidates.add('assets/images/legumes/${alt2}$e');
        candidates.add('assets/images/plants/${alt1}$e');
        candidates.add('assets/images/plants/${alt2}$e');
      }
      candidates.add('assets/images/legumes/$commonName');
      candidates.add('assets/images/plants/$commonName');
    }

    // dedupe while preserving order
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

  Widget _fallback(double size) {
    return Container(
      height: size,
      width: size,
      color: Colors.green.shade50,
      alignment: Alignment.center,
      child: Icon(Icons.eco_outlined,
          size: size * 0.36, color: Colors.green.shade700),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Plant?>(
      future: PlantCatalogService.getPlantById(planting.plantId),
      builder: (ctx, snap) {
        final plant = snap.data;

        // priority: plant.imageUrl > plant.metadata fields > heuristic resolution by id/commonName
        String? raw;
        try {
          raw = plant?.imageUrl;
          if ((raw == null || raw.isEmpty) && (plant?.metadata != null)) {
            final meta = plant!.metadata;
            final candidates = [
              meta['image'],
              meta['imagePath'],
              meta['photo'],
              meta['image_url'],
              meta['imageUrl']
            ];
            for (final c in candidates) {
              if (c is String && c.trim().isNotEmpty) {
                raw = c.trim();
                break;
              }
            }
          }
        } catch (_) {
          raw = null;
        }

        // Build the image widget (may use FutureBuilder when heuristic is needed)
        Widget buildImageArea() {
          // network url
          if (raw != null &&
              raw.isNotEmpty &&
              RegExp(r'^(http|https):\/\/', caseSensitive: false)
                  .hasMatch(raw)) {
            if (kDebugMode)
              debugPrint(
                  'PlantingPreview: using network image for ${planting.plantId} -> $raw');
            return Image.network(
              raw!,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(imageSize),
            );
          }

          // explicit asset path
          if (raw != null && raw.isNotEmpty && raw.startsWith('assets/')) {
            if (kDebugMode)
              debugPrint(
                  'PlantingPreview: using explicit asset for ${planting.plantId} -> $raw');
            return Image.asset(
              raw,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(imageSize),
            );
          }

          // heuristic resolution (async)
          final base = raw ?? '';
          final id = plant?.id ?? planting.plantId;
          final cn = plant?.commonName ?? '';
          final candidates = _buildCandidates(base, id, cn);

          if (kDebugMode) {
            debugPrint(
                'PlantingPreview: resolving image for ${planting.plantId} -> candidates(${candidates.length}) sample=${candidates.take(6).toList()}');
          }

          return FutureBuilder<String?>(
            future: () async {
              // try manifest lookup first
              final byManifest = await _searchManifestCandidates(candidates);
              if (byManifest != null) return byManifest;
              // try rootBundle load
              final byLoad = await _tryRootBundleLoad(candidates);
              return byLoad;
            }(),
            builder: (c2, snap2) {
              if (snap2.connectionState != ConnectionState.done) {
                return Container(
                  height: imageSize,
                  width: imageSize,
                  color: Colors.green.shade50,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
              final found = snap2.data;
              if (found != null) {
                if (kDebugMode)
                  debugPrint(
                      'PlantingPreview: found asset for ${planting.plantId} -> $found');
                return Image.asset(
                  found,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(imageSize),
                );
              } else {
                if (kDebugMode)
                  debugPrint(
                      'PlantingPreview: no asset found for ${planting.plantId} -> fallback');
                return _fallback(imageSize);
              }
            },
          );
        }

        // estimate harvest
        final DateTime? estimateDate = planting.expectedHarvestStartDate ??
            (plant != null
                ? planting.plantedDate.add(Duration(days: plant.daysToMaturity))
                : null);

        // status colors
        Color statusBg(String status) {
          switch (status) {
            case 'Planté':
              return Colors.blue.withOpacity(0.18);
            case 'En croissance':
              return Colors.green.withOpacity(0.18);
            case 'Prêt à récolter':
              return Colors.orange.withOpacity(0.18);
            case 'Récolté':
              return Colors.green.withOpacity(0.26);
            case 'Échoué':
              return Colors.red.withOpacity(0.18);
            default:
              return theme.colorScheme.surfaceContainerHighest;
          }
        }

        Color statusTextColor(String status) {
          switch (status) {
            case 'Planté':
              return Colors.blue.shade700;
            case 'En croissance':
              return Colors.green.shade700;
            case 'Prêt à récolter':
              return Colors.orange.shade700;
            case 'Récolté':
              return Colors.green.shade800;
            case 'Échoué':
              return Colors.red.shade700;
            default:
              return theme.colorScheme.onSurface;
          }
        }

        // final widget assembly
        return GestureDetector(
          onTap: onTap ??
              () => GoRouter.of(context).push('/plantings/${planting.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image box with overlays
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.shade50,
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Positioned.fill(child: buildImageArea()),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg(planting.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          planting.status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusTextColor(planting.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${planting.quantity}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Name + dates
              SizedBox(
                width: imageSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(planting.plantName,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      planting.status == 'Semé'
                          ? 'Semé le ${_formatDate(planting.plantedDate)}'
                          : 'Planté le ${_formatDate(planting.plantedDate)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                    if (estimateDate != null)
                      Text(
                        'Récolte estimée: ${_formatDate(estimateDate)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
