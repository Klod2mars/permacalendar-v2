// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sowing';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get home_settings_fallback_label => 'Paramètres (repli)';

  @override
  String get settings_application => 'Application';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_display => 'Affichage';

  @override
  String get settings_weather_selector => 'Sélecteur météo';

  @override
  String get settings_commune_title => 'Commune pour la météo';

  @override
  String get settings_choose_commune => 'Choisir une commune';

  @override
  String get settings_search_commune_hint => 'Rechercher une commune…';

  @override
  String settings_commune_default(String label) {
    return 'Défaut: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Sélectionnée: $label';
  }

  @override
  String get settings_quick_access => 'Accès rapide';

  @override
  String get settings_plants_catalog => 'Catalogue des plantes';

  @override
  String get settings_plants_catalog_subtitle =>
      'Rechercher et consulter les plantes';

  @override
  String get settings_about => 'À propos';

  @override
  String get settings_user_guide => 'Guide d\'utilisation';

  @override
  String get settings_user_guide_subtitle => 'Consulter la notice';

  @override
  String get settings_privacy => 'Confidentialité';

  @override
  String get settings_privacy_policy => 'Politique de confidentialité';

  @override
  String get settings_terms => 'Conditions d\'utilisation';

  @override
  String get settings_version_dialog_title => 'Version de l\'application';

  @override
  String settings_version_dialog_content(String version) {
    return 'Version: $version – Gestion de jardin dynamique\n\nSowing - Gestion de jardins vivants';
  }

  @override
  String get language_title => 'Langue / Language';

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
    return 'Langue changée : $label';
  }

  @override
  String get calibration_title => 'Calibration';

  @override
  String get calibration_subtitle =>
      'Personnalisez l\'affichage de votre dashboard';

  @override
  String get calibration_organic_title => 'Calibration Organique';

  @override
  String get calibration_organic_subtitle =>
      'Mode unifié : Image, Ciel, Modules';

  @override
  String get calibration_organic_disabled =>
      '🌿 Calibration organique désactivée';

  @override
  String get calibration_organic_enabled =>
      '🌿 Mode calibration organique activé. Sélectionnez l’un des trois onglets.';

  @override
  String get garden_list_title => 'Mes jardins';

  @override
  String get garden_error_title => 'Erreur de chargement';

  @override
  String garden_error_subtitle(String error) {
    return 'Impossible de charger la liste des jardins : $error';
  }

  @override
  String get garden_retry => 'Réessayer';

  @override
  String get garden_no_gardens => 'Aucun jardin pour le moment.';

  @override
  String get garden_archived_info =>
      'Vous avez des jardins archivés. Activez l’affichage des jardins archivés pour les voir.';

  @override
  String get garden_add_tooltip => 'Ajouter un jardin';

  @override
  String get plant_catalog_title => 'Catalogue de plantes';

  @override
  String get plant_custom_badge => 'Perso';

  @override
  String get plant_detail_not_found_title => 'Plante introuvable';

  @override
  String get plant_detail_not_found_body =>
      'Cette plante n\'existe pas ou n\'a pas pu être chargée.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant ajouté aux favoris';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Ajouter au jardin';

  @override
  String get plant_detail_popup_share => 'Partager';

  @override
  String get plant_detail_share_todo => 'Partage à implémenter';

  @override
  String get plant_detail_add_to_garden_todo => 'Ajout au jardin à implémenter';

  @override
  String get plant_detail_section_culture => 'Détails de culture';

  @override
  String get plant_detail_section_instructions => 'Instructions générales';

  @override
  String get plant_detail_detail_family => 'Famille';

  @override
  String get plant_detail_detail_maturity => 'Durée de maturation';

  @override
  String get plant_detail_detail_spacing => 'Espacement';

  @override
  String get plant_detail_detail_exposure => 'Exposition';

  @override
  String get plant_detail_detail_water => 'Besoins en eau';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Plantations - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Statistiques';

  @override
  String get planting_menu_ready_for_harvest => 'Prêt à récolter';

  @override
  String get planting_menu_test_data => 'Données test';

  @override
  String get planting_search_hint => 'Rechercher une plantation...';

  @override
  String get planting_filter_all_statuses => 'Tous les statuts';

  @override
  String get planting_filter_all_plants => 'Toutes les plantes';

  @override
  String get planting_stat_plantings => 'Plantations';

  @override
  String get planting_stat_total_quantity => 'Quantité totale';

  @override
  String get planting_stat_success_rate => 'Taux de réussite';

  @override
  String get planting_stat_in_growth => 'En croissance';

  @override
  String get planting_stat_ready_for_harvest => 'Prêt à récolter';

  @override
  String get planting_empty_none => 'Aucune plantation';

  @override
  String get planting_empty_first =>
      'Commencez par ajouter votre première plantation dans cette parcelle.';

  @override
  String get planting_create_action => 'Créer une plantation';

  @override
  String get planting_empty_no_result => 'Aucun résultat';

  @override
  String get planting_clear_filters => 'Effacer les filtres';

  @override
  String get planting_add_tooltip => 'Ajouter une plantation';

  @override
  String get search_hint => 'Rechercher...';

  @override
  String get error_page_title => 'Page non trouvée';

  @override
  String error_page_message(String uri) {
    return 'La page \"$uri\" n\'existe pas.';
  }

  @override
  String get error_page_back => 'Retour à l\'accueil';

  @override
  String get dialog_confirm => 'Confirmer';

  @override
  String get dialog_cancel => 'Annuler';

  @override
  String snackbar_commune_selected(String name) {
    return 'Commune sélectionnée: $name';
  }

  @override
  String get common_validate => 'Valider';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get empty_action_create => 'Créer';

  @override
  String get user_guide_text =>
      '1 — Bienvenue dans Sowing\nSowing est une application pensée pour accompagner les jardiniers et jardinières dans le suivi vivant et concret de leurs cultures.\nElle vous permet de :\n• organiser vos jardins et vos parcelles,\n• suivre vos plantations tout au long de leur cycle de vie,\n• planifier vos tâches au bon moment,\n• conserver la mémoire de ce qui a été fait,\n• prendre en compte la météo locale et le rythme des saisons.\nL’application fonctionne principalement hors ligne et conserve vos données directement sur votre appareil.\nCette notice décrit l’utilisation courante de Sowing : prise en main, création des jardins, plantations, calendrier, météo, export des données et bonnes pratiques.\n\n2 — Comprendre l’interface\nLe tableau de bord\nÀ l’ouverture, Sowing affiche un tableau de bord visuel et organique.\nIl se présente sous la forme d’une image de fond animée par des bulles interactives. Chaque bulle donne accès à une grande fonction de l’application :\n• jardins,\n• météo de l’air,\n• météo du sol,\n• calendrier,\n• activités,\n• statistiques,\n• paramètres.\nNavigation générale\nIl suffit de toucher une bulle pour ouvrir la section correspondante.\nÀ l’intérieur des pages, vous trouverez selon les contextes :\n• des menus contextuels,\n• des boutons « + » pour ajouter un élément,\n• des boutons d’édition ou de suppression.\n\n3 — Démarrage rapide\nOuvrir l’application\nAu lancement, le tableau de bord s’affiche automatiquement.\nConfigurer la météo\nDans les paramètres, choisissez votre commune.\nCette information permet à Sowing d’afficher une météo locale adaptée à votre jardin. Si aucune commune n’est sélectionnée, une localisation par défaut est utilisée.\nCréer votre premier jardin\nLors de la première utilisation, Sowing vous guide automatiquement pour créer votre premier jardin.\nVous pouvez également créer un jardin manuellement depuis le tableau de bord.\nSur l’écran principal, touchez la feuille verte située dans la zone la plus libre, à droite des statistiques et légèrement au‑dessus. Cette zone volontairement discrète permet d’initier la création d’un jardin.\nVous pouvez créer jusqu’à cinq jardins.\nCette approche fait partie de l’expérience Sowing : il n’existe pas de bouton « + » permanent et central. L’application invite plutôt à l’exploration et à la découverte progressive de l’espace.\nLes zones liées aux jardins sont également accessibles depuis le menu Paramètres.\nCalibration organique du tableau de bord\nUn mode de calibration organique permet :\n• de visualiser l’emplacement réel des zones interactives,\n• de les déplacer par simple glissement du doigt.\nVous pouvez ainsi positionner vos jardins et modules exactement où vous le souhaitez sur l’image : en haut, en bas ou à l’endroit qui vous convient le mieux.\nUne fois validée, cette organisation est enregistrée et conservée dans l’application.\nCréer une parcelle\nDans la fiche d’un jardin :\n• choisissez « Ajouter une parcelle »,\n• indiquez son nom, sa surface et, si besoin, quelques notes,\n• enregistrez.\nAjouter une plantation\nDans une parcelle :\n• appuyez sur le bouton « + »,\n• choisissez une plante dans le catalogue,\n• indiquez la date, la quantité et les informations utiles,\n• validez.\n\n4 — Le tableau de bord organique\nLe tableau de bord est le point central de Sowing.\nIl permet :\n• d’avoir une vue d’ensemble de votre activité,\n• d’accéder rapidement aux fonctions principales,\n• de naviguer de manière intuitive.\nSelon vos réglages, certaines bulles peuvent afficher des informations synthétiques, comme la météo ou les tâches à venir.\n\n5 — Jardins, parcelles et plantations\nLes jardins\nUn jardin représente un lieu réel : potager, serre, verger, balcon, etc.\nVous pouvez :\n• créer plusieurs jardins,\n• modifier leurs informations,\n• les supprimer si nécessaire.\nLes parcelles\nUne parcelle est une zone précise à l’intérieur d’un jardin.\nElle permet de structurer l’espace, d’organiser les cultures et de regrouper plusieurs plantations au même endroit.\nLes plantations\nUne plantation correspond à l’introduction d’une plante dans une parcelle, à une date donnée.\nLors de la création d’une plantation, Sowing propose deux modes.\nSemer\nLe mode « Semer » correspond à la mise en terre d’une graine.\nDans ce cas :\n• la progression démarre à 0 %,\n• un suivi pas à pas est proposé, particulièrement utile pour les jardiniers débutants,\n• une barre de progression visualise l’avancement du cycle de culture.\nCe suivi permet d’estimer :\n• le début probable de la période de récolte,\n• l’évolution de la culture dans le temps, de manière simple et visuelle.\nPlanter\nLe mode « Planter » est destiné aux plants déjà développés (plants issus d’une serre ou achetés en jardinerie).\nDans ce cas :\n• la plante démarre avec une progression d’environ 30 %,\n• le suivi est immédiatement plus avancé,\n• l’estimation de la période de récolte est ajustée en conséquence.\nChoix de la date\nLors de la plantation, vous pouvez choisir librement la date.\nCela permet par exemple :\n• de renseigner une plantation réalisée auparavant,\n• de corriger une date si l’application n’était pas utilisée au moment du semis ou de la plantation.\nPar défaut, la date du jour est utilisée.\nSuivi et historique\nChaque plantation dispose :\n• d’un suivi de progression,\n• d’informations sur son cycle de vie,\n• d’étapes de culture,\n• de notes personnelles.\nToutes les actions (semis, plantation, soins, récoltes) sont automatiquement enregistrées dans l’historique du jardin.\n\n6 — Catalogue de plantes\nLe catalogue regroupe l’ensemble des plantes disponibles lors de la création d’une plantation.\nIl constitue une base de référence évolutive, pensée pour couvrir les usages courants tout en restant personnalisable.\nFonctions principales :\n• recherche simple et rapide,\n• reconnaissance des noms courants et scientifiques,\n• affichage de photos lorsque disponibles.\nPlantes personnalisées\nVous pouvez créer vos propres plantes personnalisées depuis :\nParamètres → Catalogue de plantes.\nIl est alors possible de :\n• créer une nouvelle plante,\n• renseigner les paramètres essentiels (nom, type, informations utiles),\n• ajouter une image pour faciliter l’identification.\nLes plantes personnalisées sont ensuite utilisables comme n’importe quelle autre plante du catalogue.\n\n7 — Calendrier et tâches\nLa vue calendrier\nLe calendrier affiche :\n• les tâches prévues,\n• les plantations importantes,\n• les périodes de récolte estimées.\nCréer une tâche\nDepuis le calendrier :\n• créez une nouvelle tâche,\n• indiquez un titre, une date et une description,\n• choisissez une éventuelle récurrence.\nLes tâches peuvent être associées à un jardin ou à une parcelle.\nGestion des tâches\nVous pouvez :\n• modifier une tâche,\n• la supprimer,\n• l’exporter pour la partager.\n\n8 — Activités et historique\nCette section constitue la mémoire vivante de vos jardins.\nSélection d’un jardin\nDepuis le tableau de bord, effectuez un appui long sur un jardin pour le sélectionner.\nLe jardin actif est mis en évidence par une légère auréole verte et un bandeau de confirmation.\nCette sélection permet de filtrer les informations affichées.\nActivités récentes\nL’onglet « Activités » affiche chronologiquement :\n• créations,\n• plantations,\n• soins,\n• récoltes,\n• actions manuelles.\nHistorique par jardin\nL’onglet « Historique » présente l’historique complet du jardin sélectionné, année après année.\nIl permet notamment de :\n• retrouver les plantations passées,\n• vérifier si une plante a déjà été cultivée à un endroit donné,\n• mieux organiser la rotation des cultures.\n\n9 — Météo de l’air et météo du sol\nMétéo de l’air\nLa météo de l’air fournit les informations essentielles :\n• température extérieure,\n• précipitations (pluie, neige, absence de pluie),\n• alternance jour / nuit.\nCes données aident à anticiper les risques climatiques et à adapter les interventions.\nMétéo du sol\nSowing intègre un module de météo du sol.\nL’utilisateur peut renseigner une température mesurée. À partir de cette donnée, l’application estime dynamiquement l’évolution de la température du sol dans le temps.\nCette information permet :\n• de savoir quelles plantes sont réellement cultivables à un instant donné,\n• d’ajuster les semis aux conditions réelles plutôt qu’à un calendrier théorique.\nMétéo en temps réel sur le tableau de bord\nUn module central en forme d’ovoïde affiche en un coup d’œil :\n• l’état du ciel,\n• le jour ou la nuit,\n• la phase et la position de la lune pour la commune sélectionnée.\nNavigation dans le temps\nEn faisant glisser le doigt de gauche à droite sur l’ovoïde, vous parcourez les prévisions heure par heure, jusqu’à plus de 12 heures à l’avance.\nLa température et les précipitations s’ajustent dynamiquement pendant le geste.\n\n10 — Recommandations\nSowing peut proposer des recommandations adaptées à votre situation.\nElles s’appuient sur :\n• la saison,\n• la météo,\n• l’état de vos plantations.\nChaque recommandation précise :\n• quoi faire,\n• quand agir,\n• pourquoi l’action est suggérée.\n\n11 — Export et partage\nExport PDF — calendrier et tâches\nLes tâches du calendrier peuvent être exportées en PDF.\nCela permet de :\n• partager une information claire,\n• transmettre une intervention prévue,\n• conserver une trace lisible et datée.\nExport Excel — récoltes et statistiques\nLes données de récolte peuvent être exportées au format Excel afin de :\n• analyser les résultats,\n• produire des bilans,\n• suivre l’évolution dans le temps.\nPartage des documents\nLes documents générés peuvent être partagés via les applications disponibles sur votre appareil (messagerie, stockage, transfert vers un ordinateur, etc.).\n\n12 — Sauvegarde et bonnes pratiques\nLes données sont stockées localement sur votre appareil.\nBonnes pratiques recommandées :\n• effectuer une sauvegarde avant une mise à jour importante,\n• exporter régulièrement vos données,\n• maintenir l’application et l’appareil à jour.\n\n13 — Paramètres\nLe menu Paramètres permet d’adapter Sowing à vos usages.\nVous pouvez notamment :\n• choisir la langue,\n• sélectionner votre commune,\n• accéder au catalogue de plantes,\n• personnaliser le tableau de bord.\nPersonnalisation du tableau de bord\nIl est possible de :\n• repositionner chaque module,\n• ajuster l’espace visuel,\n• changer l’image de fond,\n• importer votre propre image (fonctionnalité à venir).\nInformations légales\nDepuis les paramètres, vous pouvez consulter :\n• le guide d’utilisation,\n• la politique de confidentialité,\n• les conditions d’utilisation.\n\n14 — Questions fréquentes\nLes zones tactiles ne sont pas bien alignées\nSelon le téléphone ou les réglages d’affichage, certaines zones peuvent sembler décalées.\nUn mode de calibration organique permet de :\n• visualiser les zones tactiles,\n• les repositionner par glissement,\n• enregistrer la configuration pour votre appareil.\nPuis‑je utiliser Sowing sans connexion ?\nOui. Sowing fonctionne hors ligne pour la gestion des jardins, plantations, tâches et historique.\nUne connexion est uniquement utilisée :\n• pour la récupération des données météo,\n• lors de l’export ou du partage de documents.\nAucune autre donnée n’est transmise.\n\n15 — Remarque finale\nSowing est conçu comme un compagnon de jardinage : simple, vivant et évolutif.\nPrenez le temps d’observer, de noter et de faire confiance à votre expérience autant qu’à l’outil.';

  @override
  String get privacy_policy_text =>
      'Sowing respecte pleinement votre vie privée.\n\n• Toutes les données sont stockées localement sur votre appareil\n• Aucune donnée personnelle n’est transmise à des tiers\n• Aucune information n’est stockée sur un serveur externe\n\nL’application fonctionne entièrement hors ligne. Une connexion Internet est uniquement utilisée pour récupérer les données météorologiques ou lors des exports.';

  @override
  String get terms_text =>
      'En utilisant Sowing, vous acceptez :\n\n• D\'utiliser l\'application de manière responsable\n• De ne pas tenter de contourner ses limitations\n• De respecter les droits de propriété intellectuelle\n• D\'utiliser uniquement vos propres données\n\nCette application est fournie en l\'état, sans garantie.\n\nL’équipe Sowing reste à l’écoute pour toute amélioration ou évolution future.';

  @override
  String get calibration_auto_apply =>
      'Appliquer automatiquement pour cet appareil';

  @override
  String get calibration_calibrate_now => 'Calibrer maintenant';

  @override
  String get calibration_save_profile =>
      'Sauvegarder calibration actuelle comme profil';

  @override
  String get calibration_export_profile => 'Exporter profil (copie JSON)';

  @override
  String get calibration_import_profile =>
      'Importer profil depuis presse-papiers';

  @override
  String get calibration_reset_profile =>
      'Réinitialiser profil pour cet appareil';

  @override
  String get calibration_refresh_profile => 'Actualiser aperçu profil';

  @override
  String calibration_key_device(String key) {
    return 'Clé appareil: $key';
  }

  @override
  String get calibration_no_profile =>
      'Aucun profil enregistré pour cet appareil.';

  @override
  String get calibration_image_settings_title =>
      'Réglages Image de Fond (Persistant)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image => 'Reset Image Defaults';

  @override
  String get calibration_dialog_confirm_title => 'Confirmer';

  @override
  String get calibration_dialog_delete_profile =>
      'Supprimer le profil de calibration pour cet appareil ?';

  @override
  String get calibration_action_delete => 'Supprimer';

  @override
  String get calibration_snack_no_profile =>
      'Aucun profil trouvé pour cet appareil.';

  @override
  String get calibration_snack_profile_copied =>
      'Profil copié dans le presse-papiers.';

  @override
  String get calibration_snack_clipboard_empty => 'Presse-papiers vide.';

  @override
  String get calibration_snack_profile_imported =>
      'Profil importé et sauvegardé pour cet appareil.';

  @override
  String calibration_snack_import_error(String error) {
    return 'Erreur import JSON: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Profil supprimé pour cet appareil.';

  @override
  String get calibration_snack_no_calibration =>
      'Aucune calibration enregistrée. Calibrez d\'abord depuis le dashboard.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Calibration actuelle sauvegardée comme profil pour cet appareil.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Erreur lors de la sauvegarde: $error';
  }

  @override
  String get calibration_overlay_saved => 'Calibration sauvegardée';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Erreur sauvegarde calibration: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Glissez pour déplacer, pincez pour zoomer l\'image de fond.';

  @override
  String get calibration_instruction_sky =>
      'Ajustez l\'ovoïde jour/nuit (centre, taille, rotation).';

  @override
  String get calibration_instruction_modules =>
      'Déplacez les modules (bulles) à l\'emplacement souhaité.';

  @override
  String get calibration_instruction_none =>
      'Sélectionnez un outil pour commencer.';

  @override
  String get calibration_tool_image => 'Image';

  @override
  String get calibration_tool_sky => 'Ciel';

  @override
  String get calibration_tool_modules => 'Modules';

  @override
  String get calibration_action_validate_exit => 'Valider & Quitter';

  @override
  String get dashboard_weather_stats => 'Météo détaillée';

  @override
  String get dashboard_soil_temp => 'Temp. Sol';

  @override
  String get dashboard_air_temp => 'Température';

  @override
  String get dashboard_statistics => 'Statistiques';

  @override
  String get dashboard_calendar => 'Calendrier';

  @override
  String get dashboard_activities => 'Activités';

  @override
  String get dashboard_weather => 'Météo';

  @override
  String get dashboard_settings => 'Paramètres';

  @override
  String dashboard_garden_n(int number) {
    return 'Jardin $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Jardin \"$name\" créé avec succès';
  }

  @override
  String get dashboard_garden_create_error =>
      'Erreur lors de la création du jardin.';

  @override
  String get calendar_title => 'Calendrier de culture';

  @override
  String get calendar_refreshed => 'Calendrier actualisé';

  @override
  String get calendar_new_task_tooltip => 'Nouvelle Tâche';

  @override
  String get calendar_task_saved_title => 'Tâche enregistrée';

  @override
  String get calendar_ask_export_pdf =>
      'Voulez-vous l\'envoyer à quelqu\'un en PDF ?';

  @override
  String get calendar_task_modified => 'Tâche modifiée';

  @override
  String get calendar_delete_confirm_title => 'Supprimer la tâche ?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" sera supprimée.';
  }

  @override
  String get calendar_task_deleted => 'Tâche supprimée';

  @override
  String calendar_restore_error(Object error) {
    return 'Erreur restauration : $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Erreur suppression : $error';
  }

  @override
  String get calendar_action_assign => 'Envoyer / Attribuer à...';

  @override
  String get calendar_assign_title => 'Attribuer / Envoyer';

  @override
  String get calendar_assign_hint => 'Saisir le nom ou email du destinataire';

  @override
  String get calendar_assign_field => 'Nom ou Email';

  @override
  String calendar_task_assigned(String name) {
    return 'Tâche attribuée à $name';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Erreur attribution : $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'Erreur export PDF: $error';
  }

  @override
  String get calendar_previous_month => 'Mois précédent';

  @override
  String get calendar_next_month => 'Mois suivant';

  @override
  String get calendar_limit_reached => 'Limite atteinte';

  @override
  String get calendar_drag_instruction => 'Glisser pour naviguer';

  @override
  String get common_refresh => 'Actualiser';

  @override
  String get common_yes => 'Oui';

  @override
  String get common_no => 'Non';

  @override
  String get common_delete => 'Supprimer';

  @override
  String get common_edit => 'Modifier';

  @override
  String get common_undo => 'Annuler';

  @override
  String common_error_prefix(Object error) {
    return 'Erreur: $error';
  }

  @override
  String get common_retry => 'Réessayer';

  @override
  String get common_general_error => 'Une erreur est survenue';

  @override
  String get calendar_no_events => 'Aucun événement ce jour';

  @override
  String calendar_events_of(String date) {
    return 'Événements du $date';
  }

  @override
  String get calendar_section_plantings => 'Plantations';

  @override
  String get calendar_section_harvests => 'Récoltes prévues';

  @override
  String get calendar_section_tasks => 'Tâches planifiées';

  @override
  String get calendar_filter_tasks => 'Tâches';

  @override
  String get calendar_filter_maintenance => 'Entretien';

  @override
  String get calendar_filter_harvests => 'Récoltes';

  @override
  String get calendar_filter_urgent => 'Urgences';

  @override
  String get common_error => 'Erreur';

  @override
  String get task_editor_title_new => 'Nouvelle Tâche';

  @override
  String get task_editor_title_edit => 'Modifier Tâche';

  @override
  String get task_editor_title_field => 'Titre *';

  @override
  String get task_editor_error_title_required => 'Requis';

  @override
  String get task_editor_garden_all => 'Tous les jardins';

  @override
  String get task_editor_zone_label => 'Zone (Parcelle)';

  @override
  String get task_editor_zone_none => 'Aucune zone spécifique';

  @override
  String get task_editor_zone_empty => 'Aucune parcelle pour ce jardin';

  @override
  String get task_editor_description_label => 'Description';

  @override
  String get task_editor_date_label => 'Date de début';

  @override
  String get task_editor_time_label => 'Heure';

  @override
  String get task_editor_duration_label => 'Durée estimée';

  @override
  String get task_editor_duration_other => 'Autre';

  @override
  String get task_editor_type_label => 'Type de tâche';

  @override
  String get task_editor_priority_label => 'Priorité';

  @override
  String get task_editor_urgent_label => 'Urgent';

  @override
  String get task_editor_option_none => 'Aucune (Sauvegarde uniquement)';

  @override
  String get task_editor_option_share => 'Partager (texte)';

  @override
  String get task_editor_option_pdf => 'Exporter — PDF';

  @override
  String get task_editor_option_docx => 'Exporter — Word (.docx)';

  @override
  String get task_editor_export_label => 'Sortie / Partage';

  @override
  String get task_editor_photo_placeholder =>
      'Ajouter une photo (Bientôt disponible)';

  @override
  String get task_editor_action_create => 'Créer';

  @override
  String get task_editor_action_save => 'Enregistrer';

  @override
  String get task_editor_action_cancel => 'Annuler';

  @override
  String get task_editor_assignee_label => 'Assigné à';

  @override
  String task_editor_assignee_add(String name) {
    return 'Ajouter \"$name\" aux favoris';
  }

  @override
  String get task_editor_assignee_none => 'Aucun résultat.';

  @override
  String get task_editor_recurrence_label => 'Récurrence';

  @override
  String get task_editor_recurrence_none => 'Aucune';

  @override
  String get task_editor_recurrence_interval => 'Tous les X jours';

  @override
  String get task_editor_recurrence_weekly => 'Hebdomadaire (Jours)';

  @override
  String get task_editor_recurrence_monthly => 'Mensuel (même jour)';

  @override
  String get task_editor_recurrence_repeat_label => 'Répéter tous les ';

  @override
  String get task_editor_recurrence_days_suffix => ' j';

  @override
  String get task_kind_generic => 'Générique';

  @override
  String get task_kind_repair => 'Réparation 🛠️';

  @override
  String get task_kind_buy => 'Achat 🛒';

  @override
  String get task_kind_clean => 'Nettoyage 🧹';

  @override
  String get task_kind_watering => 'Arrosage 💧';

  @override
  String get task_kind_seeding => 'Semis 🌱';

  @override
  String get task_kind_pruning => 'Taille ✂️';

  @override
  String get task_kind_weeding => 'Désherbage 🌿';

  @override
  String get task_kind_amendment => 'Amendement 🪵';

  @override
  String get task_kind_treatment => 'Traitement 🧪';

  @override
  String get task_kind_harvest => 'Récolte 🧺';

  @override
  String get task_kind_winter_protection => 'Hivernage ❄️';
}
