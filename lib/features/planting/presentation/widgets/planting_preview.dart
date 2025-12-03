// lib/features/planting/presentation/widgets/planting_preview.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/core/services/plant_catalog_service.dart';

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

  static Map<String, String>? _assetManifestLowerToOriginal;

  static Future<void> _ensureAssetManifest() async {
    if (_assetManifestLowerToOriginal != null) return;
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> map = json.decode(manifest);
      final m = <String, String>{};
      for (final k in map.keys) m[k.toLowerCase()] = k;
      _assetManifestLowerToOriginal = m;
      if (kDebugMode) debugPrint('PlantingPreview: loaded asset manifest (${m.length} entries)');
    } catch (e) {
      _assetManifestLowerToOriginal = null;
      if (kDebugMode) debugPrint('PlantingPreview: AssetManifest load failed: $e');
    }
  }

  static Future<String?> _searchManifestCandidates(List<String> candidates) async {
    await _ensureAssetManifest();
    if (_assetManifestLowerToOriginal == null) return null;
    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (_assetManifestLowerToOriginal!.containsKey(lc)) return _assetManifestLowerToOriginal![lc];
    }
    // try endsWith
    for (final c in candidates) {
      final lc = c.toLowerCase();
      for (final keyLower in _assetManifestLowerToOriginal!.keys) {
        if (keyLower.endsWith(lc)) return _assetManifestLowerToOriginal![keyLower];
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

  static List<String> _buildCandidates(String base, String id, String commonName) {
    final candidates = <String>[];

    // Primary: use commonName (from planting.plantName) — this fixes mismatch where assets use French names
    if (commonName.isNotEmpty) {
      // try raw commonName first (original capitalization)
      candidates.add('assets/images/legumes/$commonName');
      candidates.add('assets/images/plants/$commonName');
      // safe/normalized versions
      final safe = _toFilenameSafe(commonName);
      final altHyphen = safe.replaceAll('_', '-');
      for (final ext in ['.png', '.jpg', '.jpeg', '.webp']) {
        candidates.add('assets/images/legumes/$safe$ext');
        candidates.add('assets/images/legumes/$altHyphen$ext');
        candidates.add('assets/images/plants/$safe$ext');
        candidates.add('assets/images/plants/$altHyphen$ext');
      }
    }

    // If explicit base provided (metadata), include it
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

    // id-based fallback
    if (id.isNotEmpty) {
      candidates.add('assets/images/legumes/$id.jpg');
      candidates.add('assets/images/legumes/$id.png');
      candidates.add('assets/images/legumes/$id.webp');
      candidates.add('assets/images/plants/$id.jpg');
      candidates.add('assets/images/plants/$id.png');
    }

    // dedupe keeping order
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
      child: Icon(Icons.eco_outlined, size: size * 0.36, color: Colors.green.shade700),
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

        // Determine raw candidate (metadata or imageUrl) using plant if available
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

        // Use planting.plantName (this is the crucial change)
        final String commonNameFromPlanting = planting.plantName.trim();

        // Build candidates: prefer commonNameFromPlanting, fallback to raw, fallback to plant.id / planting.plantId
        final base = raw ?? '';
        final id = (plant?.id ?? planting.plantId).toString();
        final commonName = commonNameFromPlanting.isNotEmpty ? commonNameFromPlanting : (plant?.commonName ?? '');

        final candidates = _buildCandidates(base, id, commonName);

        if (kDebugMode) {
          debugPrint('PlantingPreview: resolving image for ${planting.plantId} (plantName="${planting.plantName}") -> candidates(${candidates.length}) sample=${candidates.take(6).toList()}');
        }

        Widget imageArea() {
          // If raw is network URL
          if (raw != null && raw.isNotEmpty && RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(raw)) {
            if (kDebugMode) debugPrint('PlantingPreview: using network image for ${planting.plantId} -> $raw');
            return Image.network(
              raw!,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(imageSize),
            );
          }

          // If raw points to explicit asset path
          if (raw != null && raw.isNotEmpty && raw.startsWith('assets/')) {
            if (kDebugMode) debugPrint('PlantingPreview: using explicit asset for ${planting.plantId} -> $raw');
            return Image.asset(
              raw,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(imageSize),
            );
          }

          // Otherwise resolve heuristically via manifest or rootBundle.load
          return FutureBuilder<String?>(
            future: () async {
              final byManifest = await _searchManifestCandidates(candidates);
              if (byManifest != null) return byManifest;
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
                if (kDebugMode) debugPrint('PlantingPreview: found asset for ${planting.plantId} -> $found');
                return Image.asset(
                  found,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(imageSize),
                );
              } else {
                if (kDebugMode) debugPrint('PlantingPreview: no asset found for ${planting.plantId} -> fallback');
                return _fallback(imageSize);
              }
            },
          );
        }

        final DateTime? estimateDate = planting.expectedHarvestStartDate ??
            (plant != null ? planting.plantedDate.add(Duration(days: plant.daysToMaturity)) : null);

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
            case 'Semé':
              return Colors.grey.withOpacity(0.22);
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
            case 'Semé':
              return Colors.white; // ensure contrast for semé pill
            default:
              return theme.colorScheme.onSurface;
          }
        }

        return GestureDetector(
          onTap: onTap ?? () => GoRouter.of(context).push('/plantings/${planting.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Positioned.fill(child: imageArea()),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${planting.quantity}',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: imageSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(planting.plantName,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      planting.status == 'Semé'
                          ? 'Semé le ${_formatDate(planting.plantedDate)}'
                          : 'Planté le ${_formatDate(planting.plantedDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                    ),
                    if (estimateDate != null)
                      Text(
                        'Récolte estimée: ${_formatDate(estimateDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
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
