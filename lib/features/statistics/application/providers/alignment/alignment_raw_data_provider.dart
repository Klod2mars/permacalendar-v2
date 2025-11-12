import 'package:riverpod/riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../harvest/application/harvest_records_provider.dart';
import '../../../../harvest/domain/models/harvest_record.dart';
import '../../../../../core/models/planting.dart';
import '../../../../../core/models/planting_hive.dart';
import '../../../../../core/services/plant_catalog_service.dart';
import '../../../presentation/providers/statistics_filters_provider.dart';

/// Modèle pour représenter une action d'alignement (semis/plantation ou récolte)
class AlignmentAction {
  final String id;
  final String plantId;
  final String plantName;
  final DateTime date;
  final AlignmentActionType type;
  final bool isAligned;
  final String? reason; // Raison si non aligné

  const AlignmentAction({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.date,
    required this.type,
    required this.isAligned,
    this.reason,
  });
}

/// Types d'actions d'alignement
enum AlignmentActionType {
  sowing, // Semis
  planting, // Plantation
  harvest, // Récolte
}

/// Données brutes pour le calcul de l'alignement au vivant
class AlignmentRawData {
  final List<AlignmentAction> actions;
  final bool hasData;

  const AlignmentRawData({
    required this.actions,
    required this.hasData,
  });

  /// Nombre total d'actions
  int get totalActions => actions.length;

  /// Nombre d'actions alignées
  int get alignedActions => actions.where((action) => action.isAligned).length;

  /// Nombre d'actions non alignées
  int get misalignedActions =>
      actions.where((action) => !action.isAligned).length;

  /// Pourcentage d'alignement
  double get alignmentPercentage {
    if (totalActions == 0) return 0.0;
    return (alignedActions / totalActions) * 100;
  }

  /// Actions par type
  List<AlignmentAction> get sowingActions => actions
      .where((action) => action.type == AlignmentActionType.sowing)
      .toList();

  List<AlignmentAction> get plantingActions => actions
      .where((action) => action.type == AlignmentActionType.planting)
      .toList();

  List<AlignmentAction> get harvestActions => actions
      .where((action) => action.type == AlignmentActionType.harvest)
      .toList();
}

/// Provider pour les données brutes d'alignement au vivant
///
/// Ce provider :
/// 1. Récupère toutes les actions de semis/plantation (Planting/PlantingHive) et récoltes (HarvestRecord)
/// 2. Mappe chaque action avec sa plante (via PlantCatalog)
/// 3. Convertit la date réelle en mois abrégé
/// 4. Identifie si ce mois ∈ sowingMonths ou harvestMonths ou dans la plage basée sur daysToMaturity
/// 5. Marque chaque action comme alignée = true/false
final alignmentRawDataProvider = FutureProvider<AlignmentRawData>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // S'assurer que les boîtes Hive sont ouvertes
  Box<Planting>? plantingBox;
  Box<PlantingHive>? plantingHiveBox;

  try {
    plantingBox = await Hive.openBox<Planting>('plantings');
  } catch (e) {
    plantingBox = null;
  }

  try {
    plantingHiveBox = await Hive.openBox<PlantingHive>('planting_hive');
  } catch (e) {
    plantingHiveBox = null;
  }

  final List<AlignmentAction> allActions = [];

  // Filtrer selon les filtres
  final (startDate, endDate) = filters.getEffectiveDates();

  // Traiter les plantations (Planting)
  if (plantingBox != null) {
    for (final planting in plantingBox.values) {
      // Appliquer le filtre de période
      if (planting.plantedDate.isAfter(startDate) &&
          planting.plantedDate.isBefore(endDate)) {
        final action = await _createAlignmentActionFromPlanting(planting);
        if (action != null) {
          allActions.add(action);
        }
      }
    }
  }

  // Traiter les plantations (PlantingHive)
  if (plantingHiveBox != null) {
    for (final plantingHive in plantingHiveBox.values) {
      // Appliquer le filtre de période
      if (plantingHive.plantingDate.isAfter(startDate) &&
          plantingHive.plantingDate.isBefore(endDate)) {
        final action =
            await _createAlignmentActionFromPlantingHive(plantingHive);
        if (action != null) {
          allActions.add(action);
        }
      }
    }
  }

  // Traiter les récoltes (HarvestRecord)
  for (final harvest in harvestRecordsState.records) {
    // Appliquer le filtre de jardin si spécifié
    if (filters.selectedGardenId != null &&
        filters.selectedGardenId!.isNotEmpty &&
        harvest.gardenId != filters.selectedGardenId) {
      continue;
    }

    // Appliquer le filtre de période
    if (harvest.date.isAfter(startDate) && harvest.date.isBefore(endDate)) {
      final action = await _createAlignmentActionFromHarvest(harvest);
      if (action != null) {
        allActions.add(action);
      }
    }
  }

  return AlignmentRawData(
    actions: allActions,
    hasData: allActions.isNotEmpty,
  );
});

/// Crée une action d'alignement à partir d'un Planting
Future<AlignmentAction?> _createAlignmentActionFromPlanting(
    Planting planting) async {
  try {
    // Récupérer les informations de la plante
    final plant = await PlantCatalogService.getPlantById(planting.plantId);
    if (plant == null) return null;

    // Déterminer le type d'action
    final actionType = planting.status == 'Semé'
        ? AlignmentActionType.sowing
        : AlignmentActionType.planting;

    // Vérifier l'alignement
    final alignmentResult = await _checkAlignment(
      date: planting.plantedDate,
      plant: plant,
      actionType: actionType,
    );
    final isAligned = alignmentResult.$1;
    final reason = alignmentResult.$2;

    return AlignmentAction(
      id: planting.id,
      plantId: planting.plantId,
      plantName: planting.plantName,
      date: planting.plantedDate,
      type: actionType,
      isAligned: isAligned,
      reason: reason,
    );
  } catch (e) {
    return null;
  }
}

/// Crée une action d'alignement à partir d'un PlantingHive
Future<AlignmentAction?> _createAlignmentActionFromPlantingHive(
    PlantingHive plantingHive) async {
  try {
    // Récupérer les informations de la plante
    final plant = await PlantCatalogService.getPlantById(plantingHive.plantId);
    if (plant == null) return null;

    // Déterminer le type d'action (PlantingHive ne distingue pas semis/plantation)
    const actionType = AlignmentActionType.planting;

    // Vérifier l'alignement
    final alignmentResult = await _checkAlignment(
      date: plantingHive.plantingDate,
      plant: plant,
      actionType: actionType,
    );
    final isAligned = alignmentResult.$1;
    final reason = alignmentResult.$2;

    return AlignmentAction(
      id: plantingHive.id,
      plantId: plantingHive.plantId,
      plantName: plant.commonName, // Utiliser le nom du catalogue
      date: plantingHive.plantingDate,
      type: actionType,
      isAligned: isAligned,
      reason: reason,
    );
  } catch (e) {
    return null;
  }
}

/// Crée une action d'alignement à partir d'un HarvestRecord
Future<AlignmentAction?> _createAlignmentActionFromHarvest(
    HarvestRecord harvest) async {
  try {
    // Récupérer les informations de la plante
    final plant = await PlantCatalogService.getPlantById(harvest.plantId);
    if (plant == null) return null;

    // Vérifier l'alignement pour la récolte
    final alignmentResult = await _checkAlignment(
      date: harvest.date,
      plant: plant,
      actionType: AlignmentActionType.harvest,
    );
    final isAligned = alignmentResult.$1;
    final reason = alignmentResult.$2;

    return AlignmentAction(
      id: harvest.id,
      plantId: harvest.plantId,
      plantName: harvest.plantName,
      date: harvest.date,
      type: AlignmentActionType.harvest,
      isAligned: isAligned,
      reason: reason,
    );
  } catch (e) {
    return null;
  }
}

/// Vérifie si une action est alignée avec les recommandations de la plante
///
/// Retourne un tuple (isAligned, reason)
///
/// Pour les semis/plantations : vérifie si le mois ∈ sowingMonths
/// Pour les récoltes : vérifie si le mois ∈ harvestMonths OU dans la plage calculée via daysToMaturity
Future<(bool, String?)> _checkAlignment({
  required DateTime date,
  required dynamic plant, // Plant ou PlantFreezed
  required AlignmentActionType actionType,
}) async {
  try {
    final monthAbbr = _getMonthAbbreviation(date);

    if (actionType == AlignmentActionType.sowing ||
        actionType == AlignmentActionType.planting) {
      // Vérifier l'alignement pour semis/plantation
      final sowingMonths = plant.sowingMonths as List<String>;

      if (sowingMonths.contains(monthAbbr)) {
        return (true, null);
      } else {
        return (
          false,
          'Hors période de semis recommandée (${sowingMonths.join(', ')})'
        );
      }
    } else if (actionType == AlignmentActionType.harvest) {
      // Vérifier l'alignement pour récolte
      final harvestMonths = plant.harvestMonths as List<String>;

      // Vérifier d'abord les mois de récolte explicites
      if (harvestMonths.contains(monthAbbr)) {
        return (true, null);
      }

      // Si pas dans les mois explicites, vérifier si c'est dans une plage calculée
      // On pourrait implémenter une logique plus sophistiquée ici
      // Pour l'instant, on considère que si ce n'est pas dans harvestMonths, c'est non aligné
      return (
        false,
        'Hors période de récolte recommandée (${harvestMonths.join(', ')})'
      );
    }

    return (false, 'Type d\'action non reconnu');
  } catch (e) {
    return (false, 'Erreur lors de la vérification: $e');
  }
}

/// Convertit un DateTime en abréviation de mois
String _getMonthAbbreviation(DateTime date) {
  const abbr = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
  return abbr[date.month - 1];
}


