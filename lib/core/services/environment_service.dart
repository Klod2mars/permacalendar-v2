import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentService {
  static bool _initialized = false;

  // Fonctionnalités sociales - Variable principale pour contrôler l'activation
  static bool isSocialEnabled = false;

  static bool get isUserProfilesEnabled =>
      dotenv.env['ENABLE_USER_PROFILES']?.toLowerCase() == 'true';

  static bool get isCommunityEnabled =>
      dotenv.env['ENABLE_COMMUNITY_FEATURES']?.toLowerCase() == 'true';

  static bool get isLikesSystemEnabled =>
      dotenv.env['ENABLE_LIKES_SYSTEM']?.toLowerCase() == 'true';

  // Backend
  static bool get isBackendEnabled =>
      dotenv.env['BACKEND_ENABLED']?.toLowerCase() == 'true';

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://localhost:3000/api/v1';

  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Fonctionnalités scientifiques
  static bool get isWeatherEnabled =>
      dotenv.env['ENABLE_WEATHER_INTEGRATION']?.toLowerCase() == 'true';

  static bool get isAnalyticsEnabled =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  static bool get isExportEnabled =>
      dotenv.env['ENABLE_EXPORT_FEATURES']?.toLowerCase() == 'true';

  // Coordonnées par défaut pour la météo (commune par défaut)
  static double get defaultLatitude =>
      double.tryParse(dotenv.env['DEFAULT_LATITUDE'] ?? '48.8566') ??
      48.8566; // Paris
  static double get defaultLongitude =>
      double.tryParse(dotenv.env['DEFAULT_LONGITUDE'] ?? '2.3522') ??
      2.3522; // Paris
  static String get defaultCommuneName =>
      dotenv.env['DEFAULT_COMMUNE_NAME'] ?? 'Paris';

  // Validation des jardins
  static int get maxGardensPerUser =>
      int.tryParse(dotenv.env['MAX_GARDENS_PER_USER'] ?? '5') ?? 5;

  static int get minGardensPerUser =>
      int.tryParse(dotenv.env['MIN_GARDENS_PER_USER'] ?? '1') ?? 1;

  static bool get isGardenValidationEnabled =>
      dotenv.env['ENABLE_GARDEN_VALIDATION']?.toLowerCase() == 'true';

  // Debug
  static bool get isDebugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  static bool get isLoggingEnabled =>
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  static Future<void> initialize() async {
    if (_initialized) return;

    // Validation des variables d'environnement
    _validateEnvironmentVariables();

    _initialized = true;
  }

  static void _validateEnvironmentVariables() {
    // Vérifier les contraintes des jardins
    if (maxGardensPerUser < minGardensPerUser) {
      throw Exception(
          'MAX_GARDENS_PER_USER doit être supérieur ou égal à MIN_GARDENS_PER_USER');
    }

    if (minGardensPerUser < 1) {
      throw Exception('MIN_GARDENS_PER_USER doit être au moins 1');
    }

    if (maxGardensPerUser > 10) {
      throw Exception('MAX_GARDENS_PER_USER ne peut pas dépasser 10');
    }

    // Vérifier l'URL de l'API si le backend est activé
    if (isBackendEnabled && !apiBaseUrl.startsWith('http')) {
      throw Exception('API_BASE_URL doit être une URL valide');
    }
  }

  // Méthodes utilitaires pour les logs
  static void log(String message) {
    if (isLoggingEnabled && isDebugMode) {
      print('[PermaCalendar] $message');
    }
  }

  static void logError(String message, [Object? error]) {
    if (isLoggingEnabled) {
      print('[PermaCalendar ERROR] $message');
      if (error != null) {
        print('[PermaCalendar ERROR] $error');
      }
    }
  }
}

