import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'beneficial_insect.freezed.dart';
part 'beneficial_insect.g.dart';

/// Habitat Requirements for Beneficial Insects
@freezed
class HabitatRequirements with _$HabitatRequirements {
  const factory HabitatRequirements({
    required bool needsWater,
    required bool needsShelter,
    required List<String> favorableConditions,
  }) = _HabitatRequirements;

  factory HabitatRequirements.fromJson(Map<String, dynamic> json) =>
      _$HabitatRequirementsFromJson(json);
}

/// BeneficialInsect Entity - Represents a beneficial insect/auxiliaire
///
/// PHILOSOPHY:
/// This entity represents beneficial insects that help control pests naturally.
/// It contains information about their prey, habitat needs, and attractive plants,
/// enabling recommendations for creating favorable conditions for these allies.
@freezed
class BeneficialInsect with _$BeneficialInsect {
  const factory BeneficialInsect({
    required String id,
    required String name,
    required String scientificName,
    required List<String> preyPests, // Pest IDs that this insect preys on
    required List<String>
        attractiveFlowers, // Plant IDs that attract this insect
    required HabitatRequirements habitat,
    required String lifeCycle,
    String? description,
    String? imageUrl,
    int? effectiveness, // 0-100 effectiveness score
  }) = _BeneficialInsect;

  factory BeneficialInsect.fromJson(Map<String, dynamic> json) =>
      _$BeneficialInsectFromJson(json);
}

/// Hive adapter for BeneficialInsect
@HiveType(typeId: 51)
class BeneficialInsectHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String scientificName;

  @HiveField(3)
  late List<String> preyPests;

  @HiveField(4)
  late List<String> attractiveFlowers;

  @HiveField(5)
  late bool habitatNeedsWater;

  @HiveField(6)
  late bool habitatNeedsShelter;

  @HiveField(7)
  late List<String> habitatFavorableConditions;

  @HiveField(8)
  late String lifeCycle;

  @HiveField(9)
  String? description;

  @HiveField(10)
  String? imageUrl;

  @HiveField(11)
  int? effectiveness;

  BeneficialInsectHive();

  factory BeneficialInsectHive.fromDomain(BeneficialInsect insect) {
    return BeneficialInsectHive()
      ..id = insect.id
      ..name = insect.name
      ..scientificName = insect.scientificName
      ..preyPests = insect.preyPests
      ..attractiveFlowers = insect.attractiveFlowers
      ..habitatNeedsWater = insect.habitat.needsWater
      ..habitatNeedsShelter = insect.habitat.needsShelter
      ..habitatFavorableConditions = insect.habitat.favorableConditions
      ..lifeCycle = insect.lifeCycle
      ..description = insect.description
      ..imageUrl = insect.imageUrl
      ..effectiveness = insect.effectiveness;
  }

  BeneficialInsect toDomain() {
    return BeneficialInsect(
      id: id,
      name: name,
      scientificName: scientificName,
      preyPests: preyPests,
      attractiveFlowers: attractiveFlowers,
      habitat: HabitatRequirements(
        needsWater: habitatNeedsWater,
        needsShelter: habitatNeedsShelter,
        favorableConditions: habitatFavorableConditions,
      ),
      lifeCycle: lifeCycle,
      description: description,
      imageUrl: imageUrl,
      effectiveness: effectiveness,
    );
  }
}


