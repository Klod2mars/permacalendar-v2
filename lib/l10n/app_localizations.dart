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

  /// Message erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get common_general_error;

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

  /// Titre erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get common_error;

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

  /// Erreur validation titre
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get task_editor_error_title_required;

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
