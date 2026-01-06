// lib/features/activities/domain/models/garden_history.dart
class PlantHistory {
  final String plantId;
  final String plantName;
  final DateTime? plantedDate;
  final DateTime? harvestedDate;

  PlantHistory({
    required this.plantId,
    required this.plantName,
    this.plantedDate,
    this.harvestedDate,
  });
}

class BedYearHistory {
  final String bedId;
  final String bedName;
  final int year;
  final List<PlantHistory> plants;

  BedYearHistory({
    required this.bedId,
    required this.bedName,
    required this.year,
    required this.plants,
  });
}

class YearPage {
  final int year;
  final List<BedYearHistory> beds;

  YearPage({required this.year, required this.beds});
}

class GardenHistory {
  final String gardenId;
  final String gardenName;
  final List<YearPage> years; // ordered desc: current -> older

  GardenHistory({required this.gardenId, required this.gardenName, required this.years});
}
