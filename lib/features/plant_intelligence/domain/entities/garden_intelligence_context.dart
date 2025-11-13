ï»¿import 'package:freezed_annotation/freezed_annotation.dart';

part 'garden_intelligence_context.freezed.dart';
part 'garden_intelligence_context.g.dart';

/// Contexte de l'intelligence d'un jardin
/// Contient les informations environnementales et les conditions actuelles
@freezed
class GardenIntelligenceContext with _$GardenIntelligenceContext {
  const factory GardenIntelligenceContext({
    required String gardenId,
    required String location,
    required String climate,
    @Default(0.0) double temperature,
    @Default(0.0) double humidity,
    @Default(0.0) double soilPh,
    @Default(0.0) double soilTemperature,
    required DateTime lastUpdatedAt,
  }) = _GardenIntelligenceContext;

  factory GardenIntelligenceContext.fromJson(Map<String, dynamic> json) =>
      _$GardenIntelligenceContextFromJson(json);
}


