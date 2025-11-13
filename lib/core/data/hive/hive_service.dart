import 'package:hive_flutter/hive_flutter.dart';

/// Service de base pour la gestion des boxes Hive
class HiveService {
  static const String _germinationEventsBox = 'germination_events';
  static const String _plantingsBox = 'plantings';
  static const String _gardensBox = 'gardens';
  static const String _plantsBox = 'plants';
  static const String _activitiesBox = 'activities';

  /// Initialise toutes les boxes Hive nécessaires
  static Future<void> initialize() async {
    // Note: Hive.initFlutter() est déjà appelé dans AppInitializer
    // On ne l'appelle pas ici pour éviter les conflits

    // Ouvrir les boxes principales (seulement celles qui ne sont pas déjà ouvertes)
    await openBox(_germinationEventsBox);
    await openBox(_activitiesBox);

    // Les boxes suivantes sont déjà ouvertes par GardenBoxes et PlantBoxes :
    // - _plantingsBox (ouvert par GardenBoxes)
    // - _gardensBox (ouvert par GardenBoxes)
    // - _plantsBox (ouvert par PlantBoxes)

    print('[HiveService] Boxes initialisées avec succès');
  }

  /// Ouvre une box Hive de manière sécurisée
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Ferme une box Hive
  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Ferme toutes les boxes ouvertes
  static Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  /// Supprime une box et toutes ses données
  static Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }

  /// Supprime TOUTES les boxes et données Hive (reset complet)
  static Future<void> deleteAllBoxes() async {
    try {
      // Fermer toutes les boxes ouvertes
      await closeAllBoxes();

      // Supprimer toutes les boxes connues
      final boxNames = [
        _germinationEventsBox,
        _plantingsBox,
        _gardensBox,
        _plantsBox,
        _activitiesBox,
        'garden_beds',
        'plant_varieties',
        'growth_cycles'
      ];

      for (final boxName in boxNames) {
        try {
          await Hive.deleteBoxFromDisk(boxName);
          print('[HiveService] Box "$boxName" supprimée');
        } catch (e) {
          print('[HiveService] Erreur suppression box "$boxName": $e');
        }
      }

      print('[HiveService] Toutes les boxes Hive ont été supprimées');
    } catch (e) {
      print('[HiveService] Erreur lors de la suppression des boxes: $e');
    }
  }

  /// Vide le contenu d'une box sans la supprimer
  static Future<void> clearBox(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  /// Getters pour les noms des boxes
  static String get germinationEventsBoxName => _germinationEventsBox;
  static String get plantingsBoxName => _plantingsBox;
  static String get gardensBoxName => _gardensBox;
  static String get plantsBoxName => _plantsBox;
  static String get activitiesBoxName => _activitiesBox;

  /// Vérifie si une box existe et contient des données
  static Future<bool> hasData(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Retourne le nombre d'éléments dans une box
  static Future<int> getBoxLength(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.length;
    } catch (e) {
      return 0;
    }
  }

  /// Sauvegarde toutes les boxes ouvertes
  static Future<void> flush() async {
    // Note: Hive ne fournit pas directement openedBoxes dans la version actuelle
    // On peut flush les boxes connues individuellement
    try {
      if (Hive.isBoxOpen(_germinationEventsBox)) {
        await Hive.box(_germinationEventsBox).flush();
      }
      if (Hive.isBoxOpen(_plantingsBox)) {
        await Hive.box(_plantingsBox).flush();
      }
      if (Hive.isBoxOpen(_gardensBox)) {
        await Hive.box(_gardensBox).flush();
      }
      if (Hive.isBoxOpen(_plantsBox)) {
        await Hive.box(_plantsBox).flush();
      }
      if (Hive.isBoxOpen(_activitiesBox)) {
        await Hive.box(_activitiesBox).flush();
      }
    } catch (e) {
      // Ignorer les erreurs de flush
    }
  }
}


