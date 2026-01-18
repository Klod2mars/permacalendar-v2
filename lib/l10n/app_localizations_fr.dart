// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sowing';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get home_settings_fallback_label => 'Paramètres (repli)';

  @override
  String get settings_application => 'Application';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_display => 'Affichage';

  @override
  String get settings_weather_selector => 'Sélecteur météo';

  @override
  String get settings_commune_title => 'Commune pour la météo';

  @override
  String get settings_choose_commune => 'Choisir une commune';

  @override
  String get settings_search_commune_hint => 'Rechercher une commune…';

  @override
  String settings_commune_default(String label) {
    return 'Défaut: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Sélectionnée: $label';
  }

  @override
  String get settings_quick_access => 'Accès rapide';

  @override
  String get settings_plants_catalog => 'Catalogue des plantes';

  @override
  String get settings_about => 'À propos';

  @override
  String get settings_user_guide => 'Guide d\'utilisation';

  @override
  String get settings_privacy => 'Confidentialité';

  @override
  String get settings_privacy_policy => 'Politique de confidentialité';

  @override
  String get settings_terms => 'Conditions d\'utilisation';

  @override
  String get settings_version_dialog_title => 'Version de l\'application';

  @override
  String settings_version_dialog_content(String version) {
    return 'Version: $version – Gestion de jardin dynamique\n\nPermaculturo - Gestion de jardins vivants';
  }

  @override
  String get language_title => 'Langue / Language';

  @override
  String get language_french => 'Français';

  @override
  String get language_english => 'English';

  @override
  String get language_spanish => 'Español';

  @override
  String get language_portuguese_br => 'Português (Brasil)';

  @override
  String get language_german => 'Deutsch';

  @override
  String language_changed_snackbar(String label) {
    return 'Langue changée : $label';
  }

  @override
  String get garden_list_title => 'Mes jardins';

  @override
  String get garden_error_title => 'Erreur de chargement';

  @override
  String garden_error_subtitle(String error) {
    return 'Impossible de charger la liste des jardins : $error';
  }

  @override
  String get garden_retry => 'Réessayer';

  @override
  String get garden_no_gardens => 'Aucun jardin pour le moment.';

  @override
  String get garden_archived_info =>
      'Vous avez des jardins archivés. Activez l’affichage des jardins archivés pour les voir.';

  @override
  String get garden_add_tooltip => 'Ajouter un jardin';

  @override
  String get plant_catalog_title => 'Catalogue de plantes';

  @override
  String get plant_custom_badge => 'Perso';

  @override
  String get plant_detail_not_found_title => 'Plante introuvable';

  @override
  String get plant_detail_not_found_body =>
      'Cette plante n\'existe pas ou n\'a pas pu être chargée.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant ajouté aux favoris';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Ajouter au jardin';

  @override
  String get plant_detail_popup_share => 'Partager';

  @override
  String get plant_detail_share_todo => 'Partage à implémenter';

  @override
  String get plant_detail_add_to_garden_todo => 'Ajout au jardin à implémenter';

  @override
  String get plant_detail_section_culture => 'Détails de culture';

  @override
  String get plant_detail_section_instructions => 'Instructions générales';

  @override
  String get plant_detail_detail_family => 'Famille';

  @override
  String get plant_detail_detail_maturity => 'Durée de maturation';

  @override
  String get plant_detail_detail_spacing => 'Espacement';

  @override
  String get plant_detail_detail_exposure => 'Exposition';

  @override
  String get plant_detail_detail_water => 'Besoins en eau';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Plantations - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Statistiques';

  @override
  String get planting_menu_ready_for_harvest => 'Prêt à récolter';

  @override
  String get planting_menu_test_data => 'Données test';

  @override
  String get planting_search_hint => 'Rechercher une plantation...';

  @override
  String get planting_filter_all_statuses => 'Tous les statuts';

  @override
  String get planting_filter_all_plants => 'Toutes les plantes';

  @override
  String get planting_stat_plantings => 'Plantations';

  @override
  String get planting_stat_total_quantity => 'Quantité totale';

  @override
  String get planting_stat_success_rate => 'Taux de réussite';

  @override
  String get planting_stat_in_growth => 'En croissance';

  @override
  String get planting_stat_ready_for_harvest => 'Prêt à récolter';

  @override
  String get planting_empty_none => 'Aucune plantation';

  @override
  String get planting_empty_first =>
      'Commencez par ajouter votre première plantation dans cette parcelle.';

  @override
  String get planting_create_action => 'Créer une plantation';

  @override
  String get planting_empty_no_result => 'Aucun résultat';

  @override
  String get planting_clear_filters => 'Effacer les filtres';

  @override
  String get planting_add_tooltip => 'Ajouter une plantation';

  @override
  String get search_hint => 'Rechercher...';

  @override
  String get error_page_title => 'Page non trouvée';

  @override
  String error_page_message(String uri) {
    return 'La page \"$uri\" n\'existe pas.';
  }

  @override
  String get error_page_back => 'Retour à l\'accueil';

  @override
  String get dialog_confirm => 'Confirmer';

  @override
  String get dialog_cancel => 'Annuler';

  @override
  String snackbar_commune_selected(String name) {
    return 'Commune sélectionnée: $name';
  }

  @override
  String get common_validate => 'Valider';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get empty_action_create => 'Créer';
}
