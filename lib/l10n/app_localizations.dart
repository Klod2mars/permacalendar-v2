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

  /// Sous-titre pour le catalogue des plantes
  ///
  /// In fr, this message translates to:
  /// **'Rechercher et consulter les plantes'**
  String get settings_plants_catalog_subtitle;

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

  /// Sous-titre pour le guide d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'Consulter la notice'**
  String get settings_user_guide_subtitle;

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
  /// **'Version: {version} – Gestion de jardin dynamique\n\nSowing - Gestion de jardins vivants'**
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

  /// Titre de la section Calibration
  ///
  /// In fr, this message translates to:
  /// **'Calibration'**
  String get calibration_title;

  /// Sous-titre de la section Calibration
  ///
  /// In fr, this message translates to:
  /// **'Personnalisez l\'affichage de votre dashboard'**
  String get calibration_subtitle;

  /// Titre de la carte Calibration Organique
  ///
  /// In fr, this message translates to:
  /// **'Calibration Organique'**
  String get calibration_organic_title;

  /// Sous-titre de la carte Calibration Organique
  ///
  /// In fr, this message translates to:
  /// **'Mode unifié : Image, Ciel, Modules'**
  String get calibration_organic_subtitle;

  /// SnackBar désactivation calibration
  ///
  /// In fr, this message translates to:
  /// **'🌿 Calibration organique désactivée'**
  String get calibration_organic_disabled;

  /// SnackBar activation calibration
  ///
  /// In fr, this message translates to:
  /// **'🌿 Mode calibration organique activé. Sélectionnez l’un des trois onglets.'**
  String get calibration_organic_enabled;

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

  /// Indication visuelle dans la barre de recherche du catalogue
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une plante...'**
  String get plant_catalog_search_hint;

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

  /// Texte générique Enregistrer
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get common_save;

  /// Action générique pour créer quelque chose depuis un état vide
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get empty_action_create;

  /// Texte complet du guide d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'1 — Bienvenue dans Sowing\nSowing est une application pensée pour accompagner les jardiniers et jardinières dans le suivi vivant et concret de leurs cultures.\nElle vous permet de :\n• organiser vos jardins et vos parcelles,\n• suivre vos plantations tout au long de leur cycle de vie,\n• planifier vos tâches au bon moment,\n• conserver la mémoire de ce qui a été fait,\n• prendre en compte la météo locale et le rythme des saisons.\nL’application fonctionne principalement hors ligne et conserve vos données directement sur votre appareil.\nCette notice décrit l’utilisation courante de Sowing : prise en main, création des jardins, plantations, calendrier, météo, export des données et bonnes pratiques.\n\n2 — Comprendre l’interface\nLe tableau de bord\nÀ l’ouverture, Sowing affiche un tableau de bord visuel et organique.\nIl se présente sous la forme d’une image de fond animée par des bulles interactives. Chaque bulle donne accès à une grande fonction de l’application :\n• jardins,\n• météo de l’air,\n• météo du sol,\n• calendrier,\n• activités,\n• statistiques,\n• paramètres.\nNavigation générale\nIl suffit de toucher une bulle pour ouvrir la section correspondante.\nÀ l’intérieur des pages, vous trouverez selon les contextes :\n• des menus contextuels,\n• des boutons « + » pour ajouter un élément,\n• des boutons d’édition ou de suppression.\n\n3 — Démarrage rapide\nOuvrir l’application\nAu lancement, le tableau de bord s’affiche automatiquement.\nConfigurer la météo\nDans les paramètres, choisissez votre commune.\nCette information permet à Sowing d’afficher une météo locale adaptée à votre jardin. Si aucune commune n’est sélectionnée, une localisation par défaut est utilisée.\nCréer votre premier jardin\nLors de la première utilisation, Sowing vous guide automatiquement pour créer votre premier jardin.\nVous pouvez également créer un jardin manuellement depuis le tableau de bord.\nSur l’écran principal, touchez la feuille verte située dans la zone la plus libre, à droite des statistiques et légèrement au‑dessus. Cette zone volontairement discrète permet d’initier la création d’un jardin.\nVous pouvez créer jusqu’à cinq jardins.\nCette approche fait partie de l’expérience Sowing : il n’existe pas de bouton « + » permanent et central. L’application invite plutôt à l’exploration et à la découverte progressive de l’espace.\nLes zones liées aux jardins sont également accessibles depuis le menu Paramètres.\nCalibration organique du tableau de bord\nUn mode de calibration organique permet :\n• de visualiser l’emplacement réel des zones interactives,\n• de les déplacer par simple glissement du doigt.\nVous pouvez ainsi positionner vos jardins et modules exactement où vous le souhaitez sur l’image : en haut, en bas ou à l’endroit qui vous convient le mieux.\nUne fois validée, cette organisation est enregistrée et conservée dans l’application.\nCréer une parcelle\nDans la fiche d’un jardin :\n• choisissez « Ajouter une parcelle »,\n• indiquez son nom, sa surface et, si besoin, quelques notes,\n• enregistrez.\nAjouter une plantation\nDans une parcelle :\n• appuyez sur le bouton « + »,\n• choisissez une plante dans le catalogue,\n• indiquez la date, la quantité et les informations utiles,\n• validez.\n\n4 — Le tableau de bord organique\nLe tableau de bord est le point central de Sowing.\nIl permet :\n• d’avoir une vue d’ensemble de votre activité,\n• d’accéder rapidement aux fonctions principales,\n• de naviguer de manière intuitive.\nSelon vos réglages, certaines bulles peuvent afficher des informations synthétiques, comme la météo ou les tâches à venir.\n\n5 — Jardins, parcelles et plantations\nLes jardins\nUn jardin représente un lieu réel : potager, serre, verger, balcon, etc.\nVous pouvez :\n• créer plusieurs jardins,\n• modifier leurs informations,\n• les supprimer si nécessaire.\nLes parcelles\nUne parcelle est une zone précise à l’intérieur d’un jardin.\nElle permet de structurer l’espace, d’organiser les cultures et de regrouper plusieurs plantations au même endroit.\nLes plantations\nUne plantation correspond à l’introduction d’une plante dans une parcelle, à une date donnée.\nLors de la création d’une plantation, Sowing propose deux modes.\nSemer\nLe mode « Semer » correspond à la mise en terre d’une graine.\nDans ce cas :\n• la progression démarre à 0 %,\n• un suivi pas à pas est proposé, particulièrement utile pour les jardiniers débutants,\n• une barre de progression visualise l’avancement du cycle de culture.\nCe suivi permet d’estimer :\n• le début probable de la période de récolte,\n• l’évolution de la culture dans le temps, de manière simple et visuelle.\nPlanter\nLe mode « Planter » est destiné aux plants déjà développés (plants issus d’une serre ou achetés en jardinerie).\nDans ce cas :\n• la plante démarre avec une progression d’environ 30 %,\n• le suivi est immédiatement plus avancé,\n• l’estimation de la période de récolte est ajustée en conséquence.\nChoix de la date\nLors de la plantation, vous pouvez choisir librement la date.\nCela permet par exemple :\n• de renseigner une plantation réalisée auparavant,\n• de corriger une date si l’application n’était pas utilisée au moment du semis ou de la plantation.\nPar défaut, la date du jour est utilisée.\nSuivi et historique\nChaque plantation dispose :\n• d’un suivi de progression,\n• d’informations sur son cycle de vie,\n• d’étapes de culture,\n• de notes personnelles.\nToutes les actions (semis, plantation, soins, récoltes) sont automatiquement enregistrées dans l’historique du jardin.\n\n6 — Catalogue de plantes\nLe catalogue regroupe l’ensemble des plantes disponibles lors de la création d’une plantation.\nIl constitue une base de référence évolutive, pensée pour couvrir les usages courants tout en restant personnalisable.\nFonctions principales :\n• recherche simple et rapide,\n• reconnaissance des noms courants et scientifiques,\n• affichage de photos lorsque disponibles.\nPlantes personnalisées\nVous pouvez créer vos propres plantes personnalisées depuis :\nParamètres → Catalogue de plantes.\nIl est alors possible de :\n• créer une nouvelle plante,\n• renseigner les paramètres essentiels (nom, type, informations utiles),\n• ajouter une image pour faciliter l’identification.\nLes plantes personnalisées sont ensuite utilisables comme n’importe quelle autre plante du catalogue.\n\n7 — Calendrier et tâches\nLa vue calendrier\nLe calendrier affiche :\n• les tâches prévues,\n• les plantations importantes,\n• les périodes de récolte estimées.\nCréer une tâche\nDepuis le calendrier :\n• créez une nouvelle tâche,\n• indiquez un titre, une date et une description,\n• choisissez une éventuelle récurrence.\nLes tâches peuvent être associées à un jardin ou à une parcelle.\nGestion des tâches\nVous pouvez :\n• modifier une tâche,\n• la supprimer,\n• l’exporter pour la partager.\n\n8 — Activités et historique\nCette section constitue la mémoire vivante de vos jardins.\nSélection d’un jardin\nDepuis le tableau de bord, effectuez un appui long sur un jardin pour le sélectionner.\nLe jardin actif est mis en évidence par une légère auréole verte et un bandeau de confirmation.\nCette sélection permet de filtrer les informations affichées.\nActivités récentes\nL’onglet « Activités » affiche chronologiquement :\n• créations,\n• plantations,\n• soins,\n• récoltes,\n• actions manuelles.\nHistorique par jardin\nL’onglet « Historique » présente l’historique complet du jardin sélectionné, année après année.\nIl permet notamment de :\n• retrouver les plantations passées,\n• vérifier si une plante a déjà été cultivée à un endroit donné,\n• mieux organiser la rotation des cultures.\n\n9 — Météo de l’air et météo du sol\nMétéo de l’air\nLa météo de l’air fournit les informations essentielles :\n• température extérieure,\n• précipitations (pluie, neige, absence de pluie),\n• alternance jour / nuit.\nCes données aident à anticiper les risques climatiques et à adapter les interventions.\nMétéo du sol\nSowing intègre un module de météo du sol.\nL’utilisateur peut renseigner une température mesurée. À partir de cette donnée, l’application estime dynamiquement l’évolution de la température du sol dans le temps.\nCette information permet :\n• de savoir quelles plantes sont réellement cultivables à un instant donné,\n• d’ajuster les semis aux conditions réelles plutôt qu’à un calendrier théorique.\nMétéo en temps réel sur le tableau de bord\nUn module central en forme d’ovoïde affiche en un coup d’œil :\n• l’état du ciel,\n• le jour ou la nuit,\n• la phase et la position de la lune pour la commune sélectionnée.\nNavigation dans le temps\nEn faisant glisser le doigt de gauche à droite sur l’ovoïde, vous parcourez les prévisions heure par heure, jusqu’à plus de 12 heures à l’avance.\nLa température et les précipitations s’ajustent dynamiquement pendant le geste.\n\n10 — Recommandations\nSowing peut proposer des recommandations adaptées à votre situation.\nElles s’appuient sur :\n• la saison,\n• la météo,\n• l’état de vos plantations.\nChaque recommandation précise :\n• quoi faire,\n• quand agir,\n• pourquoi l’action est suggérée.\n\n11 — Export et partage\nExport PDF — calendrier et tâches\nLes tâches du calendrier peuvent être exportées en PDF.\nCela permet de :\n• partager une information claire,\n• transmettre une intervention prévue,\n• conserver une trace lisible et datée.\nExport Excel — récoltes et statistiques\nLes données de récolte peuvent être exportées au format Excel afin de :\n• analyser les résultats,\n• produire des bilans,\n• suivre l’évolution dans le temps.\nPartage des documents\nLes documents générés peuvent être partagés via les applications disponibles sur votre appareil (messagerie, stockage, transfert vers un ordinateur, etc.).\n\n12 — Sauvegarde et bonnes pratiques\nLes données sont stockées localement sur votre appareil.\nBonnes pratiques recommandées :\n• effectuer une sauvegarde avant une mise à jour importante,\n• exporter régulièrement vos données,\n• maintenir l’application et l’appareil à jour.\n\n13 — Paramètres\nLe menu Paramètres permet d’adapter Sowing à vos usages.\nVous pouvez notamment :\n• choisir la langue,\n• sélectionner votre commune,\n• accéder au catalogue de plantes,\n• personnaliser le tableau de bord.\nPersonnalisation du tableau de bord\nIl est possible de :\n• repositionner chaque module,\n• ajuster l’espace visuel,\n• changer l’image de fond,\n• importer votre propre image (fonctionnalité à venir).\nInformations légales\nDepuis les paramètres, vous pouvez consulter :\n• le guide d’utilisation,\n• la politique de confidentialité,\n• les conditions d’utilisation.\n\n14 — Questions fréquentes\nLes zones tactiles ne sont pas bien alignées\nSelon le téléphone ou les réglages d’affichage, certaines zones peuvent sembler décalées.\nUn mode de calibration organique permet de :\n• visualiser les zones tactiles,\n• les repositionner par glissement,\n• enregistrer la configuration pour votre appareil.\nPuis‑je utiliser Sowing sans connexion ?\nOui. Sowing fonctionne hors ligne pour la gestion des jardins, plantations, tâches et historique.\nUne connexion est uniquement utilisée :\n• pour la récupération des données météo,\n• lors de l’export ou du partage de documents.\nAucune autre donnée n’est transmise.\n\n15 — Remarque finale\nSowing est conçu comme un compagnon de jardinage : simple, vivant et évolutif.\nPrenez le temps d’observer, de noter et de faire confiance à votre expérience autant qu’à l’outil.'**
  String get user_guide_text;

  /// Texte complet de la politique de confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Sowing respecte pleinement votre vie privée.\n\n• Toutes les données sont stockées localement sur votre appareil\n• Aucune donnée personnelle n’est transmise à des tiers\n• Aucune information n’est stockée sur un serveur externe\n\nL’application fonctionne entièrement hors ligne. Une connexion Internet est uniquement utilisée pour récupérer les données météorologiques ou lors des exports.'**
  String get privacy_policy_text;

  /// Texte complet des conditions d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'En utilisant Sowing, vous acceptez :\n\n• D\'utiliser l\'application de manière responsable\n• De ne pas tenter de contourner ses limitations\n• De respecter les droits de propriété intellectuelle\n• D\'utiliser uniquement vos propres données\n\nCette application est fournie en l\'état, sans garantie.\n\nL’équipe Sowing reste à l’écoute pour toute amélioration ou évolution future.'**
  String get terms_text;

  /// Switch pour appliquer automatiquement la calibration
  ///
  /// In fr, this message translates to:
  /// **'Appliquer automatiquement pour cet appareil'**
  String get calibration_auto_apply;

  /// Bouton pour lancer la calibration
  ///
  /// In fr, this message translates to:
  /// **'Calibrer maintenant'**
  String get calibration_calibrate_now;

  /// Bouton pour sauvegarder le profil
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder calibration actuelle comme profil'**
  String get calibration_save_profile;

  /// Bouton pour exporter le profil
  ///
  /// In fr, this message translates to:
  /// **'Exporter profil (copie JSON)'**
  String get calibration_export_profile;

  /// Bouton pour importer le profil
  ///
  /// In fr, this message translates to:
  /// **'Importer profil depuis presse-papiers'**
  String get calibration_import_profile;

  /// Bouton pour réinitialiser le profil
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser profil pour cet appareil'**
  String get calibration_reset_profile;

  /// Bouton pour actualiser l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'Actualiser aperçu profil'**
  String get calibration_refresh_profile;

  /// Label affichant la clé de l'appareil
  ///
  /// In fr, this message translates to:
  /// **'Clé appareil: {key}'**
  String calibration_key_device(String key);

  /// Message si aucun profil
  ///
  /// In fr, this message translates to:
  /// **'Aucun profil enregistré pour cet appareil.'**
  String get calibration_no_profile;

  /// Titre section réglages image
  ///
  /// In fr, this message translates to:
  /// **'Réglages Image de Fond (Persistant)'**
  String get calibration_image_settings_title;

  /// Label position X
  ///
  /// In fr, this message translates to:
  /// **'Pos X'**
  String get calibration_pos_x;

  /// Label position Y
  ///
  /// In fr, this message translates to:
  /// **'Pos Y'**
  String get calibration_pos_y;

  /// Label zoom
  ///
  /// In fr, this message translates to:
  /// **'Zoom'**
  String get calibration_zoom;

  /// Bouton reset image defaults
  ///
  /// In fr, this message translates to:
  /// **'Reset Image Defaults'**
  String get calibration_reset_image;

  /// Titre dialog confirmation
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get calibration_dialog_confirm_title;

  /// Contenu dialog suppression profil
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le profil de calibration pour cet appareil ?'**
  String get calibration_dialog_delete_profile;

  /// Bouton supprimer
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get calibration_action_delete;

  /// SnackBar aucun profil
  ///
  /// In fr, this message translates to:
  /// **'Aucun profil trouvé pour cet appareil.'**
  String get calibration_snack_no_profile;

  /// SnackBar profil copié
  ///
  /// In fr, this message translates to:
  /// **'Profil copié dans le presse-papiers.'**
  String get calibration_snack_profile_copied;

  /// SnackBar presse-papiers vide
  ///
  /// In fr, this message translates to:
  /// **'Presse-papiers vide.'**
  String get calibration_snack_clipboard_empty;

  /// SnackBar profil importé
  ///
  /// In fr, this message translates to:
  /// **'Profil importé et sauvegardé pour cet appareil.'**
  String get calibration_snack_profile_imported;

  /// SnackBar erreur import
  ///
  /// In fr, this message translates to:
  /// **'Erreur import JSON: {error}'**
  String calibration_snack_import_error(String error);

  /// SnackBar profil supprimé
  ///
  /// In fr, this message translates to:
  /// **'Profil supprimé pour cet appareil.'**
  String get calibration_snack_profile_deleted;

  /// SnackBar aucune calibration
  ///
  /// In fr, this message translates to:
  /// **'Aucune calibration enregistrée. Calibrez d\'abord depuis le dashboard.'**
  String get calibration_snack_no_calibration;

  /// SnackBar calibration sauvegardée comme profil
  ///
  /// In fr, this message translates to:
  /// **'Calibration actuelle sauvegardée comme profil pour cet appareil.'**
  String get calibration_snack_saved_as_profile;

  /// SnackBar erreur sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la sauvegarde: {error}'**
  String calibration_snack_save_error(String error);

  /// No description provided for @calibration_overlay_saved.
  ///
  /// In fr, this message translates to:
  /// **'Calibration sauvegardée'**
  String get calibration_overlay_saved;

  /// No description provided for @calibration_overlay_error_save.
  ///
  /// In fr, this message translates to:
  /// **'Erreur sauvegarde calibration: {error}'**
  String calibration_overlay_error_save(String error);

  /// No description provided for @calibration_instruction_image.
  ///
  /// In fr, this message translates to:
  /// **'Glissez pour déplacer, pincez pour zoomer l\'image de fond.'**
  String get calibration_instruction_image;

  /// No description provided for @calibration_instruction_sky.
  ///
  /// In fr, this message translates to:
  /// **'Ajustez l\'ovoïde jour/nuit (centre, taille, rotation).'**
  String get calibration_instruction_sky;

  /// No description provided for @calibration_instruction_modules.
  ///
  /// In fr, this message translates to:
  /// **'Déplacez les modules (bulles) à l\'emplacement souhaité.'**
  String get calibration_instruction_modules;

  /// No description provided for @calibration_instruction_none.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez un outil pour commencer.'**
  String get calibration_instruction_none;

  /// No description provided for @calibration_tool_image.
  ///
  /// In fr, this message translates to:
  /// **'Image'**
  String get calibration_tool_image;

  /// No description provided for @calibration_tool_sky.
  ///
  /// In fr, this message translates to:
  /// **'Ciel'**
  String get calibration_tool_sky;

  /// No description provided for @calibration_tool_modules.
  ///
  /// In fr, this message translates to:
  /// **'Modules'**
  String get calibration_tool_modules;

  /// No description provided for @calibration_action_validate_exit.
  ///
  /// In fr, this message translates to:
  /// **'Valider & Quitter'**
  String get calibration_action_validate_exit;

  /// Titre page création jardin
  ///
  /// In fr, this message translates to:
  /// **'Créer un jardin'**
  String get garden_management_create_title;

  /// Titre page modification jardin
  ///
  /// In fr, this message translates to:
  /// **'Modifier le jardin'**
  String get garden_management_edit_title;

  /// Label champ nom jardin
  ///
  /// In fr, this message translates to:
  /// **'Nom du jardin'**
  String get garden_management_name_label;

  /// Label champ description
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get garden_management_desc_label;

  /// Label section image
  ///
  /// In fr, this message translates to:
  /// **'Image du jardin (optionnel)'**
  String get garden_management_image_label;

  /// Label champ URL image
  ///
  /// In fr, this message translates to:
  /// **'URL de l\'image'**
  String get garden_management_image_url_label;

  /// Erreur preview image
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger l\'image'**
  String get garden_management_image_preview_error;

  /// Bouton soumettre création
  ///
  /// In fr, this message translates to:
  /// **'Créer le jardin'**
  String get garden_management_create_submit;

  /// Bouton pendant soumission
  ///
  /// In fr, this message translates to:
  /// **'Création...'**
  String get garden_management_create_submitting;

  /// SnackBar succès création
  ///
  /// In fr, this message translates to:
  /// **'Jardin créé avec succès'**
  String get garden_management_created_success;

  /// SnackBar erreur création
  ///
  /// In fr, this message translates to:
  /// **'Échec de la création du jardin'**
  String get garden_management_create_error;

  /// Titre dialog suppression
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le jardin'**
  String get garden_management_delete_confirm_title;

  /// Corps dialog suppression
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer ce jardin ? Cette action supprimera également toutes les parcelles et plantations associées. Cette action est irréversible.'**
  String get garden_management_delete_confirm_body;

  /// SnackBar succès suppression
  ///
  /// In fr, this message translates to:
  /// **'Jardin supprimé avec succès'**
  String get garden_management_delete_success;

  /// Tag jardin archivé
  ///
  /// In fr, this message translates to:
  /// **'Jardin archivé'**
  String get garden_management_archived_tag;

  /// Titre section parcelles
  ///
  /// In fr, this message translates to:
  /// **'Parcelles'**
  String get garden_management_beds_title;

  /// Titre état vide parcelles
  ///
  /// In fr, this message translates to:
  /// **'Aucune parcelle'**
  String get garden_management_no_beds_title;

  /// Description état vide parcelles
  ///
  /// In fr, this message translates to:
  /// **'Créez des parcelles pour organiser vos plantations'**
  String get garden_management_no_beds_desc;

  /// Bouton ajouter parcelle
  ///
  /// In fr, this message translates to:
  /// **'Créer une parcelle'**
  String get garden_management_add_bed_label;

  /// Label stat nombre parcelles
  ///
  /// In fr, this message translates to:
  /// **'Parcelles'**
  String get garden_management_stats_beds;

  /// Label stat surface totale
  ///
  /// In fr, this message translates to:
  /// **'Surface totale'**
  String get garden_management_stats_area;

  /// Label dashboard: Statistiques météo
  ///
  /// In fr, this message translates to:
  /// **'Météo détaillée'**
  String get dashboard_weather_stats;

  /// Label dashboard: Température du sol
  ///
  /// In fr, this message translates to:
  /// **'Temp. Sol'**
  String get dashboard_soil_temp;

  /// Label dashboard: Température air
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get dashboard_air_temp;

  /// Label dashboard: Statistiques globales
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get dashboard_statistics;

  /// Label dashboard: Calendrier
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get dashboard_calendar;

  /// Label dashboard: Activités récentes
  ///
  /// In fr, this message translates to:
  /// **'Activités'**
  String get dashboard_activities;

  /// Label dashboard: Météo ciel
  ///
  /// In fr, this message translates to:
  /// **'Météo'**
  String get dashboard_weather;

  /// Label dashboard: Paramètres
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get dashboard_settings;

  /// Label dashboard: Jardin N
  ///
  /// In fr, this message translates to:
  /// **'Jardin {number}'**
  String dashboard_garden_n(int number);

  /// SnackBar création jardin succès
  ///
  /// In fr, this message translates to:
  /// **'Jardin \"{name}\" créé avec succès'**
  String dashboard_garden_created(String name);

  /// SnackBar erreur création jardin
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création du jardin.'**
  String get dashboard_garden_create_error;

  /// Titre page calendrier
  ///
  /// In fr, this message translates to:
  /// **'Calendrier de culture'**
  String get calendar_title;

  /// SnackBar actualisation calendrier
  ///
  /// In fr, this message translates to:
  /// **'Calendrier actualisé'**
  String get calendar_refreshed;

  /// Tooltip bouton nouvelle tâche
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Tâche'**
  String get calendar_new_task_tooltip;

  /// Titre dialog tâche enregistrée
  ///
  /// In fr, this message translates to:
  /// **'Tâche enregistrée'**
  String get calendar_task_saved_title;

  /// Contenu dialog export PDF
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous l\'envoyer à quelqu\'un en PDF ?'**
  String get calendar_ask_export_pdf;

  /// SnackBar tâche modifiée
  ///
  /// In fr, this message translates to:
  /// **'Tâche modifiée'**
  String get calendar_task_modified;

  /// Titre dialog suppression tâche
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la tâche ?'**
  String get calendar_delete_confirm_title;

  /// Contenu dialog suppression tâche
  ///
  /// In fr, this message translates to:
  /// **'\"{title}\" sera supprimée.'**
  String calendar_delete_confirm_content(String title);

  /// SnackBar tâche supprimée
  ///
  /// In fr, this message translates to:
  /// **'Tâche supprimée'**
  String get calendar_task_deleted;

  /// Erreur restauration
  ///
  /// In fr, this message translates to:
  /// **'Erreur restauration : {error}'**
  String calendar_restore_error(Object error);

  /// Erreur suppression
  ///
  /// In fr, this message translates to:
  /// **'Erreur suppression : {error}'**
  String calendar_delete_error(Object error);

  /// Action sheet assigner
  ///
  /// In fr, this message translates to:
  /// **'Envoyer / Attribuer à...'**
  String get calendar_action_assign;

  /// Titre dialog assignation
  ///
  /// In fr, this message translates to:
  /// **'Attribuer / Envoyer'**
  String get calendar_assign_title;

  /// Hint dialog assignation
  ///
  /// In fr, this message translates to:
  /// **'Saisir le nom ou email du destinataire'**
  String get calendar_assign_hint;

  /// Label champ assignation
  ///
  /// In fr, this message translates to:
  /// **'Nom ou Email'**
  String get calendar_assign_field;

  /// SnackBar tâche attribuée
  ///
  /// In fr, this message translates to:
  /// **'Tâche attribuée à {name}'**
  String calendar_task_assigned(String name);

  /// Erreur attribution
  ///
  /// In fr, this message translates to:
  /// **'Erreur attribution : {error}'**
  String calendar_assign_error(Object error);

  /// Erreur export PDF
  ///
  /// In fr, this message translates to:
  /// **'Erreur export PDF: {error}'**
  String calendar_export_error(Object error);

  /// Tooltip mois précédent
  ///
  /// In fr, this message translates to:
  /// **'Mois précédent'**
  String get calendar_previous_month;

  /// Tooltip mois suivant
  ///
  /// In fr, this message translates to:
  /// **'Mois suivant'**
  String get calendar_next_month;

  /// Tooltip limite navigation
  ///
  /// In fr, this message translates to:
  /// **'Limite atteinte'**
  String get calendar_limit_reached;

  /// Instruction navigation calendrier
  ///
  /// In fr, this message translates to:
  /// **'Glisser pour naviguer'**
  String get calendar_drag_instruction;

  /// Tooltip actualiser
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get common_refresh;

  /// Bouton Oui
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get common_yes;

  /// Bouton Non
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get common_no;

  /// Bouton Supprimer
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get common_delete;

  /// Bouton Modifier
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get common_edit;

  /// Action Annuler (Undo)
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get common_undo;

  /// Préfixe erreur
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {error}'**
  String common_error_prefix(Object error);

  /// Bouton réessayer
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get common_retry;

  /// Message aucun événement
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement ce jour'**
  String get calendar_no_events;

  /// Titre événements du jour
  ///
  /// In fr, this message translates to:
  /// **'Événements du {date}'**
  String calendar_events_of(String date);

  /// Titre section plantations
  ///
  /// In fr, this message translates to:
  /// **'Plantations'**
  String get calendar_section_plantings;

  /// Titre section récoltes
  ///
  /// In fr, this message translates to:
  /// **'Récoltes prévues'**
  String get calendar_section_harvests;

  /// Titre section tâches
  ///
  /// In fr, this message translates to:
  /// **'Tâches planifiées'**
  String get calendar_section_tasks;

  /// Filtre tâches
  ///
  /// In fr, this message translates to:
  /// **'Tâches'**
  String get calendar_filter_tasks;

  /// Filtre entretien
  ///
  /// In fr, this message translates to:
  /// **'Entretien'**
  String get calendar_filter_maintenance;

  /// Filtre récoltes
  ///
  /// In fr, this message translates to:
  /// **'Récoltes'**
  String get calendar_filter_harvests;

  /// Filtre urgences
  ///
  /// In fr, this message translates to:
  /// **'Urgences'**
  String get calendar_filter_urgent;

  /// Message erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get common_general_error;

  /// Titre erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get common_error;

  /// Titre section sauvegarde/restauration
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde et Restauration'**
  String get settings_backup_restore_section;

  /// Sous-titre section sauvegarde/restauration
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde intégrale de vos données'**
  String get settings_backup_restore_subtitle;

  /// Bouton créer sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Créer une sauvegarde'**
  String get settings_backup_action;

  /// Bouton restaurer sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Restaurer une sauvegarde'**
  String get settings_restore_action;

  /// Loading sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Création de la sauvegarde en cours...'**
  String get settings_backup_creating;

  /// Succès sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde créée avec succès !'**
  String get settings_backup_success;

  /// Titre warning restauration
  ///
  /// In fr, this message translates to:
  /// **'Attention'**
  String get settings_restore_warning_title;

  /// Contenu warning restauration
  ///
  /// In fr, this message translates to:
  /// **'La restauration d\'une sauvegarde écrasera TOUTES les données actuelles (jardins, plantations, réglages). Cette action est irréversible. L\'application devra redémarrer.\n\nÊtes-vous sûr de vouloir continuer ?'**
  String get settings_restore_warning_content;

  /// Succès restauration
  ///
  /// In fr, this message translates to:
  /// **'Restauration réussie ! Veuillez redémarrer l\'application.'**
  String get settings_restore_success;

  /// Erreur sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Échec de la sauvegarde : {error}'**
  String settings_backup_error(Object error);

  /// Erreur restauration
  ///
  /// In fr, this message translates to:
  /// **'Échec de la restauration : {error}'**
  String settings_restore_error(Object error);

  /// Titre dialogue nouvelle tâche
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Tâche'**
  String get task_editor_title_new;

  /// Titre dialogue modifier tâche
  ///
  /// In fr, this message translates to:
  /// **'Modifier Tâche'**
  String get task_editor_title_edit;

  /// Label champ titre
  ///
  /// In fr, this message translates to:
  /// **'Titre *'**
  String get task_editor_title_field;

  /// Titre de l'écran des activités
  ///
  /// In fr, this message translates to:
  /// **'Activités & Historique'**
  String get activity_screen_title;

  /// Titre onglet récentes pour un jardin
  ///
  /// In fr, this message translates to:
  /// **'Récentes ({gardenName})'**
  String activity_tab_recent_garden(String gardenName);

  /// Titre onglet récentes global
  ///
  /// In fr, this message translates to:
  /// **'Récentes (Global)'**
  String get activity_tab_recent_global;

  /// Titre onglet historique
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get activity_tab_history;

  /// Titre section historique
  ///
  /// In fr, this message translates to:
  /// **'Historique — '**
  String get activity_history_section_title;

  /// Message vide historique
  ///
  /// In fr, this message translates to:
  /// **'Aucun jardin sélectionné.\nPour consulter l’historique d’un jardin, sélectionnez-le par un appui long depuis le tableau de bord.'**
  String get activity_history_empty;

  /// Titre vide activités
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité trouvée'**
  String get activity_empty_title;

  /// Sous-titre vide activités
  ///
  /// In fr, this message translates to:
  /// **'Les activités de jardinage apparaîtront ici'**
  String get activity_empty_subtitle;

  /// Erreur chargement
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement'**
  String get activity_error_loading;

  /// Priorité importante
  ///
  /// In fr, this message translates to:
  /// **'Important'**
  String get activity_priority_important;

  /// Priorité normale
  ///
  /// In fr, this message translates to:
  /// **'Normal'**
  String get activity_priority_normal;

  /// Temps: à l'instant
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant'**
  String get activity_time_just_now;

  /// Temps: minutes
  ///
  /// In fr, this message translates to:
  /// **'Il y a {minutes} min'**
  String activity_time_minutes_ago(int minutes);

  /// Temps: heures
  ///
  /// In fr, this message translates to:
  /// **'Il y a {hours} h'**
  String activity_time_hours_ago(int hours);

  /// Temps: jours
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il y a 1 jour} other{Il y a {count} jours}}'**
  String activity_time_days_ago(int count);

  /// Metadata jardin
  ///
  /// In fr, this message translates to:
  /// **'Jardin: {name}'**
  String activity_metadata_garden(String name);

  /// Metadata parcelle
  ///
  /// In fr, this message translates to:
  /// **'Parcelle: {name}'**
  String activity_metadata_bed(String name);

  /// Metadata plante
  ///
  /// In fr, this message translates to:
  /// **'Plante: {name}'**
  String activity_metadata_plant(String name);

  /// Metadata quantité
  ///
  /// In fr, this message translates to:
  /// **'Quantité: {quantity}'**
  String activity_metadata_quantity(String quantity);

  /// Metadata date
  ///
  /// In fr, this message translates to:
  /// **'Date: {date}'**
  String activity_metadata_date(String date);

  /// Metadata maintenance
  ///
  /// In fr, this message translates to:
  /// **'Maintenance: {type}'**
  String activity_metadata_maintenance(String type);

  /// Metadata météo
  ///
  /// In fr, this message translates to:
  /// **'Météo: {weather}'**
  String activity_metadata_weather(String weather);

  /// Erreur validation titre
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get task_editor_error_title_required;

  /// Titre carte hint historique
  ///
  /// In fr, this message translates to:
  /// **'Pour consulter l’historique d’un jardin'**
  String get history_hint_title;

  /// Corps carte hint historique
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez-le par un appui long depuis le tableau de bord.'**
  String get history_hint_body;

  /// Action carte hint historique
  ///
  /// In fr, this message translates to:
  /// **'Aller au tableau de bord'**
  String get history_hint_action;

  /// Desc act création jardin
  ///
  /// In fr, this message translates to:
  /// **'Jardin \"{name}\" créé'**
  String activity_desc_garden_created(String name);

  /// Desc act création parcelle
  ///
  /// In fr, this message translates to:
  /// **'Parcelle \"{name}\" créée'**
  String activity_desc_bed_created(String name);

  /// Desc act création plantation
  ///
  /// In fr, this message translates to:
  /// **'Plantation de \"{name}\" ajoutée'**
  String activity_desc_planting_created(String name);

  /// Desc act germination
  ///
  /// In fr, this message translates to:
  /// **'Germination de \"{name}\" confirmée'**
  String activity_desc_germination(String name);

  /// Desc act récolte
  ///
  /// In fr, this message translates to:
  /// **'Récolte de \"{name}\" enregistrée'**
  String activity_desc_harvest(String name);

  /// Desc act maintenance
  ///
  /// In fr, this message translates to:
  /// **'Maintenance : {type}'**
  String activity_desc_maintenance(String type);

  /// Desc act suppression jardin
  ///
  /// In fr, this message translates to:
  /// **'Jardin \"{name}\" supprimé'**
  String activity_desc_garden_deleted(String name);

  /// Desc act suppression parcelle
  ///
  /// In fr, this message translates to:
  /// **'Parcelle \"{name}\" supprimée'**
  String activity_desc_bed_deleted(String name);

  /// Desc act suppression plantation
  ///
  /// In fr, this message translates to:
  /// **'Plantation de \"{name}\" supprimée'**
  String activity_desc_planting_deleted(String name);

  /// Desc act màj jardin
  ///
  /// In fr, this message translates to:
  /// **'Jardin \"{name}\" mis à jour'**
  String activity_desc_garden_updated(String name);

  /// Desc act màj parcelle
  ///
  /// In fr, this message translates to:
  /// **'Parcelle \"{name}\" mise à jour'**
  String activity_desc_bed_updated(String name);

  /// Desc act màj plantation
  ///
  /// In fr, this message translates to:
  /// **'Plantation de \"{name}\" mise à jour'**
  String activity_desc_planting_updated(String name);

  /// Titre widget Pas-à-pas
  ///
  /// In fr, this message translates to:
  /// **'Pas-à-pas'**
  String get planting_steps_title;

  /// Label bouton ajouter étape
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get planting_steps_add_button;

  /// Bouton replier
  ///
  /// In fr, this message translates to:
  /// **'Voir moins'**
  String get planting_steps_see_less;

  /// Bouton voir tout
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get planting_steps_see_all;

  /// Message vide étapes
  ///
  /// In fr, this message translates to:
  /// **'Aucune étape recommandée'**
  String get planting_steps_empty;

  /// Label x autres étapes
  ///
  /// In fr, this message translates to:
  /// **'+ {count} autres étapes'**
  String planting_steps_more(int count);

  /// Badge prédiction
  ///
  /// In fr, this message translates to:
  /// **'Prédiction'**
  String get planting_steps_prediction_badge;

  /// Préfixe date étape
  ///
  /// In fr, this message translates to:
  /// **'Le {date}'**
  String planting_steps_date_prefix(String date);

  /// Label fait
  ///
  /// In fr, this message translates to:
  /// **'Fait'**
  String get planting_steps_done;

  /// Bouton marquer fait
  ///
  /// In fr, this message translates to:
  /// **'Marquer fait'**
  String get planting_steps_mark_done;

  /// Titre dialog ajout étape
  ///
  /// In fr, this message translates to:
  /// **'Ajouter étape'**
  String get planting_steps_dialog_title;

  /// Hint dialog ajout étape
  ///
  /// In fr, this message translates to:
  /// **'Ex: Paillage léger'**
  String get planting_steps_dialog_hint;

  /// Bouton valider ajout
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get planting_steps_dialog_add;

  /// No description provided for @planting_status_sown.
  ///
  /// In fr, this message translates to:
  /// **'Semé'**
  String get planting_status_sown;

  /// No description provided for @planting_status_planted.
  ///
  /// In fr, this message translates to:
  /// **'Planté'**
  String get planting_status_planted;

  /// No description provided for @planting_status_growing.
  ///
  /// In fr, this message translates to:
  /// **'En croissance'**
  String get planting_status_growing;

  /// No description provided for @planting_status_ready.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à récolter'**
  String get planting_status_ready;

  /// No description provided for @planting_status_harvested.
  ///
  /// In fr, this message translates to:
  /// **'Récolté'**
  String get planting_status_harvested;

  /// No description provided for @planting_status_failed.
  ///
  /// In fr, this message translates to:
  /// **'Échoué'**
  String get planting_status_failed;

  /// Label sémé le
  ///
  /// In fr, this message translates to:
  /// **'Semé le {date}'**
  String planting_card_sown_date(String date);

  /// Label planté le
  ///
  /// In fr, this message translates to:
  /// **'Planté le {date}'**
  String planting_card_planted_date(String date);

  /// Label récolte estimée
  ///
  /// In fr, this message translates to:
  /// **'Récolte estimée : {date}'**
  String planting_card_harvest_estimate(String date);

  /// No description provided for @planting_info_title.
  ///
  /// In fr, this message translates to:
  /// **'Informations botaniques'**
  String get planting_info_title;

  /// No description provided for @planting_info_tips_title.
  ///
  /// In fr, this message translates to:
  /// **'Conseils de culture'**
  String get planting_info_tips_title;

  /// No description provided for @planting_info_maturity.
  ///
  /// In fr, this message translates to:
  /// **'Maturité'**
  String get planting_info_maturity;

  /// No description provided for @planting_info_days.
  ///
  /// In fr, this message translates to:
  /// **'{days} jours'**
  String planting_info_days(Object days);

  /// No description provided for @planting_info_spacing.
  ///
  /// In fr, this message translates to:
  /// **'Espacement'**
  String get planting_info_spacing;

  /// No description provided for @planting_info_cm.
  ///
  /// In fr, this message translates to:
  /// **'{cm} cm'**
  String planting_info_cm(Object cm);

  /// No description provided for @planting_info_depth.
  ///
  /// In fr, this message translates to:
  /// **'Profondeur'**
  String get planting_info_depth;

  /// No description provided for @planting_info_exposure.
  ///
  /// In fr, this message translates to:
  /// **'Exposition'**
  String get planting_info_exposure;

  /// No description provided for @planting_info_water.
  ///
  /// In fr, this message translates to:
  /// **'Arrosage'**
  String get planting_info_water;

  /// No description provided for @planting_info_season.
  ///
  /// In fr, this message translates to:
  /// **'Saison plantation'**
  String get planting_info_season;

  /// No description provided for @planting_info_scientific_name_none.
  ///
  /// In fr, this message translates to:
  /// **'Nom scientifique non disponible'**
  String get planting_info_scientific_name_none;

  /// No description provided for @planting_info_culture_title.
  ///
  /// In fr, this message translates to:
  /// **'Informations de culture'**
  String get planting_info_culture_title;

  /// No description provided for @planting_info_germination.
  ///
  /// In fr, this message translates to:
  /// **'Temps de germination'**
  String get planting_info_germination;

  /// No description provided for @planting_info_harvest_time.
  ///
  /// In fr, this message translates to:
  /// **'Temps de récolte'**
  String get planting_info_harvest_time;

  /// No description provided for @planting_info_none.
  ///
  /// In fr, this message translates to:
  /// **'Non spécifié'**
  String get planting_info_none;

  /// No description provided for @planting_tips_none.
  ///
  /// In fr, this message translates to:
  /// **'Aucun conseil disponible'**
  String get planting_tips_none;

  /// No description provided for @planting_history_title.
  ///
  /// In fr, this message translates to:
  /// **'Historique des actions'**
  String get planting_history_title;

  /// No description provided for @planting_history_action_planting.
  ///
  /// In fr, this message translates to:
  /// **'Plantation'**
  String get planting_history_action_planting;

  /// No description provided for @planting_history_todo.
  ///
  /// In fr, this message translates to:
  /// **'L\'historique détaillé sera disponible prochainement'**
  String get planting_history_todo;

  /// Option tous les jardins
  ///
  /// In fr, this message translates to:
  /// **'Tous les jardins'**
  String get task_editor_garden_all;

  /// Label champ zone
  ///
  /// In fr, this message translates to:
  /// **'Zone (Parcelle)'**
  String get task_editor_zone_label;

  /// Option aucune zone
  ///
  /// In fr, this message translates to:
  /// **'Aucune zone spécifique'**
  String get task_editor_zone_none;

  /// Message aucune parcelle
  ///
  /// In fr, this message translates to:
  /// **'Aucune parcelle pour ce jardin'**
  String get task_editor_zone_empty;

  /// Label champ description
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get task_editor_description_label;

  /// Label champ date
  ///
  /// In fr, this message translates to:
  /// **'Date de début'**
  String get task_editor_date_label;

  /// Label champ heure
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get task_editor_time_label;

  /// Label champ durée
  ///
  /// In fr, this message translates to:
  /// **'Durée estimée'**
  String get task_editor_duration_label;

  /// Option durée autre
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get task_editor_duration_other;

  /// Label champ type
  ///
  /// In fr, this message translates to:
  /// **'Type de tâche'**
  String get task_editor_type_label;

  /// Label champ priorité
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get task_editor_priority_label;

  /// Label switch urgent
  ///
  /// In fr, this message translates to:
  /// **'Urgent'**
  String get task_editor_urgent_label;

  /// Option export aucune
  ///
  /// In fr, this message translates to:
  /// **'Aucune (Sauvegarde uniquement)'**
  String get task_editor_option_none;

  /// Option export partage
  ///
  /// In fr, this message translates to:
  /// **'Partager (texte)'**
  String get task_editor_option_share;

  /// Option export PDF
  ///
  /// In fr, this message translates to:
  /// **'Exporter — PDF'**
  String get task_editor_option_pdf;

  /// Option export Word
  ///
  /// In fr, this message translates to:
  /// **'Exporter — Word (.docx)'**
  String get task_editor_option_docx;

  /// Label champ export
  ///
  /// In fr, this message translates to:
  /// **'Sortie / Partage'**
  String get task_editor_export_label;

  /// Bouton photo placeholder
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo (Bientôt disponible)'**
  String get task_editor_photo_placeholder;

  /// Bouton créer
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get task_editor_action_create;

  /// Bouton enregistrer
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get task_editor_action_save;

  /// Bouton annuler
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get task_editor_action_cancel;

  /// Label champ assigné à
  ///
  /// In fr, this message translates to:
  /// **'Assigné à'**
  String get task_editor_assignee_label;

  /// Action ajouter assigné
  ///
  /// In fr, this message translates to:
  /// **'Ajouter \"{name}\" aux favoris'**
  String task_editor_assignee_add(String name);

  /// Message aucun résultat assigné
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat.'**
  String get task_editor_assignee_none;

  /// Label champ récurrence
  ///
  /// In fr, this message translates to:
  /// **'Récurrence'**
  String get task_editor_recurrence_label;

  /// Option récurrence aucune
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get task_editor_recurrence_none;

  /// Option récurrence intervalle
  ///
  /// In fr, this message translates to:
  /// **'Tous les X jours'**
  String get task_editor_recurrence_interval;

  /// Option récurrence hebdo
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire (Jours)'**
  String get task_editor_recurrence_weekly;

  /// Option récurrence mensuelle
  ///
  /// In fr, this message translates to:
  /// **'Mensuel (même jour)'**
  String get task_editor_recurrence_monthly;

  /// Label répéter tous les
  ///
  /// In fr, this message translates to:
  /// **'Répéter tous les '**
  String get task_editor_recurrence_repeat_label;

  /// Suffixe jours
  ///
  /// In fr, this message translates to:
  /// **' j'**
  String get task_editor_recurrence_days_suffix;

  /// Type tâche générique
  ///
  /// In fr, this message translates to:
  /// **'Générique'**
  String get task_kind_generic;

  /// Type tâche réparation
  ///
  /// In fr, this message translates to:
  /// **'Réparation 🛠️'**
  String get task_kind_repair;

  /// Titre écran température sol
  ///
  /// In fr, this message translates to:
  /// **'Température du Sol'**
  String get soil_temp_title;

  /// Erreur affichage graphique
  ///
  /// In fr, this message translates to:
  /// **'Erreur chart: {error}'**
  String soil_temp_chart_error(Object error);

  /// Titre section à propos
  ///
  /// In fr, this message translates to:
  /// **'À propos de la température du sol'**
  String get soil_temp_about_title;

  /// Contenu section à propos
  ///
  /// In fr, this message translates to:
  /// **'La température du sol affichée ici est estimée par l’application à partir de données climatiques et saisonnières, selon une formule de calcul intégrée.\n\nCette estimation permet de donner une tendance réaliste de la température du sol lorsque aucune mesure directe n’est disponible.'**
  String get soil_temp_about_content;

  /// Label formule
  ///
  /// In fr, this message translates to:
  /// **'Formule de calcul utilisée :'**
  String get soil_temp_formula_label;

  /// Contenu formule
  ///
  /// In fr, this message translates to:
  /// **'Température du sol = f(température de l’air, saison, inertie du sol)\n(Formule exacte définie dans le code de l’application)'**
  String get soil_temp_formula_content;

  /// Label température actuelle
  ///
  /// In fr, this message translates to:
  /// **'Température actuelle'**
  String get soil_temp_current_label;

  /// Bouton modifier/mesurer
  ///
  /// In fr, this message translates to:
  /// **'Modifier / Mesurer'**
  String get soil_temp_action_measure;

  /// Hint mesure manuelle
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez renseigner manuellement la température du sol dans l’onglet “Modifier / Mesurer”.'**
  String get soil_temp_measure_hint;

  /// Erreur catalogue
  ///
  /// In fr, this message translates to:
  /// **'Erreur catalogue: {error}'**
  String soil_temp_catalog_error(Object error);

  /// Erreur chargement conseils
  ///
  /// In fr, this message translates to:
  /// **'Erreur conseils: {error}'**
  String soil_temp_advice_error(Object error);

  /// Message DB vide
  ///
  /// In fr, this message translates to:
  /// **'Base de données de plantes vide.'**
  String get soil_temp_db_empty;

  /// Bouton recharger plantes
  ///
  /// In fr, this message translates to:
  /// **'Recharger les plantes'**
  String get soil_temp_reload_plants;

  /// Message aucun conseil
  ///
  /// In fr, this message translates to:
  /// **'Aucune plante avec données de germination trouvée.'**
  String get soil_temp_no_advice;

  /// Statut conseil optimal
  ///
  /// In fr, this message translates to:
  /// **'Optimal'**
  String get soil_advice_status_ideal;

  /// Statut conseil semer
  ///
  /// In fr, this message translates to:
  /// **'Semer'**
  String get soil_advice_status_sow_now;

  /// Statut conseil bientôt
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get soil_advice_status_sow_soon;

  /// Statut conseil attendre
  ///
  /// In fr, this message translates to:
  /// **'Attendre'**
  String get soil_advice_status_wait;

  /// Titre sheet temp sol
  ///
  /// In fr, this message translates to:
  /// **'Température du sol'**
  String get soil_sheet_title;

  /// Info dernière mesure
  ///
  /// In fr, this message translates to:
  /// **'Dernière mesure : {temp}°C ({date})'**
  String soil_sheet_last_measure(String temp, String date);

  /// Titre section nouvelle mesure
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle mesure (Ancrage)'**
  String get soil_sheet_new_measure;

  /// Label champ input temp
  ///
  /// In fr, this message translates to:
  /// **'Température (°C)'**
  String get soil_sheet_input_label;

  /// Erreur validation input
  ///
  /// In fr, this message translates to:
  /// **'Valeur invalide (-10.0 à 45.0)'**
  String get soil_sheet_input_error;

  /// Hint input
  ///
  /// In fr, this message translates to:
  /// **'0.0'**
  String get soil_sheet_input_hint;

  /// Bouton annuler
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get soil_sheet_action_cancel;

  /// Bouton sauvegarder
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get soil_sheet_action_save;

  /// Snack valeur invalide
  ///
  /// In fr, this message translates to:
  /// **'Valeur invalide. Entrez -10.0 à 45.0'**
  String get soil_sheet_snack_invalid;

  /// Snack succès sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Mesure enregistrée comme ancrage'**
  String get soil_sheet_snack_success;

  /// Snack erreur sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Erreur sauvegarde : {error}'**
  String soil_sheet_snack_error(Object error);

  /// Titre écran météo
  ///
  /// In fr, this message translates to:
  /// **'Météo'**
  String get weather_screen_title;

  /// Crédit fournisseur données
  ///
  /// In fr, this message translates to:
  /// **'Données fournies par Open-Meteo'**
  String get weather_provider_credit;

  /// Erreur chargement météo
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la météo'**
  String get weather_error_loading;

  /// Bouton réessayer
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get weather_action_retry;

  /// Header prochaines 24h
  ///
  /// In fr, this message translates to:
  /// **'PROCHAINES 24H'**
  String get weather_header_next_24h;

  /// Header résumé jour
  ///
  /// In fr, this message translates to:
  /// **'RÉSUMÉ JOUR'**
  String get weather_header_daily_summary;

  /// Header précipitations
  ///
  /// In fr, this message translates to:
  /// **'PRÉCIPITATIONS (24h)'**
  String get weather_header_precipitations;

  /// Label vent
  ///
  /// In fr, this message translates to:
  /// **'VENT'**
  String get weather_label_wind;

  /// Label pression
  ///
  /// In fr, this message translates to:
  /// **'PRESSION'**
  String get weather_label_pressure;

  /// Label soleil
  ///
  /// In fr, this message translates to:
  /// **'SOLEIL'**
  String get weather_label_sun;

  /// Label astres
  ///
  /// In fr, this message translates to:
  /// **'ASTRES'**
  String get weather_label_astro;

  /// Label vitesse vent
  ///
  /// In fr, this message translates to:
  /// **'Vitesse'**
  String get weather_data_speed;

  /// Label rafales
  ///
  /// In fr, this message translates to:
  /// **'Rafales'**
  String get weather_data_gusts;

  /// Label lever soleil
  ///
  /// In fr, this message translates to:
  /// **'Lever'**
  String get weather_data_sunrise;

  /// Label coucher soleil
  ///
  /// In fr, this message translates to:
  /// **'Coucher'**
  String get weather_data_sunset;

  /// Label pluie
  ///
  /// In fr, this message translates to:
  /// **'Pluie'**
  String get weather_data_rain;

  /// Label temp max
  ///
  /// In fr, this message translates to:
  /// **'Max'**
  String get weather_data_max;

  /// Label temp min
  ///
  /// In fr, this message translates to:
  /// **'Min'**
  String get weather_data_min;

  /// Label vent max
  ///
  /// In fr, this message translates to:
  /// **'Vent Max'**
  String get weather_data_wind_max;

  /// Pression haute
  ///
  /// In fr, this message translates to:
  /// **'Haute'**
  String get weather_pressure_high;

  /// Pression basse
  ///
  /// In fr, this message translates to:
  /// **'Basse'**
  String get weather_pressure_low;

  /// Label aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get weather_today_label;

  /// Phase nouvelle lune
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Lune'**
  String get moon_phase_new;

  /// Phase premier croissant
  ///
  /// In fr, this message translates to:
  /// **'Premier Croissant'**
  String get moon_phase_waxing_crescent;

  /// Phase premier quartier
  ///
  /// In fr, this message translates to:
  /// **'Premier Quartier'**
  String get moon_phase_first_quarter;

  /// Phase gibbeuse croissante
  ///
  /// In fr, this message translates to:
  /// **'Gibbeuse Croissante'**
  String get moon_phase_waxing_gibbous;

  /// Phase pleine lune
  ///
  /// In fr, this message translates to:
  /// **'Pleine Lune'**
  String get moon_phase_full;

  /// Phase gibbeuse décroissante
  ///
  /// In fr, this message translates to:
  /// **'Gibbeuse Décroissante'**
  String get moon_phase_waning_gibbous;

  /// Phase dernier quartier
  ///
  /// In fr, this message translates to:
  /// **'Dernier Quartier'**
  String get moon_phase_last_quarter;

  /// Phase dernier croissant
  ///
  /// In fr, this message translates to:
  /// **'Dernier Croissant'**
  String get moon_phase_waning_crescent;

  /// No description provided for @wmo_code_0.
  ///
  /// In fr, this message translates to:
  /// **'Ciel clair'**
  String get wmo_code_0;

  /// No description provided for @wmo_code_1.
  ///
  /// In fr, this message translates to:
  /// **'Principalement clair'**
  String get wmo_code_1;

  /// No description provided for @wmo_code_2.
  ///
  /// In fr, this message translates to:
  /// **'Partiellement nuageux'**
  String get wmo_code_2;

  /// No description provided for @wmo_code_3.
  ///
  /// In fr, this message translates to:
  /// **'Couvert'**
  String get wmo_code_3;

  /// No description provided for @wmo_code_45.
  ///
  /// In fr, this message translates to:
  /// **'Brouillard'**
  String get wmo_code_45;

  /// No description provided for @wmo_code_48.
  ///
  /// In fr, this message translates to:
  /// **'Brouillard givrant'**
  String get wmo_code_48;

  /// No description provided for @wmo_code_51.
  ///
  /// In fr, this message translates to:
  /// **'Bruine légère'**
  String get wmo_code_51;

  /// No description provided for @wmo_code_53.
  ///
  /// In fr, this message translates to:
  /// **'Bruine modérée'**
  String get wmo_code_53;

  /// No description provided for @wmo_code_55.
  ///
  /// In fr, this message translates to:
  /// **'Bruine dense'**
  String get wmo_code_55;

  /// No description provided for @wmo_code_61.
  ///
  /// In fr, this message translates to:
  /// **'Pluie légère'**
  String get wmo_code_61;

  /// No description provided for @wmo_code_63.
  ///
  /// In fr, this message translates to:
  /// **'Pluie modérée'**
  String get wmo_code_63;

  /// No description provided for @wmo_code_65.
  ///
  /// In fr, this message translates to:
  /// **'Pluie forte'**
  String get wmo_code_65;

  /// No description provided for @wmo_code_66.
  ///
  /// In fr, this message translates to:
  /// **'Pluie verglaçante légère'**
  String get wmo_code_66;

  /// No description provided for @wmo_code_67.
  ///
  /// In fr, this message translates to:
  /// **'Pluie verglaçante forte'**
  String get wmo_code_67;

  /// No description provided for @wmo_code_71.
  ///
  /// In fr, this message translates to:
  /// **'Chute de neige légère'**
  String get wmo_code_71;

  /// No description provided for @wmo_code_73.
  ///
  /// In fr, this message translates to:
  /// **'Chute de neige modérée'**
  String get wmo_code_73;

  /// No description provided for @wmo_code_75.
  ///
  /// In fr, this message translates to:
  /// **'Chute de neige forte'**
  String get wmo_code_75;

  /// No description provided for @wmo_code_77.
  ///
  /// In fr, this message translates to:
  /// **'Grains de neige'**
  String get wmo_code_77;

  /// No description provided for @wmo_code_80.
  ///
  /// In fr, this message translates to:
  /// **'Averses légères'**
  String get wmo_code_80;

  /// No description provided for @wmo_code_81.
  ///
  /// In fr, this message translates to:
  /// **'Averses modérées'**
  String get wmo_code_81;

  /// No description provided for @wmo_code_82.
  ///
  /// In fr, this message translates to:
  /// **'Averses violentes'**
  String get wmo_code_82;

  /// No description provided for @wmo_code_85.
  ///
  /// In fr, this message translates to:
  /// **'Averses de neige légères'**
  String get wmo_code_85;

  /// No description provided for @wmo_code_86.
  ///
  /// In fr, this message translates to:
  /// **'Averses de neige fortes'**
  String get wmo_code_86;

  /// No description provided for @wmo_code_95.
  ///
  /// In fr, this message translates to:
  /// **'Orage'**
  String get wmo_code_95;

  /// No description provided for @wmo_code_96.
  ///
  /// In fr, this message translates to:
  /// **'Orage avec grêle légère'**
  String get wmo_code_96;

  /// No description provided for @wmo_code_99.
  ///
  /// In fr, this message translates to:
  /// **'Orage avec grêle forte'**
  String get wmo_code_99;

  /// No description provided for @wmo_code_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Conditions variables'**
  String get wmo_code_unknown;

  /// Type tâche achat
  ///
  /// In fr, this message translates to:
  /// **'Achat 🛒'**
  String get task_kind_buy;

  /// Type tâche nettoyage
  ///
  /// In fr, this message translates to:
  /// **'Nettoyage 🧹'**
  String get task_kind_clean;

  /// Type tâche arrosage
  ///
  /// In fr, this message translates to:
  /// **'Arrosage 💧'**
  String get task_kind_watering;

  /// Type tâche semis
  ///
  /// In fr, this message translates to:
  /// **'Semis 🌱'**
  String get task_kind_seeding;

  /// Type tâche taille
  ///
  /// In fr, this message translates to:
  /// **'Taille ✂️'**
  String get task_kind_pruning;

  /// Type tâche désherbage
  ///
  /// In fr, this message translates to:
  /// **'Désherbage 🌿'**
  String get task_kind_weeding;

  /// Type tâche amendement
  ///
  /// In fr, this message translates to:
  /// **'Amendement 🪵'**
  String get task_kind_amendment;

  /// Type tâche traitement
  ///
  /// In fr, this message translates to:
  /// **'Traitement 🧪'**
  String get task_kind_treatment;

  /// Type tâche récolte
  ///
  /// In fr, this message translates to:
  /// **'Récolte 🧺'**
  String get task_kind_harvest;

  /// Type tâche hivernage
  ///
  /// In fr, this message translates to:
  /// **'Hivernage ❄️'**
  String get task_kind_winter_protection;

  /// No description provided for @garden_detail_title_error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get garden_detail_title_error;

  /// No description provided for @garden_detail_subtitle_not_found.
  ///
  /// In fr, this message translates to:
  /// **'Le jardin demande n\'existe pas ou a été supprimé.'**
  String get garden_detail_subtitle_not_found;

  /// No description provided for @garden_detail_subtitle_error_beds.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les planches: {error}'**
  String garden_detail_subtitle_error_beds(Object error);

  /// No description provided for @garden_action_edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get garden_action_edit;

  /// No description provided for @garden_action_archive.
  ///
  /// In fr, this message translates to:
  /// **'Archiver'**
  String get garden_action_archive;

  /// No description provided for @garden_action_unarchive.
  ///
  /// In fr, this message translates to:
  /// **'Désarchiver'**
  String get garden_action_unarchive;

  /// No description provided for @garden_action_delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get garden_action_delete;

  /// No description provided for @garden_created_at.
  ///
  /// In fr, this message translates to:
  /// **'Créé le {date}'**
  String garden_created_at(Object date);

  /// No description provided for @garden_bed_delete_confirm_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la parcelle'**
  String get garden_bed_delete_confirm_title;

  /// No description provided for @garden_bed_delete_confirm_body.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer \"{bedName}\" ? Cette action est irréversible.'**
  String garden_bed_delete_confirm_body(Object bedName);

  /// No description provided for @garden_bed_deleted_snack.
  ///
  /// In fr, this message translates to:
  /// **'Parcelle supprimée'**
  String get garden_bed_deleted_snack;

  /// No description provided for @garden_bed_delete_error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la suppression: {error}'**
  String garden_bed_delete_error(Object error);

  /// No description provided for @common_back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get common_back;

  /// No description provided for @garden_action_disable.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver'**
  String get garden_action_disable;

  /// No description provided for @garden_action_enable.
  ///
  /// In fr, this message translates to:
  /// **'Activer'**
  String get garden_action_enable;

  /// No description provided for @garden_action_modify.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get garden_action_modify;

  /// No description provided for @bed_create_title_new.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle parcelle'**
  String get bed_create_title_new;

  /// No description provided for @bed_create_title_edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la parcelle'**
  String get bed_create_title_edit;

  /// No description provided for @bed_form_name_label.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la parcelle *'**
  String get bed_form_name_label;

  /// No description provided for @bed_form_name_hint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Parcelle Nord, Planche 1'**
  String get bed_form_name_hint;

  /// No description provided for @bed_form_size_label.
  ///
  /// In fr, this message translates to:
  /// **'Surface (m²) *'**
  String get bed_form_size_label;

  /// No description provided for @bed_form_size_hint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 10.5'**
  String get bed_form_size_hint;

  /// No description provided for @bed_form_desc_label.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get bed_form_desc_label;

  /// No description provided for @bed_form_desc_hint.
  ///
  /// In fr, this message translates to:
  /// **'Description...'**
  String get bed_form_desc_hint;

  /// No description provided for @bed_form_submit_create.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get bed_form_submit_create;

  /// No description provided for @bed_form_submit_edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get bed_form_submit_edit;

  /// No description provided for @bed_snack_created.
  ///
  /// In fr, this message translates to:
  /// **'Parcelle créée avec succès'**
  String get bed_snack_created;

  /// No description provided for @bed_snack_updated.
  ///
  /// In fr, this message translates to:
  /// **'Parcelle modifiée avec succès'**
  String get bed_snack_updated;

  /// No description provided for @bed_form_error_name_required.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est obligatoire'**
  String get bed_form_error_name_required;

  /// No description provided for @bed_form_error_name_length.
  ///
  /// In fr, this message translates to:
  /// **'Le nom doit contenir au moins 2 caractères'**
  String get bed_form_error_name_length;

  /// No description provided for @bed_form_error_size_required.
  ///
  /// In fr, this message translates to:
  /// **'La surface est obligatoire'**
  String get bed_form_error_size_required;

  /// No description provided for @bed_form_error_size_invalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une surface valide'**
  String get bed_form_error_size_invalid;

  /// No description provided for @bed_form_error_size_max.
  ///
  /// In fr, this message translates to:
  /// **'La surface ne peut pas dépasser 1000 m²'**
  String get bed_form_error_size_max;

  /// No description provided for @status_sown.
  ///
  /// In fr, this message translates to:
  /// **'Semé'**
  String get status_sown;

  /// No description provided for @status_planted.
  ///
  /// In fr, this message translates to:
  /// **'Planté'**
  String get status_planted;

  /// No description provided for @status_growing.
  ///
  /// In fr, this message translates to:
  /// **'En croissance'**
  String get status_growing;

  /// No description provided for @status_ready_to_harvest.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à récolter'**
  String get status_ready_to_harvest;

  /// No description provided for @status_harvested.
  ///
  /// In fr, this message translates to:
  /// **'Récolté'**
  String get status_harvested;

  /// No description provided for @status_failed.
  ///
  /// In fr, this message translates to:
  /// **'Échoué'**
  String get status_failed;

  /// No description provided for @bed_card_sown_on.
  ///
  /// In fr, this message translates to:
  /// **'Semé le {date}'**
  String bed_card_sown_on(Object date);

  /// No description provided for @bed_card_harvest_start.
  ///
  /// In fr, this message translates to:
  /// **'vers début récolte'**
  String get bed_card_harvest_start;

  /// No description provided for @bed_action_harvest.
  ///
  /// In fr, this message translates to:
  /// **'Récolter'**
  String get bed_action_harvest;

  /// No description provided for @lifecycle_error_title.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du calcul du cycle de vie'**
  String get lifecycle_error_title;

  /// No description provided for @lifecycle_error_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : '**
  String get lifecycle_error_prefix;

  /// No description provided for @lifecycle_cycle_completed.
  ///
  /// In fr, this message translates to:
  /// **'du cycle complété'**
  String get lifecycle_cycle_completed;

  /// No description provided for @lifecycle_stage_germination.
  ///
  /// In fr, this message translates to:
  /// **'Germination'**
  String get lifecycle_stage_germination;

  /// No description provided for @lifecycle_stage_growth.
  ///
  /// In fr, this message translates to:
  /// **'Croissance'**
  String get lifecycle_stage_growth;

  /// No description provided for @lifecycle_stage_fruiting.
  ///
  /// In fr, this message translates to:
  /// **'Fructification'**
  String get lifecycle_stage_fruiting;

  /// No description provided for @lifecycle_stage_harvest.
  ///
  /// In fr, this message translates to:
  /// **'Récolte'**
  String get lifecycle_stage_harvest;

  /// No description provided for @lifecycle_stage_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get lifecycle_stage_unknown;

  /// No description provided for @lifecycle_harvest_expected.
  ///
  /// In fr, this message translates to:
  /// **'Récolte prévue'**
  String get lifecycle_harvest_expected;

  /// No description provided for @lifecycle_in_days.
  ///
  /// In fr, this message translates to:
  /// **'Dans {days} jours'**
  String lifecycle_in_days(Object days);

  /// No description provided for @lifecycle_passed.
  ///
  /// In fr, this message translates to:
  /// **'Passée'**
  String get lifecycle_passed;

  /// No description provided for @lifecycle_now.
  ///
  /// In fr, this message translates to:
  /// **'Maintenant !'**
  String get lifecycle_now;

  /// No description provided for @lifecycle_next_action.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine action'**
  String get lifecycle_next_action;

  /// No description provided for @lifecycle_update.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour le cycle'**
  String get lifecycle_update;

  /// No description provided for @lifecycle_days_ago.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {days} jours'**
  String lifecycle_days_ago(Object days);

  /// No description provided for @planting_detail_title.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la plantation'**
  String get planting_detail_title;

  /// No description provided for @companion_beneficial.
  ///
  /// In fr, this message translates to:
  /// **'Plantes amies'**
  String get companion_beneficial;

  /// No description provided for @companion_avoid.
  ///
  /// In fr, this message translates to:
  /// **'Plantes à éviter'**
  String get companion_avoid;

  /// No description provided for @common_close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get common_close;

  /// No description provided for @bed_detail_surface.
  ///
  /// In fr, this message translates to:
  /// **'Surface'**
  String get bed_detail_surface;

  /// No description provided for @bed_detail_details.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get bed_detail_details;

  /// No description provided for @bed_detail_notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get bed_detail_notes;

  /// No description provided for @bed_detail_current_plantings.
  ///
  /// In fr, this message translates to:
  /// **'Plantations actuelles'**
  String get bed_detail_current_plantings;

  /// No description provided for @bed_detail_no_plantings_title.
  ///
  /// In fr, this message translates to:
  /// **'Aucune plantation'**
  String get bed_detail_no_plantings_title;

  /// No description provided for @bed_detail_no_plantings_desc.
  ///
  /// In fr, this message translates to:
  /// **'Cette parcelle n\'a pas encore de plantations.'**
  String get bed_detail_no_plantings_desc;

  /// No description provided for @bed_detail_add_planting.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une plantation'**
  String get bed_detail_add_planting;

  /// No description provided for @bed_delete_planting_confirm_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la plantation ?'**
  String get bed_delete_planting_confirm_title;

  /// No description provided for @bed_delete_planting_confirm_body.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Voulez-vous vraiment supprimer cette plantation ?'**
  String get bed_delete_planting_confirm_body;

  /// No description provided for @harvest_title.
  ///
  /// In fr, this message translates to:
  /// **'Récolte :{plantName}'**
  String harvest_title(Object plantName);

  /// No description provided for @harvest_weight_label.
  ///
  /// In fr, this message translates to:
  /// **'Poids récolté (kg) *'**
  String get harvest_weight_label;

  /// No description provided for @harvest_price_label.
  ///
  /// In fr, this message translates to:
  /// **'Prix estimé (€/kg)'**
  String get harvest_price_label;

  /// No description provided for @harvest_price_helper.
  ///
  /// In fr, this message translates to:
  /// **'Sera mémorisé pour les prochaines récoltes de cette plante'**
  String get harvest_price_helper;

  /// No description provided for @harvest_notes_label.
  ///
  /// In fr, this message translates to:
  /// **'Notes / Qualité'**
  String get harvest_notes_label;

  /// No description provided for @harvest_action_save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get harvest_action_save;

  /// No description provided for @harvest_snack_saved.
  ///
  /// In fr, this message translates to:
  /// **'Récolte enregistrée'**
  String get harvest_snack_saved;

  /// No description provided for @harvest_snack_error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'enregistrement'**
  String get harvest_snack_error;

  /// No description provided for @harvest_form_error_required.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get harvest_form_error_required;

  /// No description provided for @harvest_form_error_positive.
  ///
  /// In fr, this message translates to:
  /// **'Invalide (> 0)'**
  String get harvest_form_error_positive;

  /// No description provided for @harvest_form_error_positive_or_zero.
  ///
  /// In fr, this message translates to:
  /// **'Invalide (>= 0)'**
  String get harvest_form_error_positive_or_zero;

  /// No description provided for @info_exposure_full_sun.
  ///
  /// In fr, this message translates to:
  /// **'Plein soleil'**
  String get info_exposure_full_sun;

  /// No description provided for @info_exposure_partial_sun.
  ///
  /// In fr, this message translates to:
  /// **'Mi-ombre'**
  String get info_exposure_partial_sun;

  /// No description provided for @info_exposure_shade.
  ///
  /// In fr, this message translates to:
  /// **'Ombre'**
  String get info_exposure_shade;

  /// No description provided for @info_water_low.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get info_water_low;

  /// No description provided for @info_water_medium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get info_water_medium;

  /// No description provided for @info_water_high.
  ///
  /// In fr, this message translates to:
  /// **'Élevé'**
  String get info_water_high;

  /// No description provided for @info_water_moderate.
  ///
  /// In fr, this message translates to:
  /// **'Modéré'**
  String get info_water_moderate;

  /// No description provided for @info_season_spring.
  ///
  /// In fr, this message translates to:
  /// **'Printemps'**
  String get info_season_spring;

  /// No description provided for @info_season_summer.
  ///
  /// In fr, this message translates to:
  /// **'Été'**
  String get info_season_summer;

  /// No description provided for @info_season_autumn.
  ///
  /// In fr, this message translates to:
  /// **'Automne'**
  String get info_season_autumn;

  /// No description provided for @info_season_winter.
  ///
  /// In fr, this message translates to:
  /// **'Hiver'**
  String get info_season_winter;

  /// No description provided for @info_season_all.
  ///
  /// In fr, this message translates to:
  /// **'Toute saison'**
  String get info_season_all;

  /// No description provided for @common_duplicate.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer'**
  String get common_duplicate;

  /// No description provided for @planting_delete_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la plantation'**
  String get planting_delete_title;

  /// No description provided for @planting_delete_confirm_body.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cette plantation ? Cette action est irréversible.'**
  String get planting_delete_confirm_body;

  /// No description provided for @planting_creation_title.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle culture'**
  String get planting_creation_title;

  /// No description provided for @planting_creation_title_edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la culture'**
  String get planting_creation_title_edit;

  /// No description provided for @planting_quantity_seeds.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de graines'**
  String get planting_quantity_seeds;

  /// No description provided for @planting_quantity_plants.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de plants'**
  String get planting_quantity_plants;

  /// No description provided for @planting_quantity_required.
  ///
  /// In fr, this message translates to:
  /// **'La quantité est requise'**
  String get planting_quantity_required;

  /// No description provided for @planting_quantity_positive.
  ///
  /// In fr, this message translates to:
  /// **'La quantité doit être un nombre positif'**
  String get planting_quantity_positive;

  /// No description provided for @planting_plant_selection_label.
  ///
  /// In fr, this message translates to:
  /// **'Plante : {plantName}'**
  String planting_plant_selection_label(Object plantName);

  /// No description provided for @planting_no_plant_selected.
  ///
  /// In fr, this message translates to:
  /// **'Aucune plante sélectionnée'**
  String get planting_no_plant_selected;

  /// No description provided for @planting_custom_plant_title.
  ///
  /// In fr, this message translates to:
  /// **'Plante personnalisée'**
  String get planting_custom_plant_title;

  /// No description provided for @planting_plant_name_label.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la plante'**
  String get planting_plant_name_label;

  /// No description provided for @planting_plant_name_hint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Tomate cerise'**
  String get planting_plant_name_hint;

  /// No description provided for @planting_plant_name_required.
  ///
  /// In fr, this message translates to:
  /// **'Le nom de la plante est requis'**
  String get planting_plant_name_required;

  /// No description provided for @planting_notes_label.
  ///
  /// In fr, this message translates to:
  /// **'Notes (optionnel)'**
  String get planting_notes_label;

  /// No description provided for @planting_notes_hint.
  ///
  /// In fr, this message translates to:
  /// **'Informations supplémentaires...'**
  String get planting_notes_hint;

  /// No description provided for @planting_tips_title.
  ///
  /// In fr, this message translates to:
  /// **'Conseils'**
  String get planting_tips_title;

  /// No description provided for @planting_tips_catalog.
  ///
  /// In fr, this message translates to:
  /// **'• Utilisez le catalogue pour sélectionner une plante.'**
  String get planting_tips_catalog;

  /// No description provided for @planting_tips_type.
  ///
  /// In fr, this message translates to:
  /// **'• Choisissez \"Semé\" pour les graines, \"Planté\" pour les plants.'**
  String get planting_tips_type;

  /// No description provided for @planting_tips_notes.
  ///
  /// In fr, this message translates to:
  /// **'• Ajoutez des notes pour suivre les conditions spéciales.'**
  String get planting_tips_notes;

  /// No description provided for @planting_date_future_error.
  ///
  /// In fr, this message translates to:
  /// **'La date de plantation ne peut pas être dans le futur'**
  String get planting_date_future_error;

  /// No description provided for @planting_success_create.
  ///
  /// In fr, this message translates to:
  /// **'Culture créée avec succès'**
  String get planting_success_create;

  /// No description provided for @planting_success_update.
  ///
  /// In fr, this message translates to:
  /// **'Culture modifiée avec succès'**
  String get planting_success_update;

  /// Titre écran statistiques
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get stats_screen_title;

  /// Sous-titre écran statistiques
  ///
  /// In fr, this message translates to:
  /// **'Analysez en temps réel et exportez vos données.'**
  String get stats_screen_subtitle;

  /// Titre KPI Alignement
  ///
  /// In fr, this message translates to:
  /// **'Alignement au Vivant'**
  String get kpi_alignment_title;

  /// Description KPI Alignement
  ///
  /// In fr, this message translates to:
  /// **'Cet outil évalue à quel point tu réalises tes semis, plantations et récoltes dans la fenêtre idéale recommandée par l\'Agenda Intelligent.'**
  String get kpi_alignment_description;

  /// CTA KPI Alignement
  ///
  /// In fr, this message translates to:
  /// **'Commence à planter et récolter pour voir ton alignement !'**
  String get kpi_alignment_cta;

  /// Label aligné
  ///
  /// In fr, this message translates to:
  /// **'aligné'**
  String get kpi_alignment_aligned;

  /// Label Total
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get kpi_alignment_total;

  /// Label Actions Alignées
  ///
  /// In fr, this message translates to:
  /// **'Alignées'**
  String get kpi_alignment_aligned_actions;

  /// Label Actions Décalées
  ///
  /// In fr, this message translates to:
  /// **'Décalées'**
  String get kpi_alignment_misaligned_actions;

  /// Message calcul alignement
  ///
  /// In fr, this message translates to:
  /// **'Calcul de l\'alignement...'**
  String get kpi_alignment_calculating;

  /// Message erreur alignement
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du calcul'**
  String get kpi_alignment_error;

  /// Titre Pilier Économie
  ///
  /// In fr, this message translates to:
  /// **'Économie du jardin'**
  String get pillar_economy_title;

  /// Titre Pilier Nutrition
  ///
  /// In fr, this message translates to:
  /// **'Équilibre Nutritionnel'**
  String get pillar_nutrition_title;

  /// Titre Pilier Export
  ///
  /// In fr, this message translates to:
  /// **'Export'**
  String get pillar_export_title;

  /// Label Pilier Économie
  ///
  /// In fr, this message translates to:
  /// **'Valeur totale des récoltes'**
  String get pillar_economy_label;

  /// Label Pilier Nutrition
  ///
  /// In fr, this message translates to:
  /// **'Signature Nutritionnelle'**
  String get pillar_nutrition_label;

  /// Label Pilier Export
  ///
  /// In fr, this message translates to:
  /// **'Récupérez vos données'**
  String get pillar_export_label;

  /// Bouton Pilier Export
  ///
  /// In fr, this message translates to:
  /// **'Exporter'**
  String get pillar_export_button;

  /// Titre écran économie
  ///
  /// In fr, this message translates to:
  /// **'Économie du Jardin'**
  String get stats_economy_title;

  /// Message vide économie
  ///
  /// In fr, this message translates to:
  /// **'Aucune récolte sur la période sélectionnée.'**
  String get stats_economy_no_harvest;

  /// Sous-titre vide économie
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée sur la période sélectionnée.'**
  String get stats_economy_no_harvest_desc;

  /// KPI Revenu Total
  ///
  /// In fr, this message translates to:
  /// **'Revenu Total'**
  String get stats_kpi_total_revenue;

  /// KPI Volume Total
  ///
  /// In fr, this message translates to:
  /// **'Volume Total'**
  String get stats_kpi_total_volume;

  /// KPI Prix Moyen
  ///
  /// In fr, this message translates to:
  /// **'Prix Moyen'**
  String get stats_kpi_avg_price;

  /// Titre Top Cultures
  ///
  /// In fr, this message translates to:
  /// **'Top Cultures (Valeur)'**
  String get stats_top_cultures_title;

  /// Vide Top Cultures
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée'**
  String get stats_top_cultures_no_data;

  /// Suffixe pourcentage revenu
  ///
  /// In fr, this message translates to:
  /// **'du revenu'**
  String get stats_top_cultures_percent_revenue;

  /// Titre Revenu Mensuel
  ///
  /// In fr, this message translates to:
  /// **'Revenu Mensuel'**
  String get stats_monthly_revenue_title;

  /// Vide Revenu Mensuel
  ///
  /// In fr, this message translates to:
  /// **'Pas de données mensuelles'**
  String get stats_monthly_revenue_no_data;

  /// Titre Culture Dominante
  ///
  /// In fr, this message translates to:
  /// **'Culture Dominante par Mois'**
  String get stats_dominant_culture_title;

  /// Titre Évolution Annuelle
  ///
  /// In fr, this message translates to:
  /// **'Évolution Annuelle'**
  String get stats_annual_evolution_title;

  /// Titre Répartition Culture
  ///
  /// In fr, this message translates to:
  /// **'Répartition par Culture'**
  String get stats_crop_distribution_title;

  /// Label Autres pie chart
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get stats_crop_distribution_others;

  /// Titre Mois Clés
  ///
  /// In fr, this message translates to:
  /// **'Mois Clés du Jardin'**
  String get stats_key_months_title;

  /// Label plus rentable
  ///
  /// In fr, this message translates to:
  /// **'Le plus rentable'**
  String get stats_most_profitable;

  /// Label moins rentable
  ///
  /// In fr, this message translates to:
  /// **'Le moins rentable'**
  String get stats_least_profitable;

  /// Titre Synthèse Automatique
  ///
  /// In fr, this message translates to:
  /// **'Synthèse Automatique'**
  String get stats_auto_summary_title;

  /// Titre Historique Revenu
  ///
  /// In fr, this message translates to:
  /// **'Historique du Revenu'**
  String get stats_revenue_history_title;

  /// Titre Cycle Rentabilité
  ///
  /// In fr, this message translates to:
  /// **'Cycle de Rentabilité'**
  String get stats_profitability_cycle_title;

  /// Header colonne Culture
  ///
  /// In fr, this message translates to:
  /// **'Culture'**
  String get stats_table_crop;

  /// Header colonne Jours
  ///
  /// In fr, this message translates to:
  /// **'Jours (Moy)'**
  String get stats_table_days;

  /// Header colonne Revenu
  ///
  /// In fr, this message translates to:
  /// **'Rev/Récolte'**
  String get stats_table_revenue;

  /// Header colonne Type
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get stats_table_type;

  /// Type culture rapide
  ///
  /// In fr, this message translates to:
  /// **'Rapide'**
  String get stats_type_fast;

  /// No description provided for @stats_type_long_term.
  ///
  /// In fr, this message translates to:
  /// **'Long terme'**
  String get stats_type_long_term;

  /// Titre écrant nutrition
  ///
  /// In fr, this message translates to:
  /// **'Signature Nutritionnelle'**
  String get nutrition_page_title;

  /// Titre dynamique saisonnière
  ///
  /// In fr, this message translates to:
  /// **'Dynamique Saisonnière'**
  String get nutrition_seasonal_dynamics_title;

  /// Desc dynamique saisonnière
  ///
  /// In fr, this message translates to:
  /// **'Explorez la production minérale et vitaminique de votre jardin, mois par mois.'**
  String get nutrition_seasonal_dynamics_desc;

  /// Vide mois
  ///
  /// In fr, this message translates to:
  /// **'Aucune récolte en ce mois'**
  String get nutrition_no_harvest_month;

  /// Titre minéraux majeurs
  ///
  /// In fr, this message translates to:
  /// **'Structure & Minéraux Majeurs'**
  String get nutrition_major_minerals_title;

  /// Titre oligo éléments
  ///
  /// In fr, this message translates to:
  /// **'Vitalité & Oligo-éléments'**
  String get nutrition_trace_elements_title;

  /// Pas de données chart
  ///
  /// In fr, this message translates to:
  /// **'Pas de données cette période'**
  String get nutrition_no_data_period;

  /// Vide chart majeurs
  ///
  /// In fr, this message translates to:
  /// **'Aucun minéral majeur'**
  String get nutrition_no_major_minerals;

  /// Vide chart oligo
  ///
  /// In fr, this message translates to:
  /// **'Aucun oligo-élément'**
  String get nutrition_no_trace_elements;

  /// Titre dynamique mois
  ///
  /// In fr, this message translates to:
  /// **'Dynamique de {month}'**
  String nutrition_month_dynamics_title(String month);

  /// Label production dominante
  ///
  /// In fr, this message translates to:
  /// **'Production dominante :'**
  String get nutrition_dominant_production;

  /// Note origine nutriments
  ///
  /// In fr, this message translates to:
  /// **'Ces nutriments proviennent de vos récoltes du mois.'**
  String get nutrition_nutrients_origin;

  /// No description provided for @nut_calcium.
  ///
  /// In fr, this message translates to:
  /// **'Calcium'**
  String get nut_calcium;

  /// No description provided for @nut_potassium.
  ///
  /// In fr, this message translates to:
  /// **'Potassium'**
  String get nut_potassium;

  /// No description provided for @nut_magnesium.
  ///
  /// In fr, this message translates to:
  /// **'Magnésium'**
  String get nut_magnesium;

  /// No description provided for @nut_iron.
  ///
  /// In fr, this message translates to:
  /// **'Fer'**
  String get nut_iron;

  /// No description provided for @nut_zinc.
  ///
  /// In fr, this message translates to:
  /// **'Zinc'**
  String get nut_zinc;

  /// No description provided for @nut_manganese.
  ///
  /// In fr, this message translates to:
  /// **'Manganèse'**
  String get nut_manganese;

  /// No description provided for @nut_vitamin_c.
  ///
  /// In fr, this message translates to:
  /// **'Vitamine C'**
  String get nut_vitamin_c;

  /// No description provided for @nut_fiber.
  ///
  /// In fr, this message translates to:
  /// **'Fibres'**
  String get nut_fiber;

  /// No description provided for @nut_protein.
  ///
  /// In fr, this message translates to:
  /// **'Protéines'**
  String get nut_protein;

  /// No description provided for @export_builder_title.
  ///
  /// In fr, this message translates to:
  /// **'Générateur d\'Export'**
  String get export_builder_title;

  /// No description provided for @export_scope_section.
  ///
  /// In fr, this message translates to:
  /// **'1. Périmètre'**
  String get export_scope_section;

  /// No description provided for @export_scope_period.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get export_scope_period;

  /// No description provided for @export_scope_period_all.
  ///
  /// In fr, this message translates to:
  /// **'Tout l\'historique'**
  String get export_scope_period_all;

  /// No description provided for @export_filter_garden_title.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par Jardin'**
  String get export_filter_garden_title;

  /// No description provided for @export_filter_garden_all.
  ///
  /// In fr, this message translates to:
  /// **'Tous les jardins'**
  String get export_filter_garden_all;

  /// No description provided for @export_filter_garden_count.
  ///
  /// In fr, this message translates to:
  /// **'{count} jardin(s) sélectionné(s)'**
  String export_filter_garden_count(Object count);

  /// No description provided for @export_filter_garden_edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la sélection'**
  String get export_filter_garden_edit;

  /// No description provided for @export_filter_garden_select_dialog_title.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner les jardins'**
  String get export_filter_garden_select_dialog_title;

  /// No description provided for @export_blocks_section.
  ///
  /// In fr, this message translates to:
  /// **'2. Données à inclure'**
  String get export_blocks_section;

  /// No description provided for @export_block_activity.
  ///
  /// In fr, this message translates to:
  /// **'Activités (Journal)'**
  String get export_block_activity;

  /// No description provided for @export_block_harvest.
  ///
  /// In fr, this message translates to:
  /// **'Récoltes (Production)'**
  String get export_block_harvest;

  /// No description provided for @export_block_garden.
  ///
  /// In fr, this message translates to:
  /// **'Jardins (Structure)'**
  String get export_block_garden;

  /// No description provided for @export_block_garden_bed.
  ///
  /// In fr, this message translates to:
  /// **'Parcelles (Structure)'**
  String get export_block_garden_bed;

  /// No description provided for @export_block_plant.
  ///
  /// In fr, this message translates to:
  /// **'Plantes (Catalogue)'**
  String get export_block_plant;

  /// No description provided for @export_block_desc_activity.
  ///
  /// In fr, this message translates to:
  /// **'Historique complet des interventions et événements'**
  String get export_block_desc_activity;

  /// No description provided for @export_block_desc_harvest.
  ///
  /// In fr, this message translates to:
  /// **'Données de production et rendements'**
  String get export_block_desc_harvest;

  /// No description provided for @export_block_desc_garden.
  ///
  /// In fr, this message translates to:
  /// **'Métadonnées des jardins sélectionnés'**
  String get export_block_desc_garden;

  /// No description provided for @export_block_desc_garden_bed.
  ///
  /// In fr, this message translates to:
  /// **'Détails des parcelles (surface, orientation...)'**
  String get export_block_desc_garden_bed;

  /// No description provided for @export_block_desc_plant.
  ///
  /// In fr, this message translates to:
  /// **'Liste des plantes utilisées'**
  String get export_block_desc_plant;

  /// No description provided for @export_columns_section.
  ///
  /// In fr, this message translates to:
  /// **'3. Détails & Colonnes'**
  String get export_columns_section;

  /// No description provided for @export_columns_count.
  ///
  /// In fr, this message translates to:
  /// **'{count} colonnes sélectionnées'**
  String export_columns_count(Object count);

  /// No description provided for @export_format_section.
  ///
  /// In fr, this message translates to:
  /// **'4. Format du fichier'**
  String get export_format_section;

  /// No description provided for @export_format_separate.
  ///
  /// In fr, this message translates to:
  /// **'Feuilles séparées (Standard)'**
  String get export_format_separate;

  /// No description provided for @export_format_separate_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une feuille par type de donnée (Recommandé)'**
  String get export_format_separate_subtitle;

  /// No description provided for @export_format_flat.
  ///
  /// In fr, this message translates to:
  /// **'Table Unique (Flat / BI)'**
  String get export_format_flat;

  /// No description provided for @export_format_flat_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une seule grande table pour Tableaux Croisés Dynamiques'**
  String get export_format_flat_subtitle;

  /// No description provided for @export_action_generate.
  ///
  /// In fr, this message translates to:
  /// **'Générer Export Excel'**
  String get export_action_generate;

  /// No description provided for @export_generating.
  ///
  /// In fr, this message translates to:
  /// **'Génération en cours...'**
  String get export_generating;

  /// No description provided for @export_success_title.
  ///
  /// In fr, this message translates to:
  /// **'Export terminé'**
  String get export_success_title;

  /// No description provided for @export_success_share_text.
  ///
  /// In fr, this message translates to:
  /// **'Voici votre export PermaCalendar'**
  String get export_success_share_text;

  /// No description provided for @export_error_snack.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {error}'**
  String export_error_snack(Object error);

  /// No description provided for @export_field_garden_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom du jardin'**
  String get export_field_garden_name;

  /// No description provided for @export_field_garden_id.
  ///
  /// In fr, this message translates to:
  /// **'ID Jardin'**
  String get export_field_garden_id;

  /// No description provided for @export_field_garden_surface.
  ///
  /// In fr, this message translates to:
  /// **'Surface (m²)'**
  String get export_field_garden_surface;

  /// No description provided for @export_field_garden_creation.
  ///
  /// In fr, this message translates to:
  /// **'Date création'**
  String get export_field_garden_creation;

  /// No description provided for @export_field_bed_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom parcelle'**
  String get export_field_bed_name;

  /// No description provided for @export_field_bed_id.
  ///
  /// In fr, this message translates to:
  /// **'ID Parcelle'**
  String get export_field_bed_id;

  /// No description provided for @export_field_bed_surface.
  ///
  /// In fr, this message translates to:
  /// **'Surface (m²)'**
  String get export_field_bed_surface;

  /// No description provided for @export_field_bed_plant_count.
  ///
  /// In fr, this message translates to:
  /// **'Nb Plantes'**
  String get export_field_bed_plant_count;

  /// No description provided for @export_field_plant_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom commun'**
  String get export_field_plant_name;

  /// No description provided for @export_field_plant_id.
  ///
  /// In fr, this message translates to:
  /// **'ID Plante'**
  String get export_field_plant_id;

  /// No description provided for @export_field_plant_scientific.
  ///
  /// In fr, this message translates to:
  /// **'Nom scientifique'**
  String get export_field_plant_scientific;

  /// No description provided for @export_field_plant_family.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get export_field_plant_family;

  /// No description provided for @export_field_plant_variety.
  ///
  /// In fr, this message translates to:
  /// **'Variété'**
  String get export_field_plant_variety;

  /// No description provided for @export_field_harvest_date.
  ///
  /// In fr, this message translates to:
  /// **'Date Récolte'**
  String get export_field_harvest_date;

  /// No description provided for @export_field_harvest_qty.
  ///
  /// In fr, this message translates to:
  /// **'Quantité (kg)'**
  String get export_field_harvest_qty;

  /// No description provided for @export_field_harvest_plant_name.
  ///
  /// In fr, this message translates to:
  /// **'Plante'**
  String get export_field_harvest_plant_name;

  /// No description provided for @export_field_harvest_price.
  ///
  /// In fr, this message translates to:
  /// **'Prix/kg'**
  String get export_field_harvest_price;

  /// No description provided for @export_field_harvest_value.
  ///
  /// In fr, this message translates to:
  /// **'Valeur Totale'**
  String get export_field_harvest_value;

  /// No description provided for @export_field_harvest_notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get export_field_harvest_notes;

  /// No description provided for @export_field_harvest_garden_name.
  ///
  /// In fr, this message translates to:
  /// **'Jardin'**
  String get export_field_harvest_garden_name;

  /// No description provided for @export_field_harvest_garden_id.
  ///
  /// In fr, this message translates to:
  /// **'ID Jardin'**
  String get export_field_harvest_garden_id;

  /// No description provided for @export_field_harvest_bed_name.
  ///
  /// In fr, this message translates to:
  /// **'Parcelle'**
  String get export_field_harvest_bed_name;

  /// No description provided for @export_field_harvest_bed_id.
  ///
  /// In fr, this message translates to:
  /// **'ID Parcelle'**
  String get export_field_harvest_bed_id;

  /// No description provided for @export_field_activity_date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get export_field_activity_date;

  /// No description provided for @export_field_activity_type.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get export_field_activity_type;

  /// No description provided for @export_field_activity_title.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get export_field_activity_title;

  /// No description provided for @export_field_activity_desc.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get export_field_activity_desc;

  /// No description provided for @export_field_activity_entity.
  ///
  /// In fr, this message translates to:
  /// **'Entité Cible'**
  String get export_field_activity_entity;

  /// No description provided for @export_field_activity_entity_id.
  ///
  /// In fr, this message translates to:
  /// **'ID Cible'**
  String get export_field_activity_entity_id;

  /// No description provided for @export_activity_type_garden_created.
  ///
  /// In fr, this message translates to:
  /// **'Création de jardin'**
  String get export_activity_type_garden_created;

  /// No description provided for @export_activity_type_garden_updated.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour du jardin'**
  String get export_activity_type_garden_updated;

  /// No description provided for @export_activity_type_garden_deleted.
  ///
  /// In fr, this message translates to:
  /// **'Suppression de jardin'**
  String get export_activity_type_garden_deleted;

  /// No description provided for @export_activity_type_bed_created.
  ///
  /// In fr, this message translates to:
  /// **'Création de parcelle'**
  String get export_activity_type_bed_created;

  /// No description provided for @export_activity_type_bed_updated.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour de parcelle'**
  String get export_activity_type_bed_updated;

  /// No description provided for @export_activity_type_bed_deleted.
  ///
  /// In fr, this message translates to:
  /// **'Suppression de parcelle'**
  String get export_activity_type_bed_deleted;

  /// No description provided for @export_activity_type_planting_created.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle plantation'**
  String get export_activity_type_planting_created;

  /// No description provided for @export_activity_type_planting_updated.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour plantation'**
  String get export_activity_type_planting_updated;

  /// No description provided for @export_activity_type_planting_deleted.
  ///
  /// In fr, this message translates to:
  /// **'Suppression plantation'**
  String get export_activity_type_planting_deleted;

  /// No description provided for @export_activity_type_harvest.
  ///
  /// In fr, this message translates to:
  /// **'Récolte'**
  String get export_activity_type_harvest;

  /// No description provided for @export_activity_type_maintenance.
  ///
  /// In fr, this message translates to:
  /// **'Entretien'**
  String get export_activity_type_maintenance;

  /// No description provided for @export_activity_type_weather.
  ///
  /// In fr, this message translates to:
  /// **'Météo'**
  String get export_activity_type_weather;

  /// No description provided for @export_activity_type_error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get export_activity_type_error;

  /// No description provided for @export_excel_total.
  ///
  /// In fr, this message translates to:
  /// **'TOTAL'**
  String get export_excel_total;

  /// No description provided for @export_excel_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get export_excel_unknown;

  /// No description provided for @export_field_advanced_suffix.
  ///
  /// In fr, this message translates to:
  /// **' (Avancé)'**
  String get export_field_advanced_suffix;

  /// No description provided for @export_field_desc_garden_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom donné au jardin'**
  String get export_field_desc_garden_name;

  /// No description provided for @export_field_desc_garden_id.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant unique technique'**
  String get export_field_desc_garden_id;

  /// No description provided for @export_field_desc_garden_surface.
  ///
  /// In fr, this message translates to:
  /// **'Surface totale du jardin'**
  String get export_field_desc_garden_surface;

  /// No description provided for @export_field_desc_garden_creation.
  ///
  /// In fr, this message translates to:
  /// **'Date de création dans l\'application'**
  String get export_field_desc_garden_creation;

  /// No description provided for @export_field_desc_bed_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la parcelle'**
  String get export_field_desc_bed_name;

  /// No description provided for @export_field_desc_bed_id.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant unique technique'**
  String get export_field_desc_bed_id;

  /// No description provided for @export_field_desc_bed_surface.
  ///
  /// In fr, this message translates to:
  /// **'Surface de la parcelle'**
  String get export_field_desc_bed_surface;

  /// No description provided for @export_field_desc_bed_plant_count.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de cultures en place (actuel)'**
  String get export_field_desc_bed_plant_count;

  /// No description provided for @export_field_desc_plant_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom usuel de la plante'**
  String get export_field_desc_plant_name;

  /// No description provided for @export_field_desc_plant_id.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant unique technique'**
  String get export_field_desc_plant_id;

  /// No description provided for @export_field_desc_plant_scientific.
  ///
  /// In fr, this message translates to:
  /// **'Dénomination botanique'**
  String get export_field_desc_plant_scientific;

  /// No description provided for @export_field_desc_plant_family.
  ///
  /// In fr, this message translates to:
  /// **'Famille botanique'**
  String get export_field_desc_plant_family;

  /// No description provided for @export_field_desc_plant_variety.
  ///
  /// In fr, this message translates to:
  /// **'Variété spécifique'**
  String get export_field_desc_plant_variety;

  /// No description provided for @export_field_desc_harvest_date.
  ///
  /// In fr, this message translates to:
  /// **'Date de l\'événement de récolte'**
  String get export_field_desc_harvest_date;

  /// No description provided for @export_field_desc_harvest_qty.
  ///
  /// In fr, this message translates to:
  /// **'Poids récolté en kg'**
  String get export_field_desc_harvest_qty;

  /// No description provided for @export_field_desc_harvest_plant_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la plante récoltée'**
  String get export_field_desc_harvest_plant_name;

  /// No description provided for @export_field_desc_harvest_price.
  ///
  /// In fr, this message translates to:
  /// **'Prix au kg configuré'**
  String get export_field_desc_harvest_price;

  /// No description provided for @export_field_desc_harvest_value.
  ///
  /// In fr, this message translates to:
  /// **'Quantité * Prix/kg'**
  String get export_field_desc_harvest_value;

  /// No description provided for @export_field_desc_harvest_notes.
  ///
  /// In fr, this message translates to:
  /// **'Observations saisies lors de la récolte'**
  String get export_field_desc_harvest_notes;

  /// No description provided for @export_field_desc_harvest_garden_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom du jardin d\'origine (si disponible)'**
  String get export_field_desc_harvest_garden_name;

  /// No description provided for @export_field_desc_harvest_garden_id.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant unique du jardin'**
  String get export_field_desc_harvest_garden_id;

  /// No description provided for @export_field_desc_harvest_bed_name.
  ///
  /// In fr, this message translates to:
  /// **'Parcelle d\'origine (si disponible)'**
  String get export_field_desc_harvest_bed_name;

  /// No description provided for @export_field_desc_harvest_bed_id.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant parcelle'**
  String get export_field_desc_harvest_bed_id;

  /// No description provided for @export_field_desc_activity_date.
  ///
  /// In fr, this message translates to:
  /// **'Date de l\'activité'**
  String get export_field_desc_activity_date;

  /// No description provided for @export_field_desc_activity_type.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie d\'action (Semis, Récolte, Soin...)'**
  String get export_field_desc_activity_type;

  /// No description provided for @export_field_desc_activity_title.
  ///
  /// In fr, this message translates to:
  /// **'Résumé de l\'action'**
  String get export_field_desc_activity_title;

  /// No description provided for @export_field_desc_activity_desc.
  ///
  /// In fr, this message translates to:
  /// **'Détails complets'**
  String get export_field_desc_activity_desc;

  /// No description provided for @export_field_desc_activity_entity.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'objet concerné (Plante, Parcelle...)'**
  String get export_field_desc_activity_entity;

  /// No description provided for @export_field_desc_activity_entity_id.
  ///
  /// In fr, this message translates to:
  /// **'ID de l\'objet concerné'**
  String get export_field_desc_activity_entity_id;

  /// Label du bouton Semer
  ///
  /// In fr, this message translates to:
  /// **'Semer'**
  String get plant_catalog_sow;

  /// Label du bouton Planter
  ///
  /// In fr, this message translates to:
  /// **'Planter'**
  String get plant_catalog_plant;

  /// Bouton pour afficher la sélection Semer/Planter
  ///
  /// In fr, this message translates to:
  /// **'Afficher sélection'**
  String get plant_catalog_show_selection;

  /// Filtre afficher uniquement les plantes vertes (idéal ce mois)
  ///
  /// In fr, this message translates to:
  /// **'Verts seulement'**
  String get plant_catalog_filter_green_only;

  /// Filtre afficher les plantes vertes et oranges
  ///
  /// In fr, this message translates to:
  /// **'Verts + Oranges'**
  String get plant_catalog_filter_green_orange;

  /// Filtre afficher toutes les plantes
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get plant_catalog_filter_all;

  /// Message si aucune plante n'est recommandée pour la date/action donnée
  ///
  /// In fr, this message translates to:
  /// **'Aucune plante recommandée sur la période.'**
  String get plant_catalog_no_recommended;

  /// Action pour élargir la fenêtre temporelle
  ///
  /// In fr, this message translates to:
  /// **'Élargir (±2 mois)'**
  String get plant_catalog_expand_window;

  /// Message quand la plante n'a pas d'information de période
  ///
  /// In fr, this message translates to:
  /// **'Données de période manquantes'**
  String get plant_catalog_missing_period_data;

  /// Préfixe listant les périodes available pour la plante
  ///
  /// In fr, this message translates to:
  /// **'Périodes: {months}'**
  String plant_catalog_periods_prefix(String months);

  /// Légende couleur verte
  ///
  /// In fr, this message translates to:
  /// **'Prêt ce mois'**
  String get plant_catalog_legend_green;

  /// Légende couleur orange
  ///
  /// In fr, this message translates to:
  /// **'Proche / Bientôt'**
  String get plant_catalog_legend_orange;

  /// Légende couleur rouge
  ///
  /// In fr, this message translates to:
  /// **'Hors saison'**
  String get plant_catalog_legend_red;

  /// Mention pour données manquantes/grises
  ///
  /// In fr, this message translates to:
  /// **'Données inconnues'**
  String get plant_catalog_data_unknown;

  /// No description provided for @task_editor_photo_label.
  ///
  /// In fr, this message translates to:
  /// **'Photo de la tâche'**
  String get task_editor_photo_label;

  /// No description provided for @task_editor_photo_add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo'**
  String get task_editor_photo_add;

  /// No description provided for @task_editor_photo_change.
  ///
  /// In fr, this message translates to:
  /// **'Changer la photo'**
  String get task_editor_photo_change;

  /// No description provided for @task_editor_photo_remove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer la photo'**
  String get task_editor_photo_remove;

  /// No description provided for @task_editor_photo_help.
  ///
  /// In fr, this message translates to:
  /// **'La photo sera jointe automatiquement au PDF / Word à la création / envoi.'**
  String get task_editor_photo_help;
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
