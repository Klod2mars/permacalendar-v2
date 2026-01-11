import 'package:hive/hive.dart';
import '../../core/hive/type_ids.dart';

part 'plant_localized.g.dart';

@HiveType(typeId: kTypeIdPlantLocalized) // 33
class PlantLocalized extends HiveObject {
  @HiveField(0)
  final String id; // scientificName slug

  @HiveField(1)
  final String scientificName;

  @HiveField(2)
  final String taxonomy;

  @HiveField(3)
  final Map<String, dynamic> attributes; // Non-localized attributes

  @HiveField(4)
  final Map<String, LocalizedPlantFields> localized;

  @HiveField(5)
  final DateTime lastUpdated;

  @HiveField(6)
  final int schemaVersion;

  PlantLocalized({
    required this.id,
    required this.scientificName,
    this.taxonomy = '',
    this.attributes = const {},
    required this.localized,
    required this.lastUpdated,
    this.schemaVersion = 1,
  });
}

@HiveType(typeId: kTypeIdPlantLocalized + 100) // Using an offset or nested? 
// Wait, nested objects need their own TypeId if stored as objects, or they can be JSON maps. 
// But "HiveField" implies strictly typed.
// TypeId 33 is for PlantLocalized. 
// Do I need a TypeId for LocalizedPlantFields? 
// The prompt didn't specify, but usually yes if it's a Hive class.
// But 33+100 might conflict with future stuff? 
// Safe bet: just store it as Map<String, dynamic> if simple, OR register another adapter.
// The prompted plan said: "classe LocalizedPlantFields... annoter @HiveType".
// I need a TypeId for `LocalizedPlantFields`. 
// I'll check audit again. 
// 34 is also available. I'll use 34 for LocalizedPlantFields.

@HiveType(typeId: 34)
class LocalizedPlantFields {
  @HiveField(0)
  final String commonName;

  @HiveField(1)
  final String shortDescription;

  @HiveField(2)
  final List<String> symptoms;

  @HiveField(3)
  final String quickAdvice;

  @HiveField(4)
  final String source; // wikidata, mt, glossary, human

  @HiveField(5)
  final double confidence;

  @HiveField(6)
  final bool needsReview;

  @HiveField(7)
  final String? lastReviewedBy;

  @HiveField(8)
  final DateTime? lastReviewedAt;

  LocalizedPlantFields({
    this.commonName = '',
    this.shortDescription = '',
    this.symptoms = const [],
    this.quickAdvice = '',
    this.source = 'mt',
    this.confidence = 0.0,
    this.needsReview = true,
    this.lastReviewedBy,
    this.lastReviewedAt,
  });
}
