/// Weather alert types
enum WeatherAlertType {
  frost, // ❄️ Gel
  heatwave, // 🌡️ Canicule
  watering, // 💧 Arrosage intelligent (contextuel)
  protection, // 🛡️ Protection
}

/// Alert severity levels
enum AlertSeverity {
  info, // Information
  warning, // Attention
  critical, // Critique
}

/// Enhanced weather alert model with intelligent recommendations
class WeatherAlert {
  final String id;
  final WeatherAlertType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final DateTime validFrom;
  final DateTime validUntil;
  final double? temperature;
  final List<String> recommendations;
  final String iconPath;
  final List<String> affectedPlants; // Plantes concernées
  final bool isMeteoDependent; // Dépendant météo
  final DateTime timestamp;

  const WeatherAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.validFrom,
    required this.validUntil,
    this.temperature,
    this.recommendations = const [],
    required this.iconPath,
    this.affectedPlants = const [],
    this.isMeteoDependent = false,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'WeatherAlert(id: $id, type: $type, severity: $severity, title: $title, description: $description, validFrom: $validFrom, validUntil: $validUntil, temperature: $temperature, recommendations: $recommendations, iconPath: $iconPath, affectedPlants: $affectedPlants, isMeteoDependent: $isMeteoDependent, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherAlert &&
        other.id == id &&
        other.type == type &&
        other.severity == severity &&
        other.title == title &&
        other.description == description &&
        other.validFrom == validFrom &&
        other.validUntil == validUntil &&
        other.temperature == temperature &&
        other.recommendations == recommendations &&
        other.iconPath == iconPath &&
        other.affectedPlants == affectedPlants &&
        other.isMeteoDependent == isMeteoDependent &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        severity.hashCode ^
        title.hashCode ^
        description.hashCode ^
        validFrom.hashCode ^
        validUntil.hashCode ^
        temperature.hashCode ^
        recommendations.hashCode ^
        iconPath.hashCode ^
        affectedPlants.hashCode ^
        isMeteoDependent.hashCode ^
        timestamp.hashCode;
  }
}



