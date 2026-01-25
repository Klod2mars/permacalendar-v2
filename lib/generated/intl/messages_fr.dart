// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(name) => "Parcelle \"${name}\" créée";

  static String m1(name) => "Parcelle \"${name}\" supprimée";

  static String m2(name) => "Parcelle \"${name}\" mise à jour";

  static String m3(name) => "Jardin \"${name}\" créé";

  static String m4(name) => "Jardin \"${name}\" supprimé";

  static String m5(name) => "Jardin \"${name}\" mis à jour";

  static String m6(name) => "Germination de \"${name}\" confirmée";

  static String m7(name) => "Récolte de \"${name}\" enregistrée";

  static String m8(type) => "Maintenance : ${type}";

  static String m9(name) => "Plantation de \"${name}\" ajoutée";

  static String m10(name) => "Plantation de \"${name}\" supprimée";

  static String m11(name) => "Plantation de \"${name}\" mise à jour";

  static String m12(name) => "Parcelle: ${name}";

  static String m13(date) => "Date: ${date}";

  static String m14(name) => "Jardin: ${name}";

  static String m15(type) => "Maintenance: ${type}";

  static String m16(name) => "Plante: ${name}";

  static String m17(quantity) => "Quantité: ${quantity}";

  static String m18(weather) => "Météo: ${weather}";

  static String m19(gardenName) => "Récentes (${gardenName})";

  static String m20(count) =>
      "${Intl.plural(count, one: 'Il y a 1 jour', other: 'Il y a ${count} jours')}";

  static String m21(hours) => "Il y a ${hours} h";

  static String m22(minutes) => "Il y a ${minutes} min";

  static String m23(date) => "Semé le ${date}";

  static String m24(error) => "Erreur attribution : ${error}";

  static String m25(title) => "\"${title}\" sera supprimée.";

  static String m26(error) => "Erreur suppression : ${error}";

  static String m27(date) => "Événements du ${date}";

  static String m28(error) => "Erreur export PDF: ${error}";

  static String m29(error) => "Erreur restauration : ${error}";

  static String m30(name) => "Tâche attribuée à ${name}";

  static String m31(key) => "Clé appareil: ${key}";

  static String m32(error) => "Erreur sauvegarde calibration: ${error}";

  static String m33(error) => "Erreur import JSON: ${error}";

  static String m34(error) => "Erreur lors de la sauvegarde: ${error}";

  static String m35(error) => "Erreur: ${error}";

  static String m36(name) => "Jardin \"${name}\" créé avec succès";

  static String m37(number) => "Jardin ${number}";

  static String m38(uri) => "La page \"${uri}\" n\'existe pas.";

  static String m39(count) => "${count} colonnes sélectionnées";

  static String m40(error) => "Erreur: ${error}";

  static String m41(count) => "${count} jardin(s) sélectionné(s)";

  static String m42(bedName) =>
      "Êtes-vous sûr de vouloir supprimer \"${bedName}\" ? Cette action est irréversible.";

  static String m43(error) => "Erreur lors de la suppression: ${error}";

  static String m44(date) => "Créé le ${date}";

  static String m45(error) => "Impossible de charger les planches: ${error}";

  static String m46(error) =>
      "Impossible de charger la liste des jardins : ${error}";

  static String m47(plantName) => "Récolte :${plantName}";

  static String m48(label) => "Langue changée : ${label}";

  static String m49(days) => "Il y a ${days} jours";

  static String m50(days) => "Dans ${days} jours";

  static String m51(month) => "Dynamique de ${month}";

  static String m52(plant) => "${plant} ajouté aux favoris";

  static String m53(months) => "Périodes: ${months}";

  static String m54(date) => "Récolte estimée : ${date}";

  static String m55(date) => "Planté le ${date}";

  static String m56(date) => "Semé le ${date}";

  static String m57(cm) => "${cm} cm";

  static String m58(days) => "${days} jours";

  static String m59(plantName) => "Plante : ${plantName}";

  static String m60(date) => "Le ${date}";

  static String m61(count) => "+ ${count} autres étapes";

  static String m62(gardenBedName) => "Plantations - ${gardenBedName}";

  static String m73(error) => "Échec de la sauvegarde : ${error}";

  static String m63(label) => "Défaut: ${label}";

  static String m64(label) => "Sélectionnée: ${label}";

  static String m74(error) => "Échec de la restauration : ${error}";

  static String m65(version) =>
      "Version: ${version} – Gestion de jardin dynamique\n\nSowing - Gestion de jardins vivants";

  static String m66(name) => "Commune sélectionnée: ${name}";

  static String m67(temp, date) => "Dernière mesure : ${temp}°C (${date})";

  static String m68(error) => "Erreur sauvegarde : ${error}";

  static String m69(error) => "Erreur conseils: ${error}";

  static String m70(error) => "Erreur catalogue: ${error}";

  static String m71(error) => "Erreur chart: ${error}";

  static String m72(name) => "Ajouter \"${name}\" aux favoris";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "activity_desc_bed_created": m0,
        "activity_desc_bed_deleted": m1,
        "activity_desc_bed_updated": m2,
        "activity_desc_garden_created": m3,
        "activity_desc_garden_deleted": m4,
        "activity_desc_garden_updated": m5,
        "activity_desc_germination": m6,
        "activity_desc_harvest": m7,
        "activity_desc_maintenance": m8,
        "activity_desc_planting_created": m9,
        "activity_desc_planting_deleted": m10,
        "activity_desc_planting_updated": m11,
        "activity_empty_subtitle": MessageLookupByLibrary.simpleMessage(
            "Les activités de jardinage apparaîtront ici"),
        "activity_empty_title":
            MessageLookupByLibrary.simpleMessage("Aucune activité trouvée"),
        "activity_error_loading":
            MessageLookupByLibrary.simpleMessage("Erreur lors du chargement"),
        "activity_history_empty": MessageLookupByLibrary.simpleMessage(
            "Aucun jardin sélectionné.\nPour consulter l’historique d’un jardin, sélectionnez-le par un appui long depuis le tableau de bord."),
        "activity_history_section_title":
            MessageLookupByLibrary.simpleMessage("Historique — "),
        "activity_metadata_bed": m12,
        "activity_metadata_date": m13,
        "activity_metadata_garden": m14,
        "activity_metadata_maintenance": m15,
        "activity_metadata_plant": m16,
        "activity_metadata_quantity": m17,
        "activity_metadata_weather": m18,
        "activity_priority_important":
            MessageLookupByLibrary.simpleMessage("Important"),
        "activity_priority_normal":
            MessageLookupByLibrary.simpleMessage("Normal"),
        "activity_screen_title":
            MessageLookupByLibrary.simpleMessage("Activités & Historique"),
        "activity_tab_history":
            MessageLookupByLibrary.simpleMessage("Historique"),
        "activity_tab_recent_garden": m19,
        "activity_tab_recent_global":
            MessageLookupByLibrary.simpleMessage("Récentes (Global)"),
        "activity_time_days_ago": m20,
        "activity_time_hours_ago": m21,
        "activity_time_just_now":
            MessageLookupByLibrary.simpleMessage("À l\'instant"),
        "activity_time_minutes_ago": m22,
        "appTitle": MessageLookupByLibrary.simpleMessage("Sowing"),
        "bed_action_harvest": MessageLookupByLibrary.simpleMessage("Récolter"),
        "bed_card_harvest_start":
            MessageLookupByLibrary.simpleMessage("vers début récolte"),
        "bed_card_sown_on": m23,
        "bed_create_title_edit":
            MessageLookupByLibrary.simpleMessage("Modifier la parcelle"),
        "bed_create_title_new":
            MessageLookupByLibrary.simpleMessage("Nouvelle parcelle"),
        "bed_delete_planting_confirm_body": MessageLookupByLibrary.simpleMessage(
            "Cette action est irréversible. Voulez-vous vraiment supprimer cette plantation ?"),
        "bed_delete_planting_confirm_title":
            MessageLookupByLibrary.simpleMessage("Supprimer la plantation ?"),
        "bed_detail_add_planting":
            MessageLookupByLibrary.simpleMessage("Ajouter une plantation"),
        "bed_detail_current_plantings":
            MessageLookupByLibrary.simpleMessage("Plantations actuelles"),
        "bed_detail_details": MessageLookupByLibrary.simpleMessage("Détails"),
        "bed_detail_no_plantings_desc": MessageLookupByLibrary.simpleMessage(
            "Cette parcelle n\'a pas encore de plantations."),
        "bed_detail_no_plantings_title":
            MessageLookupByLibrary.simpleMessage("Aucune plantation"),
        "bed_detail_notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "bed_detail_surface": MessageLookupByLibrary.simpleMessage("Surface"),
        "bed_form_desc_hint":
            MessageLookupByLibrary.simpleMessage("Description..."),
        "bed_form_desc_label":
            MessageLookupByLibrary.simpleMessage("Description"),
        "bed_form_error_name_length": MessageLookupByLibrary.simpleMessage(
            "Le nom doit contenir au moins 2 caractères"),
        "bed_form_error_name_required":
            MessageLookupByLibrary.simpleMessage("Le nom est obligatoire"),
        "bed_form_error_size_invalid": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer une surface valide"),
        "bed_form_error_size_max": MessageLookupByLibrary.simpleMessage(
            "La surface ne peut pas dépasser 1000 m²"),
        "bed_form_error_size_required":
            MessageLookupByLibrary.simpleMessage("La surface est obligatoire"),
        "bed_form_name_hint": MessageLookupByLibrary.simpleMessage(
            "Ex: Parcelle Nord, Planche 1"),
        "bed_form_name_label":
            MessageLookupByLibrary.simpleMessage("Nom de la parcelle *"),
        "bed_form_size_hint": MessageLookupByLibrary.simpleMessage("Ex: 10.5"),
        "bed_form_size_label":
            MessageLookupByLibrary.simpleMessage("Surface (m²) *"),
        "bed_form_submit_create": MessageLookupByLibrary.simpleMessage("Créer"),
        "bed_form_submit_edit":
            MessageLookupByLibrary.simpleMessage("Modifier"),
        "bed_snack_created":
            MessageLookupByLibrary.simpleMessage("Parcelle créée avec succès"),
        "bed_snack_updated": MessageLookupByLibrary.simpleMessage(
            "Parcelle modifiée avec succès"),
        "calendar_action_assign":
            MessageLookupByLibrary.simpleMessage("Envoyer / Attribuer à..."),
        "calendar_ask_export_pdf": MessageLookupByLibrary.simpleMessage(
            "Voulez-vous l\'envoyer à quelqu\'un en PDF ?"),
        "calendar_assign_error": m24,
        "calendar_assign_field":
            MessageLookupByLibrary.simpleMessage("Nom ou Email"),
        "calendar_assign_hint": MessageLookupByLibrary.simpleMessage(
            "Saisir le nom ou email du destinataire"),
        "calendar_assign_title":
            MessageLookupByLibrary.simpleMessage("Attribuer / Envoyer"),
        "calendar_delete_confirm_content": m25,
        "calendar_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Supprimer la tâche ?"),
        "calendar_delete_error": m26,
        "calendar_drag_instruction":
            MessageLookupByLibrary.simpleMessage("Glisser pour naviguer"),
        "calendar_events_of": m27,
        "calendar_export_error": m28,
        "calendar_filter_harvests":
            MessageLookupByLibrary.simpleMessage("Récoltes"),
        "calendar_filter_maintenance":
            MessageLookupByLibrary.simpleMessage("Entretien"),
        "calendar_filter_tasks": MessageLookupByLibrary.simpleMessage("Tâches"),
        "calendar_filter_urgent":
            MessageLookupByLibrary.simpleMessage("Urgences"),
        "calendar_limit_reached":
            MessageLookupByLibrary.simpleMessage("Limite atteinte"),
        "calendar_new_task_tooltip":
            MessageLookupByLibrary.simpleMessage("Nouvelle Tâche"),
        "calendar_next_month":
            MessageLookupByLibrary.simpleMessage("Mois suivant"),
        "calendar_no_events":
            MessageLookupByLibrary.simpleMessage("Aucun événement ce jour"),
        "calendar_previous_month":
            MessageLookupByLibrary.simpleMessage("Mois précédent"),
        "calendar_refreshed":
            MessageLookupByLibrary.simpleMessage("Calendrier actualisé"),
        "calendar_restore_error": m29,
        "calendar_section_harvests":
            MessageLookupByLibrary.simpleMessage("Récoltes prévues"),
        "calendar_section_plantings":
            MessageLookupByLibrary.simpleMessage("Plantations"),
        "calendar_section_tasks":
            MessageLookupByLibrary.simpleMessage("Tâches planifiées"),
        "calendar_task_assigned": m30,
        "calendar_task_deleted":
            MessageLookupByLibrary.simpleMessage("Tâche supprimée"),
        "calendar_task_modified":
            MessageLookupByLibrary.simpleMessage("Tâche modifiée"),
        "calendar_task_saved_title":
            MessageLookupByLibrary.simpleMessage("Tâche enregistrée"),
        "calendar_title":
            MessageLookupByLibrary.simpleMessage("Calendrier de culture"),
        "calibration_action_delete":
            MessageLookupByLibrary.simpleMessage("Supprimer"),
        "calibration_action_validate_exit":
            MessageLookupByLibrary.simpleMessage("Valider & Quitter"),
        "calibration_auto_apply": MessageLookupByLibrary.simpleMessage(
            "Appliquer automatiquement pour cet appareil"),
        "calibration_calibrate_now":
            MessageLookupByLibrary.simpleMessage("Calibrer maintenant"),
        "calibration_dialog_confirm_title":
            MessageLookupByLibrary.simpleMessage("Confirmer"),
        "calibration_dialog_delete_profile":
            MessageLookupByLibrary.simpleMessage(
                "Supprimer le profil de calibration pour cet appareil ?"),
        "calibration_export_profile": MessageLookupByLibrary.simpleMessage(
            "Exporter profil (copie JSON)"),
        "calibration_image_settings_title":
            MessageLookupByLibrary.simpleMessage(
                "Réglages Image de Fond (Persistant)"),
        "calibration_import_profile": MessageLookupByLibrary.simpleMessage(
            "Importer profil depuis presse-papiers"),
        "calibration_instruction_image": MessageLookupByLibrary.simpleMessage(
            "Glissez pour déplacer, pincez pour zoomer l\'image de fond."),
        "calibration_instruction_modules": MessageLookupByLibrary.simpleMessage(
            "Déplacez les modules (bulles) à l\'emplacement souhaité."),
        "calibration_instruction_none": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez un outil pour commencer."),
        "calibration_instruction_sky": MessageLookupByLibrary.simpleMessage(
            "Ajustez l\'ovoïde jour/nuit (centre, taille, rotation)."),
        "calibration_key_device": m31,
        "calibration_no_profile": MessageLookupByLibrary.simpleMessage(
            "Aucun profil enregistré pour cet appareil."),
        "calibration_organic_disabled": MessageLookupByLibrary.simpleMessage(
            "🌿 Calibration organique désactivée"),
        "calibration_organic_enabled": MessageLookupByLibrary.simpleMessage(
            "🌿 Mode calibration organique activé. Sélectionnez l’un des trois onglets."),
        "calibration_organic_subtitle": MessageLookupByLibrary.simpleMessage(
            "Mode unifié : Image, Ciel, Modules"),
        "calibration_organic_title":
            MessageLookupByLibrary.simpleMessage("Calibration Organique"),
        "calibration_overlay_error_save": m32,
        "calibration_overlay_saved":
            MessageLookupByLibrary.simpleMessage("Calibration sauvegardée"),
        "calibration_pos_x": MessageLookupByLibrary.simpleMessage("Pos X"),
        "calibration_pos_y": MessageLookupByLibrary.simpleMessage("Pos Y"),
        "calibration_refresh_profile":
            MessageLookupByLibrary.simpleMessage("Actualiser aperçu profil"),
        "calibration_reset_image":
            MessageLookupByLibrary.simpleMessage("Reset Image Defaults"),
        "calibration_reset_profile": MessageLookupByLibrary.simpleMessage(
            "Réinitialiser profil pour cet appareil"),
        "calibration_save_profile": MessageLookupByLibrary.simpleMessage(
            "Sauvegarder calibration actuelle comme profil"),
        "calibration_snack_clipboard_empty":
            MessageLookupByLibrary.simpleMessage("Presse-papiers vide."),
        "calibration_snack_import_error": m33,
        "calibration_snack_no_calibration": MessageLookupByLibrary.simpleMessage(
            "Aucune calibration enregistrée. Calibrez d\'abord depuis le dashboard."),
        "calibration_snack_no_profile": MessageLookupByLibrary.simpleMessage(
            "Aucun profil trouvé pour cet appareil."),
        "calibration_snack_profile_copied":
            MessageLookupByLibrary.simpleMessage(
                "Profil copié dans le presse-papiers."),
        "calibration_snack_profile_deleted":
            MessageLookupByLibrary.simpleMessage(
                "Profil supprimé pour cet appareil."),
        "calibration_snack_profile_imported":
            MessageLookupByLibrary.simpleMessage(
                "Profil importé et sauvegardé pour cet appareil."),
        "calibration_snack_save_error": m34,
        "calibration_snack_saved_as_profile": MessageLookupByLibrary.simpleMessage(
            "Calibration actuelle sauvegardée comme profil pour cet appareil."),
        "calibration_subtitle": MessageLookupByLibrary.simpleMessage(
            "Personnalisez l\'affichage de votre dashboard"),
        "calibration_title":
            MessageLookupByLibrary.simpleMessage("Calibration"),
        "calibration_tool_image": MessageLookupByLibrary.simpleMessage("Image"),
        "calibration_tool_modules":
            MessageLookupByLibrary.simpleMessage("Modules"),
        "calibration_tool_sky": MessageLookupByLibrary.simpleMessage("Ciel"),
        "calibration_zoom": MessageLookupByLibrary.simpleMessage("Zoom"),
        "common_back": MessageLookupByLibrary.simpleMessage("Retour"),
        "common_cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "common_close": MessageLookupByLibrary.simpleMessage("Fermer"),
        "common_delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "common_duplicate": MessageLookupByLibrary.simpleMessage("Dupliquer"),
        "common_edit": MessageLookupByLibrary.simpleMessage("Modifier"),
        "common_error": MessageLookupByLibrary.simpleMessage("Erreur"),
        "common_error_prefix": m35,
        "common_general_error":
            MessageLookupByLibrary.simpleMessage("Une erreur est survenue"),
        "common_no": MessageLookupByLibrary.simpleMessage("Non"),
        "common_refresh": MessageLookupByLibrary.simpleMessage("Actualiser"),
        "common_retry": MessageLookupByLibrary.simpleMessage("Réessayer"),
        "common_save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "common_undo": MessageLookupByLibrary.simpleMessage("Annuler"),
        "common_validate": MessageLookupByLibrary.simpleMessage("Valider"),
        "common_yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "companion_avoid":
            MessageLookupByLibrary.simpleMessage("Plantes à éviter"),
        "companion_beneficial":
            MessageLookupByLibrary.simpleMessage("Plantes amies"),
        "dashboard_activities":
            MessageLookupByLibrary.simpleMessage("Activités"),
        "dashboard_air_temp":
            MessageLookupByLibrary.simpleMessage("Température"),
        "dashboard_calendar":
            MessageLookupByLibrary.simpleMessage("Calendrier"),
        "dashboard_garden_create_error": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la création du jardin."),
        "dashboard_garden_created": m36,
        "dashboard_garden_n": m37,
        "dashboard_settings":
            MessageLookupByLibrary.simpleMessage("Paramètres"),
        "dashboard_soil_temp":
            MessageLookupByLibrary.simpleMessage("Temp. Sol"),
        "dashboard_statistics":
            MessageLookupByLibrary.simpleMessage("Statistiques"),
        "dashboard_weather": MessageLookupByLibrary.simpleMessage("Météo"),
        "dashboard_weather_stats":
            MessageLookupByLibrary.simpleMessage("Météo détaillée"),
        "dialog_cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "dialog_confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
        "empty_action_create": MessageLookupByLibrary.simpleMessage("Créer"),
        "error_page_back":
            MessageLookupByLibrary.simpleMessage("Retour à l\'accueil"),
        "error_page_message": m38,
        "error_page_title":
            MessageLookupByLibrary.simpleMessage("Page non trouvée"),
        "export_action_generate":
            MessageLookupByLibrary.simpleMessage("Générer Export Excel"),
        "export_activity_type_bed_created":
            MessageLookupByLibrary.simpleMessage("Création de parcelle"),
        "export_activity_type_bed_deleted":
            MessageLookupByLibrary.simpleMessage("Suppression de parcelle"),
        "export_activity_type_bed_updated":
            MessageLookupByLibrary.simpleMessage("Mise à jour de parcelle"),
        "export_activity_type_error":
            MessageLookupByLibrary.simpleMessage("Erreur"),
        "export_activity_type_garden_created":
            MessageLookupByLibrary.simpleMessage("Création de jardin"),
        "export_activity_type_garden_deleted":
            MessageLookupByLibrary.simpleMessage("Suppression de jardin"),
        "export_activity_type_garden_updated":
            MessageLookupByLibrary.simpleMessage("Mise à jour du jardin"),
        "export_activity_type_harvest":
            MessageLookupByLibrary.simpleMessage("Récolte"),
        "export_activity_type_maintenance":
            MessageLookupByLibrary.simpleMessage("Entretien"),
        "export_activity_type_planting_created":
            MessageLookupByLibrary.simpleMessage("Nouvelle plantation"),
        "export_activity_type_planting_deleted":
            MessageLookupByLibrary.simpleMessage("Suppression plantation"),
        "export_activity_type_planting_updated":
            MessageLookupByLibrary.simpleMessage("Mise à jour plantation"),
        "export_activity_type_weather":
            MessageLookupByLibrary.simpleMessage("Météo"),
        "export_block_activity":
            MessageLookupByLibrary.simpleMessage("Activités (Journal)"),
        "export_block_desc_activity": MessageLookupByLibrary.simpleMessage(
            "Historique complet des interventions et événements"),
        "export_block_desc_garden": MessageLookupByLibrary.simpleMessage(
            "Métadonnées des jardins sélectionnés"),
        "export_block_desc_garden_bed": MessageLookupByLibrary.simpleMessage(
            "Détails des parcelles (surface, orientation...)"),
        "export_block_desc_harvest": MessageLookupByLibrary.simpleMessage(
            "Données de production et rendements"),
        "export_block_desc_plant":
            MessageLookupByLibrary.simpleMessage("Liste des plantes utilisées"),
        "export_block_garden":
            MessageLookupByLibrary.simpleMessage("Jardins (Structure)"),
        "export_block_garden_bed":
            MessageLookupByLibrary.simpleMessage("Parcelles (Structure)"),
        "export_block_harvest":
            MessageLookupByLibrary.simpleMessage("Récoltes (Production)"),
        "export_block_plant":
            MessageLookupByLibrary.simpleMessage("Plantes (Catalogue)"),
        "export_blocks_section":
            MessageLookupByLibrary.simpleMessage("2. Données à inclure"),
        "export_builder_title":
            MessageLookupByLibrary.simpleMessage("Générateur d\'Export"),
        "export_columns_count": m39,
        "export_columns_section":
            MessageLookupByLibrary.simpleMessage("3. Détails & Colonnes"),
        "export_error_snack": m40,
        "export_excel_total": MessageLookupByLibrary.simpleMessage("TOTAL"),
        "export_excel_unknown": MessageLookupByLibrary.simpleMessage("Inconnu"),
        "export_field_activity_date":
            MessageLookupByLibrary.simpleMessage("Date"),
        "export_field_activity_desc":
            MessageLookupByLibrary.simpleMessage("Description"),
        "export_field_activity_entity":
            MessageLookupByLibrary.simpleMessage("Entité Cible"),
        "export_field_activity_entity_id":
            MessageLookupByLibrary.simpleMessage("ID Cible"),
        "export_field_activity_title":
            MessageLookupByLibrary.simpleMessage("Titre"),
        "export_field_activity_type":
            MessageLookupByLibrary.simpleMessage("Type"),
        "export_field_advanced_suffix":
            MessageLookupByLibrary.simpleMessage(" (Avancé)"),
        "export_field_bed_id":
            MessageLookupByLibrary.simpleMessage("ID Parcelle"),
        "export_field_bed_name":
            MessageLookupByLibrary.simpleMessage("Nom parcelle"),
        "export_field_bed_plant_count":
            MessageLookupByLibrary.simpleMessage("Nb Plantes"),
        "export_field_bed_surface":
            MessageLookupByLibrary.simpleMessage("Surface (m²)"),
        "export_field_desc_activity_date":
            MessageLookupByLibrary.simpleMessage("Date de l\'activité"),
        "export_field_desc_activity_desc":
            MessageLookupByLibrary.simpleMessage("Détails complets"),
        "export_field_desc_activity_entity":
            MessageLookupByLibrary.simpleMessage(
                "Nom de l\'objet concerné (Plante, Parcelle...)"),
        "export_field_desc_activity_entity_id":
            MessageLookupByLibrary.simpleMessage("ID de l\'objet concerné"),
        "export_field_desc_activity_title":
            MessageLookupByLibrary.simpleMessage("Résumé de l\'action"),
        "export_field_desc_activity_type": MessageLookupByLibrary.simpleMessage(
            "Catégorie d\'action (Semis, Récolte, Soin...)"),
        "export_field_desc_bed_id": MessageLookupByLibrary.simpleMessage(
            "Identifiant unique technique"),
        "export_field_desc_bed_name":
            MessageLookupByLibrary.simpleMessage("Nom de la parcelle"),
        "export_field_desc_bed_plant_count":
            MessageLookupByLibrary.simpleMessage(
                "Nombre de cultures en place (actuel)"),
        "export_field_desc_bed_surface":
            MessageLookupByLibrary.simpleMessage("Surface de la parcelle"),
        "export_field_desc_garden_creation":
            MessageLookupByLibrary.simpleMessage(
                "Date de création dans l\'application"),
        "export_field_desc_garden_id": MessageLookupByLibrary.simpleMessage(
            "Identifiant unique technique"),
        "export_field_desc_garden_name":
            MessageLookupByLibrary.simpleMessage("Nom donné au jardin"),
        "export_field_desc_garden_surface":
            MessageLookupByLibrary.simpleMessage("Surface totale du jardin"),
        "export_field_desc_harvest_bed_id":
            MessageLookupByLibrary.simpleMessage("Identifiant parcelle"),
        "export_field_desc_harvest_bed_name":
            MessageLookupByLibrary.simpleMessage(
                "Parcelle d\'origine (si disponible)"),
        "export_field_desc_harvest_date": MessageLookupByLibrary.simpleMessage(
            "Date de l\'événement de récolte"),
        "export_field_desc_harvest_garden_id":
            MessageLookupByLibrary.simpleMessage(
                "Identifiant unique du jardin"),
        "export_field_desc_harvest_garden_name":
            MessageLookupByLibrary.simpleMessage(
                "Nom du jardin d\'origine (si disponible)"),
        "export_field_desc_harvest_notes": MessageLookupByLibrary.simpleMessage(
            "Observations saisies lors de la récolte"),
        "export_field_desc_harvest_plant_name":
            MessageLookupByLibrary.simpleMessage("Nom de la plante récoltée"),
        "export_field_desc_harvest_price":
            MessageLookupByLibrary.simpleMessage("Prix au kg configuré"),
        "export_field_desc_harvest_qty":
            MessageLookupByLibrary.simpleMessage("Poids récolté en kg"),
        "export_field_desc_harvest_value":
            MessageLookupByLibrary.simpleMessage("Quantité * Prix/kg"),
        "export_field_desc_plant_family":
            MessageLookupByLibrary.simpleMessage("Famille botanique"),
        "export_field_desc_plant_id": MessageLookupByLibrary.simpleMessage(
            "Identifiant unique technique"),
        "export_field_desc_plant_name":
            MessageLookupByLibrary.simpleMessage("Nom usuel de la plante"),
        "export_field_desc_plant_scientific":
            MessageLookupByLibrary.simpleMessage("Dénomination botanique"),
        "export_field_desc_plant_variety":
            MessageLookupByLibrary.simpleMessage("Variété spécifique"),
        "export_field_garden_creation":
            MessageLookupByLibrary.simpleMessage("Date création"),
        "export_field_garden_id":
            MessageLookupByLibrary.simpleMessage("ID Jardin"),
        "export_field_garden_name":
            MessageLookupByLibrary.simpleMessage("Nom du jardin"),
        "export_field_garden_surface":
            MessageLookupByLibrary.simpleMessage("Surface (m²)"),
        "export_field_harvest_bed_id":
            MessageLookupByLibrary.simpleMessage("ID Parcelle"),
        "export_field_harvest_bed_name":
            MessageLookupByLibrary.simpleMessage("Parcelle"),
        "export_field_harvest_date":
            MessageLookupByLibrary.simpleMessage("Date Récolte"),
        "export_field_harvest_garden_id":
            MessageLookupByLibrary.simpleMessage("ID Jardin"),
        "export_field_harvest_garden_name":
            MessageLookupByLibrary.simpleMessage("Jardin"),
        "export_field_harvest_notes":
            MessageLookupByLibrary.simpleMessage("Notes"),
        "export_field_harvest_plant_name":
            MessageLookupByLibrary.simpleMessage("Plante"),
        "export_field_harvest_price":
            MessageLookupByLibrary.simpleMessage("Prix/kg"),
        "export_field_harvest_qty":
            MessageLookupByLibrary.simpleMessage("Quantité (kg)"),
        "export_field_harvest_value":
            MessageLookupByLibrary.simpleMessage("Valeur Totale"),
        "export_field_plant_family":
            MessageLookupByLibrary.simpleMessage("Famille"),
        "export_field_plant_id":
            MessageLookupByLibrary.simpleMessage("ID Plante"),
        "export_field_plant_name":
            MessageLookupByLibrary.simpleMessage("Nom commun"),
        "export_field_plant_scientific":
            MessageLookupByLibrary.simpleMessage("Nom scientifique"),
        "export_field_plant_variety":
            MessageLookupByLibrary.simpleMessage("Variété"),
        "export_filter_garden_all":
            MessageLookupByLibrary.simpleMessage("Tous les jardins"),
        "export_filter_garden_count": m41,
        "export_filter_garden_edit":
            MessageLookupByLibrary.simpleMessage("Modifier la sélection"),
        "export_filter_garden_select_dialog_title":
            MessageLookupByLibrary.simpleMessage("Sélectionner les jardins"),
        "export_filter_garden_title":
            MessageLookupByLibrary.simpleMessage("Filtrer par Jardin"),
        "export_format_flat":
            MessageLookupByLibrary.simpleMessage("Table Unique (Flat / BI)"),
        "export_format_flat_subtitle": MessageLookupByLibrary.simpleMessage(
            "Une seule grande table pour Tableaux Croisés Dynamiques"),
        "export_format_section":
            MessageLookupByLibrary.simpleMessage("4. Format du fichier"),
        "export_format_separate": MessageLookupByLibrary.simpleMessage(
            "Feuilles séparées (Standard)"),
        "export_format_separate_subtitle": MessageLookupByLibrary.simpleMessage(
            "Une feuille par type de donnée (Recommandé)"),
        "export_generating":
            MessageLookupByLibrary.simpleMessage("Génération en cours..."),
        "export_scope_period": MessageLookupByLibrary.simpleMessage("Période"),
        "export_scope_period_all":
            MessageLookupByLibrary.simpleMessage("Tout l\'historique"),
        "export_scope_section":
            MessageLookupByLibrary.simpleMessage("1. Périmètre"),
        "export_success_share_text": MessageLookupByLibrary.simpleMessage(
            "Voici votre export PermaCalendar"),
        "export_success_title":
            MessageLookupByLibrary.simpleMessage("Export terminé"),
        "garden_action_archive":
            MessageLookupByLibrary.simpleMessage("Archiver"),
        "garden_action_delete":
            MessageLookupByLibrary.simpleMessage("Supprimer"),
        "garden_action_disable":
            MessageLookupByLibrary.simpleMessage("Désactiver"),
        "garden_action_edit": MessageLookupByLibrary.simpleMessage("Modifier"),
        "garden_action_enable": MessageLookupByLibrary.simpleMessage("Activer"),
        "garden_action_modify":
            MessageLookupByLibrary.simpleMessage("Modifier"),
        "garden_action_unarchive":
            MessageLookupByLibrary.simpleMessage("Désarchiver"),
        "garden_add_tooltip":
            MessageLookupByLibrary.simpleMessage("Ajouter un jardin"),
        "garden_archived_info": MessageLookupByLibrary.simpleMessage(
            "Vous avez des jardins archivés. Activez l’affichage des jardins archivés pour les voir."),
        "garden_bed_delete_confirm_body": m42,
        "garden_bed_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Supprimer la parcelle"),
        "garden_bed_delete_error": m43,
        "garden_bed_deleted_snack":
            MessageLookupByLibrary.simpleMessage("Parcelle supprimée"),
        "garden_created_at": m44,
        "garden_detail_subtitle_error_beds": m45,
        "garden_detail_subtitle_not_found":
            MessageLookupByLibrary.simpleMessage(
                "Le jardin demandé n\'existe pas ou a été supprimé."),
        "garden_detail_title_error":
            MessageLookupByLibrary.simpleMessage("Erreur"),
        "garden_error_subtitle": m46,
        "garden_error_title":
            MessageLookupByLibrary.simpleMessage("Erreur de chargement"),
        "garden_list_title":
            MessageLookupByLibrary.simpleMessage("Mes jardins"),
        "garden_management_add_bed_label":
            MessageLookupByLibrary.simpleMessage("Créer une parcelle"),
        "garden_management_archived_tag":
            MessageLookupByLibrary.simpleMessage("Jardin archivé"),
        "garden_management_beds_title":
            MessageLookupByLibrary.simpleMessage("Parcelles"),
        "garden_management_create_error": MessageLookupByLibrary.simpleMessage(
            "Échec de la création du jardin"),
        "garden_management_create_submit":
            MessageLookupByLibrary.simpleMessage("Créer le jardin"),
        "garden_management_create_submitting":
            MessageLookupByLibrary.simpleMessage("Création..."),
        "garden_management_create_title":
            MessageLookupByLibrary.simpleMessage("Créer un jardin"),
        "garden_management_created_success":
            MessageLookupByLibrary.simpleMessage("Jardin créé avec succès"),
        "garden_management_delete_confirm_body":
            MessageLookupByLibrary.simpleMessage(
                "Êtes-vous sûr de vouloir supprimer ce jardin ? Cette action supprimera également toutes les parcelles et plantations associées. Cette action est irréversible."),
        "garden_management_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Supprimer le jardin"),
        "garden_management_delete_success":
            MessageLookupByLibrary.simpleMessage("Jardin supprimé avec succès"),
        "garden_management_desc_label":
            MessageLookupByLibrary.simpleMessage("Description"),
        "garden_management_edit_title":
            MessageLookupByLibrary.simpleMessage("Modifier le jardin"),
        "garden_management_image_label":
            MessageLookupByLibrary.simpleMessage("Image du jardin (optionnel)"),
        "garden_management_image_preview_error":
            MessageLookupByLibrary.simpleMessage(
                "Impossible de charger l\'image"),
        "garden_management_image_url_label":
            MessageLookupByLibrary.simpleMessage("URL de l\'image"),
        "garden_management_name_label":
            MessageLookupByLibrary.simpleMessage("Nom du jardin"),
        "garden_management_no_beds_desc": MessageLookupByLibrary.simpleMessage(
            "Créez des parcelles pour organiser vos plantations"),
        "garden_management_no_beds_title":
            MessageLookupByLibrary.simpleMessage("Aucune parcelle"),
        "garden_management_stats_area":
            MessageLookupByLibrary.simpleMessage("Surface totale"),
        "garden_management_stats_beds":
            MessageLookupByLibrary.simpleMessage("Parcelles"),
        "garden_no_gardens": MessageLookupByLibrary.simpleMessage(
            "Aucun jardin pour le moment."),
        "garden_retry": MessageLookupByLibrary.simpleMessage("Réessayer"),
        "harvest_action_save":
            MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "harvest_form_error_positive":
            MessageLookupByLibrary.simpleMessage("Invalide (> 0)"),
        "harvest_form_error_positive_or_zero":
            MessageLookupByLibrary.simpleMessage("Invalide (>= 0)"),
        "harvest_form_error_required":
            MessageLookupByLibrary.simpleMessage("Requis"),
        "harvest_notes_label":
            MessageLookupByLibrary.simpleMessage("Notes / Qualité"),
        "harvest_price_helper": MessageLookupByLibrary.simpleMessage(
            "Sera mémorisé pour les prochaines récoltes de cette plante"),
        "harvest_price_label":
            MessageLookupByLibrary.simpleMessage("Prix estimé (€/kg)"),
        "harvest_snack_error": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'enregistrement"),
        "harvest_snack_saved":
            MessageLookupByLibrary.simpleMessage("Récolte enregistrée"),
        "harvest_title": m47,
        "harvest_weight_label":
            MessageLookupByLibrary.simpleMessage("Poids récolté (kg) *"),
        "history_hint_action":
            MessageLookupByLibrary.simpleMessage("Aller au tableau de bord"),
        "history_hint_body": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez-le par un appui long depuis le tableau de bord."),
        "history_hint_title": MessageLookupByLibrary.simpleMessage(
            "Pour consulter l’historique d’un jardin"),
        "home_settings_fallback_label":
            MessageLookupByLibrary.simpleMessage("Paramètres (repli)"),
        "info_exposure_full_sun":
            MessageLookupByLibrary.simpleMessage("Plein soleil"),
        "info_exposure_partial_sun":
            MessageLookupByLibrary.simpleMessage("Mi-ombre"),
        "info_exposure_shade": MessageLookupByLibrary.simpleMessage("Ombre"),
        "info_season_all": MessageLookupByLibrary.simpleMessage("Toute saison"),
        "info_season_autumn": MessageLookupByLibrary.simpleMessage("Automne"),
        "info_season_spring": MessageLookupByLibrary.simpleMessage("Printemps"),
        "info_season_summer": MessageLookupByLibrary.simpleMessage("Été"),
        "info_season_winter": MessageLookupByLibrary.simpleMessage("Hiver"),
        "info_water_high": MessageLookupByLibrary.simpleMessage("Élevé"),
        "info_water_low": MessageLookupByLibrary.simpleMessage("Faible"),
        "info_water_medium": MessageLookupByLibrary.simpleMessage("Moyen"),
        "info_water_moderate": MessageLookupByLibrary.simpleMessage("Modéré"),
        "kpi_alignment_aligned": MessageLookupByLibrary.simpleMessage("aligné"),
        "kpi_alignment_aligned_actions":
            MessageLookupByLibrary.simpleMessage("Alignées"),
        "kpi_alignment_calculating":
            MessageLookupByLibrary.simpleMessage("Calcul de l\'alignement..."),
        "kpi_alignment_cta": MessageLookupByLibrary.simpleMessage(
            "Commence à planter et récolter pour voir ton alignement !"),
        "kpi_alignment_description": MessageLookupByLibrary.simpleMessage(
            "Cet outil évalue à quel point tu réalises tes semis, plantations et récoltes dans la fenêtre idéale recommandée par l\'Agenda Intelligent."),
        "kpi_alignment_error":
            MessageLookupByLibrary.simpleMessage("Erreur lors du calcul"),
        "kpi_alignment_misaligned_actions":
            MessageLookupByLibrary.simpleMessage("Décalées"),
        "kpi_alignment_title":
            MessageLookupByLibrary.simpleMessage("Alignement au Vivant"),
        "kpi_alignment_total": MessageLookupByLibrary.simpleMessage("Total"),
        "language_changed_snackbar": m48,
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_french": MessageLookupByLibrary.simpleMessage("Français"),
        "language_german": MessageLookupByLibrary.simpleMessage("Deutsch"),
        "language_portuguese_br":
            MessageLookupByLibrary.simpleMessage("Português (Brasil)"),
        "language_spanish": MessageLookupByLibrary.simpleMessage("Español"),
        "language_title":
            MessageLookupByLibrary.simpleMessage("Langue / Language"),
        "lifecycle_cycle_completed":
            MessageLookupByLibrary.simpleMessage("du cycle complété"),
        "lifecycle_days_ago": m49,
        "lifecycle_error_prefix":
            MessageLookupByLibrary.simpleMessage("Erreur : "),
        "lifecycle_error_title": MessageLookupByLibrary.simpleMessage(
            "Erreur lors du calcul du cycle de vie"),
        "lifecycle_harvest_expected":
            MessageLookupByLibrary.simpleMessage("Récolte prévue"),
        "lifecycle_in_days": m50,
        "lifecycle_next_action":
            MessageLookupByLibrary.simpleMessage("Prochaine action"),
        "lifecycle_now": MessageLookupByLibrary.simpleMessage("Maintenant !"),
        "lifecycle_passed": MessageLookupByLibrary.simpleMessage("Passée"),
        "lifecycle_stage_fruiting":
            MessageLookupByLibrary.simpleMessage("Fructification"),
        "lifecycle_stage_germination":
            MessageLookupByLibrary.simpleMessage("Germination"),
        "lifecycle_stage_growth":
            MessageLookupByLibrary.simpleMessage("Croissance"),
        "lifecycle_stage_harvest":
            MessageLookupByLibrary.simpleMessage("Récolte"),
        "lifecycle_stage_unknown":
            MessageLookupByLibrary.simpleMessage("Inconnu"),
        "lifecycle_update":
            MessageLookupByLibrary.simpleMessage("Mettre à jour le cycle"),
        "moon_phase_first_quarter":
            MessageLookupByLibrary.simpleMessage("Premier Quartier"),
        "moon_phase_full": MessageLookupByLibrary.simpleMessage("Pleine Lune"),
        "moon_phase_last_quarter":
            MessageLookupByLibrary.simpleMessage("Dernier Quartier"),
        "moon_phase_new": MessageLookupByLibrary.simpleMessage("Nouvelle Lune"),
        "moon_phase_waning_crescent":
            MessageLookupByLibrary.simpleMessage("Dernier Croissant"),
        "moon_phase_waning_gibbous":
            MessageLookupByLibrary.simpleMessage("Gibbeuse Décroissante"),
        "moon_phase_waxing_crescent":
            MessageLookupByLibrary.simpleMessage("Premier Croissant"),
        "moon_phase_waxing_gibbous":
            MessageLookupByLibrary.simpleMessage("Gibbeuse Croissante"),
        "nut_calcium": MessageLookupByLibrary.simpleMessage("Calcium"),
        "nut_fiber": MessageLookupByLibrary.simpleMessage("Fibres"),
        "nut_iron": MessageLookupByLibrary.simpleMessage("Fer"),
        "nut_magnesium": MessageLookupByLibrary.simpleMessage("Magnésium"),
        "nut_manganese": MessageLookupByLibrary.simpleMessage("Manganèse"),
        "nut_potassium": MessageLookupByLibrary.simpleMessage("Potassium"),
        "nut_protein": MessageLookupByLibrary.simpleMessage("Protéines"),
        "nut_vitamin_c": MessageLookupByLibrary.simpleMessage("Vitamine C"),
        "nut_zinc": MessageLookupByLibrary.simpleMessage("Zinc"),
        "nutrition_dominant_production":
            MessageLookupByLibrary.simpleMessage("Production dominante :"),
        "nutrition_major_minerals_title": MessageLookupByLibrary.simpleMessage(
            "Structure & Minéraux Majeurs"),
        "nutrition_month_dynamics_title": m51,
        "nutrition_no_data_period": MessageLookupByLibrary.simpleMessage(
            "Pas de données cette période"),
        "nutrition_no_harvest_month":
            MessageLookupByLibrary.simpleMessage("Aucune récolte en ce mois"),
        "nutrition_no_major_minerals":
            MessageLookupByLibrary.simpleMessage("Aucun minéral majeur"),
        "nutrition_no_trace_elements":
            MessageLookupByLibrary.simpleMessage("Aucun oligo-élément"),
        "nutrition_nutrients_origin": MessageLookupByLibrary.simpleMessage(
            "Ces nutriments proviennent de vos récoltes du mois."),
        "nutrition_page_title":
            MessageLookupByLibrary.simpleMessage("Signature Nutritionnelle"),
        "nutrition_seasonal_dynamics_desc": MessageLookupByLibrary.simpleMessage(
            "Explorez la production minérale et vitaminique de votre jardin, mois par mois."),
        "nutrition_seasonal_dynamics_title":
            MessageLookupByLibrary.simpleMessage("Dynamique Saisonnière"),
        "nutrition_trace_elements_title":
            MessageLookupByLibrary.simpleMessage("Vitalité & Oligo-éléments"),
        "pillar_economy_label":
            MessageLookupByLibrary.simpleMessage("Valeur totale des récoltes"),
        "pillar_economy_title":
            MessageLookupByLibrary.simpleMessage("Économie du jardin"),
        "pillar_export_button":
            MessageLookupByLibrary.simpleMessage("Exporter"),
        "pillar_export_label":
            MessageLookupByLibrary.simpleMessage("Récupérez vos données"),
        "pillar_export_title": MessageLookupByLibrary.simpleMessage("Export"),
        "pillar_nutrition_label":
            MessageLookupByLibrary.simpleMessage("Signature Nutritionnelle"),
        "pillar_nutrition_title":
            MessageLookupByLibrary.simpleMessage("Équilibre Nutritionnel"),
        "plant_added_favorites": m52,
        "plant_catalog_data_unknown":
            MessageLookupByLibrary.simpleMessage("Données inconnues"),
        "plant_catalog_expand_window":
            MessageLookupByLibrary.simpleMessage("Élargir (±2 mois)"),
        "plant_catalog_filter_all":
            MessageLookupByLibrary.simpleMessage("Tous"),
        "plant_catalog_filter_green_only":
            MessageLookupByLibrary.simpleMessage("Verts seulement"),
        "plant_catalog_filter_green_orange":
            MessageLookupByLibrary.simpleMessage("Verts + Oranges"),
        "plant_catalog_legend_green":
            MessageLookupByLibrary.simpleMessage("Prêt ce mois"),
        "plant_catalog_legend_orange":
            MessageLookupByLibrary.simpleMessage("Proche / Bientôt"),
        "plant_catalog_legend_red":
            MessageLookupByLibrary.simpleMessage("Hors saison"),
        "plant_catalog_missing_period_data":
            MessageLookupByLibrary.simpleMessage(
                "Données de période manquantes"),
        "plant_catalog_no_recommended": MessageLookupByLibrary.simpleMessage(
            "Aucune plante recommandée sur la période."),
        "plant_catalog_periods_prefix": m53,
        "plant_catalog_plant": MessageLookupByLibrary.simpleMessage("Planter"),
        "plant_catalog_search_hint":
            MessageLookupByLibrary.simpleMessage("Rechercher une plante..."),
        "plant_catalog_show_selection":
            MessageLookupByLibrary.simpleMessage("Afficher sélection"),
        "plant_catalog_sow": MessageLookupByLibrary.simpleMessage("Semer"),
        "plant_catalog_title":
            MessageLookupByLibrary.simpleMessage("Catalogue de plantes"),
        "plant_custom_badge": MessageLookupByLibrary.simpleMessage("Perso"),
        "plant_detail_add_to_garden_todo": MessageLookupByLibrary.simpleMessage(
            "Ajout au jardin à implémenter"),
        "plant_detail_detail_exposure":
            MessageLookupByLibrary.simpleMessage("Exposition"),
        "plant_detail_detail_family":
            MessageLookupByLibrary.simpleMessage("Famille"),
        "plant_detail_detail_maturity":
            MessageLookupByLibrary.simpleMessage("Durée de maturation"),
        "plant_detail_detail_spacing":
            MessageLookupByLibrary.simpleMessage("Espacement"),
        "plant_detail_detail_water":
            MessageLookupByLibrary.simpleMessage("Besoins en eau"),
        "plant_detail_not_found_body": MessageLookupByLibrary.simpleMessage(
            "Cette plante n\'existe pas ou n\'a pas pu être chargée."),
        "plant_detail_not_found_title":
            MessageLookupByLibrary.simpleMessage("Plante introuvable"),
        "plant_detail_popup_add_to_garden":
            MessageLookupByLibrary.simpleMessage("Ajouter au jardin"),
        "plant_detail_popup_share":
            MessageLookupByLibrary.simpleMessage("Partager"),
        "plant_detail_section_culture":
            MessageLookupByLibrary.simpleMessage("Détails de culture"),
        "plant_detail_section_instructions":
            MessageLookupByLibrary.simpleMessage("Instructions générales"),
        "plant_detail_share_todo":
            MessageLookupByLibrary.simpleMessage("Partage à implémenter"),
        "planting_add_tooltip":
            MessageLookupByLibrary.simpleMessage("Ajouter une plantation"),
        "planting_card_harvest_estimate": m54,
        "planting_card_planted_date": m55,
        "planting_card_sown_date": m56,
        "planting_clear_filters":
            MessageLookupByLibrary.simpleMessage("Effacer les filtres"),
        "planting_create_action":
            MessageLookupByLibrary.simpleMessage("Créer une plantation"),
        "planting_creation_title":
            MessageLookupByLibrary.simpleMessage("Nouvelle culture"),
        "planting_creation_title_edit":
            MessageLookupByLibrary.simpleMessage("Modifier la culture"),
        "planting_custom_plant_title":
            MessageLookupByLibrary.simpleMessage("Plante personnalisée"),
        "planting_date_future_error": MessageLookupByLibrary.simpleMessage(
            "La date de plantation ne peut pas être dans le futur"),
        "planting_delete_confirm_body": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer cette plantation ? Cette action est irréversible."),
        "planting_delete_title":
            MessageLookupByLibrary.simpleMessage("Supprimer la plantation"),
        "planting_detail_title":
            MessageLookupByLibrary.simpleMessage("Détails de la plantation"),
        "planting_empty_first": MessageLookupByLibrary.simpleMessage(
            "Commencez par ajouter votre première plantation dans cette parcelle."),
        "planting_empty_no_result":
            MessageLookupByLibrary.simpleMessage("Aucun résultat"),
        "planting_empty_none":
            MessageLookupByLibrary.simpleMessage("Aucune plantation"),
        "planting_filter_all_plants":
            MessageLookupByLibrary.simpleMessage("Toutes les plantes"),
        "planting_filter_all_statuses":
            MessageLookupByLibrary.simpleMessage("Tous les statuts"),
        "planting_history_action_planting":
            MessageLookupByLibrary.simpleMessage("Plantation"),
        "planting_history_title":
            MessageLookupByLibrary.simpleMessage("Historique des actions"),
        "planting_history_todo": MessageLookupByLibrary.simpleMessage(
            "L\'historique détaillé sera disponible prochainement"),
        "planting_info_cm": m57,
        "planting_info_culture_title":
            MessageLookupByLibrary.simpleMessage("Informations de culture"),
        "planting_info_days": m58,
        "planting_info_depth":
            MessageLookupByLibrary.simpleMessage("Profondeur"),
        "planting_info_exposure":
            MessageLookupByLibrary.simpleMessage("Exposition"),
        "planting_info_germination":
            MessageLookupByLibrary.simpleMessage("Temps de germination"),
        "planting_info_harvest_time":
            MessageLookupByLibrary.simpleMessage("Temps de récolte"),
        "planting_info_maturity":
            MessageLookupByLibrary.simpleMessage("Maturité"),
        "planting_info_none":
            MessageLookupByLibrary.simpleMessage("Non spécifié"),
        "planting_info_scientific_name_none":
            MessageLookupByLibrary.simpleMessage(
                "Nom scientifique non disponible"),
        "planting_info_season":
            MessageLookupByLibrary.simpleMessage("Saison plantation"),
        "planting_info_spacing":
            MessageLookupByLibrary.simpleMessage("Espacement"),
        "planting_info_tips_title":
            MessageLookupByLibrary.simpleMessage("Conseils de culture"),
        "planting_info_title":
            MessageLookupByLibrary.simpleMessage("Informations botaniques"),
        "planting_info_water": MessageLookupByLibrary.simpleMessage("Arrosage"),
        "planting_menu_ready_for_harvest":
            MessageLookupByLibrary.simpleMessage("Prêt à récolter"),
        "planting_menu_statistics":
            MessageLookupByLibrary.simpleMessage("Statistiques"),
        "planting_menu_test_data":
            MessageLookupByLibrary.simpleMessage("Données test"),
        "planting_no_plant_selected":
            MessageLookupByLibrary.simpleMessage("Aucune plante sélectionnée"),
        "planting_notes_hint": MessageLookupByLibrary.simpleMessage(
            "Informations supplémentaires..."),
        "planting_notes_label":
            MessageLookupByLibrary.simpleMessage("Notes (optionnel)"),
        "planting_plant_name_hint":
            MessageLookupByLibrary.simpleMessage("Ex: Tomate cerise"),
        "planting_plant_name_label":
            MessageLookupByLibrary.simpleMessage("Nom de la plante"),
        "planting_plant_name_required": MessageLookupByLibrary.simpleMessage(
            "Le nom de la plante est requis"),
        "planting_plant_selection_label": m59,
        "planting_quantity_plants":
            MessageLookupByLibrary.simpleMessage("Nombre de plants"),
        "planting_quantity_positive": MessageLookupByLibrary.simpleMessage(
            "La quantité doit être un nombre positif"),
        "planting_quantity_required":
            MessageLookupByLibrary.simpleMessage("La quantité est requise"),
        "planting_quantity_seeds":
            MessageLookupByLibrary.simpleMessage("Nombre de graines"),
        "planting_search_hint": MessageLookupByLibrary.simpleMessage(
            "Rechercher une plantation..."),
        "planting_stat_in_growth":
            MessageLookupByLibrary.simpleMessage("En croissance"),
        "planting_stat_plantings":
            MessageLookupByLibrary.simpleMessage("Plantations"),
        "planting_stat_ready_for_harvest":
            MessageLookupByLibrary.simpleMessage("Prêt à récolter"),
        "planting_stat_success_rate":
            MessageLookupByLibrary.simpleMessage("Taux de réussite"),
        "planting_stat_total_quantity":
            MessageLookupByLibrary.simpleMessage("Quantité totale"),
        "planting_status_failed":
            MessageLookupByLibrary.simpleMessage("Échoué"),
        "planting_status_growing":
            MessageLookupByLibrary.simpleMessage("En croissance"),
        "planting_status_harvested":
            MessageLookupByLibrary.simpleMessage("Récolté"),
        "planting_status_planted":
            MessageLookupByLibrary.simpleMessage("Planté"),
        "planting_status_ready":
            MessageLookupByLibrary.simpleMessage("Prêt à récolter"),
        "planting_status_sown": MessageLookupByLibrary.simpleMessage("Semé"),
        "planting_steps_add_button":
            MessageLookupByLibrary.simpleMessage("Ajouter"),
        "planting_steps_date_prefix": m60,
        "planting_steps_dialog_add":
            MessageLookupByLibrary.simpleMessage("Ajouter"),
        "planting_steps_dialog_hint":
            MessageLookupByLibrary.simpleMessage("Ex: Paillage léger"),
        "planting_steps_dialog_title":
            MessageLookupByLibrary.simpleMessage("Ajouter étape"),
        "planting_steps_done": MessageLookupByLibrary.simpleMessage("Fait"),
        "planting_steps_empty":
            MessageLookupByLibrary.simpleMessage("Aucune étape recommandée"),
        "planting_steps_mark_done":
            MessageLookupByLibrary.simpleMessage("Marquer fait"),
        "planting_steps_more": m61,
        "planting_steps_prediction_badge":
            MessageLookupByLibrary.simpleMessage("Prédiction"),
        "planting_steps_see_all":
            MessageLookupByLibrary.simpleMessage("Voir tout"),
        "planting_steps_see_less":
            MessageLookupByLibrary.simpleMessage("Voir moins"),
        "planting_steps_title":
            MessageLookupByLibrary.simpleMessage("Pas-à-pas"),
        "planting_success_create":
            MessageLookupByLibrary.simpleMessage("Culture créée avec succès"),
        "planting_success_update": MessageLookupByLibrary.simpleMessage(
            "Culture modifiée avec succès"),
        "planting_tips_catalog": MessageLookupByLibrary.simpleMessage(
            "• Utilisez le catalogue pour sélectionner une plante."),
        "planting_tips_none":
            MessageLookupByLibrary.simpleMessage("Aucun conseil disponible"),
        "planting_tips_notes": MessageLookupByLibrary.simpleMessage(
            "• Ajoutez des notes pour suivre les conditions spéciales."),
        "planting_tips_title": MessageLookupByLibrary.simpleMessage("Conseils"),
        "planting_tips_type": MessageLookupByLibrary.simpleMessage(
            "• Choisissez \"Semé\" pour les graines, \"Planté\" pour les plants."),
        "planting_title_template": m62,
        "privacy_policy_text": MessageLookupByLibrary.simpleMessage(
            "Sowing respecte pleinement votre vie privée.\n\n• Toutes les données sont stockées localement sur votre appareil\n• Aucune donnée personnelle n’est transmise à des tiers\n• Aucune information n’est stockée sur un serveur externe\n\nL’application fonctionne entièrement hors ligne. Une connexion Internet est uniquement utilisée pour récupérer les données météorologiques ou lors des exports."),
        "search_hint": MessageLookupByLibrary.simpleMessage("Rechercher..."),
        "settings_about": MessageLookupByLibrary.simpleMessage("À propos"),
        "settings_application":
            MessageLookupByLibrary.simpleMessage("Application"),
        "settings_backup_action":
            MessageLookupByLibrary.simpleMessage("Créer une sauvegarde"),
        "settings_backup_creating": MessageLookupByLibrary.simpleMessage(
            "Création de la sauvegarde en cours..."),
        "settings_backup_error": m73,
        "settings_backup_restore_section":
            MessageLookupByLibrary.simpleMessage("Sauvegarde et Restauration"),
        "settings_backup_restore_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Sauvegarde intégrale de vos données"),
        "settings_backup_success": MessageLookupByLibrary.simpleMessage(
            "Sauvegarde créée avec succès !"),
        "settings_choose_commune":
            MessageLookupByLibrary.simpleMessage("Choisir une commune"),
        "settings_commune_default": m63,
        "settings_commune_selected": m64,
        "settings_commune_title":
            MessageLookupByLibrary.simpleMessage("Commune pour la météo"),
        "settings_display": MessageLookupByLibrary.simpleMessage("Affichage"),
        "settings_plants_catalog":
            MessageLookupByLibrary.simpleMessage("Catalogue des plantes"),
        "settings_plants_catalog_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Rechercher et consulter les plantes"),
        "settings_privacy":
            MessageLookupByLibrary.simpleMessage("Confidentialité"),
        "settings_privacy_policy": MessageLookupByLibrary.simpleMessage(
            "Politique de confidentialité"),
        "settings_quick_access":
            MessageLookupByLibrary.simpleMessage("Accès rapide"),
        "settings_restore_action":
            MessageLookupByLibrary.simpleMessage("Restaurer une sauvegarde"),
        "settings_restore_error": m74,
        "settings_restore_success": MessageLookupByLibrary.simpleMessage(
            "Restauration réussie ! Veuillez redémarrer l\'application."),
        "settings_restore_warning_content": MessageLookupByLibrary.simpleMessage(
            "La restauration d\'une sauvegarde écrasera TOUTES les données actuelles (jardins, plantations, réglages). Cette action est irréversible. L\'application devra redémarrer.\n\nÊtes-vous sûr de vouloir continuer ?"),
        "settings_restore_warning_title":
            MessageLookupByLibrary.simpleMessage("Attention"),
        "settings_search_commune_hint":
            MessageLookupByLibrary.simpleMessage("Rechercher une commune…"),
        "settings_terms":
            MessageLookupByLibrary.simpleMessage("Conditions d\'utilisation"),
        "settings_title": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "settings_user_guide":
            MessageLookupByLibrary.simpleMessage("Guide d\'utilisation"),
        "settings_user_guide_subtitle":
            MessageLookupByLibrary.simpleMessage("Consulter la notice"),
        "settings_version": MessageLookupByLibrary.simpleMessage("Version"),
        "settings_version_dialog_content": m65,
        "settings_version_dialog_title":
            MessageLookupByLibrary.simpleMessage("Version de l\'application"),
        "settings_weather_selector":
            MessageLookupByLibrary.simpleMessage("Sélecteur météo"),
        "snackbar_commune_selected": m66,
        "soil_advice_status_ideal":
            MessageLookupByLibrary.simpleMessage("Optimal"),
        "soil_advice_status_sow_now":
            MessageLookupByLibrary.simpleMessage("Semer"),
        "soil_advice_status_sow_soon":
            MessageLookupByLibrary.simpleMessage("Bientôt"),
        "soil_advice_status_wait":
            MessageLookupByLibrary.simpleMessage("Attendre"),
        "soil_sheet_action_cancel":
            MessageLookupByLibrary.simpleMessage("Annuler"),
        "soil_sheet_action_save":
            MessageLookupByLibrary.simpleMessage("Sauvegarder"),
        "soil_sheet_input_error": MessageLookupByLibrary.simpleMessage(
            "Valeur invalide (-10.0 à 45.0)"),
        "soil_sheet_input_hint": MessageLookupByLibrary.simpleMessage("0.0"),
        "soil_sheet_input_label":
            MessageLookupByLibrary.simpleMessage("Température (°C)"),
        "soil_sheet_last_measure": m67,
        "soil_sheet_new_measure":
            MessageLookupByLibrary.simpleMessage("Nouvelle mesure (Ancrage)"),
        "soil_sheet_snack_error": m68,
        "soil_sheet_snack_invalid": MessageLookupByLibrary.simpleMessage(
            "Valeur invalide. Entrez -10.0 à 45.0"),
        "soil_sheet_snack_success": MessageLookupByLibrary.simpleMessage(
            "Mesure enregistrée comme ancrage"),
        "soil_sheet_title":
            MessageLookupByLibrary.simpleMessage("Température du sol"),
        "soil_temp_about_content": MessageLookupByLibrary.simpleMessage(
            "La température du sol affichée ici est estimée par l’application à partir de données climatiques et saisonnières, selon la formule suivante :\n\nCette estimation permet de donner une tendance réaliste de la température du sol lorsque aucune mesure directe n’est disponible."),
        "soil_temp_about_title": MessageLookupByLibrary.simpleMessage(
            "À propos de la température du sol"),
        "soil_temp_action_measure":
            MessageLookupByLibrary.simpleMessage("Modifier / Mesurer"),
        "soil_temp_advice_error": m69,
        "soil_temp_catalog_error": m70,
        "soil_temp_chart_error": m71,
        "soil_temp_current_label":
            MessageLookupByLibrary.simpleMessage("Température actuelle"),
        "soil_temp_db_empty": MessageLookupByLibrary.simpleMessage(
            "Base de données de plantes vide."),
        "soil_temp_formula_content": MessageLookupByLibrary.simpleMessage(
            "T_sol(n+1) = T_sol(n) + α × (T_air(n) − T_sol(n))\n\nAvec :\n• α : coefficient de diffusion thermique (valeur par défaut 0,15 — plage recommandée 0,10–0,20).\n• T_sol(n) : température du sol actuelle (°C).\n• T_air(n) : température de l’air actuelle (°C).\n\nLa formule est implémentée dans le code de l’application (ComputeSoilTempNextDayUsecase)."),
        "soil_temp_formula_label": MessageLookupByLibrary.simpleMessage(
            "Formule de calcul utilisée :"),
        "soil_temp_measure_hint": MessageLookupByLibrary.simpleMessage(
            "Vous pouvez renseigner manuellement la température du sol dans l’onglet “Modifier / Mesurer”."),
        "soil_temp_no_advice": MessageLookupByLibrary.simpleMessage(
            "Aucune plante avec données de germination trouvée."),
        "soil_temp_reload_plants":
            MessageLookupByLibrary.simpleMessage("Recharger les plantes"),
        "soil_temp_title":
            MessageLookupByLibrary.simpleMessage("Température du Sol"),
        "stats_annual_evolution_title":
            MessageLookupByLibrary.simpleMessage("Évolution Annuelle"),
        "stats_auto_summary_title":
            MessageLookupByLibrary.simpleMessage("Synthèse Automatique"),
        "stats_crop_distribution_others":
            MessageLookupByLibrary.simpleMessage("Autres"),
        "stats_crop_distribution_title":
            MessageLookupByLibrary.simpleMessage("Répartition par Culture"),
        "stats_dominant_culture_title":
            MessageLookupByLibrary.simpleMessage("Culture Dominante par Mois"),
        "stats_economy_no_harvest": MessageLookupByLibrary.simpleMessage(
            "Aucune récolte sur la période sélectionnée."),
        "stats_economy_no_harvest_desc": MessageLookupByLibrary.simpleMessage(
            "Aucune donnée sur la période sélectionnée."),
        "stats_economy_title":
            MessageLookupByLibrary.simpleMessage("Économie du Jardin"),
        "stats_key_months_title":
            MessageLookupByLibrary.simpleMessage("Mois Clés du Jardin"),
        "stats_kpi_avg_price":
            MessageLookupByLibrary.simpleMessage("Prix Moyen"),
        "stats_kpi_total_revenue":
            MessageLookupByLibrary.simpleMessage("Revenu Total"),
        "stats_kpi_total_volume":
            MessageLookupByLibrary.simpleMessage("Volume Total"),
        "stats_least_profitable":
            MessageLookupByLibrary.simpleMessage("Le moins rentable"),
        "stats_monthly_revenue_no_data":
            MessageLookupByLibrary.simpleMessage("Pas de données mensuelles"),
        "stats_monthly_revenue_title":
            MessageLookupByLibrary.simpleMessage("Revenu Mensuel"),
        "stats_most_profitable":
            MessageLookupByLibrary.simpleMessage("Le plus rentable"),
        "stats_profitability_cycle_title":
            MessageLookupByLibrary.simpleMessage("Cycle de Rentabilité"),
        "stats_revenue_history_title":
            MessageLookupByLibrary.simpleMessage("Historique du Revenu"),
        "stats_screen_subtitle": MessageLookupByLibrary.simpleMessage(
            "Analysez en temps réel et exportez vos données."),
        "stats_screen_title":
            MessageLookupByLibrary.simpleMessage("Statistiques"),
        "stats_table_crop": MessageLookupByLibrary.simpleMessage("Culture"),
        "stats_table_days": MessageLookupByLibrary.simpleMessage("Jours (Moy)"),
        "stats_table_revenue":
            MessageLookupByLibrary.simpleMessage("Rev/Récolte"),
        "stats_table_type": MessageLookupByLibrary.simpleMessage("Type"),
        "stats_top_cultures_no_data":
            MessageLookupByLibrary.simpleMessage("Aucune donnée"),
        "stats_top_cultures_percent_revenue":
            MessageLookupByLibrary.simpleMessage("du revenu"),
        "stats_top_cultures_title":
            MessageLookupByLibrary.simpleMessage("Top Cultures (Valeur)"),
        "stats_type_fast": MessageLookupByLibrary.simpleMessage("Rapide"),
        "stats_type_long_term":
            MessageLookupByLibrary.simpleMessage("Long terme"),
        "status_failed": MessageLookupByLibrary.simpleMessage("Échoué"),
        "status_growing": MessageLookupByLibrary.simpleMessage("En croissance"),
        "status_harvested": MessageLookupByLibrary.simpleMessage("Récolté"),
        "status_planted": MessageLookupByLibrary.simpleMessage("Planté"),
        "status_ready_to_harvest":
            MessageLookupByLibrary.simpleMessage("Prêt à récolter"),
        "status_sown": MessageLookupByLibrary.simpleMessage("Semé"),
        "task_editor_action_cancel":
            MessageLookupByLibrary.simpleMessage("Annuler"),
        "task_editor_action_create":
            MessageLookupByLibrary.simpleMessage("Créer"),
        "task_editor_action_save":
            MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "task_editor_assignee_add": m72,
        "task_editor_assignee_label":
            MessageLookupByLibrary.simpleMessage("Assigné à"),
        "task_editor_assignee_none":
            MessageLookupByLibrary.simpleMessage("Aucun résultat."),
        "task_editor_date_label":
            MessageLookupByLibrary.simpleMessage("Date de début"),
        "task_editor_description_label":
            MessageLookupByLibrary.simpleMessage("Description"),
        "task_editor_duration_label":
            MessageLookupByLibrary.simpleMessage("Durée estimée"),
        "task_editor_duration_other":
            MessageLookupByLibrary.simpleMessage("Autre"),
        "task_editor_error_title_required":
            MessageLookupByLibrary.simpleMessage("Requis"),
        "task_editor_export_label":
            MessageLookupByLibrary.simpleMessage("Sortie / Partage"),
        "task_editor_garden_all":
            MessageLookupByLibrary.simpleMessage("Tous les jardins"),
        "task_editor_option_docx":
            MessageLookupByLibrary.simpleMessage("Exporter — Word (.docx)"),
        "task_editor_option_none": MessageLookupByLibrary.simpleMessage(
            "Aucune (Sauvegarde uniquement)"),
        "task_editor_option_pdf":
            MessageLookupByLibrary.simpleMessage("Exporter — PDF"),
        "task_editor_option_share":
            MessageLookupByLibrary.simpleMessage("Partager (texte)"),
        "task_editor_photo_add":
            MessageLookupByLibrary.simpleMessage("Ajouter une photo"),
        "task_editor_photo_change":
            MessageLookupByLibrary.simpleMessage("Changer la photo"),
        "task_editor_photo_help": MessageLookupByLibrary.simpleMessage(
            "La photo sera jointe automatiquement au PDF / Word à la création / envoi."),
        "task_editor_photo_label":
            MessageLookupByLibrary.simpleMessage("Photo de la tâche"),
        "task_editor_photo_placeholder": MessageLookupByLibrary.simpleMessage(
            "Ajouter une photo (Bientôt disponible)"),
        "task_editor_photo_remove":
            MessageLookupByLibrary.simpleMessage("Retirer la photo"),
        "task_editor_priority_label":
            MessageLookupByLibrary.simpleMessage("Priorité"),
        "task_editor_recurrence_days_suffix":
            MessageLookupByLibrary.simpleMessage(" j"),
        "task_editor_recurrence_interval":
            MessageLookupByLibrary.simpleMessage("Tous les X jours"),
        "task_editor_recurrence_label":
            MessageLookupByLibrary.simpleMessage("Récurrence"),
        "task_editor_recurrence_monthly":
            MessageLookupByLibrary.simpleMessage("Mensuel (même jour)"),
        "task_editor_recurrence_none":
            MessageLookupByLibrary.simpleMessage("Aucune"),
        "task_editor_recurrence_repeat_label":
            MessageLookupByLibrary.simpleMessage("Répéter tous les "),
        "task_editor_recurrence_weekly":
            MessageLookupByLibrary.simpleMessage("Hebdomadaire (Jours)"),
        "task_editor_time_label": MessageLookupByLibrary.simpleMessage("Heure"),
        "task_editor_title_edit":
            MessageLookupByLibrary.simpleMessage("Modifier Tâche"),
        "task_editor_title_field":
            MessageLookupByLibrary.simpleMessage("Titre *"),
        "task_editor_title_new":
            MessageLookupByLibrary.simpleMessage("Nouvelle Tâche"),
        "task_editor_type_label":
            MessageLookupByLibrary.simpleMessage("Type de tâche"),
        "task_editor_urgent_label":
            MessageLookupByLibrary.simpleMessage("Urgent"),
        "task_editor_zone_empty": MessageLookupByLibrary.simpleMessage(
            "Aucune parcelle pour ce jardin"),
        "task_editor_zone_label":
            MessageLookupByLibrary.simpleMessage("Zone (Parcelle)"),
        "task_editor_zone_none":
            MessageLookupByLibrary.simpleMessage("Aucune zone spécifique"),
        "task_kind_amendment":
            MessageLookupByLibrary.simpleMessage("Amendement 🪵"),
        "task_kind_buy": MessageLookupByLibrary.simpleMessage("Achat 🛒"),
        "task_kind_clean": MessageLookupByLibrary.simpleMessage("Nettoyage 🧹"),
        "task_kind_generic": MessageLookupByLibrary.simpleMessage("Générique"),
        "task_kind_harvest": MessageLookupByLibrary.simpleMessage("Récolte 🧺"),
        "task_kind_pruning": MessageLookupByLibrary.simpleMessage("Taille ✂️"),
        "task_kind_repair":
            MessageLookupByLibrary.simpleMessage("Réparation 🛠️"),
        "task_kind_seeding": MessageLookupByLibrary.simpleMessage("Semis 🌱"),
        "task_kind_treatment":
            MessageLookupByLibrary.simpleMessage("Traitement 🧪"),
        "task_kind_watering":
            MessageLookupByLibrary.simpleMessage("Arrosage 💧"),
        "task_kind_weeding":
            MessageLookupByLibrary.simpleMessage("Désherbage 🌿"),
        "task_kind_winter_protection":
            MessageLookupByLibrary.simpleMessage("Hivernage ❄️"),
        "terms_text": MessageLookupByLibrary.simpleMessage(
            "En utilisant Sowing, vous acceptez :\n\n• D\'utiliser l\'application de manière responsable\n• De ne pas tenter de contourner ses limitations\n• De respecter les droits de propriété intellectuelle\n• D\'utiliser uniquement vos propres données\n\nCette application est fournie en l\'état, sans garantie.\n\nL’équipe Sowing reste à l’écoute pour toute amélioration ou évolution future."),
        "user_guide_text": MessageLookupByLibrary.simpleMessage(
            "1 — Bienvenue dans Sowing\nSowing est une application pensée pour accompagner les jardiniers et jardinières dans le suivi vivant et concret de leurs cultures.\nElle vous permet de :\n• organiser vos jardins et vos parcelles,\n• suivre vos plantations tout au long de leur cycle de vie,\n• planifier vos tâches au bon moment,\n• conserver la mémoire de ce qui a été fait,\n• prendre en compte la météo locale et le rythme des saisons.\nL’application fonctionne principalement hors ligne et conserve vos données directement sur votre appareil.\nCette notice décrit l’utilisation courante de Sowing : prise en main, création des jardins, plantations, calendrier, météo, export des données et bonnes pratiques.\n\n2 — Comprendre l’interface\nLe tableau de bord\nÀ l’ouverture, Sowing affiche un tableau de bord visuel et organique.\nIl se présente sous la forme d’une image de fond animée par des bulles interactives. Chaque bulle donne accès à une grande fonction de l’application :\n• jardins,\n• météo de l’air,\n• météo du sol,\n• calendrier,\n• activités,\n• statistiques,\n• paramètres.\nNavigation générale\nIl suffit de toucher une bulle pour ouvrir la section correspondante.\nÀ l’intérieur des pages, vous trouverez selon les contextes :\n• des menus contextuels,\n• des boutons « + » pour ajouter un élément,\n• des boutons d’édition ou de suppression.\n\n3 — Démarrage rapide\nOuvrir l’application\nAu lancement, le tableau de bord s’affiche automatiquement.\nConfigurer la météo\nDans les paramètres, choisissez votre commune.\nCette information permet à Sowing d’afficher une météo locale adaptée à votre jardin. Si aucune commune n’est sélectionnée, une localisation par défaut est utilisée.\nCréer votre premier jardin\nLors de la première utilisation, Sowing vous guide automatiquement pour créer votre premier jardin.\nVous pouvez également créer un jardin manuellement depuis le tableau de bord.\nSur l’écran principal, touchez la feuille verte située dans la zone la plus libre, à droite des statistiques et légèrement au‑dessus. Cette zone volontairement discrète permet d’initier la création d’un jardin.\nVous pouvez créer jusqu’à cinq jardins.\nCette approche fait partie de l’expérience Sowing : il n’existe pas de bouton « + » permanent et central. L’application invite plutôt à l’exploration et à la découverte progressive de l’espace.\nLes zones liées aux jardins sont également accessibles depuis le menu Paramètres.\nCalibration organique du tableau de bord\nUn mode de calibration organique permet :\n• de visualiser l’emplacement réel des zones interactives,\n• de les déplacer par simple glissement du doigt.\nVous pouvez ainsi positionner vos jardins et modules exactement où vous le souhaitez sur l’image : en haut, en bas ou à l’endroit qui vous convient le mieux.\nUne fois validée, cette organisation est enregistrée et conservée dans l’application.\nCréer une parcelle\nDans la fiche d’un jardin :\n• choisissez « Ajouter une parcelle »,\n• indiquez son nom, sa surface et, si besoin, quelques notes,\n• enregistrez.\nAjouter une plantation\nDans une parcelle :\n• appuyez sur le bouton « + »,\n• choisissez une plante dans le catalogue,\n• indiquez la date, la quantité et les informations utiles,\n• validez.\n\n4 — Le tableau de bord organique\nLe tableau de bord est le point central de Sowing.\nIl permet :\n• d’avoir une vue d’ensemble de votre activité,\n• d’accéder rapidement aux fonctions principales,\n• de naviguer de manière intuitive.\nSelon vos réglages, certaines bulles peuvent afficher des informations synthétiques, comme la météo ou les tâches à venir.\n\n5 — Jardins, parcelles et plantations\nLes jardins\nUn jardin représente un lieu réel : potager, serre, verger, balcon, etc.\nVous pouvez :\n• créer plusieurs jardins,\n• modifier leurs informations,\n• les supprimer si nécessaire.\nLes parcelles\nUne parcelle est une zone précise à l’intérieur d’un jardin.\nElle permet de structurer l’espace, d’organiser les cultures et de regrouper plusieurs plantations au même endroit.\nLes plantations\nUne plantation correspond à l’introduction d’une plante dans une parcelle, à une date donnée.\nLors de la création d’une plantation, Sowing propose deux modes.\nSemer\nLe mode « Semer » correspond à la mise en terre d’une graine.\nDans ce cas :\n• la progression démarre à 0 %,\n• un suivi pas à pas est proposé, particulièrement utile pour les jardiniers débutants,\n• une barre de progression visualise l’avancement du cycle de culture.\nCe suivi permet d’estimer :\n• le début probable de la période de récolte,\n• l’évolution de la culture dans le temps, de manière simple et visuelle.\nPlanter\nLe mode « Planter » est destiné aux plants déjà développés (plants issus d’une serre ou achetés en jardinerie).\nDans ce cas :\n• la plante démarre avec une progression d’environ 30 %,\n• le suivi est immédiatement plus avancé,\n• l’estimation de la période de récolte est ajustée en conséquence.\nChoix de la date\nLors de la plantation, vous pouvez choisir librement la date.\nCela permet par exemple :\n• de renseigner une plantation réalisée auparavant,\n• de corriger une date si l’application n’était pas utilisée au moment du semis ou de la plantation.\nPar défaut, la date du jour est utilisée.\nSuivi et historique\nChaque plantation dispose :\n• d’un suivi de progression,\n• d’informations sur son cycle de vie,\n• d’étapes de culture,\n• de notes personnelles.\nToutes les actions (semis, plantation, soins, récoltes) sont automatiquement enregistrées dans l’historique du jardin.\n\n6 — Catalogue de plantes\nLe catalogue regroupe l’ensemble des plantes disponibles lors de la création d’une plantation.\nIl constitue une base de référence évolutive, pensée pour couvrir les usages courants tout en restant personnalisable.\nFonctions principales :\n• recherche simple et rapide,\n• reconnaissance des noms courants et scientifiques,\n• affichage de photos lorsque disponibles.\nPlantes personnalisées\nVous pouvez créer vos propres plantes personnalisées depuis :\nParamètres → Catalogue de plantes.\nIl est alors possible de :\n• créer une nouvelle plante,\n• renseigner les paramètres essentiels (nom, type, informations utiles),\n• ajouter une image pour faciliter l’identification.\nLes plantes personnalisées sont ensuite utilisables comme n’importe quelle autre plante du catalogue.\n\n7 — Calendrier et tâches\nLa vue calendrier\nLe calendrier affiche :\n• les tâches prévues,\n• les plantations importantes,\n• les périodes de récolte estimées.\nCréer une tâche\nDepuis le calendrier :\n• créez une nouvelle tâche,\n• indiquez un titre, une date et une description,\n• choisissez une éventuelle récurrence.\nLes tâches peuvent être associées à un jardin ou à une parcelle.\nGestion des tâches\nVous pouvez :\n• modifier une tâche,\n• la supprimer,\n• l’exporter pour la partager.\n\n8 — Activités et historique\nCette section constitue la mémoire vivante de vos jardins.\nSélection d’un jardin\nDepuis le tableau de bord, effectuez un appui long sur un jardin pour le sélectionner.\nLe jardin actif est mis en évidence par une légère auréole verte et un bandeau de confirmation.\nCette sélection permet de filtrer les informations affichées.\nActivités récentes\nL’onglet « Activités » affiche chronologiquement :\n• créations,\n• plantations,\n• soins,\n• récoltes,\n• actions manuelles.\nHistorique par jardin\nL’onglet « Historique » présente l’historique complet du jardin sélectionné, année après année.\nIl permet notamment de :\n• retrouver les plantations passées,\n• vérifier si une plante a déjà été cultivée à un endroit donné,\n• mieux organiser la rotation des cultures.\n\n9 — Météo de l’air et météo du sol\nMétéo de l’air\nLa météo de l’air fournit les informations essentielles :\n• température extérieure,\n• précipitations (pluie, neige, absence de pluie),\n• alternance jour / nuit.\nCes données aident à anticiper les risques climatiques et à adapter les interventions.\nMétéo du sol\nSowing intègre un module de météo du sol.\nL’utilisateur peut renseigner une température mesurée. À partir de cette donnée, l’application estime dynamiquement l’évolution de la température du sol dans le temps.\nCette information permet :\n• de savoir quelles plantes sont réellement cultivables à un instant donné,\n• d’ajuster les semis aux conditions réelles plutôt qu’à un calendrier théorique.\nMétéo en temps réel sur le tableau de bord\nUn module central en forme d’ovoïde affiche en un coup d’œil :\n• l’état du ciel,\n• le jour ou la nuit,\n• la phase et la position de la lune pour la commune sélectionnée.\nNavigation dans le temps\nEn faisant glisser le doigt de gauche à droite sur l’ovoïde, vous parcourez les prévisions heure par heure, jusqu’à plus de 12 heures à l’avance.\nLa température et les précipitations s’ajustent dynamiquement pendant le geste.\n\n10 — Recommandations\nSowing peut proposer des recommandations adaptées à votre situation.\nElles s’appuient sur :\n• la saison,\n• la météo,\n• l’état de vos plantations.\nChaque recommandation précise :\n• quoi faire,\n• quand agir,\n• pourquoi l’action est suggérée.\n\n11 — Export et partage\nExport PDF — calendrier et tâches\nLes tâches du calendrier peuvent être exportées en PDF.\nCela permet de :\n• partager une information claire,\n• transmettre une intervention prévue,\n• conserver une trace lisible et datée.\nExport Excel — récoltes et statistiques\nLes données de récolte peuvent être exportées au format Excel afin de :\n• analyser les résultats,\n• produire des bilans,\n• suivre l’évolution dans le temps.\nPartage des documents\nLes documents générés peuvent être partagés via les applications disponibles sur votre appareil (messagerie, stockage, transfert vers un ordinateur, etc.).\n\n12 — Sauvegarde et bonnes pratiques\nLes données sont stockées localement sur votre appareil.\nBonnes pratiques recommandées :\n• effectuer une sauvegarde avant une mise à jour importante,\n• exporter régulièrement vos données,\n• maintenir l’application et l’appareil à jour.\n\n13 — Paramètres\nLe menu Paramètres permet d’adapter Sowing à vos usages.\nVous pouvez notamment :\n• choisir la langue,\n• sélectionner votre commune,\n• accéder au catalogue de plantes,\n• personnaliser le tableau de bord.\nPersonnalisation du tableau de bord\nIl est possible de :\n• repositionner chaque module,\n• ajuster l’espace visuel,\n• changer l’image de fond,\n• importer votre propre image (fonctionnalité à venir).\nInformations légales\nDepuis les paramètres, vous pouvez consulter :\n• le guide d’utilisation,\n• la politique de confidentialité,\n• les conditions d’utilisation.\n\n14 — Questions fréquentes\nLes zones tactiles ne sont pas bien alignées\nSelon le téléphone ou les réglages d’affichage, certaines zones peuvent sembler décalées.\nUn mode de calibration organique permet de :\n• visualiser les zones tactiles,\n• les repositionner par glissement,\n• enregistrer la configuration pour votre appareil.\nPuis‑je utiliser Sowing sans connexion ?\nOui. Sowing fonctionne hors ligne pour la gestion des jardins, plantations, tâches et historique.\nUne connexion est uniquement utilisée :\n• pour la récupération des données météo,\n• lors de l’export ou du partage de documents.\nAucune autre donnée n’est transmise.\n\n15 — Remarque finale\nSowing est conçu comme un compagnon de jardinage : simple, vivant et évolutif.\nPrenez le temps d’observer, de noter et de faire confiance à votre expérience autant qu’à l’outil."),
        "weather_action_retry":
            MessageLookupByLibrary.simpleMessage("Réessayer"),
        "weather_data_gusts": MessageLookupByLibrary.simpleMessage("Rafales"),
        "weather_data_max": MessageLookupByLibrary.simpleMessage("Max"),
        "weather_data_min": MessageLookupByLibrary.simpleMessage("Min"),
        "weather_data_rain": MessageLookupByLibrary.simpleMessage("Pluie"),
        "weather_data_speed": MessageLookupByLibrary.simpleMessage("Vitesse"),
        "weather_data_sunrise": MessageLookupByLibrary.simpleMessage("Lever"),
        "weather_data_sunset": MessageLookupByLibrary.simpleMessage("Coucher"),
        "weather_data_wind_max":
            MessageLookupByLibrary.simpleMessage("Vent Max"),
        "weather_error_loading": MessageLookupByLibrary.simpleMessage(
            "Impossible de charger la météo"),
        "weather_header_daily_summary":
            MessageLookupByLibrary.simpleMessage("RÉSUMÉ JOUR"),
        "weather_header_next_24h":
            MessageLookupByLibrary.simpleMessage("PROCHAINES 24H"),
        "weather_header_precipitations":
            MessageLookupByLibrary.simpleMessage("PRÉCIPITATIONS (24h)"),
        "weather_label_astro": MessageLookupByLibrary.simpleMessage("ASTRES"),
        "weather_label_pressure":
            MessageLookupByLibrary.simpleMessage("PRESSION"),
        "weather_label_sun": MessageLookupByLibrary.simpleMessage("SOLEIL"),
        "weather_label_wind": MessageLookupByLibrary.simpleMessage("VENT"),
        "weather_pressure_high": MessageLookupByLibrary.simpleMessage("Haute"),
        "weather_pressure_low": MessageLookupByLibrary.simpleMessage("Basse"),
        "weather_provider_credit": MessageLookupByLibrary.simpleMessage(
            "Données fournies par Open-Meteo"),
        "weather_screen_title": MessageLookupByLibrary.simpleMessage("Météo"),
        "weather_today_label":
            MessageLookupByLibrary.simpleMessage("Aujourd\'hui"),
        "wmo_code_0": MessageLookupByLibrary.simpleMessage("Ciel clair"),
        "wmo_code_1":
            MessageLookupByLibrary.simpleMessage("Principalement clair"),
        "wmo_code_2":
            MessageLookupByLibrary.simpleMessage("Partiellement nuageux"),
        "wmo_code_3": MessageLookupByLibrary.simpleMessage("Couvert"),
        "wmo_code_45": MessageLookupByLibrary.simpleMessage("Brouillard"),
        "wmo_code_48":
            MessageLookupByLibrary.simpleMessage("Brouillard givrant"),
        "wmo_code_51": MessageLookupByLibrary.simpleMessage("Bruine légère"),
        "wmo_code_53": MessageLookupByLibrary.simpleMessage("Bruine modérée"),
        "wmo_code_55": MessageLookupByLibrary.simpleMessage("Bruine dense"),
        "wmo_code_61": MessageLookupByLibrary.simpleMessage("Pluie légère"),
        "wmo_code_63": MessageLookupByLibrary.simpleMessage("Pluie modérée"),
        "wmo_code_65": MessageLookupByLibrary.simpleMessage("Pluie forte"),
        "wmo_code_66":
            MessageLookupByLibrary.simpleMessage("Pluie verglaçante légère"),
        "wmo_code_67":
            MessageLookupByLibrary.simpleMessage("Pluie verglaçante forte"),
        "wmo_code_71":
            MessageLookupByLibrary.simpleMessage("Chute de neige légère"),
        "wmo_code_73":
            MessageLookupByLibrary.simpleMessage("Chute de neige modérée"),
        "wmo_code_75":
            MessageLookupByLibrary.simpleMessage("Chute de neige forte"),
        "wmo_code_77": MessageLookupByLibrary.simpleMessage("Grains de neige"),
        "wmo_code_80": MessageLookupByLibrary.simpleMessage("Averses légères"),
        "wmo_code_81": MessageLookupByLibrary.simpleMessage("Averses modérées"),
        "wmo_code_82":
            MessageLookupByLibrary.simpleMessage("Averses violentes"),
        "wmo_code_85":
            MessageLookupByLibrary.simpleMessage("Averses de neige légères"),
        "wmo_code_86":
            MessageLookupByLibrary.simpleMessage("Averses de neige fortes"),
        "wmo_code_95": MessageLookupByLibrary.simpleMessage("Orage"),
        "wmo_code_96":
            MessageLookupByLibrary.simpleMessage("Orage avec grêle légère"),
        "wmo_code_99":
            MessageLookupByLibrary.simpleMessage("Orage avec grêle forte"),
        "wmo_code_unknown":
            MessageLookupByLibrary.simpleMessage("Conditions variables")
      };
}
