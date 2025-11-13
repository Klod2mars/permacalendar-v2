class PlantValueRanking {
  final String plantName;
  final double totalValue;

  PlantValueRanking({
    required this.plantName,
    required this.totalValue,
  });

  @override
  String toString() {
    return 'PlantValueRanking(plantName: $plantName, totalValue: $totalValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlantValueRanking &&
        other.plantName == plantName &&
        other.totalValue == totalValue;
  }

  @override
  int get hashCode => plantName.hashCode ^ totalValue.hashCode;
}


