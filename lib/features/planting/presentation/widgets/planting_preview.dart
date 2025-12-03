// lib/features/planting/presentation/widgets/planting_preview.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Asset manifest caching
  static List<String>? _assetManifestKeys;
  static Map<String, String>? _assetManifestLowerToOriginal;

  static Future<void> _ensureAssetManifestLoaded() async {
    if (_assetManifestKeys != null && _assetManifestLowerToOriginal != null) {
      return;
    }
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
      // ignore - fallback to direct load attempts
      _assetManifestKeys = null;
      _assetManifestLowerToOriginal = null;
    }
  }

  static Future<String?> _tryManifest(List<String> candidates) async {
    await _ensureAssetManifestLoaded();
    if (_assetManifestLowerToOriginal == null) return null;
    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (_assetManifestLowerToOriginal!.containsKey(lc)) {
        return _assetManifestLowerToOriginal![lc];
      }
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

  static Future<String?> _tryDirectLoad(List<String> candidates) async {
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

  static Future<String?> _findExistingAsset(
      String base, String id, String? cn) async {
    final List<String> candidates = <String>[];

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
        for (final ext in exts) {
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

    if (cn != null && cn.isNotEmpty) {
      final safe = _toFilenameSafe(cn);
      final alt1 = safe;
      final alt2 = safe.replaceAll('_', '-');
      final exts = ['.png', '.jpg', '.jpeg', '.webp'];
      for (final ext in exts) {
        candidates.add('assets/images/legumes/${alt1}$ext');
        candidates.add('assets/images/legumes/${alt2}$ext');
        candidates.add('assets/images/plants/${alt1}$ext');
        candidates.add('assets/images/plants/${alt2}$ext');
      }
      candidates.add('assets/images/legumes/${cn}');
      candidates.add('assets/images/plants/${cn}');
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

    final fromManifest = await _tryManifest(finalCandidates);
    if (fromManifest != null) return fromManifest;
    final direct = await _tryDirectLoad(finalCandidates);
    if (direct != null) return direct;
    return null;
  }

  static String _toFilenameSafe(String s) {
    var out = s.trim();
    out = out.replaceAll(RegExp(r'[^\w\s\-]'), '');
    out = out.replaceAll(RegExp(r'\s+'), '_');
    return out.toLowerCase();
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
    return FutureBuilder<Plant?>(
      future: PlantCatalogService.getPlantById(planting.plantId),
      builder: (ctx, snap) {
        final plant = snap.data;
        // Get raw candidate from plant metadata or imageUrl
        String? raw;
        try {
          raw = plant?.imageUrl;
          if ((raw == null || raw.isEmpty) && plant?.metadata != null) {
            final meta = plant!.metadata;
            final candidates = [
              meta['image'],
              meta['imagePath'],
              meta['photo'],
              meta['image_url'],
              meta['imageUrl'],
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

        // Build the image area as a FutureBuilder when needed.
        Widget imageArea() {
          // If we have a candidate raw path that's network
          if (raw != null &&
              raw.isNotEmpty &&
              RegExp(r'^(http|https):\/\/', caseSensitive: false)
                  .hasMatch(raw)) {
            debugPrint(
                'PlantingPreview: plantId=${planting.plantId} -> using network $raw');
            return Image.network(
              raw!,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                debugPrint('PlantingPreview: network error for $raw');
                return _fallback(imageSize);
              },
            );
          }

          // If raw is explicit asset path
          if (raw != null && raw.isNotEmpty && raw.startsWith('assets/')) {
            debugPrint(
                'PlantingPreview: plantId=${planting.plantId} -> using asset $raw');
            return Image.asset(
              raw,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                debugPrint('PlantingPreview: asset error for $raw');
                return _fallback(imageSize);
              },
            );
          }

          // Otherwise, resolve heuristically (or from id/commonName)
          return FutureBuilder<String?>(
            future: _findExistingAsset(raw ?? '', plant?.id ?? planting.plantId,
                plant?.commonName ?? ''),
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
                debugPrint(
                    'PlantingPreview: plantId=${planting.plantId} -> resolved asset: $found');
                return Image.asset(
                  found,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(imageSize),
                );
              } else {
                debugPrint(
                    'PlantingPreview: plantId=${planting.plantId} -> no asset found, fallback');
                return _fallback(imageSize);
              }
            },
          );
        }

        // Build status pill color/text
        Color _statusBg(String status, ThemeData theme) {
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
              return Theme.of(context).colorScheme.surfaceContainerHighest;
          }
        }

        Color _statusText(String status) {
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
              return Colors.black87;
          }
        }

        // Estimate harvest date
        final DateTime? estimateDate = planting.expectedHarvestStartDate ??
            (plant != null
                ? planting.plantedDate.add(Duration(days: plant.daysToMaturity))
                : null);

        return GestureDetector(
          onTap: onTap ??
              () =>
                  Navigator.of(context).pushNamed('/plantings/${planting.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image with overlays
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
                    // status pill
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusBg(planting.status, Theme.of(context)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          planting.status,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _statusText(planting.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                    // quantity badge
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // name and dates
              SizedBox(
                width: imageSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(planting.plantName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      planting.status == 'Semé'
                          ? 'Semé le ${_formatDate(planting.plantedDate)}'
                          : 'Planté le ${_formatDate(planting.plantedDate)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    if (estimateDate != null)
                      Text(
                        'Récolte estimée: ${_formatDate(estimateDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline),
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
