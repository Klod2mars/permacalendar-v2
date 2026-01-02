import 'dart:convert';
import 'dart:io';
import 'package:permacalendar/features/plant_catalog/data/models/plant_hive.dart';

// Copy of helper methods from PlantHiveRepository
String _getStringValue(
    Map<String, dynamic> json, String key, String defaultValue) {
  try {
    final value = json[key];
    return value?.toString() ?? defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

String? _getOptionalStringValue(Map<String, dynamic> json, String key) {
  try {
    final value = json[key];
    return value?.toString();
  } catch (e) {
    return null;
  }
}

int _getIntValue(Map<String, dynamic> json, String key, int defaultValue) {
  try {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

double _getDoubleValue(
    Map<String, dynamic> json, String key, double defaultValue) {
  try {
    final value = json[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

double? _getOptionalDoubleValue(Map<String, dynamic> json, String key) {
  try {
    final value = json[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  } catch (e) {
    return null;
  }
}

List<String> _getStringListValue(
    Map<String, dynamic> json, String key, List<String> defaultValue) {
  try {
    final value = json[key];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

List<String>? _getOptionalStringListValue(
    Map<String, dynamic> json, String key) {
  try {
    final value = json[key];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  } catch (e) {
    return null;
  }
}

Map<String, dynamic> _getMapValue(
    Map<String, dynamic> json, String key, Map<String, dynamic> defaultValue) {
  try {
    final value = json[key];
    if (value is Map) return Map<String, dynamic>.from(value);
    return defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

Map<String, dynamic>? _getOptionalMapValue(
    Map<String, dynamic> json, String key) {
  try {
    final value = json[key];
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  } catch (e) {
    return null;
  }
}

PlantHive _createPlantHiveFromJson(Map<String, dynamic> json) {
  // Récupérer l'ID d'abord (utilisé pour proposer une image par défaut si besoin)
  final id = _getStringValue(
      json, 'id', 'unknown_${DateTime.now().millisecondsSinceEpoch}');

  // Récupérer / normaliser les métadonnées
  final Map<String, dynamic> meta = _getMapValue(json, 'metadata', {});

  // === NORMALISATION LÉGÈRE POUR plants_merged_clean.json ===
  // 1) sowingMonths3 -> sowingMonths (si présent)
  if (json.containsKey('sowingMonths3') && json['sowingMonths3'] is List) {
    try {
      json['sowingMonths'] = List<String>.from(json['sowingMonths3'] as List);
    } catch (_) {}
  }

  // 2) biologicalControl.companionPlants : string -> List<String>
  if (json['biologicalControl'] is Map) {
    final bc = Map<String, dynamic>.from(json['biologicalControl'] as Map);
    final cp = bc['companionPlants'];
    if (cp is String) {
      final list = cp
          .split(RegExp(r'[;,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      bc['companionPlants'] = list;
      json['biologicalControl'] = bc;
    } else if (cp is List) {
      bc['companionPlants'] = cp.map((e) => e.toString().trim()).toList();
      json['biologicalControl'] = bc;
    }

    // 2b) Normaliser les températures dans preparations si ce sont des strings ("20 °C" -> 20.0)
    if (bc['preparations'] is List) {
      final preparations = List.from(bc['preparations'] as List);
      for (var i = 0; i < preparations.length; i++) {
        final p = Map<String, dynamic>.from(preparations[i] as Map);
        for (final k in ['temperature', 'temp']) {
          final v = p[k];
          if (v is String) {
            final m = RegExp(r'([-+]?[0-9]*\.?[0-9]+)').firstMatch(v);
            if (m != null) p[k] = double.tryParse(m.group(0)!);
          } else if (v is int || v is double) {
            p[k] = (v as num).toDouble();
          }
        }
        preparations[i] = p;
      }
      bc['preparations'] = preparations;
      json['biologicalControl'] = bc;
    }
  }

  // 3) companionPlanting : s'assurer que beneficial est une liste,
  //    déplacer les phrases 'éviter...' vers avoid et notes
  if (json['companionPlanting'] is Map) {
    final cp = Map<String, dynamic>.from(json['companionPlanting'] as Map);
    final ben = cp['beneficial'];
    if (ben is String) {
      final parts = ben
          .split(RegExp(r'[;\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final List<String> newBen = [];
      final List<String> avoids = List<String>.from(cp['avoid'] ?? []);
      final List<String> notesList = [];
      for (final item in parts) {
        if (item.toLowerCase().contains('éviter') ||
            item.toLowerCase().contains('eviter')) {
          // extraire les noms après 'éviter'
          final after = item
              .replaceAll(RegExp(r'(?i)éviter'), '')
              .replaceAll(RegExp(r'[:,-]'), ' ')
              .split(RegExp(r'\s+'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          avoids.addAll(after);
          notesList.add(item);
        } else {
          newBen.add(item);
        }
      }
      cp['beneficial'] = newBen;
      cp['avoid'] = avoids;
      if (notesList.isNotEmpty)
        cp['notes'] = (cp['notes'] ?? '').toString().trim() +
            (cp['notes'] != null && cp['notes'].toString().isNotEmpty
                ? '; '
                : '') +
            notesList.join('; ');
      json['companionPlanting'] = cp;
    }
  }

  // 4) squelette notificationSettings si absent
  if (!json.containsKey('notificationSettings') ||
      json['notificationSettings'] == null) {
    json['notificationSettings'] = {
      'thinning': {},
      'watering': {},
      'harvest': {},
      'general': {}
    };
  }

  // FIN NORMALISATION
  // Si aucune clé d'image n'est présente, proposer automatiquement une image basée sur l'ID.
  // L'écran acceptera "tomato.jpg" et préfixera "assets/images/legumes/" si nécessaire.
  final hasImage = meta.containsKey('image') ||
      meta.containsKey('imagePath') ||
      meta.containsKey('photo') ||
      meta.containsKey('image_url') ||
      meta.containsKey('imageUrl');

  if (!hasImage) {
    final candidateBase = id.toLowerCase();
    // Choix par défaut : JPG (peut être adapté)
    final defaultImage = '${candidateBase}.jpg';
    meta['image'] = defaultImage;
  }

  return PlantHive(
    // Champs obligatoires avec valeurs par défaut si manquants
    id: id,
    commonName: _getStringValue(json, 'commonName', 'Nom inconnu'),
    scientificName: _getStringValue(json, 'scientificName', 'Espèce inconnue'),
    family: _getStringValue(json, 'family', 'Famille inconnue'),
    plantingSeason: _getStringValue(json, 'plantingSeason', 'Toute saison'),
    harvestSeason: _getStringValue(json, 'harvestSeason', 'Variable'),
    daysToMaturity: _getIntValue(json, 'daysToMaturity', 90),
    spacing: _getIntValue(json, 'spacing', 30),
    depth: _getDoubleValue(json, 'depth', 1.0),
    sunExposure: _getStringValue(json, 'sunExposure', 'Plein soleil'),
    waterNeeds: _getStringValue(json, 'waterNeeds', 'Moyen'),
    description:
        _getStringValue(json, 'description', 'Description non disponible'),
    sowingMonths: _getStringListValue(json, 'sowingMonths', ['M', 'A', 'M']),
    harvestMonths: _getStringListValue(json, 'harvestMonths', ['J', 'J', 'A']),
    // Champs optionnels
    marketPricePerKg: _getOptionalDoubleValue(json, 'marketPricePerKg'),
    defaultUnit: _getOptionalStringValue(json, 'defaultUnit'),
    nutritionPer100g: _getOptionalMapValue(json, 'nutritionPer100g'),
    germination: _getOptionalMapValue(json, 'germination'),
    growth: _getOptionalMapValue(json, 'growth'),
    watering: _getOptionalMapValue(json, 'watering'),
    thinning: _getOptionalMapValue(json, 'thinning'),
    weeding: _getOptionalMapValue(json, 'weeding'),
    culturalTips: _getOptionalStringListValue(json, 'culturalTips'),
    biologicalControl: _getOptionalMapValue(json, 'biologicalControl'),
    harvestTime: _getOptionalStringValue(json, 'harvestTime'),
    companionPlanting: _getOptionalMapValue(json, 'companionPlanting'),
    notificationSettings: _getOptionalMapValue(json, 'notificationSettings'),
    varieties: _getOptionalMapValue(json, 'varieties'),
    metadata: meta,
    // Métadonnées temporelles
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isActive: true,
  );
}

void main() {
  print('Starting reproduction script...');
  try {
    final file = File('assets/data/plants_merged_clean.json');
    if (!file.existsSync()) {
      print('File not found!');
      return;
    }

    final jsonString = file.readAsStringSync();
    final jsonData = json.decode(jsonString);

    List<dynamic> plantsList = [];
    if (jsonData is Map<String, dynamic>) {
      plantsList = jsonData['plants'] as List? ?? [];
    } else if (jsonData is List) {
      plantsList = jsonData;
    }

    print('Found ${plantsList.length} plants.');

    int success = 0;
    int error = 0;

    for (var i = 0; i < plantsList.length; i++) {
      try {
        _createPlantHiveFromJson(plantsList[i]);
        success++;
      } catch (e) {
        error++;
        print('Error parsing plant at index $i: $e');
        if (error < 5) {
          // Print stacktrace for first few errors
          // print(StackTrace.current);
        }
      }
    }

    print('Finished: Success=$success, Error=$error');
  } catch (e) {
    print('Fatal error: $e');
  }
}
