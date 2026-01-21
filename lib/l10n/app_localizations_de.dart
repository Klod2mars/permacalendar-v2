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
  String get settings_weather_selector => 'Wetter-Wahla';

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
  String get plant_catalog_search_hint => 'Pflanze suchen...';

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
  String get common_save => 'Speichern';

  @override
  String get empty_action_create => 'Erstellen';

  @override
  String get user_guide_text =>
      '1 — Willkommen bei Sowing\nSowing ist eine Anwendung, die Gärtner bei der lebendigen und konkreten Überwachung ihrer Kulturen unterstützt.\nSie ermöglicht Ihnen:\n• Ihre Gärten und Beete zu organisieren,\n• Ihre Pflanzungen während ihres gesamten Lebenszyklus zu verfolgen,\n• Ihre Aufgaben zum richtigen Zeitpunkt zu planen,\n• eine Erinnerung an das zu behalten, was getan wurde,\n• das lokale Wetter und den Rhythmus der Jahreszeiten zu berücksichtigen.\nDie Anwendung funktioniert hauptsächlich offline und speichert Ihre Daten direkt auf Ihrem Gerät.\nDieses Handbuch beschreibt die übliche Verwendung von Sowing: Erste Schritte, Erstellung von Gärten, Pflanzungen, Kalender, Wetter, Datenexport und bewährte Verfahren.\n\n2 — Die Benutzeroberfläche verstehen\nDas Dashboard\nBeim Öffnen zeigt Sowing ein visuelles und organisches Dashboard an.\nEs hat die Form eines Hintergrundbildes, das von interaktiven Blasen animiert wird. Jede Blase bietet Zugriff auf eine wichtige Funktion der Anwendung:\n• Gärten,\n• Luftwetter,\n• Bodenwetter,\n• Kalender,\n• Aktivitäten,\n• Statistiken,\n• Einstellungen.\nAllgemeine Navigation\nTippen Sie einfach auf eine Blase, um den entsprechenden Abschnitt zu öffnen.\nInnerhalb der Seiten finden Sie je nach Kontext:\n• Kontextmenüs,\n• „+“-Schaltflächen zum Hinzufügen eines Elements,\n• Bearbeitungs- oder Löschschaltflächen.\n\n3 — Schnellstart\nAnwendung öffnen\nBeim Start wird das Dashboard automatisch angezeigt.\nWetter konfigurieren\nWählen Sie in den Einstellungen Ihren Standort.\nDiese Information ermöglicht es Sowing, ein an Ihren Garten angepasstes lokales Wetter anzuzeigen. Wenn kein Standort ausgewählt ist, wird ein Standardstandort verwendet.\nIhren ersten Garten erstellen\nBei der ersten Verwendung führt Sie Sowing automatisch durch die Erstellung Ihres ersten Gartens.\nSie können einen Garten auch manuell über das Dashboard erstellen.\nTippen Sie auf dem Hauptbildschirm auf das grüne Blatt im freiesten Bereich, rechts von den Statistiken und etwas darüber. Dieser bewusst diskrete Bereich ermöglicht es Ihnen, die Erstellung eines Gartens zu initiieren.\nSie können bis zu fünf Gärten erstellen.\nDieser Ansatz ist Teil des Sowing-Erlebnisses: Es gibt keine permanente und zentrale „+“-Schaltfläche. Die Anwendung lädt eher zur Erkundung und schrittweisen Entdeckung des Raumes ein.\nDie mit den Gärten verknüpften Bereiche sind auch über das Einstellungsmenü zugänglich.\nOrganische Kalibrierung des Dashboards\nEin organischer Kalibrierungsmodus ermöglicht:\n• die tatsächliche Position der interaktiven Zonen zu visualisieren,\n• sie durch einfaches Schieben des Fingers zu bewegen.\nSie können Ihre Gärten und Module also genau dort auf dem Bild positionieren, wo Sie es möchten: oben, unten oder an der Stelle, die Ihnen am besten passt.\nNach der Bestätigung wird diese Organisation gespeichert und in der Anwendung beibehalten.\nEin Beet erstellen\nIn einem Gartenblatt:\n• wählen Sie „Ein Beet hinzufügen“,\n• geben Sie seinen Namen, seine Fläche und ggf. einige Notizen an,\n• speichern Sie.\nEine Pflanzung hinzufügen\nIn einem Beet:\n• drücken Sie die „+“-Taste,\n• wählen Sie eine Pflanze aus dem Katalog,\n• geben Sie das Datum, die Menge und nützliche Informationen an,\n• bestätigen Sie.\n\n4 — Das organische Dashboard\nDas Dashboard ist der zentrale Punkt von Sowing.\nEs ermöglicht:\n• einen Überblick über Ihre Aktivität zu haben,\n• schnell auf die Hauptfunktionen zuzugreifen,\n• intuitiv zu navigieren.\nJe nach Ihren Einstellungen können einige Blasen synthetische Informationen anzeigen, wie das Wetter oder anstehende Aufgaben.\n\n5 — Gärten, Beete und Pflanzungen\nDie Gärten\nEin Garten repräsentiert einen realen Ort: Gemüsegarten, Gewächshaus, Obstgarten, Balkon usw.\nSie können:\n• mehrere Gärten erstellen,\n• ihre Informationen ändern,\n• sie bei Bedarf löschen.\nDie Beete\nEin Beet ist eine genaue Zone innerhalb eines Gartens.\nEs ermöglicht, den Raum zu strukturieren, Kulturen zu organisieren und mehrere Pflanzungen am selben Ort zu gruppieren.\nDie Pflanzungen\nEine Pflanzung entspricht der Einführung einer Pflanze in ein Beet zu einem bestimmten Zeitpunkt.\nBeim Erstellen einer Pflanzung bietet Sowing zwei Modi an.\nSäen\nDer Modus „Säen“ entspricht dem Einbringen eines Samens in den Boden.\nIn diesem Fall:\n• beginnt der Fortschritt bei 0 %,\n• wird eine schrittweise Nachverfolgung vorgeschlagen, besonders nützlich für Gartenanfänger,\n• visualisiert ein Fortschrittsbalken den Fortschritt des Kulturzyklus.\nDiese Nachverfolgung ermöglicht die Schätzung:\n• des wahrscheinlichen Beginns der Erntezeit,\n• der Entwicklung der Kultur im Laufe der Zeit auf einfache und visuelle Weise.\nPflanzen\nDer Modus „Pflanzen“ ist für bereits entwickelte Pflanzen gedacht (Pflanzen aus einem Gewächshaus oder in einem Gartencenter gekauft).\nIn diesem Fall:\n• beginnt die Pflanze mit einem Fortschritt von ca. 30 %,\n• ist die Nachverfolgung sofort fortgeschrittener,\n• wird die Schätzung der Erntezeit entsprechend angepasst.\nWahl des Datums\nBeim Pflanzen können Sie das Datum frei wählen.\nDies ermöglicht zum Beispiel:\n• eine zuvor durchgeführte Pflanzung einzutragen,\n• ein Datum zu korrigieren, wenn die Anwendung zum Zeitpunkt der Aussaat oder Pflanzung nicht verwendet wurde.\nStandardmäßig wird das aktuelle Datum verwendet.\nNachverfolgung und Verlauf\nJede Pflanzung hat:\n• eine Fortschrittsnachverfolgung,\n• Informationen zu ihrem Lebenszyklus,\n• Kulturphasen,\n• persönliche Notizen.\nAlle Aktionen (Aussaat, Pflanzung, Pflege, Ernte) werden automatisch im Gartenverlauf aufgezeichnet.\n\n6 — Pflanzenkatalog\nDer Katalog fasst alle beim Erstellen einer Pflanzung verfügbaren Pflanzen zusammen.\nEr stellt eine skalierbare Referenzbasis dar, die so konzipiert ist, dass sie aktuelle Verwendungen abdeckt und gleichzeitig anpassbar bleibt.\nHauptfunktionen:\n• einfache und schnelle Suche,\n• Erkennung von gebräuchlichen und wissenschaftlichen Namen,\n• Anzeige von Fotos, wenn verfügbar.\nBenutzerdefinierte Pflanzen\nSie können Ihre eigenen benutzerdefinierten Pflanzen erstellen unter:\nEinstellungen → Pflanzenkatalog.\nEs ist dann möglich:\n• eine neue Pflanze zu erstellen,\n• die wesentlichen Parameter (Name, Typ, nützliche Informationen) auszufüllen,\n• ein Bild hinzuzufügen, um die Identifizierung zu erleichtern.\nDie benutzerdefinierten Pflanzen sind dann wie jede andere Pflanze im Katalog verwendbar.\n\n7 — Kalender und Aufgaben\nDie Kalenderansicht\nDer Kalender zeigt an:\n• geplante Aufgaben,\n• wichtige Pflanzungen,\n• geschätzte Erntezeiten.\nEine Aufgabe erstellen\nVom Kalender aus:\n• erstellen Sie eine neue Aufgabe,\n• geben Sie einen Titel, ein Datum und eine Beschreibung an,\n• wählen Sie eine mögliche Wiederholung.\nDie Aufgaben können mit einem Garten oder einem Beet verknüpft werden.\nAufgabenverwaltung\nSie können:\n• eine Aufgabe ändern,\n• sie löschen,\n• sie exportieren, um sie zu teilen.\n\n8 — Aktivitäten und Verlauf\nDieser Abschnitt stellt das lebendige Gedächtnis Ihrer Gärten dar.\nAuswahl eines Gartens\nDrücken Sie vom Dashboard aus lange auf einen Garten, um ihn auszuwählen.\nDer aktive Garten wird durch einen hellgrünen Heiligenschein und ein Bestätigungsbanner hervorgehoben.\nDiese Auswahl ermöglicht das Filtern der angezeigten Informationen.\nKürzliche Aktivitäten\nDer Reiter „Aktivitäten“ zeigt chronologisch an:\n• Erstellungen,\n• Pflanzungen,\n• Pflege,\n• Ernten,\n• manuelle Aktionen.\nVerlauf nach Garten\nDer Reiter „Verlauf“ präsentiert den vollständigen Verlauf des ausgewählten Gartens Jahr für Jahr.\nEr ermöglicht insbesondere:\n• vergangene Pflanzungen zu finden,\n• zu überprüfen, ob eine Pflanze bereits an einem bestimmten Ort angebaut wurde,\n• die Fruchtfolge besser zu organisieren.\n\n9 — Luftwetter und Bodenwetter\nLuftwetter\nDas Luftwetter liefert wesentliche Informationen:\n• Außentemperatur,\n• Niederschläge (Regen, Schnee, kein Regen),\n• Tag-/Nachtwechsel.\nDiese Daten helfen, klimatische Risiken zu antizipieren und Interventionen anzupassen.\nBodenwetter\nSowing integriert ein Bodenwettermodul.\nDer Benutzer kann eine gemessene Temperatur eingeben. Aus diesen Daten schätzt die Anwendung dynamisch die Entwicklung der Bodentemperatur im Laufe der Zeit.\nDiese Information ermöglicht:\n• zu wissen, welche Pflanzen zu einem bestimmten Zeitpunkt wirklich anbaubar sind,\n• die Aussaat an die realen Bedingungen anzupassen statt an einen theoretischen Kalender.\nEchtzeitwetter auf dem Dashboard\nEin zentrales, eiförmiges Modul zeigt auf einen Blick:\n• den Himmelszustand,\n• Tag oder Nacht,\n• die Phase und Position des Mondes für den ausgewählten Standort.\nZeitnavigation\nIndem Sie Ihren Finger von links nach rechts über das Ei gleiten lassen, durchsuchen Sie die Vorhersagen stundenweise, bis zu mehr als 12 Stunden im Voraus.\nTemperatur und Niederschlag passen sich während der Geste dynamisch an.\n\n10 — Empfehlungen\nSowing kann Empfehlungen anbieten, die an Ihre Situation angepasst sind.\nSie stützen sich auf:\n• die Jahreszeit,\n• das Wetter,\n• den Zustand Ihrer Pflanzungen.\nJede Empfehlung gibt an:\n• was zu tun ist,\n• wann zu handeln ist,\n• warum die Aktion vorgeschlagen wird.\n\n11 — Export und Teilen\nPDF-Export — Kalender und Aufgaben\nDie Kalenderaufgaben können als PDF exportiert werden.\nDies ermöglicht:\n• klare Informationen zu teilen,\n• eine geplante Intervention zu übermitteln,\n• eine lesbare und datierte Spur zu behalten.\nExcel-Export — Ernten und Statistiken\nDie Erntedaten können im Excel-Format exportiert werden, um:\n• die Ergebnisse zu analysieren,\n• Berichte zu erstellen,\n• die Entwicklung im Laufe der Zeit zu verfolgen.\nDokumentfreigabe\nDie generierten Dokumente können über die auf Ihrem Gerät verfügbaren Anwendungen (Messaging, Speicher, Übertragung auf einen Computer usw.) geteilt werden.\n\n12 — Sicherung und bewährte Verfahren\nDie Daten werden lokal auf Ihrem Gerät gespeichert.\nEmpfohlene bewährte Verfahren:\n• vor einem größeren Update eine Sicherung durchführen,\n• Ihre Daten regelmäßig exportieren,\n• die Anwendung und das Gerät auf dem neuesten Stand halten.\n\n13 — Einstellungen\nDas Einstellungsmenü ermöglicht es, Sowing an Ihre Nutzungen anzupassen.\nSie können insbesondere:\n• die Sprache wählen,\n• Ihren Standort auswählen,\n• auf den Pflanzenkatalog zugreifen,\n• das Dashboard anpassen.\nDashboard-Anpassung\nEs ist möglich:\n• jedes Modul neu zu positionieren,\n• den visuellen Raum anzupassen,\n• das Hintergrundbild zu ändern,\n• Ihr eigenes Bild zu importieren (Funktion kommt bald).\nRechtliche Informationen\nIn den Einstellungen können Sie einsehen:\n• das Benutzerhandbuch,\n• die Datenschutzrichtlinie,\n• die Nutzungsbedingungen.\n\n14 — Häufig gestellte Fragen\nDie Touch-Zonen sind nicht gut ausgerichtet\nJe nach Telefon oder Anzeigeeinstellungen können einige Zonen verschoben erscheinen.\nEin organischer Kalibrierungsmodus ermöglicht:\n• die Touch-Zonen zu visualisieren,\n• sie durch Schieben neu zu positionieren,\n• die Konfiguration für Ihr Gerät zu speichern.\nKann ich Sowing ohne Verbindung nutzen?\nJa. Sowing funktioniert offline für die Verwaltung von Gärten, Pflanzungen, Aufgaben und Verlauf.\nEine Verbindung wird nur verwendet:\n• für den Abruf von Wetterdaten,\n• beim Export oder Teilen von Dokumenten.\nEs werden keine anderen Daten übertragen.\n\n15 — Schlussbemerkung\nSowing ist als Gartenbegleiter konzipiert: einfach, lebendig und skalierbar.\nNehmen Sie sich die Zeit zu beobachten, zu notieren und vertrauen Sie Ihrer Erfahrung genauso wie dem Werkzeug.';

  @override
  String get privacy_policy_text =>
      'Sowing respektiert Ihre Privatsphäre voll und ganz.\n\n• Alle Daten werden lokal auf Ihrem Gerät gespeichert\n• Es werden keine persönlichen Daten an Dritte übermittelt\n• Es werden keine Informationen auf einem externen Server gespeichert\n\nDie Anwendung funktioniert vollständig offline. Eine Internetverbindung wird nur zum Abrufen von Wetterdaten oder beim Export verwendet.';

  @override
  String get terms_text =>
      'Durch die Nutzung von Sowing stimmen Sie zu:\n\n• Die Anwendung verantwortungsvoll zu nutzen\n• Nicht zu versuchen, ihre Einschränkungen zu umgehen\n• Die geistigen Eigentumsrechte zu respektieren\n• Nur Ihre eigenen Daten zu verwenden\n\nDiese Anwendung wird ohne Mängelgewähr bereitgestellt.\n\nDas Sowing-Team bleibt offen für zukünftige Verbesserungen oder Entwicklungen.';

  @override
  String get calibration_auto_apply => 'Automatisch für dieses Gerät anwenden';

  @override
  String get calibration_calibrate_now => 'Jetzt kalibrieren';

  @override
  String get calibration_save_profile =>
      'Aktuelle Kalibrierung als Profil speichern';

  @override
  String get calibration_export_profile => 'Profil exportieren (JSON-Kopie)';

  @override
  String get calibration_import_profile =>
      'Profil aus Zwischenablage importieren';

  @override
  String get calibration_reset_profile =>
      'Profil für dieses Gerät zurücksetzen';

  @override
  String get calibration_refresh_profile => 'Profilvorschau aktualisieren';

  @override
  String calibration_key_device(String key) {
    return 'Geräteschlüssel: $key';
  }

  @override
  String get calibration_no_profile =>
      'Kein Profil für dieses Gerät gespeichert.';

  @override
  String get calibration_image_settings_title =>
      'Hintergrundbild-Einstellungen (Persistent)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image => 'Bildstandards zurücksetzen';

  @override
  String get calibration_dialog_confirm_title => 'Bestätigen';

  @override
  String get calibration_dialog_delete_profile =>
      'Kalibrierungsprofil für dieses Gerät löschen?';

  @override
  String get calibration_action_delete => 'Löschen';

  @override
  String get calibration_snack_no_profile =>
      'Kein Profil für dieses Gerät gefunden.';

  @override
  String get calibration_snack_profile_copied =>
      'Profil in die Zwischenablage kopiert.';

  @override
  String get calibration_snack_clipboard_empty => 'Zwischenablage leer.';

  @override
  String get calibration_snack_profile_imported =>
      'Profil importiert und für dieses Gerät gespeichert.';

  @override
  String calibration_snack_import_error(String error) {
    return 'JSON-Importfehler: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Profil für dieses Gerät gelöscht.';

  @override
  String get calibration_snack_no_calibration =>
      'Keine Kalibrierung gespeichert. Kalibrieren Sie zuerst vom Dashboard aus.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Aktuelle Kalibrierung als Profil für dieses Gerät gespeichert.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get calibration_overlay_saved => 'Kalibrierung gespeichert';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Fehler beim Speichern der Kalibrierung: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Ziehen zum Bewegen, Kneifen zum Zoomen des Hintergrundbilds.';

  @override
  String get calibration_instruction_sky =>
      'Passen Sie das Tag/Nacht-Ei an (Mitte, Größe, Rotation).';

  @override
  String get calibration_instruction_modules =>
      'Bewegen Sie die Module (Blasen) an die gewünschte Stelle.';

  @override
  String get calibration_instruction_none =>
      'Wählen Sie ein Werkzeug, um zu beginnen.';

  @override
  String get calibration_tool_image => 'Bild';

  @override
  String get calibration_tool_sky => 'Himmel';

  @override
  String get calibration_tool_modules => 'Module';

  @override
  String get calibration_action_validate_exit => 'Bestätigen & Beenden';

  @override
  String get garden_management_create_title => 'Einen Garten erstellen';

  @override
  String get garden_management_edit_title => 'Garten bearbeiten';

  @override
  String get garden_management_name_label => 'Gartenname';

  @override
  String get garden_management_desc_label => 'Beschreibung';

  @override
  String get garden_management_image_label => 'Gartenbild (Optional)';

  @override
  String get garden_management_image_url_label => 'Bild-URL';

  @override
  String get garden_management_image_preview_error =>
      'Bild kann nicht geladen werden';

  @override
  String get garden_management_create_submit => 'Garten erstellen';

  @override
  String get garden_management_create_submitting => 'Erstellen...';

  @override
  String get garden_management_created_success => 'Garten erfolgreich erstellt';

  @override
  String get garden_management_create_error =>
      'Fehler beim Erstellen des Gartens';

  @override
  String get garden_management_delete_confirm_title => 'Garten löschen';

  @override
  String get garden_management_delete_confirm_body =>
      'Sind Sie sicher, dass Sie diesen Garten löschen möchten? Dies löscht auch alle zugehörigen Beete und Pflanzungen. Diese Aktion ist unwiderruflich.';

  @override
  String get garden_management_delete_success => 'Garten erfolgreich gelöscht';

  @override
  String get garden_management_archived_tag => 'Archivierter Garten';

  @override
  String get garden_management_beds_title => 'Gartenbeete';

  @override
  String get garden_management_no_beds_title => 'Keine Beete';

  @override
  String get garden_management_no_beds_desc =>
      'Erstellen Sie Beete, um Ihre Pflanzungen zu organisieren';

  @override
  String get garden_management_add_bed_label => 'Beet erstellen';

  @override
  String get garden_management_stats_beds => 'Beete';

  @override
  String get garden_management_stats_area => 'Gesamtfläche';

  @override
  String get dashboard_weather_stats => 'Wetterdetails';

  @override
  String get dashboard_soil_temp => 'Bodentemp.';

  @override
  String get dashboard_air_temp => 'Temperatur';

  @override
  String get dashboard_statistics => 'Statistiken';

  @override
  String get dashboard_calendar => 'Kalender';

  @override
  String get dashboard_activities => 'Aktivitäten';

  @override
  String get dashboard_weather => 'Wetter';

  @override
  String get dashboard_settings => 'Einstellungen';

  @override
  String dashboard_garden_n(int number) {
    return 'Garten $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Garten \"$name\" erfolgreich erstellt';
  }

  @override
  String get dashboard_garden_create_error =>
      'Fehler beim Erstellen des Gartens.';

  @override
  String get calendar_title => 'Anbaukalender';

  @override
  String get calendar_refreshed => 'Kalender aktualisiert';

  @override
  String get calendar_new_task_tooltip => 'Neue Aufgabe';

  @override
  String get calendar_task_saved_title => 'Aufgabe gespeichert';

  @override
  String get calendar_ask_export_pdf => 'Möchten Sie es als PDF senden?';

  @override
  String get calendar_task_modified => 'Aufgabe geändert';

  @override
  String get calendar_delete_confirm_title => 'Aufgabe löschen?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" wird gelöscht.';
  }

  @override
  String get calendar_task_deleted => 'Aufgabe gelöscht';

  @override
  String calendar_restore_error(Object error) {
    return 'Wiederherstellungsfehler: $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Löschfehler: $error';
  }

  @override
  String get calendar_action_assign => 'Senden / Zuweisen an...';

  @override
  String get calendar_assign_title => 'Zuweisen / Senden';

  @override
  String get calendar_assign_hint => 'Name oder E-Mail eingeben';

  @override
  String get calendar_assign_field => 'Name oder E-Mail';

  @override
  String calendar_task_assigned(String name) {
    return 'Aufgabe an $name zugewiesen';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Zuweisungsfehler: $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'PDF-Exportfehler: $error';
  }

  @override
  String get calendar_previous_month => 'Vorheriger Monat';

  @override
  String get calendar_next_month => 'Nächster Monat';

  @override
  String get calendar_limit_reached => 'Limit erreicht';

  @override
  String get calendar_drag_instruction => 'Wischen zum Navigieren';

  @override
  String get common_refresh => 'Aktualisieren';

  @override
  String get common_yes => 'Ja';

  @override
  String get common_no => 'Nein';

  @override
  String get common_delete => 'Löschen';

  @override
  String get common_edit => 'Bearbeiten';

  @override
  String get common_undo => 'Rückgängig';

  @override
  String common_error_prefix(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get common_retry => 'Wiederholen';

  @override
  String get calendar_no_events => 'Keine Ereignisse heute';

  @override
  String calendar_events_of(String date) {
    return 'Ereignisse am $date';
  }

  @override
  String get calendar_section_plantings => 'Pflanzungen';

  @override
  String get calendar_section_harvests => 'Erwartete Ernten';

  @override
  String get calendar_section_tasks => 'Geplante Aufgaben';

  @override
  String get calendar_filter_tasks => 'Aufgaben';

  @override
  String get calendar_filter_maintenance => 'Wartung';

  @override
  String get calendar_filter_harvests => 'Ernten';

  @override
  String get calendar_filter_urgent => 'Dringend';

  @override
  String get common_general_error => 'Ein Fehler ist aufgetreten';

  @override
  String get common_error => 'Fehler';

  @override
  String get task_editor_title_new => 'Neue Aufgabe';

  @override
  String get task_editor_title_edit => 'Aufgabe bearbeiten';

  @override
  String get task_editor_title_field => 'Titel *';

  @override
  String get activity_screen_title => 'Aktivitäten & Verlauf';

  @override
  String activity_tab_recent_garden(String gardenName) {
    return 'Kürzlich ($gardenName)';
  }

  @override
  String get activity_tab_recent_global => 'Kürzlich (Global)';

  @override
  String get activity_tab_history => 'Verlauf';

  @override
  String get activity_history_section_title => 'Verlauf — ';

  @override
  String get activity_history_empty =>
      'Kein Garten ausgewählt.\nUm den Verlauf eines Gartens zu sehen, drücken Sie lange darauf im Dashboard.';

  @override
  String get activity_empty_title => 'Keine Aktivitäten gefunden';

  @override
  String get activity_empty_subtitle =>
      'Gartenaktivitäten werden hier erscheinen';

  @override
  String get activity_error_loading => 'Fehler beim Laden der Aktivitäten';

  @override
  String get activity_priority_important => 'Wichtig';

  @override
  String get activity_priority_normal => 'Normal';

  @override
  String get activity_time_just_now => 'Gerade eben';

  @override
  String activity_time_minutes_ago(int minutes) {
    return 'vor $minutes Min';
  }

  @override
  String activity_time_hours_ago(int hours) {
    return 'vor $hours Std';
  }

  @override
  String activity_time_days_ago(int count) {
    return 'vor $count Tagen';
  }

  @override
  String activity_metadata_garden(String name) {
    return 'Garten: $name';
  }

  @override
  String activity_metadata_bed(String name) {
    return 'Beet: $name';
  }

  @override
  String activity_metadata_plant(String name) {
    return 'Pflanze: $name';
  }

  @override
  String activity_metadata_quantity(String quantity) {
    return 'Menge: $quantity';
  }

  @override
  String activity_metadata_date(String date) {
    return 'Datum: $date';
  }

  @override
  String activity_metadata_maintenance(String type) {
    return 'Wartung: $type';
  }

  @override
  String activity_metadata_weather(String weather) {
    return 'Wetter: $weather';
  }

  @override
  String get task_editor_error_title_required => 'Erforderlich';

  @override
  String get history_hint_title => 'Um den Verlauf eines Gartens zu sehen';

  @override
  String get history_hint_body =>
      'Wählen Sie ihn durch langes Drücken im Dashboard aus.';

  @override
  String get history_hint_action => 'Zum Dashboard';

  @override
  String activity_desc_garden_created(String name) {
    return 'Garten \"$name\" erstellt';
  }

  @override
  String activity_desc_bed_created(String name) {
    return 'Beet \"$name\" erstellt';
  }

  @override
  String activity_desc_planting_created(String name) {
    return 'Pflanzung von \"$name\" hinzugefügt';
  }

  @override
  String activity_desc_germination(String name) {
    return 'Keimung von \"$name\" bestätigt';
  }

  @override
  String activity_desc_harvest(String name) {
    return 'Ernte von \"$name\" aufgezeichnet';
  }

  @override
  String activity_desc_maintenance(String type) {
    return 'Wartung: $type';
  }

  @override
  String activity_desc_garden_deleted(String name) {
    return 'Garten \"$name\" gelöscht';
  }

  @override
  String activity_desc_bed_deleted(String name) {
    return 'Beet \"$name\" gelöscht';
  }

  @override
  String activity_desc_planting_deleted(String name) {
    return 'Pflanzung von \"$name\" gelöscht';
  }

  @override
  String activity_desc_garden_updated(String name) {
    return 'Garten \"$name\" aktualisiert';
  }

  @override
  String activity_desc_bed_updated(String name) {
    return 'Beet \"$name\" aktualisiert';
  }

  @override
  String activity_desc_planting_updated(String name) {
    return 'Pflanzung von \"$name\" aktualisiert';
  }

  @override
  String get planting_steps_title => 'Schritt-für-Schritt';

  @override
  String get planting_steps_add_button => 'Hinzufügen';

  @override
  String get planting_steps_see_less => 'Weniger anzeigen';

  @override
  String get planting_steps_see_all => 'Alle anzeigen';

  @override
  String get planting_steps_empty => 'Keine empfohlenen Schritte';

  @override
  String planting_steps_more(int count) {
    return '+ $count weitere Schritte';
  }

  @override
  String get planting_steps_prediction_badge => 'Vorhersage';

  @override
  String planting_steps_date_prefix(String date) {
    return 'Am $date';
  }

  @override
  String get planting_steps_done => 'Erledigt';

  @override
  String get planting_steps_mark_done => 'Als erledigt markieren';

  @override
  String get planting_steps_dialog_title => 'Schritt hinzufügen';

  @override
  String get planting_steps_dialog_hint => 'Bsp: Leichtes Mulchen';

  @override
  String get planting_steps_dialog_add => 'Hinzufügen';

  @override
  String get planting_status_sown => 'Gesät';

  @override
  String get planting_status_planted => 'Gepflanzt';

  @override
  String get planting_status_growing => 'Wachsend';

  @override
  String get planting_status_ready => 'Erntebereit';

  @override
  String get planting_status_harvested => 'Geerntet';

  @override
  String get planting_status_failed => 'Fehlgeschlagen';

  @override
  String planting_card_sown_date(String date) {
    return 'Gesät am $date';
  }

  @override
  String planting_card_planted_date(String date) {
    return 'Gepflanzt am $date';
  }

  @override
  String planting_card_harvest_estimate(String date) {
    return 'Gesch. Ernte: $date';
  }

  @override
  String get planting_info_title => 'Botanische Info';

  @override
  String get planting_info_tips_title => 'Anbautipps';

  @override
  String get planting_info_maturity => 'Reife';

  @override
  String planting_info_days(Object days) {
    return '$days Tage';
  }

  @override
  String get planting_info_spacing => 'Abstand';

  @override
  String planting_info_cm(Object cm) {
    return '$cm cm';
  }

  @override
  String get planting_info_depth => 'Tiefe';

  @override
  String get planting_info_exposure => 'Standort';

  @override
  String get planting_info_water => 'Wasser';

  @override
  String get planting_info_season => 'Pflanzsaison';

  @override
  String get planting_info_scientific_name_none =>
      'Wissenschaftlicher Name nicht verfügbar';

  @override
  String get planting_info_culture_title => 'Kulturinformationen';

  @override
  String get planting_info_germination => 'Keimdauer';

  @override
  String get planting_info_harvest_time => 'Erntezeit';

  @override
  String get planting_info_none => 'Nicht angegeben';

  @override
  String get planting_tips_none => 'Keine Tipps verfügbar';

  @override
  String get planting_history_title => 'Aktionsverlauf';

  @override
  String get planting_history_action_planting => 'Pflanzung';

  @override
  String get planting_history_todo => 'Detaillierter Verlauf kommt bald';

  @override
  String get task_editor_garden_all => 'Alle Gärten';

  @override
  String get task_editor_zone_label => 'Zone (Beet)';

  @override
  String get task_editor_zone_none => 'Keine spezifische Zone';

  @override
  String get task_editor_zone_empty => 'Keine Beete für diesen Garten';

  @override
  String get task_editor_description_label => 'Beschreibung';

  @override
  String get task_editor_date_label => 'Startdatum';

  @override
  String get task_editor_time_label => 'Zeit';

  @override
  String get task_editor_duration_label => 'Geschätzte Dauer';

  @override
  String get task_editor_duration_other => 'Andere';

  @override
  String get task_editor_type_label => 'Aufgabentyp';

  @override
  String get task_editor_priority_label => 'Priorität';

  @override
  String get task_editor_urgent_label => 'Dringend';

  @override
  String get task_editor_option_none => 'Keine (Nur speichern)';

  @override
  String get task_editor_option_share => 'Teilen (Text)';

  @override
  String get task_editor_option_pdf => 'Exportieren — PDF';

  @override
  String get task_editor_option_docx => 'Exportieren — Word (.docx)';

  @override
  String get task_editor_export_label => 'Ausgabe / Teilen';

  @override
  String get task_editor_photo_placeholder => 'Foto hinzufügen (Bald)';

  @override
  String get task_editor_action_create => 'Erstellen';

  @override
  String get task_editor_action_save => 'Speichern';

  @override
  String get task_editor_action_cancel => 'Abbrechen';

  @override
  String get task_editor_assignee_label => 'Zugewiesen an';

  @override
  String task_editor_assignee_add(String name) {
    return '\"$name\" zu Favoriten hinzufügen';
  }

  @override
  String get task_editor_assignee_none => 'Keine Ergebnisse.';

  @override
  String get task_editor_recurrence_label => 'Wiederholung';

  @override
  String get task_editor_recurrence_none => 'Keine';

  @override
  String get task_editor_recurrence_interval => 'Alle X Tage';

  @override
  String get task_editor_recurrence_weekly => 'Wöchentlich (Tage)';

  @override
  String get task_editor_recurrence_monthly => 'Monatlich (gleicher Tag)';

  @override
  String get task_editor_recurrence_repeat_label => 'Wiederholen alle ';

  @override
  String get task_editor_recurrence_days_suffix => ' T';

  @override
  String get task_kind_generic => 'Allgemein';

  @override
  String get task_kind_repair => 'Reparatur 🛠️';

  @override
  String get soil_temp_title => 'Bodentemperatur';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Diagrammfehler: $error';
  }

  @override
  String get soil_temp_about_title => 'Über Bodentemperatur';

  @override
  String get soil_temp_about_content =>
      'Die hier angezeigte Bodentemperatur wird von der Anwendung basierend auf Klima- und Saisondaten unter Verwendung einer integrierten Berechnungsformel geschätzt.\n\nDiese Schätzung liefert einen realistischen Trend der Bodentemperatur, wenn keine direkte Messung verfügbar ist.';

  @override
  String get soil_temp_formula_label => 'Verwendete Berechnungsformel:';

  @override
  String get soil_temp_formula_content =>
      'Bodentemp. = f(Lufttemp., Saison, Bodenträgheit)\n(Genaue Formel im Anwendungscode definiert)';

  @override
  String get soil_temp_current_label => 'Aktuelle Temperatur';

  @override
  String get soil_temp_action_measure => 'Bearbeiten / Messen';

  @override
  String get soil_temp_measure_hint =>
      'Sie können die Bodentemperatur im Tab \'Bearbeiten / Messen\' manuell eingeben.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Katalogfehler: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Beratungsfehler: $error';
  }

  @override
  String get soil_temp_db_empty => 'Pflanzendatenbank ist leer.';

  @override
  String get soil_temp_reload_plants => 'Pflanzen neu laden';

  @override
  String get soil_temp_no_advice => 'Keine Pflanzen mit Keimdaten gefunden.';

  @override
  String get soil_advice_status_ideal => 'Optimal';

  @override
  String get soil_advice_status_sow_now => 'Jetzt säen';

  @override
  String get soil_advice_status_sow_soon => 'Bald';

  @override
  String get soil_advice_status_wait => 'Warten';

  @override
  String get soil_sheet_title => 'Bodentemperatur';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Letzte Messung: $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'Neue Messung (Anker)';

  @override
  String get soil_sheet_input_label => 'Temperatur (°C)';

  @override
  String get soil_sheet_input_error => 'Ungültiger Wert (-10.0 bis 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Abbrechen';

  @override
  String get soil_sheet_action_save => 'Speichern';

  @override
  String get soil_sheet_snack_invalid =>
      'Ungültiger Wert. Geben Sie -10.0 bis 45.0 ein';

  @override
  String get soil_sheet_snack_success => 'Messung als Anker gespeichert';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get weather_screen_title => 'Wetter';

  @override
  String get weather_provider_credit => 'Daten bereitgestellt von Open-Meteo';

  @override
  String get weather_error_loading => 'Wetter konnte nicht geladen werden';

  @override
  String get weather_action_retry => 'Wiederholen';

  @override
  String get weather_header_next_24h => 'NÄCHSTE 24H';

  @override
  String get weather_header_daily_summary => 'TÄGLICHE ZUSAMMENFASSUNG';

  @override
  String get weather_header_precipitations => 'NIEDERSCHLAG (24h)';

  @override
  String get weather_label_wind => 'WIND';

  @override
  String get weather_label_pressure => 'DRUCK';

  @override
  String get weather_label_sun => 'SONNE';

  @override
  String get weather_label_astro => 'ASTRO';

  @override
  String get weather_data_speed => 'Geschw.';

  @override
  String get weather_data_gusts => 'Böen';

  @override
  String get weather_data_sunrise => 'Sonnenaufgang';

  @override
  String get weather_data_sunset => 'Sonnenuntergang';

  @override
  String get weather_data_rain => 'Regen';

  @override
  String get weather_data_max => 'Max';

  @override
  String get weather_data_min => 'Min';

  @override
  String get weather_data_wind_max => 'Max Wind';

  @override
  String get weather_pressure_high => 'Hoch';

  @override
  String get weather_pressure_low => 'Tief';

  @override
  String get weather_today_label => 'Heute';

  @override
  String get moon_phase_new => 'Neumond';

  @override
  String get moon_phase_waxing_crescent => 'Zunehmender Sichelmond';

  @override
  String get moon_phase_first_quarter => 'Erstes Viertel';

  @override
  String get moon_phase_waxing_gibbous => 'Zunehmender Mond';

  @override
  String get moon_phase_full => 'Vollmond';

  @override
  String get moon_phase_waning_gibbous => 'Abnehmender Mond';

  @override
  String get moon_phase_last_quarter => 'Letztes Viertel';

  @override
  String get moon_phase_waning_crescent => 'Abnehmender Sichelmond';

  @override
  String get wmo_code_0 => 'Klarer Himmel';

  @override
  String get wmo_code_1 => 'Überwiegend klar';

  @override
  String get wmo_code_2 => 'Teilweise bewölkt';

  @override
  String get wmo_code_3 => 'Bedeckt';

  @override
  String get wmo_code_45 => 'Nebel';

  @override
  String get wmo_code_48 => 'Nebel mit Reifbildung';

  @override
  String get wmo_code_51 => 'Leichter Sprühregen';

  @override
  String get wmo_code_53 => 'Mäßiger Sprühregen';

  @override
  String get wmo_code_55 => 'Dichter Sprühregen';

  @override
  String get wmo_code_61 => 'Leichter Regen';

  @override
  String get wmo_code_63 => 'Mäßiger Regen';

  @override
  String get wmo_code_65 => 'Starker Regen';

  @override
  String get wmo_code_66 => 'Leichter gefrierender Regen';

  @override
  String get wmo_code_67 => 'Starker gefrierender Regen';

  @override
  String get wmo_code_71 => 'Leichter Schneefall';

  @override
  String get wmo_code_73 => 'Mäßiger Schneefall';

  @override
  String get wmo_code_75 => 'Starker Schneefall';

  @override
  String get wmo_code_77 => 'Schneegriesel';

  @override
  String get wmo_code_80 => 'Leichte Regenschauer';

  @override
  String get wmo_code_81 => 'Mäßige Regenschauer';

  @override
  String get wmo_code_82 => 'Heftige Regenschauer';

  @override
  String get wmo_code_85 => 'Leichte Schneeschauer';

  @override
  String get wmo_code_86 => 'Starke Schneeschauer';

  @override
  String get wmo_code_95 => 'Gewitter';

  @override
  String get wmo_code_96 => 'Gewitter mit leichtem Hagel';

  @override
  String get wmo_code_99 => 'Gewitter mit starkem Hagel';

  @override
  String get wmo_code_unknown => 'Unbekannte Bedingungen';

  @override
  String get task_kind_buy => 'Kaufen 🛒';

  @override
  String get task_kind_clean => 'Reinigen 🧹';

  @override
  String get task_kind_watering => 'Gießen 💧';

  @override
  String get task_kind_seeding => 'Aussäen 🌱';

  @override
  String get task_kind_pruning => 'Beschneiden ✂️';

  @override
  String get task_kind_weeding => 'Jäten 🌿';

  @override
  String get task_kind_amendment => 'Bodenverbesserung 🪵';

  @override
  String get task_kind_treatment => 'Behandlung 🧪';

  @override
  String get task_kind_harvest => 'Ernten 🧺';

  @override
  String get task_kind_winter_protection => 'Winterschutz ❄️';

  @override
  String get garden_detail_title_error => 'Fehler';

  @override
  String get garden_detail_subtitle_not_found =>
      'Der angeforderte Garten existiert nicht oder wurde gelöscht.';

  @override
  String garden_detail_subtitle_error_beds(Object error) {
    return 'Beete konnten nicht geladen werden: $error';
  }

  @override
  String get garden_action_edit => 'Bearbeiten';

  @override
  String get garden_action_archive => 'Archivieren';

  @override
  String get garden_action_unarchive => 'Dearchivieren';

  @override
  String get garden_action_delete => 'Löschen';

  @override
  String garden_created_at(Object date) {
    return 'Erstellt am $date';
  }

  @override
  String get garden_bed_delete_confirm_title => 'Beet löschen';

  @override
  String garden_bed_delete_confirm_body(Object bedName) {
    return 'Sind Sie sicher, dass Sie \"$bedName\" löschen möchten? Diese Aktion ist unwiderruflich.';
  }

  @override
  String get garden_bed_deleted_snack => 'Beet gelöscht';

  @override
  String garden_bed_delete_error(Object error) {
    return 'Fehler beim Löschen des Beets: $error';
  }

  @override
  String get common_back => 'Zurück';

  @override
  String get garden_action_disable => 'Deaktivieren';

  @override
  String get garden_action_enable => 'Aktivieren';

  @override
  String get garden_action_modify => 'Modifizieren';

  @override
  String get bed_create_title_new => 'Neues Beet';

  @override
  String get bed_create_title_edit => 'Beet bearbeiten';

  @override
  String get bed_form_name_label => 'Beetname *';

  @override
  String get bed_form_name_hint => 'Bsp: Nordbeet, Parzelle 1';

  @override
  String get bed_form_size_label => 'Fläche (m²) *';

  @override
  String get bed_form_size_hint => 'Bsp: 10.5';

  @override
  String get bed_form_desc_label => 'Beschreibung';

  @override
  String get bed_form_desc_hint => 'Beschreibung...';

  @override
  String get bed_form_submit_create => 'Erstellen';

  @override
  String get bed_form_submit_edit => 'Speichern';

  @override
  String get bed_snack_created => 'Beet erfolgreich erstellt';

  @override
  String get bed_snack_updated => 'Beet erfolgreich aktualisiert';

  @override
  String get bed_form_error_name_required => 'Name ist erforderlich';

  @override
  String get bed_form_error_name_length =>
      'Name muss mindestens 2 Zeichen lang sein';

  @override
  String get bed_form_error_size_required => 'Fläche ist erforderlich';

  @override
  String get bed_form_error_size_invalid =>
      'Bitte geben Sie eine gültige Fläche ein';

  @override
  String get bed_form_error_size_max =>
      'Fläche darf 1000 m² nicht überschreiten';

  @override
  String get status_sown => 'Gesät';

  @override
  String get status_planted => 'Gepflanzt';

  @override
  String get status_growing => 'Wachsend';

  @override
  String get status_ready_to_harvest => 'Erntebereit';

  @override
  String get status_harvested => 'Geerntet';

  @override
  String get status_failed => 'Fehlgeschlagen';

  @override
  String bed_card_sown_on(Object date) {
    return 'Gesät am $date';
  }

  @override
  String get bed_card_harvest_start => 'ca. Erntebeginn';

  @override
  String get bed_action_harvest => 'Ernten';

  @override
  String get lifecycle_error_title => 'Fehler bei der Zyklusberechnung';

  @override
  String get lifecycle_error_prefix => 'Fehler: ';

  @override
  String get lifecycle_cycle_completed => 'Zyklus abgeschlossen';

  @override
  String get lifecycle_stage_germination => 'Keimung';

  @override
  String get lifecycle_stage_growth => 'Wachstum';

  @override
  String get lifecycle_stage_fruiting => 'Fruchtbildung';

  @override
  String get lifecycle_stage_harvest => 'Ernte';

  @override
  String get lifecycle_stage_unknown => 'Unbekannt';

  @override
  String get lifecycle_harvest_expected => 'Erwartete Ernte';

  @override
  String lifecycle_in_days(Object days) {
    return 'In $days Tagen';
  }

  @override
  String get lifecycle_passed => 'Vergangen';

  @override
  String get lifecycle_now => 'Jetzt!';

  @override
  String get lifecycle_next_action => 'Nächste Aktion';

  @override
  String get lifecycle_update => 'Zyklus aktualisieren';

  @override
  String lifecycle_days_ago(Object days) {
    return 'vor $days Tagen';
  }

  @override
  String get planting_detail_title => 'Pflanzdetails';

  @override
  String get companion_beneficial => 'Nützliche Pflanzen';

  @override
  String get companion_avoid => 'Zu vermeidende Pflanzen';

  @override
  String get common_close => 'Schließen';

  @override
  String get bed_detail_surface => 'Fläche';

  @override
  String get bed_detail_details => 'Details';

  @override
  String get bed_detail_notes => 'Notizen';

  @override
  String get bed_detail_current_plantings => 'Aktuelle Pflanzungen';

  @override
  String get bed_detail_no_plantings_title => 'Keine Pflanzungen';

  @override
  String get bed_detail_no_plantings_desc =>
      'Dieses Beet hat noch keine Pflanzungen.';

  @override
  String get bed_detail_add_planting => 'Pflanzung hinzufügen';

  @override
  String get bed_delete_planting_confirm_title => 'Pflanzung löschen?';

  @override
  String get bed_delete_planting_confirm_body =>
      'Diese Aktion ist unwiderruflich. Möchten Sie diese Pflanzung wirklich löschen?';

  @override
  String harvest_title(Object plantName) {
    return 'Ernte: $plantName';
  }

  @override
  String get harvest_weight_label => 'Erntegewicht (kg) *';

  @override
  String get harvest_price_label => 'Geschätzter Preis (€/kg)';

  @override
  String get harvest_price_helper =>
      'Wird für zukünftige Ernten dieser Pflanze gespeichert';

  @override
  String get harvest_notes_label => 'Notizen / Qualität';

  @override
  String get harvest_action_save => 'Speichern';

  @override
  String get harvest_snack_saved => 'Ernte aufgezeichnet';

  @override
  String get harvest_snack_error => 'Fehler bei der Ernteaufzeichnung';

  @override
  String get harvest_form_error_required => 'Erforderlich';

  @override
  String get harvest_form_error_positive => 'Ungültig (> 0)';

  @override
  String get harvest_form_error_positive_or_zero => 'Ungültig (>= 0)';

  @override
  String get info_exposure_full_sun => 'Volle Sonne';

  @override
  String get info_exposure_partial_sun => 'Teilweise Sonne';

  @override
  String get info_exposure_shade => 'Schatten';

  @override
  String get info_water_low => 'Niedrig';

  @override
  String get info_water_medium => 'Mittel';

  @override
  String get info_water_high => 'Hoch';

  @override
  String get info_water_moderate => 'Mäßig';

  @override
  String get info_season_spring => 'Frühling';

  @override
  String get info_season_summer => 'Sommer';

  @override
  String get info_season_autumn => 'Herbst';

  @override
  String get info_season_winter => 'Winter';

  @override
  String get info_season_all => 'Alle Jahreszeiten';

  @override
  String get common_duplicate => 'Duplizieren';

  @override
  String get planting_delete_title => 'Pflanzung löschen';

  @override
  String get planting_delete_confirm_body =>
      'Sind Sie sicher, dass Sie diese Pflanzung löschen möchten? Diese Aktion ist unwiderruflich.';

  @override
  String get planting_creation_title => 'Neue Pflanzung';

  @override
  String get planting_creation_title_edit => 'Pflanzung bearbeiten';

  @override
  String get planting_quantity_seeds => 'Anzahl Samen';

  @override
  String get planting_quantity_plants => 'Anzahl Pflanzen';

  @override
  String get planting_quantity_required => 'Menge ist erforderlich';

  @override
  String get planting_quantity_positive => 'Menge muss eine positive Zahl sein';

  @override
  String planting_plant_selection_label(Object plantName) {
    return 'Pflanze: $plantName';
  }

  @override
  String get planting_no_plant_selected => 'Keine Pflanze ausgewählt';

  @override
  String get planting_custom_plant_title => 'Benutzerdefinierte Pflanze';

  @override
  String get planting_plant_name_label => 'Pflanzenname';

  @override
  String get planting_plant_name_hint => 'Bsp: Kirschtomate';

  @override
  String get planting_plant_name_required => 'Pflanzenname ist erforderlich';

  @override
  String get planting_notes_label => 'Notizen (optional)';

  @override
  String get planting_notes_hint => 'Zusätzliche Informationen...';

  @override
  String get planting_tips_title => 'Tipps';

  @override
  String get planting_tips_catalog =>
      '• Nutzen Sie den Katalog, um eine Pflanze auszuwählen.';

  @override
  String get planting_tips_type =>
      '• Wählen Sie \"Gesät\" für Samen, \"Gepflanzt\" für Setzlinge.';

  @override
  String get planting_tips_notes =>
      '• Fügen Sie Notizen hinzu, um spezielle Bedingungen zu verfolgen.';

  @override
  String get planting_date_future_error =>
      'Pflanzdatum kann nicht in der Zukunft liegen';

  @override
  String get planting_success_create => 'Pflanzung erfolgreich erstellt';

  @override
  String get planting_success_update => 'Pflanzung erfolgreich aktualisiert';

  @override
  String get stats_screen_title => 'Statistiken';

  @override
  String get stats_screen_subtitle =>
      'Analysieren Sie in Echtzeit und exportieren Sie Ihre Daten.';

  @override
  String get kpi_alignment_title => 'Lebendige Ausrichtung';

  @override
  String get kpi_alignment_description =>
      'Dieses Tool bewertet, wie nah Ihre Aussaaten, Pflanzungen und Ernten an den von der Intelligenten Agenda empfohlenen idealen Zeitfenstern liegen.';

  @override
  String get kpi_alignment_cta =>
      'Beginnen Sie zu pflanzen und zu ernten, um Ihre Ausrichtung zu sehen!';

  @override
  String get kpi_alignment_aligned => 'ausgerichtet';

  @override
  String get kpi_alignment_total => 'Gesamt';

  @override
  String get kpi_alignment_aligned_actions => 'Ausgerichtet';

  @override
  String get kpi_alignment_misaligned_actions => 'Fehlausgerichtet';

  @override
  String get kpi_alignment_calculating => 'Berechne Ausrichtung...';

  @override
  String get kpi_alignment_error => 'Fehler bei der Berechnung';

  @override
  String get pillar_economy_title => 'Gartenökonomie';

  @override
  String get pillar_nutrition_title => 'Ernährungsbilanz';

  @override
  String get pillar_export_title => 'Exportieren';

  @override
  String get pillar_economy_label => 'Gesamternte­wert';

  @override
  String get pillar_nutrition_label => 'Ernährungssignatur';

  @override
  String get pillar_export_label => 'Ihre Daten abrufen';

  @override
  String get pillar_export_button => 'Exportieren';

  @override
  String get stats_economy_title => 'Gartenökonomie';

  @override
  String get stats_economy_no_harvest =>
      'Keine Ernte im ausgewählten Zeitraum.';

  @override
  String get stats_economy_no_harvest_desc =>
      'Keine Daten für den ausgewählten Zeitraum.';

  @override
  String get stats_kpi_total_revenue => 'Gesamtumsatz';

  @override
  String get stats_kpi_total_volume => 'Gesamtvolumen';

  @override
  String get stats_kpi_avg_price => 'Durchschnittspreis';

  @override
  String get stats_top_cultures_title => 'Top-Kulturen (Wert)';

  @override
  String get stats_top_cultures_no_data => 'Keine Daten';

  @override
  String get stats_top_cultures_percent_revenue => 'des Umsatzes';

  @override
  String get stats_monthly_revenue_title => 'Monatlicher Umsatz';

  @override
  String get stats_monthly_revenue_no_data => 'Keine monatlichen Daten';

  @override
  String get stats_dominant_culture_title => 'Dominante Kultur pro Monat';

  @override
  String get stats_annual_evolution_title => 'Jahrestrend';

  @override
  String get stats_crop_distribution_title => 'Kulturverteilung';

  @override
  String get stats_crop_distribution_others => 'Andere';

  @override
  String get stats_key_months_title => 'Wichtige Gartenmonate';

  @override
  String get stats_most_profitable => 'Am profitabelsten';

  @override
  String get stats_least_profitable => 'Am wenigsten profitabel';

  @override
  String get stats_auto_summary_title => 'Auto-Zusammenfassung';

  @override
  String get stats_revenue_history_title => 'Umsatzverlauf';

  @override
  String get stats_profitability_cycle_title => 'Rentabilitätszyklus';

  @override
  String get stats_table_crop => 'Kultur';

  @override
  String get stats_table_days => 'Tage (Ø)';

  @override
  String get stats_table_revenue => 'Umsatz/Ernte';

  @override
  String get stats_table_type => 'Typ';

  @override
  String get stats_type_fast => 'Schnell';

  @override
  String get stats_type_long_term => 'Langfristig';

  @override
  String get nutrition_page_title => 'Ernährungssignatur';

  @override
  String get nutrition_seasonal_dynamics_title => 'Saisonale Dynamik';

  @override
  String get nutrition_seasonal_dynamics_desc =>
      'Entdecken Sie die Mineral- und Vitaminproduktion Ihres Gartens, Monat für Monat.';

  @override
  String get nutrition_no_harvest_month => 'Keine Ernte in diesem Monat';

  @override
  String get nutrition_major_minerals_title => 'Struktur & Hauptmineralien';

  @override
  String get nutrition_trace_elements_title => 'Vitalität & Spurenelemente';

  @override
  String get nutrition_no_data_period => 'Keine Daten für diesen Zeitraum';

  @override
  String get nutrition_no_major_minerals => 'Keine Hauptmineralien';

  @override
  String get nutrition_no_trace_elements => 'Keine Spurenelemente';

  @override
  String nutrition_month_dynamics_title(String month) {
    return 'Dynamik von $month';
  }

  @override
  String get nutrition_dominant_production => 'Dominante Produktion:';

  @override
  String get nutrition_nutrients_origin =>
      'Diese Nährstoffe stammen aus Ihren Ernten des Monats.';

  @override
  String get nut_calcium => 'Kalzium';

  @override
  String get nut_potassium => 'Kalium';

  @override
  String get nut_magnesium => 'Magnesium';

  @override
  String get nut_iron => 'Eisen';

  @override
  String get nut_zinc => 'Zink';

  @override
  String get nut_manganese => 'Mangan';

  @override
  String get nut_vitamin_c => 'Vitamin C';

  @override
  String get nut_fiber => 'Ballaststoffe';

  @override
  String get nut_protein => 'Protein';

  @override
  String get export_builder_title => 'Export-Builder';

  @override
  String get export_scope_section => '1. Umfang';

  @override
  String get export_scope_period => 'Zeitraum';

  @override
  String get export_scope_period_all => 'Gesamter Verlauf';

  @override
  String get export_filter_garden_title => 'Nach Garten filtern';

  @override
  String get export_filter_garden_all => 'Alle Gärten';

  @override
  String export_filter_garden_count(Object count) {
    return '$count Garten/Gärten ausgewählt';
  }

  @override
  String get export_filter_garden_edit => 'Auswahl bearbeiten';

  @override
  String get export_filter_garden_select_dialog_title => 'Gärten auswählen';

  @override
  String get export_blocks_section => '2. Datenblöcke';

  @override
  String get export_block_activity => 'Aktivitäten (Journal)';

  @override
  String get export_block_harvest => 'Ernten (Produktion)';

  @override
  String get export_block_garden => 'Gärten (Struktur)';

  @override
  String get export_block_garden_bed => 'Beete (Struktur)';

  @override
  String get export_block_plant => 'Pflanzen (Katalog)';

  @override
  String get export_block_desc_activity =>
      'Vollständiger Verlauf der Interventionen und Ereignisse';

  @override
  String get export_block_desc_harvest => 'Produktionsdaten und Erträge';

  @override
  String get export_block_desc_garden => 'Metadaten der ausgewählten Gärten';

  @override
  String get export_block_desc_garden_bed =>
      'Beetdetails (Fläche, Ausrichtung...)';

  @override
  String get export_block_desc_plant => 'Liste der verwendeten Pflanzen';

  @override
  String get export_columns_section => '3. Details & Spalten';

  @override
  String export_columns_count(Object count) {
    return '$count Spalten ausgewählt';
  }

  @override
  String get export_format_section => '4. Dateiformat';

  @override
  String get export_format_separate => 'Separate Blätter (Standard)';

  @override
  String get export_format_separate_subtitle =>
      'Ein Blatt pro Datentyp (Empfohlen)';

  @override
  String get export_format_flat => 'Einzelne Tabelle (Flach / BI)';

  @override
  String get export_format_flat_subtitle =>
      'Eine große Tabelle für Pivot-Tabellen';

  @override
  String get export_action_generate => 'Excel-Export generieren';

  @override
  String get export_generating => 'Generiere...';

  @override
  String get export_success_title => 'Export abgeschlossen';

  @override
  String get export_success_share_text => 'Hier ist Ihr PermaCalendar Export';

  @override
  String export_error_snack(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get export_field_garden_name => 'Gartenname';

  @override
  String get export_field_garden_id => 'Garten-ID';

  @override
  String get export_field_garden_surface => 'Fläche (m²)';

  @override
  String get export_field_garden_creation => 'Erstellungsdatum';

  @override
  String get export_field_bed_name => 'Beetname';

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
  String get plant_catalog_sow => 'Säen';

  @override
  String get plant_catalog_plant => 'Pflanzen';

  @override
  String get plant_catalog_show_selection => 'Auswahl ansehen';

  @override
  String get plant_catalog_filter_green_only => 'Nur Grüne';

  @override
  String get plant_catalog_filter_green_orange => 'Grün + Orange';

  @override
  String get plant_catalog_filter_all => 'Alle';

  @override
  String get plant_catalog_no_recommended =>
      'Keine Pflanzen für diesen Zeitraum empfohlen.';

  @override
  String get plant_catalog_expand_window => 'Erweitern (±2 Monate)';

  @override
  String get plant_catalog_missing_period_data => 'Fehlende Zeitraumsdaten';

  @override
  String plant_catalog_periods_prefix(String months) {
    return 'Zeiträume: $months';
  }

  @override
  String get plant_catalog_legend_green => 'Bereit diesen Monat';

  @override
  String get plant_catalog_legend_orange => 'Nahe / Bald';

  @override
  String get plant_catalog_legend_red => 'Außerhalb der Saison';

  @override
  String get plant_catalog_data_unknown => 'Unbekannte Daten';
}
