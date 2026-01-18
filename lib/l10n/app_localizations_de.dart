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
  String get settings_plants_catalog_subtitle => 'Pflanzen suchen und anzeigen';

  @override
  String get settings_about => 'Über';

  @override
  String get settings_user_guide => 'Benutzerhandbuch';

  @override
  String get settings_user_guide_subtitle => 'Handbuch lesen';

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
  String get calibration_title => 'Kalibrierung';

  @override
  String get calibration_subtitle =>
      'Passen Sie die Anzeige Ihres Dashboards an';

  @override
  String get calibration_organic_title => 'Organische Kalibrierung';

  @override
  String get calibration_organic_subtitle =>
      'Einheitlicher Modus: Bild, Himmel, Module';

  @override
  String get calibration_organic_disabled =>
      '🌿 Organische Kalibrierung deaktiviert';

  @override
  String get calibration_organic_enabled =>
      '🌿 Organischer Kalibrierungsmodus aktiviert. Wählen Sie einen der drei Tabs.';

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

  @override
  String get user_guide_text =>
      '1 — Willkommen bei Sowing\n(Übersetzung läuft...)\nSowing ist eine Anwendung, die Gärtner bei der lebendigen und konkreten Überwachung ihrer Kulturen unterstützt.\n...';

  @override
  String get privacy_policy_text =>
      'Sowing respektiert Ihre Privatsphäre voll und ganz.\n\n• Alle Daten werden lokal auf Ihrem Gerät gespeichert\n• Es werden keine persönlichen Daten an Dritte übermittelt\n• Es werden keine Informationen auf einem externen Server gespeichert\n\nDie Anwendung funktioniert vollständig offline. Eine Internetverbindung wird nur zum Abrufen von Wetterdaten oder beim Export verwendet.';

  @override
  String get terms_text =>
      'Durch die Nutzung von Sowing stimmen Sie zu:\n\n• Die Anwendung verantwortungsvoll zu nutzen\n• Nicht zu versuchen, ihre Einschränkungen zu umgehen\n• Die geistigen Eigentumsrechte zu respektieren\n• Nur Ihre eigenen Daten zu verwenden\n\nDiese Anwendung wird ohne Mängelgewähr bereitgestellt.\n\nDas Sowing-Team bleibt offen für zukünftige Verbesserungen oder Entwicklungen.';

  @override
  String get calibration_auto_apply => 'Automatically apply for this device';

  @override
  String get calibration_calibrate_now => 'Calibrate now';

  @override
  String get calibration_save_profile => 'Save current calibration as profile';

  @override
  String get calibration_export_profile => 'Export profile (JSON copy)';

  @override
  String get calibration_import_profile => 'Import profile from clipboard';

  @override
  String get calibration_reset_profile => 'Reset profile for this device';

  @override
  String get calibration_refresh_profile => 'Refresh profile preview';

  @override
  String calibration_key_device(String key) {
    return 'Device key: $key';
  }

  @override
  String get calibration_no_profile => 'No profile saved for this device.';

  @override
  String get calibration_image_settings_title =>
      'Background Image Settings (Persistent)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image => 'Reset Image Defaults';

  @override
  String get calibration_dialog_confirm_title => 'Confirm';

  @override
  String get calibration_dialog_delete_profile =>
      'Delete calibration profile for this device?';

  @override
  String get calibration_action_delete => 'Delete';

  @override
  String get calibration_snack_no_profile =>
      'No profile found for this device.';

  @override
  String get calibration_snack_profile_copied => 'Profile copied to clipboard.';

  @override
  String get calibration_snack_clipboard_empty => 'Clipboard empty.';

  @override
  String get calibration_snack_profile_imported =>
      'Profile imported and saved for this device.';

  @override
  String calibration_snack_import_error(String error) {
    return 'JSON import error: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Profile deleted for this device.';

  @override
  String get calibration_snack_no_calibration =>
      'No calibration saved. Calibrate from dashboard first.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Current calibration saved as profile for this device.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Error while saving: $error';
  }

  @override
  String get calibration_overlay_saved => 'Calibration saved';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Calibration save error: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Drag to move, pinch to zoom the background image.';

  @override
  String get calibration_instruction_sky =>
      'Adjust the day/night ovoid (center, size, rotation).';

  @override
  String get calibration_instruction_modules =>
      'Move the modules (bubbles) to the desired location.';

  @override
  String get calibration_instruction_none => 'Select a tool to start.';

  @override
  String get calibration_tool_image => 'Image';

  @override
  String get calibration_tool_sky => 'Sky';

  @override
  String get calibration_tool_modules => 'Modules';

  @override
  String get calibration_action_validate_exit => 'Validate & Exit';

  @override
  String get dashboard_weather_stats => 'Weather Details';

  @override
  String get dashboard_soil_temp => 'Soil Temp';

  @override
  String get dashboard_air_temp => 'Temperature';

  @override
  String get dashboard_statistics => 'Statistics';

  @override
  String get dashboard_calendar => 'Calendar';

  @override
  String get dashboard_activities => 'Activities';

  @override
  String get dashboard_weather => 'Weather';

  @override
  String get dashboard_settings => 'Settings';

  @override
  String dashboard_garden_n(int number) {
    return 'Garden $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Garden \"$name\" created successfully';
  }

  @override
  String get dashboard_garden_create_error => 'Error creating garden.';

  @override
  String get calendar_title => 'Growing Calendar';

  @override
  String get calendar_refreshed => 'Calendar refreshed';

  @override
  String get calendar_new_task_tooltip => 'New Task';

  @override
  String get calendar_task_saved_title => 'Task saved';

  @override
  String get calendar_ask_export_pdf => 'Do you want to send it as PDF?';

  @override
  String get calendar_task_modified => 'Task modified';

  @override
  String get calendar_delete_confirm_title => 'Delete task?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" will be deleted.';
  }

  @override
  String get calendar_task_deleted => 'Task deleted';

  @override
  String calendar_restore_error(Object error) {
    return 'Restore error: $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Delete error: $error';
  }

  @override
  String get calendar_action_assign => 'Send / Assign to...';

  @override
  String get calendar_assign_title => 'Assign / Send';

  @override
  String get calendar_assign_hint => 'Enter name or email';

  @override
  String get calendar_assign_field => 'Name or Email';

  @override
  String calendar_task_assigned(String name) {
    return 'Task assigned to $name';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Assignment error: $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'PDF Export error: $error';
  }

  @override
  String get calendar_previous_month => 'Previous month';

  @override
  String get calendar_next_month => 'Next month';

  @override
  String get calendar_limit_reached => 'Limit reached';

  @override
  String get calendar_drag_instruction => 'Swipe to navigate';

  @override
  String get common_refresh => 'Refresh';

  @override
  String get common_yes => 'Yes';

  @override
  String get common_no => 'No';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_undo => 'Undo';

  @override
  String common_error_prefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get common_retry => 'Retry';

  @override
  String get common_general_error => 'An error occurred';

  @override
  String get calendar_no_events => 'No events today';

  @override
  String calendar_events_of(String date) {
    return 'Events of $date';
  }

  @override
  String get calendar_section_plantings => 'Plantings';

  @override
  String get calendar_section_harvests => 'Expected harvests';

  @override
  String get calendar_section_tasks => 'Scheduled tasks';

  @override
  String get calendar_filter_tasks => 'Tasks';

  @override
  String get calendar_filter_maintenance => 'Maintenance';

  @override
  String get calendar_filter_harvests => 'Harvests';

  @override
  String get calendar_filter_urgent => 'Urgent';

  @override
  String get common_error => 'Error';

  @override
  String get task_editor_title_new => 'New Task';

  @override
  String get task_editor_title_edit => 'Edit Task';

  @override
  String get task_editor_title_field => 'Title *';

  @override
  String get task_editor_error_title_required => 'Required';

  @override
  String get task_editor_garden_all => 'All Gardens';

  @override
  String get task_editor_zone_label => 'Zone (Bed)';

  @override
  String get task_editor_zone_none => 'No specific zone';

  @override
  String get task_editor_zone_empty => 'No beds for this garden';

  @override
  String get task_editor_description_label => 'Description';

  @override
  String get task_editor_date_label => 'Start Date';

  @override
  String get task_editor_time_label => 'Time';

  @override
  String get task_editor_duration_label => 'Estimated Duration';

  @override
  String get task_editor_duration_other => 'Other';

  @override
  String get task_editor_type_label => 'Task Type';

  @override
  String get task_editor_priority_label => 'Priority';

  @override
  String get task_editor_urgent_label => 'Urgent';

  @override
  String get task_editor_option_none => 'None (Save Only)';

  @override
  String get task_editor_option_share => 'Share (Text)';

  @override
  String get task_editor_option_pdf => 'Export — PDF';

  @override
  String get task_editor_option_docx => 'Export — Word (.docx)';

  @override
  String get task_editor_export_label => 'Output / Share';

  @override
  String get task_editor_photo_placeholder => 'Add Photo (Coming Soon)';

  @override
  String get task_editor_action_create => 'Create';

  @override
  String get task_editor_action_save => 'Save';

  @override
  String get task_editor_action_cancel => 'Cancel';

  @override
  String get task_editor_assignee_label => 'Assigned to';

  @override
  String task_editor_assignee_add(String name) {
    return 'Add \"$name\" to favorites';
  }

  @override
  String get task_editor_assignee_none => 'No results.';

  @override
  String get task_editor_recurrence_label => 'Recurrence';

  @override
  String get task_editor_recurrence_none => 'None';

  @override
  String get task_editor_recurrence_interval => 'Every X days';

  @override
  String get task_editor_recurrence_weekly => 'Weekly (Days)';

  @override
  String get task_editor_recurrence_monthly => 'Monthly (same day)';

  @override
  String get task_editor_recurrence_repeat_label => 'Repeat every ';

  @override
  String get task_editor_recurrence_days_suffix => ' d';

  @override
  String get task_kind_generic => 'Generic';

  @override
  String get task_kind_repair => 'Repair 🛠️';

  @override
  String get task_kind_buy => 'Buy 🛒';

  @override
  String get task_kind_clean => 'Clean 🧹';

  @override
  String get task_kind_watering => 'Watering 💧';

  @override
  String get task_kind_seeding => 'Seeding 🌱';

  @override
  String get task_kind_pruning => 'Pruning ✂️';

  @override
  String get task_kind_weeding => 'Weeding 🌿';

  @override
  String get task_kind_amendment => 'Amendment 🪵';

  @override
  String get task_kind_treatment => 'Treatment 🧪';

  @override
  String get task_kind_harvest => 'Harvest 🧺';

  @override
  String get task_kind_winter_protection => 'Winter Protection ❄️';
}
