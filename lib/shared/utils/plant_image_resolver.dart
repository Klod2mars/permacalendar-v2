// lib/shared/utils/plant_image_resolver.dart
import 'dart:convert';
import 'package:flutter/services.dart';

String _normalizeDiacritics(String input) {
  if (input == null || input.isEmpty) return '';
  var s = input.toLowerCase().trim();
  const diacritics = {
    'à': 'a','á': 'a','â': 'a','ã': 'a','ä': 'a','å': 'a',
    'ç': 'c','è': 'e','é': 'e','ê': 'e','ë': 'e',
    'ì': 'i','í': 'i','î': 'i','ï': 'i','ñ':'n',
    'ò':'o','ó':'o','ô':'o','õ':'o','ö':'o',
    'ù':'u','ú':'u','û':'u','ü':'u','ý':'y','ÿ':'y',
    'œ':'oe','æ':'ae'
  };
  diacritics.forEach((k, v) => s = s.replaceAll(k, v));
  // remove punctuation but keep spaces, underscores, hyphens and alphanumerics
  s = s.replaceAll(RegExp(r'[^a-z0-9\s_\-]'), '');
  s = s.replaceAll(RegExp(r'\s+'), ' ');
  return s;
}

Future<String?> findPlantImageAsset(dynamic plant) async {
  try {
    final manifest = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> m = json.decode(manifest);
    final mapLower = <String, String>{};
    for (final k in m.keys) {
      mapLower[k.toLowerCase()] = k;
    }

    // extract raw metadata image
    String? raw;
    try {
      final meta = (plant?.metadata);
      if (meta != null && meta is Map) {
        raw = meta['image'] ??
            meta['imagePath'] ??
            meta['photo'] ??
            meta['image_url'] ??
            meta['imageUrl'] ??
            meta['image_search_term']; // Fallback injected by repository
        if (raw is String) raw = raw.trim();
      }
    } catch (_) {}

    // helper to add candidate variants
    final candidates = <String>{};
    void addCandidate(String c) {
      if (c == null || c.trim().isEmpty) return;
      candidates.add(c);
      candidates.add(c.toLowerCase());
    }

    // If raw provided
    if (raw != null && raw.isNotEmpty) {
      final base = raw;
      if (RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(base)) {
        // It's a network image — return raw so caller can treat network.
        return base;
      }
      if (base.startsWith('file:') || base.startsWith('/')) {
        // Local absolute path
        return base;
      }
      if (base.startsWith('assets/')) {
        addCandidate(base);
      } else {
        // Try in assets folders
        final prefixes = [
          'assets/images/legumes/',
          'assets/images/plants/',
          'assets/'
        ];
        if (RegExp(r'\.\w+$').hasMatch(base)) {
          for (final p in prefixes) {
            addCandidate('$p$base');
          }
        } else {
          final exts = ['.png', '.jpg', '.jpeg', '.webp'];
          for (final p in prefixes) {
            addCandidate('$p$base');
            for (final e in exts) addCandidate('$p$base$e');
          }
        }
      }
    }

    // try id-based
    final id = (plant?.id ?? '').toString();
    if (id.isNotEmpty) {
      final prefixes = ['assets/images/legumes/', 'assets/images/plants/', 'assets/'];
      final exts = ['.jpg', '.png', '.webp', '.jpeg'];
      for (final p in prefixes) {
        for (final e in exts) addCandidate('$p$id$e');
        addCandidate('$p$id');
      }
    }

    // try commonName normalized and raw variations
    final cn = (plant?.commonName ?? '').toString();
    if (cn.isNotEmpty) {
      final normalized = _normalizeDiacritics(cn).replaceAll(' ', '_');
      final normalizedSpace = _normalizeDiacritics(cn);
      final rawLower = cn.toLowerCase().trim();
      final exts = ['.png', '.jpg', '.jpeg', '.webp'];
      final prefixes = ['assets/images/legumes/', 'assets/images/plants/'];
      for (final p in prefixes) {
        for (final e in exts) {
          addCandidate('$p$normalized$e');
          addCandidate('$p${normalized.toLowerCase()}$e');
          addCandidate('$p${rawLower.replaceAll(' ', '_')}$e');
        }
        addCandidate('$p$normalized');
        addCandidate('$p${normalized.toLowerCase()}');
        addCandidate('$p${normalizedSpace}');
      }
    }

    // Try fallback search term (e.g. French name for legacy images)
    if (plant?.metadata != null && plant!.metadata is Map) {
      final searchTerm = plant.metadata['image_search_term'];
      if (searchTerm != null && searchTerm is String && searchTerm.isNotEmpty) {
        final normalized = _normalizeDiacritics(searchTerm).replaceAll(' ', '_');
        final rawLower = searchTerm.toLowerCase().trim();
        final exts = ['.png', '.jpg', '.jpeg', '.webp'];
        final prefixes = ['assets/images/legumes/', 'assets/images/plants/'];
        for (final p in prefixes) {
          for (final e in exts) {
            addCandidate('$p$normalized$e');
            addCandidate('$p${normalized.toLowerCase()}$e');
            addCandidate('$p${rawLower.replaceAll(' ', '_')}$e');
          }
        }
      }
    }

    // Allow underscore/hyphen variants
    final additional = <String>{};
    for (final c in candidates) {
      additional.add(c.replaceAll('_', '-'));
      additional.add(c.replaceAll('-', '_'));
      additional.add(c.replaceAll(' ', '_'));
      additional.add(c.replaceAll(' ', '-'));
    }
    candidates.addAll(additional);

    // Try manifest exact lowercase
    for (final c in candidates) {
      final lc = c.toLowerCase();
      if (mapLower.containsKey(lc)) return mapLower[lc];
    }

    // Try endsWith matches (handles prefix differences)
    for (final c in candidates) {
      final lc = c.toLowerCase();
      for (final keyLower in mapLower.keys) {
        if (keyLower.endsWith(lc)) return mapLower[keyLower];
      }
    }

    // Last resort: try rootBundle.load
    for (final c in candidates) {
      try {
        await rootBundle.load(c);
        return c;
      } catch (_) {}
    }

  } catch (_) {}
  return null;
}
