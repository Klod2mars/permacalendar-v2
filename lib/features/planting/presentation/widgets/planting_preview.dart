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

  static List<String>? _assetManifestKeys;
  static Map<String, String>? _assetManifestLowerToOriginal;

  // -------------------------
  // Asset manifest helpers
  // -------------------------
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
    // ending with match
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

    // base provided (maybe a filename or id)
    if (base.isNotEmpty) {
      if (base.startsWith('assets/')) {
        candidates.add(base);
        candidates.add(base.toLowerCase());
      } else {
        candidates.add('assets/images/legumes/$base');
        candidates.add('assets/images/plants/$base');
        candidates.add('assets/$base');
        candidates.add('assets/images/$base');
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

    // id-based candidates
    if (id.isNotEmpty) {
      candidates.add('assets/images/legumes/$id.jpg');
      candidates.add('assets/images/legumes/$id.png');
      candidates.add('assets/images/legumes/$id.webp');
      candidates.add('assets/images/plants/$id.jpg');
      candidates.add('assets/images/plants/$id.png');
    }

    // common name candidates
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

    // dedupe
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Plant?>(
      future: PlantCatalogService.getPlantById(planting.plantId),
      builder: (ctx, snap) {
        final plant = snap.data;
        // prioritize imageUrl, then metadata image fields, then try to resolve assets
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

        Widget imageWidget;

        if (raw != null && raw.isNotEmpty) {
          final isNetwork =
              RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(raw);
          if (isNetwork) {
            imageWidget = Image.network(
              raw,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(imageSize),
            );
          } else if (raw.startsWith('assets/')) {
            imageWidget = Image.asset(
              raw,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(imageSize),
            );
          } else {
            // try heuristic asset resolution
            return FutureBuilder<String?>(
              future: _findExistingAsset(
                  raw, plant?.id ?? planting.plantId, plant?.commonName ?? ''),
              builder: (ctx2, snap2) {
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
                  return GestureDetector(
                    onTap: onTap ??
                        () => Navigator.of(ctx)
                            .pushNamed('/plantings/${planting.id}'),
                    child: Image.asset(
                      found,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(imageSize),
                    ),
                  );
                } else {
                  // fallback to simple asset or fallback icon
                  return GestureDetector(
                    onTap: onTap ??
                        () => Navigator.of(ctx)
                            .pushNamed('/plantings/${planting.id}'),
                    child: _fallback(imageSize),
                  );
                }
              },
            );
          }
        } else {
          // no raw path => try resolving by id or commonName
          return FutureBuilder<String?>(
            future: _findExistingAsset(
                '', plant?.id ?? planting.plantId, plant?.commonName ?? ''),
            builder: (ctx2, snap2) {
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
                return GestureDetector(
                  onTap: onTap ??
                      () => Navigator.of(ctx)
                          .pushNamed('/plantings/${planting.id}'),
                  child: Image.asset(
                    found,
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(imageSize),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: onTap ??
                      () => Navigator.of(ctx)
                          .pushNamed('/plantings/${planting.id}'),
                  child: _fallback(imageSize),
                );
              }
            },
          );
        }

        // if we reach here, imageWidget was set (network or asset straightforward)
        return GestureDetector(
          onTap: onTap ??
              () =>
                  Navigator.of(context).pushNamed('/plantings/${planting.id}'),
          child: Container(
            width: imageSize,
            height: imageSize,
            child: imageWidget,
          ),
        );
      },
    );
  }
}
