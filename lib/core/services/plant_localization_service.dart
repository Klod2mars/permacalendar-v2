import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/plant_catalog/domain/entities/plant_entity.dart';

/// Service responsible for looking up and merging localized strings into Plant objects.
class PlantLocalizationService {
  static final PlantLocalizationService _instance =
      PlantLocalizationService._internal();

  factory PlantLocalizationService() {
    return _instance;
  }

  PlantLocalizationService._internal();

  Map<String, dynamic> _localizedData = {};
  String _currentLocale = 'fr';
  bool _isLoaded = false;

  /// Loads the localization file for the given locale.
  Future<void> loadLocale(String locale) async {
    try {
      // For Sprint 1, we force 'fr' or assume file naming convention matches
      // In production, this would look up `assets/data/i18n/plants_$locale.json`
      final path = 'assets/data/json_multilangue_doc/plants_$locale.json'; 
      final jsonString = await rootBundle.loadString(path);
      _localizedData = json.decode(jsonString);
      _currentLocale = locale;
      _isLoaded = true;
      // print('PlantLocalizationService: Loaded $locale with ${_localizedData.length} entries.');
    } catch (e) {
      // print('PlantLocalizationService: Error loading locale $locale: $e');
      // If load fails, we keep empty map, so we show technical tokens (graceful degradation)
      _localizedData = {};
      _isLoaded = false;
    }
  }

  /// Merges localized data into a PlantFreezed object.
  PlantFreezed localize(PlantFreezed plant) {
    if (!_isLoaded || !_localizedData.containsKey(plant.id)) {
      return _localizeEnumsOnly(plant);
    }

    final loc = _localizedData[plant.id] as Map<String, dynamic>;

    // Audit Patch 3: Normalize list fields to prevent null
    final cultural = _normalizeListField(loc['culturalTips']);

    return plant.copyWith(
      commonName: loc['commonName'] ?? plant.commonName,
      description: loc['description'] ?? plant.description,
      // Apply normalized list if available, else keep original (which mimics current behavior but safer)
      // Actually, if loc doesn't have it, we keep plant's. If loc has it, we use the safe list.
      culturalTips: cultural.isNotEmpty ? cultural : (plant.culturalTips ?? <String>[]),
      harvestTime: loc['harvestTime'] ?? plant.harvestTime,
    ).copyWith(
       // Apply Enum mappings
       sunExposure: _translateEnum('sunExposure', plant.sunExposure),
       waterNeeds: _translateEnum('waterNeeds', plant.waterNeeds),
       plantingSeason: _translateSeasonList(plant.plantingSeason), 
       harvestSeason: _translateSeasonList(plant.harvestSeason),
       notificationSettings: _mergeNotificationMessages(plant.notificationSettings, loc['notificationSettings']) ?? {},
       companionPlanting: _normalizeCompanionPlanting(plant.companionPlanting, loc['companionPlanting']),
    );
  }

  Map<String, dynamic> _normalizeCompanionPlanting(Map<String, dynamic>? original, dynamic locData) {
    final base = Map<String, dynamic>.from(original ?? {});
    base['beneficial'] = _normalizeListField(base['beneficial']);
    base['avoid'] = _normalizeListField(base['avoid']);
    base['notes'] = base['notes'] ?? '';

    if (locData is Map) {
       if (locData['notes'] != null) base['notes'] = locData['notes'];
       // We usually don't localize IDs in beneficial/avoid, but if needed:
       // if (locData['beneficial'] != null) base['beneficial'] = _normalizeListField(locData['beneficial']);
       // if (locData['avoid'] != null) base['avoid'] = _normalizeListField(locData['avoid']);
    }
    return base;
  }

  // Helper from Audit to ensure List<String>
  List<String> _normalizeListField(dynamic field) {
    if (field == null) return <String>[];
    if (field is List) {
      return field.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }
    if (field is String) {
      return field
        .split(RegExp(r'[;,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    }
    return <String>[];
  }

  PlantFreezed _localizeEnumsOnly(PlantFreezed plant) {
     return plant.copyWith(
       sunExposure: _translateEnum('sunExposure', plant.sunExposure),
       waterNeeds: _translateEnum('waterNeeds', plant.waterNeeds),
       plantingSeason: _translateSeasonList(plant.plantingSeason), 
       harvestSeason: _translateSeasonList(plant.harvestSeason),
     );
  }

  // Temporary Hardcoded Mappings for Sprint 1 Retro-compatibility
  String _translateEnum(String type, String token) {
    if (_currentLocale != 'fr') return token; // Only FR supported for legacy map
    
    // Check if it's already localized (legacy data)
    if (!token.contains('_') && !token.contains('UNKNOWN')) return token;

    switch (type) {
      case 'sunExposure':
        const map = {
          'SUN_FULL': 'Plein soleil',
          'SUN_PARTIAL': 'Mi-soleil',
          'SUN_PARTIAL_SHADE': 'Mi-ombre', // Or 'Ombre légère'
          'SUN_SHADE': 'Ombre',
          'SUN_FULL_PARTIAL': 'Plein soleil, Mi-ombre',
          'SUN_PARTIAL_SHADE_SHADE': 'Mi-ombre, Ombre',
        };
        return map[token] ?? token;
        
      case 'waterNeeds':
         const map = {
          'WATER_LOW': 'Faible',
          'WATER_MEDIUM': 'Moyen',
          'WATER_HIGH': 'Élevé',
          'WATER_MEDIUM_HIGH': 'Modéré à élevé',
        };
        return map[token] ?? token;
        
      default:
        return token;
    }
  }

  String _translateSeasonList(String tokenList) {
    if (_currentLocale != 'fr') return tokenList;
    if (tokenList.isEmpty) return tokenList;

    // Tokens are likely comma separated or a single string?
    // In tokenized JSON: "plantingSeason": ["SPRING", "SUMMER"] (List) OR String?
    // PlantFreezed has `String plantingSeason`.
    // My script outputted List<String> in JSON... 
    // BUT PlantHive/PlantFreezed define it as String. 
    // -> If Hive loads a List into a String field, it usually calls toString() -> "[SPRING, SUMMER]"
    // This is MESSY. 
    // PlantHiveRepository line 462: `_getStringValue(json, 'plantingSeason', ...)`
    // If json has ["SPRING", "SUMMER"], _getStringValue returns "['SPRING', 'SUMMER']".
    // I need to intercept this in PlantHiveRepository OR handle it here.
    
    // Ideally, I should join them back in the Repository for now, 
    // OR parse the ugly string here.
    
    // Let's assume Repository joins them or they come as string.
    // Actually, looking at `transform_plants.py`: `p_out['plantingSeason'] = map_seasons(...)` -> Returns LIST.
    // `PlantHiveRepository` `_getStringValue` calls `value?.toString()`.
    // So "['SPRING', 'SUMMER']".
    
    // CLEAN FIX: I should update PlantHiveRepository to join the list if it finds one.
    // For here, I will try to clean up.
    
    String clean = tokenList.replaceAll('[', '').replaceAll(']', '');
    List<String> tokens = clean.split(',').map((e) => e.trim()).toList();
    
    const map = {
      'SPRING': 'Printemps',
      'SUMMER': 'Été',
      'AUTUMN': 'Automne',
      'WINTER': 'Hiver',
    };
    
    List<String> translated = [];
    for (var t in tokens) {
      if (map.containsKey(t)) {
        translated.add(map[t]!);
      } else {
        translated.add(t);
      }
    }
    return translated.join(',');
  }

  Map<String, dynamic>? _mergeNotificationMessages(Map<String, dynamic>? original, Map<String, dynamic>? loc) {
    if (original == null) return {};
    if (loc == null) return original; // No localized messages

    // Create a copy to modify
    Map<String, dynamic> merged = Map.from(original);

    loc.forEach((key, val) {
       if (merged.containsKey(key) && val is Map && val.containsKey('message')) {
         if (merged[key] is Map) {
            // merged[key] is likely "LinkedMap". Need to be careful.
            var subMap = Map<String, dynamic>.from(merged[key]);
            subMap['message'] = val['message'];
            merged[key] = subMap;
         }
       }
       // Deep nested Temperature ?
        if (key == 'temperature_alert' && val is Map) {
             var tempMap = merged['temperature_alert'];
             if (tempMap is Map) {
                 var newTempMap = Map<String, dynamic>.from(tempMap);
                 val.forEach((subK, subV) {
                      if (newTempMap.containsKey(subK) && subV is Map && subV.containsKey('message')) {
                           var finalMap = Map<String, dynamic>.from(newTempMap[subK]);
                           finalMap['message'] = subV['message'];
                           newTempMap[subK] = finalMap;
                      }
                 });
                 merged['temperature_alert'] = newTempMap;
             }
        }
    });

    return merged;
  }
}
