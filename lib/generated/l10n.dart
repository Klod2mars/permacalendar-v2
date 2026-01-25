// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sowing`
  String get appTitle {
    return Intl.message(
      'Sowing',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Settings (fallback)`
  String get home_settings_fallback_label {
    return Intl.message(
      'Settings (fallback)',
      name: 'home_settings_fallback_label',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get settings_application {
    return Intl.message(
      'Application',
      name: 'settings_application',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get settings_version {
    return Intl.message(
      'Version',
      name: 'settings_version',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get settings_display {
    return Intl.message(
      'Display',
      name: 'settings_display',
      desc: '',
      args: [],
    );
  }

  /// `Weather Selector`
  String get settings_weather_selector {
    return Intl.message(
      'Weather Selector',
      name: 'settings_weather_selector',
      desc: '',
      args: [],
    );
  }

  /// `Location for Weather`
  String get settings_commune_title {
    return Intl.message(
      'Location for Weather',
      name: 'settings_commune_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose a Location`
  String get settings_choose_commune {
    return Intl.message(
      'Choose a Location',
      name: 'settings_choose_commune',
      desc: '',
      args: [],
    );
  }

  /// `Search for a location...`
  String get settings_search_commune_hint {
    return Intl.message(
      'Search for a location...',
      name: 'settings_search_commune_hint',
      desc: '',
      args: [],
    );
  }

  /// `Default: {label}`
  String settings_commune_default(Object label) {
    return Intl.message(
      'Default: $label',
      name: 'settings_commune_default',
      desc: '',
      args: [label],
    );
  }

  /// `Selected: {label}`
  String settings_commune_selected(Object label) {
    return Intl.message(
      'Selected: $label',
      name: 'settings_commune_selected',
      desc: '',
      args: [label],
    );
  }

  /// `Quick Access`
  String get settings_quick_access {
    return Intl.message(
      'Quick Access',
      name: 'settings_quick_access',
      desc: '',
      args: [],
    );
  }

  /// `Plant Catalog`
  String get settings_plants_catalog {
    return Intl.message(
      'Plant Catalog',
      name: 'settings_plants_catalog',
      desc: '',
      args: [],
    );
  }

  /// `Search and browse plants`
  String get settings_plants_catalog_subtitle {
    return Intl.message(
      'Search and browse plants',
      name: 'settings_plants_catalog_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get settings_about {
    return Intl.message(
      'About',
      name: 'settings_about',
      desc: '',
      args: [],
    );
  }

  /// `User Guide`
  String get settings_user_guide {
    return Intl.message(
      'User Guide',
      name: 'settings_user_guide',
      desc: '',
      args: [],
    );
  }

  /// `Read the manual`
  String get settings_user_guide_subtitle {
    return Intl.message(
      'Read the manual',
      name: 'settings_user_guide_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get settings_privacy {
    return Intl.message(
      'Privacy',
      name: 'settings_privacy',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get settings_privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'settings_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get settings_terms {
    return Intl.message(
      'Terms of Use',
      name: 'settings_terms',
      desc: '',
      args: [],
    );
  }

  /// `App Version`
  String get settings_version_dialog_title {
    return Intl.message(
      'App Version',
      name: 'settings_version_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Version: {version} – Dynamic Garden Management\n\nSowing - Living Garden Management`
  String settings_version_dialog_content(Object version) {
    return Intl.message(
      'Version: $version – Dynamic Garden Management\n\nSowing - Living Garden Management',
      name: 'settings_version_dialog_content',
      desc: '',
      args: [version],
    );
  }

  /// `Language / Langue`
  String get language_title {
    return Intl.message(
      'Language / Langue',
      name: 'language_title',
      desc: '',
      args: [],
    );
  }

  /// `Français`
  String get language_french {
    return Intl.message(
      'Français',
      name: 'language_french',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get language_english {
    return Intl.message(
      'English',
      name: 'language_english',
      desc: '',
      args: [],
    );
  }

  /// `Español`
  String get language_spanish {
    return Intl.message(
      'Español',
      name: 'language_spanish',
      desc: '',
      args: [],
    );
  }

  /// `Português (Brasil)`
  String get language_portuguese_br {
    return Intl.message(
      'Português (Brasil)',
      name: 'language_portuguese_br',
      desc: '',
      args: [],
    );
  }

  /// `Deutsch`
  String get language_german {
    return Intl.message(
      'Deutsch',
      name: 'language_german',
      desc: '',
      args: [],
    );
  }

  /// `Language changed: {label}`
  String language_changed_snackbar(Object label) {
    return Intl.message(
      'Language changed: $label',
      name: 'language_changed_snackbar',
      desc: '',
      args: [label],
    );
  }

  /// `Calibration`
  String get calibration_title {
    return Intl.message(
      'Calibration',
      name: 'calibration_title',
      desc: '',
      args: [],
    );
  }

  /// `Customize your dashboard display`
  String get calibration_subtitle {
    return Intl.message(
      'Customize your dashboard display',
      name: 'calibration_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Organic Calibration`
  String get calibration_organic_title {
    return Intl.message(
      'Organic Calibration',
      name: 'calibration_organic_title',
      desc: '',
      args: [],
    );
  }

  /// `Unified mode: Image, Sky, Modules`
  String get calibration_organic_subtitle {
    return Intl.message(
      'Unified mode: Image, Sky, Modules',
      name: 'calibration_organic_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `🌿 Organic calibration disabled`
  String get calibration_organic_disabled {
    return Intl.message(
      '🌿 Organic calibration disabled',
      name: 'calibration_organic_disabled',
      desc: '',
      args: [],
    );
  }

  /// `🌿 Organic calibration mode enabled. Select one of the three tabs.`
  String get calibration_organic_enabled {
    return Intl.message(
      '🌿 Organic calibration mode enabled. Select one of the three tabs.',
      name: 'calibration_organic_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Error calculating lifecycle`
  String get lifecycle_error_title {
    return Intl.message(
      'Error calculating lifecycle',
      name: 'lifecycle_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Error: `
  String get lifecycle_error_prefix {
    return Intl.message(
      'Error: ',
      name: 'lifecycle_error_prefix',
      desc: '',
      args: [],
    );
  }

  /// `cycle completed`
  String get lifecycle_cycle_completed {
    return Intl.message(
      'cycle completed',
      name: 'lifecycle_cycle_completed',
      desc: '',
      args: [],
    );
  }

  /// `Germination`
  String get lifecycle_stage_germination {
    return Intl.message(
      'Germination',
      name: 'lifecycle_stage_germination',
      desc: '',
      args: [],
    );
  }

  /// `Growth`
  String get lifecycle_stage_growth {
    return Intl.message(
      'Growth',
      name: 'lifecycle_stage_growth',
      desc: '',
      args: [],
    );
  }

  /// `Fruiting`
  String get lifecycle_stage_fruiting {
    return Intl.message(
      'Fruiting',
      name: 'lifecycle_stage_fruiting',
      desc: '',
      args: [],
    );
  }

  /// `Harvest`
  String get lifecycle_stage_harvest {
    return Intl.message(
      'Harvest',
      name: 'lifecycle_stage_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get lifecycle_stage_unknown {
    return Intl.message(
      'Unknown',
      name: 'lifecycle_stage_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Expected harvest`
  String get lifecycle_harvest_expected {
    return Intl.message(
      'Expected harvest',
      name: 'lifecycle_harvest_expected',
      desc: '',
      args: [],
    );
  }

  /// `In {days} days`
  String lifecycle_in_days(Object days) {
    return Intl.message(
      'In $days days',
      name: 'lifecycle_in_days',
      desc: '',
      args: [days],
    );
  }

  /// `Passed`
  String get lifecycle_passed {
    return Intl.message(
      'Passed',
      name: 'lifecycle_passed',
      desc: '',
      args: [],
    );
  }

  /// `Now!`
  String get lifecycle_now {
    return Intl.message(
      'Now!',
      name: 'lifecycle_now',
      desc: '',
      args: [],
    );
  }

  /// `Next action`
  String get lifecycle_next_action {
    return Intl.message(
      'Next action',
      name: 'lifecycle_next_action',
      desc: '',
      args: [],
    );
  }

  /// `Update cycle`
  String get lifecycle_update {
    return Intl.message(
      'Update cycle',
      name: 'lifecycle_update',
      desc: '',
      args: [],
    );
  }

  /// `{days} days ago`
  String lifecycle_days_ago(Object days) {
    return Intl.message(
      '$days days ago',
      name: 'lifecycle_days_ago',
      desc: '',
      args: [days],
    );
  }

  /// `Planting Details`
  String get planting_detail_title {
    return Intl.message(
      'Planting Details',
      name: 'planting_detail_title',
      desc: '',
      args: [],
    );
  }

  /// `My Gardens`
  String get garden_list_title {
    return Intl.message(
      'My Gardens',
      name: 'garden_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Loading Error`
  String get garden_error_title {
    return Intl.message(
      'Loading Error',
      name: 'garden_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load garden list: {error}`
  String garden_error_subtitle(Object error) {
    return Intl.message(
      'Unable to load garden list: $error',
      name: 'garden_error_subtitle',
      desc: '',
      args: [error],
    );
  }

  /// `Retry`
  String get garden_retry {
    return Intl.message(
      'Retry',
      name: 'garden_retry',
      desc: '',
      args: [],
    );
  }

  /// `No gardens yet.`
  String get garden_no_gardens {
    return Intl.message(
      'No gardens yet.',
      name: 'garden_no_gardens',
      desc: '',
      args: [],
    );
  }

  /// `You have archived gardens. Enable archived view to see them.`
  String get garden_archived_info {
    return Intl.message(
      'You have archived gardens. Enable archived view to see them.',
      name: 'garden_archived_info',
      desc: '',
      args: [],
    );
  }

  /// `Add Garden`
  String get garden_add_tooltip {
    return Intl.message(
      'Add Garden',
      name: 'garden_add_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Plant Catalog`
  String get plant_catalog_title {
    return Intl.message(
      'Plant Catalog',
      name: 'plant_catalog_title',
      desc: '',
      args: [],
    );
  }

  /// `Search for a plant...`
  String get plant_catalog_search_hint {
    return Intl.message(
      'Search for a plant...',
      name: 'plant_catalog_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get plant_custom_badge {
    return Intl.message(
      'Custom',
      name: 'plant_custom_badge',
      desc: '',
      args: [],
    );
  }

  /// `Plant not found`
  String get plant_detail_not_found_title {
    return Intl.message(
      'Plant not found',
      name: 'plant_detail_not_found_title',
      desc: '',
      args: [],
    );
  }

  /// `This plant does not exist or could not be loaded.`
  String get plant_detail_not_found_body {
    return Intl.message(
      'This plant does not exist or could not be loaded.',
      name: 'plant_detail_not_found_body',
      desc: '',
      args: [],
    );
  }

  /// `{plant} added to favorites`
  String plant_added_favorites(Object plant) {
    return Intl.message(
      '$plant added to favorites',
      name: 'plant_added_favorites',
      desc: '',
      args: [plant],
    );
  }

  /// `Add to garden`
  String get plant_detail_popup_add_to_garden {
    return Intl.message(
      'Add to garden',
      name: 'plant_detail_popup_add_to_garden',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get plant_detail_popup_share {
    return Intl.message(
      'Share',
      name: 'plant_detail_popup_share',
      desc: '',
      args: [],
    );
  }

  /// `Sharing is not implemented yet`
  String get plant_detail_share_todo {
    return Intl.message(
      'Sharing is not implemented yet',
      name: 'plant_detail_share_todo',
      desc: '',
      args: [],
    );
  }

  /// `Adding to garden is not implemented yet`
  String get plant_detail_add_to_garden_todo {
    return Intl.message(
      'Adding to garden is not implemented yet',
      name: 'plant_detail_add_to_garden_todo',
      desc: '',
      args: [],
    );
  }

  /// `Culture Details`
  String get plant_detail_section_culture {
    return Intl.message(
      'Culture Details',
      name: 'plant_detail_section_culture',
      desc: '',
      args: [],
    );
  }

  /// `General Instructions`
  String get plant_detail_section_instructions {
    return Intl.message(
      'General Instructions',
      name: 'plant_detail_section_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get plant_detail_detail_family {
    return Intl.message(
      'Family',
      name: 'plant_detail_detail_family',
      desc: '',
      args: [],
    );
  }

  /// `Maturity Duration`
  String get plant_detail_detail_maturity {
    return Intl.message(
      'Maturity Duration',
      name: 'plant_detail_detail_maturity',
      desc: '',
      args: [],
    );
  }

  /// `Spacing`
  String get plant_detail_detail_spacing {
    return Intl.message(
      'Spacing',
      name: 'plant_detail_detail_spacing',
      desc: '',
      args: [],
    );
  }

  /// `Exposure`
  String get plant_detail_detail_exposure {
    return Intl.message(
      'Exposure',
      name: 'plant_detail_detail_exposure',
      desc: '',
      args: [],
    );
  }

  /// `Water Needs`
  String get plant_detail_detail_water {
    return Intl.message(
      'Water Needs',
      name: 'plant_detail_detail_water',
      desc: '',
      args: [],
    );
  }

  /// `Plantings - {gardenBedName}`
  String planting_title_template(Object gardenBedName) {
    return Intl.message(
      'Plantings - $gardenBedName',
      name: 'planting_title_template',
      desc: '',
      args: [gardenBedName],
    );
  }

  /// `Statistics`
  String get planting_menu_statistics {
    return Intl.message(
      'Statistics',
      name: 'planting_menu_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Ready to harvest`
  String get planting_menu_ready_for_harvest {
    return Intl.message(
      'Ready to harvest',
      name: 'planting_menu_ready_for_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Test Data`
  String get planting_menu_test_data {
    return Intl.message(
      'Test Data',
      name: 'planting_menu_test_data',
      desc: '',
      args: [],
    );
  }

  /// `Search a planting...`
  String get planting_search_hint {
    return Intl.message(
      'Search a planting...',
      name: 'planting_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `All statuses`
  String get planting_filter_all_statuses {
    return Intl.message(
      'All statuses',
      name: 'planting_filter_all_statuses',
      desc: '',
      args: [],
    );
  }

  /// `All plants`
  String get planting_filter_all_plants {
    return Intl.message(
      'All plants',
      name: 'planting_filter_all_plants',
      desc: '',
      args: [],
    );
  }

  /// `Plantings`
  String get planting_stat_plantings {
    return Intl.message(
      'Plantings',
      name: 'planting_stat_plantings',
      desc: '',
      args: [],
    );
  }

  /// `Total Quantity`
  String get planting_stat_total_quantity {
    return Intl.message(
      'Total Quantity',
      name: 'planting_stat_total_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Success Rate`
  String get planting_stat_success_rate {
    return Intl.message(
      'Success Rate',
      name: 'planting_stat_success_rate',
      desc: '',
      args: [],
    );
  }

  /// `In Growth`
  String get planting_stat_in_growth {
    return Intl.message(
      'In Growth',
      name: 'planting_stat_in_growth',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Harvest`
  String get planting_stat_ready_for_harvest {
    return Intl.message(
      'Ready to Harvest',
      name: 'planting_stat_ready_for_harvest',
      desc: '',
      args: [],
    );
  }

  /// `No plantings`
  String get planting_empty_none {
    return Intl.message(
      'No plantings',
      name: 'planting_empty_none',
      desc: '',
      args: [],
    );
  }

  /// `Start by adding your first planting in this bed.`
  String get planting_empty_first {
    return Intl.message(
      'Start by adding your first planting in this bed.',
      name: 'planting_empty_first',
      desc: '',
      args: [],
    );
  }

  /// `Create Planting`
  String get planting_create_action {
    return Intl.message(
      'Create Planting',
      name: 'planting_create_action',
      desc: '',
      args: [],
    );
  }

  /// `No Result`
  String get planting_empty_no_result {
    return Intl.message(
      'No Result',
      name: 'planting_empty_no_result',
      desc: '',
      args: [],
    );
  }

  /// `Clear Filters`
  String get planting_clear_filters {
    return Intl.message(
      'Clear Filters',
      name: 'planting_clear_filters',
      desc: '',
      args: [],
    );
  }

  /// `Add a planting`
  String get planting_add_tooltip {
    return Intl.message(
      'Add a planting',
      name: 'planting_add_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search_hint {
    return Intl.message(
      'Search...',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Page Not Found`
  String get error_page_title {
    return Intl.message(
      'Page Not Found',
      name: 'error_page_title',
      desc: '',
      args: [],
    );
  }

  /// `The page "{uri}" does not exist.`
  String error_page_message(Object uri) {
    return Intl.message(
      'The page "$uri" does not exist.',
      name: 'error_page_message',
      desc: '',
      args: [uri],
    );
  }

  /// `Back to Home`
  String get error_page_back {
    return Intl.message(
      'Back to Home',
      name: 'error_page_back',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get dialog_confirm {
    return Intl.message(
      'Confirm',
      name: 'dialog_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get dialog_cancel {
    return Intl.message(
      'Cancel',
      name: 'dialog_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Location selected: {name}`
  String snackbar_commune_selected(Object name) {
    return Intl.message(
      'Location selected: $name',
      name: 'snackbar_commune_selected',
      desc: '',
      args: [name],
    );
  }

  /// `Validate`
  String get common_validate {
    return Intl.message(
      'Validate',
      name: 'common_validate',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get common_cancel {
    return Intl.message(
      'Cancel',
      name: 'common_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get empty_action_create {
    return Intl.message(
      'Create',
      name: 'empty_action_create',
      desc: '',
      args: [],
    );
  }

  /// `1 — Welcome to Sowing\nSowing is an application designed to support gardeners in the lively and concrete monitoring of their crops.\nIt allows you to:\n• organize your gardens and plots,\n• follow your plantings throughout their life cycle,\n• plan your tasks at the right time,\n• keep a memory of what has been done,\n• take into account local weather and the rhythm of the seasons.\nThe application works mainly offline and keeps your data directly on your device.\nThis manual describes the common use of Sowing: getting started, creating gardens, plantings, calendar, weather, data export and best practices.\n\n2 — Understanding the interface\nThe dashboard\nUpon opening, Sowing displays a visual and organic dashboard.\nIt takes the form of a background image animated by interactive bubbles. Each bubble gives access to a major function of the application:\n• gardens,\n• air weather,\n• soil weather,\n• calendar,\n• activities,\n• statistics,\n• settings.\nGeneral navigation\nSimply touch a bubble to open the corresponding section.\nInside the pages, you will find depending on the context:\n• contextual menus,\n• "+" buttons to add an element,\n• edit or delete buttons.\n\n3 — Quick Start\nOpen the application\nAt launch, the dashboard is displayed automatically.\nConfigure the weather\nIn the settings, choose your location.\nThis information allows Sowing to display local weather adapted to your garden. If no location is selected, a default location is used.\nCreate your first garden\nWhen using for the first time, Sowing automatically guides you to create your first garden.\nYou can also create a garden manually from the dashboard.\nOn the main screen, touch the green leaf located in the freest area, to the right of the statistics and slightly above. This deliberately discreet area allows you to initiate the creation of a garden.\nYou can create up to five gardens.\nThis approach is part of the Sowing experience: there is no permanent and central "+" button. The application rather invites exploration and progressive discovery of space.\nThe areas linked to the gardens are also accessible from the Settings menu.\nOrganic calibration of the dashboard\nAn organic calibration mode allows:\n• to visualize the real location of interactive zones,\n• to move them by simple sliding of the finger.\nYou can thus position your gardens and modules exactly where you want on the image: at the top, at the bottom or at the place that suits you best.\nOnce validated, this organization is saved and kept in the application.\nCreate a plot\nIn a garden sheet:\n• choose "Add a plot",\n• indicate its name, its area and, if necessary, some notes,\n• save.\nAdd a planting\nIn a plot:\n• press the "+" button,\n• choose a plant from the catalog,\n• indicate the date, the quantity and useful information,\n• validate.\n\n4 — The organic dashboard\nThe dashboard is the central point of Sowing.\nIt allows:\n• to have an overview of your activity,\n• to quickly access the main functions,\n• to navigate intuitively.\nDepending on your settings, some bubbles may display synthetic information, such as the weather or upcoming tasks.\n\n5 — Gardens, plots and plantings\nThe gardens\nA garden represents a real place: vegetable garden, greenhouse, orchard, balcony, etc.\nYou can:\n• create several gardens,\n• modify their information,\n• delete them if necessary.\nThe plots\nA plot is a precise zone inside a garden.\nIt allows to structure the space, organize crops and group several plantings in the same place.\nThe plantings\nA planting corresponds to the introduction of a plant in a plot, at a given date.\nWhen creating a planting, Sowing offers two modes.\nSow\nThe "Sow" mode corresponds to putting a seed in the ground.\nIn this case:\n• the progression starts at 0%,\n• a step-by-step follow-up is proposed, particularly useful for beginner gardeners,\n• a progress bar visualizes the advancement of the crop cycle.\nThis follow-up allows to estimate:\n• the probable start of the harvest period,\n• the evolution of the crop over time, in a simple and visual way.\nPlant\nThe "Plant" mode is intended for plants already developed (plants from a greenhouse or purchased in a garden center).\nIn this case:\n• the plant starts with a progression of about 30%,\n• the follow-up is immediately more advanced,\n• the estimation of the harvest period is adjusted consequently.\nChoice of date\nWhen planting, you can freely choose the date.\nThis allows for example:\n• to fill in a planting carried out previously,\n• to correct a date if the application was not used at the time of sowing or planting.\nBy default, the current date is used.\nFollow-up and history\nEach planting has:\n• a progression follow-up,\n• information on its life cycle,\n• crop stages,\n• personal notes.\nAll actions (sowing, planting, care, harvesting) are automatically recorded in the garden history.\n\n6 — Plant catalog\nThe catalog brings together all the plants available when creating a planting.\nIt constitutes an scalable reference base, designed to cover current uses while remaining customizable.\nMain functions:\n• simple and quick search,\n• recognition of common and scientific names,\n• display of photos when available.\nCustom plants\nYou can create your own custom plants from:\nSettings → Plant catalog.\nIt is then possible to:\n• create a new plant,\n• fill in the essential parameters (name, type, useful information),\n• add an image to facilitate identification.\nThe custom plants are then usable like any other plant in the catalog.\n\n7 — Calendar and tasks\nThe calendar view\nThe calendar displays:\n• planned tasks,\n• important plantings,\n• estimated harvest periods.\nCreate a task\nFrom the calendar:\n• create a new task,\n• indicate a title, a date and a description,\n• choose a possible recurrence.\nThe tasks can be associated with a garden or a plot.\nTask management\nYou can:\n• modify a task,\n• delete it,\n• export it to share it.\n\n8 — Activities and history\nThis section constitutes the living memory of your gardens.\nSelection of a garden\nFrom the dashboard, long press a garden to select it.\nThe active garden is highlighted by a light green halo and a confirmation banner.\nThis selection allows to filter the displayed information.\nRecent activities\nThe "Activities" tab displays chronologically:\n• creations,\n• plantings,\n• care,\n• harvests,\n• manual actions.\nHistory by garden\nThe "History" tab presents the complete history of the selected garden, year after year.\nIt allows in particular to:\n• find past plantings,\n• check if a plant has already been cultivated in a given place,\n• better organize crop rotation.\n\n9 — Air weather and soil weather\nAir weather\nThe air weather provides essential information:\n• outside temperature,\n• precipitation (rain, snow, no rain),\n• day / night alternation.\nThis data helps to anticipate climatic risks and adapt interventions.\nSoil weather\nSowing integrates a soil weather module.\nThe user can fill in a measured temperature. From this data, the application dynamically estimates the evolution of the soil temperature over time.\nThis information allows:\n• to know which plants are really cultivable at a given time,\n• to adjust sowing to real conditions rather than a theoretical calendar.\nReal-time weather on the dashboard\nA central ovoid-shaped module displays at a glance:\n• the state of the sky,\n• day or night,\n• the phase and position of the moon for the selected location.\nTime navigation\nBy sliding your finger from left to right on the ovoid, you browse the forecasts hour by hour, up to more than 12 hours in advance.\nThe temperature and precipitation adjust dynamically during the gesture.\n\n10 — Recommendations\nSowing can offer recommendations adapted to your situation.\nThey rely on:\n• the season,\n• the weather,\n• the state of your plantings.\nEach recommendation specifies:\n• what to do,\n• when to act,\n• why the action is suggested.\n\n11 — Export and sharing\nPDF Export — calendar and tasks\nThe calendar tasks can be exported to PDF.\nThis allows to:\n• share clear information,\n• transmit a planned intervention,\n• keep a readable and dated trace.\nExcel Export — harvests and statistics\nThe harvest data can be exported in Excel format in order to:\n• analyze the results,\n• produce reports,\n• follow the evolution over time.\nDocument sharing\nThe generated documents can be shared via the applications available on your device (messaging, storage, transfer to a computer, etc.).\n\n12 — Backup and best practices\nThe data is stored locally on your device.\nRecommended best practices:\n• make a backup before a major update,\n• export your data regularly,\n• keep the application and the device up to date.\n\n13 — Settings\nThe Settings menu allows to adapt Sowing to your uses.\nYou can notably:\n• choose the language,\n• select your location,\n• access the plant catalog,\n• customize the dashboard.\nDashboard customization\nIt is possible to:\n• reposition each module,\n• adjust the visual space,\n• change the background image,\n• import your own image (feature coming soon).\nLegal information\nFrom the settings, you can consult:\n• the user guide,\n• the privacy policy,\n• the terms of use.\n\n14 — Frequently asked questions\nThe touch zones are not well aligned\nDepending on the phone or display settings, some zones may seem shifted.\nAn organic calibration mode allows to:\n• visualize the touch zones,\n• reposition them by sliding,\n• save the configuration for your device.\nCan I use Sowing without connection?\nYes. Sowing works offline for the management of gardens, plantings, tasks and history.\nA connection is only used:\n• for the recovery of weather data,\n• during the export or sharing of documents.\nNo other data is transmitted.\n\n15 — Final remark\nSowing is designed as a gardening companion: simple, lively and scalable.\nTake the time to observe, note and trust your experience as much as the tool.`
  String get user_guide_text {
    return Intl.message(
      '1 — Welcome to Sowing\nSowing is an application designed to support gardeners in the lively and concrete monitoring of their crops.\nIt allows you to:\n• organize your gardens and plots,\n• follow your plantings throughout their life cycle,\n• plan your tasks at the right time,\n• keep a memory of what has been done,\n• take into account local weather and the rhythm of the seasons.\nThe application works mainly offline and keeps your data directly on your device.\nThis manual describes the common use of Sowing: getting started, creating gardens, plantings, calendar, weather, data export and best practices.\n\n2 — Understanding the interface\nThe dashboard\nUpon opening, Sowing displays a visual and organic dashboard.\nIt takes the form of a background image animated by interactive bubbles. Each bubble gives access to a major function of the application:\n• gardens,\n• air weather,\n• soil weather,\n• calendar,\n• activities,\n• statistics,\n• settings.\nGeneral navigation\nSimply touch a bubble to open the corresponding section.\nInside the pages, you will find depending on the context:\n• contextual menus,\n• "+" buttons to add an element,\n• edit or delete buttons.\n\n3 — Quick Start\nOpen the application\nAt launch, the dashboard is displayed automatically.\nConfigure the weather\nIn the settings, choose your location.\nThis information allows Sowing to display local weather adapted to your garden. If no location is selected, a default location is used.\nCreate your first garden\nWhen using for the first time, Sowing automatically guides you to create your first garden.\nYou can also create a garden manually from the dashboard.\nOn the main screen, touch the green leaf located in the freest area, to the right of the statistics and slightly above. This deliberately discreet area allows you to initiate the creation of a garden.\nYou can create up to five gardens.\nThis approach is part of the Sowing experience: there is no permanent and central "+" button. The application rather invites exploration and progressive discovery of space.\nThe areas linked to the gardens are also accessible from the Settings menu.\nOrganic calibration of the dashboard\nAn organic calibration mode allows:\n• to visualize the real location of interactive zones,\n• to move them by simple sliding of the finger.\nYou can thus position your gardens and modules exactly where you want on the image: at the top, at the bottom or at the place that suits you best.\nOnce validated, this organization is saved and kept in the application.\nCreate a plot\nIn a garden sheet:\n• choose "Add a plot",\n• indicate its name, its area and, if necessary, some notes,\n• save.\nAdd a planting\nIn a plot:\n• press the "+" button,\n• choose a plant from the catalog,\n• indicate the date, the quantity and useful information,\n• validate.\n\n4 — The organic dashboard\nThe dashboard is the central point of Sowing.\nIt allows:\n• to have an overview of your activity,\n• to quickly access the main functions,\n• to navigate intuitively.\nDepending on your settings, some bubbles may display synthetic information, such as the weather or upcoming tasks.\n\n5 — Gardens, plots and plantings\nThe gardens\nA garden represents a real place: vegetable garden, greenhouse, orchard, balcony, etc.\nYou can:\n• create several gardens,\n• modify their information,\n• delete them if necessary.\nThe plots\nA plot is a precise zone inside a garden.\nIt allows to structure the space, organize crops and group several plantings in the same place.\nThe plantings\nA planting corresponds to the introduction of a plant in a plot, at a given date.\nWhen creating a planting, Sowing offers two modes.\nSow\nThe "Sow" mode corresponds to putting a seed in the ground.\nIn this case:\n• the progression starts at 0%,\n• a step-by-step follow-up is proposed, particularly useful for beginner gardeners,\n• a progress bar visualizes the advancement of the crop cycle.\nThis follow-up allows to estimate:\n• the probable start of the harvest period,\n• the evolution of the crop over time, in a simple and visual way.\nPlant\nThe "Plant" mode is intended for plants already developed (plants from a greenhouse or purchased in a garden center).\nIn this case:\n• the plant starts with a progression of about 30%,\n• the follow-up is immediately more advanced,\n• the estimation of the harvest period is adjusted consequently.\nChoice of date\nWhen planting, you can freely choose the date.\nThis allows for example:\n• to fill in a planting carried out previously,\n• to correct a date if the application was not used at the time of sowing or planting.\nBy default, the current date is used.\nFollow-up and history\nEach planting has:\n• a progression follow-up,\n• information on its life cycle,\n• crop stages,\n• personal notes.\nAll actions (sowing, planting, care, harvesting) are automatically recorded in the garden history.\n\n6 — Plant catalog\nThe catalog brings together all the plants available when creating a planting.\nIt constitutes an scalable reference base, designed to cover current uses while remaining customizable.\nMain functions:\n• simple and quick search,\n• recognition of common and scientific names,\n• display of photos when available.\nCustom plants\nYou can create your own custom plants from:\nSettings → Plant catalog.\nIt is then possible to:\n• create a new plant,\n• fill in the essential parameters (name, type, useful information),\n• add an image to facilitate identification.\nThe custom plants are then usable like any other plant in the catalog.\n\n7 — Calendar and tasks\nThe calendar view\nThe calendar displays:\n• planned tasks,\n• important plantings,\n• estimated harvest periods.\nCreate a task\nFrom the calendar:\n• create a new task,\n• indicate a title, a date and a description,\n• choose a possible recurrence.\nThe tasks can be associated with a garden or a plot.\nTask management\nYou can:\n• modify a task,\n• delete it,\n• export it to share it.\n\n8 — Activities and history\nThis section constitutes the living memory of your gardens.\nSelection of a garden\nFrom the dashboard, long press a garden to select it.\nThe active garden is highlighted by a light green halo and a confirmation banner.\nThis selection allows to filter the displayed information.\nRecent activities\nThe "Activities" tab displays chronologically:\n• creations,\n• plantings,\n• care,\n• harvests,\n• manual actions.\nHistory by garden\nThe "History" tab presents the complete history of the selected garden, year after year.\nIt allows in particular to:\n• find past plantings,\n• check if a plant has already been cultivated in a given place,\n• better organize crop rotation.\n\n9 — Air weather and soil weather\nAir weather\nThe air weather provides essential information:\n• outside temperature,\n• precipitation (rain, snow, no rain),\n• day / night alternation.\nThis data helps to anticipate climatic risks and adapt interventions.\nSoil weather\nSowing integrates a soil weather module.\nThe user can fill in a measured temperature. From this data, the application dynamically estimates the evolution of the soil temperature over time.\nThis information allows:\n• to know which plants are really cultivable at a given time,\n• to adjust sowing to real conditions rather than a theoretical calendar.\nReal-time weather on the dashboard\nA central ovoid-shaped module displays at a glance:\n• the state of the sky,\n• day or night,\n• the phase and position of the moon for the selected location.\nTime navigation\nBy sliding your finger from left to right on the ovoid, you browse the forecasts hour by hour, up to more than 12 hours in advance.\nThe temperature and precipitation adjust dynamically during the gesture.\n\n10 — Recommendations\nSowing can offer recommendations adapted to your situation.\nThey rely on:\n• the season,\n• the weather,\n• the state of your plantings.\nEach recommendation specifies:\n• what to do,\n• when to act,\n• why the action is suggested.\n\n11 — Export and sharing\nPDF Export — calendar and tasks\nThe calendar tasks can be exported to PDF.\nThis allows to:\n• share clear information,\n• transmit a planned intervention,\n• keep a readable and dated trace.\nExcel Export — harvests and statistics\nThe harvest data can be exported in Excel format in order to:\n• analyze the results,\n• produce reports,\n• follow the evolution over time.\nDocument sharing\nThe generated documents can be shared via the applications available on your device (messaging, storage, transfer to a computer, etc.).\n\n12 — Backup and best practices\nThe data is stored locally on your device.\nRecommended best practices:\n• make a backup before a major update,\n• export your data regularly,\n• keep the application and the device up to date.\n\n13 — Settings\nThe Settings menu allows to adapt Sowing to your uses.\nYou can notably:\n• choose the language,\n• select your location,\n• access the plant catalog,\n• customize the dashboard.\nDashboard customization\nIt is possible to:\n• reposition each module,\n• adjust the visual space,\n• change the background image,\n• import your own image (feature coming soon).\nLegal information\nFrom the settings, you can consult:\n• the user guide,\n• the privacy policy,\n• the terms of use.\n\n14 — Frequently asked questions\nThe touch zones are not well aligned\nDepending on the phone or display settings, some zones may seem shifted.\nAn organic calibration mode allows to:\n• visualize the touch zones,\n• reposition them by sliding,\n• save the configuration for your device.\nCan I use Sowing without connection?\nYes. Sowing works offline for the management of gardens, plantings, tasks and history.\nA connection is only used:\n• for the recovery of weather data,\n• during the export or sharing of documents.\nNo other data is transmitted.\n\n15 — Final remark\nSowing is designed as a gardening companion: simple, lively and scalable.\nTake the time to observe, note and trust your experience as much as the tool.',
      name: 'user_guide_text',
      desc: '',
      args: [],
    );
  }

  /// `Sowing fully respects your privacy.\n\n• All data is stored locally on your device\n• No personal data is transmitted to third parties\n• No information is stored on an external server\n\nThe application works entirely offline. An Internet connection is only used to retrieve weather data or during exports.`
  String get privacy_policy_text {
    return Intl.message(
      'Sowing fully respects your privacy.\n\n• All data is stored locally on your device\n• No personal data is transmitted to third parties\n• No information is stored on an external server\n\nThe application works entirely offline. An Internet connection is only used to retrieve weather data or during exports.',
      name: 'privacy_policy_text',
      desc: '',
      args: [],
    );
  }

  /// `By using Sowing, you agree to:\n\n• Use the application responsibly\n• Not attempt to bypass its limitations\n• Respect intellectual property rights\n• Use only your own data\n\nThis application is provided as is, without warranty.\n\nThe Sowing team remains attentive to any future improvement or evolution.`
  String get terms_text {
    return Intl.message(
      'By using Sowing, you agree to:\n\n• Use the application responsibly\n• Not attempt to bypass its limitations\n• Respect intellectual property rights\n• Use only your own data\n\nThis application is provided as is, without warranty.\n\nThe Sowing team remains attentive to any future improvement or evolution.',
      name: 'terms_text',
      desc: '',
      args: [],
    );
  }

  /// `Automatically apply for this device`
  String get calibration_auto_apply {
    return Intl.message(
      'Automatically apply for this device',
      name: 'calibration_auto_apply',
      desc: '',
      args: [],
    );
  }

  /// `Calibrate now`
  String get calibration_calibrate_now {
    return Intl.message(
      'Calibrate now',
      name: 'calibration_calibrate_now',
      desc: '',
      args: [],
    );
  }

  /// `Save current calibration as profile`
  String get calibration_save_profile {
    return Intl.message(
      'Save current calibration as profile',
      name: 'calibration_save_profile',
      desc: '',
      args: [],
    );
  }

  /// `Export profile (JSON copy)`
  String get calibration_export_profile {
    return Intl.message(
      'Export profile (JSON copy)',
      name: 'calibration_export_profile',
      desc: '',
      args: [],
    );
  }

  /// `Import profile from clipboard`
  String get calibration_import_profile {
    return Intl.message(
      'Import profile from clipboard',
      name: 'calibration_import_profile',
      desc: '',
      args: [],
    );
  }

  /// `Reset profile for this device`
  String get calibration_reset_profile {
    return Intl.message(
      'Reset profile for this device',
      name: 'calibration_reset_profile',
      desc: '',
      args: [],
    );
  }

  /// `Refresh profile preview`
  String get calibration_refresh_profile {
    return Intl.message(
      'Refresh profile preview',
      name: 'calibration_refresh_profile',
      desc: '',
      args: [],
    );
  }

  /// `Device key: {key}`
  String calibration_key_device(Object key) {
    return Intl.message(
      'Device key: $key',
      name: 'calibration_key_device',
      desc: '',
      args: [key],
    );
  }

  /// `No profile saved for this device.`
  String get calibration_no_profile {
    return Intl.message(
      'No profile saved for this device.',
      name: 'calibration_no_profile',
      desc: '',
      args: [],
    );
  }

  /// `Background Image Settings (Persistent)`
  String get calibration_image_settings_title {
    return Intl.message(
      'Background Image Settings (Persistent)',
      name: 'calibration_image_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Pos X`
  String get calibration_pos_x {
    return Intl.message(
      'Pos X',
      name: 'calibration_pos_x',
      desc: '',
      args: [],
    );
  }

  /// `Pos Y`
  String get calibration_pos_y {
    return Intl.message(
      'Pos Y',
      name: 'calibration_pos_y',
      desc: '',
      args: [],
    );
  }

  /// `Zoom`
  String get calibration_zoom {
    return Intl.message(
      'Zoom',
      name: 'calibration_zoom',
      desc: '',
      args: [],
    );
  }

  /// `Reset Image Defaults`
  String get calibration_reset_image {
    return Intl.message(
      'Reset Image Defaults',
      name: 'calibration_reset_image',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get calibration_dialog_confirm_title {
    return Intl.message(
      'Confirm',
      name: 'calibration_dialog_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Delete calibration profile for this device?`
  String get calibration_dialog_delete_profile {
    return Intl.message(
      'Delete calibration profile for this device?',
      name: 'calibration_dialog_delete_profile',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get calibration_action_delete {
    return Intl.message(
      'Delete',
      name: 'calibration_action_delete',
      desc: '',
      args: [],
    );
  }

  /// `No profile found for this device.`
  String get calibration_snack_no_profile {
    return Intl.message(
      'No profile found for this device.',
      name: 'calibration_snack_no_profile',
      desc: '',
      args: [],
    );
  }

  /// `Profile copied to clipboard.`
  String get calibration_snack_profile_copied {
    return Intl.message(
      'Profile copied to clipboard.',
      name: 'calibration_snack_profile_copied',
      desc: '',
      args: [],
    );
  }

  /// `Clipboard empty.`
  String get calibration_snack_clipboard_empty {
    return Intl.message(
      'Clipboard empty.',
      name: 'calibration_snack_clipboard_empty',
      desc: '',
      args: [],
    );
  }

  /// `Profile imported and saved for this device.`
  String get calibration_snack_profile_imported {
    return Intl.message(
      'Profile imported and saved for this device.',
      name: 'calibration_snack_profile_imported',
      desc: '',
      args: [],
    );
  }

  /// `JSON import error: {error}`
  String calibration_snack_import_error(Object error) {
    return Intl.message(
      'JSON import error: $error',
      name: 'calibration_snack_import_error',
      desc: '',
      args: [error],
    );
  }

  /// `Profile deleted for this device.`
  String get calibration_snack_profile_deleted {
    return Intl.message(
      'Profile deleted for this device.',
      name: 'calibration_snack_profile_deleted',
      desc: '',
      args: [],
    );
  }

  /// `No calibration saved. Calibrate from dashboard first.`
  String get calibration_snack_no_calibration {
    return Intl.message(
      'No calibration saved. Calibrate from dashboard first.',
      name: 'calibration_snack_no_calibration',
      desc: '',
      args: [],
    );
  }

  /// `Current calibration saved as profile for this device.`
  String get calibration_snack_saved_as_profile {
    return Intl.message(
      'Current calibration saved as profile for this device.',
      name: 'calibration_snack_saved_as_profile',
      desc: '',
      args: [],
    );
  }

  /// `Error while saving: {error}`
  String calibration_snack_save_error(Object error) {
    return Intl.message(
      'Error while saving: $error',
      name: 'calibration_snack_save_error',
      desc: '',
      args: [error],
    );
  }

  /// `Calibration saved`
  String get calibration_overlay_saved {
    return Intl.message(
      'Calibration saved',
      name: 'calibration_overlay_saved',
      desc: '',
      args: [],
    );
  }

  /// `Calibration save error: {error}`
  String calibration_overlay_error_save(Object error) {
    return Intl.message(
      'Calibration save error: $error',
      name: 'calibration_overlay_error_save',
      desc: '',
      args: [error],
    );
  }

  /// `Drag to move, pinch to zoom the background image.`
  String get calibration_instruction_image {
    return Intl.message(
      'Drag to move, pinch to zoom the background image.',
      name: 'calibration_instruction_image',
      desc: '',
      args: [],
    );
  }

  /// `Adjust the day/night ovoid (center, size, rotation).`
  String get calibration_instruction_sky {
    return Intl.message(
      'Adjust the day/night ovoid (center, size, rotation).',
      name: 'calibration_instruction_sky',
      desc: '',
      args: [],
    );
  }

  /// `Move the modules (bubbles) to the desired location.`
  String get calibration_instruction_modules {
    return Intl.message(
      'Move the modules (bubbles) to the desired location.',
      name: 'calibration_instruction_modules',
      desc: '',
      args: [],
    );
  }

  /// `Select a tool to start.`
  String get calibration_instruction_none {
    return Intl.message(
      'Select a tool to start.',
      name: 'calibration_instruction_none',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get calibration_tool_image {
    return Intl.message(
      'Image',
      name: 'calibration_tool_image',
      desc: '',
      args: [],
    );
  }

  /// `Sky`
  String get calibration_tool_sky {
    return Intl.message(
      'Sky',
      name: 'calibration_tool_sky',
      desc: '',
      args: [],
    );
  }

  /// `Modules`
  String get calibration_tool_modules {
    return Intl.message(
      'Modules',
      name: 'calibration_tool_modules',
      desc: '',
      args: [],
    );
  }

  /// `Validate & Exit`
  String get calibration_action_validate_exit {
    return Intl.message(
      'Validate & Exit',
      name: 'calibration_action_validate_exit',
      desc: '',
      args: [],
    );
  }

  /// `Weather Details`
  String get dashboard_weather_stats {
    return Intl.message(
      'Weather Details',
      name: 'dashboard_weather_stats',
      desc: '',
      args: [],
    );
  }

  /// `Soil Temp`
  String get dashboard_soil_temp {
    return Intl.message(
      'Soil Temp',
      name: 'dashboard_soil_temp',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get dashboard_air_temp {
    return Intl.message(
      'Temperature',
      name: 'dashboard_air_temp',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get dashboard_statistics {
    return Intl.message(
      'Statistics',
      name: 'dashboard_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get dashboard_calendar {
    return Intl.message(
      'Calendar',
      name: 'dashboard_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Activities`
  String get dashboard_activities {
    return Intl.message(
      'Activities',
      name: 'dashboard_activities',
      desc: '',
      args: [],
    );
  }

  /// `Weather`
  String get dashboard_weather {
    return Intl.message(
      'Weather',
      name: 'dashboard_weather',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get dashboard_settings {
    return Intl.message(
      'Settings',
      name: 'dashboard_settings',
      desc: '',
      args: [],
    );
  }

  /// `Garden {number}`
  String dashboard_garden_n(Object number) {
    return Intl.message(
      'Garden $number',
      name: 'dashboard_garden_n',
      desc: '',
      args: [number],
    );
  }

  /// `Garden "{name}" created successfully`
  String dashboard_garden_created(Object name) {
    return Intl.message(
      'Garden "$name" created successfully',
      name: 'dashboard_garden_created',
      desc: '',
      args: [name],
    );
  }

  /// `Error creating garden.`
  String get dashboard_garden_create_error {
    return Intl.message(
      'Error creating garden.',
      name: 'dashboard_garden_create_error',
      desc: '',
      args: [],
    );
  }

  /// `Growing Calendar`
  String get calendar_title {
    return Intl.message(
      'Growing Calendar',
      name: 'calendar_title',
      desc: '',
      args: [],
    );
  }

  /// `Calendar refreshed`
  String get calendar_refreshed {
    return Intl.message(
      'Calendar refreshed',
      name: 'calendar_refreshed',
      desc: '',
      args: [],
    );
  }

  /// `New Task`
  String get calendar_new_task_tooltip {
    return Intl.message(
      'New Task',
      name: 'calendar_new_task_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Task saved`
  String get calendar_task_saved_title {
    return Intl.message(
      'Task saved',
      name: 'calendar_task_saved_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to send it as PDF?`
  String get calendar_ask_export_pdf {
    return Intl.message(
      'Do you want to send it as PDF?',
      name: 'calendar_ask_export_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Task modified`
  String get calendar_task_modified {
    return Intl.message(
      'Task modified',
      name: 'calendar_task_modified',
      desc: '',
      args: [],
    );
  }

  /// `Delete task?`
  String get calendar_delete_confirm_title {
    return Intl.message(
      'Delete task?',
      name: 'calendar_delete_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `"{title}" will be deleted.`
  String calendar_delete_confirm_content(Object title) {
    return Intl.message(
      '"$title" will be deleted.',
      name: 'calendar_delete_confirm_content',
      desc: '',
      args: [title],
    );
  }

  /// `Task deleted`
  String get calendar_task_deleted {
    return Intl.message(
      'Task deleted',
      name: 'calendar_task_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Restore error: {error}`
  String calendar_restore_error(Object error) {
    return Intl.message(
      'Restore error: $error',
      name: 'calendar_restore_error',
      desc: '',
      args: [error],
    );
  }

  /// `Delete error: {error}`
  String calendar_delete_error(Object error) {
    return Intl.message(
      'Delete error: $error',
      name: 'calendar_delete_error',
      desc: '',
      args: [error],
    );
  }

  /// `Send / Assign to...`
  String get calendar_action_assign {
    return Intl.message(
      'Send / Assign to...',
      name: 'calendar_action_assign',
      desc: '',
      args: [],
    );
  }

  /// `Assign / Send`
  String get calendar_assign_title {
    return Intl.message(
      'Assign / Send',
      name: 'calendar_assign_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter name or email`
  String get calendar_assign_hint {
    return Intl.message(
      'Enter name or email',
      name: 'calendar_assign_hint',
      desc: '',
      args: [],
    );
  }

  /// `Name or Email`
  String get calendar_assign_field {
    return Intl.message(
      'Name or Email',
      name: 'calendar_assign_field',
      desc: '',
      args: [],
    );
  }

  /// `Task assigned to {name}`
  String calendar_task_assigned(Object name) {
    return Intl.message(
      'Task assigned to $name',
      name: 'calendar_task_assigned',
      desc: '',
      args: [name],
    );
  }

  /// `Assignment error: {error}`
  String calendar_assign_error(Object error) {
    return Intl.message(
      'Assignment error: $error',
      name: 'calendar_assign_error',
      desc: '',
      args: [error],
    );
  }

  /// `PDF Export error: {error}`
  String calendar_export_error(Object error) {
    return Intl.message(
      'PDF Export error: $error',
      name: 'calendar_export_error',
      desc: '',
      args: [error],
    );
  }

  /// `Previous month`
  String get calendar_previous_month {
    return Intl.message(
      'Previous month',
      name: 'calendar_previous_month',
      desc: '',
      args: [],
    );
  }

  /// `Next month`
  String get calendar_next_month {
    return Intl.message(
      'Next month',
      name: 'calendar_next_month',
      desc: '',
      args: [],
    );
  }

  /// `Limit reached`
  String get calendar_limit_reached {
    return Intl.message(
      'Limit reached',
      name: 'calendar_limit_reached',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to navigate`
  String get calendar_drag_instruction {
    return Intl.message(
      'Swipe to navigate',
      name: 'calendar_drag_instruction',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get common_refresh {
    return Intl.message(
      'Refresh',
      name: 'common_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get common_yes {
    return Intl.message(
      'Yes',
      name: 'common_yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get common_no {
    return Intl.message(
      'No',
      name: 'common_no',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get common_delete {
    return Intl.message(
      'Delete',
      name: 'common_delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get common_edit {
    return Intl.message(
      'Edit',
      name: 'common_edit',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get common_undo {
    return Intl.message(
      'Undo',
      name: 'common_undo',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String common_error_prefix(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'common_error_prefix',
      desc: '',
      args: [error],
    );
  }

  /// `Retry`
  String get common_retry {
    return Intl.message(
      'Retry',
      name: 'common_retry',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get common_general_error {
    return Intl.message(
      'An error occurred',
      name: 'common_general_error',
      desc: 'Generic error message',
      args: [],
    );
  }

  /// `Error`
  String get common_error {
    return Intl.message(
      'Error',
      name: 'common_error',
      desc: 'Generic error title',
      args: [],
    );
  }

  /// `New Task`
  String get task_editor_title_new {
    return Intl.message(
      'New Task',
      name: 'task_editor_title_new',
      desc: 'New task dialog title',
      args: [],
    );
  }

  /// `Edit Task`
  String get task_editor_title_edit {
    return Intl.message(
      'Edit Task',
      name: 'task_editor_title_edit',
      desc: 'Edit task dialog title',
      args: [],
    );
  }

  /// `Title *`
  String get task_editor_title_field {
    return Intl.message(
      'Title *',
      name: 'task_editor_title_field',
      desc: 'Title field label',
      args: [],
    );
  }

  /// `Required`
  String get task_editor_error_title_required {
    return Intl.message(
      'Required',
      name: 'task_editor_error_title_required',
      desc: 'Title validation error',
      args: [],
    );
  }

  /// `All Gardens`
  String get task_editor_garden_all {
    return Intl.message(
      'All Gardens',
      name: 'task_editor_garden_all',
      desc: 'All gardens option',
      args: [],
    );
  }

  /// `Zone (Bed)`
  String get task_editor_zone_label {
    return Intl.message(
      'Zone (Bed)',
      name: 'task_editor_zone_label',
      desc: 'Zone field label',
      args: [],
    );
  }

  /// `No specific zone`
  String get task_editor_zone_none {
    return Intl.message(
      'No specific zone',
      name: 'task_editor_zone_none',
      desc: 'No zone option',
      args: [],
    );
  }

  /// `No beds for this garden`
  String get task_editor_zone_empty {
    return Intl.message(
      'No beds for this garden',
      name: 'task_editor_zone_empty',
      desc: 'No beds message',
      args: [],
    );
  }

  /// `Description`
  String get task_editor_description_label {
    return Intl.message(
      'Description',
      name: 'task_editor_description_label',
      desc: 'Description field label',
      args: [],
    );
  }

  /// `Start Date`
  String get task_editor_date_label {
    return Intl.message(
      'Start Date',
      name: 'task_editor_date_label',
      desc: 'Date field label',
      args: [],
    );
  }

  /// `Time`
  String get task_editor_time_label {
    return Intl.message(
      'Time',
      name: 'task_editor_time_label',
      desc: 'Time field label',
      args: [],
    );
  }

  /// `Estimated Duration`
  String get task_editor_duration_label {
    return Intl.message(
      'Estimated Duration',
      name: 'task_editor_duration_label',
      desc: 'Duration field label',
      args: [],
    );
  }

  /// `Other`
  String get task_editor_duration_other {
    return Intl.message(
      'Other',
      name: 'task_editor_duration_other',
      desc: 'Other duration option',
      args: [],
    );
  }

  /// `Task Type`
  String get task_editor_type_label {
    return Intl.message(
      'Task Type',
      name: 'task_editor_type_label',
      desc: 'Task type field label',
      args: [],
    );
  }

  /// `Priority`
  String get task_editor_priority_label {
    return Intl.message(
      'Priority',
      name: 'task_editor_priority_label',
      desc: 'Priority field label',
      args: [],
    );
  }

  /// `Urgent`
  String get task_editor_urgent_label {
    return Intl.message(
      'Urgent',
      name: 'task_editor_urgent_label',
      desc: 'Urgent switch label',
      args: [],
    );
  }

  /// `None (Save Only)`
  String get task_editor_option_none {
    return Intl.message(
      'None (Save Only)',
      name: 'task_editor_option_none',
      desc: 'None export option',
      args: [],
    );
  }

  /// `Share (Text)`
  String get task_editor_option_share {
    return Intl.message(
      'Share (Text)',
      name: 'task_editor_option_share',
      desc: 'Share export option',
      args: [],
    );
  }

  /// `Export — PDF`
  String get task_editor_option_pdf {
    return Intl.message(
      'Export — PDF',
      name: 'task_editor_option_pdf',
      desc: 'PDF export option',
      args: [],
    );
  }

  /// `Export — Word (.docx)`
  String get task_editor_option_docx {
    return Intl.message(
      'Export — Word (.docx)',
      name: 'task_editor_option_docx',
      desc: 'Word export option',
      args: [],
    );
  }

  /// `Output / Share`
  String get task_editor_export_label {
    return Intl.message(
      'Output / Share',
      name: 'task_editor_export_label',
      desc: 'Export field label',
      args: [],
    );
  }

  /// `Add Photo (Coming Soon)`
  String get task_editor_photo_placeholder {
    return Intl.message(
      'Add Photo (Coming Soon)',
      name: 'task_editor_photo_placeholder',
      desc: 'Photo placeholder button',
      args: [],
    );
  }

  /// `Create`
  String get task_editor_action_create {
    return Intl.message(
      'Create',
      name: 'task_editor_action_create',
      desc: 'Create button',
      args: [],
    );
  }

  /// `Save`
  String get task_editor_action_save {
    return Intl.message(
      'Save',
      name: 'task_editor_action_save',
      desc: 'Save button',
      args: [],
    );
  }

  /// `Cancel`
  String get task_editor_action_cancel {
    return Intl.message(
      'Cancel',
      name: 'task_editor_action_cancel',
      desc: 'Cancel button',
      args: [],
    );
  }

  /// `Assigned to`
  String get task_editor_assignee_label {
    return Intl.message(
      'Assigned to',
      name: 'task_editor_assignee_label',
      desc: 'Assignee field label',
      args: [],
    );
  }

  /// `Add "{name}" to favorites`
  String task_editor_assignee_add(String name) {
    return Intl.message(
      'Add "$name" to favorites',
      name: 'task_editor_assignee_add',
      desc: 'Action add assignee favorrites',
      args: [name],
    );
  }

  /// `No results.`
  String get task_editor_assignee_none {
    return Intl.message(
      'No results.',
      name: 'task_editor_assignee_none',
      desc: 'Assignee no results',
      args: [],
    );
  }

  /// `Recurrence`
  String get task_editor_recurrence_label {
    return Intl.message(
      'Recurrence',
      name: 'task_editor_recurrence_label',
      desc: 'Recurrence field label',
      args: [],
    );
  }

  /// `None`
  String get task_editor_recurrence_none {
    return Intl.message(
      'None',
      name: 'task_editor_recurrence_none',
      desc: 'Recurrence option none',
      args: [],
    );
  }

  /// `Every X days`
  String get task_editor_recurrence_interval {
    return Intl.message(
      'Every X days',
      name: 'task_editor_recurrence_interval',
      desc: 'Recurrence option interval',
      args: [],
    );
  }

  /// `Weekly (Days)`
  String get task_editor_recurrence_weekly {
    return Intl.message(
      'Weekly (Days)',
      name: 'task_editor_recurrence_weekly',
      desc: 'Recurrence option weekly',
      args: [],
    );
  }

  /// `Monthly (same day)`
  String get task_editor_recurrence_monthly {
    return Intl.message(
      'Monthly (same day)',
      name: 'task_editor_recurrence_monthly',
      desc: 'Recurrence option monthly',
      args: [],
    );
  }

  /// `Repeat every `
  String get task_editor_recurrence_repeat_label {
    return Intl.message(
      'Repeat every ',
      name: 'task_editor_recurrence_repeat_label',
      desc: 'Label repeat every',
      args: [],
    );
  }

  /// ` d`
  String get task_editor_recurrence_days_suffix {
    return Intl.message(
      ' d',
      name: 'task_editor_recurrence_days_suffix',
      desc: 'Suffix days',
      args: [],
    );
  }

  /// `Generic`
  String get task_kind_generic {
    return Intl.message(
      'Generic',
      name: 'task_kind_generic',
      desc: 'Generic task type',
      args: [],
    );
  }

  /// `Repair 🛠️`
  String get task_kind_repair {
    return Intl.message(
      'Repair 🛠️',
      name: 'task_kind_repair',
      desc: 'Repair task type',
      args: [],
    );
  }

  /// `Soil Temperature`
  String get soil_temp_title {
    return Intl.message(
      'Soil Temperature',
      name: 'soil_temp_title',
      desc: 'Soil temp screen title',
      args: [],
    );
  }

  /// `Chart error: {error}`
  String soil_temp_chart_error(Object error) {
    return Intl.message(
      'Chart error: $error',
      name: 'soil_temp_chart_error',
      desc: 'Chart display error',
      args: [error],
    );
  }

  /// `About Soil Temperature`
  String get soil_temp_about_title {
    return Intl.message(
      'About Soil Temperature',
      name: 'soil_temp_about_title',
      desc: 'About section title',
      args: [],
    );
  }

  /// `The soil temperature displayed here is estimated by the app from climatic and seasonal data, according to the following formula:\n\nThis estimate gives a realistic trend of soil temperature when no direct measurement is available.`
  String get soil_temp_about_content {
    return Intl.message(
      'The soil temperature displayed here is estimated by the app from climatic and seasonal data, according to the following formula:\n\nThis estimate gives a realistic trend of soil temperature when no direct measurement is available.',
      name: 'soil_temp_about_content',
      desc: 'About section content',
      args: [],
    );
  }

  /// `Calculation formula used:`
  String get soil_temp_formula_label {
    return Intl.message(
      'Calculation formula used:',
      name: 'soil_temp_formula_label',
      desc: 'Formula label',
      args: [],
    );
  }

  /// `T_soil(n+1) = T_soil(n) + α × (T_air(n) − T_soil(n))\n\nWhere:\n• α: thermal diffusion coefficient (default 0.15 — recommended range 0.10–0.20).\n• T_soil(n): current soil temperature (°C).\n• T_air(n): current air temperature (°C).\n\nThe formula is implemented in the app code (ComputeSoilTempNextDayUsecase).`
  String get soil_temp_formula_content {
    return Intl.message(
      'T_soil(n+1) = T_soil(n) + α × (T_air(n) − T_soil(n))\n\nWhere:\n• α: thermal diffusion coefficient (default 0.15 — recommended range 0.10–0.20).\n• T_soil(n): current soil temperature (°C).\n• T_air(n): current air temperature (°C).\n\nThe formula is implemented in the app code (ComputeSoilTempNextDayUsecase).',
      name: 'soil_temp_formula_content',
      desc: 'Formula content',
      args: [],
    );
  }

  /// `Current Temperature`
  String get soil_temp_current_label {
    return Intl.message(
      'Current Temperature',
      name: 'soil_temp_current_label',
      desc: 'Current temp label',
      args: [],
    );
  }

  /// `Edit / Measure`
  String get soil_temp_action_measure {
    return Intl.message(
      'Edit / Measure',
      name: 'soil_temp_action_measure',
      desc: 'Edit/measure button',
      args: [],
    );
  }

  /// `You can manually enter the soil temperature in the 'Edit / Measure' tab.`
  String get soil_temp_measure_hint {
    return Intl.message(
      'You can manually enter the soil temperature in the \'Edit / Measure\' tab.',
      name: 'soil_temp_measure_hint',
      desc: 'Manual measure hint',
      args: [],
    );
  }

  /// `Catalog error: {error}`
  String soil_temp_catalog_error(Object error) {
    return Intl.message(
      'Catalog error: $error',
      name: 'soil_temp_catalog_error',
      desc: 'Catalog error',
      args: [error],
    );
  }

  /// `Advice error: {error}`
  String soil_temp_advice_error(Object error) {
    return Intl.message(
      'Advice error: $error',
      name: 'soil_temp_advice_error',
      desc: 'Advice loading error',
      args: [error],
    );
  }

  /// `Plant database is empty.`
  String get soil_temp_db_empty {
    return Intl.message(
      'Plant database is empty.',
      name: 'soil_temp_db_empty',
      desc: 'Empty DB message',
      args: [],
    );
  }

  /// `Reload plants`
  String get soil_temp_reload_plants {
    return Intl.message(
      'Reload plants',
      name: 'soil_temp_reload_plants',
      desc: 'Reload plants button',
      args: [],
    );
  }

  /// `No plants with germination data found.`
  String get soil_temp_no_advice {
    return Intl.message(
      'No plants with germination data found.',
      name: 'soil_temp_no_advice',
      desc: 'No advice message',
      args: [],
    );
  }

  /// `Optimal`
  String get soil_advice_status_ideal {
    return Intl.message(
      'Optimal',
      name: 'soil_advice_status_ideal',
      desc: 'Status ideal',
      args: [],
    );
  }

  /// `Sow Now`
  String get soil_advice_status_sow_now {
    return Intl.message(
      'Sow Now',
      name: 'soil_advice_status_sow_now',
      desc: 'Status sow now',
      args: [],
    );
  }

  /// `Soon`
  String get soil_advice_status_sow_soon {
    return Intl.message(
      'Soon',
      name: 'soil_advice_status_sow_soon',
      desc: 'Status soon',
      args: [],
    );
  }

  /// `Wait`
  String get soil_advice_status_wait {
    return Intl.message(
      'Wait',
      name: 'soil_advice_status_wait',
      desc: 'Status wait',
      args: [],
    );
  }

  /// `Soil Temperature`
  String get soil_sheet_title {
    return Intl.message(
      'Soil Temperature',
      name: 'soil_sheet_title',
      desc: 'Soil temp sheet title',
      args: [],
    );
  }

  /// `Last measure: {temp}°C ({date})`
  String soil_sheet_last_measure(String temp, String date) {
    return Intl.message(
      'Last measure: $temp°C ($date)',
      name: 'soil_sheet_last_measure',
      desc: 'Last measure info',
      args: [temp, date],
    );
  }

  /// `New measure (Anchor)`
  String get soil_sheet_new_measure {
    return Intl.message(
      'New measure (Anchor)',
      name: 'soil_sheet_new_measure',
      desc: 'New measure section title',
      args: [],
    );
  }

  /// `Temperature (°C)`
  String get soil_sheet_input_label {
    return Intl.message(
      'Temperature (°C)',
      name: 'soil_sheet_input_label',
      desc: 'Input temp label',
      args: [],
    );
  }

  /// `Invalid value (-10.0 to 45.0)`
  String get soil_sheet_input_error {
    return Intl.message(
      'Invalid value (-10.0 to 45.0)',
      name: 'soil_sheet_input_error',
      desc: 'Input validation error',
      args: [],
    );
  }

  /// `0.0`
  String get soil_sheet_input_hint {
    return Intl.message(
      '0.0',
      name: 'soil_sheet_input_hint',
      desc: 'Input hint',
      args: [],
    );
  }

  /// `Cancel`
  String get soil_sheet_action_cancel {
    return Intl.message(
      'Cancel',
      name: 'soil_sheet_action_cancel',
      desc: 'Cancel button',
      args: [],
    );
  }

  /// `Save`
  String get soil_sheet_action_save {
    return Intl.message(
      'Save',
      name: 'soil_sheet_action_save',
      desc: 'Save button',
      args: [],
    );
  }

  /// `Invalid value. Enter -10.0 to 45.0`
  String get soil_sheet_snack_invalid {
    return Intl.message(
      'Invalid value. Enter -10.0 to 45.0',
      name: 'soil_sheet_snack_invalid',
      desc: 'Invalid value snackbar',
      args: [],
    );
  }

  /// `Measure saved as anchor`
  String get soil_sheet_snack_success {
    return Intl.message(
      'Measure saved as anchor',
      name: 'soil_sheet_snack_success',
      desc: 'Success snackbar',
      args: [],
    );
  }

  /// `Save error: {error}`
  String soil_sheet_snack_error(Object error) {
    return Intl.message(
      'Save error: $error',
      name: 'soil_sheet_snack_error',
      desc: 'Error snackbar',
      args: [error],
    );
  }

  /// `Weather`
  String get weather_screen_title {
    return Intl.message(
      'Weather',
      name: 'weather_screen_title',
      desc: 'Weather screen title',
      args: [],
    );
  }

  /// `Data provided by Open-Meteo`
  String get weather_provider_credit {
    return Intl.message(
      'Data provided by Open-Meteo',
      name: 'weather_provider_credit',
      desc: 'Data provider credit',
      args: [],
    );
  }

  /// `Unable to load weather`
  String get weather_error_loading {
    return Intl.message(
      'Unable to load weather',
      name: 'weather_error_loading',
      desc: 'Weather load error',
      args: [],
    );
  }

  /// `Retry`
  String get weather_action_retry {
    return Intl.message(
      'Retry',
      name: 'weather_action_retry',
      desc: 'Retry button',
      args: [],
    );
  }

  /// `NEXT 24H`
  String get weather_header_next_24h {
    return Intl.message(
      'NEXT 24H',
      name: 'weather_header_next_24h',
      desc: 'Next 24h header',
      args: [],
    );
  }

  /// `DAILY SUMMARY`
  String get weather_header_daily_summary {
    return Intl.message(
      'DAILY SUMMARY',
      name: 'weather_header_daily_summary',
      desc: 'Daily summary header',
      args: [],
    );
  }

  /// `PRECIPITATION (24h)`
  String get weather_header_precipitations {
    return Intl.message(
      'PRECIPITATION (24h)',
      name: 'weather_header_precipitations',
      desc: 'Precipitations header',
      args: [],
    );
  }

  /// `WIND`
  String get weather_label_wind {
    return Intl.message(
      'WIND',
      name: 'weather_label_wind',
      desc: 'Wind label',
      args: [],
    );
  }

  /// `PRESSURE`
  String get weather_label_pressure {
    return Intl.message(
      'PRESSURE',
      name: 'weather_label_pressure',
      desc: 'Pressure label',
      args: [],
    );
  }

  /// `SUN`
  String get weather_label_sun {
    return Intl.message(
      'SUN',
      name: 'weather_label_sun',
      desc: 'Sun label',
      args: [],
    );
  }

  /// `ASTRO`
  String get weather_label_astro {
    return Intl.message(
      'ASTRO',
      name: 'weather_label_astro',
      desc: 'Astro label',
      args: [],
    );
  }

  /// `Speed`
  String get weather_data_speed {
    return Intl.message(
      'Speed',
      name: 'weather_data_speed',
      desc: 'Wind speed label',
      args: [],
    );
  }

  /// `Gusts`
  String get weather_data_gusts {
    return Intl.message(
      'Gusts',
      name: 'weather_data_gusts',
      desc: 'Gusts label',
      args: [],
    );
  }

  /// `Sunrise`
  String get weather_data_sunrise {
    return Intl.message(
      'Sunrise',
      name: 'weather_data_sunrise',
      desc: 'Sunrise label',
      args: [],
    );
  }

  /// `Sunset`
  String get weather_data_sunset {
    return Intl.message(
      'Sunset',
      name: 'weather_data_sunset',
      desc: 'Sunset label',
      args: [],
    );
  }

  /// `Rain`
  String get weather_data_rain {
    return Intl.message(
      'Rain',
      name: 'weather_data_rain',
      desc: 'Rain label',
      args: [],
    );
  }

  /// `Max`
  String get weather_data_max {
    return Intl.message(
      'Max',
      name: 'weather_data_max',
      desc: 'Max temp label',
      args: [],
    );
  }

  /// `Min`
  String get weather_data_min {
    return Intl.message(
      'Min',
      name: 'weather_data_min',
      desc: 'Min temp label',
      args: [],
    );
  }

  /// `Max Wind`
  String get weather_data_wind_max {
    return Intl.message(
      'Max Wind',
      name: 'weather_data_wind_max',
      desc: 'Max wind label',
      args: [],
    );
  }

  /// `High`
  String get weather_pressure_high {
    return Intl.message(
      'High',
      name: 'weather_pressure_high',
      desc: 'High pressure',
      args: [],
    );
  }

  /// `Low`
  String get weather_pressure_low {
    return Intl.message(
      'Low',
      name: 'weather_pressure_low',
      desc: 'Low pressure',
      args: [],
    );
  }

  /// `Today`
  String get weather_today_label {
    return Intl.message(
      'Today',
      name: 'weather_today_label',
      desc: 'Today label',
      args: [],
    );
  }

  /// `New Moon`
  String get moon_phase_new {
    return Intl.message(
      'New Moon',
      name: 'moon_phase_new',
      desc: 'New moon',
      args: [],
    );
  }

  /// `Waxing Crescent`
  String get moon_phase_waxing_crescent {
    return Intl.message(
      'Waxing Crescent',
      name: 'moon_phase_waxing_crescent',
      desc: 'Waxing crescent',
      args: [],
    );
  }

  /// `First Quarter`
  String get moon_phase_first_quarter {
    return Intl.message(
      'First Quarter',
      name: 'moon_phase_first_quarter',
      desc: 'First quarter',
      args: [],
    );
  }

  /// `Waxing Gibbous`
  String get moon_phase_waxing_gibbous {
    return Intl.message(
      'Waxing Gibbous',
      name: 'moon_phase_waxing_gibbous',
      desc: 'Waxing gibbous',
      args: [],
    );
  }

  /// `Full Moon`
  String get moon_phase_full {
    return Intl.message(
      'Full Moon',
      name: 'moon_phase_full',
      desc: 'Full moon',
      args: [],
    );
  }

  /// `Waning Gibbous`
  String get moon_phase_waning_gibbous {
    return Intl.message(
      'Waning Gibbous',
      name: 'moon_phase_waning_gibbous',
      desc: 'Waning gibbous',
      args: [],
    );
  }

  /// `Last Quarter`
  String get moon_phase_last_quarter {
    return Intl.message(
      'Last Quarter',
      name: 'moon_phase_last_quarter',
      desc: 'Last quarter',
      args: [],
    );
  }

  /// `Waning Crescent`
  String get moon_phase_waning_crescent {
    return Intl.message(
      'Waning Crescent',
      name: 'moon_phase_waning_crescent',
      desc: 'Waning crescent',
      args: [],
    );
  }

  /// `Clear sky`
  String get wmo_code_0 {
    return Intl.message(
      'Clear sky',
      name: 'wmo_code_0',
      desc: '',
      args: [],
    );
  }

  /// `Mainly clear`
  String get wmo_code_1 {
    return Intl.message(
      'Mainly clear',
      name: 'wmo_code_1',
      desc: '',
      args: [],
    );
  }

  /// `Partly cloudy`
  String get wmo_code_2 {
    return Intl.message(
      'Partly cloudy',
      name: 'wmo_code_2',
      desc: '',
      args: [],
    );
  }

  /// `Overcast`
  String get wmo_code_3 {
    return Intl.message(
      'Overcast',
      name: 'wmo_code_3',
      desc: '',
      args: [],
    );
  }

  /// `Fog`
  String get wmo_code_45 {
    return Intl.message(
      'Fog',
      name: 'wmo_code_45',
      desc: '',
      args: [],
    );
  }

  /// `Depositing rime fog`
  String get wmo_code_48 {
    return Intl.message(
      'Depositing rime fog',
      name: 'wmo_code_48',
      desc: '',
      args: [],
    );
  }

  /// `Light drizzle`
  String get wmo_code_51 {
    return Intl.message(
      'Light drizzle',
      name: 'wmo_code_51',
      desc: '',
      args: [],
    );
  }

  /// `Moderate drizzle`
  String get wmo_code_53 {
    return Intl.message(
      'Moderate drizzle',
      name: 'wmo_code_53',
      desc: '',
      args: [],
    );
  }

  /// `Dense drizzle`
  String get wmo_code_55 {
    return Intl.message(
      'Dense drizzle',
      name: 'wmo_code_55',
      desc: '',
      args: [],
    );
  }

  /// `Slight rain`
  String get wmo_code_61 {
    return Intl.message(
      'Slight rain',
      name: 'wmo_code_61',
      desc: '',
      args: [],
    );
  }

  /// `Moderate rain`
  String get wmo_code_63 {
    return Intl.message(
      'Moderate rain',
      name: 'wmo_code_63',
      desc: '',
      args: [],
    );
  }

  /// `Heavy rain`
  String get wmo_code_65 {
    return Intl.message(
      'Heavy rain',
      name: 'wmo_code_65',
      desc: '',
      args: [],
    );
  }

  /// `Light freezing rain`
  String get wmo_code_66 {
    return Intl.message(
      'Light freezing rain',
      name: 'wmo_code_66',
      desc: '',
      args: [],
    );
  }

  /// `Heavy freezing rain`
  String get wmo_code_67 {
    return Intl.message(
      'Heavy freezing rain',
      name: 'wmo_code_67',
      desc: '',
      args: [],
    );
  }

  /// `Slight snow fall`
  String get wmo_code_71 {
    return Intl.message(
      'Slight snow fall',
      name: 'wmo_code_71',
      desc: '',
      args: [],
    );
  }

  /// `Moderate snow fall`
  String get wmo_code_73 {
    return Intl.message(
      'Moderate snow fall',
      name: 'wmo_code_73',
      desc: '',
      args: [],
    );
  }

  /// `Heavy snow fall`
  String get wmo_code_75 {
    return Intl.message(
      'Heavy snow fall',
      name: 'wmo_code_75',
      desc: '',
      args: [],
    );
  }

  /// `Snow grains`
  String get wmo_code_77 {
    return Intl.message(
      'Snow grains',
      name: 'wmo_code_77',
      desc: '',
      args: [],
    );
  }

  /// `Slight rain showers`
  String get wmo_code_80 {
    return Intl.message(
      'Slight rain showers',
      name: 'wmo_code_80',
      desc: '',
      args: [],
    );
  }

  /// `Moderate rain showers`
  String get wmo_code_81 {
    return Intl.message(
      'Moderate rain showers',
      name: 'wmo_code_81',
      desc: '',
      args: [],
    );
  }

  /// `Violent rain showers`
  String get wmo_code_82 {
    return Intl.message(
      'Violent rain showers',
      name: 'wmo_code_82',
      desc: '',
      args: [],
    );
  }

  /// `Slight snow showers`
  String get wmo_code_85 {
    return Intl.message(
      'Slight snow showers',
      name: 'wmo_code_85',
      desc: '',
      args: [],
    );
  }

  /// `Heavy snow showers`
  String get wmo_code_86 {
    return Intl.message(
      'Heavy snow showers',
      name: 'wmo_code_86',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm`
  String get wmo_code_95 {
    return Intl.message(
      'Thunderstorm',
      name: 'wmo_code_95',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with slight hail`
  String get wmo_code_96 {
    return Intl.message(
      'Thunderstorm with slight hail',
      name: 'wmo_code_96',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with heavy hail`
  String get wmo_code_99 {
    return Intl.message(
      'Thunderstorm with heavy hail',
      name: 'wmo_code_99',
      desc: '',
      args: [],
    );
  }

  /// `Unknown conditions`
  String get wmo_code_unknown {
    return Intl.message(
      'Unknown conditions',
      name: 'wmo_code_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Buy 🛒`
  String get task_kind_buy {
    return Intl.message(
      'Buy 🛒',
      name: 'task_kind_buy',
      desc: 'Buy task type',
      args: [],
    );
  }

  /// `Clean 🧹`
  String get task_kind_clean {
    return Intl.message(
      'Clean 🧹',
      name: 'task_kind_clean',
      desc: 'Clean task type',
      args: [],
    );
  }

  /// `Watering 💧`
  String get task_kind_watering {
    return Intl.message(
      'Watering 💧',
      name: 'task_kind_watering',
      desc: 'Watering task type',
      args: [],
    );
  }

  /// `Seeding 🌱`
  String get task_kind_seeding {
    return Intl.message(
      'Seeding 🌱',
      name: 'task_kind_seeding',
      desc: 'Seeding task type',
      args: [],
    );
  }

  /// `Pruning ✂️`
  String get task_kind_pruning {
    return Intl.message(
      'Pruning ✂️',
      name: 'task_kind_pruning',
      desc: 'Pruning task type',
      args: [],
    );
  }

  /// `Weeding 🌿`
  String get task_kind_weeding {
    return Intl.message(
      'Weeding 🌿',
      name: 'task_kind_weeding',
      desc: 'Weeding task type',
      args: [],
    );
  }

  /// `Amendment 🪵`
  String get task_kind_amendment {
    return Intl.message(
      'Amendment 🪵',
      name: 'task_kind_amendment',
      desc: 'Amendment task type',
      args: [],
    );
  }

  /// `Treatment 🧪`
  String get task_kind_treatment {
    return Intl.message(
      'Treatment 🧪',
      name: 'task_kind_treatment',
      desc: 'Treatment task type',
      args: [],
    );
  }

  /// `Harvest 🧺`
  String get task_kind_harvest {
    return Intl.message(
      'Harvest 🧺',
      name: 'task_kind_harvest',
      desc: 'Harvest task type',
      args: [],
    );
  }

  /// `Winter Protection ❄️`
  String get task_kind_winter_protection {
    return Intl.message(
      'Winter Protection ❄️',
      name: 'task_kind_winter_protection',
      desc: 'Winter protection task type',
      args: [],
    );
  }

  /// `No events today`
  String get calendar_no_events {
    return Intl.message(
      'No events today',
      name: 'calendar_no_events',
      desc: '',
      args: [],
    );
  }

  /// `Events of {date}`
  String calendar_events_of(Object date) {
    return Intl.message(
      'Events of $date',
      name: 'calendar_events_of',
      desc: '',
      args: [date],
    );
  }

  /// `Plantings`
  String get calendar_section_plantings {
    return Intl.message(
      'Plantings',
      name: 'calendar_section_plantings',
      desc: '',
      args: [],
    );
  }

  /// `Expected harvests`
  String get calendar_section_harvests {
    return Intl.message(
      'Expected harvests',
      name: 'calendar_section_harvests',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled tasks`
  String get calendar_section_tasks {
    return Intl.message(
      'Scheduled tasks',
      name: 'calendar_section_tasks',
      desc: '',
      args: [],
    );
  }

  /// `Tasks`
  String get calendar_filter_tasks {
    return Intl.message(
      'Tasks',
      name: 'calendar_filter_tasks',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get calendar_filter_maintenance {
    return Intl.message(
      'Maintenance',
      name: 'calendar_filter_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Harvests`
  String get calendar_filter_harvests {
    return Intl.message(
      'Harvests',
      name: 'calendar_filter_harvests',
      desc: '',
      args: [],
    );
  }

  /// `Urgent`
  String get calendar_filter_urgent {
    return Intl.message(
      'Urgent',
      name: 'calendar_filter_urgent',
      desc: '',
      args: [],
    );
  }

  /// `Create a Garden`
  String get garden_management_create_title {
    return Intl.message(
      'Create a Garden',
      name: 'garden_management_create_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit Garden`
  String get garden_management_edit_title {
    return Intl.message(
      'Edit Garden',
      name: 'garden_management_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `Garden Name`
  String get garden_management_name_label {
    return Intl.message(
      'Garden Name',
      name: 'garden_management_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get garden_management_desc_label {
    return Intl.message(
      'Description',
      name: 'garden_management_desc_label',
      desc: '',
      args: [],
    );
  }

  /// `Garden Image (Optional)`
  String get garden_management_image_label {
    return Intl.message(
      'Garden Image (Optional)',
      name: 'garden_management_image_label',
      desc: '',
      args: [],
    );
  }

  /// `Image URL`
  String get garden_management_image_url_label {
    return Intl.message(
      'Image URL',
      name: 'garden_management_image_url_label',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load image`
  String get garden_management_image_preview_error {
    return Intl.message(
      'Unable to load image',
      name: 'garden_management_image_preview_error',
      desc: '',
      args: [],
    );
  }

  /// `Create Garden`
  String get garden_management_create_submit {
    return Intl.message(
      'Create Garden',
      name: 'garden_management_create_submit',
      desc: '',
      args: [],
    );
  }

  /// `Creating...`
  String get garden_management_create_submitting {
    return Intl.message(
      'Creating...',
      name: 'garden_management_create_submitting',
      desc: '',
      args: [],
    );
  }

  /// `Garden created successfully`
  String get garden_management_created_success {
    return Intl.message(
      'Garden created successfully',
      name: 'garden_management_created_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create garden`
  String get garden_management_create_error {
    return Intl.message(
      'Failed to create garden',
      name: 'garden_management_create_error',
      desc: '',
      args: [],
    );
  }

  /// `Delete Garden`
  String get garden_management_delete_confirm_title {
    return Intl.message(
      'Delete Garden',
      name: 'garden_management_delete_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this garden? This will also delete all associated plots and plantings. This action is irreversible.`
  String get garden_management_delete_confirm_body {
    return Intl.message(
      'Are you sure you want to delete this garden? This will also delete all associated plots and plantings. This action is irreversible.',
      name: 'garden_management_delete_confirm_body',
      desc: '',
      args: [],
    );
  }

  /// `Garden deleted successfully`
  String get garden_management_delete_success {
    return Intl.message(
      'Garden deleted successfully',
      name: 'garden_management_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Archived Garden`
  String get garden_management_archived_tag {
    return Intl.message(
      'Archived Garden',
      name: 'garden_management_archived_tag',
      desc: '',
      args: [],
    );
  }

  /// `Garden Beds`
  String get garden_management_beds_title {
    return Intl.message(
      'Garden Beds',
      name: 'garden_management_beds_title',
      desc: '',
      args: [],
    );
  }

  /// `No Garden Beds`
  String get garden_management_no_beds_title {
    return Intl.message(
      'No Garden Beds',
      name: 'garden_management_no_beds_title',
      desc: '',
      args: [],
    );
  }

  /// `Create beds to organize your plantings`
  String get garden_management_no_beds_desc {
    return Intl.message(
      'Create beds to organize your plantings',
      name: 'garden_management_no_beds_desc',
      desc: '',
      args: [],
    );
  }

  /// `Create Bed`
  String get garden_management_add_bed_label {
    return Intl.message(
      'Create Bed',
      name: 'garden_management_add_bed_label',
      desc: '',
      args: [],
    );
  }

  /// `Beds`
  String get garden_management_stats_beds {
    return Intl.message(
      'Beds',
      name: 'garden_management_stats_beds',
      desc: '',
      args: [],
    );
  }

  /// `Total Area`
  String get garden_management_stats_area {
    return Intl.message(
      'Total Area',
      name: 'garden_management_stats_area',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get garden_detail_title_error {
    return Intl.message(
      'Error',
      name: 'garden_detail_title_error',
      desc: '',
      args: [],
    );
  }

  /// `The requested garden does not exist or has been deleted.`
  String get garden_detail_subtitle_not_found {
    return Intl.message(
      'The requested garden does not exist or has been deleted.',
      name: 'garden_detail_subtitle_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load beds: {error}`
  String garden_detail_subtitle_error_beds(Object error) {
    return Intl.message(
      'Unable to load beds: $error',
      name: 'garden_detail_subtitle_error_beds',
      desc: '',
      args: [error],
    );
  }

  /// `Edit`
  String get garden_action_edit {
    return Intl.message(
      'Edit',
      name: 'garden_action_edit',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get garden_action_archive {
    return Intl.message(
      'Archive',
      name: 'garden_action_archive',
      desc: '',
      args: [],
    );
  }

  /// `Unarchive`
  String get garden_action_unarchive {
    return Intl.message(
      'Unarchive',
      name: 'garden_action_unarchive',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get garden_action_delete {
    return Intl.message(
      'Delete',
      name: 'garden_action_delete',
      desc: '',
      args: [],
    );
  }

  /// `Created on {date}`
  String garden_created_at(Object date) {
    return Intl.message(
      'Created on $date',
      name: 'garden_created_at',
      desc: '',
      args: [date],
    );
  }

  /// `Delete Bed`
  String get garden_bed_delete_confirm_title {
    return Intl.message(
      'Delete Bed',
      name: 'garden_bed_delete_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete "{bedName}"? This action is irreversible.`
  String garden_bed_delete_confirm_body(Object bedName) {
    return Intl.message(
      'Are you sure you want to delete "$bedName"? This action is irreversible.',
      name: 'garden_bed_delete_confirm_body',
      desc: '',
      args: [bedName],
    );
  }

  /// `Bed deleted`
  String get garden_bed_deleted_snack {
    return Intl.message(
      'Bed deleted',
      name: 'garden_bed_deleted_snack',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting bed: {error}`
  String garden_bed_delete_error(Object error) {
    return Intl.message(
      'Error deleting bed: $error',
      name: 'garden_bed_delete_error',
      desc: '',
      args: [error],
    );
  }

  /// `Save`
  String get common_save {
    return Intl.message(
      'Save',
      name: 'common_save',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get common_back {
    return Intl.message(
      'Back',
      name: 'common_back',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get garden_action_disable {
    return Intl.message(
      'Disable',
      name: 'garden_action_disable',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get garden_action_enable {
    return Intl.message(
      'Enable',
      name: 'garden_action_enable',
      desc: '',
      args: [],
    );
  }

  /// `Modify`
  String get garden_action_modify {
    return Intl.message(
      'Modify',
      name: 'garden_action_modify',
      desc: '',
      args: [],
    );
  }

  /// `New Bed`
  String get bed_create_title_new {
    return Intl.message(
      'New Bed',
      name: 'bed_create_title_new',
      desc: '',
      args: [],
    );
  }

  /// `Edit Bed`
  String get bed_create_title_edit {
    return Intl.message(
      'Edit Bed',
      name: 'bed_create_title_edit',
      desc: '',
      args: [],
    );
  }

  /// `Bed Name *`
  String get bed_form_name_label {
    return Intl.message(
      'Bed Name *',
      name: 'bed_form_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Ex: North Bed, Plot 1`
  String get bed_form_name_hint {
    return Intl.message(
      'Ex: North Bed, Plot 1',
      name: 'bed_form_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Area (m²) *`
  String get bed_form_size_label {
    return Intl.message(
      'Area (m²) *',
      name: 'bed_form_size_label',
      desc: '',
      args: [],
    );
  }

  /// `Ex: 10.5`
  String get bed_form_size_hint {
    return Intl.message(
      'Ex: 10.5',
      name: 'bed_form_size_hint',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get bed_form_desc_label {
    return Intl.message(
      'Description',
      name: 'bed_form_desc_label',
      desc: '',
      args: [],
    );
  }

  /// `Description...`
  String get bed_form_desc_hint {
    return Intl.message(
      'Description...',
      name: 'bed_form_desc_hint',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get bed_form_submit_create {
    return Intl.message(
      'Create',
      name: 'bed_form_submit_create',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get bed_form_submit_edit {
    return Intl.message(
      'Save',
      name: 'bed_form_submit_edit',
      desc: '',
      args: [],
    );
  }

  /// `Bed created successfully`
  String get bed_snack_created {
    return Intl.message(
      'Bed created successfully',
      name: 'bed_snack_created',
      desc: '',
      args: [],
    );
  }

  /// `Bed updated successfully`
  String get bed_snack_updated {
    return Intl.message(
      'Bed updated successfully',
      name: 'bed_snack_updated',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get bed_form_error_name_required {
    return Intl.message(
      'Name is required',
      name: 'bed_form_error_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters`
  String get bed_form_error_name_length {
    return Intl.message(
      'Name must be at least 2 characters',
      name: 'bed_form_error_name_length',
      desc: '',
      args: [],
    );
  }

  /// `Area is required`
  String get bed_form_error_size_required {
    return Intl.message(
      'Area is required',
      name: 'bed_form_error_size_required',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid area`
  String get bed_form_error_size_invalid {
    return Intl.message(
      'Please enter a valid area',
      name: 'bed_form_error_size_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Area cannot exceed 1000 m²`
  String get bed_form_error_size_max {
    return Intl.message(
      'Area cannot exceed 1000 m²',
      name: 'bed_form_error_size_max',
      desc: '',
      args: [],
    );
  }

  /// `Sown`
  String get status_sown {
    return Intl.message(
      'Sown',
      name: 'status_sown',
      desc: '',
      args: [],
    );
  }

  /// `Planted`
  String get status_planted {
    return Intl.message(
      'Planted',
      name: 'status_planted',
      desc: '',
      args: [],
    );
  }

  /// `Growing`
  String get status_growing {
    return Intl.message(
      'Growing',
      name: 'status_growing',
      desc: '',
      args: [],
    );
  }

  /// `Ready to harvest`
  String get status_ready_to_harvest {
    return Intl.message(
      'Ready to harvest',
      name: 'status_ready_to_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Harvested`
  String get status_harvested {
    return Intl.message(
      'Harvested',
      name: 'status_harvested',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get status_failed {
    return Intl.message(
      'Failed',
      name: 'status_failed',
      desc: '',
      args: [],
    );
  }

  /// `Sown on {date}`
  String bed_card_sown_on(Object date) {
    return Intl.message(
      'Sown on $date',
      name: 'bed_card_sown_on',
      desc: '',
      args: [date],
    );
  }

  /// `approx. harvest start`
  String get bed_card_harvest_start {
    return Intl.message(
      'approx. harvest start',
      name: 'bed_card_harvest_start',
      desc: '',
      args: [],
    );
  }

  /// `Harvest`
  String get bed_action_harvest {
    return Intl.message(
      'Harvest',
      name: 'bed_action_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Beneficial plants`
  String get companion_beneficial {
    return Intl.message(
      'Beneficial plants',
      name: 'companion_beneficial',
      desc: '',
      args: [],
    );
  }

  /// `Plants to avoid`
  String get companion_avoid {
    return Intl.message(
      'Plants to avoid',
      name: 'companion_avoid',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get common_close {
    return Intl.message(
      'Close',
      name: 'common_close',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get bed_detail_surface {
    return Intl.message(
      'Area',
      name: 'bed_detail_surface',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get bed_detail_details {
    return Intl.message(
      'Details',
      name: 'bed_detail_details',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get bed_detail_notes {
    return Intl.message(
      'Notes',
      name: 'bed_detail_notes',
      desc: '',
      args: [],
    );
  }

  /// `Current Plantings`
  String get bed_detail_current_plantings {
    return Intl.message(
      'Current Plantings',
      name: 'bed_detail_current_plantings',
      desc: '',
      args: [],
    );
  }

  /// `No Plantings`
  String get bed_detail_no_plantings_title {
    return Intl.message(
      'No Plantings',
      name: 'bed_detail_no_plantings_title',
      desc: '',
      args: [],
    );
  }

  /// `This bed has no plantings yet.`
  String get bed_detail_no_plantings_desc {
    return Intl.message(
      'This bed has no plantings yet.',
      name: 'bed_detail_no_plantings_desc',
      desc: '',
      args: [],
    );
  }

  /// `Add Planting`
  String get bed_detail_add_planting {
    return Intl.message(
      'Add Planting',
      name: 'bed_detail_add_planting',
      desc: '',
      args: [],
    );
  }

  /// `Delete Planting?`
  String get bed_delete_planting_confirm_title {
    return Intl.message(
      'Delete Planting?',
      name: 'bed_delete_planting_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `This action is irreversible. Do you really want to delete this planting?`
  String get bed_delete_planting_confirm_body {
    return Intl.message(
      'This action is irreversible. Do you really want to delete this planting?',
      name: 'bed_delete_planting_confirm_body',
      desc: '',
      args: [],
    );
  }

  /// `Harvest: {plantName}`
  String harvest_title(Object plantName) {
    return Intl.message(
      'Harvest: $plantName',
      name: 'harvest_title',
      desc: '',
      args: [plantName],
    );
  }

  /// `Harvested Weight (kg) *`
  String get harvest_weight_label {
    return Intl.message(
      'Harvested Weight (kg) *',
      name: 'harvest_weight_label',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Price (€/kg)`
  String get harvest_price_label {
    return Intl.message(
      'Estimated Price (€/kg)',
      name: 'harvest_price_label',
      desc: '',
      args: [],
    );
  }

  /// `Will be remembered for future harvests of this plant`
  String get harvest_price_helper {
    return Intl.message(
      'Will be remembered for future harvests of this plant',
      name: 'harvest_price_helper',
      desc: '',
      args: [],
    );
  }

  /// `Notes / Quality`
  String get harvest_notes_label {
    return Intl.message(
      'Notes / Quality',
      name: 'harvest_notes_label',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get harvest_action_save {
    return Intl.message(
      'Save',
      name: 'harvest_action_save',
      desc: '',
      args: [],
    );
  }

  /// `Harvest recorded`
  String get harvest_snack_saved {
    return Intl.message(
      'Harvest recorded',
      name: 'harvest_snack_saved',
      desc: '',
      args: [],
    );
  }

  /// `Error recording harvest`
  String get harvest_snack_error {
    return Intl.message(
      'Error recording harvest',
      name: 'harvest_snack_error',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get harvest_form_error_required {
    return Intl.message(
      'Required',
      name: 'harvest_form_error_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid (> 0)`
  String get harvest_form_error_positive {
    return Intl.message(
      'Invalid (> 0)',
      name: 'harvest_form_error_positive',
      desc: '',
      args: [],
    );
  }

  /// `Invalid (>= 0)`
  String get harvest_form_error_positive_or_zero {
    return Intl.message(
      'Invalid (>= 0)',
      name: 'harvest_form_error_positive_or_zero',
      desc: '',
      args: [],
    );
  }

  /// `Step-by-step`
  String get planting_steps_title {
    return Intl.message(
      'Step-by-step',
      name: 'planting_steps_title',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get planting_steps_add_button {
    return Intl.message(
      'Add',
      name: 'planting_steps_add_button',
      desc: '',
      args: [],
    );
  }

  /// `See less`
  String get planting_steps_see_less {
    return Intl.message(
      'See less',
      name: 'planting_steps_see_less',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get planting_steps_see_all {
    return Intl.message(
      'See all',
      name: 'planting_steps_see_all',
      desc: '',
      args: [],
    );
  }

  /// `No recommended steps`
  String get planting_steps_empty {
    return Intl.message(
      'No recommended steps',
      name: 'planting_steps_empty',
      desc: '',
      args: [],
    );
  }

  /// `+ {count} more steps`
  String planting_steps_more(Object count) {
    return Intl.message(
      '+ $count more steps',
      name: 'planting_steps_more',
      desc: '',
      args: [count],
    );
  }

  /// `Prediction`
  String get planting_steps_prediction_badge {
    return Intl.message(
      'Prediction',
      name: 'planting_steps_prediction_badge',
      desc: '',
      args: [],
    );
  }

  /// `On {date}`
  String planting_steps_date_prefix(Object date) {
    return Intl.message(
      'On $date',
      name: 'planting_steps_date_prefix',
      desc: '',
      args: [date],
    );
  }

  /// `Done`
  String get planting_steps_done {
    return Intl.message(
      'Done',
      name: 'planting_steps_done',
      desc: '',
      args: [],
    );
  }

  /// `Mark Done`
  String get planting_steps_mark_done {
    return Intl.message(
      'Mark Done',
      name: 'planting_steps_mark_done',
      desc: '',
      args: [],
    );
  }

  /// `Add Step`
  String get planting_steps_dialog_title {
    return Intl.message(
      'Add Step',
      name: 'planting_steps_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Ex: Light mulching`
  String get planting_steps_dialog_hint {
    return Intl.message(
      'Ex: Light mulching',
      name: 'planting_steps_dialog_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get planting_steps_dialog_add {
    return Intl.message(
      'Add',
      name: 'planting_steps_dialog_add',
      desc: '',
      args: [],
    );
  }

  /// `Sown`
  String get planting_status_sown {
    return Intl.message(
      'Sown',
      name: 'planting_status_sown',
      desc: '',
      args: [],
    );
  }

  /// `Planted`
  String get planting_status_planted {
    return Intl.message(
      'Planted',
      name: 'planting_status_planted',
      desc: '',
      args: [],
    );
  }

  /// `Growing`
  String get planting_status_growing {
    return Intl.message(
      'Growing',
      name: 'planting_status_growing',
      desc: '',
      args: [],
    );
  }

  /// `Ready to harvest`
  String get planting_status_ready {
    return Intl.message(
      'Ready to harvest',
      name: 'planting_status_ready',
      desc: '',
      args: [],
    );
  }

  /// `Harvested`
  String get planting_status_harvested {
    return Intl.message(
      'Harvested',
      name: 'planting_status_harvested',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get planting_status_failed {
    return Intl.message(
      'Failed',
      name: 'planting_status_failed',
      desc: '',
      args: [],
    );
  }

  /// `Sown on {date}`
  String planting_card_sown_date(Object date) {
    return Intl.message(
      'Sown on $date',
      name: 'planting_card_sown_date',
      desc: '',
      args: [date],
    );
  }

  /// `Planted on {date}`
  String planting_card_planted_date(Object date) {
    return Intl.message(
      'Planted on $date',
      name: 'planting_card_planted_date',
      desc: '',
      args: [date],
    );
  }

  /// `Est. harvest: {date}`
  String planting_card_harvest_estimate(Object date) {
    return Intl.message(
      'Est. harvest: $date',
      name: 'planting_card_harvest_estimate',
      desc: '',
      args: [date],
    );
  }

  /// `Botanical Info`
  String get planting_info_title {
    return Intl.message(
      'Botanical Info',
      name: 'planting_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Growing Tips`
  String get planting_info_tips_title {
    return Intl.message(
      'Growing Tips',
      name: 'planting_info_tips_title',
      desc: '',
      args: [],
    );
  }

  /// `Maturity`
  String get planting_info_maturity {
    return Intl.message(
      'Maturity',
      name: 'planting_info_maturity',
      desc: '',
      args: [],
    );
  }

  /// `{days} days`
  String planting_info_days(Object days) {
    return Intl.message(
      '$days days',
      name: 'planting_info_days',
      desc: '',
      args: [days],
    );
  }

  /// `Spacing`
  String get planting_info_spacing {
    return Intl.message(
      'Spacing',
      name: 'planting_info_spacing',
      desc: '',
      args: [],
    );
  }

  /// `{cm} cm`
  String planting_info_cm(Object cm) {
    return Intl.message(
      '$cm cm',
      name: 'planting_info_cm',
      desc: '',
      args: [cm],
    );
  }

  /// `Depth`
  String get planting_info_depth {
    return Intl.message(
      'Depth',
      name: 'planting_info_depth',
      desc: '',
      args: [],
    );
  }

  /// `Exposure`
  String get planting_info_exposure {
    return Intl.message(
      'Exposure',
      name: 'planting_info_exposure',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get planting_info_water {
    return Intl.message(
      'Water',
      name: 'planting_info_water',
      desc: '',
      args: [],
    );
  }

  /// `Planting Season`
  String get planting_info_season {
    return Intl.message(
      'Planting Season',
      name: 'planting_info_season',
      desc: '',
      args: [],
    );
  }

  /// `Scientific name not available`
  String get planting_info_scientific_name_none {
    return Intl.message(
      'Scientific name not available',
      name: 'planting_info_scientific_name_none',
      desc: '',
      args: [],
    );
  }

  /// `Culture Information`
  String get planting_info_culture_title {
    return Intl.message(
      'Culture Information',
      name: 'planting_info_culture_title',
      desc: '',
      args: [],
    );
  }

  /// `Germination time`
  String get planting_info_germination {
    return Intl.message(
      'Germination time',
      name: 'planting_info_germination',
      desc: '',
      args: [],
    );
  }

  /// `Harvest time`
  String get planting_info_harvest_time {
    return Intl.message(
      'Harvest time',
      name: 'planting_info_harvest_time',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get planting_info_none {
    return Intl.message(
      'Not specified',
      name: 'planting_info_none',
      desc: '',
      args: [],
    );
  }

  /// `No tips available`
  String get planting_tips_none {
    return Intl.message(
      'No tips available',
      name: 'planting_tips_none',
      desc: '',
      args: [],
    );
  }

  /// `Action History`
  String get planting_history_title {
    return Intl.message(
      'Action History',
      name: 'planting_history_title',
      desc: '',
      args: [],
    );
  }

  /// `Planting`
  String get planting_history_action_planting {
    return Intl.message(
      'Planting',
      name: 'planting_history_action_planting',
      desc: '',
      args: [],
    );
  }

  /// `Detailed history coming soon`
  String get planting_history_todo {
    return Intl.message(
      'Detailed history coming soon',
      name: 'planting_history_todo',
      desc: '',
      args: [],
    );
  }

  /// `Full sun`
  String get info_exposure_full_sun {
    return Intl.message(
      'Full sun',
      name: 'info_exposure_full_sun',
      desc: '',
      args: [],
    );
  }

  /// `Partial sun`
  String get info_exposure_partial_sun {
    return Intl.message(
      'Partial sun',
      name: 'info_exposure_partial_sun',
      desc: '',
      args: [],
    );
  }

  /// `Shade`
  String get info_exposure_shade {
    return Intl.message(
      'Shade',
      name: 'info_exposure_shade',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get info_water_low {
    return Intl.message(
      'Low',
      name: 'info_water_low',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get info_water_medium {
    return Intl.message(
      'Medium',
      name: 'info_water_medium',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get info_water_high {
    return Intl.message(
      'High',
      name: 'info_water_high',
      desc: '',
      args: [],
    );
  }

  /// `Moderate`
  String get info_water_moderate {
    return Intl.message(
      'Moderate',
      name: 'info_water_moderate',
      desc: '',
      args: [],
    );
  }

  /// `Spring`
  String get info_season_spring {
    return Intl.message(
      'Spring',
      name: 'info_season_spring',
      desc: '',
      args: [],
    );
  }

  /// `Summer`
  String get info_season_summer {
    return Intl.message(
      'Summer',
      name: 'info_season_summer',
      desc: '',
      args: [],
    );
  }

  /// `Autumn`
  String get info_season_autumn {
    return Intl.message(
      'Autumn',
      name: 'info_season_autumn',
      desc: '',
      args: [],
    );
  }

  /// `Winter`
  String get info_season_winter {
    return Intl.message(
      'Winter',
      name: 'info_season_winter',
      desc: '',
      args: [],
    );
  }

  /// `All seasons`
  String get info_season_all {
    return Intl.message(
      'All seasons',
      name: 'info_season_all',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate`
  String get common_duplicate {
    return Intl.message(
      'Duplicate',
      name: 'common_duplicate',
      desc: '',
      args: [],
    );
  }

  /// `Delete Planting`
  String get planting_delete_title {
    return Intl.message(
      'Delete Planting',
      name: 'planting_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this planting? This action is irreversible.`
  String get planting_delete_confirm_body {
    return Intl.message(
      'Are you sure you want to delete this planting? This action is irreversible.',
      name: 'planting_delete_confirm_body',
      desc: '',
      args: [],
    );
  }

  /// `New Planting`
  String get planting_creation_title {
    return Intl.message(
      'New Planting',
      name: 'planting_creation_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit Planting`
  String get planting_creation_title_edit {
    return Intl.message(
      'Edit Planting',
      name: 'planting_creation_title_edit',
      desc: '',
      args: [],
    );
  }

  /// `Number of seeds`
  String get planting_quantity_seeds {
    return Intl.message(
      'Number of seeds',
      name: 'planting_quantity_seeds',
      desc: '',
      args: [],
    );
  }

  /// `Number of plants`
  String get planting_quantity_plants {
    return Intl.message(
      'Number of plants',
      name: 'planting_quantity_plants',
      desc: '',
      args: [],
    );
  }

  /// `Quantity is required`
  String get planting_quantity_required {
    return Intl.message(
      'Quantity is required',
      name: 'planting_quantity_required',
      desc: '',
      args: [],
    );
  }

  /// `Quantity must be a positive number`
  String get planting_quantity_positive {
    return Intl.message(
      'Quantity must be a positive number',
      name: 'planting_quantity_positive',
      desc: '',
      args: [],
    );
  }

  /// `Plant: {plantName}`
  String planting_plant_selection_label(Object plantName) {
    return Intl.message(
      'Plant: $plantName',
      name: 'planting_plant_selection_label',
      desc: '',
      args: [plantName],
    );
  }

  /// `No plant selected`
  String get planting_no_plant_selected {
    return Intl.message(
      'No plant selected',
      name: 'planting_no_plant_selected',
      desc: '',
      args: [],
    );
  }

  /// `Custom Plant`
  String get planting_custom_plant_title {
    return Intl.message(
      'Custom Plant',
      name: 'planting_custom_plant_title',
      desc: '',
      args: [],
    );
  }

  /// `Plant Name`
  String get planting_plant_name_label {
    return Intl.message(
      'Plant Name',
      name: 'planting_plant_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Ex: Cherry Tomato`
  String get planting_plant_name_hint {
    return Intl.message(
      'Ex: Cherry Tomato',
      name: 'planting_plant_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Plant name is required`
  String get planting_plant_name_required {
    return Intl.message(
      'Plant name is required',
      name: 'planting_plant_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Notes (optional)`
  String get planting_notes_label {
    return Intl.message(
      'Notes (optional)',
      name: 'planting_notes_label',
      desc: '',
      args: [],
    );
  }

  /// `Additional information...`
  String get planting_notes_hint {
    return Intl.message(
      'Additional information...',
      name: 'planting_notes_hint',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get planting_tips_title {
    return Intl.message(
      'Tips',
      name: 'planting_tips_title',
      desc: '',
      args: [],
    );
  }

  /// `• Use the catalog to select a plant.`
  String get planting_tips_catalog {
    return Intl.message(
      '• Use the catalog to select a plant.',
      name: 'planting_tips_catalog',
      desc: '',
      args: [],
    );
  }

  /// `• Choose "Sown" for seeds, "Planted" for seedlings.`
  String get planting_tips_type {
    return Intl.message(
      '• Choose "Sown" for seeds, "Planted" for seedlings.',
      name: 'planting_tips_type',
      desc: '',
      args: [],
    );
  }

  /// `• Add notes to track special conditions.`
  String get planting_tips_notes {
    return Intl.message(
      '• Add notes to track special conditions.',
      name: 'planting_tips_notes',
      desc: '',
      args: [],
    );
  }

  /// `Planting date cannot be in the future`
  String get planting_date_future_error {
    return Intl.message(
      'Planting date cannot be in the future',
      name: 'planting_date_future_error',
      desc: '',
      args: [],
    );
  }

  /// `Planting created successfully`
  String get planting_success_create {
    return Intl.message(
      'Planting created successfully',
      name: 'planting_success_create',
      desc: '',
      args: [],
    );
  }

  /// `Planting updated successfully`
  String get planting_success_update {
    return Intl.message(
      'Planting updated successfully',
      name: 'planting_success_update',
      desc: '',
      args: [],
    );
  }

  /// `Activities & History`
  String get activity_screen_title {
    return Intl.message(
      'Activities & History',
      name: 'activity_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Recent ({gardenName})`
  String activity_tab_recent_garden(Object gardenName) {
    return Intl.message(
      'Recent ($gardenName)',
      name: 'activity_tab_recent_garden',
      desc: '',
      args: [gardenName],
    );
  }

  /// `Recent (Global)`
  String get activity_tab_recent_global {
    return Intl.message(
      'Recent (Global)',
      name: 'activity_tab_recent_global',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get activity_tab_history {
    return Intl.message(
      'History',
      name: 'activity_tab_history',
      desc: '',
      args: [],
    );
  }

  /// `History — `
  String get activity_history_section_title {
    return Intl.message(
      'History — ',
      name: 'activity_history_section_title',
      desc: '',
      args: [],
    );
  }

  /// `No garden selected.\nTo view a garden's history, long-press it from the dashboard.`
  String get activity_history_empty {
    return Intl.message(
      'No garden selected.\nTo view a garden\'s history, long-press it from the dashboard.',
      name: 'activity_history_empty',
      desc: '',
      args: [],
    );
  }

  /// `No activities found`
  String get activity_empty_title {
    return Intl.message(
      'No activities found',
      name: 'activity_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Gardening activities will appear here`
  String get activity_empty_subtitle {
    return Intl.message(
      'Gardening activities will appear here',
      name: 'activity_empty_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Error loading activities`
  String get activity_error_loading {
    return Intl.message(
      'Error loading activities',
      name: 'activity_error_loading',
      desc: '',
      args: [],
    );
  }

  /// `Important`
  String get activity_priority_important {
    return Intl.message(
      'Important',
      name: 'activity_priority_important',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get activity_priority_normal {
    return Intl.message(
      'Normal',
      name: 'activity_priority_normal',
      desc: '',
      args: [],
    );
  }

  /// `Just now`
  String get activity_time_just_now {
    return Intl.message(
      'Just now',
      name: 'activity_time_just_now',
      desc: '',
      args: [],
    );
  }

  /// `{minutes} min ago`
  String activity_time_minutes_ago(Object minutes) {
    return Intl.message(
      '$minutes min ago',
      name: 'activity_time_minutes_ago',
      desc: '',
      args: [minutes],
    );
  }

  /// `{hours} h ago`
  String activity_time_hours_ago(Object hours) {
    return Intl.message(
      '$hours h ago',
      name: 'activity_time_hours_ago',
      desc: '',
      args: [hours],
    );
  }

  /// `{count, plural, =1{1 day ago} other{{count} days ago}}`
  String activity_time_days_ago(num count) {
    return Intl.plural(
      count,
      one: '1 day ago',
      other: '$count days ago',
      name: 'activity_time_days_ago',
      desc: '',
      args: [count],
    );
  }

  /// `Garden: {name}`
  String activity_metadata_garden(Object name) {
    return Intl.message(
      'Garden: $name',
      name: 'activity_metadata_garden',
      desc: '',
      args: [name],
    );
  }

  /// `Plot: {name}`
  String activity_metadata_bed(Object name) {
    return Intl.message(
      'Plot: $name',
      name: 'activity_metadata_bed',
      desc: '',
      args: [name],
    );
  }

  /// `Plant: {name}`
  String activity_metadata_plant(Object name) {
    return Intl.message(
      'Plant: $name',
      name: 'activity_metadata_plant',
      desc: '',
      args: [name],
    );
  }

  /// `Quantity: {quantity}`
  String activity_metadata_quantity(Object quantity) {
    return Intl.message(
      'Quantity: $quantity',
      name: 'activity_metadata_quantity',
      desc: '',
      args: [quantity],
    );
  }

  /// `Date: {date}`
  String activity_metadata_date(Object date) {
    return Intl.message(
      'Date: $date',
      name: 'activity_metadata_date',
      desc: '',
      args: [date],
    );
  }

  /// `Maintenance: {type}`
  String activity_metadata_maintenance(Object type) {
    return Intl.message(
      'Maintenance: $type',
      name: 'activity_metadata_maintenance',
      desc: '',
      args: [type],
    );
  }

  /// `Weather: {weather}`
  String activity_metadata_weather(Object weather) {
    return Intl.message(
      'Weather: $weather',
      name: 'activity_metadata_weather',
      desc: '',
      args: [weather],
    );
  }

  /// `To view a garden's history`
  String get history_hint_title {
    return Intl.message(
      'To view a garden\'s history',
      name: 'history_hint_title',
      desc: '',
      args: [],
    );
  }

  /// `Select it by long-pressing from the dashboard.`
  String get history_hint_body {
    return Intl.message(
      'Select it by long-pressing from the dashboard.',
      name: 'history_hint_body',
      desc: '',
      args: [],
    );
  }

  /// `Go to dashboard`
  String get history_hint_action {
    return Intl.message(
      'Go to dashboard',
      name: 'history_hint_action',
      desc: '',
      args: [],
    );
  }

  /// `Garden "{name}" created`
  String activity_desc_garden_created(Object name) {
    return Intl.message(
      'Garden "$name" created',
      name: 'activity_desc_garden_created',
      desc: '',
      args: [name],
    );
  }

  /// `Bed "{name}" created`
  String activity_desc_bed_created(Object name) {
    return Intl.message(
      'Bed "$name" created',
      name: 'activity_desc_bed_created',
      desc: '',
      args: [name],
    );
  }

  /// `Planting of "{name}" added`
  String activity_desc_planting_created(Object name) {
    return Intl.message(
      'Planting of "$name" added',
      name: 'activity_desc_planting_created',
      desc: '',
      args: [name],
    );
  }

  /// `Germination of "{name}" confirmed`
  String activity_desc_germination(Object name) {
    return Intl.message(
      'Germination of "$name" confirmed',
      name: 'activity_desc_germination',
      desc: '',
      args: [name],
    );
  }

  /// `Harvest of "{name}" recorded`
  String activity_desc_harvest(Object name) {
    return Intl.message(
      'Harvest of "$name" recorded',
      name: 'activity_desc_harvest',
      desc: '',
      args: [name],
    );
  }

  /// `Maintenance: {type}`
  String activity_desc_maintenance(Object type) {
    return Intl.message(
      'Maintenance: $type',
      name: 'activity_desc_maintenance',
      desc: '',
      args: [type],
    );
  }

  /// `Garden "{name}" deleted`
  String activity_desc_garden_deleted(Object name) {
    return Intl.message(
      'Garden "$name" deleted',
      name: 'activity_desc_garden_deleted',
      desc: '',
      args: [name],
    );
  }

  /// `Bed "{name}" deleted`
  String activity_desc_bed_deleted(Object name) {
    return Intl.message(
      'Bed "$name" deleted',
      name: 'activity_desc_bed_deleted',
      desc: '',
      args: [name],
    );
  }

  /// `Planting of "{name}" deleted`
  String activity_desc_planting_deleted(Object name) {
    return Intl.message(
      'Planting of "$name" deleted',
      name: 'activity_desc_planting_deleted',
      desc: '',
      args: [name],
    );
  }

  /// `Garden "{name}" updated`
  String activity_desc_garden_updated(Object name) {
    return Intl.message(
      'Garden "$name" updated',
      name: 'activity_desc_garden_updated',
      desc: '',
      args: [name],
    );
  }

  /// `Bed "{name}" updated`
  String activity_desc_bed_updated(Object name) {
    return Intl.message(
      'Bed "$name" updated',
      name: 'activity_desc_bed_updated',
      desc: '',
      args: [name],
    );
  }

  /// `Planting of "{name}" updated`
  String activity_desc_planting_updated(Object name) {
    return Intl.message(
      'Planting of "$name" updated',
      name: 'activity_desc_planting_updated',
      desc: '',
      args: [name],
    );
  }

  /// `Statistics`
  String get stats_screen_title {
    return Intl.message(
      'Statistics',
      name: 'stats_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Analyze in real-time and export your data.`
  String get stats_screen_subtitle {
    return Intl.message(
      'Analyze in real-time and export your data.',
      name: 'stats_screen_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Living Alignment`
  String get kpi_alignment_title {
    return Intl.message(
      'Living Alignment',
      name: 'kpi_alignment_title',
      desc: '',
      args: [],
    );
  }

  /// `This tool evaluates how closely your sowing, planting, and harvesting align with the ideal windows recommended by the Intelligent Agenda.`
  String get kpi_alignment_description {
    return Intl.message(
      'This tool evaluates how closely your sowing, planting, and harvesting align with the ideal windows recommended by the Intelligent Agenda.',
      name: 'kpi_alignment_description',
      desc: '',
      args: [],
    );
  }

  /// `Start planting and harvesting to see your alignment!`
  String get kpi_alignment_cta {
    return Intl.message(
      'Start planting and harvesting to see your alignment!',
      name: 'kpi_alignment_cta',
      desc: '',
      args: [],
    );
  }

  /// `aligned`
  String get kpi_alignment_aligned {
    return Intl.message(
      'aligned',
      name: 'kpi_alignment_aligned',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get kpi_alignment_total {
    return Intl.message(
      'Total',
      name: 'kpi_alignment_total',
      desc: '',
      args: [],
    );
  }

  /// `Aligned`
  String get kpi_alignment_aligned_actions {
    return Intl.message(
      'Aligned',
      name: 'kpi_alignment_aligned_actions',
      desc: '',
      args: [],
    );
  }

  /// `Misaligned`
  String get kpi_alignment_misaligned_actions {
    return Intl.message(
      'Misaligned',
      name: 'kpi_alignment_misaligned_actions',
      desc: '',
      args: [],
    );
  }

  /// `Calculating alignment...`
  String get kpi_alignment_calculating {
    return Intl.message(
      'Calculating alignment...',
      name: 'kpi_alignment_calculating',
      desc: '',
      args: [],
    );
  }

  /// `Error during calculation`
  String get kpi_alignment_error {
    return Intl.message(
      'Error during calculation',
      name: 'kpi_alignment_error',
      desc: '',
      args: [],
    );
  }

  /// `Garden Economy`
  String get pillar_economy_title {
    return Intl.message(
      'Garden Economy',
      name: 'pillar_economy_title',
      desc: '',
      args: [],
    );
  }

  /// `Nutritional Balance`
  String get pillar_nutrition_title {
    return Intl.message(
      'Nutritional Balance',
      name: 'pillar_nutrition_title',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get pillar_export_title {
    return Intl.message(
      'Export',
      name: 'pillar_export_title',
      desc: '',
      args: [],
    );
  }

  /// `Total harvest value`
  String get pillar_economy_label {
    return Intl.message(
      'Total harvest value',
      name: 'pillar_economy_label',
      desc: '',
      args: [],
    );
  }

  /// `Nutritional Signature`
  String get pillar_nutrition_label {
    return Intl.message(
      'Nutritional Signature',
      name: 'pillar_nutrition_label',
      desc: '',
      args: [],
    );
  }

  /// `Retrieve your data`
  String get pillar_export_label {
    return Intl.message(
      'Retrieve your data',
      name: 'pillar_export_label',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get pillar_export_button {
    return Intl.message(
      'Export',
      name: 'pillar_export_button',
      desc: '',
      args: [],
    );
  }

  /// `Garden Economy`
  String get stats_economy_title {
    return Intl.message(
      'Garden Economy',
      name: 'stats_economy_title',
      desc: '',
      args: [],
    );
  }

  /// `No harvest in the selected period.`
  String get stats_economy_no_harvest {
    return Intl.message(
      'No harvest in the selected period.',
      name: 'stats_economy_no_harvest',
      desc: '',
      args: [],
    );
  }

  /// `No data for the selected period.`
  String get stats_economy_no_harvest_desc {
    return Intl.message(
      'No data for the selected period.',
      name: 'stats_economy_no_harvest_desc',
      desc: '',
      args: [],
    );
  }

  /// `Total Revenue`
  String get stats_kpi_total_revenue {
    return Intl.message(
      'Total Revenue',
      name: 'stats_kpi_total_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Total Volume`
  String get stats_kpi_total_volume {
    return Intl.message(
      'Total Volume',
      name: 'stats_kpi_total_volume',
      desc: '',
      args: [],
    );
  }

  /// `Average Price`
  String get stats_kpi_avg_price {
    return Intl.message(
      'Average Price',
      name: 'stats_kpi_avg_price',
      desc: '',
      args: [],
    );
  }

  /// `Top Crops (Value)`
  String get stats_top_cultures_title {
    return Intl.message(
      'Top Crops (Value)',
      name: 'stats_top_cultures_title',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get stats_top_cultures_no_data {
    return Intl.message(
      'No data',
      name: 'stats_top_cultures_no_data',
      desc: '',
      args: [],
    );
  }

  /// `of revenue`
  String get stats_top_cultures_percent_revenue {
    return Intl.message(
      'of revenue',
      name: 'stats_top_cultures_percent_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Revenue`
  String get stats_monthly_revenue_title {
    return Intl.message(
      'Monthly Revenue',
      name: 'stats_monthly_revenue_title',
      desc: '',
      args: [],
    );
  }

  /// `No monthly data`
  String get stats_monthly_revenue_no_data {
    return Intl.message(
      'No monthly data',
      name: 'stats_monthly_revenue_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Dominant Crop by Month`
  String get stats_dominant_culture_title {
    return Intl.message(
      'Dominant Crop by Month',
      name: 'stats_dominant_culture_title',
      desc: '',
      args: [],
    );
  }

  /// `Annual Trend`
  String get stats_annual_evolution_title {
    return Intl.message(
      'Annual Trend',
      name: 'stats_annual_evolution_title',
      desc: '',
      args: [],
    );
  }

  /// `Crop Distribution`
  String get stats_crop_distribution_title {
    return Intl.message(
      'Crop Distribution',
      name: 'stats_crop_distribution_title',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get stats_crop_distribution_others {
    return Intl.message(
      'Others',
      name: 'stats_crop_distribution_others',
      desc: '',
      args: [],
    );
  }

  /// `Key Garden Months`
  String get stats_key_months_title {
    return Intl.message(
      'Key Garden Months',
      name: 'stats_key_months_title',
      desc: '',
      args: [],
    );
  }

  /// `Most Profitable`
  String get stats_most_profitable {
    return Intl.message(
      'Most Profitable',
      name: 'stats_most_profitable',
      desc: '',
      args: [],
    );
  }

  /// `Least Profitable`
  String get stats_least_profitable {
    return Intl.message(
      'Least Profitable',
      name: 'stats_least_profitable',
      desc: '',
      args: [],
    );
  }

  /// `Auto Summary`
  String get stats_auto_summary_title {
    return Intl.message(
      'Auto Summary',
      name: 'stats_auto_summary_title',
      desc: '',
      args: [],
    );
  }

  /// `Revenue History`
  String get stats_revenue_history_title {
    return Intl.message(
      'Revenue History',
      name: 'stats_revenue_history_title',
      desc: '',
      args: [],
    );
  }

  /// `Profitability Cycle`
  String get stats_profitability_cycle_title {
    return Intl.message(
      'Profitability Cycle',
      name: 'stats_profitability_cycle_title',
      desc: '',
      args: [],
    );
  }

  /// `Crop`
  String get stats_table_crop {
    return Intl.message(
      'Crop',
      name: 'stats_table_crop',
      desc: '',
      args: [],
    );
  }

  /// `Days (Avg)`
  String get stats_table_days {
    return Intl.message(
      'Days (Avg)',
      name: 'stats_table_days',
      desc: '',
      args: [],
    );
  }

  /// `Rev/Harvest`
  String get stats_table_revenue {
    return Intl.message(
      'Rev/Harvest',
      name: 'stats_table_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get stats_table_type {
    return Intl.message(
      'Type',
      name: 'stats_table_type',
      desc: '',
      args: [],
    );
  }

  /// `Fast`
  String get stats_type_fast {
    return Intl.message(
      'Fast',
      name: 'stats_type_fast',
      desc: '',
      args: [],
    );
  }

  /// `Long Term`
  String get stats_type_long_term {
    return Intl.message(
      'Long Term',
      name: 'stats_type_long_term',
      desc: '',
      args: [],
    );
  }

  /// `Nutrition Signature`
  String get nutrition_page_title {
    return Intl.message(
      'Nutrition Signature',
      name: 'nutrition_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Seasonal Dynamics`
  String get nutrition_seasonal_dynamics_title {
    return Intl.message(
      'Seasonal Dynamics',
      name: 'nutrition_seasonal_dynamics_title',
      desc: '',
      args: [],
    );
  }

  /// `Explore the mineral and vitamin production of your garden, month by month.`
  String get nutrition_seasonal_dynamics_desc {
    return Intl.message(
      'Explore the mineral and vitamin production of your garden, month by month.',
      name: 'nutrition_seasonal_dynamics_desc',
      desc: '',
      args: [],
    );
  }

  /// `No harvest this month`
  String get nutrition_no_harvest_month {
    return Intl.message(
      'No harvest this month',
      name: 'nutrition_no_harvest_month',
      desc: '',
      args: [],
    );
  }

  /// `Structure & Major Minerals`
  String get nutrition_major_minerals_title {
    return Intl.message(
      'Structure & Major Minerals',
      name: 'nutrition_major_minerals_title',
      desc: '',
      args: [],
    );
  }

  /// `Vitality & Trace Elements`
  String get nutrition_trace_elements_title {
    return Intl.message(
      'Vitality & Trace Elements',
      name: 'nutrition_trace_elements_title',
      desc: '',
      args: [],
    );
  }

  /// `No data for this period`
  String get nutrition_no_data_period {
    return Intl.message(
      'No data for this period',
      name: 'nutrition_no_data_period',
      desc: '',
      args: [],
    );
  }

  /// `No major minerals`
  String get nutrition_no_major_minerals {
    return Intl.message(
      'No major minerals',
      name: 'nutrition_no_major_minerals',
      desc: '',
      args: [],
    );
  }

  /// `No trace elements`
  String get nutrition_no_trace_elements {
    return Intl.message(
      'No trace elements',
      name: 'nutrition_no_trace_elements',
      desc: '',
      args: [],
    );
  }

  /// `Dynamics of {month}`
  String nutrition_month_dynamics_title(Object month) {
    return Intl.message(
      'Dynamics of $month',
      name: 'nutrition_month_dynamics_title',
      desc: '',
      args: [month],
    );
  }

  /// `Dominant production:`
  String get nutrition_dominant_production {
    return Intl.message(
      'Dominant production:',
      name: 'nutrition_dominant_production',
      desc: '',
      args: [],
    );
  }

  /// `These nutrients come from your harvests of the month.`
  String get nutrition_nutrients_origin {
    return Intl.message(
      'These nutrients come from your harvests of the month.',
      name: 'nutrition_nutrients_origin',
      desc: '',
      args: [],
    );
  }

  /// `Calcium`
  String get nut_calcium {
    return Intl.message(
      'Calcium',
      name: 'nut_calcium',
      desc: '',
      args: [],
    );
  }

  /// `Potassium`
  String get nut_potassium {
    return Intl.message(
      'Potassium',
      name: 'nut_potassium',
      desc: '',
      args: [],
    );
  }

  /// `Magnesium`
  String get nut_magnesium {
    return Intl.message(
      'Magnesium',
      name: 'nut_magnesium',
      desc: '',
      args: [],
    );
  }

  /// `Iron`
  String get nut_iron {
    return Intl.message(
      'Iron',
      name: 'nut_iron',
      desc: '',
      args: [],
    );
  }

  /// `Zinc`
  String get nut_zinc {
    return Intl.message(
      'Zinc',
      name: 'nut_zinc',
      desc: '',
      args: [],
    );
  }

  /// `Manganese`
  String get nut_manganese {
    return Intl.message(
      'Manganese',
      name: 'nut_manganese',
      desc: '',
      args: [],
    );
  }

  /// `Vitamin C`
  String get nut_vitamin_c {
    return Intl.message(
      'Vitamin C',
      name: 'nut_vitamin_c',
      desc: '',
      args: [],
    );
  }

  /// `Fiber`
  String get nut_fiber {
    return Intl.message(
      'Fiber',
      name: 'nut_fiber',
      desc: '',
      args: [],
    );
  }

  /// `Protein`
  String get nut_protein {
    return Intl.message(
      'Protein',
      name: 'nut_protein',
      desc: '',
      args: [],
    );
  }

  /// `Export Builder`
  String get export_builder_title {
    return Intl.message(
      'Export Builder',
      name: 'export_builder_title',
      desc: '',
      args: [],
    );
  }

  /// `1. Scope`
  String get export_scope_section {
    return Intl.message(
      '1. Scope',
      name: 'export_scope_section',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get export_scope_period {
    return Intl.message(
      'Period',
      name: 'export_scope_period',
      desc: '',
      args: [],
    );
  }

  /// `All History`
  String get export_scope_period_all {
    return Intl.message(
      'All History',
      name: 'export_scope_period_all',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Garden`
  String get export_filter_garden_title {
    return Intl.message(
      'Filter by Garden',
      name: 'export_filter_garden_title',
      desc: '',
      args: [],
    );
  }

  /// `All Gardens`
  String get export_filter_garden_all {
    return Intl.message(
      'All Gardens',
      name: 'export_filter_garden_all',
      desc: '',
      args: [],
    );
  }

  /// `{count} garden(s) selected`
  String export_filter_garden_count(Object count) {
    return Intl.message(
      '$count garden(s) selected',
      name: 'export_filter_garden_count',
      desc: '',
      args: [count],
    );
  }

  /// `Edit selection`
  String get export_filter_garden_edit {
    return Intl.message(
      'Edit selection',
      name: 'export_filter_garden_edit',
      desc: '',
      args: [],
    );
  }

  /// `Select Gardens`
  String get export_filter_garden_select_dialog_title {
    return Intl.message(
      'Select Gardens',
      name: 'export_filter_garden_select_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `2. Data Blocks`
  String get export_blocks_section {
    return Intl.message(
      '2. Data Blocks',
      name: 'export_blocks_section',
      desc: '',
      args: [],
    );
  }

  /// `Activities (Journal)`
  String get export_block_activity {
    return Intl.message(
      'Activities (Journal)',
      name: 'export_block_activity',
      desc: '',
      args: [],
    );
  }

  /// `Harvests (Production)`
  String get export_block_harvest {
    return Intl.message(
      'Harvests (Production)',
      name: 'export_block_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Gardens (Structure)`
  String get export_block_garden {
    return Intl.message(
      'Gardens (Structure)',
      name: 'export_block_garden',
      desc: '',
      args: [],
    );
  }

  /// `Plots (Structure)`
  String get export_block_garden_bed {
    return Intl.message(
      'Plots (Structure)',
      name: 'export_block_garden_bed',
      desc: '',
      args: [],
    );
  }

  /// `Plants (Catalog)`
  String get export_block_plant {
    return Intl.message(
      'Plants (Catalog)',
      name: 'export_block_plant',
      desc: '',
      args: [],
    );
  }

  /// `Complete history of interventions and events`
  String get export_block_desc_activity {
    return Intl.message(
      'Complete history of interventions and events',
      name: 'export_block_desc_activity',
      desc: '',
      args: [],
    );
  }

  /// `Production data and yields`
  String get export_block_desc_harvest {
    return Intl.message(
      'Production data and yields',
      name: 'export_block_desc_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Metadata of selected gardens`
  String get export_block_desc_garden {
    return Intl.message(
      'Metadata of selected gardens',
      name: 'export_block_desc_garden',
      desc: '',
      args: [],
    );
  }

  /// `Plot details (area, orientation...)`
  String get export_block_desc_garden_bed {
    return Intl.message(
      'Plot details (area, orientation...)',
      name: 'export_block_desc_garden_bed',
      desc: '',
      args: [],
    );
  }

  /// `List of used plants`
  String get export_block_desc_plant {
    return Intl.message(
      'List of used plants',
      name: 'export_block_desc_plant',
      desc: '',
      args: [],
    );
  }

  /// `3. Details & Columns`
  String get export_columns_section {
    return Intl.message(
      '3. Details & Columns',
      name: 'export_columns_section',
      desc: '',
      args: [],
    );
  }

  /// `{count} columns selected`
  String export_columns_count(Object count) {
    return Intl.message(
      '$count columns selected',
      name: 'export_columns_count',
      desc: '',
      args: [count],
    );
  }

  /// `4. File Format`
  String get export_format_section {
    return Intl.message(
      '4. File Format',
      name: 'export_format_section',
      desc: '',
      args: [],
    );
  }

  /// `Separate Sheets (Standard)`
  String get export_format_separate {
    return Intl.message(
      'Separate Sheets (Standard)',
      name: 'export_format_separate',
      desc: '',
      args: [],
    );
  }

  /// `One sheet per data type (Recommended)`
  String get export_format_separate_subtitle {
    return Intl.message(
      'One sheet per data type (Recommended)',
      name: 'export_format_separate_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Single Table (Flat / BI)`
  String get export_format_flat {
    return Intl.message(
      'Single Table (Flat / BI)',
      name: 'export_format_flat',
      desc: '',
      args: [],
    );
  }

  /// `One large table for Pivot Tables`
  String get export_format_flat_subtitle {
    return Intl.message(
      'One large table for Pivot Tables',
      name: 'export_format_flat_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Generate Excel Export`
  String get export_action_generate {
    return Intl.message(
      'Generate Excel Export',
      name: 'export_action_generate',
      desc: '',
      args: [],
    );
  }

  /// `Generating...`
  String get export_generating {
    return Intl.message(
      'Generating...',
      name: 'export_generating',
      desc: '',
      args: [],
    );
  }

  /// `Export Complete`
  String get export_success_title {
    return Intl.message(
      'Export Complete',
      name: 'export_success_title',
      desc: '',
      args: [],
    );
  }

  /// `Here is your PermaCalendar export`
  String get export_success_share_text {
    return Intl.message(
      'Here is your PermaCalendar export',
      name: 'export_success_share_text',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String export_error_snack(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'export_error_snack',
      desc: '',
      args: [error],
    );
  }

  /// `Garden Name`
  String get export_field_garden_name {
    return Intl.message(
      'Garden Name',
      name: 'export_field_garden_name',
      desc: '',
      args: [],
    );
  }

  /// `Garden ID`
  String get export_field_garden_id {
    return Intl.message(
      'Garden ID',
      name: 'export_field_garden_id',
      desc: '',
      args: [],
    );
  }

  /// `Area (m²)`
  String get export_field_garden_surface {
    return Intl.message(
      'Area (m²)',
      name: 'export_field_garden_surface',
      desc: '',
      args: [],
    );
  }

  /// `Creation Date`
  String get export_field_garden_creation {
    return Intl.message(
      'Creation Date',
      name: 'export_field_garden_creation',
      desc: '',
      args: [],
    );
  }

  /// `Plot Name`
  String get export_field_bed_name {
    return Intl.message(
      'Plot Name',
      name: 'export_field_bed_name',
      desc: '',
      args: [],
    );
  }

  /// `Plot ID`
  String get export_field_bed_id {
    return Intl.message(
      'Plot ID',
      name: 'export_field_bed_id',
      desc: '',
      args: [],
    );
  }

  /// `Area (m²)`
  String get export_field_bed_surface {
    return Intl.message(
      'Area (m²)',
      name: 'export_field_bed_surface',
      desc: '',
      args: [],
    );
  }

  /// `Plant Count`
  String get export_field_bed_plant_count {
    return Intl.message(
      'Plant Count',
      name: 'export_field_bed_plant_count',
      desc: '',
      args: [],
    );
  }

  /// `Common Name`
  String get export_field_plant_name {
    return Intl.message(
      'Common Name',
      name: 'export_field_plant_name',
      desc: '',
      args: [],
    );
  }

  /// `Plant ID`
  String get export_field_plant_id {
    return Intl.message(
      'Plant ID',
      name: 'export_field_plant_id',
      desc: '',
      args: [],
    );
  }

  /// `Scientific Name`
  String get export_field_plant_scientific {
    return Intl.message(
      'Scientific Name',
      name: 'export_field_plant_scientific',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get export_field_plant_family {
    return Intl.message(
      'Family',
      name: 'export_field_plant_family',
      desc: '',
      args: [],
    );
  }

  /// `Variety`
  String get export_field_plant_variety {
    return Intl.message(
      'Variety',
      name: 'export_field_plant_variety',
      desc: '',
      args: [],
    );
  }

  /// `Harvest Date`
  String get export_field_harvest_date {
    return Intl.message(
      'Harvest Date',
      name: 'export_field_harvest_date',
      desc: '',
      args: [],
    );
  }

  /// `Quantity (kg)`
  String get export_field_harvest_qty {
    return Intl.message(
      'Quantity (kg)',
      name: 'export_field_harvest_qty',
      desc: '',
      args: [],
    );
  }

  /// `Plant`
  String get export_field_harvest_plant_name {
    return Intl.message(
      'Plant',
      name: 'export_field_harvest_plant_name',
      desc: '',
      args: [],
    );
  }

  /// `Price/kg`
  String get export_field_harvest_price {
    return Intl.message(
      'Price/kg',
      name: 'export_field_harvest_price',
      desc: '',
      args: [],
    );
  }

  /// `Total Value`
  String get export_field_harvest_value {
    return Intl.message(
      'Total Value',
      name: 'export_field_harvest_value',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get export_field_harvest_notes {
    return Intl.message(
      'Notes',
      name: 'export_field_harvest_notes',
      desc: '',
      args: [],
    );
  }

  /// `Garden`
  String get export_field_harvest_garden_name {
    return Intl.message(
      'Garden',
      name: 'export_field_harvest_garden_name',
      desc: '',
      args: [],
    );
  }

  /// `Garden ID`
  String get export_field_harvest_garden_id {
    return Intl.message(
      'Garden ID',
      name: 'export_field_harvest_garden_id',
      desc: '',
      args: [],
    );
  }

  /// `Plot`
  String get export_field_harvest_bed_name {
    return Intl.message(
      'Plot',
      name: 'export_field_harvest_bed_name',
      desc: '',
      args: [],
    );
  }

  /// `Plot ID`
  String get export_field_harvest_bed_id {
    return Intl.message(
      'Plot ID',
      name: 'export_field_harvest_bed_id',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get export_field_activity_date {
    return Intl.message(
      'Date',
      name: 'export_field_activity_date',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get export_field_activity_type {
    return Intl.message(
      'Type',
      name: 'export_field_activity_type',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get export_field_activity_title {
    return Intl.message(
      'Title',
      name: 'export_field_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get export_field_activity_desc {
    return Intl.message(
      'Description',
      name: 'export_field_activity_desc',
      desc: '',
      args: [],
    );
  }

  /// `Target Entity`
  String get export_field_activity_entity {
    return Intl.message(
      'Target Entity',
      name: 'export_field_activity_entity',
      desc: '',
      args: [],
    );
  }

  /// `Target ID`
  String get export_field_activity_entity_id {
    return Intl.message(
      'Target ID',
      name: 'export_field_activity_entity_id',
      desc: '',
      args: [],
    );
  }

  /// `Garden Creation`
  String get export_activity_type_garden_created {
    return Intl.message(
      'Garden Creation',
      name: 'export_activity_type_garden_created',
      desc: '',
      args: [],
    );
  }

  /// `Garden Update`
  String get export_activity_type_garden_updated {
    return Intl.message(
      'Garden Update',
      name: 'export_activity_type_garden_updated',
      desc: '',
      args: [],
    );
  }

  /// `Garden Deletion`
  String get export_activity_type_garden_deleted {
    return Intl.message(
      'Garden Deletion',
      name: 'export_activity_type_garden_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Plot Creation`
  String get export_activity_type_bed_created {
    return Intl.message(
      'Plot Creation',
      name: 'export_activity_type_bed_created',
      desc: '',
      args: [],
    );
  }

  /// `Plot Update`
  String get export_activity_type_bed_updated {
    return Intl.message(
      'Plot Update',
      name: 'export_activity_type_bed_updated',
      desc: '',
      args: [],
    );
  }

  /// `Plot Deletion`
  String get export_activity_type_bed_deleted {
    return Intl.message(
      'Plot Deletion',
      name: 'export_activity_type_bed_deleted',
      desc: '',
      args: [],
    );
  }

  /// `New Planting`
  String get export_activity_type_planting_created {
    return Intl.message(
      'New Planting',
      name: 'export_activity_type_planting_created',
      desc: '',
      args: [],
    );
  }

  /// `Planting Update`
  String get export_activity_type_planting_updated {
    return Intl.message(
      'Planting Update',
      name: 'export_activity_type_planting_updated',
      desc: '',
      args: [],
    );
  }

  /// `Planting Deletion`
  String get export_activity_type_planting_deleted {
    return Intl.message(
      'Planting Deletion',
      name: 'export_activity_type_planting_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Harvest`
  String get export_activity_type_harvest {
    return Intl.message(
      'Harvest',
      name: 'export_activity_type_harvest',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get export_activity_type_maintenance {
    return Intl.message(
      'Maintenance',
      name: 'export_activity_type_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Weather`
  String get export_activity_type_weather {
    return Intl.message(
      'Weather',
      name: 'export_activity_type_weather',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get export_activity_type_error {
    return Intl.message(
      'Error',
      name: 'export_activity_type_error',
      desc: '',
      args: [],
    );
  }

  /// `TOTAL`
  String get export_excel_total {
    return Intl.message(
      'TOTAL',
      name: 'export_excel_total',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get export_excel_unknown {
    return Intl.message(
      'Unknown',
      name: 'export_excel_unknown',
      desc: '',
      args: [],
    );
  }

  /// ` (Advanced)`
  String get export_field_advanced_suffix {
    return Intl.message(
      ' (Advanced)',
      name: 'export_field_advanced_suffix',
      desc: '',
      args: [],
    );
  }

  /// `Name given to the garden`
  String get export_field_desc_garden_name {
    return Intl.message(
      'Name given to the garden',
      name: 'export_field_desc_garden_name',
      desc: '',
      args: [],
    );
  }

  /// `Unique technical identifier`
  String get export_field_desc_garden_id {
    return Intl.message(
      'Unique technical identifier',
      name: 'export_field_desc_garden_id',
      desc: '',
      args: [],
    );
  }

  /// `Total garden area`
  String get export_field_desc_garden_surface {
    return Intl.message(
      'Total garden area',
      name: 'export_field_desc_garden_surface',
      desc: '',
      args: [],
    );
  }

  /// `Creation date in the application`
  String get export_field_desc_garden_creation {
    return Intl.message(
      'Creation date in the application',
      name: 'export_field_desc_garden_creation',
      desc: '',
      args: [],
    );
  }

  /// `Name of the plot`
  String get export_field_desc_bed_name {
    return Intl.message(
      'Name of the plot',
      name: 'export_field_desc_bed_name',
      desc: '',
      args: [],
    );
  }

  /// `Unique technical identifier`
  String get export_field_desc_bed_id {
    return Intl.message(
      'Unique technical identifier',
      name: 'export_field_desc_bed_id',
      desc: '',
      args: [],
    );
  }

  /// `Surface area of the plot`
  String get export_field_desc_bed_surface {
    return Intl.message(
      'Surface area of the plot',
      name: 'export_field_desc_bed_surface',
      desc: '',
      args: [],
    );
  }

  /// `Number of crops in place (current)`
  String get export_field_desc_bed_plant_count {
    return Intl.message(
      'Number of crops in place (current)',
      name: 'export_field_desc_bed_plant_count',
      desc: '',
      args: [],
    );
  }

  /// `Common name of the plant`
  String get export_field_desc_plant_name {
    return Intl.message(
      'Common name of the plant',
      name: 'export_field_desc_plant_name',
      desc: '',
      args: [],
    );
  }

  /// `Unique technical identifier`
  String get export_field_desc_plant_id {
    return Intl.message(
      'Unique technical identifier',
      name: 'export_field_desc_plant_id',
      desc: '',
      args: [],
    );
  }

  /// `Botanical denomination`
  String get export_field_desc_plant_scientific {
    return Intl.message(
      'Botanical denomination',
      name: 'export_field_desc_plant_scientific',
      desc: '',
      args: [],
    );
  }

  /// `Botanical family`
  String get export_field_desc_plant_family {
    return Intl.message(
      'Botanical family',
      name: 'export_field_desc_plant_family',
      desc: '',
      args: [],
    );
  }

  /// `Specific variety`
  String get export_field_desc_plant_variety {
    return Intl.message(
      'Specific variety',
      name: 'export_field_desc_plant_variety',
      desc: '',
      args: [],
    );
  }

  /// `Date of the harvest event`
  String get export_field_desc_harvest_date {
    return Intl.message(
      'Date of the harvest event',
      name: 'export_field_desc_harvest_date',
      desc: '',
      args: [],
    );
  }

  /// `Harvested weight in kg`
  String get export_field_desc_harvest_qty {
    return Intl.message(
      'Harvested weight in kg',
      name: 'export_field_desc_harvest_qty',
      desc: '',
      args: [],
    );
  }

  /// `Name of the harvested plant`
  String get export_field_desc_harvest_plant_name {
    return Intl.message(
      'Name of the harvested plant',
      name: 'export_field_desc_harvest_plant_name',
      desc: '',
      args: [],
    );
  }

  /// `Configured price per kg`
  String get export_field_desc_harvest_price {
    return Intl.message(
      'Configured price per kg',
      name: 'export_field_desc_harvest_price',
      desc: '',
      args: [],
    );
  }

  /// `Quantity * Price/kg`
  String get export_field_desc_harvest_value {
    return Intl.message(
      'Quantity * Price/kg',
      name: 'export_field_desc_harvest_value',
      desc: '',
      args: [],
    );
  }

  /// `Observations entered during harvest`
  String get export_field_desc_harvest_notes {
    return Intl.message(
      'Observations entered during harvest',
      name: 'export_field_desc_harvest_notes',
      desc: '',
      args: [],
    );
  }

  /// `Name of the source garden (if available)`
  String get export_field_desc_harvest_garden_name {
    return Intl.message(
      'Name of the source garden (if available)',
      name: 'export_field_desc_harvest_garden_name',
      desc: '',
      args: [],
    );
  }

  /// `Unique garden identifier`
  String get export_field_desc_harvest_garden_id {
    return Intl.message(
      'Unique garden identifier',
      name: 'export_field_desc_harvest_garden_id',
      desc: '',
      args: [],
    );
  }

  /// `Source plot (if available)`
  String get export_field_desc_harvest_bed_name {
    return Intl.message(
      'Source plot (if available)',
      name: 'export_field_desc_harvest_bed_name',
      desc: '',
      args: [],
    );
  }

  /// `Plot identifier`
  String get export_field_desc_harvest_bed_id {
    return Intl.message(
      'Plot identifier',
      name: 'export_field_desc_harvest_bed_id',
      desc: '',
      args: [],
    );
  }

  /// `Date of the activity`
  String get export_field_desc_activity_date {
    return Intl.message(
      'Date of the activity',
      name: 'export_field_desc_activity_date',
      desc: '',
      args: [],
    );
  }

  /// `Action category (Sowing, Harvest, Care...)`
  String get export_field_desc_activity_type {
    return Intl.message(
      'Action category (Sowing, Harvest, Care...)',
      name: 'export_field_desc_activity_type',
      desc: '',
      args: [],
    );
  }

  /// `Summary of the action`
  String get export_field_desc_activity_title {
    return Intl.message(
      'Summary of the action',
      name: 'export_field_desc_activity_title',
      desc: '',
      args: [],
    );
  }

  /// `Complete details`
  String get export_field_desc_activity_desc {
    return Intl.message(
      'Complete details',
      name: 'export_field_desc_activity_desc',
      desc: '',
      args: [],
    );
  }

  /// `Name of the object concerned (Plant, Plot...)`
  String get export_field_desc_activity_entity {
    return Intl.message(
      'Name of the object concerned (Plant, Plot...)',
      name: 'export_field_desc_activity_entity',
      desc: '',
      args: [],
    );
  }

  /// `ID of the object concerned`
  String get export_field_desc_activity_entity_id {
    return Intl.message(
      'ID of the object concerned',
      name: 'export_field_desc_activity_entity_id',
      desc: '',
      args: [],
    );
  }

  /// `Sow`
  String get plant_catalog_sow {
    return Intl.message(
      'Sow',
      name: 'plant_catalog_sow',
      desc: 'Label for Sow button',
      args: [],
    );
  }

  /// `Plant`
  String get plant_catalog_plant {
    return Intl.message(
      'Plant',
      name: 'plant_catalog_plant',
      desc: 'Label for Plant button',
      args: [],
    );
  }

  /// `Show selection`
  String get plant_catalog_show_selection {
    return Intl.message(
      'Show selection',
      name: 'plant_catalog_show_selection',
      desc: 'Button to show selection',
      args: [],
    );
  }

  /// `Green only`
  String get plant_catalog_filter_green_only {
    return Intl.message(
      'Green only',
      name: 'plant_catalog_filter_green_only',
      desc: 'Filter green plants only',
      args: [],
    );
  }

  /// `Green + Orange`
  String get plant_catalog_filter_green_orange {
    return Intl.message(
      'Green + Orange',
      name: 'plant_catalog_filter_green_orange',
      desc: 'Filter green and orange plants',
      args: [],
    );
  }

  /// `All`
  String get plant_catalog_filter_all {
    return Intl.message(
      'All',
      name: 'plant_catalog_filter_all',
      desc: 'Filter all plants',
      args: [],
    );
  }

  /// `No plants recommended for this period.`
  String get plant_catalog_no_recommended {
    return Intl.message(
      'No plants recommended for this period.',
      name: 'plant_catalog_no_recommended',
      desc: 'Message when no plants are recommended',
      args: [],
    );
  }

  /// `Expand (±2 months)`
  String get plant_catalog_expand_window {
    return Intl.message(
      'Expand (±2 months)',
      name: 'plant_catalog_expand_window',
      desc: 'Action to expand time window',
      args: [],
    );
  }

  /// `Missing period data`
  String get plant_catalog_missing_period_data {
    return Intl.message(
      'Missing period data',
      name: 'plant_catalog_missing_period_data',
      desc: 'Message for missing period data',
      args: [],
    );
  }

  /// `Periods: {months}`
  String plant_catalog_periods_prefix(String months) {
    return Intl.message(
      'Periods: $months',
      name: 'plant_catalog_periods_prefix',
      desc: 'Prefix listing available periods',
      args: [months],
    );
  }

  /// `Ready this month`
  String get plant_catalog_legend_green {
    return Intl.message(
      'Ready this month',
      name: 'plant_catalog_legend_green',
      desc: 'Green legend',
      args: [],
    );
  }

  /// `Close / Soon`
  String get plant_catalog_legend_orange {
    return Intl.message(
      'Close / Soon',
      name: 'plant_catalog_legend_orange',
      desc: 'Orange legend',
      args: [],
    );
  }

  /// `Out of season`
  String get plant_catalog_legend_red {
    return Intl.message(
      'Out of season',
      name: 'plant_catalog_legend_red',
      desc: 'Red legend',
      args: [],
    );
  }

  /// `Unknown data`
  String get plant_catalog_data_unknown {
    return Intl.message(
      'Unknown data',
      name: 'plant_catalog_data_unknown',
      desc: 'Unknown data label',
      args: [],
    );
  }

  /// `Task Photo`
  String get task_editor_photo_label {
    return Intl.message(
      'Task Photo',
      name: 'task_editor_photo_label',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo`
  String get task_editor_photo_add {
    return Intl.message(
      'Add Photo',
      name: 'task_editor_photo_add',
      desc: '',
      args: [],
    );
  }

  /// `Change Photo`
  String get task_editor_photo_change {
    return Intl.message(
      'Change Photo',
      name: 'task_editor_photo_change',
      desc: '',
      args: [],
    );
  }

  /// `Remove Photo`
  String get task_editor_photo_remove {
    return Intl.message(
      'Remove Photo',
      name: 'task_editor_photo_remove',
      desc: '',
      args: [],
    );
  }

  /// `The photo will be automatically attached to PDF / Word upon creation / sending.`
  String get task_editor_photo_help {
    return Intl.message(
      'The photo will be automatically attached to PDF / Word upon creation / sending.',
      name: 'task_editor_photo_help',
      desc: '',
      args: [],
    );
  }

  /// `Backup & Restore`
  String get settings_backup_restore_section {
    return Intl.message(
      'Backup & Restore',
      name: 'settings_backup_restore_section',
      desc: '',
      args: [],
    );
  }

  /// `Full backup of your data`
  String get settings_backup_restore_subtitle {
    return Intl.message(
      'Full backup of your data',
      name: 'settings_backup_restore_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Backup`
  String get settings_backup_action {
    return Intl.message(
      'Create Backup',
      name: 'settings_backup_action',
      desc: '',
      args: [],
    );
  }

  /// `Restore Backup`
  String get settings_restore_action {
    return Intl.message(
      'Restore Backup',
      name: 'settings_restore_action',
      desc: '',
      args: [],
    );
  }

  /// `Creating Backup...`
  String get settings_backup_creating {
    return Intl.message(
      'Creating Backup...',
      name: 'settings_backup_creating',
      desc: '',
      args: [],
    );
  }

  /// `Backup created successfully!`
  String get settings_backup_success {
    return Intl.message(
      'Backup created successfully!',
      name: 'settings_backup_success',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get settings_restore_warning_title {
    return Intl.message(
      'Warning',
      name: 'settings_restore_warning_title',
      desc: '',
      args: [],
    );
  }

  /// `Restoring a backup will overwrite ALL current data (gardens, plantings, settings). This action is irreversible. The app will restart after restore.\n\nAre you sure you want to proceed?`
  String get settings_restore_warning_content {
    return Intl.message(
      'Restoring a backup will overwrite ALL current data (gardens, plantings, settings). This action is irreversible. The app will restart after restore.\n\nAre you sure you want to proceed?',
      name: 'settings_restore_warning_content',
      desc: '',
      args: [],
    );
  }

  /// `Restore successful! Please restart the app.`
  String get settings_restore_success {
    return Intl.message(
      'Restore successful! Please restart the app.',
      name: 'settings_restore_success',
      desc: '',
      args: [],
    );
  }

  /// `Backup failed: {error}`
  String settings_backup_error(Object error) {
    return Intl.message(
      'Backup failed: $error',
      name: 'settings_backup_error',
      desc: '',
      args: [error],
    );
  }

  /// `Restore failed: {error}`
  String settings_restore_error(Object error) {
    return Intl.message(
      'Restore failed: $error',
      name: 'settings_restore_error',
      desc: '',
      args: [error],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
