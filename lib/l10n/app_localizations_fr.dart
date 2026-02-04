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
  String get garden_creation_dialog_title => 'Créez votre premier jardin';

  @override
  String get garden_creation_dialog_description =>
      'Donnez un nom à votre espace de permaculture pour commencer.';

  @override
  String get garden_creation_name_label => 'Nom du jardin';

  @override
  String get garden_creation_name_hint => 'Ex: Mon Potager';

  @override
  String get garden_creation_name_required => 'Le nom est requis';

  @override
  String get garden_creation_create_button => 'Créer';

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
  String get plant_catalog_search_hint => 'Rechercher une plante...';

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
  String get common_save => 'Enregistrer';

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
  String get garden_management_create_title => 'Créer un jardin';

  @override
  String get garden_management_edit_title => 'Modifier le jardin';

  @override
  String get garden_management_name_label => 'Nom du jardin';

  @override
  String get garden_management_desc_label => 'Description';

  @override
  String get garden_management_image_label => 'Image du jardin (optionnel)';

  @override
  String get garden_management_image_url_label => 'URL de l\'image';

  @override
  String get garden_management_image_preview_error =>
      'Impossible de charger l\'image';

  @override
  String get garden_management_create_submit => 'Créer le jardin';

  @override
  String get garden_management_create_submitting => 'Création...';

  @override
  String get garden_management_created_success => 'Jardin créé avec succès';

  @override
  String get garden_management_create_error => 'Échec de la création du jardin';

  @override
  String get garden_management_delete_confirm_title => 'Supprimer le jardin';

  @override
  String get garden_management_delete_confirm_body =>
      'Êtes-vous sûr de vouloir supprimer ce jardin ? Cette action supprimera également toutes les parcelles et plantations associées. Cette action est irréversible.';

  @override
  String get garden_management_delete_success => 'Jardin supprimé avec succès';

  @override
  String get garden_management_archived_tag => 'Jardin archivé';

  @override
  String get garden_management_beds_title => 'Parcelles';

  @override
  String get garden_management_no_beds_title => 'Aucune parcelle';

  @override
  String get garden_management_no_beds_desc =>
      'Créez des parcelles pour organiser vos plantations';

  @override
  String get garden_management_add_bed_label => 'Créer une parcelle';

  @override
  String get garden_management_stats_beds => 'Parcelles';

  @override
  String get garden_management_stats_area => 'Surface totale';

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
      'Souhaitez-vous envoyer la fiche tâche à quelqu\'un ?';

  @override
  String get action_no_thanks => 'Non merci';

  @override
  String get action_pdf => 'PDF';

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
  String get calendar_personal_notification => 'Notification';

  @override
  String get calendar_personal_notification_on => 'Activée';

  @override
  String get calendar_personal_notification_off => 'Désactivée';

  @override
  String get calendar_notify_before => 'Prévenir avant';

  @override
  String get minutes => 'minutes';

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
  String get common_attention => 'Attention';

  @override
  String get limit_beds_reached_message =>
      'Pour garantir une fluidité parfaite, la limite est fixée à 100 parcelles par jardin. Vous avez atteint ce seuil de confort.';

  @override
  String get limit_plantings_reached_message =>
      'Limite de 6 plantes atteinte.\nVeuillez retirer une plante de cette parcelle pour en ajouter une nouvelle.';

  @override
  String get limit_gardens_reached_message =>
      'Limite de 5 jardins actifs atteinte.\nVeuillez archiver ou supprimer un jardin pour en créer un nouveau.';

  @override
  String get calendar_filter_maintenance => 'Entretien';

  @override
  String get calendar_filter_harvests => 'Récoltes';

  @override
  String get calendar_filter_urgent => 'Urgences';

  @override
  String get common_general_error => 'Une erreur est survenue';

  @override
  String get common_error => 'Erreur';

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
  String get settings_backup_compatible_zip => 'Compatible ZIP';

  @override
  String get backup_share_subject => 'Sauvegarde PermaCalendar';

  @override
  String get task_editor_title_new => 'Nouvelle Tâche';

  @override
  String get task_editor_title_edit => 'Modifier Tâche';

  @override
  String get task_editor_title_field => 'Titre *';

  @override
  String get activity_screen_title => 'Activités & Historique';

  @override
  String activity_tab_recent_garden(String gardenName) {
    return 'Récentes ($gardenName)';
  }

  @override
  String get activity_tab_recent_global => 'Récentes (Global)';

  @override
  String get activity_tab_history => 'Historique';

  @override
  String get activity_history_section_title => 'Historique — ';

  @override
  String get activity_history_empty =>
      'Aucun jardin sélectionné.\nPour consulter l’historique d’un jardin, sélectionnez-le par un appui long depuis le tableau de bord.';

  @override
  String get activity_empty_title => 'Aucune activité trouvée';

  @override
  String get activity_empty_subtitle =>
      'Les activités de jardinage apparaîtront ici';

  @override
  String get activity_error_loading => 'Erreur lors du chargement';

  @override
  String get activity_priority_important => 'Important';

  @override
  String get activity_priority_normal => 'Normal';

  @override
  String get activity_time_just_now => 'À l\'instant';

  @override
  String activity_time_minutes_ago(int minutes) {
    return 'Il y a $minutes min';
  }

  @override
  String activity_time_hours_ago(int hours) {
    return 'Il y a $hours h';
  }

  @override
  String activity_time_days_ago(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String activity_metadata_garden(String name) {
    return 'Jardin: $name';
  }

  @override
  String activity_metadata_bed(String name) {
    return 'Parcelle: $name';
  }

  @override
  String activity_metadata_plant(String name) {
    return 'Plante: $name';
  }

  @override
  String activity_metadata_quantity(String quantity) {
    return 'Quantité: $quantity';
  }

  @override
  String activity_metadata_date(String date) {
    return 'Date: $date';
  }

  @override
  String activity_metadata_maintenance(String type) {
    return 'Maintenance: $type';
  }

  @override
  String activity_metadata_weather(String weather) {
    return 'Météo: $weather';
  }

  @override
  String get task_editor_error_title_required => 'Requis';

  @override
  String get history_hint_title => 'Pour consulter l’historique d’un jardin';

  @override
  String get history_hint_body =>
      'Sélectionnez-le par un appui long depuis le tableau de bord.';

  @override
  String get history_hint_action => 'Aller au tableau de bord';

  @override
  String activity_desc_garden_created(String name) {
    return 'Jardin \"$name\" créé';
  }

  @override
  String activity_desc_bed_created(String name) {
    return 'Parcelle \"$name\" créée';
  }

  @override
  String activity_desc_planting_created(String name) {
    return 'Plantation de \"$name\" ajoutée';
  }

  @override
  String activity_desc_germination(String name) {
    return 'Germination de \"$name\" confirmée';
  }

  @override
  String activity_desc_harvest(String name) {
    return 'Récolte de \"$name\" enregistrée';
  }

  @override
  String activity_desc_maintenance(String type) {
    return 'Maintenance : $type';
  }

  @override
  String activity_desc_garden_deleted(String name) {
    return 'Jardin \"$name\" supprimé';
  }

  @override
  String activity_desc_bed_deleted(String name) {
    return 'Parcelle \"$name\" supprimée';
  }

  @override
  String activity_desc_planting_deleted(String name) {
    return 'Plantation de \"$name\" supprimée';
  }

  @override
  String activity_desc_garden_updated(String name) {
    return 'Jardin \"$name\" mis à jour';
  }

  @override
  String activity_desc_bed_updated(String name) {
    return 'Parcelle \"$name\" mise à jour';
  }

  @override
  String activity_desc_planting_updated(String name) {
    return 'Plantation de \"$name\" mise à jour';
  }

  @override
  String get planting_steps_title => 'Pas-à-pas';

  @override
  String get planting_steps_add_button => 'Ajouter';

  @override
  String get planting_steps_see_less => 'Voir moins';

  @override
  String get planting_steps_see_all => 'Voir tout';

  @override
  String get planting_steps_empty => 'Aucune étape recommandée';

  @override
  String planting_steps_more(int count) {
    return '+ $count autres étapes';
  }

  @override
  String get planting_steps_prediction_badge => 'Prédiction';

  @override
  String planting_steps_date_prefix(String date) {
    return 'Le $date';
  }

  @override
  String get planting_steps_done => 'Fait';

  @override
  String get planting_steps_mark_done => 'Marquer fait';

  @override
  String get planting_steps_dialog_title => 'Ajouter étape';

  @override
  String get planting_steps_dialog_hint => 'Ex: Paillage léger';

  @override
  String get planting_steps_dialog_add => 'Ajouter';

  @override
  String get planting_status_sown => 'Semé';

  @override
  String get planting_status_planted => 'Planté';

  @override
  String get planting_status_growing => 'En croissance';

  @override
  String get planting_status_ready => 'Prêt à récolter';

  @override
  String get planting_status_harvested => 'Récolté';

  @override
  String get planting_status_failed => 'Échoué';

  @override
  String planting_card_sown_date(String date) {
    return 'Semé le $date';
  }

  @override
  String planting_card_planted_date(String date) {
    return 'Planté le $date';
  }

  @override
  String planting_card_harvest_estimate(String date) {
    return 'Récolte estimée : $date';
  }

  @override
  String get planting_info_title => 'Informations botaniques';

  @override
  String get planting_info_tips_title => 'Conseils de culture';

  @override
  String get planting_info_maturity => 'Maturité';

  @override
  String planting_info_days(Object days) {
    return '$days jours';
  }

  @override
  String get planting_info_spacing => 'Espacement';

  @override
  String planting_info_cm(Object cm) {
    return '$cm cm';
  }

  @override
  String get planting_info_depth => 'Profondeur';

  @override
  String get planting_info_exposure => 'Exposition';

  @override
  String get planting_info_water => 'Arrosage';

  @override
  String get planting_info_season => 'Saison plantation';

  @override
  String get planting_info_scientific_name_none =>
      'Nom scientifique non disponible';

  @override
  String get planting_info_culture_title => 'Informations de culture';

  @override
  String get planting_info_germination => 'Temps de germination';

  @override
  String get planting_info_harvest_time => 'Temps de récolte';

  @override
  String get planting_info_none => 'Non spécifié';

  @override
  String get planting_tips_none => 'Aucun conseil disponible';

  @override
  String get planting_history_title => 'Historique des actions';

  @override
  String get planting_history_action_planting => 'Plantation';

  @override
  String get planting_history_todo =>
      'L\'historique détaillé sera disponible prochainement';

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
  String get soil_temp_title => 'Température du Sol';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Erreur chart: $error';
  }

  @override
  String get soil_temp_about_title => 'À propos de la température du sol';

  @override
  String get soil_temp_about_content =>
      'La température du sol affichée ici est estimée par l’application à partir de données climatiques et saisonnières, selon la formule suivante :\n\nCette estimation permet de donner une tendance réaliste de la température du sol lorsque aucune mesure directe n’est disponible.';

  @override
  String get soil_temp_formula_label => 'Formule de calcul utilisée :';

  @override
  String get soil_temp_formula_content =>
      'T_sol(n+1) = T_sol(n) + α × (T_air(n) − T_sol(n))\n\nAvec :\n• α : coefficient de diffusion thermique (valeur par défaut 0,15 — plage recommandée 0,10–0,20).\n• T_sol(n) : température du sol actuelle (°C).\n• T_air(n) : température de l’air actuelle (°C).\n\nLa formule est implémentée dans le code de l’application (ComputeSoilTempNextDayUsecase).';

  @override
  String get soil_temp_current_label => 'Température actuelle';

  @override
  String get soil_temp_action_measure => 'Modifier / Mesurer';

  @override
  String get soil_temp_measure_hint =>
      'Vous pouvez renseigner manuellement la température du sol dans l’onglet “Modifier / Mesurer”.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Erreur catalogue: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Erreur conseils: $error';
  }

  @override
  String get soil_temp_db_empty => 'Base de données de plantes vide.';

  @override
  String get soil_temp_reload_plants => 'Recharger les plantes';

  @override
  String get soil_temp_no_advice =>
      'Aucune plante avec données de germination trouvée.';

  @override
  String get soil_advice_status_ideal => 'Optimal';

  @override
  String get soil_advice_status_sow_now => 'Semer';

  @override
  String get soil_advice_status_sow_soon => 'Bientôt';

  @override
  String get soil_advice_status_wait => 'Attendre';

  @override
  String get soil_sheet_title => 'Température du sol';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Dernière mesure : $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'Nouvelle mesure (Ancrage)';

  @override
  String get soil_sheet_input_label => 'Température (°C)';

  @override
  String get soil_sheet_input_error => 'Valeur invalide (-10.0 à 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Annuler';

  @override
  String get soil_sheet_action_save => 'Sauvegarder';

  @override
  String get soil_sheet_snack_invalid => 'Valeur invalide. Entrez -10.0 à 45.0';

  @override
  String get soil_sheet_snack_success => 'Mesure enregistrée comme ancrage';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Erreur sauvegarde : $error';
  }

  @override
  String get weather_screen_title => 'Météo';

  @override
  String get weather_provider_credit => 'Données fournies par Open-Meteo';

  @override
  String get weather_error_loading => 'Impossible de charger la météo';

  @override
  String get weather_action_retry => 'Réessayer';

  @override
  String get weather_header_next_24h => 'PROCHAINES 24H';

  @override
  String get weather_header_daily_summary => 'RÉSUMÉ JOUR';

  @override
  String get weather_header_precipitations => 'PRÉCIPITATIONS (24h)';

  @override
  String get weather_label_wind => 'VENT';

  @override
  String get weather_label_pressure => 'PRESSION';

  @override
  String get weather_label_sun => 'SOLEIL';

  @override
  String get weather_label_astro => 'ASTRES';

  @override
  String get weather_data_speed => 'Vitesse';

  @override
  String get weather_data_gusts => 'Rafales';

  @override
  String get weather_data_sunrise => 'Lever';

  @override
  String get weather_data_sunset => 'Coucher';

  @override
  String get weather_data_rain => 'Pluie';

  @override
  String get weather_data_max => 'Max';

  @override
  String get weather_data_min => 'Min';

  @override
  String get weather_data_wind_max => 'Vent Max';

  @override
  String get weather_pressure_high => 'Haute';

  @override
  String get weather_pressure_low => 'Basse';

  @override
  String get weather_today_label => 'Aujourd\'hui';

  @override
  String get moon_phase_new => 'Nouvelle Lune';

  @override
  String get moon_phase_waxing_crescent => 'Premier Croissant';

  @override
  String get moon_phase_first_quarter => 'Premier Quartier';

  @override
  String get moon_phase_waxing_gibbous => 'Gibbeuse Croissante';

  @override
  String get moon_phase_full => 'Pleine Lune';

  @override
  String get moon_phase_waning_gibbous => 'Gibbeuse Décroissante';

  @override
  String get moon_phase_last_quarter => 'Dernier Quartier';

  @override
  String get moon_phase_waning_crescent => 'Dernier Croissant';

  @override
  String get wmo_code_0 => 'Ciel clair';

  @override
  String get wmo_code_1 => 'Principalement clair';

  @override
  String get wmo_code_2 => 'Partiellement nuageux';

  @override
  String get wmo_code_3 => 'Couvert';

  @override
  String get wmo_code_45 => 'Brouillard';

  @override
  String get wmo_code_48 => 'Brouillard givrant';

  @override
  String get wmo_code_51 => 'Bruine légère';

  @override
  String get wmo_code_53 => 'Bruine modérée';

  @override
  String get wmo_code_55 => 'Bruine dense';

  @override
  String get wmo_code_61 => 'Pluie légère';

  @override
  String get wmo_code_63 => 'Pluie modérée';

  @override
  String get wmo_code_65 => 'Pluie forte';

  @override
  String get wmo_code_66 => 'Pluie verglaçante légère';

  @override
  String get wmo_code_67 => 'Pluie verglaçante forte';

  @override
  String get wmo_code_71 => 'Chute de neige légère';

  @override
  String get wmo_code_73 => 'Chute de neige modérée';

  @override
  String get wmo_code_75 => 'Chute de neige forte';

  @override
  String get wmo_code_77 => 'Grains de neige';

  @override
  String get wmo_code_80 => 'Averses légères';

  @override
  String get wmo_code_81 => 'Averses modérées';

  @override
  String get wmo_code_82 => 'Averses violentes';

  @override
  String get wmo_code_85 => 'Averses de neige légères';

  @override
  String get wmo_code_86 => 'Averses de neige fortes';

  @override
  String get wmo_code_95 => 'Orage';

  @override
  String get wmo_code_96 => 'Orage avec grêle légère';

  @override
  String get wmo_code_99 => 'Orage avec grêle forte';

  @override
  String get wmo_code_unknown => 'Conditions variables';

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

  @override
  String get garden_detail_title_error => 'Erreur';

  @override
  String get garden_detail_subtitle_not_found =>
      'Le jardin demandé n\'existe pas ou a été supprimé.';

  @override
  String garden_detail_subtitle_error_beds(Object error) {
    return 'Impossible de charger les planches: $error';
  }

  @override
  String get garden_action_edit => 'Modifier';

  @override
  String get garden_action_archive => 'Archiver';

  @override
  String get garden_action_unarchive => 'Désarchiver';

  @override
  String get garden_action_delete => 'Supprimer';

  @override
  String garden_created_at(Object date) {
    return 'Créé le $date';
  }

  @override
  String get garden_bed_delete_confirm_title => 'Supprimer la parcelle';

  @override
  String garden_bed_delete_confirm_body(Object bedName) {
    return 'Êtes-vous sûr de vouloir supprimer \"$bedName\" ? Cette action est irréversible.';
  }

  @override
  String get garden_bed_deleted_snack => 'Parcelle supprimée';

  @override
  String garden_bed_delete_error(Object error) {
    return 'Erreur lors de la suppression: $error';
  }

  @override
  String get common_back => 'Retour';

  @override
  String get garden_action_disable => 'Désactiver';

  @override
  String get garden_action_enable => 'Activer';

  @override
  String get garden_action_modify => 'Modifier';

  @override
  String get bed_create_title_new => 'Nouvelle parcelle';

  @override
  String get bed_create_title_edit => 'Modifier la parcelle';

  @override
  String get bed_form_name_label => 'Nom de la parcelle *';

  @override
  String get bed_form_name_hint => 'Ex: Parcelle Nord, Planche 1';

  @override
  String get bed_form_size_label => 'Surface (m²) *';

  @override
  String get bed_form_size_hint => 'Ex: 10.5';

  @override
  String get bed_form_desc_label => 'Description';

  @override
  String get bed_form_desc_hint => 'Description...';

  @override
  String get bed_form_submit_create => 'Créer';

  @override
  String get bed_form_submit_edit => 'Modifier';

  @override
  String get bed_snack_created => 'Parcelle créée avec succès';

  @override
  String get bed_snack_updated => 'Parcelle modifiée avec succès';

  @override
  String get bed_form_error_name_required => 'Le nom est obligatoire';

  @override
  String get bed_form_error_name_length =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get bed_form_error_size_required => 'La surface est obligatoire';

  @override
  String get bed_form_error_size_invalid =>
      'Veuillez entrer une surface valide';

  @override
  String get bed_form_error_size_max =>
      'La surface ne peut pas dépasser 1000 m²';

  @override
  String get status_sown => 'Semé';

  @override
  String get status_planted => 'Planté';

  @override
  String get status_growing => 'En croissance';

  @override
  String get status_ready_to_harvest => 'Prêt à récolter';

  @override
  String get status_harvested => 'Récolté';

  @override
  String get status_failed => 'Échoué';

  @override
  String bed_card_sown_on(Object date) {
    return 'Semé le $date';
  }

  @override
  String get bed_card_harvest_start => 'vers début récolte';

  @override
  String get bed_action_harvest => 'Récolter';

  @override
  String get lifecycle_error_title => 'Erreur lors du calcul du cycle de vie';

  @override
  String get lifecycle_error_prefix => 'Erreur : ';

  @override
  String get lifecycle_cycle_completed => 'du cycle complété';

  @override
  String get lifecycle_stage_germination => 'Germination';

  @override
  String get lifecycle_stage_growth => 'Croissance';

  @override
  String get lifecycle_stage_fruiting => 'Fructification';

  @override
  String get lifecycle_stage_harvest => 'Récolte';

  @override
  String get lifecycle_stage_unknown => 'Inconnu';

  @override
  String get lifecycle_harvest_expected => 'Récolte prévue';

  @override
  String lifecycle_in_days(Object days) {
    return 'Dans $days jours';
  }

  @override
  String get lifecycle_passed => 'Passée';

  @override
  String get lifecycle_now => 'Maintenant !';

  @override
  String get lifecycle_next_action => 'Prochaine action';

  @override
  String get lifecycle_update => 'Mettre à jour le cycle';

  @override
  String lifecycle_days_ago(Object days) {
    return 'Il y a $days jours';
  }

  @override
  String get planting_detail_title => 'Détails de la plantation';

  @override
  String get companion_beneficial => 'Plantes amies';

  @override
  String get companion_avoid => 'Plantes à éviter';

  @override
  String get common_close => 'Fermer';

  @override
  String get bed_detail_surface => 'Surface';

  @override
  String get bed_detail_details => 'Détails';

  @override
  String get bed_detail_notes => 'Notes';

  @override
  String get bed_detail_current_plantings => 'Plantations actuelles';

  @override
  String get bed_detail_no_plantings_title => 'Aucune plantation';

  @override
  String get bed_detail_no_plantings_desc =>
      'Cette parcelle n\'a pas encore de plantations.';

  @override
  String get bed_detail_add_planting => 'Ajouter une plantation';

  @override
  String get bed_delete_planting_confirm_title => 'Supprimer la plantation ?';

  @override
  String get bed_delete_planting_confirm_body =>
      'Cette action est irréversible. Voulez-vous vraiment supprimer cette plantation ?';

  @override
  String harvest_title(Object plantName) {
    return 'Récolte :$plantName';
  }

  @override
  String get harvest_weight_label => 'Poids récolté (kg) *';

  @override
  String harvest_price_label(String currencyUnit) {
    return 'Prix estimé ($currencyUnit)';
  }

  @override
  String get harvest_price_helper =>
      'Sera mémorisé pour les prochaines récoltes de cette plante';

  @override
  String get harvest_notes_label => 'Notes / Qualité';

  @override
  String get harvest_action_save => 'Enregistrer';

  @override
  String get harvest_snack_saved => 'Récolte enregistrée';

  @override
  String get harvest_snack_error => 'Erreur lors de l\'enregistrement';

  @override
  String get harvest_form_error_required => 'Requis';

  @override
  String get harvest_form_error_positive => 'Invalide (> 0)';

  @override
  String get harvest_form_error_positive_or_zero => 'Invalide (>= 0)';

  @override
  String get info_exposure_full_sun => 'Plein soleil';

  @override
  String get info_exposure_partial_sun => 'Mi-ombre';

  @override
  String get info_exposure_shade => 'Ombre';

  @override
  String get info_water_low => 'Faible';

  @override
  String get info_water_medium => 'Moyen';

  @override
  String get info_water_high => 'Élevé';

  @override
  String get info_water_moderate => 'Modéré';

  @override
  String get info_season_spring => 'Printemps';

  @override
  String get info_season_summer => 'Été';

  @override
  String get info_season_autumn => 'Automne';

  @override
  String get info_season_winter => 'Hiver';

  @override
  String get info_season_all => 'Toute saison';

  @override
  String get common_duplicate => 'Dupliquer';

  @override
  String get planting_delete_title => 'Supprimer la plantation';

  @override
  String get planting_delete_confirm_body =>
      'Êtes-vous sûr de vouloir supprimer cette plantation ? Cette action est irréversible.';

  @override
  String get planting_creation_title => 'Nouvelle culture';

  @override
  String get planting_creation_title_edit => 'Modifier la culture';

  @override
  String get planting_quantity_seeds => 'Nombre de graines';

  @override
  String get planting_quantity_plants => 'Nombre de plants';

  @override
  String get planting_quantity_required => 'La quantité est requise';

  @override
  String get planting_quantity_positive =>
      'La quantité doit être un nombre positif';

  @override
  String planting_plant_selection_label(Object plantName) {
    return 'Plante : $plantName';
  }

  @override
  String get planting_no_plant_selected => 'Aucune plante sélectionnée';

  @override
  String get planting_custom_plant_title => 'Plante personnalisée';

  @override
  String get planting_plant_name_label => 'Nom de la plante';

  @override
  String get planting_plant_name_hint => 'Ex: Tomate cerise';

  @override
  String get planting_plant_name_required => 'Le nom de la plante est requis';

  @override
  String get planting_notes_label => 'Notes (optionnel)';

  @override
  String get planting_notes_hint => 'Informations supplémentaires...';

  @override
  String get planting_tips_title => 'Conseils';

  @override
  String get planting_tips_catalog =>
      '• Utilisez le catalogue pour sélectionner une plante.';

  @override
  String get planting_tips_type =>
      '• Choisissez \"Semé\" pour les graines, \"Planté\" pour les plants.';

  @override
  String get planting_tips_notes =>
      '• Ajoutez des notes pour suivre les conditions spéciales.';

  @override
  String get planting_date_future_error =>
      'La date de plantation ne peut pas être dans le futur';

  @override
  String get planting_success_create => 'Culture créée avec succès';

  @override
  String get planting_success_update => 'Culture modifiée avec succès';

  @override
  String get stats_screen_title => 'Statistiques';

  @override
  String get stats_screen_subtitle =>
      'Analysez en temps réel et exportez vos données.';

  @override
  String get kpi_alignment_title => 'Alignement au Vivant';

  @override
  String get kpi_alignment_description =>
      'Cet outil évalue à quel point tu réalises tes semis, plantations et récoltes dans la fenêtre idéale recommandée par l\'Agenda Intelligent.';

  @override
  String get kpi_alignment_cta =>
      'Commence à planter et récolter pour voir ton alignement !';

  @override
  String get kpi_alignment_aligned => 'aligné';

  @override
  String get kpi_alignment_total => 'Total';

  @override
  String get kpi_alignment_aligned_actions => 'Alignées';

  @override
  String get kpi_alignment_misaligned_actions => 'Décalées';

  @override
  String get kpi_alignment_calculating => 'Calcul de l\'alignement...';

  @override
  String get kpi_alignment_error => 'Erreur lors du calcul';

  @override
  String get pillar_economy_title => 'Économie du jardin';

  @override
  String get pillar_nutrition_title => 'Équilibre Nutritionnel';

  @override
  String get pillar_export_title => 'Export';

  @override
  String get pillar_economy_label => 'Valeur totale des récoltes';

  @override
  String get pillar_nutrition_label => 'Signature Nutritionnelle';

  @override
  String get pillar_export_label => 'Récupérez vos données';

  @override
  String get pillar_export_button => 'Exporter';

  @override
  String get stats_economy_title => 'Économie du Jardin';

  @override
  String get stats_economy_no_harvest =>
      'Aucune récolte sur la période sélectionnée.';

  @override
  String get stats_economy_no_harvest_desc =>
      'Aucune donnée sur la période sélectionnée.';

  @override
  String get stats_kpi_total_revenue => 'Revenu Total';

  @override
  String get stats_kpi_total_volume => 'Volume Total';

  @override
  String get stats_kpi_avg_price => 'Prix Moyen';

  @override
  String get stats_top_cultures_title => 'Top Cultures (Valeur)';

  @override
  String get stats_top_cultures_no_data => 'Aucune donnée';

  @override
  String get stats_top_cultures_percent_revenue => 'du revenu';

  @override
  String get stats_monthly_revenue_title => 'Revenu Mensuel';

  @override
  String get stats_monthly_revenue_no_data => 'Pas de données mensuelles';

  @override
  String get stats_dominant_culture_title => 'Culture Dominante par Mois';

  @override
  String get stats_annual_evolution_title => 'Évolution Annuelle';

  @override
  String get stats_crop_distribution_title => 'Répartition par Culture';

  @override
  String get stats_crop_distribution_others => 'Autres';

  @override
  String get stats_key_months_title => 'Mois Clés du Jardin';

  @override
  String get stats_most_profitable => 'Le plus rentable';

  @override
  String get stats_least_profitable => 'Le moins rentable';

  @override
  String get stats_auto_summary_title => 'Synthèse Automatique';

  @override
  String get stats_revenue_history_title => 'Historique du Revenu';

  @override
  String get stats_profitability_cycle_title => 'Cycle de Rentabilité';

  @override
  String get stats_table_crop => 'Culture';

  @override
  String get stats_table_days => 'Jours (Moy)';

  @override
  String get stats_table_revenue => 'Rev/Récolte';

  @override
  String get stats_table_type => 'Type';

  @override
  String get stats_type_fast => 'Rapide';

  @override
  String get stats_type_long_term => 'Long terme';

  @override
  String get nutrition_page_title => 'Signature Nutritionnelle';

  @override
  String get nutrition_seasonal_dynamics_title => 'Dynamique Saisonnière';

  @override
  String get nutrition_seasonal_dynamics_desc =>
      'Explorez la production minérale et vitaminique de votre jardin, mois par mois.';

  @override
  String get nutrition_no_harvest_month => 'Aucune récolte en ce mois';

  @override
  String get nutrition_major_minerals_title => 'Structure & Minéraux Majeurs';

  @override
  String get nutrition_trace_elements_title => 'Vitalité & Oligo-éléments';

  @override
  String get nutrition_no_data_period => 'Pas de données cette période';

  @override
  String get nutrition_no_major_minerals => 'Aucun minéral majeur';

  @override
  String get nutrition_no_trace_elements => 'Aucun oligo-élément';

  @override
  String nutrition_month_dynamics_title(String month) {
    return 'Dynamique de $month';
  }

  @override
  String get nutrition_dominant_production => 'Production dominante :';

  @override
  String get nutrition_nutrients_origin =>
      'Ces nutriments proviennent de vos récoltes du mois.';

  @override
  String get nut_calcium => 'Calcium';

  @override
  String get nut_potassium => 'Potassium';

  @override
  String get nut_magnesium => 'Magnésium';

  @override
  String get nut_iron => 'Fer';

  @override
  String get nut_zinc => 'Zinc';

  @override
  String get nut_manganese => 'Manganèse';

  @override
  String get nut_vitamin_c => 'Vitamine C';

  @override
  String get nut_fiber => 'Fibres';

  @override
  String get nut_protein => 'Protéines';

  @override
  String get export_builder_title => 'Générateur d\'Export';

  @override
  String get export_scope_section => '1. Périmètre';

  @override
  String get export_scope_period => 'Période';

  @override
  String get export_scope_period_all => 'Tout l\'historique';

  @override
  String get export_filter_garden_title => 'Filtrer par Jardin';

  @override
  String get export_filter_garden_all => 'Tous les jardins';

  @override
  String export_filter_garden_count(Object count) {
    return '$count jardin(s) sélectionné(s)';
  }

  @override
  String get export_filter_garden_edit => 'Modifier la sélection';

  @override
  String get export_filter_garden_select_dialog_title =>
      'Sélectionner les jardins';

  @override
  String get export_blocks_section => '2. Données à inclure';

  @override
  String get export_block_activity => 'Activités (Journal)';

  @override
  String get export_block_harvest => 'Récoltes (Production)';

  @override
  String get export_block_garden => 'Jardins (Structure)';

  @override
  String get export_block_garden_bed => 'Parcelles (Structure)';

  @override
  String get export_block_plant => 'Plantes (Catalogue)';

  @override
  String get export_block_desc_activity =>
      'Historique complet des interventions et événements';

  @override
  String get export_block_desc_harvest => 'Données de production et rendements';

  @override
  String get export_block_desc_garden => 'Métadonnées des jardins sélectionnés';

  @override
  String get export_block_desc_garden_bed =>
      'Détails des parcelles (surface, orientation...)';

  @override
  String get export_block_desc_plant => 'Liste des plantes utilisées';

  @override
  String get export_columns_section => '3. Détails & Colonnes';

  @override
  String export_columns_count(Object count) {
    return '$count colonnes sélectionnées';
  }

  @override
  String get export_format_section => '4. Format du fichier';

  @override
  String get export_format_separate => 'Feuilles séparées (Standard)';

  @override
  String get export_format_separate_subtitle =>
      'Une feuille par type de donnée (Recommandé)';

  @override
  String get export_format_flat => 'Table Unique (Flat / BI)';

  @override
  String get export_format_flat_subtitle =>
      'Une seule grande table pour Tableaux Croisés Dynamiques';

  @override
  String get export_action_generate => 'Générer Export Excel';

  @override
  String get export_generating => 'Génération en cours...';

  @override
  String get export_success_title => 'Export terminé';

  @override
  String get export_success_share_text => 'Voici votre export PermaCalendar';

  @override
  String export_error_snack(Object error) {
    return 'Erreur: $error';
  }

  @override
  String get export_field_garden_name => 'Nom du jardin';

  @override
  String get export_field_garden_id => 'ID Jardin';

  @override
  String get export_field_garden_surface => 'Surface (m²)';

  @override
  String get export_field_garden_creation => 'Date création';

  @override
  String get export_field_bed_name => 'Nom parcelle';

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
  String get plant_catalog_sow => 'Semer';

  @override
  String get plant_catalog_plant => 'Planter';

  @override
  String get plant_catalog_show_selection => 'Afficher sélection';

  @override
  String get plant_catalog_filter_green_only =>
      'Legumes adaptés aux conditions';

  @override
  String get plant_catalog_filter_green_orange => 'Verts + Oranges';

  @override
  String get plant_catalog_filter_all => 'Tous';

  @override
  String get plant_catalog_no_recommended =>
      'Aucune plante recommandée sur la période.';

  @override
  String get plant_catalog_expand_window => 'Élargir (±2 mois)';

  @override
  String get plant_catalog_missing_period_data =>
      'Données de période manquantes';

  @override
  String plant_catalog_periods_prefix(String months) {
    return 'Périodes: $months';
  }

  @override
  String get plant_catalog_legend_green => 'Prêt ce mois';

  @override
  String get plant_catalog_legend_orange => 'Proche / Bientôt';

  @override
  String get plant_catalog_legend_red => 'Hors saison';

  @override
  String get plant_catalog_data_unknown => 'Données inconnues';

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
      'La photo sera jointe automatiquement au PDF à la création / envoi.';

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

  @override
  String get settings_garden_config_title => 'Configuration du Jardin';

  @override
  String get settings_climatic_zone_label => 'Zone Climatique';

  @override
  String settings_status_manual(String value) {
    return '$value (Manuel)';
  }

  @override
  String settings_status_auto(String value) {
    return '$value (Auto)';
  }

  @override
  String get settings_status_detecting => 'Détection...';

  @override
  String get settings_last_frost_date_label => 'Dernier Gel (Printemps)';

  @override
  String get settings_last_frost_date_title => 'Date de Dernier Gel';

  @override
  String settings_status_estimated(String value) {
    return '$value (Estimé)';
  }

  @override
  String get settings_status_unknown => 'Inconnu';

  @override
  String get settings_currency_label => 'Devise';

  @override
  String get settings_currency_selector_title => 'Choisir la devise';

  @override
  String get settings_commune_search_placeholder_start =>
      'Saisissez un nom de commune pour commencer.';

  @override
  String settings_commune_search_no_results(String query) {
    return 'Aucun résultat pour \"$query\".';
  }

  @override
  String get settings_zone_auto_recommended => 'Automatique (Recommandé)';

  @override
  String get settings_date_auto => 'Automatique';

  @override
  String get settings_reset_date_button => 'Réinitialiser la date';

  @override
  String get settings_terms_subtitle => 'Termes et conditions';

  @override
  String get language_italian => 'Italiano';

  @override
  String get zone_nh_temperate_europe => 'Tempéré - Hémisphère Nord (Eurasie)';

  @override
  String get zone_nh_temperate_na => 'Tempéré - Amérique du Nord';

  @override
  String get zone_sh_temperate => 'Tempéré - Hémisphère Sud';

  @override
  String get zone_mediterranean => 'Méditerranéen';

  @override
  String get zone_tropical => 'Tropical';

  @override
  String get zone_arid => 'Aride / Désertique';

  @override
  String get stats_pillar_economy => 'ÉCONOMIE';

  @override
  String get stats_pillar_nutrition => 'NUTRITION';

  @override
  String get stats_pillar_export => 'EXPORT';

  @override
  String get stats_data_label => 'DATA';

  @override
  String get stats_radar_vitamins => 'Vitamines';

  @override
  String get stats_radar_minerals => 'Minéraux';

  @override
  String get stats_radar_fibers => 'Fibres';

  @override
  String get stats_radar_proteins => 'Protéines';

  @override
  String get stats_radar_energy => 'Énergie';

  @override
  String get stats_radar_antiox => 'Antiox';

  @override
  String get custom_plant_new_title => 'Nouvelle plante';

  @override
  String get custom_plant_edit_title => 'Modifier la plante';

  @override
  String get custom_plant_action_save_creation => 'Créer la plante';

  @override
  String get custom_plant_action_save_modification =>
      'Enregistrer les modifications';

  @override
  String get custom_plant_delete_confirm_title => 'Supprimer la plante ?';

  @override
  String get custom_plant_delete_confirm_body =>
      'Cette action est irréversible.';

  @override
  String get custom_plant_saved_success => 'Plante enregistrée avec succès';

  @override
  String get custom_plant_common_name_label => 'Nom commun *';

  @override
  String get custom_plant_common_name_required => 'Requis';

  @override
  String get custom_plant_scientific_name_label => 'Nom scientifique';

  @override
  String get custom_plant_family_label => 'Famille';

  @override
  String get custom_plant_description_label => 'Description';

  @override
  String get custom_plant_price_title => 'Prix';

  @override
  String custom_plant_price_label(String currency) {
    return 'Prix moyen par Kg ($currency)';
  }

  @override
  String get custom_plant_price_hint => 'ex: 4.50';

  @override
  String get custom_plant_nutrition_title => 'Nutrition (pour 100g)';

  @override
  String get custom_plant_nutrition_cal => 'Calories';

  @override
  String get custom_plant_nutrition_prot => 'Protéines';

  @override
  String get custom_plant_nutrition_carb => 'Glucides';

  @override
  String get custom_plant_nutrition_fat => 'Lipides';

  @override
  String get custom_plant_notes_title => 'Notes & Associations';

  @override
  String get custom_plant_notes_label => 'Notes personnelles';

  @override
  String get custom_plant_notes_hint =>
      'Plantes compagnes, astuces de culture...';

  @override
  String get custom_plant_cycle_title => 'Cycle de culture';

  @override
  String get custom_plant_sowing_period => 'Période de semis';

  @override
  String get custom_plant_harvest_period => 'Période de récolte';

  @override
  String get custom_plant_select_months => 'Sélectionnez les mois ci-dessous';

  @override
  String get custom_plant_add_photo => 'Ajouter une photo';

  @override
  String get custom_plant_delete_photo => 'Supprimer la photo';

  @override
  String get custom_plant_pick_camera => 'Prendre une photo';

  @override
  String get custom_plant_pick_gallery => 'Choisir depuis la galerie';

  @override
  String custom_plant_pick_error(Object error) {
    return 'Erreur lors de la sélection de l\'image: $error';
  }

  @override
  String get garden_no_location => 'Sans lieu';

  @override
  String get export_filename_prefix => 'Export';

  @override
  String get export_field_desc_nutrient_key => 'Identifiant technique';

  @override
  String get export_field_desc_nutrient_label => 'Nom du nutriment';

  @override
  String get export_field_desc_nutrient_unit => 'Unité de mesure';

  @override
  String get export_field_desc_nutrient_total => 'Quantité totale calculée';

  @override
  String get export_field_desc_mass_with_data_kg =>
      'Masse totale des récoltes ayant des données';

  @override
  String get export_field_desc_contributing_records =>
      'Nombre de récoltes avec données';

  @override
  String get export_field_desc_data_confidence =>
      'Confiance (Masse avec données / Masse totale)';

  @override
  String get export_field_desc_coverage_percent =>
      'Couverture des Apports Journaliers Recommandés';

  @override
  String get export_field_desc_lower_bound_coverage =>
      'Estimation basse de la couverture';

  @override
  String get export_field_desc_upper_bound_coverage =>
      'Estimation haute de la couverture';

  @override
  String get nutrition_inventory_title => 'Inventaire Nutritionnel';

  @override
  String get nutrition_mode_interpretation => 'Interprétation';

  @override
  String get nutrition_mode_measure => 'Mesure';

  @override
  String get calendar_mark_as_done => 'Marquer comme fait';

  @override
  String get calendar_mark_as_todo => 'Marquer comme à faire';

  @override
  String get step_germination_title => 'Germination attendue';

  @override
  String step_germination_desc(Object days) {
    return 'Apparition des premières pousses (estimé à ~$days jours)';
  }

  @override
  String get step_watering_title => 'Arrosage recommandé';

  @override
  String get step_watering_desc_regular =>
      'Arrosage régulier selon les besoins';

  @override
  String step_watering_desc_amount(Object amount) {
    return 'Quantité : $amount';
  }

  @override
  String get step_thinning_title => 'Éclaircissage recommandé';

  @override
  String get step_thinning_desc_default =>
      'Éclaircir pour obtenir un espacement optimal';

  @override
  String get step_weeding_title => 'Désherbage recommandé';

  @override
  String get step_weeding_desc_regular => 'Désherbage régulier selon besoin';

  @override
  String step_weeding_desc_freq(Object freq) {
    return 'Fréquence : $freq';
  }

  @override
  String get step_harvest_estimated_title => 'Récolte estimée';

  @override
  String step_harvest_estimated_desc(Object days) {
    return 'Estimation basée sur $days jours';
  }

  @override
  String get step_harvest_start_title => 'Début de récolte';

  @override
  String get step_harvest_start_desc => 'Début prévu de la période de récolte';

  @override
  String get step_harvest_end_title => 'Fin de récolte';

  @override
  String get step_harvest_end_desc => 'Fin prévue de la période de récolte';

  @override
  String get step_bio_control_title => 'Contrôle biologique';

  @override
  String step_bio_control_prep_title(Object number) {
    return 'Préparation $number contrôle biologique';
  }

  @override
  String get step_add_step_title => 'Ajouter une étape';

  @override
  String get step_dialog_title_label => 'Titre';

  @override
  String get step_dialog_desc_label => 'Description';

  @override
  String get step_dialog_no_date => 'Pas de date';

  @override
  String get step_dialog_pick_date => 'Sélectionner date';

  @override
  String get common_add => 'Ajouter';

  @override
  String get common_done => 'Fait';

  @override
  String get calendar_task_personal_notification_title =>
      'Notification personnelle';

  @override
  String get calendar_task_personal_notification_subtitle =>
      'Recevoir une alerte sur cet appareil';

  @override
  String get calendar_task_notify_before_label => 'Me prévenir';

  @override
  String get notify_at_time => 'À l\'heure';

  @override
  String get minutes_short => 'min';

  @override
  String get hour_short => 'h';

  @override
  String get day_short => 'j';
}
