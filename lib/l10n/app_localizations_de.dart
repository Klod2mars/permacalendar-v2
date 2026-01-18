// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sowing';

  @override
  String get settings_title => 'Einstellungen';

  @override
  String get home_settings_fallback_label => 'Einstellungen (Fallback)';

  @override
  String get settings_application => 'Anwendung';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_display => 'Anzeige';

  @override
  String get settings_weather_selector => 'Wetters Wähler';

  @override
  String get settings_commune_title => 'Standort für Wetter';

  @override
  String get settings_choose_commune => 'Standort wählen';

  @override
  String get settings_search_commune_hint => 'Nach einem Ort suchen...';

  @override
  String settings_commune_default(String label) {
    return 'Standard: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Ausgewählt: $label';
  }

  @override
  String get settings_quick_access => 'Schnellzugriff';

  @override
  String get settings_plants_catalog => 'Pflanzenkatalog';

  @override
  String get settings_about => 'Über';

  @override
  String get settings_user_guide => 'Benutzerhandbuch';

  @override
  String get settings_privacy => 'Datenschutz';

  @override
  String get settings_privacy_policy => 'Datenschutzrichtlinie';

  @override
  String get settings_terms => 'Nutzungsbedingungen';

  @override
  String get settings_version_dialog_title => 'App-Version';

  @override
  String settings_version_dialog_content(String version) {
    return 'Version: $version – Dynamisches Gartenmanagement\n\nSowing - Lebendiges Gartenmanagement';
  }

  @override
  String get language_title => 'Sprache / Language';

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
    return 'Sprache geändert: $label';
  }

  @override
  String get garden_list_title => 'Meine Gärten';

  @override
  String get garden_error_title => 'Ladefehler';

  @override
  String garden_error_subtitle(String error) {
    return 'Gartenliste konnte nicht geladen werden: $error';
  }

  @override
  String get garden_retry => 'Wiederholen';

  @override
  String get garden_no_gardens => 'Noch keine Gärten.';

  @override
  String get garden_archived_info =>
      'Sie haben archivierte Gärten. Aktivieren Sie die Anzeige archivierter Gärten, um sie zu sehen.';

  @override
  String get garden_add_tooltip => 'Garten hinzufügen';

  @override
  String get plant_catalog_title => 'Pflanzenkatalog';

  @override
  String get plant_custom_badge => 'Benutzerdefiniert';

  @override
  String get plant_detail_not_found_title => 'Pflanze nicht gefunden';

  @override
  String get plant_detail_not_found_body =>
      'Diese Pflanze existiert nicht oder konnte nicht geladen werden.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant zu Favoriten hinzugefügt';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Zum Garten hinzufügen';

  @override
  String get plant_detail_popup_share => 'Teilen';

  @override
  String get plant_detail_share_todo => 'Teilen ist noch nicht implementiert';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Hinzufügen zum Garten noch nicht implementiert';

  @override
  String get plant_detail_section_culture => 'Kulturdetails';

  @override
  String get plant_detail_section_instructions => 'Allgemeine Anweisungen';

  @override
  String get plant_detail_detail_family => 'Familie';

  @override
  String get plant_detail_detail_maturity => 'Reifedauer';

  @override
  String get plant_detail_detail_spacing => 'Abstand';

  @override
  String get plant_detail_detail_exposure => 'Standort';

  @override
  String get plant_detail_detail_water => 'Wasserbedarf';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Pflanzungen - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Statistiken';

  @override
  String get planting_menu_ready_for_harvest => 'Erntebereit';

  @override
  String get planting_menu_test_data => 'Testdaten';

  @override
  String get planting_search_hint => 'Pflanzung suchen...';

  @override
  String get planting_filter_all_statuses => 'Alle Status';

  @override
  String get planting_filter_all_plants => 'Alle Pflanzen';

  @override
  String get planting_stat_plantings => 'Pflanzungen';

  @override
  String get planting_stat_total_quantity => 'Gesamtmenge';

  @override
  String get planting_stat_success_rate => 'Erfolgsrate';

  @override
  String get planting_stat_in_growth => 'Im Wachstum';

  @override
  String get planting_stat_ready_for_harvest => 'Erntebereit';

  @override
  String get planting_empty_none => 'Keine Pflanzungen';

  @override
  String get planting_empty_first =>
      'Fügen Sie Ihre erste Pflanzung in diesem Beet hinzu.';

  @override
  String get planting_create_action => 'Pflanzung erstellen';

  @override
  String get planting_empty_no_result => 'Kein Ergebnis';

  @override
  String get planting_clear_filters => 'Filter löschen';

  @override
  String get planting_add_tooltip => 'Pflanzung hinzufügen';

  @override
  String get search_hint => 'Suchen...';

  @override
  String get error_page_title => 'Seite nicht gefunden';

  @override
  String error_page_message(String uri) {
    return 'Die Seite \"$uri\" existiert nicht.';
  }

  @override
  String get error_page_back => 'Zurück zur Startseite';

  @override
  String get dialog_confirm => 'Bestätigen';

  @override
  String get dialog_cancel => 'Abbrechen';

  @override
  String snackbar_commune_selected(String name) {
    return 'Standort ausgewählt: $name';
  }

  @override
  String get common_validate => 'Bestätigen';

  @override
  String get common_cancel => 'Stornieren';

  @override
  String get empty_action_create => 'Erstellen';
}
