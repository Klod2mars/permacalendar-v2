/// GENERATED FILE - DO NOT EDIT
// Run .scripts/generate_register_adapters.ps1 to regenerate.
import 'package:hive/hive.dart';
import 'package:permacalendar/core/models/activity.dart';
import 'package:permacalendar/core/models/activity_v3.dart';
import 'package:permacalendar/core/models/calibration_state.dart';
import 'package:permacalendar/core/models/garden_bed_hive.dart';
import 'package:permacalendar/core/models/garden_bed_v2.dart';
import 'package:permacalendar/core/models/garden_hive.dart';
import 'package:permacalendar/core/models/garden_v2.dart';
import 'package:permacalendar/core/models/germination_event.dart';
import 'package:permacalendar/core/models/growth_cycle.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/core/models/plant_variety.dart';
import 'package:permacalendar/core/models/planting_hive.dart';
import 'package:permacalendar/core/models/planting_v2.dart';
import 'package:permacalendar/features/climate/data/datasources/soil_metrics_local_ds.dart';
import 'package:permacalendar/features/plant_catalog/data/models/plant_hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/beneficial_insect.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/bio_control_recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context_hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/notification_alert.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest_observation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition_hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation_hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition_hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/models/plant_health_status.dart';

void registerAllHiveAdapters() {
  try {
    if (!Hive.isAdapterRegistered(16)) { Hive.registerAdapter(ActivityAdapter()); }
    if (!Hive.isAdapterRegistered(17)) { Hive.registerAdapter(ActivityTypeAdapter()); }
    if (!Hive.isAdapterRegistered(30)) { Hive.registerAdapter(ActivityV3Adapter()); }
    if (!Hive.isAdapterRegistered(44)) { Hive.registerAdapter(AlertSeverityAdapter()); }
    if (!Hive.isAdapterRegistered(51)) { Hive.registerAdapter(BeneficialInsectHiveAdapter()); }
    if (!Hive.isAdapterRegistered(53)) { Hive.registerAdapter(BioControlRecommendationHiveAdapter()); }
    if (!Hive.isAdapterRegistered(60)) { Hive.registerAdapter(CalibrationStateAdapter()); }
    if (!Hive.isAdapterRegistered(61)) { Hive.registerAdapter(CalibrationTypeAdapter()); }
    if (!Hive.isAdapterRegistered(18)) { Hive.registerAdapter(EntityTypeAdapter()); }
    if (!Hive.isAdapterRegistered(10)) { Hive.registerAdapter(GardenAdapter()); }
    if (!Hive.isAdapterRegistered(11)) { Hive.registerAdapter(GardenBedAdapter()); }
    if (!Hive.isAdapterRegistered(26)) { Hive.registerAdapter(GardenBedHiveAdapter()); }
    if (!Hive.isAdapterRegistered(50)) { Hive.registerAdapter(GardenContextHiveAdapter()); }
    if (!Hive.isAdapterRegistered(25)) { Hive.registerAdapter(GardenHiveAdapter()); }
    if (!Hive.isAdapterRegistered(6)) { Hive.registerAdapter(GerminationEventAdapter()); }
    if (!Hive.isAdapterRegistered(5)) { Hive.registerAdapter(GrowthCycleAdapter()); }
    if (!Hive.isAdapterRegistered(43)) { Hive.registerAdapter(NotificationAlertAdapter()); }
    if (!Hive.isAdapterRegistered(41)) { Hive.registerAdapter(NotificationPriorityAdapter()); }
    if (!Hive.isAdapterRegistered(42)) { Hive.registerAdapter(NotificationStatusAdapter()); }
    if (!Hive.isAdapterRegistered(40)) { Hive.registerAdapter(NotificationTypeAdapter()); }
    if (!Hive.isAdapterRegistered(50)) { Hive.registerAdapter(PestHiveAdapter()); }
    if (!Hive.isAdapterRegistered(52)) { Hive.registerAdapter(PestObservationHiveAdapter()); }
    if (!Hive.isAdapterRegistered(2)) { Hive.registerAdapter(PlantAdapter()); }
    if (!Hive.isAdapterRegistered(43)) { Hive.registerAdapter(PlantConditionHiveAdapter()); }
    if (!Hive.isAdapterRegistered(56)) { Hive.registerAdapter(PlantHealthComponentAdapter()); }
    if (!Hive.isAdapterRegistered(55)) { Hive.registerAdapter(PlantHealthFactorAdapter()); }
    if (!Hive.isAdapterRegistered(54)) { Hive.registerAdapter(PlantHealthLevelAdapter()); }
    if (!Hive.isAdapterRegistered(57)) { Hive.registerAdapter(PlantHealthStatusAdapter()); }
    if (!Hive.isAdapterRegistered(28)) { Hive.registerAdapter(PlantHiveAdapter()); }
    if (!Hive.isAdapterRegistered(14)) { Hive.registerAdapter(PlantingAdapter()); }
    if (!Hive.isAdapterRegistered(27)) { Hive.registerAdapter(PlantingHiveAdapter()); }
    if (!Hive.isAdapterRegistered(4)) { Hive.registerAdapter(PlantVarietyAdapter()); }
    if (!Hive.isAdapterRegistered(39)) { Hive.registerAdapter(RecommendationHiveAdapter()); }
    if (!Hive.isAdapterRegistered(28)) { Hive.registerAdapter(SoilMetricsDtoAdapter()); }
    if (!Hive.isAdapterRegistered(37)) { Hive.registerAdapter(WeatherConditionHiveAdapter()); }
    if (!Hive.isAdapterRegistered(38)) { Hive.registerAdapter(WeatherForecastHiveAdapter()); }
  } catch (e) {
    // ignore errors during adapter registration in test bootstrap
  }
}

