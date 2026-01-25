// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(name) => "Aiuola \"${name}\" creata";

  static String m1(name) => "Aiuola \"${name}\" eliminata";

  static String m2(name) => "Aiuola \"${name}\" aggiornata";

  static String m3(name) => "Giardino \"${name}\" creato";

  static String m4(name) => "Giardino \"${name}\" eliminato";

  static String m5(name) => "Giardino \"${name}\" aggiornato";

  static String m6(name) => "Germinazione di \"${name}\" confermata";

  static String m7(name) => "Raccolto di \"${name}\" registrato";

  static String m8(type) => "Manutenzione: ${type}";

  static String m9(name) => "Piantagione di \"${name}\" aggiunta";

  static String m10(name) => "Piantagione di \"${name}\" eliminata";

  static String m11(name) => "Piantagione di \"${name}\" aggiornata";

  static String m12(name) => "Aiuola: ${name}";

  static String m13(date) => "Data: ${date}";

  static String m14(name) => "Giardino: ${name}";

  static String m15(type) => "Manutenzione: ${type}";

  static String m16(name) => "Pianta: ${name}";

  static String m17(quantity) => "Quantità: ${quantity}";

  static String m18(weather) => "Meteo: ${weather}";

  static String m19(gardenName) => "Recente (${gardenName})";

  static String m20(count) => "${count} giorni fa";

  static String m21(hours) => "${hours} ore fa";

  static String m22(minutes) => "${minutes} min fa";

  static String m23(date) => "Seminato il ${date}";

  static String m24(error) => "Errore assegnazione: ${error}";

  static String m25(title) => "\"${title}\" verrà eliminata.";

  static String m26(error) => "Errore eliminazione: ${error}";

  static String m27(date) => "Eventi del ${date}";

  static String m28(error) => "Errore esportazione PDF: ${error}";

  static String m29(error) => "Errore ripristino: ${error}";

  static String m30(name) => "Attività assegnata a ${name}";

  static String m31(key) => "Chiave dispositivo: ${key}";

  static String m32(error) => "Errore salvataggio calibrazione: ${error}";

  static String m33(error) => "Errore importazione JSON: ${error}";

  static String m34(error) => "Errore durante il salvataggio: ${error}";

  static String m35(error) => "Errore: ${error}";

  static String m36(name) => "Giardino \"${name}\" creato con successo";

  static String m37(number) => "Giardino ${number}";

  static String m38(uri) => "La pagina \"${uri}\" non esiste.";

  static String m39(count) => "${count} colonne selezionate";

  static String m40(error) => "Errore: ${error}";

  static String m41(count) => "${count} giardino/i selezionato/i";

  static String m42(bedName) =>
      "Sei sicuro di voler eliminare \"${bedName}\"? Questa azione è irreversibile.";

  static String m43(error) => "Errore eliminazione aiuola: ${error}";

  static String m44(date) => "Creato il ${date}";

  static String m45(error) => "Impossibile caricare aiuole: ${error}";

  static String m46(error) =>
      "Impossibile caricare l\'elenco dei giardini: ${error}";

  static String m47(plantName) => "Raccolto: ${plantName}";

  static String m48(label) => "Lingua cambiata: ${label}";

  static String m49(days) => "${days} giorni fa";

  static String m50(days) => "Tra ${days} giorni";

  static String m51(month) => "Dinamiche di ${month}";

  static String m52(plant) => "${plant} aggiunta ai preferiti";

  static String m53(months) => "Periodi: ${months}";

  static String m54(date) => "Stima raccolto: ${date}";

  static String m55(date) => "Piantato il ${date}";

  static String m56(date) => "Seminato il ${date}";

  static String m57(cm) => "${cm} cm";

  static String m58(days) => "${days} giorni";

  static String m59(plantName) => "Pianta: ${plantName}";

  static String m60(date) => "Il ${date}";

  static String m61(count) => "+ ${count} altri passaggi";

  static String m62(gardenBedName) => "Piantagioni - ${gardenBedName}";

  static String m63(label) => "Predefinito: ${label}";

  static String m64(label) => "Selezionato: ${label}";

  static String m65(version) =>
      "Versione: ${version} – Gestione dinamica del giardino\n\nSowing - Gestione giardini viventi";

  static String m66(name) => "Posizione selezionata: ${name}";

  static String m67(temp, date) => "Ultima misura: ${temp}°C (${date})";

  static String m68(error) => "Errore salvataggio: ${error}";

  static String m69(error) => "Errore consiglio: ${error}";

  static String m70(error) => "Errore catalogo: ${error}";

  static String m71(error) => "Errore grafico: ${error}";

  static String m72(name) => "Aggiungi \"${name}\" ai preferiti";

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
            "Le attività di giardinaggio appariranno qui"),
        "activity_empty_title":
            MessageLookupByLibrary.simpleMessage("Nessuna attività trovata"),
        "activity_error_loading":
            MessageLookupByLibrary.simpleMessage("Errore caricamento attività"),
        "activity_history_empty": MessageLookupByLibrary.simpleMessage(
            "Nessun giardino selezionato.\nPer vedere la cronologia di un giardino, premi a lungo su di esso nella dashboard."),
        "activity_history_section_title":
            MessageLookupByLibrary.simpleMessage("Cronologia — "),
        "activity_metadata_bed": m12,
        "activity_metadata_date": m13,
        "activity_metadata_garden": m14,
        "activity_metadata_maintenance": m15,
        "activity_metadata_plant": m16,
        "activity_metadata_quantity": m17,
        "activity_metadata_weather": m18,
        "activity_priority_important":
            MessageLookupByLibrary.simpleMessage("Importante"),
        "activity_priority_normal":
            MessageLookupByLibrary.simpleMessage("Normale"),
        "activity_screen_title":
            MessageLookupByLibrary.simpleMessage("Attività e Cronologia"),
        "activity_tab_history":
            MessageLookupByLibrary.simpleMessage("Cronologia"),
        "activity_tab_recent_garden": m19,
        "activity_tab_recent_global":
            MessageLookupByLibrary.simpleMessage("Recente (Globale)"),
        "activity_time_days_ago": m20,
        "activity_time_hours_ago": m21,
        "activity_time_just_now":
            MessageLookupByLibrary.simpleMessage("Proprio ora"),
        "activity_time_minutes_ago": m22,
        "appTitle": MessageLookupByLibrary.simpleMessage("Sowing"),
        "bed_action_harvest": MessageLookupByLibrary.simpleMessage("Raccogli"),
        "bed_card_harvest_start":
            MessageLookupByLibrary.simpleMessage("inizio raccolto ca."),
        "bed_card_sown_on": m23,
        "bed_create_title_edit":
            MessageLookupByLibrary.simpleMessage("Modifica Aiuola"),
        "bed_create_title_new":
            MessageLookupByLibrary.simpleMessage("Nuova Aiuola"),
        "bed_delete_planting_confirm_body": MessageLookupByLibrary.simpleMessage(
            "Questa azione è irreversibile. Vuoi davvero eliminare questa piantagione?"),
        "bed_delete_planting_confirm_title":
            MessageLookupByLibrary.simpleMessage("Eliminare Piantagione?"),
        "bed_detail_add_planting":
            MessageLookupByLibrary.simpleMessage("Aggiungi Piantagione"),
        "bed_detail_current_plantings":
            MessageLookupByLibrary.simpleMessage("Piantagioni Attuali"),
        "bed_detail_details": MessageLookupByLibrary.simpleMessage("Dettagli"),
        "bed_detail_no_plantings_desc": MessageLookupByLibrary.simpleMessage(
            "Questa aiuola non ha ancora piantagioni."),
        "bed_detail_no_plantings_title":
            MessageLookupByLibrary.simpleMessage("Nessuna Piantagione"),
        "bed_detail_notes": MessageLookupByLibrary.simpleMessage("Note"),
        "bed_detail_surface": MessageLookupByLibrary.simpleMessage("Area"),
        "bed_form_desc_hint":
            MessageLookupByLibrary.simpleMessage("Descrizione..."),
        "bed_form_desc_label":
            MessageLookupByLibrary.simpleMessage("Descrizione"),
        "bed_form_error_name_length": MessageLookupByLibrary.simpleMessage(
            "Il nome deve essere lungo almeno 2 caratteri"),
        "bed_form_error_name_required":
            MessageLookupByLibrary.simpleMessage("Il nome è obbligatorio"),
        "bed_form_error_size_invalid":
            MessageLookupByLibrary.simpleMessage("Inserisci un\'area valida"),
        "bed_form_error_size_max": MessageLookupByLibrary.simpleMessage(
            "L\'area non può superare 1000 m²"),
        "bed_form_error_size_required":
            MessageLookupByLibrary.simpleMessage("L\'area è obbligatoria"),
        "bed_form_name_hint":
            MessageLookupByLibrary.simpleMessage("Es: Aiuola Nord, Parcela 1"),
        "bed_form_name_label":
            MessageLookupByLibrary.simpleMessage("Nome Aiuola *"),
        "bed_form_size_hint": MessageLookupByLibrary.simpleMessage("Es: 10.5"),
        "bed_form_size_label":
            MessageLookupByLibrary.simpleMessage("Area (m²) *"),
        "bed_form_submit_create": MessageLookupByLibrary.simpleMessage("Crea"),
        "bed_form_submit_edit": MessageLookupByLibrary.simpleMessage("Salva"),
        "bed_snack_created":
            MessageLookupByLibrary.simpleMessage("Aiuola creata con successo"),
        "bed_snack_updated": MessageLookupByLibrary.simpleMessage(
            "Aiuola aggiornata con successo"),
        "calendar_action_assign":
            MessageLookupByLibrary.simpleMessage("Invia / Assegna a..."),
        "calendar_ask_export_pdf":
            MessageLookupByLibrary.simpleMessage("Vuoi inviarlo come PDF?"),
        "calendar_assign_error": m24,
        "calendar_assign_field":
            MessageLookupByLibrary.simpleMessage("Nome o Email"),
        "calendar_assign_hint":
            MessageLookupByLibrary.simpleMessage("Inserisci nome o email"),
        "calendar_assign_title":
            MessageLookupByLibrary.simpleMessage("Assegna / Invia"),
        "calendar_delete_confirm_content": m25,
        "calendar_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Eliminare attività?"),
        "calendar_delete_error": m26,
        "calendar_drag_instruction":
            MessageLookupByLibrary.simpleMessage("Scorri per navigare"),
        "calendar_events_of": m27,
        "calendar_export_error": m28,
        "calendar_filter_harvests":
            MessageLookupByLibrary.simpleMessage("Raccolti"),
        "calendar_filter_maintenance":
            MessageLookupByLibrary.simpleMessage("Manutenzione"),
        "calendar_filter_tasks":
            MessageLookupByLibrary.simpleMessage("Attività"),
        "calendar_filter_urgent":
            MessageLookupByLibrary.simpleMessage("Urgente"),
        "calendar_limit_reached":
            MessageLookupByLibrary.simpleMessage("Limite raggiunto"),
        "calendar_new_task_tooltip":
            MessageLookupByLibrary.simpleMessage("Nuova Attività"),
        "calendar_next_month":
            MessageLookupByLibrary.simpleMessage("Mese successivo"),
        "calendar_no_events":
            MessageLookupByLibrary.simpleMessage("Nessun evento oggi"),
        "calendar_previous_month":
            MessageLookupByLibrary.simpleMessage("Mese precedente"),
        "calendar_refreshed":
            MessageLookupByLibrary.simpleMessage("Calendario aggiornato"),
        "calendar_restore_error": m29,
        "calendar_section_harvests":
            MessageLookupByLibrary.simpleMessage("Raccolti previsti"),
        "calendar_section_plantings":
            MessageLookupByLibrary.simpleMessage("Piantagioni"),
        "calendar_section_tasks":
            MessageLookupByLibrary.simpleMessage("Attività programmate"),
        "calendar_task_assigned": m30,
        "calendar_task_deleted":
            MessageLookupByLibrary.simpleMessage("Attività eliminata"),
        "calendar_task_modified":
            MessageLookupByLibrary.simpleMessage("Attività modificata"),
        "calendar_task_saved_title":
            MessageLookupByLibrary.simpleMessage("Attività salvata"),
        "calendar_title":
            MessageLookupByLibrary.simpleMessage("Calendario di coltivazione"),
        "calibration_action_delete":
            MessageLookupByLibrary.simpleMessage("Elimina"),
        "calibration_action_validate_exit":
            MessageLookupByLibrary.simpleMessage("Convalida ed Esci"),
        "calibration_auto_apply": MessageLookupByLibrary.simpleMessage(
            "Applica automaticamente per questo dispositivo"),
        "calibration_calibrate_now":
            MessageLookupByLibrary.simpleMessage("Calibra ora"),
        "calibration_dialog_confirm_title":
            MessageLookupByLibrary.simpleMessage("Conferma"),
        "calibration_dialog_delete_profile":
            MessageLookupByLibrary.simpleMessage(
                "Eliminare profilo di calibrazione per questo dispositivo?"),
        "calibration_export_profile": MessageLookupByLibrary.simpleMessage(
            "Esporta profilo (copia JSON)"),
        "calibration_image_settings_title":
            MessageLookupByLibrary.simpleMessage(
                "Impostazioni Immagine di Sfondo (Persistente)"),
        "calibration_import_profile": MessageLookupByLibrary.simpleMessage(
            "Importa profilo dagli appunti"),
        "calibration_instruction_image": MessageLookupByLibrary.simpleMessage(
            "Trascina per spostare, pizzica per zoomare l\'immagine di sfondo."),
        "calibration_instruction_modules": MessageLookupByLibrary.simpleMessage(
            "Sposta i moduli (bolle) nella posizione desiderata."),
        "calibration_instruction_none": MessageLookupByLibrary.simpleMessage(
            "Seleziona uno strumento per iniziare."),
        "calibration_instruction_sky": MessageLookupByLibrary.simpleMessage(
            "Regola l\'uovo giorno/notte (centro, dimensione, rotazione)."),
        "calibration_key_device": m31,
        "calibration_no_profile": MessageLookupByLibrary.simpleMessage(
            "Nessun profilo salvato per questo dispositivo."),
        "calibration_organic_disabled": MessageLookupByLibrary.simpleMessage(
            "🌿 Calibrazione organica disattivata"),
        "calibration_organic_enabled": MessageLookupByLibrary.simpleMessage(
            "🌿 Modalità di calibrazione organica attivata. Seleziona una delle tre schede."),
        "calibration_organic_subtitle": MessageLookupByLibrary.simpleMessage(
            "Modalità unificata: Immagine, Cielo, Moduli"),
        "calibration_organic_title":
            MessageLookupByLibrary.simpleMessage("Calibrazione Organica"),
        "calibration_overlay_error_save": m32,
        "calibration_overlay_saved":
            MessageLookupByLibrary.simpleMessage("Calibrazione salvata"),
        "calibration_pos_x": MessageLookupByLibrary.simpleMessage("Pos X"),
        "calibration_pos_y": MessageLookupByLibrary.simpleMessage("Pos Y"),
        "calibration_refresh_profile":
            MessageLookupByLibrary.simpleMessage("Aggiorna anteprima profilo"),
        "calibration_reset_image": MessageLookupByLibrary.simpleMessage(
            "Reimposta valori predefiniti immagine"),
        "calibration_reset_profile": MessageLookupByLibrary.simpleMessage(
            "Reimposta profilo per questo dispositivo"),
        "calibration_save_profile": MessageLookupByLibrary.simpleMessage(
            "Salva calibrazione attuale come profilo"),
        "calibration_snack_clipboard_empty":
            MessageLookupByLibrary.simpleMessage("Appunti vuoti."),
        "calibration_snack_import_error": m33,
        "calibration_snack_no_calibration":
            MessageLookupByLibrary.simpleMessage(
                "Nessuna calibrazione salvata. Calibra dalla dashboard prima."),
        "calibration_snack_no_profile": MessageLookupByLibrary.simpleMessage(
            "Nessun profilo trovato per questo dispositivo."),
        "calibration_snack_profile_copied":
            MessageLookupByLibrary.simpleMessage(
                "Profilo copiato negli appunti."),
        "calibration_snack_profile_deleted":
            MessageLookupByLibrary.simpleMessage(
                "Profilo eliminato per questo dispositivo."),
        "calibration_snack_profile_imported":
            MessageLookupByLibrary.simpleMessage(
                "Profilo importato e salvato per questo dispositivo."),
        "calibration_snack_save_error": m34,
        "calibration_snack_saved_as_profile": MessageLookupByLibrary.simpleMessage(
            "Calibrazione attuale salvata come profilo per questo dispositivo."),
        "calibration_subtitle": MessageLookupByLibrary.simpleMessage(
            "Personalizza la visualizzazione della tua dashboard"),
        "calibration_title":
            MessageLookupByLibrary.simpleMessage("Calibrazione"),
        "calibration_tool_image":
            MessageLookupByLibrary.simpleMessage("Immagine"),
        "calibration_tool_modules":
            MessageLookupByLibrary.simpleMessage("Moduli"),
        "calibration_tool_sky": MessageLookupByLibrary.simpleMessage("Cielo"),
        "calibration_zoom": MessageLookupByLibrary.simpleMessage("Zoom"),
        "common_back": MessageLookupByLibrary.simpleMessage("Indietro"),
        "common_cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "common_close": MessageLookupByLibrary.simpleMessage("Chiudi"),
        "common_delete": MessageLookupByLibrary.simpleMessage("Elimina"),
        "common_duplicate": MessageLookupByLibrary.simpleMessage("Duplica"),
        "common_edit": MessageLookupByLibrary.simpleMessage("Modifica"),
        "common_error": MessageLookupByLibrary.simpleMessage("Errore"),
        "common_error_prefix": m35,
        "common_general_error":
            MessageLookupByLibrary.simpleMessage("Si è verificato un errore"),
        "common_no": MessageLookupByLibrary.simpleMessage("No"),
        "common_refresh": MessageLookupByLibrary.simpleMessage("Aggiorna"),
        "common_retry": MessageLookupByLibrary.simpleMessage("Riprova"),
        "common_save": MessageLookupByLibrary.simpleMessage("Salva"),
        "common_undo": MessageLookupByLibrary.simpleMessage("Annulla"),
        "common_validate": MessageLookupByLibrary.simpleMessage("Convalida"),
        "common_yes": MessageLookupByLibrary.simpleMessage("Sì"),
        "companion_avoid":
            MessageLookupByLibrary.simpleMessage("Piante da evitare"),
        "companion_beneficial":
            MessageLookupByLibrary.simpleMessage("Piante benefiche"),
        "dashboard_activities":
            MessageLookupByLibrary.simpleMessage("Attività"),
        "dashboard_air_temp":
            MessageLookupByLibrary.simpleMessage("Temperatura"),
        "dashboard_calendar":
            MessageLookupByLibrary.simpleMessage("Calendario"),
        "dashboard_garden_create_error":
            MessageLookupByLibrary.simpleMessage("Errore creazione giardino."),
        "dashboard_garden_created": m36,
        "dashboard_garden_n": m37,
        "dashboard_settings":
            MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "dashboard_soil_temp":
            MessageLookupByLibrary.simpleMessage("Temp. Suolo"),
        "dashboard_statistics":
            MessageLookupByLibrary.simpleMessage("Statistiche"),
        "dashboard_weather": MessageLookupByLibrary.simpleMessage("Meteo"),
        "dashboard_weather_stats":
            MessageLookupByLibrary.simpleMessage("Dettagli Meteo"),
        "dialog_cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "dialog_confirm": MessageLookupByLibrary.simpleMessage("Conferma"),
        "empty_action_create": MessageLookupByLibrary.simpleMessage("Crea"),
        "error_page_back":
            MessageLookupByLibrary.simpleMessage("Torna alla home"),
        "error_page_message": m38,
        "error_page_title":
            MessageLookupByLibrary.simpleMessage("Pagina non trovata"),
        "export_action_generate":
            MessageLookupByLibrary.simpleMessage("Genera Esportazione Excel"),
        "export_block_activity":
            MessageLookupByLibrary.simpleMessage("Attività (Giornale)"),
        "export_block_desc_activity": MessageLookupByLibrary.simpleMessage(
            "Cronologia completa di interventi ed eventi"),
        "export_block_desc_garden": MessageLookupByLibrary.simpleMessage(
            "Metadati dei giardini selezionati"),
        "export_block_desc_garden_bed": MessageLookupByLibrary.simpleMessage(
            "Dettagli aiuole (area, orientamento...)"),
        "export_block_desc_harvest":
            MessageLookupByLibrary.simpleMessage("Dati di produzione e rese"),
        "export_block_desc_plant": MessageLookupByLibrary.simpleMessage(
            "Elenco delle piante utilizzate"),
        "export_block_garden":
            MessageLookupByLibrary.simpleMessage("Giardini (Struttura)"),
        "export_block_garden_bed":
            MessageLookupByLibrary.simpleMessage("Aiuole (Struttura)"),
        "export_block_harvest":
            MessageLookupByLibrary.simpleMessage("Raccolti (Produzione)"),
        "export_block_plant":
            MessageLookupByLibrary.simpleMessage("Piante (Catalogo)"),
        "export_blocks_section":
            MessageLookupByLibrary.simpleMessage("2. Blocchi Dati"),
        "export_builder_title":
            MessageLookupByLibrary.simpleMessage("Costruttore di Esportazione"),
        "export_columns_count": m39,
        "export_columns_section":
            MessageLookupByLibrary.simpleMessage("3. Dettagli e Colonne"),
        "export_error_snack": m40,
        "export_field_bed_name":
            MessageLookupByLibrary.simpleMessage("Nome Aiuola"),
        "export_field_garden_creation":
            MessageLookupByLibrary.simpleMessage("Data Creazione"),
        "export_field_garden_id":
            MessageLookupByLibrary.simpleMessage("ID Giardino"),
        "export_field_garden_name":
            MessageLookupByLibrary.simpleMessage("Nome Giardino"),
        "export_field_garden_surface":
            MessageLookupByLibrary.simpleMessage("Area (m²)"),
        "export_filter_garden_all":
            MessageLookupByLibrary.simpleMessage("Tutti i giardini"),
        "export_filter_garden_count": m41,
        "export_filter_garden_edit":
            MessageLookupByLibrary.simpleMessage("Modifica selezione"),
        "export_filter_garden_select_dialog_title":
            MessageLookupByLibrary.simpleMessage("Seleziona Giardini"),
        "export_filter_garden_title":
            MessageLookupByLibrary.simpleMessage("Filtra per Giardino"),
        "export_format_flat": MessageLookupByLibrary.simpleMessage(
            "Tabella Singola (Piatta / BI)"),
        "export_format_flat_subtitle": MessageLookupByLibrary.simpleMessage(
            "Una grande tabella per Tabelle Pivot"),
        "export_format_section":
            MessageLookupByLibrary.simpleMessage("4. Formato File"),
        "export_format_separate":
            MessageLookupByLibrary.simpleMessage("Fogli Separati (Standard)"),
        "export_format_separate_subtitle": MessageLookupByLibrary.simpleMessage(
            "Un foglio per tipo di dato (Consigliato)"),
        "export_generating":
            MessageLookupByLibrary.simpleMessage("Generazione..."),
        "export_scope_period": MessageLookupByLibrary.simpleMessage("Periodo"),
        "export_scope_period_all":
            MessageLookupByLibrary.simpleMessage("Tutta la Cronologia"),
        "export_scope_section":
            MessageLookupByLibrary.simpleMessage("1. Ambito"),
        "export_success_share_text": MessageLookupByLibrary.simpleMessage(
            "Ecco la tua esportazione PermaCalendar"),
        "export_success_title":
            MessageLookupByLibrary.simpleMessage("Esportazione Completata"),
        "garden_action_archive":
            MessageLookupByLibrary.simpleMessage("Archivia"),
        "garden_action_delete": MessageLookupByLibrary.simpleMessage("Elimina"),
        "garden_action_disable":
            MessageLookupByLibrary.simpleMessage("Disabilita"),
        "garden_action_edit": MessageLookupByLibrary.simpleMessage("Modifica"),
        "garden_action_enable": MessageLookupByLibrary.simpleMessage("Abilita"),
        "garden_action_modify":
            MessageLookupByLibrary.simpleMessage("Modifica"),
        "garden_action_unarchive":
            MessageLookupByLibrary.simpleMessage("Annulla archiviazione"),
        "garden_add_tooltip":
            MessageLookupByLibrary.simpleMessage("Aggiungi giardino"),
        "garden_archived_info": MessageLookupByLibrary.simpleMessage(
            "Hai giardini archiviati. Attiva la visualizzazione dei giardini archiviati per vederli."),
        "garden_bed_delete_confirm_body": m42,
        "garden_bed_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Elimina Aiuola"),
        "garden_bed_delete_error": m43,
        "garden_bed_deleted_snack":
            MessageLookupByLibrary.simpleMessage("Aiuola eliminata"),
        "garden_created_at": m44,
        "garden_detail_subtitle_error_beds": m45,
        "garden_detail_subtitle_not_found":
            MessageLookupByLibrary.simpleMessage(
                "Il giardino richiesto non esiste o è stato eliminato."),
        "garden_detail_title_error":
            MessageLookupByLibrary.simpleMessage("Errore"),
        "garden_error_subtitle": m46,
        "garden_error_title":
            MessageLookupByLibrary.simpleMessage("Errore di caricamento"),
        "garden_list_title":
            MessageLookupByLibrary.simpleMessage("I miei giardini"),
        "garden_management_add_bed_label":
            MessageLookupByLibrary.simpleMessage("Crea Aiuola"),
        "garden_management_archived_tag":
            MessageLookupByLibrary.simpleMessage("Giardino Archiviato"),
        "garden_management_beds_title":
            MessageLookupByLibrary.simpleMessage("Aiuole del Giardino"),
        "garden_management_create_error":
            MessageLookupByLibrary.simpleMessage("Creazione giardino fallita"),
        "garden_management_create_submit":
            MessageLookupByLibrary.simpleMessage("Crea Giardino"),
        "garden_management_create_submitting":
            MessageLookupByLibrary.simpleMessage("Creazione..."),
        "garden_management_create_title":
            MessageLookupByLibrary.simpleMessage("Crea Giardino"),
        "garden_management_created_success":
            MessageLookupByLibrary.simpleMessage(
                "Giardino creato con successo"),
        "garden_management_delete_confirm_body":
            MessageLookupByLibrary.simpleMessage(
                "Sei sicuro di voler eliminare questo giardino? Questo eliminerà anche tutte le aiuole e le piantagioni associate. Questa azione è irreversibile."),
        "garden_management_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Elimina Giardino"),
        "garden_management_delete_success":
            MessageLookupByLibrary.simpleMessage(
                "Giardino eliminato con successo"),
        "garden_management_desc_label":
            MessageLookupByLibrary.simpleMessage("Descrizione"),
        "garden_management_edit_title":
            MessageLookupByLibrary.simpleMessage("Modifica Giardino"),
        "garden_management_image_label": MessageLookupByLibrary.simpleMessage(
            "Immagine Giardino (Opzionale)"),
        "garden_management_image_preview_error":
            MessageLookupByLibrary.simpleMessage(
                "Impossibile caricare immagine"),
        "garden_management_image_url_label":
            MessageLookupByLibrary.simpleMessage("URL Immagine"),
        "garden_management_name_label":
            MessageLookupByLibrary.simpleMessage("Nome Giardino"),
        "garden_management_no_beds_desc": MessageLookupByLibrary.simpleMessage(
            "Crea aiuole per organizzare le tue piantagioni"),
        "garden_management_no_beds_title":
            MessageLookupByLibrary.simpleMessage("Nessuna Aiuola"),
        "garden_management_stats_area":
            MessageLookupByLibrary.simpleMessage("Area Totale"),
        "garden_management_stats_beds":
            MessageLookupByLibrary.simpleMessage("Aiuole"),
        "garden_no_gardens":
            MessageLookupByLibrary.simpleMessage("Nessun giardino ancora."),
        "garden_retry": MessageLookupByLibrary.simpleMessage("Riprova"),
        "harvest_action_save": MessageLookupByLibrary.simpleMessage("Salva"),
        "harvest_form_error_positive":
            MessageLookupByLibrary.simpleMessage("Non valido (> 0)"),
        "harvest_form_error_positive_or_zero":
            MessageLookupByLibrary.simpleMessage("Non valido (>= 0)"),
        "harvest_form_error_required":
            MessageLookupByLibrary.simpleMessage("Obbligatorio"),
        "harvest_notes_label":
            MessageLookupByLibrary.simpleMessage("Note / Qualità"),
        "harvest_price_helper": MessageLookupByLibrary.simpleMessage(
            "Sarà ricordato per futuri raccolti di questa pianta"),
        "harvest_price_label":
            MessageLookupByLibrary.simpleMessage("Prezzo Stimato (€/kg)"),
        "harvest_snack_error": MessageLookupByLibrary.simpleMessage(
            "Errore registrazione raccolto"),
        "harvest_snack_saved":
            MessageLookupByLibrary.simpleMessage("Raccolto registrato"),
        "harvest_title": m47,
        "harvest_weight_label":
            MessageLookupByLibrary.simpleMessage("Peso Raccolto (kg) *"),
        "history_hint_action":
            MessageLookupByLibrary.simpleMessage("Vai alla dashboard"),
        "history_hint_body": MessageLookupByLibrary.simpleMessage(
            "Selezionalo premendo a lungo nella dashboard."),
        "history_hint_title": MessageLookupByLibrary.simpleMessage(
            "Per vedere la cronologia di un giardino"),
        "home_settings_fallback_label":
            MessageLookupByLibrary.simpleMessage("Impostazioni (fallback)"),
        "info_exposure_full_sun":
            MessageLookupByLibrary.simpleMessage("Pieno sole"),
        "info_exposure_partial_sun":
            MessageLookupByLibrary.simpleMessage("Sole parziale"),
        "info_exposure_shade": MessageLookupByLibrary.simpleMessage("Ombra"),
        "info_season_all":
            MessageLookupByLibrary.simpleMessage("Tutte le stagioni"),
        "info_season_autumn": MessageLookupByLibrary.simpleMessage("Autunno"),
        "info_season_spring": MessageLookupByLibrary.simpleMessage("Primavera"),
        "info_season_summer": MessageLookupByLibrary.simpleMessage("Estate"),
        "info_season_winter": MessageLookupByLibrary.simpleMessage("Inverno"),
        "info_water_high": MessageLookupByLibrary.simpleMessage("Alto"),
        "info_water_low": MessageLookupByLibrary.simpleMessage("Basso"),
        "info_water_medium": MessageLookupByLibrary.simpleMessage("Medio"),
        "info_water_moderate": MessageLookupByLibrary.simpleMessage("Moderato"),
        "kpi_alignment_aligned":
            MessageLookupByLibrary.simpleMessage("allineato"),
        "kpi_alignment_aligned_actions":
            MessageLookupByLibrary.simpleMessage("Allineato"),
        "kpi_alignment_calculating":
            MessageLookupByLibrary.simpleMessage("Calcolo allineamento..."),
        "kpi_alignment_cta": MessageLookupByLibrary.simpleMessage(
            "Inizia a piantare e raccogliere per vedere il tuo allineamento!"),
        "kpi_alignment_description": MessageLookupByLibrary.simpleMessage(
            "Questo strumento valuta quanto le tue semine, piantagioni e raccolti siano vicini alle finestre ideali raccomandate dall\'Agenda Intelligente."),
        "kpi_alignment_error":
            MessageLookupByLibrary.simpleMessage("Errore durante il calcolo"),
        "kpi_alignment_misaligned_actions":
            MessageLookupByLibrary.simpleMessage("Disallineato"),
        "kpi_alignment_title":
            MessageLookupByLibrary.simpleMessage("Allineamento Vivente"),
        "kpi_alignment_total": MessageLookupByLibrary.simpleMessage("Totale"),
        "language_changed_snackbar": m48,
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_french": MessageLookupByLibrary.simpleMessage("Français"),
        "language_german": MessageLookupByLibrary.simpleMessage("Deutsch"),
        "language_portuguese_br":
            MessageLookupByLibrary.simpleMessage("Português (Brasil)"),
        "language_spanish": MessageLookupByLibrary.simpleMessage("Español"),
        "language_title":
            MessageLookupByLibrary.simpleMessage("Lingua / Language"),
        "lifecycle_cycle_completed":
            MessageLookupByLibrary.simpleMessage("ciclo completato"),
        "lifecycle_days_ago": m49,
        "lifecycle_error_prefix":
            MessageLookupByLibrary.simpleMessage("Errore: "),
        "lifecycle_error_title": MessageLookupByLibrary.simpleMessage(
            "Errore nel calcolo del ciclo"),
        "lifecycle_harvest_expected":
            MessageLookupByLibrary.simpleMessage("Raccolto previsto"),
        "lifecycle_in_days": m50,
        "lifecycle_next_action":
            MessageLookupByLibrary.simpleMessage("Prossima azione"),
        "lifecycle_now": MessageLookupByLibrary.simpleMessage("Adesso!"),
        "lifecycle_passed": MessageLookupByLibrary.simpleMessage("Passato"),
        "lifecycle_stage_fruiting":
            MessageLookupByLibrary.simpleMessage("Fruttificazione"),
        "lifecycle_stage_germination":
            MessageLookupByLibrary.simpleMessage("Germinazione"),
        "lifecycle_stage_growth":
            MessageLookupByLibrary.simpleMessage("Crescita"),
        "lifecycle_stage_harvest":
            MessageLookupByLibrary.simpleMessage("Raccolto"),
        "lifecycle_stage_unknown":
            MessageLookupByLibrary.simpleMessage("Sconosciuto"),
        "lifecycle_update":
            MessageLookupByLibrary.simpleMessage("Aggiorna ciclo"),
        "moon_phase_first_quarter":
            MessageLookupByLibrary.simpleMessage("Primo Quarto"),
        "moon_phase_full": MessageLookupByLibrary.simpleMessage("Luna Piena"),
        "moon_phase_last_quarter":
            MessageLookupByLibrary.simpleMessage("Ultimo Quarto"),
        "moon_phase_new": MessageLookupByLibrary.simpleMessage("Luna Nuova"),
        "moon_phase_waning_crescent":
            MessageLookupByLibrary.simpleMessage("Luna Calante"),
        "moon_phase_waning_gibbous":
            MessageLookupByLibrary.simpleMessage("Gibbosa Calante"),
        "moon_phase_waxing_crescent":
            MessageLookupByLibrary.simpleMessage("Luna Crescente"),
        "moon_phase_waxing_gibbous":
            MessageLookupByLibrary.simpleMessage("Gibbosa Crescente"),
        "nut_calcium": MessageLookupByLibrary.simpleMessage("Calcio"),
        "nut_fiber": MessageLookupByLibrary.simpleMessage("Fibre"),
        "nut_iron": MessageLookupByLibrary.simpleMessage("Ferro"),
        "nut_magnesium": MessageLookupByLibrary.simpleMessage("Magnesio"),
        "nut_manganese": MessageLookupByLibrary.simpleMessage("Manganese"),
        "nut_potassium": MessageLookupByLibrary.simpleMessage("Potassio"),
        "nut_protein": MessageLookupByLibrary.simpleMessage("Proteine"),
        "nut_vitamin_c": MessageLookupByLibrary.simpleMessage("Vitamina C"),
        "nut_zinc": MessageLookupByLibrary.simpleMessage("Zinco"),
        "nutrition_dominant_production":
            MessageLookupByLibrary.simpleMessage("Produzione dominante:"),
        "nutrition_major_minerals_title": MessageLookupByLibrary.simpleMessage(
            "Struttura e Minerali Principali"),
        "nutrition_month_dynamics_title": m51,
        "nutrition_no_data_period": MessageLookupByLibrary.simpleMessage(
            "Nessun dato per questo periodo"),
        "nutrition_no_harvest_month":
            MessageLookupByLibrary.simpleMessage("Nessun raccolto questo mese"),
        "nutrition_no_major_minerals":
            MessageLookupByLibrary.simpleMessage("Nessun minerale principale"),
        "nutrition_no_trace_elements":
            MessageLookupByLibrary.simpleMessage("Nessun oligoelemento"),
        "nutrition_nutrients_origin": MessageLookupByLibrary.simpleMessage(
            "Questi nutrienti provengono dai tuoi raccolti del mese."),
        "nutrition_page_title":
            MessageLookupByLibrary.simpleMessage("Firma Nutrizionale"),
        "nutrition_seasonal_dynamics_desc": MessageLookupByLibrary.simpleMessage(
            "Esplora la produzione di minerali e vitamine del tuo giardino, mese per mese."),
        "nutrition_seasonal_dynamics_title":
            MessageLookupByLibrary.simpleMessage("Dinamiche Stagionali"),
        "nutrition_trace_elements_title":
            MessageLookupByLibrary.simpleMessage("Vitalità e Oligoelementi"),
        "pillar_economy_label":
            MessageLookupByLibrary.simpleMessage("Valore totale raccolto"),
        "pillar_economy_title":
            MessageLookupByLibrary.simpleMessage("Economia del Giardino"),
        "pillar_export_button": MessageLookupByLibrary.simpleMessage("Esporta"),
        "pillar_export_label":
            MessageLookupByLibrary.simpleMessage("Recupera i tuoi dati"),
        "pillar_export_title": MessageLookupByLibrary.simpleMessage("Esporta"),
        "pillar_nutrition_label":
            MessageLookupByLibrary.simpleMessage("Firma Nutrizionale"),
        "pillar_nutrition_title":
            MessageLookupByLibrary.simpleMessage("Bilancio Nutrizionale"),
        "plant_added_favorites": m52,
        "plant_catalog_data_unknown":
            MessageLookupByLibrary.simpleMessage("Dati sconosciuti"),
        "plant_catalog_expand_window":
            MessageLookupByLibrary.simpleMessage("Espandi (±2 mesi)"),
        "plant_catalog_filter_all":
            MessageLookupByLibrary.simpleMessage("Tutti"),
        "plant_catalog_filter_green_only":
            MessageLookupByLibrary.simpleMessage("Solo verdi"),
        "plant_catalog_filter_green_orange":
            MessageLookupByLibrary.simpleMessage("Verdi + Arancioni"),
        "plant_catalog_legend_green":
            MessageLookupByLibrary.simpleMessage("Pronto questo mese"),
        "plant_catalog_legend_orange":
            MessageLookupByLibrary.simpleMessage("Vicino / Presto"),
        "plant_catalog_legend_red":
            MessageLookupByLibrary.simpleMessage("Fuori stagione"),
        "plant_catalog_missing_period_data":
            MessageLookupByLibrary.simpleMessage("Dati del periodo mancanti"),
        "plant_catalog_no_recommended": MessageLookupByLibrary.simpleMessage(
            "Nessuna pianta raccomandata per il periodo."),
        "plant_catalog_periods_prefix": m53,
        "plant_catalog_plant": MessageLookupByLibrary.simpleMessage("Piantare"),
        "plant_catalog_search_hint":
            MessageLookupByLibrary.simpleMessage("Cerca una pianta..."),
        "plant_catalog_show_selection":
            MessageLookupByLibrary.simpleMessage("Mostra selezione"),
        "plant_catalog_sow": MessageLookupByLibrary.simpleMessage("Seminare"),
        "plant_catalog_title":
            MessageLookupByLibrary.simpleMessage("Catalogo piante"),
        "plant_custom_badge":
            MessageLookupByLibrary.simpleMessage("Personalizzato"),
        "plant_detail_add_to_garden_todo": MessageLookupByLibrary.simpleMessage(
            "Aggiunta al giardino non ancora implementata"),
        "plant_detail_detail_exposure":
            MessageLookupByLibrary.simpleMessage("Esposizione"),
        "plant_detail_detail_family":
            MessageLookupByLibrary.simpleMessage("Famiglia"),
        "plant_detail_detail_maturity":
            MessageLookupByLibrary.simpleMessage("Tempo di maturazione"),
        "plant_detail_detail_spacing":
            MessageLookupByLibrary.simpleMessage("Spaziatura"),
        "plant_detail_detail_water":
            MessageLookupByLibrary.simpleMessage("Fabbisogno idrico"),
        "plant_detail_not_found_body": MessageLookupByLibrary.simpleMessage(
            "Questa pianta non esiste o non è stato possibile caricarla."),
        "plant_detail_not_found_title":
            MessageLookupByLibrary.simpleMessage("Pianta non trovata"),
        "plant_detail_popup_add_to_garden":
            MessageLookupByLibrary.simpleMessage("Aggiungi al giardino"),
        "plant_detail_popup_share":
            MessageLookupByLibrary.simpleMessage("Condividi"),
        "plant_detail_section_culture":
            MessageLookupByLibrary.simpleMessage("Dettagli colturali"),
        "plant_detail_section_instructions":
            MessageLookupByLibrary.simpleMessage("Istruzioni generali"),
        "plant_detail_share_todo": MessageLookupByLibrary.simpleMessage(
            "Condivisione non ancora implementata"),
        "planting_add_tooltip":
            MessageLookupByLibrary.simpleMessage("Aggiungi piantagione"),
        "planting_card_harvest_estimate": m54,
        "planting_card_planted_date": m55,
        "planting_card_sown_date": m56,
        "planting_clear_filters":
            MessageLookupByLibrary.simpleMessage("Cancella filtri"),
        "planting_create_action":
            MessageLookupByLibrary.simpleMessage("Crea piantagione"),
        "planting_creation_title":
            MessageLookupByLibrary.simpleMessage("Nuova Piantagione"),
        "planting_creation_title_edit":
            MessageLookupByLibrary.simpleMessage("Modifica Piantagione"),
        "planting_custom_plant_title":
            MessageLookupByLibrary.simpleMessage("Pianta Personalizzata"),
        "planting_date_future_error": MessageLookupByLibrary.simpleMessage(
            "La data di piantagione non può essere nel futuro"),
        "planting_delete_confirm_body": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler eliminare questa piantagione? Questa azione è irreversibile."),
        "planting_delete_title":
            MessageLookupByLibrary.simpleMessage("Elimina piantagione"),
        "planting_detail_title":
            MessageLookupByLibrary.simpleMessage("Dettagli piantagione"),
        "planting_empty_first": MessageLookupByLibrary.simpleMessage(
            "Aggiungi la tua prima piantagione in questa aiuola."),
        "planting_empty_no_result":
            MessageLookupByLibrary.simpleMessage("Nessun risultato"),
        "planting_empty_none":
            MessageLookupByLibrary.simpleMessage("Nessuna piantagione"),
        "planting_filter_all_plants":
            MessageLookupByLibrary.simpleMessage("Tutte le piante"),
        "planting_filter_all_statuses":
            MessageLookupByLibrary.simpleMessage("Tutti gli stati"),
        "planting_history_action_planting":
            MessageLookupByLibrary.simpleMessage("Piantagione"),
        "planting_history_title":
            MessageLookupByLibrary.simpleMessage("Cronologia azioni"),
        "planting_history_todo": MessageLookupByLibrary.simpleMessage(
            "Cronologia dettagliata in arrivo"),
        "planting_info_cm": m57,
        "planting_info_culture_title":
            MessageLookupByLibrary.simpleMessage("Info Colturali"),
        "planting_info_days": m58,
        "planting_info_depth":
            MessageLookupByLibrary.simpleMessage("Profondità"),
        "planting_info_exposure":
            MessageLookupByLibrary.simpleMessage("Esposizione"),
        "planting_info_germination":
            MessageLookupByLibrary.simpleMessage("Tempo di germinazione"),
        "planting_info_harvest_time":
            MessageLookupByLibrary.simpleMessage("Tempo di raccolta"),
        "planting_info_maturity":
            MessageLookupByLibrary.simpleMessage("Maturità"),
        "planting_info_none":
            MessageLookupByLibrary.simpleMessage("Non specificato"),
        "planting_info_scientific_name_none":
            MessageLookupByLibrary.simpleMessage(
                "Nome scientifico non disponibile"),
        "planting_info_season":
            MessageLookupByLibrary.simpleMessage("Stagione di semina"),
        "planting_info_spacing":
            MessageLookupByLibrary.simpleMessage("Spaziatura"),
        "planting_info_tips_title":
            MessageLookupByLibrary.simpleMessage("Consigli di Coltivazione"),
        "planting_info_title":
            MessageLookupByLibrary.simpleMessage("Info Botaniche"),
        "planting_info_water": MessageLookupByLibrary.simpleMessage("Acqua"),
        "planting_menu_ready_for_harvest":
            MessageLookupByLibrary.simpleMessage("Pronto per il raccolto"),
        "planting_menu_statistics":
            MessageLookupByLibrary.simpleMessage("Statistiche"),
        "planting_menu_test_data":
            MessageLookupByLibrary.simpleMessage("Dati di prova"),
        "planting_no_plant_selected":
            MessageLookupByLibrary.simpleMessage("Nessuna pianta selezionata"),
        "planting_notes_hint":
            MessageLookupByLibrary.simpleMessage("Informazioni aggiuntive..."),
        "planting_notes_label":
            MessageLookupByLibrary.simpleMessage("Note (opzionale)"),
        "planting_plant_name_hint":
            MessageLookupByLibrary.simpleMessage("Es: Pomodoro Ciliegino"),
        "planting_plant_name_label":
            MessageLookupByLibrary.simpleMessage("Nome Pianta"),
        "planting_plant_name_required":
            MessageLookupByLibrary.simpleMessage("Nome pianta obbligatorio"),
        "planting_plant_selection_label": m59,
        "planting_quantity_plants":
            MessageLookupByLibrary.simpleMessage("Numero di piante"),
        "planting_quantity_positive": MessageLookupByLibrary.simpleMessage(
            "La quantità deve essere un numero positivo"),
        "planting_quantity_required":
            MessageLookupByLibrary.simpleMessage("Quantità obbligatoria"),
        "planting_quantity_seeds":
            MessageLookupByLibrary.simpleMessage("Numero di semi"),
        "planting_search_hint":
            MessageLookupByLibrary.simpleMessage("Cerca piantagione..."),
        "planting_stat_in_growth":
            MessageLookupByLibrary.simpleMessage("In crescita"),
        "planting_stat_plantings":
            MessageLookupByLibrary.simpleMessage("Piantagioni"),
        "planting_stat_ready_for_harvest":
            MessageLookupByLibrary.simpleMessage("Pronto per il raccolto"),
        "planting_stat_success_rate":
            MessageLookupByLibrary.simpleMessage("Tasso di successo"),
        "planting_stat_total_quantity":
            MessageLookupByLibrary.simpleMessage("Quantità totale"),
        "planting_status_failed":
            MessageLookupByLibrary.simpleMessage("Fallito"),
        "planting_status_growing":
            MessageLookupByLibrary.simpleMessage("In crescita"),
        "planting_status_harvested":
            MessageLookupByLibrary.simpleMessage("Raccolto"),
        "planting_status_planted":
            MessageLookupByLibrary.simpleMessage("Piantato"),
        "planting_status_ready":
            MessageLookupByLibrary.simpleMessage("Pronto per il raccolto"),
        "planting_status_sown":
            MessageLookupByLibrary.simpleMessage("Seminato"),
        "planting_steps_add_button":
            MessageLookupByLibrary.simpleMessage("Aggiungi"),
        "planting_steps_date_prefix": m60,
        "planting_steps_dialog_add":
            MessageLookupByLibrary.simpleMessage("Aggiungi"),
        "planting_steps_dialog_hint":
            MessageLookupByLibrary.simpleMessage("Es: Pacciamatura leggera"),
        "planting_steps_dialog_title":
            MessageLookupByLibrary.simpleMessage("Aggiungi Passaggio"),
        "planting_steps_done": MessageLookupByLibrary.simpleMessage("Fatto"),
        "planting_steps_empty": MessageLookupByLibrary.simpleMessage(
            "Nessun passaggio consigliato"),
        "planting_steps_mark_done":
            MessageLookupByLibrary.simpleMessage("Segna come fatto"),
        "planting_steps_more": m61,
        "planting_steps_prediction_badge":
            MessageLookupByLibrary.simpleMessage("Previsione"),
        "planting_steps_see_all":
            MessageLookupByLibrary.simpleMessage("Vedi tutto"),
        "planting_steps_see_less":
            MessageLookupByLibrary.simpleMessage("Vedi meno"),
        "planting_steps_title":
            MessageLookupByLibrary.simpleMessage("Passo dopo passo"),
        "planting_success_create": MessageLookupByLibrary.simpleMessage(
            "Piantagione creata con successo"),
        "planting_success_update": MessageLookupByLibrary.simpleMessage(
            "Piantagione aggiornata con successo"),
        "planting_tips_catalog": MessageLookupByLibrary.simpleMessage(
            "• Usa il catalogo per selezionare una pianta."),
        "planting_tips_none": MessageLookupByLibrary.simpleMessage(
            "Nessun consiglio disponibile"),
        "planting_tips_notes": MessageLookupByLibrary.simpleMessage(
            "• Aggiungi note per tracciare condizioni speciali."),
        "planting_tips_title": MessageLookupByLibrary.simpleMessage("Consigli"),
        "planting_tips_type": MessageLookupByLibrary.simpleMessage(
            "• Scegli \"Seminato\" per semi, \"Piantato\" per piantine."),
        "planting_title_template": m62,
        "privacy_policy_text": MessageLookupByLibrary.simpleMessage(
            "Sowing rispetta pienamente la tua privacy.\n\n• Tutti i dati sono archiviati localmente sul tuo dispositivo\n• Nessun dato personale viene trasmesso a terzi\n• Nessuna informazione viene archiviata su un server esterno\n\nL\'applicazione funziona completamente offline. Una connessione Internet viene utilizzata solo per recuperare i dati meteo o durante le esportazioni."),
        "search_hint": MessageLookupByLibrary.simpleMessage("Cerca..."),
        "settings_about": MessageLookupByLibrary.simpleMessage("Informazioni"),
        "settings_application":
            MessageLookupByLibrary.simpleMessage("Applicazione"),
        "settings_choose_commune":
            MessageLookupByLibrary.simpleMessage("Scegli posizione"),
        "settings_commune_default": m63,
        "settings_commune_selected": m64,
        "settings_commune_title":
            MessageLookupByLibrary.simpleMessage("Posizione per il meteo"),
        "settings_display":
            MessageLookupByLibrary.simpleMessage("Visualizzazione"),
        "settings_plants_catalog":
            MessageLookupByLibrary.simpleMessage("Catalogo piante"),
        "settings_plants_catalog_subtitle":
            MessageLookupByLibrary.simpleMessage("Cerca e visualizza piante"),
        "settings_privacy": MessageLookupByLibrary.simpleMessage("Privacy"),
        "settings_privacy_policy":
            MessageLookupByLibrary.simpleMessage("Informativa sulla privacy"),
        "settings_quick_access":
            MessageLookupByLibrary.simpleMessage("Accesso rapido"),
        "settings_search_commune_hint":
            MessageLookupByLibrary.simpleMessage("Cerca una località..."),
        "settings_terms":
            MessageLookupByLibrary.simpleMessage("Termini di utilizzo"),
        "settings_title": MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "settings_user_guide":
            MessageLookupByLibrary.simpleMessage("Guida utente"),
        "settings_user_guide_subtitle":
            MessageLookupByLibrary.simpleMessage("Leggi il manuale"),
        "settings_version": MessageLookupByLibrary.simpleMessage("Versione"),
        "settings_version_dialog_content": m65,
        "settings_version_dialog_title":
            MessageLookupByLibrary.simpleMessage("Versione app"),
        "settings_weather_selector":
            MessageLookupByLibrary.simpleMessage("Selettore meteo"),
        "snackbar_commune_selected": m66,
        "soil_advice_status_ideal":
            MessageLookupByLibrary.simpleMessage("Ottimale"),
        "soil_advice_status_sow_now":
            MessageLookupByLibrary.simpleMessage("Semina Ora"),
        "soil_advice_status_sow_soon":
            MessageLookupByLibrary.simpleMessage("Presto"),
        "soil_advice_status_wait":
            MessageLookupByLibrary.simpleMessage("Attendi"),
        "soil_sheet_action_cancel":
            MessageLookupByLibrary.simpleMessage("Annulla"),
        "soil_sheet_action_save": MessageLookupByLibrary.simpleMessage("Salva"),
        "soil_sheet_input_error": MessageLookupByLibrary.simpleMessage(
            "Valore non valido (da -10.0 a 45.0)"),
        "soil_sheet_input_hint": MessageLookupByLibrary.simpleMessage("0.0"),
        "soil_sheet_input_label":
            MessageLookupByLibrary.simpleMessage("Temperatura (°C)"),
        "soil_sheet_last_measure": m67,
        "soil_sheet_new_measure":
            MessageLookupByLibrary.simpleMessage("Nuova misura (Ancora)"),
        "soil_sheet_snack_error": m68,
        "soil_sheet_snack_invalid": MessageLookupByLibrary.simpleMessage(
            "Valore non valido. Inserisci tra -10.0 e 45.0"),
        "soil_sheet_snack_success":
            MessageLookupByLibrary.simpleMessage("Misura salvata come ancora"),
        "soil_sheet_title":
            MessageLookupByLibrary.simpleMessage("Temperatura del Suolo"),
        "soil_temp_about_content": MessageLookupByLibrary.simpleMessage(
            "La temperatura del suolo visualizzata qui è stimata dall\'app in base a dati climatici e stagionali, secondo la seguente formula:\n\nQuesta stima fornisce una tendenza realistica della temperatura del suolo quando non sono disponibili misurazioni dirette."),
        "soil_temp_about_title":
            MessageLookupByLibrary.simpleMessage("Info Temp. Suolo"),
        "soil_temp_action_measure":
            MessageLookupByLibrary.simpleMessage("Modifica / Misura"),
        "soil_temp_advice_error": m69,
        "soil_temp_catalog_error": m70,
        "soil_temp_chart_error": m71,
        "soil_temp_current_label":
            MessageLookupByLibrary.simpleMessage("Temperatura attuale"),
        "soil_temp_db_empty":
            MessageLookupByLibrary.simpleMessage("Database piante vuoto."),
        "soil_temp_formula_content": MessageLookupByLibrary.simpleMessage(
            "T_suolo(n+1) = T_suolo(n) + α × (T_aria(n) − T_suolo(n))\n\nDove:\n• α : coefficiente di diffusione termica (predefinito 0,15 — intervallo raccomandato 0,10–0,20).\n• T_suolo(n) : temperatura attuale del suolo (°C).\n• T_aria(n) : temperatura attuale dell\'aria (°C).\n\nLa formula è implementata nel codice dell\'app (ComputeSoilTempNextDayUsecase)."),
        "soil_temp_formula_label":
            MessageLookupByLibrary.simpleMessage("Formula di calcolo usata:"),
        "soil_temp_measure_hint": MessageLookupByLibrary.simpleMessage(
            "Puoi inserire manualmente la temperatura del suolo nella scheda \'Modifica / Misura\'."),
        "soil_temp_no_advice": MessageLookupByLibrary.simpleMessage(
            "Nessuna pianta con dati di germinazione trovata."),
        "soil_temp_reload_plants":
            MessageLookupByLibrary.simpleMessage("Ricarica piante"),
        "soil_temp_title":
            MessageLookupByLibrary.simpleMessage("Temperatura del Suolo"),
        "stats_annual_evolution_title":
            MessageLookupByLibrary.simpleMessage("Tendenza Annuale"),
        "stats_auto_summary_title":
            MessageLookupByLibrary.simpleMessage("Riepilogo Automatico"),
        "stats_crop_distribution_others":
            MessageLookupByLibrary.simpleMessage("Altri"),
        "stats_crop_distribution_title":
            MessageLookupByLibrary.simpleMessage("Distribuzione Colture"),
        "stats_dominant_culture_title":
            MessageLookupByLibrary.simpleMessage("Coltura Dominante per Mese"),
        "stats_economy_no_harvest": MessageLookupByLibrary.simpleMessage(
            "Nessun raccolto nel periodo selezionato."),
        "stats_economy_no_harvest_desc": MessageLookupByLibrary.simpleMessage(
            "Nessun dato per il periodo selezionato."),
        "stats_economy_title":
            MessageLookupByLibrary.simpleMessage("Economia del Giardino"),
        "stats_key_months_title":
            MessageLookupByLibrary.simpleMessage("Mesi Chiave del Giardino"),
        "stats_kpi_avg_price":
            MessageLookupByLibrary.simpleMessage("Prezzo Medio"),
        "stats_kpi_total_revenue":
            MessageLookupByLibrary.simpleMessage("Entrate Totali"),
        "stats_kpi_total_volume":
            MessageLookupByLibrary.simpleMessage("Volume Totale"),
        "stats_least_profitable":
            MessageLookupByLibrary.simpleMessage("Meno Redditizio"),
        "stats_monthly_revenue_no_data":
            MessageLookupByLibrary.simpleMessage("Nessun dato mensile"),
        "stats_monthly_revenue_title":
            MessageLookupByLibrary.simpleMessage("Entrate Mensili"),
        "stats_most_profitable":
            MessageLookupByLibrary.simpleMessage("Più Redditizio"),
        "stats_profitability_cycle_title":
            MessageLookupByLibrary.simpleMessage("Ciclo di Redditività"),
        "stats_revenue_history_title":
            MessageLookupByLibrary.simpleMessage("Cronologia Entrate"),
        "stats_screen_subtitle": MessageLookupByLibrary.simpleMessage(
            "Analizza in tempo reale ed esporta i tuoi dati."),
        "stats_screen_title":
            MessageLookupByLibrary.simpleMessage("Statistiche"),
        "stats_table_crop": MessageLookupByLibrary.simpleMessage("Coltura"),
        "stats_table_days":
            MessageLookupByLibrary.simpleMessage("Giorni (Media)"),
        "stats_table_revenue":
            MessageLookupByLibrary.simpleMessage("Ric/Raccolto"),
        "stats_table_type": MessageLookupByLibrary.simpleMessage("Tipo"),
        "stats_top_cultures_no_data":
            MessageLookupByLibrary.simpleMessage("Nessun dato"),
        "stats_top_cultures_percent_revenue":
            MessageLookupByLibrary.simpleMessage("delle entrate"),
        "stats_top_cultures_title":
            MessageLookupByLibrary.simpleMessage("Migliori Colture (Valore)"),
        "stats_type_fast": MessageLookupByLibrary.simpleMessage("Veloce"),
        "stats_type_long_term":
            MessageLookupByLibrary.simpleMessage("Lungo Termine"),
        "status_failed": MessageLookupByLibrary.simpleMessage("Fallito"),
        "status_growing": MessageLookupByLibrary.simpleMessage("In crescita"),
        "status_harvested": MessageLookupByLibrary.simpleMessage("Raccolto"),
        "status_planted": MessageLookupByLibrary.simpleMessage("Piantato"),
        "status_ready_to_harvest":
            MessageLookupByLibrary.simpleMessage("Pronto per il raccolto"),
        "status_sown": MessageLookupByLibrary.simpleMessage("Seminato"),
        "task_editor_action_cancel":
            MessageLookupByLibrary.simpleMessage("Annulla"),
        "task_editor_action_create":
            MessageLookupByLibrary.simpleMessage("Crea"),
        "task_editor_action_save":
            MessageLookupByLibrary.simpleMessage("Salva"),
        "task_editor_assignee_add": m72,
        "task_editor_assignee_label":
            MessageLookupByLibrary.simpleMessage("Assegnato a"),
        "task_editor_assignee_none":
            MessageLookupByLibrary.simpleMessage("Nessun risultato."),
        "task_editor_date_label":
            MessageLookupByLibrary.simpleMessage("Data di Inizio"),
        "task_editor_description_label":
            MessageLookupByLibrary.simpleMessage("Descrizione"),
        "task_editor_duration_label":
            MessageLookupByLibrary.simpleMessage("Durata Stimata"),
        "task_editor_duration_other":
            MessageLookupByLibrary.simpleMessage("Altro"),
        "task_editor_error_title_required":
            MessageLookupByLibrary.simpleMessage("Obbligatorio"),
        "task_editor_export_label":
            MessageLookupByLibrary.simpleMessage("Output / Condividi"),
        "task_editor_garden_all":
            MessageLookupByLibrary.simpleMessage("Tutti i Giardini"),
        "task_editor_option_docx":
            MessageLookupByLibrary.simpleMessage("Esporta — Word (.docx)"),
        "task_editor_option_none":
            MessageLookupByLibrary.simpleMessage("Nessuno (Salva Solo)"),
        "task_editor_option_pdf":
            MessageLookupByLibrary.simpleMessage("Esporta — PDF"),
        "task_editor_option_share":
            MessageLookupByLibrary.simpleMessage("Condividi (Testo)"),
        "task_editor_photo_placeholder":
            MessageLookupByLibrary.simpleMessage("Aggiungi Foto (Presto)"),
        "task_editor_priority_label":
            MessageLookupByLibrary.simpleMessage("Priorità"),
        "task_editor_recurrence_days_suffix":
            MessageLookupByLibrary.simpleMessage(" g"),
        "task_editor_recurrence_interval":
            MessageLookupByLibrary.simpleMessage("Ogni X giorni"),
        "task_editor_recurrence_label":
            MessageLookupByLibrary.simpleMessage("Ricorrenza"),
        "task_editor_recurrence_monthly":
            MessageLookupByLibrary.simpleMessage("Mensilmente (stesso giorno)"),
        "task_editor_recurrence_none":
            MessageLookupByLibrary.simpleMessage("Nessuna"),
        "task_editor_recurrence_repeat_label":
            MessageLookupByLibrary.simpleMessage("Ripeti ogni "),
        "task_editor_recurrence_weekly":
            MessageLookupByLibrary.simpleMessage("Settimanalmente (Giorni)"),
        "task_editor_time_label": MessageLookupByLibrary.simpleMessage("Ora"),
        "task_editor_title_edit":
            MessageLookupByLibrary.simpleMessage("Modifica Attività"),
        "task_editor_title_field":
            MessageLookupByLibrary.simpleMessage("Titolo *"),
        "task_editor_title_new":
            MessageLookupByLibrary.simpleMessage("Nuova Attività"),
        "task_editor_type_label":
            MessageLookupByLibrary.simpleMessage("Tipo di Attività"),
        "task_editor_urgent_label":
            MessageLookupByLibrary.simpleMessage("Urgente"),
        "task_editor_zone_empty": MessageLookupByLibrary.simpleMessage(
            "Nessuna aiuola per questo giardino"),
        "task_editor_zone_label":
            MessageLookupByLibrary.simpleMessage("Zona (Aiuola)"),
        "task_editor_zone_none":
            MessageLookupByLibrary.simpleMessage("Nessuna zona specifica"),
        "task_kind_amendment":
            MessageLookupByLibrary.simpleMessage("Ammendamento 🪵"),
        "task_kind_buy": MessageLookupByLibrary.simpleMessage("Comprare 🛒"),
        "task_kind_clean": MessageLookupByLibrary.simpleMessage("Pulire 🧹"),
        "task_kind_generic": MessageLookupByLibrary.simpleMessage("Generico"),
        "task_kind_harvest":
            MessageLookupByLibrary.simpleMessage("Raccogliere 🧺"),
        "task_kind_pruning": MessageLookupByLibrary.simpleMessage("Potare ✂️"),
        "task_kind_repair":
            MessageLookupByLibrary.simpleMessage("Riparazione 🛠️"),
        "task_kind_seeding":
            MessageLookupByLibrary.simpleMessage("Seminare 🌱"),
        "task_kind_treatment":
            MessageLookupByLibrary.simpleMessage("Trattamento 🧪"),
        "task_kind_watering":
            MessageLookupByLibrary.simpleMessage("Innaffiare 💧"),
        "task_kind_weeding":
            MessageLookupByLibrary.simpleMessage("Diserbare 🌿"),
        "task_kind_winter_protection":
            MessageLookupByLibrary.simpleMessage("Protezione inv. ❄️"),
        "terms_text": MessageLookupByLibrary.simpleMessage(
            "Utilizzando Sowing, accetti di:\n\n• Utilizzare l\'applicazione in modo responsabile\n• Non tentare di aggirare le sue limitazioni\n• Rispettare i diritti di proprietà intellettuale\n• Utilizzare solo i tuoi dati\n\nQuesta applicazione è fornita così com\'è, senza garanzia.\n\nIl team di Sowing rimane aperto a qualsiasi miglioramento o evoluzione futura."),
        "user_guide_text": MessageLookupByLibrary.simpleMessage(
            "1 — Benvenuto in Sowing\nSowing è un\'applicazione progettata per supportare i giardinieri nel monitoraggio vivo e concreto delle loro colture.\nTi permette di:\n• organizzare i tuoi giardini e aiuole,\n• seguire le tue piantagioni durante il loro ciclo di vita,\n• pianificare i tuoi compiti al momento giusto,\n• mantenere un ricordo di ciò che è stato fatto,\n• tenere conto del meteo locale e del ritmo delle stagioni.\nL\'applicazione funziona principalmente offline e conserva i tuoi dati direttamente sul tuo dispositivo.\nQuesto manuale descrive l\'uso comune di Sowing: primi passi, creazione di giardini, piantagioni, calendario, meteo, esportazione dati e buone pratiche.\n\n2 — Comprendere l\'interfaccia\nLa dashboard\nAll\'apertura, Sowing mostra una dashboard visiva e organica.\nPrende la forma di un\'immagine di sfondo animata da bolle interattive. Ogni bolla dà accesso a una funzione principale dell\'applicazione:\n• giardini,\n• meteo dell\'aria,\n• meteo del suolo,\n• calendario,\n• attività,\n• statistiche,\n• impostazioni.\nNavigazione generale\nTocca semplicemente una bolla per aprire la sezione corrispondente.\nAll\'interno delle pagine, troverai a seconda del contesto:\n• menu contestuali,\n• pulsanti \"+\" per aggiungere un elemento,\n• pulsanti di modifica o eliminazione.\n\n3 — Avvio rapido\nAprire l\'applicazione\nAll\'avvio, la dashboard viene visualizzata automaticamente.\nConfigurare il meteo\nNelle impostazioni, scegli la tua posizione.\nQuesta informazione consente a Sowing di visualizzare il meteo locale adattato al tuo giardino. Se nessuna posizione è selezionata, ne viene usata una predefinita.\nCreare il tuo primo giardino\nAl primo utilizzo, Sowing ti guida automaticamente per creare il tuo primo giardino.\nPuoi anche creare un giardino manualmente dalla dashboard.\nNella schermata principale, tocca la foglia verde situata nell\'area più libera, a destra delle statistiche e leggermente in alto. Questa zona deliberatamente discreta ti permette di avviare la creazione di un giardino.\nPuoi creare fino a cinque giardini.\nQuesto approccio fa parte dell\'esperienza Sowing: non c\'è un pulsante \"+\" permanente e centrale. L\'applicazione invita piuttosto all\'esplorazione e alla scoperta progressiva dello spazio.\nLe aree collegate ai giardini sono accessibili anche dal menu Impostazioni.\nCalibrazione organica della dashboard\nUna modalità di calibrazione organica permette:\n• visualizzare la posizione reale delle zone interattive,\n• spostarle semplicemente facendo scorrere il dito.\nPuoi quindi posizionare i tuoi giardini e moduli esattamente dove vuoi sull\'immagine: in alto, in basso o nel posto che più ti aggrada.\nUna volta convalidata, questa organizzazione viene salvata e mantenuta nell\'applicazione.\nCreare un\'aiuola\nIn una scheda giardino:\n• scegli \"Aggiungi un\'aiuola\",\n• indica il suo nome, la sua area e, se necessario, alcune note,\n• salva.\nAggiungere una piantagione\nIn un\'aiuola:\n• premi il pulsante \"+\",\n• scegli una pianta dal catalogo,\n• indica la data, la quantità e informazioni utili,\n• convalida.\n\n4 — La dashboard organica\nLa dashboard è il punto centrale di Sowing.\nPermette:\n• avere una panoramica della tua attività,\n• accedere rapidamente alle funzioni principali,\n• navigare intuitivamente.\nA seconda delle tue impostazioni, alcune bolle possono visualizzare informazioni sintetiche, come il meteo o le attività imminenti.\n\n5 — Giardini, aiuole e piantagioni\nI giardini\nUn giardino rappresenta un luogo reale: orto, serra, frutteto, balcone, ecc.\nPuoi:\n• creare diversi giardini,\n• modificare le loro informazioni,\n• eliminarli se necessario.\nLe aiuole\nUn\'aiuola è una zona precisa all\'interno di un giardino.\nPermette di strutturare lo spazio, organizzare le colture e raggruppare diverse piantagioni nello stesso luogo.\nLe piantagioni\nUna piantagione corrisponde all\'introduzione di una pianta in un\'aiuola, in una data determinata.\nQuando crei una piantagione, Sowing offre due modalità.\nSeminare\nLa modalità \"Seminare\" corrisponde a mettere un seme nel terreno.\nIn questo caso:\n• il progresso inizia allo 0%,\n• viene proposto un monitoraggio passo dopo passo, particolarmente utile per i giardinieri principianti,\n• una barra di avanzamento visualizza il progresso del ciclo colturale.\nQuesto monitoraggio permette di stimare:\n• l\'inizio probabile del periodo di raccolta,\n• l\'evoluzione della coltura nel tempo, in modo semplice e visivo.\nPiantare\nLa modalità \"Piantare\" è destinata a piante già sviluppate (piante da una serra o acquistate in un vivaio).\nIn questo caso:\n• la pianta inizia con un progresso di circa il 30%,\n• il monitoraggio è immediatamente più avanzato,\n• la stima del periodo di raccolta viene adattata di conseguenza.\nScelta della data\nQuando pianti, puoi scegliere liberamente la data.\nQuesto permette ad esempio:\n• riempire una piantagione effettuata in precedenza,\n• correggere una data se l\'applicazione non è stata utilizzata al momento della semina o piantagione.\nPer impostazione predefinita, viene utilizzata la data corrente.\nMonitoraggio e cronologia\nOgni piantagione ha:\n• un monitoraggio del progresso,\n• informazioni sul suo ciclo vitale,\n• fasi colturali,\n• note personali.\nTutte le azioni (semina, piantagione, cura, raccolta) vengono registrate automaticamente nella cronologia del giardino.\n\n6 — Catalogo piante\nIl catalogo raccoglie tutte le piante disponibili durante la creazione di una piantagione.\nCostituisce una base di riferimento scalabile, progettata per coprire gli usi attuali pur rimanendo personalizzabile.\nFunzioni principali:\n• ricerca semplice e rapida,\n• riconoscimento di nomi comuni e scientifici,\n• visualizzazione di foto quando disponibili.\nPiante personalizzate\nPuoi creare le tue piante personalizzate da:\nImpostazioni → Catalogo piante.\nÈ quindi possibile:\n• creare una nuova pianta,\n• riempire i parametri essenziali (nome, tipo, informazioni utili),\n• aggiungere un\'immagine per facilitare l\'identificazione.\nLe piante personalizzate sono quindi utilizzabili come qualsiasi altra pianta nel catalogo.\n\n7 — Calendario e attività\nLa vista calendario\nIl calendario visualizza:\n• attività pianificate,\n• piantagioni importanti,\n• periodi di raccolta stimati.\nCreare un\'attività\nDal calendario:\n• crea una nuova attività,\n• indica un titolo, una data e una descrizione,\n• scegli una possibile ricorrenza.\nLe attività possono essere associate a un giardino o a un\'aiuola.\nGestione delle attività\nPuoi:\n• modificare un\'attività,\n• eliminarla,\n• esportarla per condividerla.\n\n8 — Attività e cronologia\nQuesta sezione costituisce la memoria viva dei tuoi giardini.\nSelezione di un giardino\nDalla dashboard, tieni premuto su un giardino per selezionarlo.\nIl giardino attivo è evidenziato con un alone verde chiaro e un banner di conferma.\nQuesta selezione permette di filtrare le informazioni visualizzate.\nAttività recenti\nLa scheda \"Attività\" visualizza cronologicamente:\n• creazioni,\n• piantagioni,\n• cure,\n• raccolti,\n• azioni manuali.\nCronologia per giardino\nLa scheda \"Cronologia\" presenta la cronologia completa del giardino selezionato, anno dopo anno.\nPermette in particolare:\n• trovare piantagioni passate,\n• verificare se una pianta è già stata coltivata in un determinato luogo,\n• organizzare meglio la rotazione delle colture.\n\n9 — Meteo dell\'aria e meteo del suolo\nMeteo dell\'aria\nIl meteo dell\'aria fornisce informazioni essenziali:\n• temperatura esterna,\n• precipitazioni (pioggia, neve, nessuna pioggia),\n• alternanza giorno / notte.\nQuesti dati aiutano ad anticipare i rischi climatici e ad adattare gli interventi.\nMeteo del suolo\nSowing integra un modulo meteo del suolo.\nL\'utente può inserire una temperatura misurata. Da questi dati, l\'applicazione stima dinamicamente l\'evoluzione della temperatura del suolo nel tempo.\nQuesta informazione permette:\n• sapere quali piante sono realmente coltivabili in un dato momento,\n• adattare la semina alle condizioni reali invece che a un calendario teorico.\nMeteo in tempo reale sulla dashboard\nUn modulo centrale a forma di uovo mostra a colpo d\'occhio:\n• lo stato del cielo,\n• giorno o notte,\n• la fase e posizione della luna per la località selezionata.\nNavigazione nel tempo\nFacendo scorrere il dito da sinistra a destra sull\'uovo, navighi attraverso le previsioni ora per ora, fino a più di 12 ore in anticipo.\nLa temperatura e le precipitazioni si adattano dinamicamente durante il gesto.\n\n10 — Raccomandazioni\nSowing può offrire raccomandazioni adattate alla tua situazione.\nSi basano su:\n• la stagione,\n• il meteo,\n• lo stato delle tue piantagioni.\nOgni raccomandazione specifica:\n• cosa fare,\n• quando agire,\n• perché l\'azione è suggerita.\n\n11 — Esportazione e condivisione\nEsportazione PDF — calendario e attività\nLe attività del calendario possono essere esportate in PDF.\nQuesto permette:\n• condividere informazioni chiare,\n• trasmettere un intervento pianificato,\n• mantenere una traccia leggibile e datata.\nEsportazione Excel — raccolti e statistiche\nI dati di raccolta possono essere esportati in formato Excel per:\n• analizzare i risultati,\n• produrre report,\n• seguire l\'evoluzione nel tempo.\nCondivisione documenti\nI documenti generati possono essere condivisi tramite le applicazioni disponibili sul tuo dispositivo (messaggistica, archiviazione, trasferimento a un computer, ecc.).\n\n12 — Backup e buone pratiche\nI dati sono archiviati localmente sul tuo dispositivo.\nBuone pratiche raccomandate:\n• fare un backup prima di un aggiornamento importante,\n• esportare i tuoi dati regolarmente,\n• mantenere l\'applicazione e il dispositivo aggiornati.\n\n13 — Impostazioni\nIl menu Impostazioni permette di adattare Sowing ai tuoi usi.\nPuoi in particolare:\n• scegliere la lingua,\n• selezionare la tua posizione,\n• accedere al catalogo piante,\n• personalizzare la dashboard.\nPersonalizzazione della dashboard\nÈ possibile:\n• riposizionare ogni modulo,\n• regolare lo spazio visivo,\n• cambiare l\'immagine di sfondo,\n• importare la tua immagine (funzione in arrivo).\nInformazioni legali\nNelle impostazioni, puoi consultare:\n• la guida utente,\n• l\'informativa sulla privacy,\n• i termini di utilizzo.\n\n14 — Domande frequenti\nLe zone tattili non sono ben allineate\nA seconda del telefono o delle impostazioni di visualizzazione, alcune zone possono sembrare spostate.\nUna modalità di calibrazione organica permette:\n• visualizzare le zone tattili,\n• riposizionarle facendole scorrere,\n• salvare la configurazione per il tuo dispositivo.\nPosso usare Sowing offline?\nSì. Sowing funziona offline per la gestione di giardini, piantagioni, attività e cronologia.\nUna connessione viene utilizzata solo:\n• per il recupero dei dati meteo,\n• durante l\'esportazione o la condivisione di documenti.\nNessun altro dato viene trasmesso.\n\n15 — Nota finale\nSowing è progettato come un compagno di giardinaggio: semplice, vivo e scalabile.\nPrenditi il tempo per osservare, annotare e fidarti della tua esperienza tanto quanto dello strumento."),
        "weather_action_retry": MessageLookupByLibrary.simpleMessage("Riprova"),
        "weather_data_gusts": MessageLookupByLibrary.simpleMessage("Raffiche"),
        "weather_data_max": MessageLookupByLibrary.simpleMessage("Max"),
        "weather_data_min": MessageLookupByLibrary.simpleMessage("Min"),
        "weather_data_rain": MessageLookupByLibrary.simpleMessage("Pioggia"),
        "weather_data_speed": MessageLookupByLibrary.simpleMessage("Velocità"),
        "weather_data_sunrise": MessageLookupByLibrary.simpleMessage("Alba"),
        "weather_data_sunset": MessageLookupByLibrary.simpleMessage("Tramonto"),
        "weather_data_wind_max":
            MessageLookupByLibrary.simpleMessage("Vento Max"),
        "weather_error_loading": MessageLookupByLibrary.simpleMessage(
            "Impossibile caricare il meteo"),
        "weather_header_daily_summary":
            MessageLookupByLibrary.simpleMessage("RIEPILOGO GIORNALIERO"),
        "weather_header_next_24h":
            MessageLookupByLibrary.simpleMessage("PROSSIME 24H"),
        "weather_header_precipitations":
            MessageLookupByLibrary.simpleMessage("PRECIPITAZIONI (24h)"),
        "weather_label_astro": MessageLookupByLibrary.simpleMessage("ASTRO"),
        "weather_label_pressure":
            MessageLookupByLibrary.simpleMessage("PRESSIONE"),
        "weather_label_sun": MessageLookupByLibrary.simpleMessage("SOLE"),
        "weather_label_wind": MessageLookupByLibrary.simpleMessage("VENTO"),
        "weather_pressure_high": MessageLookupByLibrary.simpleMessage("Alta"),
        "weather_pressure_low": MessageLookupByLibrary.simpleMessage("Bassa"),
        "weather_provider_credit":
            MessageLookupByLibrary.simpleMessage("Dati forniti da Open-Meteo"),
        "weather_screen_title": MessageLookupByLibrary.simpleMessage("Meteo"),
        "weather_today_label": MessageLookupByLibrary.simpleMessage("Oggi"),
        "wmo_code_0": MessageLookupByLibrary.simpleMessage("Cielo sereno"),
        "wmo_code_1":
            MessageLookupByLibrary.simpleMessage("Prevalentemente sereno"),
        "wmo_code_2":
            MessageLookupByLibrary.simpleMessage("Parzialmente nuvoloso"),
        "wmo_code_3": MessageLookupByLibrary.simpleMessage("Coperto"),
        "wmo_code_45": MessageLookupByLibrary.simpleMessage("Nebbia"),
        "wmo_code_48": MessageLookupByLibrary.simpleMessage("Nebbia con brina"),
        "wmo_code_51":
            MessageLookupByLibrary.simpleMessage("Pioviggine leggera"),
        "wmo_code_53":
            MessageLookupByLibrary.simpleMessage("Pioviggine moderata"),
        "wmo_code_55": MessageLookupByLibrary.simpleMessage("Pioviggine densa"),
        "wmo_code_61": MessageLookupByLibrary.simpleMessage("Pioggia leggera"),
        "wmo_code_63": MessageLookupByLibrary.simpleMessage("Pioggia moderata"),
        "wmo_code_65": MessageLookupByLibrary.simpleMessage("Pioggia forte"),
        "wmo_code_66":
            MessageLookupByLibrary.simpleMessage("Pioggia gelata leggera"),
        "wmo_code_67":
            MessageLookupByLibrary.simpleMessage("Pioggia gelata forte"),
        "wmo_code_71": MessageLookupByLibrary.simpleMessage("Nevicata leggera"),
        "wmo_code_73":
            MessageLookupByLibrary.simpleMessage("Nevicata moderata"),
        "wmo_code_75": MessageLookupByLibrary.simpleMessage("Nevicata forte"),
        "wmo_code_77": MessageLookupByLibrary.simpleMessage("Granelli di neve"),
        "wmo_code_80":
            MessageLookupByLibrary.simpleMessage("Rovesci di pioggia leggeri"),
        "wmo_code_81":
            MessageLookupByLibrary.simpleMessage("Rovesci di pioggia moderati"),
        "wmo_code_82":
            MessageLookupByLibrary.simpleMessage("Rovesci di pioggia violenti"),
        "wmo_code_85":
            MessageLookupByLibrary.simpleMessage("Rovesci di neve leggeri"),
        "wmo_code_86":
            MessageLookupByLibrary.simpleMessage("Rovesci di neve forti"),
        "wmo_code_95": MessageLookupByLibrary.simpleMessage("Temporale"),
        "wmo_code_96": MessageLookupByLibrary.simpleMessage(
            "Temporale con grandine leggera"),
        "wmo_code_99": MessageLookupByLibrary.simpleMessage(
            "Temporale con grandine forte"),
        "wmo_code_unknown":
            MessageLookupByLibrary.simpleMessage("Condizioni sconosciute")
      };
}
