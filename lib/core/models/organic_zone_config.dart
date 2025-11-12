import 'package:flutter/material.dart';

/// Configuration d'une zone calibrable unifiée (Organic)
class OrganicZoneConfig {
  final String id;
  final String name;
  final Offset position; // position normalisée (0..1)
  final double size; // taille relative (0..1)
  final bool enabled; // visibilité/activation de la zone

  const OrganicZoneConfig({
    required this.id,
    required this.name,
    required this.position,
    required this.size,
    required this.enabled,
  });

  OrganicZoneConfig copyWith({
    String? id,
    String? name,
    Offset? position,
    double? size,
    bool? enabled,
  }) {
    return OrganicZoneConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      size: size ?? this.size,
      enabled: enabled ?? this.enabled,
    );
  }
}

