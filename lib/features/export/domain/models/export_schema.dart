import 'package:permacalendar/features/export/domain/models/export_config.dart';

/// Static definitions of all available export blocks and fields
class ExportSchema {
  static const String version = "1.0.0";

  static Map<ExportBlockType, String> blockLabels = {
    ExportBlockType.garden: "Jardins (Structure)",
    ExportBlockType.gardenBed: "Parcelles",
    ExportBlockType.plant: "Plantes (Catalogue)",
    ExportBlockType.activity: "Activités (Journal)",
    ExportBlockType.harvest: "Récoltes (Production)",
  };

  static Map<ExportBlockType, String> blockDescriptions = {
    ExportBlockType.garden:
        "Métadonnées des jardins sélectionnés (surface, localisation...)",
    ExportBlockType.gardenBed:
        "Détails des parcelles (surface, orientation...)",
    ExportBlockType.plant: "Liste des plantes utilisées du catalogue",
    ExportBlockType.activity:
        "Historique complet des interventions et événements",
    ExportBlockType.harvest: "Données de production et rendements",
  };

  static Map<ExportBlockType, List<ExportField>> fields = {
    ExportBlockType.garden: [
      const ExportField(
          id: 'garden_name',
          label: 'Nom du jardin',
          description: 'Nom donné au jardin',
          isContext: true),
      const ExportField(
          id: 'garden_id',
          label: 'ID Jardin',
          description: 'Identifiant unique technique',
          isContext: true,
          isAdvanced: true),
      const ExportField(
          id: 'garden_surface',
          label: 'Surface (m²)',
          description: 'Surface totale du jardin'),
      const ExportField(
          id: 'garden_creation_date',
          label: 'Date création',
          description: 'Date de création dans l\'application',
          isAdvanced: true),
    ],
    ExportBlockType.gardenBed: [
      const ExportField(
          id: 'bed_name',
          label: 'Nom parcelle',
          description: 'Nom de la parcelle',
          isContext: true),
      const ExportField(
          id: 'bed_id',
          label: 'ID Parcelle',
          description: 'Identifiant unique technique',
          isContext: true,
          isAdvanced: true),
      const ExportField(
          id: 'bed_surface',
          label: 'Surface (m²)',
          description: 'Surface de la parcelle'),
      // Add orientation etc if available in model
      const ExportField(
          id: 'bed_plant_count',
          label: 'Nb Plantes',
          description: 'Nombre de cultures en place (actuel)',
          isAdvanced: true),
    ],
    ExportBlockType.plant: [
      const ExportField(
          id: 'plant_name',
          label: 'Nom commun',
          description: 'Nom usuel de la plante',
          isContext: true),
      const ExportField(
          id: 'plant_id',
          label: 'ID Plante',
          description: 'Identifiant unique technique',
          isContext: true,
          isAdvanced: true),
      const ExportField(
          id: 'plant_scientific',
          label: 'Nom scientifique',
          description: 'Dénomination botanique',
          isAdvanced: true),
      const ExportField(
          id: 'plant_family',
          label: 'Famille',
          description: 'Famille botanique',
          isAdvanced: true),
      const ExportField(
          id: 'plant_variety',
          label: 'Variété',
          description: 'Variété spécifique',
          isAdvanced: true),
    ],
    ExportBlockType.harvest: [
      const ExportField(
          id: 'harvest_date',
          label: 'Date Récolte',
          description: 'Date de l\'événement de récolte'),
      const ExportField(
          id: 'harvest_qty',
          label: 'Quantité (kg)',
          description: 'Poids récolté en kg'),
      const ExportField(
          id: 'harvest_plant_name',
          label: 'Plante',
          description: 'Nom de la plante récoltée',
          isContext: true),
      const ExportField(
          id: 'harvest_price',
          label: 'Prix/kg',
          description: 'Prix au kg configuré',
          isAdvanced: true),
      const ExportField(
          id: 'harvest_value',
          label: 'Valeur Totale',
          description: 'Quantité * Prix/kg',
          isAdvanced: true),
      const ExportField(
          id: 'harvest_notes',
          label: 'Notes',
          description: 'Observations saisies lors de la récolte'),
      const ExportField(
          id: 'harvest_garden_name',
          label: 'Jardin',
          description: 'Nom du jardin d\'origine (si disponible)',
          isContext: true),
      const ExportField(
          id: 'harvest_garden_id',
          label: 'ID Jardin',
          description: 'Identifiant unique du jardin',
          isContext: true,
          isAdvanced: true),
      const ExportField(
          id: 'harvest_bed_name',
          label: 'Parcelle',
          description: 'Parcelle d\'origine (si disponible)',
          isContext: true),
      const ExportField(
          id: 'harvest_bed_id',
          label: 'ID Parcelle',
          description: 'Identifiant parcelle',
          isAdvanced: true,
          isContext: true),
    ],
    ExportBlockType.activity: [
      const ExportField(
          id: 'activity_date',
          label: 'Date',
          description: 'Date de l\'activité'),
      const ExportField(
          id: 'activity_type',
          label: 'Type',
          description: 'Catégorie d\'action (Semis, Récolte, Soin...)'),
      const ExportField(
          id: 'activity_title',
          label: 'Titre',
          description: 'Résumé de l\'action'),
      const ExportField(
          id: 'activity_desc',
          label: 'Description',
          description: 'Détails complets'),
      const ExportField(
          id: 'activity_entity',
          label: 'Entité Cible',
          description: 'Nom de l\'objet concerné (Plante, Parcelle...)',
          isContext: true),
      const ExportField(
          id: 'activity_entity_id',
          label: 'ID Cible',
          description: 'ID de l\'objet concerné',
          isAdvanced: true),
    ]
  };

  static List<ExportField> getFieldsFor(ExportBlockType type) =>
      fields[type] ?? [];

  static ExportField? getFieldById(ExportBlockType type, String fieldId) {
    try {
      return fields[type]?.firstWhere((f) => f.id == fieldId);
    } catch (_) {
      return null;
    }
  }
}
