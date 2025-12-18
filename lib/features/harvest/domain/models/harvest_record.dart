import 'package:flutter/foundation.dart';

class HarvestRecord {
  final String id;
  final String gardenId;
  final String plantId;
  final String plantName;
  final double quantityKg;
  final double pricePerKg;
  final DateTime date;

  const HarvestRecord({
    required this.id,
    required this.gardenId,
    required this.plantId,
    required this.plantName,
    required this.quantityKg,
    required this.pricePerKg,
    required this.date,
  });

  double get totalValue => quantityKg * pricePerKg;
}
