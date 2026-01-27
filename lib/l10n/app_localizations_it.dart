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
  String get garden_creation_dialog_title => 'Crea il tuo primo giardino';

  @override
  String get garden_creation_dialog_description =>
      'Dai un nome al tuo spazio di permacultura per iniziare.';

  @override
  String get garden_creation_name_label => 'Nome del giardino';

  @override
  String get garden_creation_name_hint => 'Es: Il mio Orto';

  @override
  String get garden_creation_name_required => 'Il nome è obbligatorio';

  @override
  String get garden_creation_create_button => 'Crea';

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
  String get settings_commune_title => 'Posizione per il meteo';

  @override
  String get settings_choose_commune => 'Scegli posizione';

  @override
  String get settings_search_commune_hint => 'Cerca una località...';

  @override
  String settings_commune_default(String label) {
    return 'Predefinito: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Selezionato: $label';
  }

  @override
  String get settings_quick_access => 'Accesso rapido';

  @override
  String get settings_plants_catalog => 'Catalogo piante';

  @override
  String get settings_plants_catalog_subtitle => 'Cerca e visualizza piante';

  @override
  String get settings_about => 'Informazioni';

  @override
  String get settings_user_guide => 'Guida utente';

  @override
  String get settings_user_guide_subtitle => 'Leggi il manuale';

  @override
  String get settings_privacy => 'Privacy';

  @override
  String get settings_privacy_policy => 'Informativa sulla privacy';

  @override
  String get settings_terms => 'Termini di utilizzo';

  @override
  String get settings_version_dialog_title => 'Versione app';

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
      'Personalizza la visualizzazione della tua dashboard';

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
  String get garden_error_title => 'Errore di caricamento';

  @override
  String garden_error_subtitle(String error) {
    return 'Impossibile caricare l\'elenco dei giardini: $error';
  }

  @override
  String get garden_retry => 'Riprova';

  @override
  String get garden_no_gardens => 'Nessun giardino ancora.';

  @override
  String get garden_archived_info =>
      'Hai giardini archiviati. Attiva la visualizzazione dei giardini archiviati per vederli.';

  @override
  String get garden_add_tooltip => 'Aggiungi giardino';

  @override
  String get plant_catalog_title => 'Catalogo piante';

  @override
  String get plant_catalog_search_hint => 'Cerca una pianta...';

  @override
  String get plant_custom_badge => 'Personalizzato';

  @override
  String get plant_detail_not_found_title => 'Pianta non trovata';

  @override
  String get plant_detail_not_found_body =>
      'Questa pianta non esiste o non è stato possibile caricarla.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant aggiunta ai preferiti';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Aggiungi al giardino';

  @override
  String get plant_detail_popup_share => 'Condividi';

  @override
  String get plant_detail_share_todo => 'Condivisione non ancora implementata';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Aggiunta al giardino non ancora implementata';

  @override
  String get plant_detail_section_culture => 'Dettagli colturali';

  @override
  String get plant_detail_section_instructions => 'Istruzioni generali';

  @override
  String get plant_detail_detail_family => 'Famiglia';

  @override
  String get plant_detail_detail_maturity => 'Tempo di maturazione';

  @override
  String get plant_detail_detail_spacing => 'Spaziatura';

  @override
  String get plant_detail_detail_exposure => 'Esposizione';

  @override
  String get plant_detail_detail_water => 'Fabbisogno idrico';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Piantagioni - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Statistiche';

  @override
  String get planting_menu_ready_for_harvest => 'Pronto per il raccolto';

  @override
  String get planting_menu_test_data => 'Dati di prova';

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
  String get planting_stat_success_rate => 'Tasso di successo';

  @override
  String get planting_stat_in_growth => 'In crescita';

  @override
  String get planting_stat_ready_for_harvest => 'Pronto per il raccolto';

  @override
  String get planting_empty_none => 'Nessuna piantagione';

  @override
  String get planting_empty_first =>
      'Aggiungi la tua prima piantagione in questa aiuola.';

  @override
  String get planting_create_action => 'Crea piantagione';

  @override
  String get planting_empty_no_result => 'Nessun risultato';

  @override
  String get planting_clear_filters => 'Cancella filtri';

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
  String get error_page_back => 'Torna alla home';

  @override
  String get dialog_confirm => 'Conferma';

  @override
  String get dialog_cancel => 'Annulla';

  @override
  String snackbar_commune_selected(String name) {
    return 'Posizione selezionata: $name';
  }

  @override
  String get common_validate => 'Convalida';

  @override
  String get common_cancel => 'Annulla';

  @override
  String get common_save => 'Salva';

  @override
  String get empty_action_create => 'Crea';

  @override
  String get user_guide_text =>
      '1 — Benvenuto in Sowing\nSowing è un\'applicazione progettata per supportare i giardinieri nel monitoraggio vivo e concreto delle loro colture.\nTi permette di:\n• organizzare i tuoi giardini e aiuole,\n• seguire le tue piantagioni durante il loro ciclo di vita,\n• pianificare i tuoi compiti al momento giusto,\n• mantenere un ricordo di ciò che è stato fatto,\n• tenere conto del meteo locale e del ritmo delle stagioni.\nL\'applicazione funziona principalmente offline e conserva i tuoi dati direttamente sul tuo dispositivo.\nQuesto manuale descrive l\'uso comune di Sowing: primi passi, creazione di giardini, piantagioni, calendario, meteo, esportazione dati e buone pratiche.\n\n2 — Comprendere l\'interfaccia\nLa dashboard\nAll\'apertura, Sowing mostra una dashboard visiva e organica.\nPrende la forma di un\'immagine di sfondo animata da bolle interattive. Ogni bolla dà accesso a una funzione principale dell\'applicazione:\n• giardini,\n• meteo dell\'aria,\n• meteo del suolo,\n• calendario,\n• attività,\n• statistiche,\n• impostazioni.\nNavigazione generale\nTocca semplicemente una bolla per aprire la sezione corrispondente.\nAll\'interno delle pagine, troverai a seconda del contesto:\n• menu contestuali,\n• pulsanti \"+\" per aggiungere un elemento,\n• pulsanti di modifica o eliminazione.\n\n3 — Avvio rapido\nAprire l\'applicazione\nAll\'avvio, la dashboard viene visualizzata automaticamente.\nConfigurare il meteo\nNelle impostazioni, scegli la tua posizione.\nQuesta informazione consente a Sowing di visualizzare il meteo locale adattato al tuo giardino. Se nessuna posizione è selezionata, ne viene usata una predefinita.\nCreare il tuo primo giardino\nAl primo utilizzo, Sowing ti guida automaticamente per creare il tuo primo giardino.\nPuoi anche creare un giardino manualmente dalla dashboard.\nNella schermata principale, tocca la foglia verde situata nell\'area più libera, a destra delle statistiche e leggermente in alto. Questa zona deliberatamente discreta ti permette di avviare la creazione di un giardino.\nPuoi creare fino a cinque giardini.\nQuesto approccio fa parte dell\'esperienza Sowing: non c\'è un pulsante \"+\" permanente e centrale. L\'applicazione invita piuttosto all\'esplorazione e alla scoperta progressiva dello spazio.\nLe aree collegate ai giardini sono accessibili anche dal menu Impostazioni.\nCalibrazione organica della dashboard\nUna modalità di calibrazione organica permette:\n• visualizzare la posizione reale delle zone interattive,\n• spostarle semplicemente facendo scorrere il dito.\nPuoi quindi posizionare i tuoi giardini e moduli esattamente dove vuoi sull\'immagine: in alto, in basso o nel posto che più ti aggrada.\nUna volta convalidata, questa organizzazione viene salvata e mantenuta nell\'applicazione.\nCreare un\'aiuola\nIn una scheda giardino:\n• scegli \"Aggiungi un\'aiuola\",\n• indica il suo nome, la sua area e, se necessario, alcune note,\n• salva.\nAggiungere una piantagione\nIn un\'aiuola:\n• premi il pulsante \"+\",\n• scegli una pianta dal catalogo,\n• indica la data, la quantità e informazioni utili,\n• convalida.\n\n4 — La dashboard organica\nLa dashboard è il punto centrale di Sowing.\nPermette:\n• avere una panoramica della tua attività,\n• accedere rapidamente alle funzioni principali,\n• navigare intuitivamente.\nA seconda delle tue impostazioni, alcune bolle possono visualizzare informazioni sintetiche, come il meteo o le attività imminenti.\n\n5 — Giardini, aiuole e piantagioni\nI giardini\nUn giardino rappresenta un luogo reale: orto, serra, frutteto, balcone, ecc.\nPuoi:\n• creare diversi giardini,\n• modificare le loro informazioni,\n• eliminarli se necessario.\nLe aiuole\nUn\'aiuola è una zona precisa all\'interno di un giardino.\nPermette di strutturare lo spazio, organizzare le colture e raggruppare diverse piantagioni nello stesso luogo.\nLe piantagioni\nUna piantagione corrisponde all\'introduzione di una pianta in un\'aiuola, in una data determinata.\nQuando crei una piantagione, Sowing offre due modalità.\nSeminare\nLa modalità \"Seminare\" corrisponde a mettere un seme nel terreno.\nIn questo caso:\n• il progresso inizia allo 0%,\n• viene proposto un monitoraggio passo dopo passo, particolarmente utile per i giardinieri principianti,\n• una barra di avanzamento visualizza il progresso del ciclo colturale.\nQuesto monitoraggio permette di stimare:\n• l\'inizio probabile del periodo di raccolta,\n• l\'evoluzione della coltura nel tempo, in modo semplice e visivo.\nPiantare\nLa modalità \"Piantare\" è destinata a piante già sviluppate (piante da una serra o acquistate in un vivaio).\nIn questo caso:\n• la pianta inizia con un progresso di circa il 30%,\n• il monitoraggio è immediatamente più avanzato,\n• la stima del periodo di raccolta viene adattata di conseguenza.\nScelta della data\nQuando pianti, puoi scegliere liberamente la data.\nQuesto permette ad esempio:\n• riempire una piantagione effettuata in precedenza,\n• correggere una data se l\'applicazione non è stata utilizzata al momento della semina o piantagione.\nPer impostazione predefinita, viene utilizzata la data corrente.\nMonitoraggio e cronologia\nOgni piantagione ha:\n• un monitoraggio del progresso,\n• informazioni sul suo ciclo vitale,\n• fasi colturali,\n• note personali.\nTutte le azioni (semina, piantagione, cura, raccolta) vengono registrate automaticamente nella cronologia del giardino.\n\n6 — Catalogo piante\nIl catalogo raccoglie tutte le piante disponibili durante la creazione di una piantagione.\nCostituisce una base di riferimento scalabile, progettata per coprire gli usi attuali pur rimanendo personalizzabile.\nFunzioni principali:\n• ricerca semplice e rapida,\n• riconoscimento di nomi comuni e scientifici,\n• visualizzazione di foto quando disponibili.\nPiante personalizzate\nPuoi creare le tue piante personalizzate da:\nImpostazioni → Catalogo piante.\nÈ quindi possibile:\n• creare una nuova pianta,\n• riempire i parametri essenziali (nome, tipo, informazioni utili),\n• aggiungere un\'immagine per facilitare l\'identificazione.\nLe piante personalizzate sono quindi utilizzabili come qualsiasi altra pianta nel catalogo.\n\n7 — Calendario e attività\nLa vista calendario\nIl calendario visualizza:\n• attività pianificate,\n• piantagioni importanti,\n• periodi di raccolta stimati.\nCreare un\'attività\nDal calendario:\n• crea una nuova attività,\n• indica un titolo, una data e una descrizione,\n• scegli una possibile ricorrenza.\nLe attività possono essere associate a un giardino o a un\'aiuola.\nGestione delle attività\nPuoi:\n• modificare un\'attività,\n• eliminarla,\n• esportarla per condividerla.\n\n8 — Attività e cronologia\nQuesta sezione costituisce la memoria viva dei tuoi giardini.\nSelezione di un giardino\nDalla dashboard, tieni premuto su un giardino per selezionarlo.\nIl giardino attivo è evidenziato con un alone verde chiaro e un banner di conferma.\nQuesta selezione permette di filtrare le informazioni visualizzate.\nAttività recenti\nLa scheda \"Attività\" visualizza cronologicamente:\n• creazioni,\n• piantagioni,\n• cure,\n• raccolti,\n• azioni manuali.\nCronologia per giardino\nLa scheda \"Cronologia\" presenta la cronologia completa del giardino selezionato, anno dopo anno.\nPermette in particolare:\n• trovare piantagioni passate,\n• verificare se una pianta è già stata coltivata in un determinato luogo,\n• organizzare meglio la rotazione delle colture.\n\n9 — Meteo dell\'aria e meteo del suolo\nMeteo dell\'aria\nIl meteo dell\'aria fornisce informazioni essenziali:\n• temperatura esterna,\n• precipitazioni (pioggia, neve, nessuna pioggia),\n• alternanza giorno / notte.\nQuesti dati aiutano ad anticipare i rischi climatici e ad adattare gli interventi.\nMeteo del suolo\nSowing integra un modulo meteo del suolo.\nL\'utente può inserire una temperatura misurata. Da questi dati, l\'applicazione stima dinamicamente l\'evoluzione della temperatura del suolo nel tempo.\nQuesta informazione permette:\n• sapere quali piante sono realmente coltivabili in un dato momento,\n• adattare la semina alle condizioni reali invece che a un calendario teorico.\nMeteo in tempo reale sulla dashboard\nUn modulo centrale a forma di uovo mostra a colpo d\'occhio:\n• lo stato del cielo,\n• giorno o notte,\n• la fase e posizione della luna per la località selezionata.\nNavigazione nel tempo\nFacendo scorrere il dito da sinistra a destra sull\'uovo, navighi attraverso le previsioni ora per ora, fino a più di 12 ore in anticipo.\nLa temperatura e le precipitazioni si adattano dinamicamente durante il gesto.\n\n10 — Raccomandazioni\nSowing può offrire raccomandazioni adattate alla tua situazione.\nSi basano su:\n• la stagione,\n• il meteo,\n• lo stato delle tue piantagioni.\nOgni raccomandazione specifica:\n• cosa fare,\n• quando agire,\n• perché l\'azione è suggerita.\n\n11 — Esportazione e condivisione\nEsportazione PDF — calendario e attività\nLe attività del calendario possono essere esportate in PDF.\nQuesto permette:\n• condividere informazioni chiare,\n• trasmettere un intervento pianificato,\n• mantenere una traccia leggibile e datata.\nEsportazione Excel — raccolti e statistiche\nI dati di raccolta possono essere esportati in formato Excel per:\n• analizzare i risultati,\n• produrre report,\n• seguire l\'evoluzione nel tempo.\nCondivisione documenti\nI documenti generati possono essere condivisi tramite le applicazioni disponibili sul tuo dispositivo (messaggistica, archiviazione, trasferimento a un computer, ecc.).\n\n12 — Backup e buone pratiche\nI dati sono archiviati localmente sul tuo dispositivo.\nBuone pratiche raccomandate:\n• fare un backup prima di un aggiornamento importante,\n• esportare i tuoi dati regolarmente,\n• mantenere l\'applicazione e il dispositivo aggiornati.\n\n13 — Impostazioni\nIl menu Impostazioni permette di adattare Sowing ai tuoi usi.\nPuoi in particolare:\n• scegliere la lingua,\n• selezionare la tua posizione,\n• accedere al catalogo piante,\n• personalizzare la dashboard.\nPersonalizzazione della dashboard\nÈ possibile:\n• riposizionare ogni modulo,\n• regolare lo spazio visivo,\n• cambiare l\'immagine di sfondo,\n• importare la tua immagine (funzione in arrivo).\nInformazioni legali\nNelle impostazioni, puoi consultare:\n• la guida utente,\n• l\'informativa sulla privacy,\n• i termini di utilizzo.\n\n14 — Domande frequenti\nLe zone tattili non sono ben allineate\nA seconda del telefono o delle impostazioni di visualizzazione, alcune zone possono sembrare spostate.\nUna modalità di calibrazione organica permette:\n• visualizzare le zone tattili,\n• riposizionarle facendole scorrere,\n• salvare la configurazione per il tuo dispositivo.\nPosso usare Sowing offline?\nSì. Sowing funziona offline per la gestione di giardini, piantagioni, attività e cronologia.\nUna connessione viene utilizzata solo:\n• per il recupero dei dati meteo,\n• durante l\'esportazione o la condivisione di documenti.\nNessun altro dato viene trasmesso.\n\n15 — Nota finale\nSowing è progettato come un compagno di giardinaggio: semplice, vivo e scalabile.\nPrenditi il tempo per osservare, annotare e fidarti della tua esperienza tanto quanto dello strumento.';

  @override
  String get privacy_policy_text =>
      'Sowing rispetta pienamente la tua privacy.\n\n• Tutti i dati sono archiviati localmente sul tuo dispositivo\n• Nessun dato personale viene trasmesso a terzi\n• Nessuna informazione viene archiviata su un server esterno\n\nL\'applicazione funziona completamente offline. Una connessione Internet viene utilizzata solo per recuperare i dati meteo o durante le esportazioni.';

  @override
  String get terms_text =>
      'Utilizzando Sowing, accetti di:\n\n• Utilizzare l\'applicazione in modo responsabile\n• Non tentare di aggirare le sue limitazioni\n• Rispettare i diritti di proprietà intellettuale\n• Utilizzare solo i tuoi dati\n\nQuesta applicazione è fornita così com\'è, senza garanzia.\n\nIl team di Sowing rimane aperto a qualsiasi miglioramento o evoluzione futura.';

  @override
  String get calibration_auto_apply =>
      'Applica automaticamente per questo dispositivo';

  @override
  String get calibration_calibrate_now => 'Calibra ora';

  @override
  String get calibration_save_profile =>
      'Salva calibrazione attuale come profilo';

  @override
  String get calibration_export_profile => 'Esporta profilo (copia JSON)';

  @override
  String get calibration_import_profile => 'Importa profilo dagli appunti';

  @override
  String get calibration_reset_profile =>
      'Reimposta profilo per questo dispositivo';

  @override
  String get calibration_refresh_profile => 'Aggiorna anteprima profilo';

  @override
  String calibration_key_device(String key) {
    return 'Chiave dispositivo: $key';
  }

  @override
  String get calibration_no_profile =>
      'Nessun profilo salvato per questo dispositivo.';

  @override
  String get calibration_image_settings_title =>
      'Impostazioni Immagine di Sfondo (Persistente)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image => 'Reimposta valori predefiniti immagine';

  @override
  String get calibration_dialog_confirm_title => 'Conferma';

  @override
  String get calibration_dialog_delete_profile =>
      'Eliminare profilo di calibrazione per questo dispositivo?';

  @override
  String get calibration_action_delete => 'Elimina';

  @override
  String get calibration_snack_no_profile =>
      'Nessun profilo trovato per questo dispositivo.';

  @override
  String get calibration_snack_profile_copied =>
      'Profilo copiato negli appunti.';

  @override
  String get calibration_snack_clipboard_empty => 'Appunti vuoti.';

  @override
  String get calibration_snack_profile_imported =>
      'Profilo importato e salvato per questo dispositivo.';

  @override
  String calibration_snack_import_error(String error) {
    return 'Errore importazione JSON: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Profilo eliminato per questo dispositivo.';

  @override
  String get calibration_snack_no_calibration =>
      'Nessuna calibrazione salvata. Calibra dalla dashboard prima.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Calibrazione attuale salvata come profilo per questo dispositivo.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Errore durante il salvataggio: $error';
  }

  @override
  String get calibration_overlay_saved => 'Calibrazione salvata';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Errore salvataggio calibrazione: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Trascina per spostare, pizzica per zoomare l\'immagine di sfondo.';

  @override
  String get calibration_instruction_sky =>
      'Regola l\'uovo giorno/notte (centro, dimensione, rotazione).';

  @override
  String get calibration_instruction_modules =>
      'Sposta i moduli (bolle) nella posizione desiderata.';

  @override
  String get calibration_instruction_none =>
      'Seleziona uno strumento per iniziare.';

  @override
  String get calibration_tool_image => 'Immagine';

  @override
  String get calibration_tool_sky => 'Cielo';

  @override
  String get calibration_tool_modules => 'Moduli';

  @override
  String get calibration_action_validate_exit => 'Convalida ed Esci';

  @override
  String get garden_management_create_title => 'Crea Giardino';

  @override
  String get garden_management_edit_title => 'Modifica Giardino';

  @override
  String get garden_management_name_label => 'Nome Giardino';

  @override
  String get garden_management_desc_label => 'Descrizione';

  @override
  String get garden_management_image_label => 'Immagine Giardino (Opzionale)';

  @override
  String get garden_management_image_url_label => 'URL Immagine';

  @override
  String get garden_management_image_preview_error =>
      'Impossibile caricare immagine';

  @override
  String get garden_management_create_submit => 'Crea Giardino';

  @override
  String get garden_management_create_submitting => 'Creazione...';

  @override
  String get garden_management_created_success =>
      'Giardino creato con successo';

  @override
  String get garden_management_create_error => 'Creazione giardino fallita';

  @override
  String get garden_management_delete_confirm_title => 'Elimina Giardino';

  @override
  String get garden_management_delete_confirm_body =>
      'Sei sicuro di voler eliminare questo giardino? Questo eliminerà anche tutte le aiuole e le piantagioni associate. Questa azione è irreversibile.';

  @override
  String get garden_management_delete_success =>
      'Giardino eliminato con successo';

  @override
  String get garden_management_archived_tag => 'Giardino Archiviato';

  @override
  String get garden_management_beds_title => 'Aiuole del Giardino';

  @override
  String get garden_management_no_beds_title => 'Nessuna Aiuola';

  @override
  String get garden_management_no_beds_desc =>
      'Crea aiuole per organizzare le tue piantagioni';

  @override
  String get garden_management_add_bed_label => 'Crea Aiuola';

  @override
  String get garden_management_stats_beds => 'Aiuole';

  @override
  String get garden_management_stats_area => 'Area Totale';

  @override
  String get dashboard_weather_stats => 'Dettagli Meteo';

  @override
  String get dashboard_soil_temp => 'Temp. Suolo';

  @override
  String get dashboard_air_temp => 'Temperatura';

  @override
  String get dashboard_statistics => 'Statistiche';

  @override
  String get dashboard_calendar => 'Calendario';

  @override
  String get dashboard_activities => 'Attività';

  @override
  String get dashboard_weather => 'Meteo';

  @override
  String get dashboard_settings => 'Impostazioni';

  @override
  String dashboard_garden_n(int number) {
    return 'Giardino $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Giardino \"$name\" creato con successo';
  }

  @override
  String get dashboard_garden_create_error => 'Errore creazione giardino.';

  @override
  String get calendar_title => 'Calendario di coltivazione';

  @override
  String get calendar_refreshed => 'Calendario aggiornato';

  @override
  String get calendar_new_task_tooltip => 'Nuova Attività';

  @override
  String get calendar_task_saved_title => 'Attività salvata';

  @override
  String get calendar_ask_export_pdf => 'Vuoi inviarlo come PDF?';

  @override
  String get calendar_task_modified => 'Attività modificata';

  @override
  String get calendar_delete_confirm_title => 'Eliminare attività?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" verrà eliminata.';
  }

  @override
  String get calendar_task_deleted => 'Attività eliminata';

  @override
  String calendar_restore_error(Object error) {
    return 'Errore ripristino: $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Errore eliminazione: $error';
  }

  @override
  String get calendar_action_assign => 'Invia / Assegna a...';

  @override
  String get calendar_assign_title => 'Assegna / Invia';

  @override
  String get calendar_assign_hint => 'Inserisci nome o email';

  @override
  String get calendar_assign_field => 'Nome o Email';

  @override
  String calendar_task_assigned(String name) {
    return 'Attività assegnata a $name';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Errore assegnazione: $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'Errore esportazione PDF: $error';
  }

  @override
  String get calendar_previous_month => 'Mese precedente';

  @override
  String get calendar_next_month => 'Mese successivo';

  @override
  String get calendar_limit_reached => 'Limite raggiunto';

  @override
  String get calendar_drag_instruction => 'Scorri per navigare';

  @override
  String get common_refresh => 'Aggiorna';

  @override
  String get common_yes => 'Sì';

  @override
  String get common_no => 'No';

  @override
  String get common_delete => 'Elimina';

  @override
  String get common_edit => 'Modifica';

  @override
  String get common_undo => 'Annulla';

  @override
  String common_error_prefix(Object error) {
    return 'Errore: $error';
  }

  @override
  String get common_retry => 'Riprova';

  @override
  String get calendar_no_events => 'Nessun evento oggi';

  @override
  String calendar_events_of(String date) {
    return 'Eventi del $date';
  }

  @override
  String get calendar_section_plantings => 'Piantagioni';

  @override
  String get calendar_section_harvests => 'Raccolti previsti';

  @override
  String get calendar_section_tasks => 'Attività programmate';

  @override
  String get calendar_filter_tasks => 'Attività';

  @override
  String get calendar_filter_maintenance => 'Manutenzione';

  @override
  String get calendar_filter_harvests => 'Raccolti';

  @override
  String get calendar_filter_urgent => 'Urgente';

  @override
  String get common_general_error => 'Si è verificato un errore';

  @override
  String get common_error => 'Errore';

  @override
  String get settings_backup_restore_section => 'Sauvegarde et Restauration';

  @override
  String get settings_backup_restore_subtitle =>
      'Sauvegarde intégrale de vos données';

  @override
  String get settings_backup_action => 'Créer une sauvegarde';

  @override
  String get settings_restore_action => 'Restaurer une sauvegarde';

  @override
  String get settings_backup_creating =>
      'Création de la sauvegarde en cours...';

  @override
  String get settings_backup_success => 'Sauvegarde créée avec succès !';

  @override
  String get settings_restore_warning_title => 'Attention';

  @override
  String get settings_restore_warning_content =>
      'La restauration d\'une sauvegarde écrasera TOUTES les données actuelles (jardins, plantations, réglages). Cette action est irréversible. L\'application devra redémarrer.\n\nÊtes-vous sûr de vouloir continuer ?';

  @override
  String get settings_restore_success =>
      'Restauration réussie ! Veuillez redémarrer l\'application.';

  @override
  String settings_backup_error(Object error) {
    return 'Échec de la sauvegarde : $error';
  }

  @override
  String settings_restore_error(Object error) {
    return 'Échec de la restauration : $error';
  }

  @override
  String get task_editor_title_new => 'Nuova Attività';

  @override
  String get task_editor_title_edit => 'Modifica Attività';

  @override
  String get task_editor_title_field => 'Titolo *';

  @override
  String get activity_screen_title => 'Attività e Cronologia';

  @override
  String activity_tab_recent_garden(String gardenName) {
    return 'Recente ($gardenName)';
  }

  @override
  String get activity_tab_recent_global => 'Recente (Globale)';

  @override
  String get activity_tab_history => 'Cronologia';

  @override
  String get activity_history_section_title => 'Cronologia — ';

  @override
  String get activity_history_empty =>
      'Nessun giardino selezionato.\nPer vedere la cronologia di un giardino, premi a lungo su di esso nella dashboard.';

  @override
  String get activity_empty_title => 'Nessuna attività trovata';

  @override
  String get activity_empty_subtitle =>
      'Le attività di giardinaggio appariranno qui';

  @override
  String get activity_error_loading => 'Errore caricamento attività';

  @override
  String get activity_priority_important => 'Importante';

  @override
  String get activity_priority_normal => 'Normale';

  @override
  String get activity_time_just_now => 'Proprio ora';

  @override
  String activity_time_minutes_ago(int minutes) {
    return '$minutes min fa';
  }

  @override
  String activity_time_hours_ago(int hours) {
    return '$hours ore fa';
  }

  @override
  String activity_time_days_ago(int count) {
    return '$count giorni fa';
  }

  @override
  String activity_metadata_garden(String name) {
    return 'Giardino: $name';
  }

  @override
  String activity_metadata_bed(String name) {
    return 'Aiuola: $name';
  }

  @override
  String activity_metadata_plant(String name) {
    return 'Pianta: $name';
  }

  @override
  String activity_metadata_quantity(String quantity) {
    return 'Quantità: $quantity';
  }

  @override
  String activity_metadata_date(String date) {
    return 'Data: $date';
  }

  @override
  String activity_metadata_maintenance(String type) {
    return 'Manutenzione: $type';
  }

  @override
  String activity_metadata_weather(String weather) {
    return 'Meteo: $weather';
  }

  @override
  String get task_editor_error_title_required => 'Obbligatorio';

  @override
  String get history_hint_title => 'Per vedere la cronologia di un giardino';

  @override
  String get history_hint_body =>
      'Selezionalo premendo a lungo nella dashboard.';

  @override
  String get history_hint_action => 'Vai alla dashboard';

  @override
  String activity_desc_garden_created(String name) {
    return 'Giardino \"$name\" creato';
  }

  @override
  String activity_desc_bed_created(String name) {
    return 'Aiuola \"$name\" creata';
  }

  @override
  String activity_desc_planting_created(String name) {
    return 'Piantagione di \"$name\" aggiunta';
  }

  @override
  String activity_desc_germination(String name) {
    return 'Germinazione di \"$name\" confermata';
  }

  @override
  String activity_desc_harvest(String name) {
    return 'Raccolto di \"$name\" registrato';
  }

  @override
  String activity_desc_maintenance(String type) {
    return 'Manutenzione: $type';
  }

  @override
  String activity_desc_garden_deleted(String name) {
    return 'Giardino \"$name\" eliminato';
  }

  @override
  String activity_desc_bed_deleted(String name) {
    return 'Aiuola \"$name\" eliminata';
  }

  @override
  String activity_desc_planting_deleted(String name) {
    return 'Piantagione di \"$name\" eliminata';
  }

  @override
  String activity_desc_garden_updated(String name) {
    return 'Giardino \"$name\" aggiornato';
  }

  @override
  String activity_desc_bed_updated(String name) {
    return 'Aiuola \"$name\" aggiornata';
  }

  @override
  String activity_desc_planting_updated(String name) {
    return 'Piantagione di \"$name\" aggiornata';
  }

  @override
  String get planting_steps_title => 'Passo dopo passo';

  @override
  String get planting_steps_add_button => 'Aggiungi';

  @override
  String get planting_steps_see_less => 'Vedi meno';

  @override
  String get planting_steps_see_all => 'Vedi tutto';

  @override
  String get planting_steps_empty => 'Nessun passaggio consigliato';

  @override
  String planting_steps_more(int count) {
    return '+ $count altri passaggi';
  }

  @override
  String get planting_steps_prediction_badge => 'Previsione';

  @override
  String planting_steps_date_prefix(String date) {
    return 'Il $date';
  }

  @override
  String get planting_steps_done => 'Fatto';

  @override
  String get planting_steps_mark_done => 'Segna come fatto';

  @override
  String get planting_steps_dialog_title => 'Aggiungi Passaggio';

  @override
  String get planting_steps_dialog_hint => 'Es: Pacciamatura leggera';

  @override
  String get planting_steps_dialog_add => 'Aggiungi';

  @override
  String get planting_status_sown => 'Seminato';

  @override
  String get planting_status_planted => 'Piantato';

  @override
  String get planting_status_growing => 'In crescita';

  @override
  String get planting_status_ready => 'Pronto per il raccolto';

  @override
  String get planting_status_harvested => 'Raccolto';

  @override
  String get planting_status_failed => 'Fallito';

  @override
  String planting_card_sown_date(String date) {
    return 'Seminato il $date';
  }

  @override
  String planting_card_planted_date(String date) {
    return 'Piantato il $date';
  }

  @override
  String planting_card_harvest_estimate(String date) {
    return 'Stima raccolto: $date';
  }

  @override
  String get planting_info_title => 'Info Botaniche';

  @override
  String get planting_info_tips_title => 'Consigli di Coltivazione';

  @override
  String get planting_info_maturity => 'Maturità';

  @override
  String planting_info_days(Object days) {
    return '$days giorni';
  }

  @override
  String get planting_info_spacing => 'Spaziatura';

  @override
  String planting_info_cm(Object cm) {
    return '$cm cm';
  }

  @override
  String get planting_info_depth => 'Profondità';

  @override
  String get planting_info_exposure => 'Esposizione';

  @override
  String get planting_info_water => 'Acqua';

  @override
  String get planting_info_season => 'Stagione di semina';

  @override
  String get planting_info_scientific_name_none =>
      'Nome scientifico non disponibile';

  @override
  String get planting_info_culture_title => 'Info Colturali';

  @override
  String get planting_info_germination => 'Tempo di germinazione';

  @override
  String get planting_info_harvest_time => 'Tempo di raccolta';

  @override
  String get planting_info_none => 'Non specificato';

  @override
  String get planting_tips_none => 'Nessun consiglio disponibile';

  @override
  String get planting_history_title => 'Cronologia azioni';

  @override
  String get planting_history_action_planting => 'Piantagione';

  @override
  String get planting_history_todo => 'Cronologia dettagliata in arrivo';

  @override
  String get task_editor_garden_all => 'Tutti i Giardini';

  @override
  String get task_editor_zone_label => 'Zona (Aiuola)';

  @override
  String get task_editor_zone_none => 'Nessuna zona specifica';

  @override
  String get task_editor_zone_empty => 'Nessuna aiuola per questo giardino';

  @override
  String get task_editor_description_label => 'Descrizione';

  @override
  String get task_editor_date_label => 'Data di Inizio';

  @override
  String get task_editor_time_label => 'Ora';

  @override
  String get task_editor_duration_label => 'Durata Stimata';

  @override
  String get task_editor_duration_other => 'Altro';

  @override
  String get task_editor_type_label => 'Tipo di Attività';

  @override
  String get task_editor_priority_label => 'Priorità';

  @override
  String get task_editor_urgent_label => 'Urgente';

  @override
  String get task_editor_option_none => 'Nessuno (Salva Solo)';

  @override
  String get task_editor_option_share => 'Condividi (Testo)';

  @override
  String get task_editor_option_pdf => 'Esporta — PDF';

  @override
  String get task_editor_option_docx => 'Esporta — Word (.docx)';

  @override
  String get task_editor_export_label => 'Output / Condividi';

  @override
  String get task_editor_photo_placeholder => 'Aggiungi Foto (Presto)';

  @override
  String get task_editor_action_create => 'Crea';

  @override
  String get task_editor_action_save => 'Salva';

  @override
  String get task_editor_action_cancel => 'Annulla';

  @override
  String get task_editor_assignee_label => 'Assegnato a';

  @override
  String task_editor_assignee_add(String name) {
    return 'Aggiungi \"$name\" ai preferiti';
  }

  @override
  String get task_editor_assignee_none => 'Nessun risultato.';

  @override
  String get task_editor_recurrence_label => 'Ricorrenza';

  @override
  String get task_editor_recurrence_none => 'Nessuna';

  @override
  String get task_editor_recurrence_interval => 'Ogni X giorni';

  @override
  String get task_editor_recurrence_weekly => 'Settimanalmente (Giorni)';

  @override
  String get task_editor_recurrence_monthly => 'Mensilmente (stesso giorno)';

  @override
  String get task_editor_recurrence_repeat_label => 'Ripeti ogni ';

  @override
  String get task_editor_recurrence_days_suffix => ' g';

  @override
  String get task_kind_generic => 'Generico';

  @override
  String get task_kind_repair => 'Riparazione 🛠️';

  @override
  String get soil_temp_title => 'Temperatura del Suolo';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Errore grafico: $error';
  }

  @override
  String get soil_temp_about_title => 'Info Temp. Suolo';

  @override
  String get soil_temp_about_content =>
      'La temperatura del suolo visualizzata qui è stimata dall\'app in base a dati climatici e stagionali, secondo la seguente formula:\n\nQuesta stima fornisce una tendenza realistica della temperatura del suolo quando non sono disponibili misurazioni dirette.';

  @override
  String get soil_temp_formula_label => 'Formula di calcolo usata:';

  @override
  String get soil_temp_formula_content =>
      'T_suolo(n+1) = T_suolo(n) + α × (T_aria(n) − T_suolo(n))\n\nDove:\n• α : coefficiente di diffusione termica (predefinito 0,15 — intervallo raccomandato 0,10–0,20).\n• T_suolo(n) : temperatura attuale del suolo (°C).\n• T_aria(n) : temperatura attuale dell\'aria (°C).\n\nLa formula è implementata nel codice dell\'app (ComputeSoilTempNextDayUsecase).';

  @override
  String get soil_temp_current_label => 'Temperatura attuale';

  @override
  String get soil_temp_action_measure => 'Modifica / Misura';

  @override
  String get soil_temp_measure_hint =>
      'Puoi inserire manualmente la temperatura del suolo nella scheda \'Modifica / Misura\'.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Errore catalogo: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Errore consiglio: $error';
  }

  @override
  String get soil_temp_db_empty => 'Database piante vuoto.';

  @override
  String get soil_temp_reload_plants => 'Ricarica piante';

  @override
  String get soil_temp_no_advice =>
      'Nessuna pianta con dati di germinazione trovata.';

  @override
  String get soil_advice_status_ideal => 'Ottimale';

  @override
  String get soil_advice_status_sow_now => 'Semina Ora';

  @override
  String get soil_advice_status_sow_soon => 'Presto';

  @override
  String get soil_advice_status_wait => 'Attendi';

  @override
  String get soil_sheet_title => 'Temperatura del Suolo';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Ultima misura: $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'Nuova misura (Ancora)';

  @override
  String get soil_sheet_input_label => 'Temperatura (°C)';

  @override
  String get soil_sheet_input_error => 'Valore non valido (da -10.0 a 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Annulla';

  @override
  String get soil_sheet_action_save => 'Salva';

  @override
  String get soil_sheet_snack_invalid =>
      'Valore non valido. Inserisci tra -10.0 e 45.0';

  @override
  String get soil_sheet_snack_success => 'Misura salvata come ancora';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Errore salvataggio: $error';
  }

  @override
  String get weather_screen_title => 'Meteo';

  @override
  String get weather_provider_credit => 'Dati forniti da Open-Meteo';

  @override
  String get weather_error_loading => 'Impossibile caricare il meteo';

  @override
  String get weather_action_retry => 'Riprova';

  @override
  String get weather_header_next_24h => 'PROSSIME 24H';

  @override
  String get weather_header_daily_summary => 'RIEPILOGO GIORNALIERO';

  @override
  String get weather_header_precipitations => 'PRECIPITAZIONI (24h)';

  @override
  String get weather_label_wind => 'VENTO';

  @override
  String get weather_label_pressure => 'PRESSIONE';

  @override
  String get weather_label_sun => 'SOLE';

  @override
  String get weather_label_astro => 'ASTRO';

  @override
  String get weather_data_speed => 'Velocità';

  @override
  String get weather_data_gusts => 'Raffiche';

  @override
  String get weather_data_sunrise => 'Alba';

  @override
  String get weather_data_sunset => 'Tramonto';

  @override
  String get weather_data_rain => 'Pioggia';

  @override
  String get weather_data_max => 'Max';

  @override
  String get weather_data_min => 'Min';

  @override
  String get weather_data_wind_max => 'Vento Max';

  @override
  String get weather_pressure_high => 'Alta';

  @override
  String get weather_pressure_low => 'Bassa';

  @override
  String get weather_today_label => 'Oggi';

  @override
  String get moon_phase_new => 'Luna Nuova';

  @override
  String get moon_phase_waxing_crescent => 'Luna Crescente';

  @override
  String get moon_phase_first_quarter => 'Primo Quarto';

  @override
  String get moon_phase_waxing_gibbous => 'Gibbosa Crescente';

  @override
  String get moon_phase_full => 'Luna Piena';

  @override
  String get moon_phase_waning_gibbous => 'Gibbosa Calante';

  @override
  String get moon_phase_last_quarter => 'Ultimo Quarto';

  @override
  String get moon_phase_waning_crescent => 'Luna Calante';

  @override
  String get wmo_code_0 => 'Cielo sereno';

  @override
  String get wmo_code_1 => 'Prevalentemente sereno';

  @override
  String get wmo_code_2 => 'Parzialmente nuvoloso';

  @override
  String get wmo_code_3 => 'Coperto';

  @override
  String get wmo_code_45 => 'Nebbia';

  @override
  String get wmo_code_48 => 'Nebbia con brina';

  @override
  String get wmo_code_51 => 'Pioviggine leggera';

  @override
  String get wmo_code_53 => 'Pioviggine moderata';

  @override
  String get wmo_code_55 => 'Pioviggine densa';

  @override
  String get wmo_code_61 => 'Pioggia leggera';

  @override
  String get wmo_code_63 => 'Pioggia moderata';

  @override
  String get wmo_code_65 => 'Pioggia forte';

  @override
  String get wmo_code_66 => 'Pioggia gelata leggera';

  @override
  String get wmo_code_67 => 'Pioggia gelata forte';

  @override
  String get wmo_code_71 => 'Nevicata leggera';

  @override
  String get wmo_code_73 => 'Nevicata moderata';

  @override
  String get wmo_code_75 => 'Nevicata forte';

  @override
  String get wmo_code_77 => 'Granelli di neve';

  @override
  String get wmo_code_80 => 'Rovesci di pioggia leggeri';

  @override
  String get wmo_code_81 => 'Rovesci di pioggia moderati';

  @override
  String get wmo_code_82 => 'Rovesci di pioggia violenti';

  @override
  String get wmo_code_85 => 'Rovesci di neve leggeri';

  @override
  String get wmo_code_86 => 'Rovesci di neve forti';

  @override
  String get wmo_code_95 => 'Temporale';

  @override
  String get wmo_code_96 => 'Temporale con grandine leggera';

  @override
  String get wmo_code_99 => 'Temporale con grandine forte';

  @override
  String get wmo_code_unknown => 'Condizioni sconosciute';

  @override
  String get task_kind_buy => 'Comprare 🛒';

  @override
  String get task_kind_clean => 'Pulire 🧹';

  @override
  String get task_kind_watering => 'Innaffiare 💧';

  @override
  String get task_kind_seeding => 'Seminare 🌱';

  @override
  String get task_kind_pruning => 'Potare ✂️';

  @override
  String get task_kind_weeding => 'Diserbare 🌿';

  @override
  String get task_kind_amendment => 'Ammendamento 🪵';

  @override
  String get task_kind_treatment => 'Trattamento 🧪';

  @override
  String get task_kind_harvest => 'Raccogliere 🧺';

  @override
  String get task_kind_winter_protection => 'Protezione inv. ❄️';

  @override
  String get garden_detail_title_error => 'Errore';

  @override
  String get garden_detail_subtitle_not_found =>
      'Il giardino richiesto non esiste o è stato eliminato.';

  @override
  String garden_detail_subtitle_error_beds(Object error) {
    return 'Impossibile caricare aiuole: $error';
  }

  @override
  String get garden_action_edit => 'Modifica';

  @override
  String get garden_action_archive => 'Archivia';

  @override
  String get garden_action_unarchive => 'Annulla archiviazione';

  @override
  String get garden_action_delete => 'Elimina';

  @override
  String garden_created_at(Object date) {
    return 'Creato il $date';
  }

  @override
  String get garden_bed_delete_confirm_title => 'Elimina Aiuola';

  @override
  String garden_bed_delete_confirm_body(Object bedName) {
    return 'Sei sicuro di voler eliminare \"$bedName\"? Questa azione è irreversibile.';
  }

  @override
  String get garden_bed_deleted_snack => 'Aiuola eliminata';

  @override
  String garden_bed_delete_error(Object error) {
    return 'Errore eliminazione aiuola: $error';
  }

  @override
  String get common_back => 'Indietro';

  @override
  String get garden_action_disable => 'Disabilita';

  @override
  String get garden_action_enable => 'Abilita';

  @override
  String get garden_action_modify => 'Modifica';

  @override
  String get bed_create_title_new => 'Nuova Aiuola';

  @override
  String get bed_create_title_edit => 'Modifica Aiuola';

  @override
  String get bed_form_name_label => 'Nome Aiuola *';

  @override
  String get bed_form_name_hint => 'Es: Aiuola Nord, Parcela 1';

  @override
  String get bed_form_size_label => 'Area (m²) *';

  @override
  String get bed_form_size_hint => 'Es: 10.5';

  @override
  String get bed_form_desc_label => 'Descrizione';

  @override
  String get bed_form_desc_hint => 'Descrizione...';

  @override
  String get bed_form_submit_create => 'Crea';

  @override
  String get bed_form_submit_edit => 'Salva';

  @override
  String get bed_snack_created => 'Aiuola creata con successo';

  @override
  String get bed_snack_updated => 'Aiuola aggiornata con successo';

  @override
  String get bed_form_error_name_required => 'Il nome è obbligatorio';

  @override
  String get bed_form_error_name_length =>
      'Il nome deve essere lungo almeno 2 caratteri';

  @override
  String get bed_form_error_size_required => 'L\'area è obbligatoria';

  @override
  String get bed_form_error_size_invalid => 'Inserisci un\'area valida';

  @override
  String get bed_form_error_size_max => 'L\'area non può superare 1000 m²';

  @override
  String get status_sown => 'Seminato';

  @override
  String get status_planted => 'Piantato';

  @override
  String get status_growing => 'In crescita';

  @override
  String get status_ready_to_harvest => 'Pronto per il raccolto';

  @override
  String get status_harvested => 'Raccolto';

  @override
  String get status_failed => 'Fallito';

  @override
  String bed_card_sown_on(Object date) {
    return 'Seminato il $date';
  }

  @override
  String get bed_card_harvest_start => 'inizio raccolto ca.';

  @override
  String get bed_action_harvest => 'Raccogli';

  @override
  String get lifecycle_error_title => 'Errore nel calcolo del ciclo';

  @override
  String get lifecycle_error_prefix => 'Errore: ';

  @override
  String get lifecycle_cycle_completed => 'ciclo completato';

  @override
  String get lifecycle_stage_germination => 'Germinazione';

  @override
  String get lifecycle_stage_growth => 'Crescita';

  @override
  String get lifecycle_stage_fruiting => 'Fruttificazione';

  @override
  String get lifecycle_stage_harvest => 'Raccolto';

  @override
  String get lifecycle_stage_unknown => 'Sconosciuto';

  @override
  String get lifecycle_harvest_expected => 'Raccolto previsto';

  @override
  String lifecycle_in_days(Object days) {
    return 'Tra $days giorni';
  }

  @override
  String get lifecycle_passed => 'Passato';

  @override
  String get lifecycle_now => 'Adesso!';

  @override
  String get lifecycle_next_action => 'Prossima azione';

  @override
  String get lifecycle_update => 'Aggiorna ciclo';

  @override
  String lifecycle_days_ago(Object days) {
    return '$days giorni fa';
  }

  @override
  String get planting_detail_title => 'Dettagli piantagione';

  @override
  String get companion_beneficial => 'Piante benefiche';

  @override
  String get companion_avoid => 'Piante da evitare';

  @override
  String get common_close => 'Chiudi';

  @override
  String get bed_detail_surface => 'Area';

  @override
  String get bed_detail_details => 'Dettagli';

  @override
  String get bed_detail_notes => 'Note';

  @override
  String get bed_detail_current_plantings => 'Piantagioni Attuali';

  @override
  String get bed_detail_no_plantings_title => 'Nessuna Piantagione';

  @override
  String get bed_detail_no_plantings_desc =>
      'Questa aiuola non ha ancora piantagioni.';

  @override
  String get bed_detail_add_planting => 'Aggiungi Piantagione';

  @override
  String get bed_delete_planting_confirm_title => 'Eliminare Piantagione?';

  @override
  String get bed_delete_planting_confirm_body =>
      'Questa azione è irreversibile. Vuoi davvero eliminare questa piantagione?';

  @override
  String harvest_title(Object plantName) {
    return 'Raccolto: $plantName';
  }

  @override
  String get harvest_weight_label => 'Peso Raccolto (kg) *';

  @override
  String get harvest_price_label => 'Prezzo Stimato (€/kg)';

  @override
  String get harvest_price_helper =>
      'Sarà ricordato per futuri raccolti di questa pianta';

  @override
  String get harvest_notes_label => 'Note / Qualità';

  @override
  String get harvest_action_save => 'Salva';

  @override
  String get harvest_snack_saved => 'Raccolto registrato';

  @override
  String get harvest_snack_error => 'Errore registrazione raccolto';

  @override
  String get harvest_form_error_required => 'Obbligatorio';

  @override
  String get harvest_form_error_positive => 'Non valido (> 0)';

  @override
  String get harvest_form_error_positive_or_zero => 'Non valido (>= 0)';

  @override
  String get info_exposure_full_sun => 'Pieno sole';

  @override
  String get info_exposure_partial_sun => 'Sole parziale';

  @override
  String get info_exposure_shade => 'Ombra';

  @override
  String get info_water_low => 'Basso';

  @override
  String get info_water_medium => 'Medio';

  @override
  String get info_water_high => 'Alto';

  @override
  String get info_water_moderate => 'Moderato';

  @override
  String get info_season_spring => 'Primavera';

  @override
  String get info_season_summer => 'Estate';

  @override
  String get info_season_autumn => 'Autunno';

  @override
  String get info_season_winter => 'Inverno';

  @override
  String get info_season_all => 'Tutte le stagioni';

  @override
  String get common_duplicate => 'Duplica';

  @override
  String get planting_delete_title => 'Elimina piantagione';

  @override
  String get planting_delete_confirm_body =>
      'Sei sicuro di voler eliminare questa piantagione? Questa azione è irreversibile.';

  @override
  String get planting_creation_title => 'Nuova Piantagione';

  @override
  String get planting_creation_title_edit => 'Modifica Piantagione';

  @override
  String get planting_quantity_seeds => 'Numero di semi';

  @override
  String get planting_quantity_plants => 'Numero di piante';

  @override
  String get planting_quantity_required => 'Quantità obbligatoria';

  @override
  String get planting_quantity_positive =>
      'La quantità deve essere un numero positivo';

  @override
  String planting_plant_selection_label(Object plantName) {
    return 'Pianta: $plantName';
  }

  @override
  String get planting_no_plant_selected => 'Nessuna pianta selezionata';

  @override
  String get planting_custom_plant_title => 'Pianta Personalizzata';

  @override
  String get planting_plant_name_label => 'Nome Pianta';

  @override
  String get planting_plant_name_hint => 'Es: Pomodoro Ciliegino';

  @override
  String get planting_plant_name_required => 'Nome pianta obbligatorio';

  @override
  String get planting_notes_label => 'Note (opzionale)';

  @override
  String get planting_notes_hint => 'Informazioni aggiuntive...';

  @override
  String get planting_tips_title => 'Consigli';

  @override
  String get planting_tips_catalog =>
      '• Usa il catalogo per selezionare una pianta.';

  @override
  String get planting_tips_type =>
      '• Scegli \"Seminato\" per semi, \"Piantato\" per piantine.';

  @override
  String get planting_tips_notes =>
      '• Aggiungi note per tracciare condizioni speciali.';

  @override
  String get planting_date_future_error =>
      'La data di piantagione non può essere nel futuro';

  @override
  String get planting_success_create => 'Piantagione creata con successo';

  @override
  String get planting_success_update => 'Piantagione aggiornata con successo';

  @override
  String get stats_screen_title => 'Statistiche';

  @override
  String get stats_screen_subtitle =>
      'Analizza in tempo reale ed esporta i tuoi dati.';

  @override
  String get kpi_alignment_title => 'Allineamento Vivente';

  @override
  String get kpi_alignment_description =>
      'Questo strumento valuta quanto le tue semine, piantagioni e raccolti siano vicini alle finestre ideali raccomandate dall\'Agenda Intelligente.';

  @override
  String get kpi_alignment_cta =>
      'Inizia a piantare e raccogliere per vedere il tuo allineamento!';

  @override
  String get kpi_alignment_aligned => 'allineato';

  @override
  String get kpi_alignment_total => 'Totale';

  @override
  String get kpi_alignment_aligned_actions => 'Allineato';

  @override
  String get kpi_alignment_misaligned_actions => 'Disallineato';

  @override
  String get kpi_alignment_calculating => 'Calcolo allineamento...';

  @override
  String get kpi_alignment_error => 'Errore durante il calcolo';

  @override
  String get pillar_economy_title => 'Economia del Giardino';

  @override
  String get pillar_nutrition_title => 'Bilancio Nutrizionale';

  @override
  String get pillar_export_title => 'Esporta';

  @override
  String get pillar_economy_label => 'Valore totale raccolto';

  @override
  String get pillar_nutrition_label => 'Firma Nutrizionale';

  @override
  String get pillar_export_label => 'Recupera i tuoi dati';

  @override
  String get pillar_export_button => 'Esporta';

  @override
  String get stats_economy_title => 'Economia del Giardino';

  @override
  String get stats_economy_no_harvest =>
      'Nessun raccolto nel periodo selezionato.';

  @override
  String get stats_economy_no_harvest_desc =>
      'Nessun dato per il periodo selezionato.';

  @override
  String get stats_kpi_total_revenue => 'Entrate Totali';

  @override
  String get stats_kpi_total_volume => 'Volume Totale';

  @override
  String get stats_kpi_avg_price => 'Prezzo Medio';

  @override
  String get stats_top_cultures_title => 'Migliori Colture (Valore)';

  @override
  String get stats_top_cultures_no_data => 'Nessun dato';

  @override
  String get stats_top_cultures_percent_revenue => 'delle entrate';

  @override
  String get stats_monthly_revenue_title => 'Entrate Mensili';

  @override
  String get stats_monthly_revenue_no_data => 'Nessun dato mensile';

  @override
  String get stats_dominant_culture_title => 'Coltura Dominante per Mese';

  @override
  String get stats_annual_evolution_title => 'Tendenza Annuale';

  @override
  String get stats_crop_distribution_title => 'Distribuzione Colture';

  @override
  String get stats_crop_distribution_others => 'Altri';

  @override
  String get stats_key_months_title => 'Mesi Chiave del Giardino';

  @override
  String get stats_most_profitable => 'Più Redditizio';

  @override
  String get stats_least_profitable => 'Meno Redditizio';

  @override
  String get stats_auto_summary_title => 'Riepilogo Automatico';

  @override
  String get stats_revenue_history_title => 'Cronologia Entrate';

  @override
  String get stats_profitability_cycle_title => 'Ciclo di Redditività';

  @override
  String get stats_table_crop => 'Coltura';

  @override
  String get stats_table_days => 'Giorni (Media)';

  @override
  String get stats_table_revenue => 'Ric/Raccolto';

  @override
  String get stats_table_type => 'Tipo';

  @override
  String get stats_type_fast => 'Veloce';

  @override
  String get stats_type_long_term => 'Lungo Termine';

  @override
  String get nutrition_page_title => 'Firma Nutrizionale';

  @override
  String get nutrition_seasonal_dynamics_title => 'Dinamiche Stagionali';

  @override
  String get nutrition_seasonal_dynamics_desc =>
      'Esplora la produzione di minerali e vitamine del tuo giardino, mese per mese.';

  @override
  String get nutrition_no_harvest_month => 'Nessun raccolto questo mese';

  @override
  String get nutrition_major_minerals_title =>
      'Struttura e Minerali Principali';

  @override
  String get nutrition_trace_elements_title => 'Vitalità e Oligoelementi';

  @override
  String get nutrition_no_data_period => 'Nessun dato per questo periodo';

  @override
  String get nutrition_no_major_minerals => 'Nessun minerale principale';

  @override
  String get nutrition_no_trace_elements => 'Nessun oligoelemento';

  @override
  String nutrition_month_dynamics_title(String month) {
    return 'Dinamiche di $month';
  }

  @override
  String get nutrition_dominant_production => 'Produzione dominante:';

  @override
  String get nutrition_nutrients_origin =>
      'Questi nutrienti provengono dai tuoi raccolti del mese.';

  @override
  String get nut_calcium => 'Calcio';

  @override
  String get nut_potassium => 'Potassio';

  @override
  String get nut_magnesium => 'Magnesio';

  @override
  String get nut_iron => 'Ferro';

  @override
  String get nut_zinc => 'Zinco';

  @override
  String get nut_manganese => 'Manganese';

  @override
  String get nut_vitamin_c => 'Vitamina C';

  @override
  String get nut_fiber => 'Fibre';

  @override
  String get nut_protein => 'Proteine';

  @override
  String get export_builder_title => 'Costruttore di Esportazione';

  @override
  String get export_scope_section => '1. Ambito';

  @override
  String get export_scope_period => 'Periodo';

  @override
  String get export_scope_period_all => 'Tutta la Cronologia';

  @override
  String get export_filter_garden_title => 'Filtra per Giardino';

  @override
  String get export_filter_garden_all => 'Tutti i giardini';

  @override
  String export_filter_garden_count(Object count) {
    return '$count giardino/i selezionato/i';
  }

  @override
  String get export_filter_garden_edit => 'Modifica selezione';

  @override
  String get export_filter_garden_select_dialog_title => 'Seleziona Giardini';

  @override
  String get export_blocks_section => '2. Blocchi Dati';

  @override
  String get export_block_activity => 'Attività (Giornale)';

  @override
  String get export_block_harvest => 'Raccolti (Produzione)';

  @override
  String get export_block_garden => 'Giardini (Struttura)';

  @override
  String get export_block_garden_bed => 'Aiuole (Struttura)';

  @override
  String get export_block_plant => 'Piante (Catalogo)';

  @override
  String get export_block_desc_activity =>
      'Cronologia completa di interventi ed eventi';

  @override
  String get export_block_desc_harvest => 'Dati di produzione e rese';

  @override
  String get export_block_desc_garden => 'Metadati dei giardini selezionati';

  @override
  String get export_block_desc_garden_bed =>
      'Dettagli aiuole (area, orientamento...)';

  @override
  String get export_block_desc_plant => 'Elenco delle piante utilizzate';

  @override
  String get export_columns_section => '3. Dettagli e Colonne';

  @override
  String export_columns_count(Object count) {
    return '$count colonne selezionate';
  }

  @override
  String get export_format_section => '4. Formato File';

  @override
  String get export_format_separate => 'Fogli Separati (Standard)';

  @override
  String get export_format_separate_subtitle =>
      'Un foglio per tipo di dato (Consigliato)';

  @override
  String get export_format_flat => 'Tabella Singola (Piatta / BI)';

  @override
  String get export_format_flat_subtitle =>
      'Una grande tabella per Tabelle Pivot';

  @override
  String get export_action_generate => 'Genera Esportazione Excel';

  @override
  String get export_generating => 'Generazione...';

  @override
  String get export_success_title => 'Esportazione Completata';

  @override
  String get export_success_share_text =>
      'Ecco la tua esportazione PermaCalendar';

  @override
  String export_error_snack(Object error) {
    return 'Errore: $error';
  }

  @override
  String get export_field_garden_name => 'Nome Giardino';

  @override
  String get export_field_garden_id => 'ID Giardino';

  @override
  String get export_field_garden_surface => 'Area (m²)';

  @override
  String get export_field_garden_creation => 'Data Creazione';

  @override
  String get export_field_bed_name => 'Nome Aiuola';

  @override
  String get export_field_bed_id => 'ID Parcelle';

  @override
  String get export_field_bed_surface => 'Surface (m²)';

  @override
  String get export_field_bed_plant_count => 'Nb Plantes';

  @override
  String get export_field_plant_name => 'Nom commun';

  @override
  String get export_field_plant_id => 'ID Plante';

  @override
  String get export_field_plant_scientific => 'Nom scientifique';

  @override
  String get export_field_plant_family => 'Famille';

  @override
  String get export_field_plant_variety => 'Variété';

  @override
  String get export_field_harvest_date => 'Date Récolte';

  @override
  String get export_field_harvest_qty => 'Quantité (kg)';

  @override
  String get export_field_harvest_plant_name => 'Plante';

  @override
  String get export_field_harvest_price => 'Prix/kg';

  @override
  String get export_field_harvest_value => 'Valeur Totale';

  @override
  String get export_field_harvest_notes => 'Notes';

  @override
  String get export_field_harvest_garden_name => 'Jardin';

  @override
  String get export_field_harvest_garden_id => 'ID Jardin';

  @override
  String get export_field_harvest_bed_name => 'Parcelle';

  @override
  String get export_field_harvest_bed_id => 'ID Parcelle';

  @override
  String get export_field_activity_date => 'Date';

  @override
  String get export_field_activity_type => 'Type';

  @override
  String get export_field_activity_title => 'Titre';

  @override
  String get export_field_activity_desc => 'Description';

  @override
  String get export_field_activity_entity => 'Entité Cible';

  @override
  String get export_field_activity_entity_id => 'ID Cible';

  @override
  String get export_activity_type_garden_created => 'Création de jardin';

  @override
  String get export_activity_type_garden_updated => 'Mise à jour du jardin';

  @override
  String get export_activity_type_garden_deleted => 'Suppression de jardin';

  @override
  String get export_activity_type_bed_created => 'Création de parcelle';

  @override
  String get export_activity_type_bed_updated => 'Mise à jour de parcelle';

  @override
  String get export_activity_type_bed_deleted => 'Suppression de parcelle';

  @override
  String get export_activity_type_planting_created => 'Nouvelle plantation';

  @override
  String get export_activity_type_planting_updated => 'Mise à jour plantation';

  @override
  String get export_activity_type_planting_deleted => 'Suppression plantation';

  @override
  String get export_activity_type_harvest => 'Récolte';

  @override
  String get export_activity_type_maintenance => 'Entretien';

  @override
  String get export_activity_type_weather => 'Météo';

  @override
  String get export_activity_type_error => 'Erreur';

  @override
  String get export_excel_total => 'TOTAL';

  @override
  String get export_excel_unknown => 'Inconnu';

  @override
  String get export_field_advanced_suffix => ' (Avancé)';

  @override
  String get export_field_desc_garden_name => 'Nom donné au jardin';

  @override
  String get export_field_desc_garden_id => 'Identifiant unique technique';

  @override
  String get export_field_desc_garden_surface => 'Surface totale du jardin';

  @override
  String get export_field_desc_garden_creation =>
      'Date de création dans l\'application';

  @override
  String get export_field_desc_bed_name => 'Nom de la parcelle';

  @override
  String get export_field_desc_bed_id => 'Identifiant unique technique';

  @override
  String get export_field_desc_bed_surface => 'Surface de la parcelle';

  @override
  String get export_field_desc_bed_plant_count =>
      'Nombre de cultures en place (actuel)';

  @override
  String get export_field_desc_plant_name => 'Nom usuel de la plante';

  @override
  String get export_field_desc_plant_id => 'Identifiant unique technique';

  @override
  String get export_field_desc_plant_scientific => 'Dénomination botanique';

  @override
  String get export_field_desc_plant_family => 'Famille botanique';

  @override
  String get export_field_desc_plant_variety => 'Variété spécifique';

  @override
  String get export_field_desc_harvest_date =>
      'Date de l\'événement de récolte';

  @override
  String get export_field_desc_harvest_qty => 'Poids récolté en kg';

  @override
  String get export_field_desc_harvest_plant_name =>
      'Nom de la plante récoltée';

  @override
  String get export_field_desc_harvest_price => 'Prix au kg configuré';

  @override
  String get export_field_desc_harvest_value => 'Quantité * Prix/kg';

  @override
  String get export_field_desc_harvest_notes =>
      'Observations saisies lors de la récolte';

  @override
  String get export_field_desc_harvest_garden_name =>
      'Nom du jardin d\'origine (si disponible)';

  @override
  String get export_field_desc_harvest_garden_id =>
      'Identifiant unique du jardin';

  @override
  String get export_field_desc_harvest_bed_name =>
      'Parcelle d\'origine (si disponible)';

  @override
  String get export_field_desc_harvest_bed_id => 'Identifiant parcelle';

  @override
  String get export_field_desc_activity_date => 'Date de l\'activité';

  @override
  String get export_field_desc_activity_type =>
      'Catégorie d\'action (Semis, Récolte, Soin...)';

  @override
  String get export_field_desc_activity_title => 'Résumé de l\'action';

  @override
  String get export_field_desc_activity_desc => 'Détails complets';

  @override
  String get export_field_desc_activity_entity =>
      'Nom de l\'objet concerné (Plante, Parcelle...)';

  @override
  String get export_field_desc_activity_entity_id => 'ID de l\'objet concerné';

  @override
  String get plant_catalog_sow => 'Seminare';

  @override
  String get plant_catalog_plant => 'Piantare';

  @override
  String get plant_catalog_show_selection => 'Mostra selezione';

  @override
  String get plant_catalog_filter_green_only => 'Solo verdi';

  @override
  String get plant_catalog_filter_green_orange => 'Verdi + Arancioni';

  @override
  String get plant_catalog_filter_all => 'Tutti';

  @override
  String get plant_catalog_no_recommended =>
      'Nessuna pianta raccomandata per il periodo.';

  @override
  String get plant_catalog_expand_window => 'Espandi (±2 mesi)';

  @override
  String get plant_catalog_missing_period_data => 'Dati del periodo mancanti';

  @override
  String plant_catalog_periods_prefix(String months) {
    return 'Periodi: $months';
  }

  @override
  String get plant_catalog_legend_green => 'Pronto questo mese';

  @override
  String get plant_catalog_legend_orange => 'Vicino / Presto';

  @override
  String get plant_catalog_legend_red => 'Fuori stagione';

  @override
  String get plant_catalog_data_unknown => 'Dati sconosciuti';

  @override
  String get task_editor_photo_label => 'Photo de la tâche';

  @override
  String get task_editor_photo_add => 'Ajouter une photo';

  @override
  String get task_editor_photo_change => 'Changer la photo';

  @override
  String get task_editor_photo_remove => 'Retirer la photo';

  @override
  String get task_editor_photo_help =>
      'La photo sera jointe automatiquement au PDF / Word à la création / envoi.';

  @override
  String get export_block_nutrition => 'Nutrition (Agrégation)';

  @override
  String get export_block_desc_nutrition =>
      'Indicateurs nutritionnels agrégés par nutriment';

  @override
  String get export_field_nutrient_key => 'Clé nutriment';

  @override
  String get export_field_nutrient_label => 'Nutriment';

  @override
  String get export_field_nutrient_unit => 'Unité';

  @override
  String get export_field_nutrient_total => 'Total disponible';

  @override
  String get export_field_mass_with_data_kg => 'Masse avec données (kg)';

  @override
  String get export_field_contributing_records => 'Nb récoltes';

  @override
  String get export_field_data_confidence => 'Confiance';

  @override
  String get export_field_coverage_percent => 'Moy. DRI (%)';

  @override
  String get export_field_lower_bound_coverage => 'Min DRI (%)';

  @override
  String get export_field_upper_bound_coverage => 'Max DRI (%)';
}
