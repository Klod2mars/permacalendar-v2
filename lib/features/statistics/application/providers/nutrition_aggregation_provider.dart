
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import '../services/nutrition_aggregation_service.dart';

final nutritionAggregationServiceProvider = Provider<NutritionAggregationService>((ref) {
  final plants = ref.watch(plantsListProvider);
  return NutritionAggregationService(plants);
});
