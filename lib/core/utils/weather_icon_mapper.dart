/// Mapper pour associer les codes météo WMO aux icônes organiques

///

/// Utilise les codes météo de l'Organisation Météorologique Mondiale (WMO)

/// pour mapper vers les icônes du pack organique DeeVid.

import 'package:permacalendar/l10n/app_localizations.dart';

class WeatherIconMapper {
  /// Retourne le chemin vers l'icône météo correspondant au code WMO

  static String getIconPath(int? weatherCode) {
    if (weatherCode == null) return 'assets/weather_icons/default.svg';

    switch (weatherCode) {
      // Ciel clair

      case 0:
        return 'assets/weather_icons/clear_day.svg';

      // Partiellement nuageux

      case 1: // Principalement clair

      case 2: // Partiellement nuageux

      case 3: // Couvert

        return 'assets/weather_icons/cloudy.svg';

        return 'assets/weather_icons/partly_cloudy.svg';

      // Brouillard

      case 45: // Brouillard

      case 48: // Brouillard givrant

        return 'assets/weather_icons/fog.svg';

      // Bruine

      case 51: // Bruine légère

      case 53: // Bruine modérée

      case 55: // Bruine dense

        return 'assets/weather_icons/drizzle.svg';

      // Pluie

      case 61: // Pluie légère

      case 63: // Pluie modérée

      case 65: // Pluie forte

        return 'assets/weather_icons/rain.svg';

      // Pluie verglaçante

      case 66: // Pluie verglaçante légère

      case 67: // Pluie verglaçante forte

        return 'assets/weather_icons/freezing_rain.svg';

      // Averses

      case 80: // Averses légères

      case 81: // Averses modérées

      case 82: // Averses violentes

        return 'assets/weather_icons/showers.svg';

      // Neige

      case 71: // Chute de neige légère

      case 73: // Chute de neige modérée

      case 75: // Chute de neige forte

      case 77: // Grains de neige

        return 'assets/weather_icons/snow.svg';

      // Averses de neige

      case 85: // Averses de neige légères

      case 86: // Averses de neige fortes

        return 'assets/weather_icons/snow_showers.svg';

      // Orage

      case 95: // Orage

      case 96: // Orage avec grêle légère

      case 99: // Orage avec grêle forte

        return 'assets/weather_icons/thunderstorm.svg';

      // Vent

      case 20: // Brouillard

      case 21: // Pluie légère

      case 22: // Neige légère

      case 23: // Pluie et neige légères

      case 24: // Pluie modérée

      case 25: // Neige modérée

      case 26: // Pluie et neige modérées

      case 27: // Pluie forte

      case 28: // Neige forte

      case 29: // Pluie et neige fortes

        return 'assets/weather_icons/wind.svg';

      // Par défaut

      default:
        return 'assets/weather_icons/default.svg';
    }
  }


  /// Retourne une description textuelle localisée
  static String getLocalizedDescription(AppLocalizations l10n, int? weatherCode) {
    if (weatherCode == null) return l10n.wmo_code_unknown;

    switch (weatherCode) {
      case 0: return l10n.wmo_code_0;
      case 1: return l10n.wmo_code_1;
      case 2: return l10n.wmo_code_2;
      case 3: return l10n.wmo_code_3;
      case 45: return l10n.wmo_code_45;
      case 48: return l10n.wmo_code_48;
      case 51: return l10n.wmo_code_51;
      case 53: return l10n.wmo_code_53;
      case 55: return l10n.wmo_code_55;
      case 61: return l10n.wmo_code_61;
      case 63: return l10n.wmo_code_63;
      case 65: return l10n.wmo_code_65;
      case 66: return l10n.wmo_code_66;
      case 67: return l10n.wmo_code_67;
      case 71: return l10n.wmo_code_71;
      case 73: return l10n.wmo_code_73;
      case 75: return l10n.wmo_code_75;
      case 77: return l10n.wmo_code_77;
      case 80: return l10n.wmo_code_80;
      case 81: return l10n.wmo_code_81;
      case 82: return l10n.wmo_code_82;
      case 85: return l10n.wmo_code_85;
      case 86: return l10n.wmo_code_86;
      case 95: return l10n.wmo_code_95;
      case 96: return l10n.wmo_code_96;
      case 99: return l10n.wmo_code_99;
      default: return l10n.wmo_code_unknown;
    }
  }



  /// Retourne une icône de fallback en cas d'erreur de chargement

  static String getFallbackIcon() {
    return 'assets/weather_icons/default.svg';
  }

  /// Vérifie si un code météo est valide

  static bool isValidWeatherCode(int? weatherCode) {
    if (weatherCode == null) return false;

    return weatherCode >= 0 && weatherCode <= 99;
  }
}
