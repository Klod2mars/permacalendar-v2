ï»¿/// Mapper pour associer les codes météo WMO aux icônes organiques
///
/// Utilise les codes météo de l'Organisation Météorologique Mondiale (WMO)
/// pour mapper vers les icônes du pack organique DeeVid.
class WeatherIconMapper {
  /// Retourne le chemin vers l'icône météo correspondant au code WMO
  static String getIconPath(int? weatherCode) {
    if (weatherCode == null) return 'assets/weather_icons/default.png';

    switch (weatherCode) {
      // Ciel clair
      case 0:
        return 'assets/weather_icons/clear_day.png';

      // Partiellement nuageux
      case 1: // Principalement clair
      case 2: // Partiellement nuageux
      case 3: // Couvert
        return 'assets/weather_icons/partly_cloudy.png';

      // Brouillard
      case 45: // Brouillard
      case 48: // Brouillard givrant
        return 'assets/weather_icons/fog.png';

      // Bruine
      case 51: // Bruine légère
      case 53: // Bruine modérée
      case 55: // Bruine dense
        return 'assets/weather_icons/drizzle.png';

      // Pluie
      case 61: // Pluie légère
      case 63: // Pluie modérée
      case 65: // Pluie forte
        return 'assets/weather_icons/rain.png';

      // Pluie verglaçante
      case 66: // Pluie verglaçante légère
      case 67: // Pluie verglaçante forte
        return 'assets/weather_icons/freezing_rain.png';

      // Averses
      case 80: // Averses légères
      case 81: // Averses modérées
      case 82: // Averses violentes
        return 'assets/weather_icons/showers.png';

      // Neige
      case 71: // Chute de neige légère
      case 73: // Chute de neige modérée
      case 75: // Chute de neige forte
      case 77: // Grains de neige
        return 'assets/weather_icons/snow.png';

      // Averses de neige
      case 85: // Averses de neige légères
      case 86: // Averses de neige fortes
        return 'assets/weather_icons/snow_showers.png';

      // Orage
      case 95: // Orage
      case 96: // Orage avec grêle légère
      case 99: // Orage avec grêle forte
        return 'assets/weather_icons/thunderstorm.png';

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
        return 'assets/weather_icons/wind.png';

      // Par défaut
      default:
        return 'assets/weather_icons/default.png';
    }
  }

  /// Retourne une description textuelle du temps pour l'accessibilité
  static String getWeatherDescription(int? weatherCode) {
    if (weatherCode == null) return 'Conditions inconnues';

    switch (weatherCode) {
      case 0:
        return 'Ciel clair';
      case 1:
        return 'Principalement clair';
      case 2:
        return 'Partiellement nuageux';
      case 3:
        return 'Couvert';
      case 45:
        return 'Brouillard';
      case 48:
        return 'Brouillard givrant';
      case 51:
        return 'Bruine légère';
      case 53:
        return 'Bruine modérée';
      case 55:
        return 'Bruine dense';
      case 61:
        return 'Pluie légère';
      case 63:
        return 'Pluie modérée';
      case 65:
        return 'Pluie forte';
      case 66:
        return 'Pluie verglaçante légère';
      case 67:
        return 'Pluie verglaçante forte';
      case 71:
        return 'Chute de neige légère';
      case 73:
        return 'Chute de neige modérée';
      case 75:
        return 'Chute de neige forte';
      case 77:
        return 'Grains de neige';
      case 80:
        return 'Averses légères';
      case 81:
        return 'Averses modérées';
      case 82:
        return 'Averses violentes';
      case 85:
        return 'Averses de neige légères';
      case 86:
        return 'Averses de neige fortes';
      case 95:
        return 'Orage';
      case 96:
        return 'Orage avec grêle légère';
      case 99:
        return 'Orage avec grêle forte';
      default:
        return 'Conditions variables';
    }
  }

  /// Retourne une icône de fallback en cas d'erreur de chargement
  static String getFallbackIcon() {
    return 'assets/weather_icons/default.png';
  }

  /// Vérifie si un code météo est valide
  static bool isValidWeatherCode(int? weatherCode) {
    if (weatherCode == null) return false;
    return weatherCode >= 0 && weatherCode <= 99;
  }
}


