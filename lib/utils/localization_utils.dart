import 'dart:ui';
import '../models/plant_localized.dart';

class LocalizationUtils {
  /// Returns the best available name for the plant based on the locale.
  /// Precedence:
  /// 1. Exact match (e.g. fr_FR)
  /// 2. Language match (e.g. fr)
  /// 3. English (en)
  /// 4. Scientific Name
  static String getLocalizedPlantName(PlantLocalized plant, Locale locale) {
    // 1. Exact match (e.g. "pt_BR")
    // Note: defined locales in this app are often string based keys in the map like "pt_BR", "fr", etc.
    // The locale object has languageCode and countryCode.
    
    // Try full tag (e.g. "pt_BR")
    String fullTag = locale.toString();
    if (plant.localized.containsKey(fullTag) && plant.localized[fullTag]!.commonName.isNotEmpty) {
      return plant.localized[fullTag]!.commonName;
    }
    
    // Try language code (e.g. "fr")
    String langCode = locale.languageCode;
    if (plant.localized.containsKey(langCode) && plant.localized[langCode]!.commonName.isNotEmpty) {
      return plant.localized[langCode]!.commonName;
    }
    
    // Try English
    if (plant.localized.containsKey('en') && plant.localized['en']!.commonName.isNotEmpty) {
      return plant.localized['en']!.commonName;
    }
    
    // Fallback
    return plant.scientificName;
  }
}
