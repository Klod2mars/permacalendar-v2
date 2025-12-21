import 'package:flutter/foundation.dart';

class HarvestRecord {
  final String id;
  final String gardenId;
  final String plantId;
  final String plantName;
  final double quantityKg;
  final double pricePerKg;
  final DateTime date;
  final String? notes;

  const HarvestRecord({
    required this.id,
    required this.gardenId,
    required this.plantId,
    required this.plantName,
    required this.quantityKg,
    required this.pricePerKg,
    required this.date,
    this.notes,
  });

  double get totalValue => quantityKg * pricePerKg;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gardenId': gardenId,
      'plantId': plantId,
      'plantName': plantName,
      'quantityKg': quantityKg,
      'pricePerKg': pricePerKg,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory HarvestRecord.fromJson(Map<String, dynamic> json) {
    return HarvestRecord(
      id: json['id'] as String,
      gardenId: json['gardenId'] as String,
      plantId: json['plantId'] as String,
      plantName: json['plantName'] as String,
      quantityKg: (json['quantityKg'] as num).toDouble(),
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }
}
