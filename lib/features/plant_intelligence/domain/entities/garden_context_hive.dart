ï»¿import 'package:hive/hive.dart';
import 'garden_context.dart';

part 'garden_context_hive.g.dart';

/// Adaptateur Hive pour la persistance de GardenContext
/// TypeId: 50 - Utilisé pour stocker le contexte des jardins
@HiveType(typeId: 50)
class GardenContextHive extends HiveObject {
  @HiveField(0)
  String gardenId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double latitude;

  @HiveField(4)
  double longitude;

  @HiveField(5)
  String? address;

  @HiveField(6)
  String? city;

  @HiveField(7)
  String? postalCode;

  @HiveField(8)
  String? country;

  @HiveField(9)
  String? usdaZone;

  @HiveField(10)
  double? altitude;

  @HiveField(11)
  String? exposure;

  @HiveField(12)
  double averageTemperature;

  @HiveField(13)
  double minTemperature;

  @HiveField(14)
  double maxTemperature;

  @HiveField(15)
  double averagePrecipitation;

  @HiveField(16)
  double averageHumidity;

  @HiveField(17)
  int frostDays;

  @HiveField(18)
  int growingSeasonLength;

  @HiveField(19)
  String? dominantWindDirection;

  @HiveField(20)
  double? averageWindSpeed;

  @HiveField(21)
  double? averageSunshineHours;

  @HiveField(22)
  int soilType; // Index de l'enum SoilType

  @HiveField(23)
  double ph;

  @HiveField(24)
  int soilTexture; // Index de l'enum SoilTexture

  @HiveField(25)
  double organicMatter;

  @HiveField(26)
  double waterRetention;

  @HiveField(27)
  int soilDrainage; // Index de l'enum SoilDrainage

  @HiveField(28)
  double depth;

  @HiveField(29)
  int nitrogen; // Index de l'enum NutrientLevel

  @HiveField(30)
  int phosphorus;

  @HiveField(31)
  int potassium;

  @HiveField(32)
  int calcium;

  @HiveField(33)
  int magnesium;

  @HiveField(34)
  int sulfur;

  @HiveField(35)
  int biologicalActivity; // Index de l'enum BiologicalActivity

  @HiveField(36)
  List<String>? contaminants;

  @HiveField(37)
  List<String> activePlantIds;

  @HiveField(38)
  List<String> historicalPlantIds;

  @HiveField(39)
  int totalPlants;

  @HiveField(40)
  int activePlants;

  @HiveField(41)
  double totalArea;

  @HiveField(42)
  double activeArea;

  @HiveField(43)
  double totalYield;

  @HiveField(44)
  double currentYearYield;

  @HiveField(45)
  int harvestsThisYear;

  @HiveField(46)
  int plantingsThisYear;

  @HiveField(47)
  double successRate;

  @HiveField(48)
  double totalInputCosts;

  @HiveField(49)
  double totalHarvestValue;

  @HiveField(50)
  int cultivationMethod; // Index de l'enum CultivationMethod

  @HiveField(51)
  bool usePesticides;

  @HiveField(52)
  bool useChemicalFertilizers;

  @HiveField(53)
  bool useOrganicFertilizers;

  @HiveField(54)
  bool cropRotation;

  @HiveField(55)
  bool companionPlanting;

  @HiveField(56)
  bool mulching;

  @HiveField(57)
  bool automaticIrrigation;

  @HiveField(58)
  bool regularMonitoring;

  @HiveField(59)
  List<String> objectives;

  @HiveField(60)
  DateTime? createdAt;

  @HiveField(61)
  DateTime? updatedAt;

  @HiveField(62)
  Map<String, dynamic> metadata;

  GardenContextHive({
    required this.gardenId,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.usdaZone,
    this.altitude,
    this.exposure,
    required this.averageTemperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.averagePrecipitation,
    required this.averageHumidity,
    required this.frostDays,
    required this.growingSeasonLength,
    this.dominantWindDirection,
    this.averageWindSpeed,
    this.averageSunshineHours,
    required this.soilType,
    required this.ph,
    required this.soilTexture,
    required this.organicMatter,
    required this.waterRetention,
    required this.soilDrainage,
    required this.depth,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.calcium,
    required this.magnesium,
    required this.sulfur,
    required this.biologicalActivity,
    this.contaminants,
    required this.activePlantIds,
    required this.historicalPlantIds,
    required this.totalPlants,
    required this.activePlants,
    required this.totalArea,
    required this.activeArea,
    required this.totalYield,
    required this.currentYearYield,
    required this.harvestsThisYear,
    required this.plantingsThisYear,
    required this.successRate,
    required this.totalInputCosts,
    required this.totalHarvestValue,
    required this.cultivationMethod,
    required this.usePesticides,
    required this.useChemicalFertilizers,
    required this.useOrganicFertilizers,
    required this.cropRotation,
    required this.companionPlanting,
    required this.mulching,
    required this.automaticIrrigation,
    required this.regularMonitoring,
    required this.objectives,
    this.createdAt,
    this.updatedAt,
    required this.metadata,
  });

  /// Convertit un GardenContext Freezed vers GardenContextHive
  factory GardenContextHive.fromGardenContext(GardenContext context) {
    return GardenContextHive(
      gardenId: context.gardenId,
      name: context.name,
      description: context.description,
      latitude: context.location.latitude,
      longitude: context.location.longitude,
      address: context.location.address,
      city: context.location.city,
      postalCode: context.location.postalCode,
      country: context.location.country,
      usdaZone: context.location.usdaZone,
      altitude: context.location.altitude,
      exposure: context.location.exposure,
      averageTemperature: context.climate.averageTemperature,
      minTemperature: context.climate.minTemperature,
      maxTemperature: context.climate.maxTemperature,
      averagePrecipitation: context.climate.averagePrecipitation,
      averageHumidity: context.climate.averageHumidity,
      frostDays: context.climate.frostDays,
      growingSeasonLength: context.climate.growingSeasonLength,
      dominantWindDirection: context.climate.dominantWindDirection,
      averageWindSpeed: context.climate.averageWindSpeed,
      averageSunshineHours: context.climate.averageSunshineHours,
      soilType: context.soil.type.index,
      ph: context.soil.ph,
      soilTexture: context.soil.texture.index,
      organicMatter: context.soil.organicMatter,
      waterRetention: context.soil.waterRetention,
      soilDrainage: context.soil.drainage.index,
      depth: context.soil.depth,
      nitrogen: context.soil.nutrients.nitrogen.index,
      phosphorus: context.soil.nutrients.phosphorus.index,
      potassium: context.soil.nutrients.potassium.index,
      calcium: context.soil.nutrients.calcium.index,
      magnesium: context.soil.nutrients.magnesium.index,
      sulfur: context.soil.nutrients.sulfur.index,
      biologicalActivity: context.soil.biologicalActivity.index,
      contaminants: context.soil.contaminants,
      activePlantIds: context.activePlantIds,
      historicalPlantIds: context.historicalPlantIds,
      totalPlants: context.stats.totalPlants,
      activePlants: context.stats.activePlants,
      totalArea: context.stats.totalArea,
      activeArea: context.stats.activeArea,
      totalYield: context.stats.totalYield,
      currentYearYield: context.stats.currentYearYield,
      harvestsThisYear: context.stats.harvestsThisYear,
      plantingsThisYear: context.stats.plantingsThisYear,
      successRate: context.stats.successRate,
      totalInputCosts: context.stats.totalInputCosts,
      totalHarvestValue: context.stats.totalHarvestValue,
      cultivationMethod: context.preferences.method.index,
      usePesticides: context.preferences.usePesticides,
      useChemicalFertilizers: context.preferences.useChemicalFertilizers,
      useOrganicFertilizers: context.preferences.useOrganicFertilizers,
      cropRotation: context.preferences.cropRotation,
      companionPlanting: context.preferences.companionPlanting,
      mulching: context.preferences.mulching,
      automaticIrrigation: context.preferences.automaticIrrigation,
      regularMonitoring: context.preferences.regularMonitoring,
      objectives: context.preferences.objectives,
      createdAt: context.createdAt,
      updatedAt: context.updatedAt,
      metadata: context.metadata,
    );
  }

  /// Convertit un GardenContextHive vers GardenContext Freezed
  GardenContext toGardenContext() {
    return GardenContext(
      gardenId: gardenId,
      name: name,
      description: description,
      location: GardenLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
        city: city,
        postalCode: postalCode,
        country: country,
        usdaZone: usdaZone,
        altitude: altitude,
        exposure: exposure,
      ),
      climate: ClimateConditions(
        averageTemperature: averageTemperature,
        minTemperature: minTemperature,
        maxTemperature: maxTemperature,
        averagePrecipitation: averagePrecipitation,
        averageHumidity: averageHumidity,
        frostDays: frostDays,
        growingSeasonLength: growingSeasonLength,
        dominantWindDirection: dominantWindDirection,
        averageWindSpeed: averageWindSpeed,
        averageSunshineHours: averageSunshineHours,
      ),
      soil: SoilInfo(
        type: SoilType.values[soilType],
        ph: ph,
        texture: SoilTexture.values[soilTexture],
        organicMatter: organicMatter,
        waterRetention: waterRetention,
        drainage: SoilDrainage.values[soilDrainage],
        depth: depth,
        nutrients: NutrientLevels(
          nitrogen: NutrientLevel.values[nitrogen],
          phosphorus: NutrientLevel.values[phosphorus],
          potassium: NutrientLevel.values[potassium],
          calcium: NutrientLevel.values[calcium],
          magnesium: NutrientLevel.values[magnesium],
          sulfur: NutrientLevel.values[sulfur],
          micronutrients: {},
        ),
        biologicalActivity: BiologicalActivity.values[biologicalActivity],
        contaminants: contaminants,
      ),
      activePlantIds: activePlantIds,
      historicalPlantIds: historicalPlantIds,
      stats: GardenStats(
        totalPlants: totalPlants,
        activePlants: activePlants,
        totalArea: totalArea,
        activeArea: activeArea,
        totalYield: totalYield,
        currentYearYield: currentYearYield,
        harvestsThisYear: harvestsThisYear,
        plantingsThisYear: plantingsThisYear,
        successRate: successRate,
        totalInputCosts: totalInputCosts,
        totalHarvestValue: totalHarvestValue,
      ),
      preferences: CultivationPreferences(
        method: CultivationMethod.values[cultivationMethod],
        usePesticides: usePesticides,
        useChemicalFertilizers: useChemicalFertilizers,
        useOrganicFertilizers: useOrganicFertilizers,
        cropRotation: cropRotation,
        companionPlanting: companionPlanting,
        mulching: mulching,
        automaticIrrigation: automaticIrrigation,
        regularMonitoring: regularMonitoring,
        objectives: objectives,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}


