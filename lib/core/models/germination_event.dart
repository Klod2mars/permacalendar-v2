import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'germination_event.g.dart';

/// Événement de germination d'une plantation
@HiveType(typeId: 6)
class GerminationEvent extends HiveObject {
  /// Identifiant unique de l'événement
  @HiveField(0)
  final String id;

  /// Date de création de l'événement
  @HiveField(1)
  final DateTime date;

  /// ID de la plantation concernée
  @HiveField(2)
  final String plantingId;

  /// Date de confirmation de la germination
  @HiveField(3)
  final DateTime confirmedDate;

  /// Température du sol saisie par l'utilisateur (optionnel)
  @HiveField(4)
  final double? userSoilTemp;

  /// Notes de l'utilisateur
  @HiveField(5)
  final String? notes;

  /// Note supplémentaire
  @HiveField(6)
  final String? note;

  /// Contexte météorologique au moment de la confirmation
  @HiveField(7)
  final Map<String, dynamic>? weatherContext;

  /// Date de création
  @HiveField(8)
  final DateTime createdAt;

  /// Date de dernière mise à jour
  @HiveField(9)
  final DateTime updatedAt;

  /// Métadonnées additionnelles
  @HiveField(10)
  final Map<String, dynamic> metadata;

  /// Indique si l'événement est actif
  @HiveField(11)
  final bool isActive;

  GerminationEvent({
    String? id,
    DateTime? date,
    required this.plantingId,
    DateTime? confirmedDate,
    this.userSoilTemp,
    this.notes,
    this.note,
    this.weatherContext,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now(),
        confirmedDate = confirmedDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        metadata = metadata ?? {};

  /// Factory constructor pour créer un nouvel événement de germination
  factory GerminationEvent.create({
    required String plantingId,
    DateTime? confirmedDate,
    double? userSoilTemp,
    String? notes,
    String? note,
    Map<String, dynamic>? weatherContext,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return GerminationEvent(
      plantingId: plantingId,
      confirmedDate: confirmedDate ?? now,
      userSoilTemp: userSoilTemp,
      notes: notes,
      note: note,
      weatherContext: weatherContext,
      createdAt: now,
      updatedAt: now,
      metadata: metadata ?? {},
    );
  }

  /// Crée une copie avec des modifications
  GerminationEvent copyWith({
    String? id,
    DateTime? date,
    String? plantingId,
    DateTime? confirmedDate,
    double? userSoilTemp,
    String? notes,
    String? note,
    Map<String, dynamic>? weatherContext,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    bool? isActive,
  }) {
    return GerminationEvent(
      id: id ?? this.id,
      date: date ?? this.date,
      plantingId: plantingId ?? this.plantingId,
      confirmedDate: confirmedDate ?? this.confirmedDate,
      userSoilTemp: userSoilTemp ?? this.userSoilTemp,
      notes: notes ?? this.notes,
      note: note ?? this.note,
      weatherContext: weatherContext ?? this.weatherContext,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convertit en Map pour la sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'plantingId': plantingId,
      'confirmedDate': confirmedDate.toIso8601String(),
      'userSoilTemp': userSoilTemp,
      'notes': notes,
      'note': note,
      'weatherContext': weatherContext,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
      'isActive': isActive,
    };
  }

  /// Crée une instance depuis une Map JSON
  factory GerminationEvent.fromJson(Map<String, dynamic> json) {
    return GerminationEvent(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      plantingId: json['plantingId'] as String,
      confirmedDate: DateTime.parse(json['confirmedDate'] as String),
      userSoilTemp: json['userSoilTemp'] as double?,
      notes: json['notes'] as String?,
      note: json['note'] as String?,
      weatherContext: json['weatherContext'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  String toString() {
    return 'GerminationEvent(id: $id, plantingId: $plantingId, confirmedDate: $confirmedDate, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GerminationEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


