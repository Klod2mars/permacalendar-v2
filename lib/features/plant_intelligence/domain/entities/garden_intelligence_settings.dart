import 'package:freezed_annotation/freezed_annotation.dart';

part 'garden_intelligence_settings.freezed.dart';
part 'garden_intelligence_settings.g.dart';

/// Paramètres de l'intelligence d'un jardin
/// Configuration des analyses et des alertes
@freezed
class GardenIntelligenceSettings with _$GardenIntelligenceSettings {
  const factory GardenIntelligenceSettings({
    required String gardenId,
    @Default(true) bool autoAnalysis,
    @Default(true) bool notificationsEnabled,
    @Default(24) int analysisIntervalHours,
    @Default(0.8) double confidenceThreshold,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GardenIntelligenceSettings;

  factory GardenIntelligenceSettings.fromJson(Map<String, dynamic> json) =>
      _$GardenIntelligenceSettingsFromJson(json);
}

