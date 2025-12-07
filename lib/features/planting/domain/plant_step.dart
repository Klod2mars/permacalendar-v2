// lib/features/planting/domain/plant_step.dart
import 'package:flutter/foundation.dart';

/// Modèle léger pour une étape de soin / pas-à-pas
@immutable
class PlantStep {
  final String id;
  final String title;
  final String description;
  final DateTime? scheduledDate;
  final String category;
  final bool recommended;
  final bool completed;
  final Map<String, dynamic>? meta;

  const PlantStep({
    required this.id,
    required this.title,
    this.description = '',
    this.scheduledDate,
    required this.category,
    this.recommended = true,
    this.completed = false,
    this.meta,
  });

  PlantStep copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    String? category,
    bool? recommended,
    bool? completed,
    Map<String, dynamic>? meta,
  }) {
    return PlantStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      category: category ?? this.category,
      recommended: recommended ?? this.recommended,
      completed: completed ?? this.completed,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'category': category,
      'recommended': recommended,
      'completed': completed,
      'meta': meta,
    };
  }

  factory PlantStep.fromJson(Map<String, dynamic> json) {
    return PlantStep(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.tryParse(json['scheduledDate'].toString())
          : null,
      category: json['category']?.toString() ?? '',
      recommended: json['recommended'] == null ? true : (json['recommended'] == true),
      completed: json['completed'] == true,
      meta: json['meta'] is Map<String, dynamic>
          ? json['meta']
          : (json['meta'] != null ? Map<String, dynamic>.from(json['meta']) : null),
    );
  }
}
