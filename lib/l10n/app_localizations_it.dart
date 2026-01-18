// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Sowing';

  @override
  String get settings_title => 'Impostazioni';

  @override
  String get home_settings_fallback_label => 'Impostazioni (fallback)';

  @override
  String get settings_application => 'Applicazione';

  @override
  String get settings_version => 'Versione';

  @override
  String get settings_display => 'Visualizzazione';

  @override
  String get settings_weather_selector => 'Selettore meteo';

  @override
  String get settings_commune_title => 'Località per meteo';

  @override
  String get settings_choose_commune => 'Scegli una località';

  @override
  String get settings_search_commune_hint => 'Cerca una località...';

  @override
  String settings_commune_default(String label) {
    return 'Default: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Selezionata: $label';
  }

  @override
  String get settings_quick_access => 'Accesso rapido';

  @override
  String get settings_plants_catalog => 'Catalogo Piante';

  @override
  String get settings_plants_catalog_subtitle => 'Cerca e visualizza piante';

  @override
  String get settings_about => 'Info';

  @override
  String get settings_user_guide => 'Guida utente';

  @override
  String get settings_user_guide_subtitle => 'Consulta il manuale';

  @override
  String get settings_privacy => 'Privacy';

  @override
  String get settings_privacy_policy => 'Politica sulla riservatezza';

  @override
  String get settings_terms => 'Termini di utilizzo';

  @override
  String get settings_version_dialog_title => 'Versione App';

  @override
  String settings_version_dialog_content(String version) {
    return 'Versione: $version – Gestione dinamica del giardino\n\nSowing - Gestione giardini viventi';
  }

  @override
  String get language_title => 'Lingua / Language';

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
    return 'Lingua cambiata: $label';
  }

  @override
  String get calibration_title => 'Calibrazione';

  @override
  String get calibration_subtitle =>
      'Personalizza la visualizzazione della dashboard';

  @override
  String get calibration_organic_title => 'Calibrazione Organica';

  @override
  String get calibration_organic_subtitle =>
      'Modalità unificata: Immagine, Cielo, Moduli';

  @override
  String get calibration_organic_disabled =>
      '🌿 Calibrazione organica disattivata';

  @override
  String get calibration_organic_enabled =>
      '🌿 Modalità di calibrazione organica attivata. Seleziona una delle tre schede.';

  @override
  String get garden_list_title => 'I miei giardini';

  @override
  String get garden_error_title => 'Errore caricamento';

  @override
  String garden_error_subtitle(String error) {
    return 'Impossibile caricare la lista giardini: $error';
  }

  @override
  String get garden_retry => 'Riprova';

  @override
  String get garden_no_gardens => 'Nessun giardino per ora.';

  @override
  String get garden_archived_info =>
      'Hai giardini archiviati. Attiva visualizzazione giardini archiviati per vederli.';

  @override
  String get garden_add_tooltip => 'Aggiungi un giardino';

  @override
  String get plant_catalog_title => 'Catalogo Piante';

  @override
  String get plant_custom_badge => 'Perso';

  @override
  String get plant_detail_not_found_title => 'Pianta non trovata';

  @override
  String get plant_detail_not_found_body =>
      'Questa pianta non esiste o non può essere caricata.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant aggiunta ai preferiti';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Aggiungi al giardino';

  @override
  String get plant_detail_popup_share => 'Condividi';

  @override
  String get plant_detail_share_todo => 'Condivisione non implementata';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Aggiunta al giardino non implementata';

  @override
  String get plant_detail_section_culture => 'Dettagli coltura';

  @override
  String get plant_detail_section_instructions => 'Istruzioni generali';

  @override
  String get plant_detail_detail_family => 'Famiglia';

  @override
  String get plant_detail_detail_maturity => 'Durata maturazione';

  @override
  String get plant_detail_detail_spacing => 'Spaziatura';

  @override
  String get plant_detail_detail_exposure => 'Esposizione';

  @override
  String get plant_detail_detail_water => 'Bisogno d\'acqua';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Piantagioni - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Statistiche';

  @override
  String get planting_menu_ready_for_harvest => 'Pronto per raccolta';

  @override
  String get planting_menu_test_data => 'Dati test';

  @override
  String get planting_search_hint => 'Cerca piantagione...';

  @override
  String get planting_filter_all_statuses => 'Tutti gli stati';

  @override
  String get planting_filter_all_plants => 'Tutte le piante';

  @override
  String get planting_stat_plantings => 'Piantagioni';

  @override
  String get planting_stat_total_quantity => 'Quantità totale';

  @override
  String get planting_stat_success_rate => 'Tasso successo';

  @override
  String get planting_stat_in_growth => 'In crescita';

  @override
  String get planting_stat_ready_for_harvest => 'Pronto raccolta';

  @override
  String get planting_empty_none => 'Nessuna piantagione';

  @override
  String get planting_empty_first =>
      'Inizia aggiungendo la tua prima piantagione.';

  @override
  String get planting_create_action => 'Crea Piantagione';

  @override
  String get planting_empty_no_result => 'Nessun risultato';

  @override
  String get planting_clear_filters => 'Pulisci filtri';

  @override
  String get planting_add_tooltip => 'Aggiungi piantagione';

  @override
  String get search_hint => 'Cerca...';

  @override
  String get error_page_title => 'Pagina non trovata';

  @override
  String error_page_message(String uri) {
    return 'La pagina \"$uri\" non esiste.';
  }

  @override
  String get error_page_back => 'Torna alla Home';

  @override
  String get dialog_confirm => 'Conferma';

  @override
  String get dialog_cancel => 'Annulla';

  @override
  String snackbar_commune_selected(String name) {
    return 'Località selezionata: $name';
  }

  @override
  String get common_validate => 'Convalida';

  @override
  String get common_cancel => 'Annulla';

  @override
  String get empty_action_create => 'Crea';

  @override
  String get user_guide_text =>
      '1 — Benvenuto in Sowing\n(Traduzione in corso...)\nSowing è un\'applicazione progettata per supportare i giardinieri nel monitoraggio vivace e concreto delle loro colture.\n...';

  @override
  String get privacy_policy_text =>
      'Sowing rispetta pienamente la tua privacy.\n\n• Tutti i dati sono memorizzati localmente sul tuo dispositivo\n• Nessun dato personale viene trasmesso a terzi\n• Nessuna informazione viene memorizzata su un server esterno\n\nL\'applicazione funziona interamente offline. Una connessione Internet viene utilizzata solo per recuperare i dati meteorologici o durante le esportazioni.';

  @override
  String get terms_text =>
      'Utilizzando Sowing, accetti di:\n\n• Utilizzare l\'applicazione in modo responsabile\n• Non tentare di aggirare le sue limitazioni\n• Rispettare i diritti di proprietà intellettuale\n• Utilizzare solo i tuoi dati\n\nQuesta applicazione è fornita così com\'è, senza garanzia.\n\nIl team di Sowing rimane attento a qualsiasi miglioramento o evoluzione futura.';

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
  String get soil_temp_title => 'Soil Temperature';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Chart error: $error';
  }

  @override
  String get soil_temp_about_title => 'About Soil Temperature';

  @override
  String get soil_temp_about_content =>
      'The soil temperature displayed here is estimated by the application based on climatic and seasonal data, using a built-in calculation formula.\n\nThis estimation provides a realistic trend of soil temperature when no direct measurement is available.';

  @override
  String get soil_temp_formula_label => 'Calculation formula used:';

  @override
  String get soil_temp_formula_content =>
      'Soil Temperature = f(air temperature, season, soil inertia)\n(Exact formula defined in the application code)';

  @override
  String get soil_temp_current_label => 'Current Temperature';

  @override
  String get soil_temp_action_measure => 'Edit / Measure';

  @override
  String get soil_temp_measure_hint =>
      'You can manually enter the soil temperature in the \'Edit / Measure\' tab.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Catalog error: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Advice error: $error';
  }

  @override
  String get soil_temp_db_empty => 'Plant database is empty.';

  @override
  String get soil_temp_reload_plants => 'Reload plants';

  @override
  String get soil_temp_no_advice => 'No plants with germination data found.';

  @override
  String get soil_advice_status_ideal => 'Optimal';

  @override
  String get soil_advice_status_sow_now => 'Sow Now';

  @override
  String get soil_advice_status_sow_soon => 'Soon';

  @override
  String get soil_advice_status_wait => 'Wait';

  @override
  String get soil_sheet_title => 'Soil Temperature';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Last measure: $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'New measure (Anchor)';

  @override
  String get soil_sheet_input_label => 'Temperature (°C)';

  @override
  String get soil_sheet_input_error => 'Invalid value (-10.0 to 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Cancel';

  @override
  String get soil_sheet_action_save => 'Save';

  @override
  String get soil_sheet_snack_invalid => 'Invalid value. Enter -10.0 to 45.0';

  @override
  String get soil_sheet_snack_success => 'Measure saved as anchor';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Save error: $error';
  }

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
