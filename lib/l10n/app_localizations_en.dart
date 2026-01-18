// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PermaCalendar';

  @override
  String get settings_title => 'Settings';

  @override
  String get home_settings_fallback_label => 'Settings (fallback)';

  @override
  String get settings_application => 'Application';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_display => 'Display';

  @override
  String get settings_weather_selector => 'Weather Selector';

  @override
  String get settings_commune_title => 'Location for Weather';

  @override
  String get settings_choose_commune => 'Choose a Location';

  @override
  String get settings_search_commune_hint => 'Search for a location...';

  @override
  String settings_commune_default(String label) {
    return 'Default: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Selected: $label';
  }

  @override
  String get settings_quick_access => 'Quick Access';

  @override
  String get settings_plants_catalog => 'Plant Catalog';

  @override
  String get settings_about => 'About';

  @override
  String get settings_user_guide => 'User Guide';

  @override
  String get settings_privacy => 'Privacy';

  @override
  String get settings_privacy_policy => 'Privacy Policy';

  @override
  String get settings_terms => 'Terms of Use';

  @override
  String get settings_version_dialog_title => 'App Version';

  @override
  String settings_version_dialog_content(String version) {
    return 'Version: $version – Dynamic Garden Management\n\nPermaCalendar - Living Garden Management';
  }

  @override
  String get language_title => 'Language / Langue';

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
    return 'Language changed: $label';
  }

  @override
  String get garden_list_title => 'My Gardens';

  @override
  String get garden_error_title => 'Load Error';

  @override
  String garden_error_subtitle(String error) {
    return 'Unable to load garden list: $error';
  }

  @override
  String get garden_retry => 'Retry';

  @override
  String get garden_no_gardens => 'No gardens yet.';

  @override
  String get garden_archived_info =>
      'You have archived gardens. Enable archived garden display to see them.';

  @override
  String get garden_add_tooltip => 'Add a garden';

  @override
  String get plant_catalog_title => 'Plant Catalog';

  @override
  String get plant_custom_badge => 'Custom';

  @override
  String get plant_detail_not_found_title => 'Plant not found';

  @override
  String get plant_detail_not_found_body =>
      'This plant does not exist or could not be loaded.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant added to favorites';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Add to garden';

  @override
  String get plant_detail_popup_share => 'Share';

  @override
  String get plant_detail_share_todo => 'Sharing is not implemented yet';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Adding to garden is not implemented yet';

  @override
  String get plant_detail_section_culture => 'Culture Details';

  @override
  String get plant_detail_section_instructions => 'General Instructions';

  @override
  String get plant_detail_detail_family => 'Family';

  @override
  String get plant_detail_detail_maturity => 'Maturity Duration';

  @override
  String get plant_detail_detail_spacing => 'Spacing';

  @override
  String get plant_detail_detail_exposure => 'Exposure';

  @override
  String get plant_detail_detail_water => 'Water Needs';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Plantings - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Statistics';

  @override
  String get planting_menu_ready_for_harvest => 'Ready to harvest';

  @override
  String get planting_menu_test_data => 'Test Data';

  @override
  String get planting_search_hint => 'Search a planting...';

  @override
  String get planting_filter_all_statuses => 'All statuses';

  @override
  String get planting_filter_all_plants => 'All plants';

  @override
  String get planting_stat_plantings => 'Plantings';

  @override
  String get planting_stat_total_quantity => 'Total Quantity';

  @override
  String get planting_stat_success_rate => 'Success Rate';

  @override
  String get planting_stat_in_growth => 'In Growth';

  @override
  String get planting_stat_ready_for_harvest => 'Ready to Harvest';

  @override
  String get planting_empty_none => 'No plantings';

  @override
  String get planting_empty_first =>
      'Start by adding your first planting in this bed.';

  @override
  String get planting_create_action => 'Create Planting';

  @override
  String get planting_empty_no_result => 'No Result';

  @override
  String get planting_clear_filters => 'Clear Filters';

  @override
  String get planting_add_tooltip => 'Add a planting';

  @override
  String get search_hint => 'Search...';

  @override
  String get error_page_title => 'Page Not Found';

  @override
  String error_page_message(String uri) {
    return 'The page \"$uri\" does not exist.';
  }

  @override
  String get error_page_back => 'Back to Home';

  @override
  String get dialog_confirm => 'Confirm';

  @override
  String get dialog_cancel => 'Cancel';

  @override
  String snackbar_commune_selected(String name) {
    return 'Location selected: $name';
  }

  @override
  String get common_validate => 'Validate';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get empty_action_create => 'Create';
}
