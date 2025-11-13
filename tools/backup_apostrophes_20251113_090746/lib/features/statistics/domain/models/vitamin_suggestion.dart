import '../../../../core/models/plant.dart';

/// Model pour représenter une suggestion de plante pour rééquilibrer les carences vitaminiques
class VitaminSuggestion {
  final Plant plant;
  final String vitaminKey; // "A", "B", "C", "E", "K"
  final double
      vitaminValue; // Valeur nutritionnelle de cette vitamine dans la plante

  const VitaminSuggestion({
    required this.plant,
    required this.vitaminKey,
    required this.vitaminValue,
  });

  /// Nom d'affichage de la vitamine
  String get vitaminDisplayName {
    switch (vitaminKey) {
      case 'A':
        return 'A';
      case 'B':
        return 'B';
      case 'C':
        return 'C';
      case 'E':
        return 'E';
      case 'K':
        return 'K';
      default:
        return vitaminKey;
    }
  }

  /// Unité de la vitamine
  String get vitaminUnit {
    switch (vitaminKey) {
      case 'A':
      case 'B':
      case 'K':
        return 'µg';
      case 'C':
      case 'E':
        return 'mg';
      default:
        return '';
    }
  }

  /// Valeur formatée pour l'affichage
  String get formattedVitaminValue {
    if (vitaminValue == 0) return '0';
    if (vitaminValue < 1) return vitaminValue.toStringAsFixed(2);
    return vitaminValue.toStringAsFixed(1);
  }

  @override
  String toString() {
    return 'VitaminSuggestion(plant: ${plant.commonName}, vitamin: $vitaminKey, value: $formattedVitaminValue $vitaminUnit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VitaminSuggestion &&
        other.plant.id == plant.id &&
        other.vitaminKey == vitaminKey;
  }

  @override
  int get hashCode => plant.id.hashCode ^ vitaminKey.hashCode;
}


