// lib/shared/utils/plant_image_resolver.dart
import 'dart:convert';
import 'package:flutter/services.dart';

/// Résolveur d'asset d'image pour une "plant" (tolérant casse / extension / dossiers).
/// Accepte un `plant` dynamique (doit exposer `id`, `commonName`, `metadata`).
Future<String?> findPlantImageAsset(dynamic plant) async {
  try {
    // 1) Charger manifest et table lowercase -> original
    final manifest = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> m = json.decode(manifest);
    final mapLower = <String, String>{};
    for (final k in m.keys) {
      mapLower[k.toLowerCase()] = k;
    }

    // 2) extraire valeur metadata si présente
    String? raw;
    try {
      final meta = (plant?.metadata);
      if (meta != null && meta is Map) {
        raw = meta['image'] ??
            meta['imagePath'] ??
            meta['photo'] ??
            meta['image_url'] ??
            meta['imageUrl'];
        if (raw is String) raw = raw.trim();
      }
    } catch (_) {}

    // 3) construire candidats
    final candidates = <String>[];
    if (raw != null && raw.isNotEmpty) {
      final base = raw;
      // si l'utilisateur a mis un chemin assets/ explicite
      if (base.startsWith('assets/')) {
        candidates.add(base);
        candidates.add(base.toLowerCase());
      } else {
        candidates.add('assets/images/legumes/$base');
        candidates.add('assets/images/legumes/${base.toLowerCase()}');
        candidates.add('assets/images/plants/$base');
        candidates.add('assets/images/plants/${base.toLowerCase()}');
        candidates.add('assets/$base');
        candidates.add('assets/${base.toLowerCase()}');

        if (!RegExp(r'\.\w+$').hasMatch(base)) {
          final exts = ['.png', '.jpg', '.jpeg', '.webp'];
          for (final ext in exts) {
            candidates.add('assets/images/legumes/${base}$ext');
            candidates.add('assets/images/legumes/${base.toLowerCase()}$ext');
            candidates.add('assets/images/plants/${base}$ext');
            candidates.add('assets/images/plants/${base.toLowerCase()}$ext');
          }
        } else {
          candidates.add('assets/images/legumes/${base.toLowerCase()}');
          candidates.add('assets/images/plants/${base.toLowerCase()}');
        }
      }
    }

    // ajouter candidats id / commonName
    final id = (plant?.id ?? '').toString();
    if (id.isNotEmpty) {
      candidates.add('assets/images/legumes/$id.jpg');
      candidates.add('assets/images/legumes/$id.png');
      candidates.add('assets/images/legumes/$id.webp');
      candidates.add('assets/images/plants/$id.jpg');
      candidates.add('assets/images/plants/$id.png');
    }

    final cn = (plant?.commonName ?? '').toString();
    if (cn.isNotEmpty) {
      var safe = cn.toLowerCase().trim();
      safe = safe.replaceAll(RegExp(r'[^a-z0-9_\-]'), '_');
      final exts = ['.png', '.jpg', '.jpeg', '.webp'];
      for (final ext in exts) {
        candidates.add('assets/images/legumes/${safe}$ext');
        candidates.add('assets/images/plants/${safe}$ext');
      }
    }

    // dédupliquer
    final seen = <String>{};
    final finalCandidates = <String>[];
    for (final c in candidates) {
      if (c != null && c.isNotEmpty && !seen.contains(c)) {
        seen.add(c);
        finalCandidates.add(c);
      }
    }

    // 4) recherche via manifest (insensible à la casse)
    for (final c in finalCandidates) {
      final lc = c.toLowerCase();
      if (mapLower.containsKey(lc)) return mapLower[lc];
    }
    for (final c in finalCandidates) {
      final lc = c.toLowerCase();
      for (final keyLower in mapLower.keys) {
        if (keyLower.endsWith(lc)) return mapLower[keyLower];
      }
    }

    // 5) dernier recours : essayer rootBundle.load
    for (final c in finalCandidates) {
      try {
        await rootBundle.load(c);
        return c;
      } catch (_) {}
    }
  } catch (_) {}
  return null;
}
