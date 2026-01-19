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
  String get garden_error_title => 'Loading Error';

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
      'You have archived gardens. Enable archived view to see them.';

  @override
  String get garden_add_tooltip => 'Add Garden';

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
  String get common_save => 'Save';

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

  @override
  String get calibration_overlay_saved => 'Calibration saved';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Calibration save error: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Drag to move, pinch to zoom the background image.';

  @override
  String get calibration_instruction_sky =>
      'Adjust the day/night ovoid (center, size, rotation).';

  @override
  String get calibration_instruction_modules =>
      'Move the modules (bubbles) to the desired location.';

  @override
  String get calibration_instruction_none => 'Select a tool to start.';

  @override
  String get calibration_tool_image => 'Image';

  @override
  String get calibration_tool_sky => 'Sky';

  @override
  String get calibration_tool_modules => 'Modules';

  @override
  String get calibration_action_validate_exit => 'Validate & Exit';

  @override
  String get garden_management_create_title => 'Create a Garden';

  @override
  String get garden_management_edit_title => 'Edit Garden';

  @override
  String get garden_management_name_label => 'Garden Name';

  @override
  String get garden_management_desc_label => 'Description';

  @override
  String get garden_management_image_label => 'Garden Image (Optional)';

  @override
  String get garden_management_image_url_label => 'Image URL';

  @override
  String get garden_management_image_preview_error => 'Unable to load image';

  @override
  String get garden_management_create_submit => 'Create Garden';

  @override
  String get garden_management_create_submitting => 'Creating...';

  @override
  String get garden_management_created_success => 'Garden created successfully';

  @override
  String get garden_management_create_error => 'Failed to create garden';

  @override
  String get garden_management_delete_confirm_title => 'Delete Garden';

  @override
  String get garden_management_delete_confirm_body =>
      'Are you sure you want to delete this garden? This will also delete all associated plots and plantings. This action is irreversible.';

  @override
  String get garden_management_delete_success => 'Garden deleted successfully';

  @override
  String get garden_management_archived_tag => 'Archived Garden';

  @override
  String get garden_management_beds_title => 'Garden Beds';

  @override
  String get garden_management_no_beds_title => 'No Garden Beds';

  @override
  String get garden_management_no_beds_desc =>
      'Create beds to organize your plantings';

  @override
  String get garden_management_add_bed_label => 'Create Bed';

  @override
  String get garden_management_stats_beds => 'Beds';

  @override
  String get garden_management_stats_area => 'Total Area';

  @override
  String get dashboard_weather_stats => 'Weather Details';

  @override
  String get dashboard_soil_temp => 'Soil Temp';

  @override
  String get dashboard_air_temp => 'Temperature';

  @override
  String get dashboard_statistics => 'Statistics';

  @override
  String get dashboard_calendar => 'Calendar';

  @override
  String get dashboard_activities => 'Activities';

  @override
  String get dashboard_weather => 'Weather';

  @override
  String get dashboard_settings => 'Settings';

  @override
  String dashboard_garden_n(int number) {
    return 'Garden $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Garden \"$name\" created successfully';
  }

  @override
  String get dashboard_garden_create_error => 'Error creating garden.';

  @override
  String get calendar_title => 'Growing Calendar';

  @override
  String get calendar_refreshed => 'Calendar refreshed';

  @override
  String get calendar_new_task_tooltip => 'New Task';

  @override
  String get calendar_task_saved_title => 'Task saved';

  @override
  String get calendar_ask_export_pdf => 'Do you want to send it as PDF?';

  @override
  String get calendar_task_modified => 'Task modified';

  @override
  String get calendar_delete_confirm_title => 'Delete task?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" will be deleted.';
  }

  @override
  String get calendar_task_deleted => 'Task deleted';

  @override
  String calendar_restore_error(Object error) {
    return 'Restore error: $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Delete error: $error';
  }

  @override
  String get calendar_action_assign => 'Send / Assign to...';

  @override
  String get calendar_assign_title => 'Assign / Send';

  @override
  String get calendar_assign_hint => 'Enter name or email';

  @override
  String get calendar_assign_field => 'Name or Email';

  @override
  String calendar_task_assigned(String name) {
    return 'Task assigned to $name';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Assignment error: $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'PDF Export error: $error';
  }

  @override
  String get calendar_previous_month => 'Previous month';

  @override
  String get calendar_next_month => 'Next month';

  @override
  String get calendar_limit_reached => 'Limit reached';

  @override
  String get calendar_drag_instruction => 'Swipe to navigate';

  @override
  String get common_refresh => 'Refresh';

  @override
  String get common_yes => 'Yes';

  @override
  String get common_no => 'No';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_undo => 'Undo';

  @override
  String common_error_prefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get common_retry => 'Retry';

  @override
  String get calendar_no_events => 'No events today';

  @override
  String calendar_events_of(String date) {
    return 'Events of $date';
  }

  @override
  String get calendar_section_plantings => 'Plantings';

  @override
  String get calendar_section_harvests => 'Expected harvests';

  @override
  String get calendar_section_tasks => 'Scheduled tasks';

  @override
  String get calendar_filter_tasks => 'Tasks';

  @override
  String get calendar_filter_maintenance => 'Maintenance';

  @override
  String get calendar_filter_harvests => 'Harvests';

  @override
  String get calendar_filter_urgent => 'Urgent';

  @override
  String get common_general_error => 'An error occurred';

  @override
  String get common_error => 'Error';

  @override
  String get task_editor_title_new => 'New Task';

  @override
  String get task_editor_title_edit => 'Edit Task';

  @override
  String get task_editor_title_field => 'Title *';

  @override
  String get activity_screen_title => 'Activities & History';

  @override
  String activity_tab_recent_garden(String gardenName) {
    return 'Recent ($gardenName)';
  }

  @override
  String get activity_tab_recent_global => 'Recent (Global)';

  @override
  String get activity_tab_history => 'History';

  @override
  String get activity_history_section_title => 'History — ';

  @override
  String get activity_history_empty =>
      'No garden selected.\nTo view a garden\'s history, long-press it from the dashboard.';

  @override
  String get activity_empty_title => 'No activities found';

  @override
  String get activity_empty_subtitle => 'Gardening activities will appear here';

  @override
  String get activity_error_loading => 'Error loading activities';

  @override
  String get activity_priority_important => 'Important';

  @override
  String get activity_priority_normal => 'Normal';

  @override
  String get activity_time_just_now => 'Just now';

  @override
  String activity_time_minutes_ago(int minutes) {
    return '$minutes min ago';
  }

  @override
  String activity_time_hours_ago(int hours) {
    return '$hours h ago';
  }

  @override
  String activity_time_days_ago(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String activity_metadata_garden(String name) {
    return 'Garden: $name';
  }

  @override
  String activity_metadata_bed(String name) {
    return 'Plot: $name';
  }

  @override
  String activity_metadata_plant(String name) {
    return 'Plant: $name';
  }

  @override
  String activity_metadata_quantity(String quantity) {
    return 'Quantity: $quantity';
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
    return 'Weather: $weather';
  }

  @override
  String get task_editor_error_title_required => 'Required';

  @override
  String get history_hint_title => 'To view a garden\'s history';

  @override
  String get history_hint_body =>
      'Select it by long-pressing from the dashboard.';

  @override
  String get history_hint_action => 'Go to dashboard';

  @override
  String activity_desc_garden_created(String name) {
    return 'Garden \"$name\" created';
  }

  @override
  String activity_desc_bed_created(String name) {
    return 'Bed \"$name\" created';
  }

  @override
  String activity_desc_planting_created(String name) {
    return 'Planting of \"$name\" added';
  }

  @override
  String activity_desc_germination(String name) {
    return 'Germination of \"$name\" confirmed';
  }

  @override
  String activity_desc_harvest(String name) {
    return 'Harvest of \"$name\" recorded';
  }

  @override
  String activity_desc_maintenance(String type) {
    return 'Maintenance: $type';
  }

  @override
  String activity_desc_garden_deleted(String name) {
    return 'Garden \"$name\" deleted';
  }

  @override
  String activity_desc_bed_deleted(String name) {
    return 'Bed \"$name\" deleted';
  }

  @override
  String activity_desc_planting_deleted(String name) {
    return 'Planting of \"$name\" deleted';
  }

  @override
  String activity_desc_garden_updated(String name) {
    return 'Garden \"$name\" updated';
  }

  @override
  String activity_desc_bed_updated(String name) {
    return 'Bed \"$name\" updated';
  }

  @override
  String activity_desc_planting_updated(String name) {
    return 'Planting of \"$name\" updated';
  }

  @override
  String get planting_steps_title => 'Step-by-step';

  @override
  String get planting_steps_add_button => 'Add';

  @override
  String get planting_steps_see_less => 'See less';

  @override
  String get planting_steps_see_all => 'See all';

  @override
  String get planting_steps_empty => 'No recommended steps';

  @override
  String planting_steps_more(int count) {
    return '+ $count more steps';
  }

  @override
  String get planting_steps_prediction_badge => 'Prediction';

  @override
  String planting_steps_date_prefix(String date) {
    return 'On $date';
  }

  @override
  String get planting_steps_done => 'Done';

  @override
  String get planting_steps_mark_done => 'Mark Done';

  @override
  String get planting_steps_dialog_title => 'Add Step';

  @override
  String get planting_steps_dialog_hint => 'Ex: Light mulching';

  @override
  String get planting_steps_dialog_add => 'Add';

  @override
  String get planting_status_sown => 'Sown';

  @override
  String get planting_status_planted => 'Planted';

  @override
  String get planting_status_growing => 'Growing';

  @override
  String get planting_status_ready => 'Ready to harvest';

  @override
  String get planting_status_harvested => 'Harvested';

  @override
  String get planting_status_failed => 'Failed';

  @override
  String planting_card_sown_date(String date) {
    return 'Sown on $date';
  }

  @override
  String planting_card_planted_date(String date) {
    return 'Planted on $date';
  }

  @override
  String planting_card_harvest_estimate(String date) {
    return 'Est. harvest: $date';
  }

  @override
  String get planting_info_title => 'Botanical Info';

  @override
  String get planting_info_tips_title => 'Growing Tips';

  @override
  String get planting_info_maturity => 'Maturity';

  @override
  String planting_info_days(Object days) {
    return '$days days';
  }

  @override
  String get planting_info_spacing => 'Spacing';

  @override
  String planting_info_cm(Object cm) {
    return '$cm cm';
  }

  @override
  String get planting_info_depth => 'Depth';

  @override
  String get planting_info_exposure => 'Exposure';

  @override
  String get planting_info_water => 'Water';

  @override
  String get planting_info_season => 'Planting Season';

  @override
  String get planting_info_scientific_name_none =>
      'Scientific name not available';

  @override
  String get planting_info_culture_title => 'Culture Information';

  @override
  String get planting_info_germination => 'Germination time';

  @override
  String get planting_info_harvest_time => 'Harvest time';

  @override
  String get planting_info_none => 'Not specified';

  @override
  String get planting_tips_none => 'No tips available';

  @override
  String get planting_history_title => 'Action History';

  @override
  String get planting_history_action_planting => 'Planting';

  @override
  String get planting_history_todo => 'Detailed history coming soon';

  @override
  String get task_editor_garden_all => 'All Gardens';

  @override
  String get task_editor_zone_label => 'Zone (Bed)';

  @override
  String get task_editor_zone_none => 'No specific zone';

  @override
  String get task_editor_zone_empty => 'No beds for this garden';

  @override
  String get task_editor_description_label => 'Description';

  @override
  String get task_editor_date_label => 'Start Date';

  @override
  String get task_editor_time_label => 'Time';

  @override
  String get task_editor_duration_label => 'Estimated Duration';

  @override
  String get task_editor_duration_other => 'Other';

  @override
  String get task_editor_type_label => 'Task Type';

  @override
  String get task_editor_priority_label => 'Priority';

  @override
  String get task_editor_urgent_label => 'Urgent';

  @override
  String get task_editor_option_none => 'None (Save Only)';

  @override
  String get task_editor_option_share => 'Share (Text)';

  @override
  String get task_editor_option_pdf => 'Export — PDF';

  @override
  String get task_editor_option_docx => 'Export — Word (.docx)';

  @override
  String get task_editor_export_label => 'Output / Share';

  @override
  String get task_editor_photo_placeholder => 'Add Photo (Coming Soon)';

  @override
  String get task_editor_action_create => 'Create';

  @override
  String get task_editor_action_save => 'Save';

  @override
  String get task_editor_action_cancel => 'Cancel';

  @override
  String get task_editor_assignee_label => 'Assigned to';

  @override
  String task_editor_assignee_add(String name) {
    return 'Add \"$name\" to favorites';
  }

  @override
  String get task_editor_assignee_none => 'No results.';

  @override
  String get task_editor_recurrence_label => 'Recurrence';

  @override
  String get task_editor_recurrence_none => 'None';

  @override
  String get task_editor_recurrence_interval => 'Every X days';

  @override
  String get task_editor_recurrence_weekly => 'Weekly (Days)';

  @override
  String get task_editor_recurrence_monthly => 'Monthly (same day)';

  @override
  String get task_editor_recurrence_repeat_label => 'Repeat every ';

  @override
  String get task_editor_recurrence_days_suffix => ' d';

  @override
  String get task_kind_generic => 'Generic';

  @override
  String get task_kind_repair => 'Repair 🛠️';

  @override
  String get soil_temp_title => 'Soil Temperature';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Chart error: $error';
  }

  @override
  String get soil_temp_about_title => 'About Soil Temperature';

  @override
  String get soil_temp_about_content =>
      'The soil temperature displayed here is estimated by the application based on climatic and seasonal data, using a built-in calculation formula.\n\nThis estimation provides a realistic trend of soil temperature when no direct measurement is available.';

  @override
  String get soil_temp_formula_label => 'Calculation formula used:';

  @override
  String get soil_temp_formula_content =>
      'Soil Temperature = f(air temperature, season, soil inertia)\n(Exact formula defined in the application code)';

  @override
  String get soil_temp_current_label => 'Current Temperature';

  @override
  String get soil_temp_action_measure => 'Edit / Measure';

  @override
  String get soil_temp_measure_hint =>
      'You can manually enter the soil temperature in the \'Edit / Measure\' tab.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Catalog error: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Advice error: $error';
  }

  @override
  String get soil_temp_db_empty => 'Plant database is empty.';

  @override
  String get soil_temp_reload_plants => 'Reload plants';

  @override
  String get soil_temp_no_advice => 'No plants with germination data found.';

  @override
  String get soil_advice_status_ideal => 'Optimal';

  @override
  String get soil_advice_status_sow_now => 'Sow Now';

  @override
  String get soil_advice_status_sow_soon => 'Soon';

  @override
  String get soil_advice_status_wait => 'Wait';

  @override
  String get soil_sheet_title => 'Soil Temperature';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Last measure: $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'New measure (Anchor)';

  @override
  String get soil_sheet_input_label => 'Temperature (°C)';

  @override
  String get soil_sheet_input_error => 'Invalid value (-10.0 to 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Cancel';

  @override
  String get soil_sheet_action_save => 'Save';

  @override
  String get soil_sheet_snack_invalid => 'Invalid value. Enter -10.0 to 45.0';

  @override
  String get soil_sheet_snack_success => 'Measure saved as anchor';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Save error: $error';
  }

  @override
  String get weather_screen_title => 'Weather';

  @override
  String get weather_provider_credit => 'Data provided by Open-Meteo';

  @override
  String get weather_error_loading => 'Unable to load weather';

  @override
  String get weather_action_retry => 'Retry';

  @override
  String get weather_header_next_24h => 'NEXT 24H';

  @override
  String get weather_header_daily_summary => 'DAILY SUMMARY';

  @override
  String get weather_header_precipitations => 'PRECIPITATION (24h)';

  @override
  String get weather_label_wind => 'WIND';

  @override
  String get weather_label_pressure => 'PRESSURE';

  @override
  String get weather_label_sun => 'SUN';

  @override
  String get weather_label_astro => 'ASTRO';

  @override
  String get weather_data_speed => 'Speed';

  @override
  String get weather_data_gusts => 'Gusts';

  @override
  String get weather_data_sunrise => 'Sunrise';

  @override
  String get weather_data_sunset => 'Sunset';

  @override
  String get weather_data_rain => 'Rain';

  @override
  String get weather_data_max => 'Max';

  @override
  String get weather_data_min => 'Min';

  @override
  String get weather_data_wind_max => 'Max Wind';

  @override
  String get weather_pressure_high => 'High';

  @override
  String get weather_pressure_low => 'Low';

  @override
  String get weather_today_label => 'Today';

  @override
  String get moon_phase_new => 'New Moon';

  @override
  String get moon_phase_waxing_crescent => 'Waxing Crescent';

  @override
  String get moon_phase_first_quarter => 'First Quarter';

  @override
  String get moon_phase_waxing_gibbous => 'Waxing Gibbous';

  @override
  String get moon_phase_full => 'Full Moon';

  @override
  String get moon_phase_waning_gibbous => 'Waning Gibbous';

  @override
  String get moon_phase_last_quarter => 'Last Quarter';

  @override
  String get moon_phase_waning_crescent => 'Waning Crescent';

  @override
  String get wmo_code_0 => 'Clear sky';

  @override
  String get wmo_code_1 => 'Mainly clear';

  @override
  String get wmo_code_2 => 'Partly cloudy';

  @override
  String get wmo_code_3 => 'Overcast';

  @override
  String get wmo_code_45 => 'Fog';

  @override
  String get wmo_code_48 => 'Depositing rime fog';

  @override
  String get wmo_code_51 => 'Light drizzle';

  @override
  String get wmo_code_53 => 'Moderate drizzle';

  @override
  String get wmo_code_55 => 'Dense drizzle';

  @override
  String get wmo_code_61 => 'Slight rain';

  @override
  String get wmo_code_63 => 'Moderate rain';

  @override
  String get wmo_code_65 => 'Heavy rain';

  @override
  String get wmo_code_66 => 'Light freezing rain';

  @override
  String get wmo_code_67 => 'Heavy freezing rain';

  @override
  String get wmo_code_71 => 'Slight snow fall';

  @override
  String get wmo_code_73 => 'Moderate snow fall';

  @override
  String get wmo_code_75 => 'Heavy snow fall';

  @override
  String get wmo_code_77 => 'Snow grains';

  @override
  String get wmo_code_80 => 'Slight rain showers';

  @override
  String get wmo_code_81 => 'Moderate rain showers';

  @override
  String get wmo_code_82 => 'Violent rain showers';

  @override
  String get wmo_code_85 => 'Slight snow showers';

  @override
  String get wmo_code_86 => 'Heavy snow showers';

  @override
  String get wmo_code_95 => 'Thunderstorm';

  @override
  String get wmo_code_96 => 'Thunderstorm with slight hail';

  @override
  String get wmo_code_99 => 'Thunderstorm with heavy hail';

  @override
  String get wmo_code_unknown => 'Unknown conditions';

  @override
  String get task_kind_buy => 'Buy 🛒';

  @override
  String get task_kind_clean => 'Clean 🧹';

  @override
  String get task_kind_watering => 'Watering 💧';

  @override
  String get task_kind_seeding => 'Seeding 🌱';

  @override
  String get task_kind_pruning => 'Pruning ✂️';

  @override
  String get task_kind_weeding => 'Weeding 🌿';

  @override
  String get task_kind_amendment => 'Amendment 🪵';

  @override
  String get task_kind_treatment => 'Treatment 🧪';

  @override
  String get task_kind_harvest => 'Harvest 🧺';

  @override
  String get task_kind_winter_protection => 'Winter Protection ❄️';

  @override
  String get garden_detail_title_error => 'Error';

  @override
  String get garden_detail_subtitle_not_found =>
      'The requested garden does not exist or has been deleted.';

  @override
  String garden_detail_subtitle_error_beds(Object error) {
    return 'Unable to load beds: $error';
  }

  @override
  String get garden_action_edit => 'Edit';

  @override
  String get garden_action_archive => 'Archive';

  @override
  String get garden_action_unarchive => 'Unarchive';

  @override
  String get garden_action_delete => 'Delete';

  @override
  String garden_created_at(Object date) {
    return 'Created on $date';
  }

  @override
  String get garden_bed_delete_confirm_title => 'Delete Bed';

  @override
  String garden_bed_delete_confirm_body(Object bedName) {
    return 'Are you sure you want to delete \"$bedName\"? This action is irreversible.';
  }

  @override
  String get garden_bed_deleted_snack => 'Bed deleted';

  @override
  String garden_bed_delete_error(Object error) {
    return 'Error deleting bed: $error';
  }

  @override
  String get common_back => 'Back';

  @override
  String get garden_action_disable => 'Disable';

  @override
  String get garden_action_enable => 'Enable';

  @override
  String get garden_action_modify => 'Modify';

  @override
  String get bed_create_title_new => 'New Bed';

  @override
  String get bed_create_title_edit => 'Edit Bed';

  @override
  String get bed_form_name_label => 'Bed Name *';

  @override
  String get bed_form_name_hint => 'Ex: North Bed, Plot 1';

  @override
  String get bed_form_size_label => 'Area (m²) *';

  @override
  String get bed_form_size_hint => 'Ex: 10.5';

  @override
  String get bed_form_desc_label => 'Description';

  @override
  String get bed_form_desc_hint => 'Description...';

  @override
  String get bed_form_submit_create => 'Create';

  @override
  String get bed_form_submit_edit => 'Save';

  @override
  String get bed_snack_created => 'Bed created successfully';

  @override
  String get bed_snack_updated => 'Bed updated successfully';

  @override
  String get bed_form_error_name_required => 'Name is required';

  @override
  String get bed_form_error_name_length => 'Name must be at least 2 characters';

  @override
  String get bed_form_error_size_required => 'Area is required';

  @override
  String get bed_form_error_size_invalid => 'Please enter a valid area';

  @override
  String get bed_form_error_size_max => 'Area cannot exceed 1000 m²';

  @override
  String get status_sown => 'Sown';

  @override
  String get status_planted => 'Planted';

  @override
  String get status_growing => 'Growing';

  @override
  String get status_ready_to_harvest => 'Ready to harvest';

  @override
  String get status_harvested => 'Harvested';

  @override
  String get status_failed => 'Failed';

  @override
  String bed_card_sown_on(Object date) {
    return 'Sown on $date';
  }

  @override
  String get bed_card_harvest_start => 'approx. harvest start';

  @override
  String get bed_action_harvest => 'Harvest';

  @override
  String get lifecycle_error_title => 'Error calculating lifecycle';

  @override
  String get lifecycle_error_prefix => 'Error: ';

  @override
  String get lifecycle_cycle_completed => 'cycle completed';

  @override
  String get lifecycle_stage_germination => 'Germination';

  @override
  String get lifecycle_stage_growth => 'Growth';

  @override
  String get lifecycle_stage_fruiting => 'Fruiting';

  @override
  String get lifecycle_stage_harvest => 'Harvest';

  @override
  String get lifecycle_stage_unknown => 'Unknown';

  @override
  String get lifecycle_harvest_expected => 'Expected harvest';

  @override
  String lifecycle_in_days(Object days) {
    return 'In $days days';
  }

  @override
  String get lifecycle_passed => 'Passed';

  @override
  String get lifecycle_now => 'Now!';

  @override
  String get lifecycle_next_action => 'Next action';

  @override
  String get lifecycle_update => 'Update cycle';

  @override
  String lifecycle_days_ago(Object days) {
    return '$days days ago';
  }

  @override
  String get planting_detail_title => 'Planting Details';

  @override
  String get companion_beneficial => 'Beneficial plants';

  @override
  String get companion_avoid => 'Plants to avoid';

  @override
  String get common_close => 'Close';

  @override
  String get bed_detail_surface => 'Area';

  @override
  String get bed_detail_details => 'Details';

  @override
  String get bed_detail_notes => 'Notes';

  @override
  String get bed_detail_current_plantings => 'Current Plantings';

  @override
  String get bed_detail_no_plantings_title => 'No Plantings';

  @override
  String get bed_detail_no_plantings_desc => 'This bed has no plantings yet.';

  @override
  String get bed_detail_add_planting => 'Add Planting';

  @override
  String get bed_delete_planting_confirm_title => 'Delete Planting?';

  @override
  String get bed_delete_planting_confirm_body =>
      'This action is irreversible. Do you really want to delete this planting?';

  @override
  String harvest_title(Object plantName) {
    return 'Harvest: $plantName';
  }

  @override
  String get harvest_weight_label => 'Harvested Weight (kg) *';

  @override
  String get harvest_price_label => 'Estimated Price (€/kg)';

  @override
  String get harvest_price_helper =>
      'Will be remembered for future harvests of this plant';

  @override
  String get harvest_notes_label => 'Notes / Quality';

  @override
  String get harvest_action_save => 'Save';

  @override
  String get harvest_snack_saved => 'Harvest recorded';

  @override
  String get harvest_snack_error => 'Error recording harvest';

  @override
  String get harvest_form_error_required => 'Required';

  @override
  String get harvest_form_error_positive => 'Invalid (> 0)';

  @override
  String get harvest_form_error_positive_or_zero => 'Invalid (>= 0)';

  @override
  String get info_exposure_full_sun => 'Full sun';

  @override
  String get info_exposure_partial_sun => 'Partial sun';

  @override
  String get info_exposure_shade => 'Shade';

  @override
  String get info_water_low => 'Low';

  @override
  String get info_water_medium => 'Medium';

  @override
  String get info_water_high => 'High';

  @override
  String get info_water_moderate => 'Moderate';

  @override
  String get info_season_spring => 'Spring';

  @override
  String get info_season_summer => 'Summer';

  @override
  String get info_season_autumn => 'Autumn';

  @override
  String get info_season_winter => 'Winter';

  @override
  String get info_season_all => 'All seasons';

  @override
  String get common_duplicate => 'Duplicate';

  @override
  String get planting_delete_title => 'Delete Planting';

  @override
  String get planting_delete_confirm_body =>
      'Are you sure you want to delete this planting? This action is irreversible.';

  @override
  String get planting_creation_title => 'New Planting';

  @override
  String get planting_creation_title_edit => 'Edit Planting';

  @override
  String get planting_quantity_seeds => 'Number of seeds';

  @override
  String get planting_quantity_plants => 'Number of plants';

  @override
  String get planting_quantity_required => 'Quantity is required';

  @override
  String get planting_quantity_positive => 'Quantity must be a positive number';

  @override
  String planting_plant_selection_label(Object plantName) {
    return 'Plant: $plantName';
  }

  @override
  String get planting_no_plant_selected => 'No plant selected';

  @override
  String get planting_custom_plant_title => 'Custom Plant';

  @override
  String get planting_plant_name_label => 'Plant Name';

  @override
  String get planting_plant_name_hint => 'Ex: Cherry Tomato';

  @override
  String get planting_plant_name_required => 'Plant name is required';

  @override
  String get planting_notes_label => 'Notes (optional)';

  @override
  String get planting_notes_hint => 'Additional information...';

  @override
  String get planting_tips_title => 'Tips';

  @override
  String get planting_tips_catalog => '• Use the catalog to select a plant.';

  @override
  String get planting_tips_type =>
      '• Choose \"Sown\" for seeds, \"Planted\" for seedlings.';

  @override
  String get planting_tips_notes => '• Add notes to track special conditions.';

  @override
  String get planting_date_future_error =>
      'Planting date cannot be in the future';

  @override
  String get planting_success_create => 'Planting created successfully';

  @override
  String get planting_success_update => 'Planting updated successfully';

  @override
  String get stats_screen_title => 'Statistics';

  @override
  String get stats_screen_subtitle =>
      'Analyze in real-time and export your data.';

  @override
  String get kpi_alignment_title => 'Living Alignment';

  @override
  String get kpi_alignment_description =>
      'This tool evaluates how closely your sowing, planting, and harvesting align with the ideal windows recommended by the Intelligent Agenda.';

  @override
  String get kpi_alignment_cta =>
      'Start planting and harvesting to see your alignment!';

  @override
  String get kpi_alignment_aligned => 'aligned';

  @override
  String get kpi_alignment_total => 'Total';

  @override
  String get kpi_alignment_aligned_actions => 'Aligned';

  @override
  String get kpi_alignment_misaligned_actions => 'Misaligned';

  @override
  String get kpi_alignment_calculating => 'Calculating alignment...';

  @override
  String get kpi_alignment_error => 'Error during calculation';

  @override
  String get pillar_economy_title => 'Garden Economy';

  @override
  String get pillar_nutrition_title => 'Nutritional Balance';

  @override
  String get pillar_export_title => 'Export';

  @override
  String get pillar_economy_label => 'Total harvest value';

  @override
  String get pillar_nutrition_label => 'Nutritional Signature';

  @override
  String get pillar_export_label => 'Retrieve your data';

  @override
  String get pillar_export_button => 'Export';

  @override
  String get stats_economy_title => 'Garden Economy';

  @override
  String get stats_economy_no_harvest => 'No harvest in the selected period.';

  @override
  String get stats_economy_no_harvest_desc =>
      'No data for the selected period.';

  @override
  String get stats_kpi_total_revenue => 'Total Revenue';

  @override
  String get stats_kpi_total_volume => 'Total Volume';

  @override
  String get stats_kpi_avg_price => 'Average Price';

  @override
  String get stats_top_cultures_title => 'Top Crops (Value)';

  @override
  String get stats_top_cultures_no_data => 'No data';

  @override
  String get stats_top_cultures_percent_revenue => 'of revenue';

  @override
  String get stats_monthly_revenue_title => 'Monthly Revenue';

  @override
  String get stats_monthly_revenue_no_data => 'No monthly data';

  @override
  String get stats_dominant_culture_title => 'Dominant Crop by Month';

  @override
  String get stats_annual_evolution_title => 'Annual Trend';

  @override
  String get stats_crop_distribution_title => 'Crop Distribution';

  @override
  String get stats_crop_distribution_others => 'Others';

  @override
  String get stats_key_months_title => 'Key Garden Months';

  @override
  String get stats_most_profitable => 'Most Profitable';

  @override
  String get stats_least_profitable => 'Least Profitable';

  @override
  String get stats_auto_summary_title => 'Auto Summary';

  @override
  String get stats_revenue_history_title => 'Revenue History';

  @override
  String get stats_profitability_cycle_title => 'Profitability Cycle';

  @override
  String get stats_table_crop => 'Crop';

  @override
  String get stats_table_days => 'Days (Avg)';

  @override
  String get stats_table_revenue => 'Rev/Harvest';

  @override
  String get stats_table_type => 'Type';

  @override
  String get stats_type_fast => 'Fast';

  @override
  String get stats_type_long_term => 'Long Term';
}
