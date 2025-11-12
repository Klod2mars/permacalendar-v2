import 'package:freezed_annotation/freezed_annotation.dart';

part 'garden_intelligence_memory.freezed.dart';
part 'garden_intelligence_memory.g.dart';

/// Mémoire de l'intelligence d'un jardin
/// Stocke les statistiques et l'historique des analyses
@freezed
class GardenIntelligenceMemory with _$GardenIntelligenceMemory {
  const factory GardenIntelligenceMemory({
    required String gardenId,
    @Default(0) int totalReportsGenerated,
    @Default(0) int totalAnalysesPerformed,
    required DateTime lastReportGeneratedAt,
    required DateTime memoryCreatedAt,
    required DateTime memoryUpdatedAt,
  }) = _GardenIntelligenceMemory;

  factory GardenIntelligenceMemory.fromJson(Map<String, dynamic> json) =>
      _$GardenIntelligenceMemoryFromJson(json);
}

