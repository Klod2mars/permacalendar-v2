/// Constantes de l'application PermaCalendar 2.0
class AppConstants {
  // Informations de l'application
  static const String appName = 'PermaCalendar 2.0';
  static const String appVersion = '2.0.0';
  static const String buildNumber = '1.0.0+1';
  static const String appDescription =
      'Application de gestion de jardinage en permaculture';

  // Limites de l'application
  static const int minGardensPerUser = 1;
  static const int maxGardensPerUser = 5;
  static const int maxGardensDefault = 5;
  static const int maxGardenBedsPerGarden = 20;
  static const int maxPlantingsPerBed = 50;
  static const int maxPlantVarieties = 10;
  static const int maxCompanionPlants = 20;
  static const int maxCareActionsPerPlanting = 100;

  // Limites de validation pour jardins
  static const double minGardenArea = 0.1;
  static const double maxGardenArea = 10000.0;

  // Messages d'erreur pour jardins
  static const String gardenLimitReachedMessage =
      'Vous ne pouvez pas créer plus de $maxGardensPerUser jardins';
  static const String minimumGardenRequiredMessage =
      'Vous devez avoir au moins $minGardensPerUser jardin';

  // Limites de texte
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxNotesLength = 1000;
  static const int maxUrlLength = 2048;

  // Valeurs par défaut
  static const double defaultGardenArea = 10.0;
  static const double defaultBedWidth = 1.2;
  static const double defaultBedLength = 3.0;
  static const int defaultDaysToMaturity = 90;
  static const double defaultPlantSpacing = 30.0;

  // Formats de date
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Clés de stockage local
  static const String userPreferencesKey = 'user_preferences';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String firstLaunchKey = 'first_launch';
  static const String lastSyncKey = 'last_sync';

  // URLs et endpoints (préparés pour le backend)
  static const String defaultBackendUrl = 'https://api.permacalendar.com';
  static const String healthEndpoint = '/health';
  static const String authEndpoint = '/auth';
  static const String gardensEndpoint = '/gardens';
  static const String plantsEndpoint = '/plants';
  static const String weatherEndpoint = '/weather';

  // Clés API (à configurer dans .env)
  static const String weatherApiKeyEnv = 'WEATHER_API_KEY';
  static const String backendApiKeyEnv = 'BACKEND_API_KEY';

  // Durées et timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);
  static const Duration syncInterval = Duration(minutes: 15);
  static const Duration notificationDelay = Duration(seconds: 2);

  // Tailles d'images
  static const double thumbnailSize = 100.0;
  static const double mediumImageSize = 300.0;
  static const double largeImageSize = 800.0;

  // Couleurs par défaut (hex)
  static const String primaryColorHex = '#4CAF50';
  static const String secondaryColorHex = '#8BC34A';
  static const String errorColorHex = '#F44336';
  static const String warningColorHex = '#FF9800';
  static const String successColorHex = '#4CAF50';

  // Icônes par défaut
  static const String defaultGardenIcon = '🌱';
  static const String defaultPlantIcon = '🌿';
  static const String defaultBedIcon = '🟫';
  static const String defaultHarvestIcon = '🥕';

  // Regex patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+?[\d\s\-\(\)]{10,}$';
  static const String urlPattern =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  static const String scientificNamePattern = r'^[A-Z][a-z]+ [a-z]+( [a-z]+)*$';

  // Messages d'erreur par défaut
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String serverErrorMessage = 'Erreur serveur, veuillez réessayer';
  static const String validationErrorMessage = 'Données invalides';
  static const String notFoundErrorMessage = 'Élément non trouvé';
  static const String unauthorizedErrorMessage = 'Accès non autorisé';

  // Messages de succès
  static const String saveSuccessMessage = 'Sauvegardé avec succès';
  static const String deleteSuccessMessage = 'Supprimé avec succès';
  static const String updateSuccessMessage = 'Mis à jour avec succès';
  static const String syncSuccessMessage = 'Synchronisation réussie';
}

/// Types de sol disponibles
enum SoilType {
  clay('Argileux'),
  sandy('Sableux'),
  loamy('Limoneux'),
  chalky('Calcaire'),
  peaty('Tourbeux'),
  silty('Silteux');

  const SoilType(this.displayName);
  final String displayName;
}

/// Types d'exposition au soleil
enum ExposureType {
  fullSun('Plein soleil'),
  partialSun('Soleil partiel'),
  partialShade('Ombre partielle'),
  fullShade('Ombre complète');

  const ExposureType(this.displayName);
  final String displayName;
}

/// Saisons de plantation
enum PlantingSeason {
  spring('Printemps'),
  summer('Été'),
  autumn('Automne'),
  winter('Hiver');

  const PlantingSeason(this.displayName);
  final String displayName;
}

/// Catégories de plantes
enum PlantCategory {
  vegetables('Légumes'),
  fruits('Fruits'),
  herbs('Herbes aromatiques'),
  flowers('Fleurs'),
  trees('Arbres'),
  shrubs('Arbustes'),
  grains('Céréales'),
  legumes('Légumineuses');

  const PlantCategory(this.displayName);
  final String displayName;
}

/// Niveaux de difficulté
enum DifficultyLevel {
  beginner('Débutant'),
  intermediate('Intermédiaire'),
  advanced('Avancé'),
  expert('Expert');

  const DifficultyLevel(this.displayName);
  final String displayName;
}

/// Statuts de plantation
enum PlantingStatus {
  planned('Planifié'),
  planted('Planté'),
  germinated('Germé'),
  growing('En croissance'),
  flowering('En fleur'),
  fruiting('En fructification'),
  ready('Prêt à récolter'),
  harvested('Récolté'),
  failed('Échec');

  const PlantingStatus(this.displayName);
  final String displayName;

  /// Retourne la couleur associée au statut
  String get colorHex {
    switch (this) {
      case PlantingStatus.planned:
        return '#9E9E9E';
      case PlantingStatus.planted:
        return '#8BC34A';
      case PlantingStatus.germinated:
        return '#4CAF50';
      case PlantingStatus.growing:
        return '#2E7D32';
      case PlantingStatus.flowering:
        return '#E91E63';
      case PlantingStatus.fruiting:
        return '#FF9800';
      case PlantingStatus.ready:
        return '#FFC107';
      case PlantingStatus.harvested:
        return '#4CAF50';
      case PlantingStatus.failed:
        return '#F44336';
    }
  }
}

/// Types d'actions de soin
enum CareActionType {
  watering('Arrosage'),
  fertilizing('Fertilisation'),
  pruning('Taille'),
  weeding('Désherbage'),
  mulching('Paillage'),
  pestControl('Traitement'),
  harvesting('Récolte'),
  observation('Observation'),
  other('Autre');

  const CareActionType(this.displayName);
  final String displayName;

  /// Retourne l'icône associée à l'action
  String get icon {
    switch (this) {
      case CareActionType.watering:
        return '💧';
      case CareActionType.fertilizing:
        return '🌱';
      case CareActionType.pruning:
        return '✂️';
      case CareActionType.weeding:
        return '🌿';
      case CareActionType.mulching:
        return '🍂';
      case CareActionType.pestControl:
        return '🐛';
      case CareActionType.harvesting:
        return '🥕';
      case CareActionType.observation:
        return '👁️';
      case CareActionType.other:
        return '📝';
    }
  }
}

/// Types de notifications
enum NotificationType {
  watering('Arrosage nécessaire'),
  harvesting('Prêt à récolter'),
  planting('Temps de planter'),
  care('Soin requis'),
  weather('Alerte météo'),
  reminder('Rappel'),
  sync('Synchronisation'),
  error('Erreur');

  const NotificationType(this.displayName);
  final String displayName;
}

/// Unités de mesure
enum MeasurementUnit {
  // Distance
  centimeters('cm'),
  meters('m'),
  inches('in'),
  feet('ft'),

  // Surface
  squareMeters('m²'),
  squareFeet('ft²'),
  hectares('ha'),
  acres('ac'),

  // Volume
  liters('L'),
  milliliters('mL'),
  gallons('gal'),

  // Poids
  grams('g'),
  kilograms('kg'),
  pounds('lb'),
  ounces('oz'),

  // Température
  celsius('°C'),
  fahrenheit('°F');

  const MeasurementUnit(this.symbol);
  final String symbol;
}

/// Types de données météorologiques
enum WeatherDataType {
  temperature('Température'),
  humidity('Humidité'),
  precipitation('Précipitations'),
  windSpeed('Vitesse du vent'),
  pressure('Pression'),
  uvIndex('Indice UV'),
  cloudCover('Couverture nuageuse');

  const WeatherDataType(this.displayName);
  final String displayName;
}

/// Périodes d'export de données
enum ExportPeriod {
  week('Cette semaine'),
  month('Ce mois'),
  quarter('Ce trimestre'),
  year('Cette année'),
  all('Toutes les données');

  const ExportPeriod(this.displayName);
  final String displayName;
}

/// Formats d'export
enum ExportFormat {
  csv('CSV'),
  json('JSON'),
  pdf('PDF'),
  excel('Excel');

  const ExportFormat(this.displayName);
  final String displayName;

  String get fileExtension {
    switch (this) {
      case ExportFormat.csv:
        return '.csv';
      case ExportFormat.json:
        return '.json';
      case ExportFormat.pdf:
        return '.pdf';
      case ExportFormat.excel:
        return '.xlsx';
    }
  }
}


