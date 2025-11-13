import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'pest.dart';

part 'pest_observation.freezed.dart';
part 'pest_observation.g.dart';

/// PestObservation Entity - Represents a user observation of a pest in their garden
///
/// PHILOSOPHY:
/// This entity embodies the Sanctuary principle - it is created ONLY by the user,
/// NEVER by the AI. The user observes real pests in their garden and records them.
/// The Intelligence Végétale reads these observations but NEVER creates them.
/// This maintains the sacred flow: Reality (User) → Sanctuary (Observation) → Intelligence (Analysis)
@freezed
class PestObservation with _$PestObservation {
  const factory PestObservation({
    required String id,
    required String pestId,
    required String plantId,
    required String gardenId,
    required DateTime observedAt,
    required PestSeverity severity,
    String? bedId, // Optional: specific bed where observed
    String? notes,
    List<String>? photoUrls,
    bool? isActive, // Whether the observation is still active
    DateTime? resolvedAt, // When the pest issue was resolved
    String? resolutionMethod, // How it was resolved
  }) = _PestObservation;

  factory PestObservation.fromJson(Map<String, dynamic> json) =>
      _$PestObservationFromJson(json);
}

/// Hive adapter for PestObservation
@HiveType(typeId: 52)
class PestObservationHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String pestId;

  @HiveField(2)
  late String plantId;

  @HiveField(3)
  late String gardenId;

  @HiveField(4)
  late DateTime observedAt;

  @HiveField(5)
  late String severity; // Stored as string

  @HiveField(6)
  String? bedId;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  List<String>? photoUrls;

  @HiveField(9)
  bool? isActive;

  @HiveField(10)
  DateTime? resolvedAt;

  @HiveField(11)
  String? resolutionMethod;

  PestObservationHive();

  factory PestObservationHive.fromDomain(PestObservation observation) {
    return PestObservationHive()
      ..id = observation.id
      ..pestId = observation.pestId
      ..plantId = observation.plantId
      ..gardenId = observation.gardenId
      ..observedAt = observation.observedAt
      ..severity = observation.severity.name
      ..bedId = observation.bedId
      ..notes = observation.notes
      ..photoUrls = observation.photoUrls
      ..isActive = observation.isActive
      ..resolvedAt = observation.resolvedAt
      ..resolutionMethod = observation.resolutionMethod;
  }

  PestObservation toDomain() {
    return PestObservation(
      id: id,
      pestId: pestId,
      plantId: plantId,
      gardenId: gardenId,
      observedAt: observedAt,
      severity: PestSeverity.values.firstWhere(
        (e) => e.name == severity,
        orElse: () => PestSeverity.moderate,
      ),
      bedId: bedId,
      notes: notes,
      photoUrls: photoUrls,
      isActive: isActive,
      resolvedAt: resolvedAt,
      resolutionMethod: resolutionMethod,
    );
  }
}


