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
}
