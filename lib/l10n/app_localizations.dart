import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt')
  ];

  /// Titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'Sowing'**
  String get appTitle;

  /// Titre de la page des paramètres
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings_title;

  /// Label accessibilité pour le hotspot de paramètres sur l'accueil
  ///
  /// In fr, this message translates to:
  /// **'Paramètres (repli)'**
  String get home_settings_fallback_label;

  /// Rubrique 'Application' dans les paramètres
  ///
  /// In fr, this message translates to:
  /// **'Application'**
  String get settings_application;

  /// Label pour la version de l'application
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settings_version;

  /// Titre de la section Affichage
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get settings_display;

  /// Titre de la section Sélecteur météo
  ///
  /// In fr, this message translates to:
  /// **'Sélecteur météo'**
  String get settings_weather_selector;

  /// Titre du paramètre Commune pour la météo
  ///
  /// In fr, this message translates to:
  /// **'Commune pour la météo'**
  String get settings_commune_title;

  /// Titre/drawer pour choisir une commune
  ///
  /// In fr, this message translates to:
  /// **'Choisir une commune'**
  String get settings_choose_commune;

  /// Hint text pour la recherche de commune
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une commune…'**
  String get settings_search_commune_hint;

  /// Texte indiquant la commune par défaut
  ///
  /// In fr, this message translates to:
  /// **'Défaut: {label}'**
  String settings_commune_default(String label);

  /// Texte indiquant la commune sélectionnée
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnée: {label}'**
  String settings_commune_selected(String label);

  /// Titre de la zone Accès rapide dans les paramètres
  ///
  /// In fr, this message translates to:
  /// **'Accès rapide'**
  String get settings_quick_access;

  /// Libellé pour l'accès au catalogue des plantes
  ///
  /// In fr, this message translates to:
  /// **'Catalogue des plantes'**
  String get settings_plants_catalog;

  /// Titre de la section À propos
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settings_about;

  /// Label pour le guide d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'Guide d\'utilisation'**
  String get settings_user_guide;

  /// Label Confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get settings_privacy;

  /// Titre / label de la politique de confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get settings_privacy_policy;

  /// Titre / label des conditions d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get settings_terms;

  /// Titre de la boîte de dialogue d'information sur la version
  ///
  /// In fr, this message translates to:
  /// **'Version de l\'application'**
  String get settings_version_dialog_title;

  /// Contenu de la boîte de dialogue de version
  ///
  /// In fr, this message translates to:
  /// **'Version: {version} – Gestion de jardin dynamique\n\nPermaculturo - Gestion de jardins vivants'**
  String settings_version_dialog_content(String version);

  /// Titre de la page de sélection de la langue
  ///
  /// In fr, this message translates to:
  /// **'Langue / Language'**
  String get language_title;

  /// Nom de la langue française
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get language_french;

  /// Nom de la langue anglaise
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get language_english;

  /// Nom de la langue espagnole
  ///
  /// In fr, this message translates to:
  /// **'Español'**
  String get language_spanish;

  /// Nom de la langue portugaise (Brésil)
  ///
  /// In fr, this message translates to:
  /// **'Português (Brasil)'**
  String get language_portuguese_br;

  /// Nom de la langue allemande
  ///
  /// In fr, this message translates to:
  /// **'Deutsch'**
  String get language_german;

  /// Message affiché en snackBar après changement de langue
  ///
  /// In fr, this message translates to:
  /// **'Langue changée : {label}'**
  String language_changed_snackbar(String label);

  /// Titre écran liste des jardins
  ///
  /// In fr, this message translates to:
  /// **'Mes jardins'**
  String get garden_list_title;

  /// Titre pour l'état d'erreur sur la liste des jardins
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get garden_error_title;

  /// Message d'erreur détaillé pour jardin
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la liste des jardins : {error}'**
  String garden_error_subtitle(String error);

  /// Texte du bouton Réessayer
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get garden_retry;

  /// Message affiché si aucun jardin actif
  ///
  /// In fr, this message translates to:
  /// **'Aucun jardin pour le moment.'**
  String get garden_no_gardens;

  /// Info affichée lorsque des jardins sont archivés
  ///
  /// In fr, this message translates to:
  /// **'Vous avez des jardins archivés. Activez l’affichage des jardins archivés pour les voir.'**
  String get garden_archived_info;

  /// Tooltip du FAB pour ajouter un jardin
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un jardin'**
  String get garden_add_tooltip;

  /// Titre de l'écran catalogue de plantes
  ///
  /// In fr, this message translates to:
  /// **'Catalogue de plantes'**
  String get plant_catalog_title;

  /// Texte du badge pour plante personnalisée
  ///
  /// In fr, this message translates to:
  /// **'Perso'**
  String get plant_custom_badge;

  /// Titre affiché si une plante n'existe pas
  ///
  /// In fr, this message translates to:
  /// **'Plante introuvable'**
  String get plant_detail_not_found_title;

  /// Message affiché lorsque la plante n'a pas été chargée
  ///
  /// In fr, this message translates to:
  /// **'Cette plante n\'existe pas ou n\'a pas pu être chargée.'**
  String get plant_detail_not_found_body;

  /// SnackBar indiquant qu'une plante a été ajoutée aux favoris
  ///
  /// In fr, this message translates to:
  /// **'{plant} ajouté aux favoris'**
  String plant_added_favorites(String plant);

  /// Texte du menu contextuel pour ajouter une plante au jardin
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au jardin'**
  String get plant_detail_popup_add_to_garden;

  /// Texte du menu contextuel pour partager
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get plant_detail_popup_share;

  /// SnackBar indiquant que le partage n'est pas encore implémenté
  ///
  /// In fr, this message translates to:
  /// **'Partage à implémenter'**
  String get plant_detail_share_todo;

  /// SnackBar indiquant que l'ajout au jardin est à implémenter
  ///
  /// In fr, this message translates to:
  /// **'Ajout au jardin à implémenter'**
  String get plant_detail_add_to_garden_todo;

  /// Titre section Détails de culture
  ///
  /// In fr, this message translates to:
  /// **'Détails de culture'**
  String get plant_detail_section_culture;

  /// Titre section Instructions générales
  ///
  /// In fr, this message translates to:
  /// **'Instructions générales'**
  String get plant_detail_section_instructions;

  /// Label Famille dans le détail plante
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get plant_detail_detail_family;

  /// Label Durée de maturation
  ///
  /// In fr, this message translates to:
  /// **'Durée de maturation'**
  String get plant_detail_detail_maturity;

  /// Label Espacement
  ///
  /// In fr, this message translates to:
  /// **'Espacement'**
  String get plant_detail_detail_spacing;

  /// Label Exposition
  ///
  /// In fr, this message translates to:
  /// **'Exposition'**
  String get plant_detail_detail_exposure;

  /// Label Besoins en eau
  ///
  /// In fr, this message translates to:
  /// **'Besoins en eau'**
  String get plant_detail_detail_water;

  /// Titre de l'écran des plantations, contient le nom de la parcelle
  ///
  /// In fr, this message translates to:
  /// **'Plantations - {gardenBedName}'**
  String planting_title_template(String gardenBedName);

  /// Menu item Statistiques
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get planting_menu_statistics;

  /// Menu item Prêt à récolter
  ///
  /// In fr, this message translates to:
  /// **'Prêt à récolter'**
  String get planting_menu_ready_for_harvest;

  /// Menu item Données test
  ///
  /// In fr, this message translates to:
  /// **'Données test'**
  String get planting_menu_test_data;

  /// Hint de recherche sur la liste de plantations
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une plantation...'**
  String get planting_search_hint;

  /// Filtre Tous les statuts
  ///
  /// In fr, this message translates to:
  /// **'Tous les statuts'**
  String get planting_filter_all_statuses;

  /// Filtre Toutes les plantes
  ///
  /// In fr, this message translates to:
  /// **'Toutes les plantes'**
  String get planting_filter_all_plants;

  /// Label statistiques : Plantations
  ///
  /// In fr, this message translates to:
  /// **'Plantations'**
  String get planting_stat_plantings;

  /// Label statistiques : Quantité totale
  ///
  /// In fr, this message translates to:
  /// **'Quantité totale'**
  String get planting_stat_total_quantity;

  /// Label statistiques : Taux de réussite
  ///
  /// In fr, this message translates to:
  /// **'Taux de réussite'**
  String get planting_stat_success_rate;

  /// Label statistiques : En croissance
  ///
  /// In fr, this message translates to:
  /// **'En croissance'**
  String get planting_stat_in_growth;

  /// Label statistiques : Prêt à récolter
  ///
  /// In fr, this message translates to:
  /// **'Prêt à récolter'**
  String get planting_stat_ready_for_harvest;

  /// Titre pour l'état vide des plantations
  ///
  /// In fr, this message translates to:
  /// **'Aucune plantation'**
  String get planting_empty_none;

  /// Texte incitatif si aucune plantation n'existe
  ///
  /// In fr, this message translates to:
  /// **'Commencez par ajouter votre première plantation dans cette parcelle.'**
  String get planting_empty_first;

  /// Texte du bouton pour créer une plantation
  ///
  /// In fr, this message translates to:
  /// **'Créer une plantation'**
  String get planting_create_action;

  /// Titre pour l'état 'aucun résultat' dans la recherche
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get planting_empty_no_result;

  /// Action pour effacer les filtres
  ///
  /// In fr, this message translates to:
  /// **'Effacer les filtres'**
  String get planting_clear_filters;

  /// Tooltip du FAB pour ajouter une plantation
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une plantation'**
  String get planting_add_tooltip;

  /// Hint générique pour la barre de recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher...'**
  String get search_hint;

  /// Titre pour la page d'erreur 'page non trouvée'
  ///
  /// In fr, this message translates to:
  /// **'Page non trouvée'**
  String get error_page_title;

  /// Message expliquant que la page demandée n'existe pas
  ///
  /// In fr, this message translates to:
  /// **'La page \"{uri}\" n\'existe pas.'**
  String error_page_message(String uri);

  /// Bouton pour revenir à l'accueil depuis la page d'erreur
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get error_page_back;

  /// Texte du bouton Confirmer dans les dialogues
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get dialog_confirm;

  /// Texte du bouton Annuler dans les dialogues
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get dialog_cancel;

  /// SnackBar indiquant la commune sélectionnée
  ///
  /// In fr, this message translates to:
  /// **'Commune sélectionnée: {name}'**
  String snackbar_commune_selected(String name);

  /// Texte générique Valider
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get common_validate;

  /// Texte générique Annuler (duplicate kept for backward compatibility)
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get common_cancel;

  /// Action générique pour créer quelque chose depuis un état vide
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get empty_action_create;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
