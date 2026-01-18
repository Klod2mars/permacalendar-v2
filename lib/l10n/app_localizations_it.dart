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
  String get settings_about => 'Info';

  @override
  String get settings_user_guide => 'Guida utente';

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
}
