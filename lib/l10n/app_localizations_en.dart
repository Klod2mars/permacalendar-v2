// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sowing';

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
  String get settings_plants_catalog_subtitle => 'Search and browse plants';

  @override
  String get settings_about => 'About';

  @override
  String get settings_user_guide => 'User Guide';

  @override
  String get settings_user_guide_subtitle => 'Read the manual';

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
    return 'Version: $version – Dynamic Garden Management\n\nSowing - Living Garden Management';
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
  String get calibration_title => 'Calibration';

  @override
  String get calibration_subtitle => 'Customize your dashboard display';

  @override
  String get calibration_organic_title => 'Organic Calibration';

  @override
  String get calibration_organic_subtitle =>
      'Unified mode: Image, Sky, Modules';

  @override
  String get calibration_organic_disabled => '🌿 Organic calibration disabled';

  @override
  String get calibration_organic_enabled =>
      '🌿 Organic calibration mode enabled. Select one of the three tabs.';

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

  @override
  String get user_guide_text =>
      '1 — Welcome to Sowing\nSowing is an application designed to support gardeners in the lively and concrete monitoring of their crops.\nIt allows you to:\n• organize your gardens and plots,\n• follow your plantings throughout their life cycle,\n• plan your tasks at the right time,\n• keep a memory of what has been done,\n• take into account local weather and the rhythm of the seasons.\nThe application works mainly offline and keeps your data directly on your device.\nThis manual describes the common use of Sowing: getting started, creating gardens, plantings, calendar, weather, data export and best practices.\n\n2 — Understanding the interface\nThe dashboard\nUpon opening, Sowing displays a visual and organic dashboard.\nIt takes the form of a background image animated by interactive bubbles. Each bubble gives access to a major function of the application:\n• gardens,\n• air weather,\n• soil weather,\n• calendar,\n• activities,\n• statistics,\n• settings.\nGeneral navigation\nSimply touch a bubble to open the corresponding section.\nInside the pages, you will find depending on the context:\n• contextual menus,\n• \"+\" buttons to add an element,\n• edit or delete buttons.\n\n3 — Quick Start\nOpen the application\nAt launch, the dashboard is displayed automatically.\nConfigure the weather\nIn the settings, choose your location.\nThis information allows Sowing to display local weather adapted to your garden. If no location is selected, a default location is used.\nCreate your first garden\nWhen using for the first time, Sowing automatically guides you to create your first garden.\nYou can also create a garden manually from the dashboard.\nOn the main screen, touch the green leaf located in the freest area, to the right of the statistics and slightly above. This deliberately discreet area allows you to initiate the creation of a garden.\nYou can create up to five gardens.\nThis approach is part of the Sowing experience: there is no permanent and central \"+\" button. The application rather invites exploration and progressive discovery of space.\nThe areas linked to the gardens are also accessible from the Settings menu.\nOrganic calibration of the dashboard\nAn organic calibration mode allows:\n• to visualize the real location of interactive zones,\n• to move them by simple sliding of the finger.\nYou can thus position your gardens and modules exactly where you want on the image: at the top, at the bottom or at the place that suits you best.\nOnce validated, this organization is saved and kept in the application.\nCreate a plot\nIn a garden sheet:\n• choose \"Add a plot\",\n• indicate its name, its area and, if necessary, some notes,\n• save.\nAdd a planting\nIn a plot:\n• press the \"+\" button,\n• choose a plant from the catalog,\n• indicate the date, the quantity and useful information,\n• validate.\n\n4 — The organic dashboard\nThe dashboard is the central point of Sowing.\nIt allows:\n• to have an overview of your activity,\n• to quickly access the main functions,\n• to navigate intuitively.\nDepending on your settings, some bubbles may display synthetic information, such as the weather or upcoming tasks.\n\n5 — Gardens, plots and plantings\nThe gardens\nA garden represents a real place: vegetable garden, greenhouse, orchard, balcony, etc.\nYou can:\n• create several gardens,\n• modify their information,\n• delete them if necessary.\nThe plots\nA plot is a precise zone inside a garden.\nIt allows to structure the space, organize crops and group several plantings in the same place.\nThe plantings\nA planting corresponds to the introduction of a plant in a plot, at a given date.\nWhen creating a planting, Sowing offers two modes.\nSow\nThe \"Sow\" mode corresponds to putting a seed in the ground.\nIn this case:\n• the progression starts at 0%,\n• a step-by-step follow-up is proposed, particularly useful for beginner gardeners,\n• a progress bar visualizes the advancement of the crop cycle.\nThis follow-up allows to estimate:\n• the probable start of the harvest period,\n• the evolution of the crop over time, in a simple and visual way.\nPlant\nThe \"Plant\" mode is intended for plants already developed (plants from a greenhouse or purchased in a garden center).\nIn this case:\n• the plant starts with a progression of about 30%,\n• the follow-up is immediately more advanced,\n• the estimation of the harvest period is adjusted consequently.\nChoice of date\nWhen planting, you can freely choose the date.\nThis allows for example:\n• to fill in a planting carried out previously,\n• to correct a date if the application was not used at the time of sowing or planting.\nBy default, the current date is used.\nFollow-up and history\nEach planting has:\n• a progression follow-up,\n• information on its life cycle,\n• crop stages,\n• personal notes.\nAll actions (sowing, planting, care, harvesting) are automatically recorded in the garden history.\n\n6 — Plant catalog\nThe catalog brings together all the plants available when creating a planting.\nIt constitutes an scalable reference base, designed to cover current uses while remaining customizable.\nMain functions:\n• simple and quick search,\n• recognition of common and scientific names,\n• display of photos when available.\nCustom plants\nYou can create your own custom plants from:\nSettings → Plant catalog.\nIt is then possible to:\n• create a new plant,\n• fill in the essential parameters (name, type, useful information),\n• add an image to facilitate identification.\nThe custom plants are then usable like any other plant in the catalog.\n\n7 — Calendar and tasks\nThe calendar view\nThe calendar displays:\n• planned tasks,\n• important plantings,\n• estimated harvest periods.\nCreate a task\nFrom the calendar:\n• create a new task,\n• indicate a title, a date and a description,\n• choose a possible recurrence.\nThe tasks can be associated with a garden or a plot.\nTask management\nYou can:\n• modify a task,\n• delete it,\n• export it to share it.\n\n8 — Activities and history\nThis section constitutes the living memory of your gardens.\nSelection of a garden\nFrom the dashboard, long press a garden to select it.\nThe active garden is highlighted by a light green halo and a confirmation banner.\nThis selection allows to filter the displayed information.\nRecent activities\nThe \"Activities\" tab displays chronologically:\n• creations,\n• plantings,\n• care,\n• harvests,\n• manual actions.\nHistory by garden\nThe \"History\" tab presents the complete history of the selected garden, year after year.\nIt allows in particular to:\n• find past plantings,\n• check if a plant has already been cultivated in a given place,\n• better organize crop rotation.\n\n9 — Air weather and soil weather\nAir weather\nThe air weather provides essential information:\n• outside temperature,\n• precipitation (rain, snow, no rain),\n• day / night alternation.\nThis data helps to anticipate climatic risks and adapt interventions.\nSoil weather\nSowing integrates a soil weather module.\nThe user can fill in a measured temperature. From this data, the application dynamically estimates the evolution of the soil temperature over time.\nThis information allows:\n• to know which plants are really cultivable at a given time,\n• to adjust sowing to real conditions rather than a theoretical calendar.\nReal-time weather on the dashboard\nA central ovoid-shaped module displays at a glance:\n• the state of the sky,\n• day or night,\n• the phase and position of the moon for the selected location.\nTime navigation\nBy sliding your finger from left to right on the ovoid, you browse the forecasts hour by hour, up to more than 12 hours in advance.\nThe temperature and precipitation adjust dynamically during the gesture.\n\n10 — Recommendations\nSowing can offer recommendations adapted to your situation.\nThey rely on:\n• the season,\n• the weather,\n• the state of your plantings.\nEach recommendation specifies:\n• what to do,\n• when to act,\n• why the action is suggested.\n\n11 — Export and sharing\nPDF Export — calendar and tasks\nThe calendar tasks can be exported to PDF.\nThis allows to:\n• share clear information,\n• transmit a planned intervention,\n• keep a readable and dated trace.\nExcel Export — harvests and statistics\nThe harvest data can be exported in Excel format in order to:\n• analyze the results,\n• produce reports,\n• follow the evolution over time.\nDocument sharing\nThe generated documents can be shared via the applications available on your device (messaging, storage, transfer to a computer, etc.).\n\n12 — Backup and best practices\nThe data is stored locally on your device.\nRecommended best practices:\n• make a backup before a major update,\n• export your data regularly,\n• keep the application and the device up to date.\n\n13 — Settings\nThe Settings menu allows to adapt Sowing to your uses.\nYou can notably:\n• choose the language,\n• select your location,\n• access the plant catalog,\n• customize the dashboard.\nDashboard customization\nIt is possible to:\n• reposition each module,\n• adjust the visual space,\n• change the background image,\n• import your own image (feature coming soon).\nLegal information\nFrom the settings, you can consult:\n• the user guide,\n• the privacy policy,\n• the terms of use.\n\n14 — Frequently asked questions\nThe touch zones are not well aligned\nDepending on the phone or display settings, some zones may seem shifted.\nAn organic calibration mode allows to:\n• visualize the touch zones,\n• reposition them by sliding,\n• save the configuration for your device.\nCan I use Sowing without connection?\nYes. Sowing works offline for the management of gardens, plantings, tasks and history.\nA connection is only used:\n• for the recovery of weather data,\n• during the export or sharing of documents.\nNo other data is transmitted.\n\n15 — Final remark\nSowing is designed as a gardening companion: simple, lively and scalable.\nTake the time to observe, note and trust your experience as much as the tool.';

  @override
  String get privacy_policy_text =>
      'Sowing fully respects your privacy.\n\n• All data is stored locally on your device\n• No personal data is transmitted to third parties\n• No information is stored on an external server\n\nThe application works entirely offline. An Internet connection is only used to retrieve weather data or during exports.';

  @override
  String get terms_text =>
      'By using Sowing, you agree to:\n\n• Use the application responsibly\n• Not attempt to bypass its limitations\n• Respect intellectual property rights\n• Use only your own data\n\nThis application is provided as is, without warranty.\n\nThe Sowing team remains attentive to any future improvement or evolution.';

  @override
  String get calibration_auto_apply => 'Automatically apply for this device';

  @override
  String get calibration_calibrate_now => 'Calibrate now';

  @override
  String get calibration_save_profile => 'Save current calibration as profile';

  @override
  String get calibration_export_profile => 'Export profile (JSON copy)';

  @override
  String get calibration_import_profile => 'Import profile from clipboard';

  @override
  String get calibration_reset_profile => 'Reset profile for this device';

  @override
  String get calibration_refresh_profile => 'Refresh profile preview';

  @override
  String calibration_key_device(String key) {
    return 'Device key: $key';
  }

  @override
  String get calibration_no_profile => 'No profile saved for this device.';

  @override
  String get calibration_image_settings_title =>
      'Background Image Settings (Persistent)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image => 'Reset Image Defaults';

  @override
  String get calibration_dialog_confirm_title => 'Confirm';

  @override
  String get calibration_dialog_delete_profile =>
      'Delete calibration profile for this device?';

  @override
  String get calibration_action_delete => 'Delete';

  @override
  String get calibration_snack_no_profile =>
      'No profile found for this device.';

  @override
  String get calibration_snack_profile_copied => 'Profile copied to clipboard.';

  @override
  String get calibration_snack_clipboard_empty => 'Clipboard empty.';

  @override
  String get calibration_snack_profile_imported =>
      'Profile imported and saved for this device.';

  @override
  String calibration_snack_import_error(String error) {
    return 'JSON import error: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Profile deleted for this device.';

  @override
  String get calibration_snack_no_calibration =>
      'No calibration saved. Calibrate from dashboard first.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Current calibration saved as profile for this device.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Error while saving: $error';
  }
}
