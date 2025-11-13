ï»¿import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'activity.g.dart';

/// Types d'activités disponibles dans l'application
@HiveType(typeId: 17)
enum ActivityType {
  @HiveField(0)
  gardenCreated,
  @HiveField(1)
  gardenUpdated,
  @HiveField(2)
  gardenDeleted,
  @HiveField(3)
  bedCreated,
  @HiveField(4)
  bedUpdated,
  @HiveField(5)
  bedDeleted,
  @HiveField(6)
  plantingCreated,
  @HiveField(7)
  plantingUpdated,
  @HiveField(8)
  plantingHarvested,
  @HiveField(9)
  careActionAdded,
  @HiveField(10)
  germinationConfirmed,
  @HiveField(11)
  plantCreated,
  @HiveField(12)
  plantUpdated,
  @HiveField(13)
  plantDeleted,
  @HiveField(14)
  plantingDeleted,
  @HiveField(15)
  weatherDataFetched,
  @HiveField(16)
  weatherAlertTriggered,
}

/// Types d'entités pouvant être associées à une activité
@HiveType(typeId: 18)
enum EntityType {
  @HiveField(0)
  garden,
  @HiveField(1)
  gardenBed,
  @HiveField(2)
  planting,
  @HiveField(3)
  plant,
  @HiveField(4)
  germinationEvent,
}

/// Modèle pour tracker les activités utilisateur dans l'application
@HiveType(typeId: 16)
class Activity extends HiveObject {
  /// Identifiant unique de l'activité
  @HiveField(0)
  final String id;

  /// Type d'activité
  @HiveField(1)
  final ActivityType type;

  /// Titre de l'activité
  @HiveField(2)
  final String title;

  /// Description détaillée de l'activité
  @HiveField(3)
  final String description;

  /// ID de l'entité concernée par l'activité
  @HiveField(4)
  final String? entityId;

  /// Type de l'entité concernée
  @HiveField(5)
  final EntityType? entityType;

  /// Date et heure de l'activité
  @HiveField(6)
  final DateTime timestamp;

  /// Métadonnées additionnelles
  @HiveField(7)
  final Map<String, dynamic> metadata;

  /// Date de Création
  @HiveField(8)
  final DateTime createdAt;

  /// Date de dernière mise à jour
  @HiveField(9)
  final DateTime updatedAt;

  /// Indique si l'activité est active
  @HiveField(10)
  final bool isActive;

  Activity({
    String? id,
    required this.type,
    required this.title,
    required this.description,
    this.entityId,
    this.entityType,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now(),
        metadata = metadata ?? {},
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor pour la Création d'un jardin
  factory Activity.gardenCreated({
    required String gardenId,
    required String gardenName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.gardenCreated,
      title: 'Jardin Créé',
      description: 'Le jardin "$gardenName" a été Créé avec succès',
      entityId: gardenId,
      entityType: EntityType.garden,
      metadata: {
        'gardenName': gardenName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la mise à jour d'un jardin
  factory Activity.gardenUpdated({
    required String gardenId,
    required String gardenName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.gardenUpdated,
      title: 'Jardin modifié',
      description: 'Le jardin "$gardenName" a été mis à jour',
      entityId: gardenId,
      entityType: EntityType.garden,
      metadata: {
        'gardenName': gardenName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la suppression d'un jardin
  factory Activity.gardenDeleted({
    required String gardenId,
    required String gardenName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.gardenDeleted,
      title: 'Jardin supprimé',
      description: 'Le jardin "$gardenName" a été supprimé',
      entityId: gardenId,
      entityType: EntityType.garden,
      metadata: {
        'gardenName': gardenName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la Création d'une parcelle
  factory Activity.bedCreated({
    required String bedId,
    required String bedName,
    required String gardenName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.bedCreated,
      title: 'Parcelle Créée',
      description:
          'La parcelle "$bedName" a été Créée dans le jardin "$gardenName"',
      entityId: bedId,
      entityType: EntityType.gardenBed,
      metadata: {
        'bedName': bedName,
        'gardenName': gardenName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la mise à jour d'une parcelle
  factory Activity.bedUpdated({
    required String bedId,
    required String bedName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.bedUpdated,
      title: 'Parcelle modifiée',
      description: 'La parcelle "$bedName" a été mise à jour',
      entityId: bedId,
      entityType: EntityType.gardenBed,
      metadata: {
        'bedName': bedName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la suppression d'une parcelle
  factory Activity.bedDeleted({
    required String bedId,
    required String bedName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.bedDeleted,
      title: 'Parcelle supprimée',
      description: 'La parcelle "$bedName" a été supprimée',
      entityId: bedId,
      entityType: EntityType.gardenBed,
      metadata: {
        'bedName': bedName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la Création d'une plantation
  factory Activity.plantingCreated({
    required String plantingId,
    required String plantName,
    required String bedName,
    required int quantity,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantingCreated,
      title: 'Plantation Créée',
      description: '$quantity $plantName planté(s) dans la parcelle "$bedName"',
      entityId: plantingId,
      entityType: EntityType.planting,
      metadata: {
        'plantName': plantName,
        'bedName': bedName,
        'quantity': quantity,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la mise à jour d'une plantation
  factory Activity.plantingUpdated({
    required String plantingId,
    required String plantName,
    required String status,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantingUpdated,
      title: 'Plantation mise à jour',
      description:
          'La plantation de $plantName a été mise à jour (statut: $status)',
      entityId: plantingId,
      entityType: EntityType.planting,
      metadata: {
        'plantName': plantName,
        'status': status,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la récolte d'une plantation
  factory Activity.plantingHarvested({
    required String plantingId,
    required String plantName,
    required int quantity,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantingHarvested,
      title: 'Récolte effectuée',
      description: '$quantity $plantName récoltés avec succès',
      entityId: plantingId,
      entityType: EntityType.planting,
      metadata: {
        'plantName': plantName,
        'quantity': quantity,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour l'ajout d'une action de soin
  factory Activity.careActionAdded({
    required String plantingId,
    required String plantName,
    required String careAction,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.careActionAdded,
      title: 'Action de soin ajoutée',
      description: 'Action "$careAction" effectuée sur $plantName',
      entityId: plantingId,
      entityType: EntityType.planting,
      metadata: {
        'plantName': plantName,
        'careAction': careAction,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la confirmation de germination
  factory Activity.germinationConfirmed({
    required String plantingId,
    required String plantName,
    required DateTime germinationDate,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.germinationConfirmed,
      title: 'Germination confirmée',
      description:
          'Germination de $plantName confirmée le ${germinationDate.day}/${germinationDate.month}/${germinationDate.year}',
      entityId: plantingId,
      entityType: EntityType.planting,
      metadata: {
        'plantName': plantName,
        'germinationDate': germinationDate.toIso8601String(),
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la Création d'une plante
  factory Activity.plantCreated({
    required String plantId,
    required String plantName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantCreated,
      title: 'Plante ajoutée',
      description: 'La plante "$plantName" a été ajoutée au catalogue',
      entityId: plantId,
      entityType: EntityType.plant,
      metadata: {
        'plantName': plantName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la mise à jour d'une plante
  factory Activity.plantUpdated({
    required String plantId,
    required String plantName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantUpdated,
      title: 'Plante modifiée',
      description: 'La plante "$plantName" a été mise à jour',
      entityId: plantId,
      entityType: EntityType.plant,
      metadata: {
        'plantName': plantName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la suppression d'une plante
  factory Activity.plantDeleted({
    required String plantId,
    required String plantName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantDeleted,
      title: 'Plante supprimée',
      description: 'La plante "$plantName" a été supprimée du catalogue',
      entityId: plantId,
      entityType: EntityType.plant,
      metadata: {
        'plantName': plantName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la suppression d'une plantation
  factory Activity.plantingDeleted({
    required String plantingId,
    required String plantName,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.plantingDeleted,
      title: 'Plantation supprimée',
      description: 'La plantation de "$plantName" a été supprimée',
      entityId: plantingId,
      entityType: EntityType.planting,
      metadata: {
        'plantName': plantName,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour la récupération de données météo
  factory Activity.weatherDataFetched({
    required String location,
    required Map<String, dynamic> weatherData,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.weatherDataFetched,
      title: 'Données météo récupérées',
      description: 'Données météorologiques récupérées pour $location',
      metadata: {
        'location': location,
        'weatherData': weatherData,
        ...?metadata,
      },
    );
  }

  /// Factory constructor pour les alertes météo
  factory Activity.weatherAlertTriggered({
    required String location,
    required String alertType,
    required String alertMessage,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      type: ActivityType.weatherAlertTriggered,
      title: 'Alerte météo',
      description: 'Alerte météo pour $location: $alertMessage',
      metadata: {
        'location': location,
        'alertType': alertType,
        'alertMessage': alertMessage,
        ...?metadata,
      },
    );
  }

  /// Crée une copie avec des modifications
  Activity copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    String? entityId,
    EntityType? entityType,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? Map<String, dynamic>.from(this.metadata),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convertit en Map pour la sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'entityId': entityId,
      'entityType': entityType?.name,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Crée une instance depuis une Map JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.gardenCreated,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      entityId: json['entityId'] as String?,
      entityType: json['entityType'] != null
          ? EntityType.values.firstWhere(
              (e) => e.name == json['entityType'],
              orElse: () => EntityType.garden,
            )
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  String toString() {
    return 'Activity(id: $id, type: ${type.name}, title: $title, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


