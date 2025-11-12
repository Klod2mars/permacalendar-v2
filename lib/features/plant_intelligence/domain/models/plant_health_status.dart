enum PlantHealthStatus {
  excellent,
  good,
  fair,
  poor,
  critical,
}

extension PlantHealthStatusExtension on PlantHealthStatus {
  String get displayName {
    switch (this) {
      case PlantHealthStatus.excellent:
        return 'Excellent';
      case PlantHealthStatus.good:
        return 'Good';
      case PlantHealthStatus.fair:
        return 'Fair';
      case PlantHealthStatus.poor:
        return 'Poor';
      case PlantHealthStatus.critical:
        return 'Critical';
    }
  }

  double get scoreThreshold {
    switch (this) {
      case PlantHealthStatus.excellent:
        return 0.9;
      case PlantHealthStatus.good:
        return 0.7;
      case PlantHealthStatus.fair:
        return 0.5;
      case PlantHealthStatus.poor:
        return 0.3;
      case PlantHealthStatus.critical:
        return 0.0;
    }
  }
}

