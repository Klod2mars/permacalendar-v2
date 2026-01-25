// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Bed \"${name}\" created";

  static String m1(name) => "Bed \"${name}\" deleted";

  static String m2(name) => "Bed \"${name}\" updated";

  static String m3(name) => "Garden \"${name}\" created";

  static String m4(name) => "Garden \"${name}\" deleted";

  static String m5(name) => "Garden \"${name}\" updated";

  static String m6(name) => "Germination of \"${name}\" confirmed";

  static String m7(name) => "Harvest of \"${name}\" recorded";

  static String m8(type) => "Maintenance: ${type}";

  static String m9(name) => "Planting of \"${name}\" added";

  static String m10(name) => "Planting of \"${name}\" deleted";

  static String m11(name) => "Planting of \"${name}\" updated";

  static String m12(name) => "Plot: ${name}";

  static String m13(date) => "Date: ${date}";

  static String m14(name) => "Garden: ${name}";

  static String m15(type) => "Maintenance: ${type}";

  static String m16(name) => "Plant: ${name}";

  static String m17(quantity) => "Quantity: ${quantity}";

  static String m18(weather) => "Weather: ${weather}";

  static String m19(gardenName) => "Recent (${gardenName})";

  static String m20(count) =>
      "${Intl.plural(count, one: '1 day ago', other: '${count} days ago')}";

  static String m21(hours) => "${hours} h ago";

  static String m22(minutes) => "${minutes} min ago";

  static String m23(date) => "Sown on ${date}";

  static String m24(error) => "Assignment error: ${error}";

  static String m25(title) => "\"${title}\" will be deleted.";

  static String m26(error) => "Delete error: ${error}";

  static String m27(date) => "Events of ${date}";

  static String m28(error) => "PDF Export error: ${error}";

  static String m29(error) => "Restore error: ${error}";

  static String m30(name) => "Task assigned to ${name}";

  static String m31(key) => "Device key: ${key}";

  static String m32(error) => "Calibration save error: ${error}";

  static String m33(error) => "JSON import error: ${error}";

  static String m34(error) => "Error while saving: ${error}";

  static String m35(error) => "Error: ${error}";

  static String m36(name) => "Garden \"${name}\" created successfully";

  static String m37(number) => "Garden ${number}";

  static String m38(uri) => "The page \"${uri}\" does not exist.";

  static String m39(count) => "${count} columns selected";

  static String m40(error) => "Error: ${error}";

  static String m41(count) => "${count} garden(s) selected";

  static String m42(bedName) =>
      "Are you sure you want to delete \"${bedName}\"? This action is irreversible.";

  static String m43(error) => "Error deleting bed: ${error}";

  static String m44(date) => "Created on ${date}";

  static String m45(error) => "Unable to load beds: ${error}";

  static String m46(error) => "Unable to load garden list: ${error}";

  static String m47(plantName) => "Harvest: ${plantName}";

  static String m48(label) => "Language changed: ${label}";

  static String m49(days) => "${days} days ago";

  static String m50(days) => "In ${days} days";

  static String m51(month) => "Dynamics of ${month}";

  static String m52(plant) => "${plant} added to favorites";

  static String m53(months) => "Periods: ${months}";

  static String m54(date) => "Est. harvest: ${date}";

  static String m55(date) => "Planted on ${date}";

  static String m56(date) => "Sown on ${date}";

  static String m57(cm) => "${cm} cm";

  static String m58(days) => "${days} days";

  static String m59(plantName) => "Plant: ${plantName}";

  static String m60(date) => "On ${date}";

  static String m61(count) => "+ ${count} more steps";

  static String m62(gardenBedName) => "Plantings - ${gardenBedName}";

  static String m73(error) => "Backup failed: ${error}";

  static String m63(label) => "Default: ${label}";

  static String m64(label) => "Selected: ${label}";

  static String m74(error) => "Restore failed: ${error}";

  static String m65(version) =>
      "Version: ${version} – Dynamic Garden Management\n\nSowing - Living Garden Management";

  static String m66(name) => "Location selected: ${name}";

  static String m67(temp, date) => "Last measure: ${temp}°C (${date})";

  static String m68(error) => "Save error: ${error}";

  static String m69(error) => "Advice error: ${error}";

  static String m70(error) => "Catalog error: ${error}";

  static String m71(error) => "Chart error: ${error}";

  static String m72(name) => "Add \"${name}\" to favorites";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "activity_desc_bed_created": m0,
        "activity_desc_bed_deleted": m1,
        "activity_desc_bed_updated": m2,
        "activity_desc_garden_created": m3,
        "activity_desc_garden_deleted": m4,
        "activity_desc_garden_updated": m5,
        "activity_desc_germination": m6,
        "activity_desc_harvest": m7,
        "activity_desc_maintenance": m8,
        "activity_desc_planting_created": m9,
        "activity_desc_planting_deleted": m10,
        "activity_desc_planting_updated": m11,
        "activity_empty_subtitle": MessageLookupByLibrary.simpleMessage(
            "Gardening activities will appear here"),
        "activity_empty_title":
            MessageLookupByLibrary.simpleMessage("No activities found"),
        "activity_error_loading":
            MessageLookupByLibrary.simpleMessage("Error loading activities"),
        "activity_history_empty": MessageLookupByLibrary.simpleMessage(
            "No garden selected.\nTo view a garden\'s history, long-press it from the dashboard."),
        "activity_history_section_title":
            MessageLookupByLibrary.simpleMessage("History — "),
        "activity_metadata_bed": m12,
        "activity_metadata_date": m13,
        "activity_metadata_garden": m14,
        "activity_metadata_maintenance": m15,
        "activity_metadata_plant": m16,
        "activity_metadata_quantity": m17,
        "activity_metadata_weather": m18,
        "activity_priority_important":
            MessageLookupByLibrary.simpleMessage("Important"),
        "activity_priority_normal":
            MessageLookupByLibrary.simpleMessage("Normal"),
        "activity_screen_title":
            MessageLookupByLibrary.simpleMessage("Activities & History"),
        "activity_tab_history": MessageLookupByLibrary.simpleMessage("History"),
        "activity_tab_recent_garden": m19,
        "activity_tab_recent_global":
            MessageLookupByLibrary.simpleMessage("Recent (Global)"),
        "activity_time_days_ago": m20,
        "activity_time_hours_ago": m21,
        "activity_time_just_now":
            MessageLookupByLibrary.simpleMessage("Just now"),
        "activity_time_minutes_ago": m22,
        "appTitle": MessageLookupByLibrary.simpleMessage("Sowing"),
        "bed_action_harvest": MessageLookupByLibrary.simpleMessage("Harvest"),
        "bed_card_harvest_start":
            MessageLookupByLibrary.simpleMessage("approx. harvest start"),
        "bed_card_sown_on": m23,
        "bed_create_title_edit":
            MessageLookupByLibrary.simpleMessage("Edit Bed"),
        "bed_create_title_new": MessageLookupByLibrary.simpleMessage("New Bed"),
        "bed_delete_planting_confirm_body": MessageLookupByLibrary.simpleMessage(
            "This action is irreversible. Do you really want to delete this planting?"),
        "bed_delete_planting_confirm_title":
            MessageLookupByLibrary.simpleMessage("Delete Planting?"),
        "bed_detail_add_planting":
            MessageLookupByLibrary.simpleMessage("Add Planting"),
        "bed_detail_current_plantings":
            MessageLookupByLibrary.simpleMessage("Current Plantings"),
        "bed_detail_details": MessageLookupByLibrary.simpleMessage("Details"),
        "bed_detail_no_plantings_desc": MessageLookupByLibrary.simpleMessage(
            "This bed has no plantings yet."),
        "bed_detail_no_plantings_title":
            MessageLookupByLibrary.simpleMessage("No Plantings"),
        "bed_detail_notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "bed_detail_surface": MessageLookupByLibrary.simpleMessage("Area"),
        "bed_form_desc_hint":
            MessageLookupByLibrary.simpleMessage("Description..."),
        "bed_form_desc_label":
            MessageLookupByLibrary.simpleMessage("Description"),
        "bed_form_error_name_length": MessageLookupByLibrary.simpleMessage(
            "Name must be at least 2 characters"),
        "bed_form_error_name_required":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "bed_form_error_size_invalid":
            MessageLookupByLibrary.simpleMessage("Please enter a valid area"),
        "bed_form_error_size_max":
            MessageLookupByLibrary.simpleMessage("Area cannot exceed 1000 m²"),
        "bed_form_error_size_required":
            MessageLookupByLibrary.simpleMessage("Area is required"),
        "bed_form_name_hint":
            MessageLookupByLibrary.simpleMessage("Ex: North Bed, Plot 1"),
        "bed_form_name_label":
            MessageLookupByLibrary.simpleMessage("Bed Name *"),
        "bed_form_size_hint": MessageLookupByLibrary.simpleMessage("Ex: 10.5"),
        "bed_form_size_label":
            MessageLookupByLibrary.simpleMessage("Area (m²) *"),
        "bed_form_submit_create":
            MessageLookupByLibrary.simpleMessage("Create"),
        "bed_form_submit_edit": MessageLookupByLibrary.simpleMessage("Save"),
        "bed_snack_created":
            MessageLookupByLibrary.simpleMessage("Bed created successfully"),
        "bed_snack_updated":
            MessageLookupByLibrary.simpleMessage("Bed updated successfully"),
        "calendar_action_assign":
            MessageLookupByLibrary.simpleMessage("Send / Assign to..."),
        "calendar_ask_export_pdf": MessageLookupByLibrary.simpleMessage(
            "Do you want to send it as PDF?"),
        "calendar_assign_error": m24,
        "calendar_assign_field":
            MessageLookupByLibrary.simpleMessage("Name or Email"),
        "calendar_assign_hint":
            MessageLookupByLibrary.simpleMessage("Enter name or email"),
        "calendar_assign_title":
            MessageLookupByLibrary.simpleMessage("Assign / Send"),
        "calendar_delete_confirm_content": m25,
        "calendar_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Delete task?"),
        "calendar_delete_error": m26,
        "calendar_drag_instruction":
            MessageLookupByLibrary.simpleMessage("Swipe to navigate"),
        "calendar_events_of": m27,
        "calendar_export_error": m28,
        "calendar_filter_harvests":
            MessageLookupByLibrary.simpleMessage("Harvests"),
        "calendar_filter_maintenance":
            MessageLookupByLibrary.simpleMessage("Maintenance"),
        "calendar_filter_tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
        "calendar_filter_urgent":
            MessageLookupByLibrary.simpleMessage("Urgent"),
        "calendar_limit_reached":
            MessageLookupByLibrary.simpleMessage("Limit reached"),
        "calendar_new_task_tooltip":
            MessageLookupByLibrary.simpleMessage("New Task"),
        "calendar_next_month":
            MessageLookupByLibrary.simpleMessage("Next month"),
        "calendar_no_events":
            MessageLookupByLibrary.simpleMessage("No events today"),
        "calendar_previous_month":
            MessageLookupByLibrary.simpleMessage("Previous month"),
        "calendar_refreshed":
            MessageLookupByLibrary.simpleMessage("Calendar refreshed"),
        "calendar_restore_error": m29,
        "calendar_section_harvests":
            MessageLookupByLibrary.simpleMessage("Expected harvests"),
        "calendar_section_plantings":
            MessageLookupByLibrary.simpleMessage("Plantings"),
        "calendar_section_tasks":
            MessageLookupByLibrary.simpleMessage("Scheduled tasks"),
        "calendar_task_assigned": m30,
        "calendar_task_deleted":
            MessageLookupByLibrary.simpleMessage("Task deleted"),
        "calendar_task_modified":
            MessageLookupByLibrary.simpleMessage("Task modified"),
        "calendar_task_saved_title":
            MessageLookupByLibrary.simpleMessage("Task saved"),
        "calendar_title":
            MessageLookupByLibrary.simpleMessage("Growing Calendar"),
        "calibration_action_delete":
            MessageLookupByLibrary.simpleMessage("Delete"),
        "calibration_action_validate_exit":
            MessageLookupByLibrary.simpleMessage("Validate & Exit"),
        "calibration_auto_apply": MessageLookupByLibrary.simpleMessage(
            "Automatically apply for this device"),
        "calibration_calibrate_now":
            MessageLookupByLibrary.simpleMessage("Calibrate now"),
        "calibration_dialog_confirm_title":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "calibration_dialog_delete_profile":
            MessageLookupByLibrary.simpleMessage(
                "Delete calibration profile for this device?"),
        "calibration_export_profile":
            MessageLookupByLibrary.simpleMessage("Export profile (JSON copy)"),
        "calibration_image_settings_title":
            MessageLookupByLibrary.simpleMessage(
                "Background Image Settings (Persistent)"),
        "calibration_import_profile": MessageLookupByLibrary.simpleMessage(
            "Import profile from clipboard"),
        "calibration_instruction_image": MessageLookupByLibrary.simpleMessage(
            "Drag to move, pinch to zoom the background image."),
        "calibration_instruction_modules": MessageLookupByLibrary.simpleMessage(
            "Move the modules (bubbles) to the desired location."),
        "calibration_instruction_none":
            MessageLookupByLibrary.simpleMessage("Select a tool to start."),
        "calibration_instruction_sky": MessageLookupByLibrary.simpleMessage(
            "Adjust the day/night ovoid (center, size, rotation)."),
        "calibration_key_device": m31,
        "calibration_no_profile": MessageLookupByLibrary.simpleMessage(
            "No profile saved for this device."),
        "calibration_organic_disabled": MessageLookupByLibrary.simpleMessage(
            "🌿 Organic calibration disabled"),
        "calibration_organic_enabled": MessageLookupByLibrary.simpleMessage(
            "🌿 Organic calibration mode enabled. Select one of the three tabs."),
        "calibration_organic_subtitle": MessageLookupByLibrary.simpleMessage(
            "Unified mode: Image, Sky, Modules"),
        "calibration_organic_title":
            MessageLookupByLibrary.simpleMessage("Organic Calibration"),
        "calibration_overlay_error_save": m32,
        "calibration_overlay_saved":
            MessageLookupByLibrary.simpleMessage("Calibration saved"),
        "calibration_pos_x": MessageLookupByLibrary.simpleMessage("Pos X"),
        "calibration_pos_y": MessageLookupByLibrary.simpleMessage("Pos Y"),
        "calibration_refresh_profile":
            MessageLookupByLibrary.simpleMessage("Refresh profile preview"),
        "calibration_reset_image":
            MessageLookupByLibrary.simpleMessage("Reset Image Defaults"),
        "calibration_reset_profile": MessageLookupByLibrary.simpleMessage(
            "Reset profile for this device"),
        "calibration_save_profile": MessageLookupByLibrary.simpleMessage(
            "Save current calibration as profile"),
        "calibration_snack_clipboard_empty":
            MessageLookupByLibrary.simpleMessage("Clipboard empty."),
        "calibration_snack_import_error": m33,
        "calibration_snack_no_calibration":
            MessageLookupByLibrary.simpleMessage(
                "No calibration saved. Calibrate from dashboard first."),
        "calibration_snack_no_profile": MessageLookupByLibrary.simpleMessage(
            "No profile found for this device."),
        "calibration_snack_profile_copied":
            MessageLookupByLibrary.simpleMessage(
                "Profile copied to clipboard."),
        "calibration_snack_profile_deleted":
            MessageLookupByLibrary.simpleMessage(
                "Profile deleted for this device."),
        "calibration_snack_profile_imported":
            MessageLookupByLibrary.simpleMessage(
                "Profile imported and saved for this device."),
        "calibration_snack_save_error": m34,
        "calibration_snack_saved_as_profile":
            MessageLookupByLibrary.simpleMessage(
                "Current calibration saved as profile for this device."),
        "calibration_subtitle": MessageLookupByLibrary.simpleMessage(
            "Customize your dashboard display"),
        "calibration_title":
            MessageLookupByLibrary.simpleMessage("Calibration"),
        "calibration_tool_image": MessageLookupByLibrary.simpleMessage("Image"),
        "calibration_tool_modules":
            MessageLookupByLibrary.simpleMessage("Modules"),
        "calibration_tool_sky": MessageLookupByLibrary.simpleMessage("Sky"),
        "calibration_zoom": MessageLookupByLibrary.simpleMessage("Zoom"),
        "common_back": MessageLookupByLibrary.simpleMessage("Back"),
        "common_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "common_close": MessageLookupByLibrary.simpleMessage("Close"),
        "common_delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "common_duplicate": MessageLookupByLibrary.simpleMessage("Duplicate"),
        "common_edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "common_error": MessageLookupByLibrary.simpleMessage("Error"),
        "common_error_prefix": m35,
        "common_general_error":
            MessageLookupByLibrary.simpleMessage("An error occurred"),
        "common_no": MessageLookupByLibrary.simpleMessage("No"),
        "common_refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "common_retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "common_save": MessageLookupByLibrary.simpleMessage("Save"),
        "common_undo": MessageLookupByLibrary.simpleMessage("Undo"),
        "common_validate": MessageLookupByLibrary.simpleMessage("Validate"),
        "common_yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "companion_avoid":
            MessageLookupByLibrary.simpleMessage("Plants to avoid"),
        "companion_beneficial":
            MessageLookupByLibrary.simpleMessage("Beneficial plants"),
        "dashboard_activities":
            MessageLookupByLibrary.simpleMessage("Activities"),
        "dashboard_air_temp":
            MessageLookupByLibrary.simpleMessage("Temperature"),
        "dashboard_calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
        "dashboard_garden_create_error":
            MessageLookupByLibrary.simpleMessage("Error creating garden."),
        "dashboard_garden_created": m36,
        "dashboard_garden_n": m37,
        "dashboard_settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "dashboard_soil_temp":
            MessageLookupByLibrary.simpleMessage("Soil Temp"),
        "dashboard_statistics":
            MessageLookupByLibrary.simpleMessage("Statistics"),
        "dashboard_weather": MessageLookupByLibrary.simpleMessage("Weather"),
        "dashboard_weather_stats":
            MessageLookupByLibrary.simpleMessage("Weather Details"),
        "dialog_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "dialog_confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "empty_action_create": MessageLookupByLibrary.simpleMessage("Create"),
        "error_page_back": MessageLookupByLibrary.simpleMessage("Back to Home"),
        "error_page_message": m38,
        "error_page_title":
            MessageLookupByLibrary.simpleMessage("Page Not Found"),
        "export_action_generate":
            MessageLookupByLibrary.simpleMessage("Generate Excel Export"),
        "export_activity_type_bed_created":
            MessageLookupByLibrary.simpleMessage("Plot Creation"),
        "export_activity_type_bed_deleted":
            MessageLookupByLibrary.simpleMessage("Plot Deletion"),
        "export_activity_type_bed_updated":
            MessageLookupByLibrary.simpleMessage("Plot Update"),
        "export_activity_type_error":
            MessageLookupByLibrary.simpleMessage("Error"),
        "export_activity_type_garden_created":
            MessageLookupByLibrary.simpleMessage("Garden Creation"),
        "export_activity_type_garden_deleted":
            MessageLookupByLibrary.simpleMessage("Garden Deletion"),
        "export_activity_type_garden_updated":
            MessageLookupByLibrary.simpleMessage("Garden Update"),
        "export_activity_type_harvest":
            MessageLookupByLibrary.simpleMessage("Harvest"),
        "export_activity_type_maintenance":
            MessageLookupByLibrary.simpleMessage("Maintenance"),
        "export_activity_type_planting_created":
            MessageLookupByLibrary.simpleMessage("New Planting"),
        "export_activity_type_planting_deleted":
            MessageLookupByLibrary.simpleMessage("Planting Deletion"),
        "export_activity_type_planting_updated":
            MessageLookupByLibrary.simpleMessage("Planting Update"),
        "export_activity_type_weather":
            MessageLookupByLibrary.simpleMessage("Weather"),
        "export_block_activity":
            MessageLookupByLibrary.simpleMessage("Activities (Journal)"),
        "export_block_desc_activity": MessageLookupByLibrary.simpleMessage(
            "Complete history of interventions and events"),
        "export_block_desc_garden": MessageLookupByLibrary.simpleMessage(
            "Metadata of selected gardens"),
        "export_block_desc_garden_bed": MessageLookupByLibrary.simpleMessage(
            "Plot details (area, orientation...)"),
        "export_block_desc_harvest":
            MessageLookupByLibrary.simpleMessage("Production data and yields"),
        "export_block_desc_plant":
            MessageLookupByLibrary.simpleMessage("List of used plants"),
        "export_block_garden":
            MessageLookupByLibrary.simpleMessage("Gardens (Structure)"),
        "export_block_garden_bed":
            MessageLookupByLibrary.simpleMessage("Plots (Structure)"),
        "export_block_harvest":
            MessageLookupByLibrary.simpleMessage("Harvests (Production)"),
        "export_block_plant":
            MessageLookupByLibrary.simpleMessage("Plants (Catalog)"),
        "export_blocks_section":
            MessageLookupByLibrary.simpleMessage("2. Data Blocks"),
        "export_builder_title":
            MessageLookupByLibrary.simpleMessage("Export Builder"),
        "export_columns_count": m39,
        "export_columns_section":
            MessageLookupByLibrary.simpleMessage("3. Details & Columns"),
        "export_error_snack": m40,
        "export_excel_total": MessageLookupByLibrary.simpleMessage("TOTAL"),
        "export_excel_unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "export_field_activity_date":
            MessageLookupByLibrary.simpleMessage("Date"),
        "export_field_activity_desc":
            MessageLookupByLibrary.simpleMessage("Description"),
        "export_field_activity_entity":
            MessageLookupByLibrary.simpleMessage("Target Entity"),
        "export_field_activity_entity_id":
            MessageLookupByLibrary.simpleMessage("Target ID"),
        "export_field_activity_title":
            MessageLookupByLibrary.simpleMessage("Title"),
        "export_field_activity_type":
            MessageLookupByLibrary.simpleMessage("Type"),
        "export_field_advanced_suffix":
            MessageLookupByLibrary.simpleMessage(" (Advanced)"),
        "export_field_bed_id": MessageLookupByLibrary.simpleMessage("Plot ID"),
        "export_field_bed_name":
            MessageLookupByLibrary.simpleMessage("Plot Name"),
        "export_field_bed_plant_count":
            MessageLookupByLibrary.simpleMessage("Plant Count"),
        "export_field_bed_surface":
            MessageLookupByLibrary.simpleMessage("Area (m²)"),
        "export_field_desc_activity_date":
            MessageLookupByLibrary.simpleMessage("Date of the activity"),
        "export_field_desc_activity_desc":
            MessageLookupByLibrary.simpleMessage("Complete details"),
        "export_field_desc_activity_entity":
            MessageLookupByLibrary.simpleMessage(
                "Name of the object concerned (Plant, Plot...)"),
        "export_field_desc_activity_entity_id":
            MessageLookupByLibrary.simpleMessage("ID of the object concerned"),
        "export_field_desc_activity_title":
            MessageLookupByLibrary.simpleMessage("Summary of the action"),
        "export_field_desc_activity_type": MessageLookupByLibrary.simpleMessage(
            "Action category (Sowing, Harvest, Care...)"),
        "export_field_desc_bed_id":
            MessageLookupByLibrary.simpleMessage("Unique technical identifier"),
        "export_field_desc_bed_name":
            MessageLookupByLibrary.simpleMessage("Name of the plot"),
        "export_field_desc_bed_plant_count":
            MessageLookupByLibrary.simpleMessage(
                "Number of crops in place (current)"),
        "export_field_desc_bed_surface":
            MessageLookupByLibrary.simpleMessage("Surface area of the plot"),
        "export_field_desc_garden_creation":
            MessageLookupByLibrary.simpleMessage(
                "Creation date in the application"),
        "export_field_desc_garden_id":
            MessageLookupByLibrary.simpleMessage("Unique technical identifier"),
        "export_field_desc_garden_name":
            MessageLookupByLibrary.simpleMessage("Name given to the garden"),
        "export_field_desc_garden_surface":
            MessageLookupByLibrary.simpleMessage("Total garden area"),
        "export_field_desc_harvest_bed_id":
            MessageLookupByLibrary.simpleMessage("Plot identifier"),
        "export_field_desc_harvest_bed_name":
            MessageLookupByLibrary.simpleMessage("Source plot (if available)"),
        "export_field_desc_harvest_date":
            MessageLookupByLibrary.simpleMessage("Date of the harvest event"),
        "export_field_desc_harvest_garden_id":
            MessageLookupByLibrary.simpleMessage("Unique garden identifier"),
        "export_field_desc_harvest_garden_name":
            MessageLookupByLibrary.simpleMessage(
                "Name of the source garden (if available)"),
        "export_field_desc_harvest_notes": MessageLookupByLibrary.simpleMessage(
            "Observations entered during harvest"),
        "export_field_desc_harvest_plant_name":
            MessageLookupByLibrary.simpleMessage("Name of the harvested plant"),
        "export_field_desc_harvest_price":
            MessageLookupByLibrary.simpleMessage("Configured price per kg"),
        "export_field_desc_harvest_qty":
            MessageLookupByLibrary.simpleMessage("Harvested weight in kg"),
        "export_field_desc_harvest_value":
            MessageLookupByLibrary.simpleMessage("Quantity * Price/kg"),
        "export_field_desc_plant_family":
            MessageLookupByLibrary.simpleMessage("Botanical family"),
        "export_field_desc_plant_id":
            MessageLookupByLibrary.simpleMessage("Unique technical identifier"),
        "export_field_desc_plant_name":
            MessageLookupByLibrary.simpleMessage("Common name of the plant"),
        "export_field_desc_plant_scientific":
            MessageLookupByLibrary.simpleMessage("Botanical denomination"),
        "export_field_desc_plant_variety":
            MessageLookupByLibrary.simpleMessage("Specific variety"),
        "export_field_garden_creation":
            MessageLookupByLibrary.simpleMessage("Creation Date"),
        "export_field_garden_id":
            MessageLookupByLibrary.simpleMessage("Garden ID"),
        "export_field_garden_name":
            MessageLookupByLibrary.simpleMessage("Garden Name"),
        "export_field_garden_surface":
            MessageLookupByLibrary.simpleMessage("Area (m²)"),
        "export_field_harvest_bed_id":
            MessageLookupByLibrary.simpleMessage("Plot ID"),
        "export_field_harvest_bed_name":
            MessageLookupByLibrary.simpleMessage("Plot"),
        "export_field_harvest_date":
            MessageLookupByLibrary.simpleMessage("Harvest Date"),
        "export_field_harvest_garden_id":
            MessageLookupByLibrary.simpleMessage("Garden ID"),
        "export_field_harvest_garden_name":
            MessageLookupByLibrary.simpleMessage("Garden"),
        "export_field_harvest_notes":
            MessageLookupByLibrary.simpleMessage("Notes"),
        "export_field_harvest_plant_name":
            MessageLookupByLibrary.simpleMessage("Plant"),
        "export_field_harvest_price":
            MessageLookupByLibrary.simpleMessage("Price/kg"),
        "export_field_harvest_qty":
            MessageLookupByLibrary.simpleMessage("Quantity (kg)"),
        "export_field_harvest_value":
            MessageLookupByLibrary.simpleMessage("Total Value"),
        "export_field_plant_family":
            MessageLookupByLibrary.simpleMessage("Family"),
        "export_field_plant_id":
            MessageLookupByLibrary.simpleMessage("Plant ID"),
        "export_field_plant_name":
            MessageLookupByLibrary.simpleMessage("Common Name"),
        "export_field_plant_scientific":
            MessageLookupByLibrary.simpleMessage("Scientific Name"),
        "export_field_plant_variety":
            MessageLookupByLibrary.simpleMessage("Variety"),
        "export_filter_garden_all":
            MessageLookupByLibrary.simpleMessage("All Gardens"),
        "export_filter_garden_count": m41,
        "export_filter_garden_edit":
            MessageLookupByLibrary.simpleMessage("Edit selection"),
        "export_filter_garden_select_dialog_title":
            MessageLookupByLibrary.simpleMessage("Select Gardens"),
        "export_filter_garden_title":
            MessageLookupByLibrary.simpleMessage("Filter by Garden"),
        "export_format_flat":
            MessageLookupByLibrary.simpleMessage("Single Table (Flat / BI)"),
        "export_format_flat_subtitle": MessageLookupByLibrary.simpleMessage(
            "One large table for Pivot Tables"),
        "export_format_section":
            MessageLookupByLibrary.simpleMessage("4. File Format"),
        "export_format_separate":
            MessageLookupByLibrary.simpleMessage("Separate Sheets (Standard)"),
        "export_format_separate_subtitle": MessageLookupByLibrary.simpleMessage(
            "One sheet per data type (Recommended)"),
        "export_generating":
            MessageLookupByLibrary.simpleMessage("Generating..."),
        "export_scope_period": MessageLookupByLibrary.simpleMessage("Period"),
        "export_scope_period_all":
            MessageLookupByLibrary.simpleMessage("All History"),
        "export_scope_section":
            MessageLookupByLibrary.simpleMessage("1. Scope"),
        "export_success_share_text": MessageLookupByLibrary.simpleMessage(
            "Here is your PermaCalendar export"),
        "export_success_title":
            MessageLookupByLibrary.simpleMessage("Export Complete"),
        "garden_action_archive":
            MessageLookupByLibrary.simpleMessage("Archive"),
        "garden_action_delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "garden_action_disable":
            MessageLookupByLibrary.simpleMessage("Disable"),
        "garden_action_edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "garden_action_enable": MessageLookupByLibrary.simpleMessage("Enable"),
        "garden_action_modify": MessageLookupByLibrary.simpleMessage("Modify"),
        "garden_action_unarchive":
            MessageLookupByLibrary.simpleMessage("Unarchive"),
        "garden_add_tooltip":
            MessageLookupByLibrary.simpleMessage("Add Garden"),
        "garden_archived_info": MessageLookupByLibrary.simpleMessage(
            "You have archived gardens. Enable archived view to see them."),
        "garden_bed_delete_confirm_body": m42,
        "garden_bed_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Delete Bed"),
        "garden_bed_delete_error": m43,
        "garden_bed_deleted_snack":
            MessageLookupByLibrary.simpleMessage("Bed deleted"),
        "garden_created_at": m44,
        "garden_detail_subtitle_error_beds": m45,
        "garden_detail_subtitle_not_found":
            MessageLookupByLibrary.simpleMessage(
                "The requested garden does not exist or has been deleted."),
        "garden_detail_title_error":
            MessageLookupByLibrary.simpleMessage("Error"),
        "garden_error_subtitle": m46,
        "garden_error_title":
            MessageLookupByLibrary.simpleMessage("Loading Error"),
        "garden_list_title": MessageLookupByLibrary.simpleMessage("My Gardens"),
        "garden_management_add_bed_label":
            MessageLookupByLibrary.simpleMessage("Create Bed"),
        "garden_management_archived_tag":
            MessageLookupByLibrary.simpleMessage("Archived Garden"),
        "garden_management_beds_title":
            MessageLookupByLibrary.simpleMessage("Garden Beds"),
        "garden_management_create_error":
            MessageLookupByLibrary.simpleMessage("Failed to create garden"),
        "garden_management_create_submit":
            MessageLookupByLibrary.simpleMessage("Create Garden"),
        "garden_management_create_submitting":
            MessageLookupByLibrary.simpleMessage("Creating..."),
        "garden_management_create_title":
            MessageLookupByLibrary.simpleMessage("Create a Garden"),
        "garden_management_created_success":
            MessageLookupByLibrary.simpleMessage("Garden created successfully"),
        "garden_management_delete_confirm_body":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this garden? This will also delete all associated plots and plantings. This action is irreversible."),
        "garden_management_delete_confirm_title":
            MessageLookupByLibrary.simpleMessage("Delete Garden"),
        "garden_management_delete_success":
            MessageLookupByLibrary.simpleMessage("Garden deleted successfully"),
        "garden_management_desc_label":
            MessageLookupByLibrary.simpleMessage("Description"),
        "garden_management_edit_title":
            MessageLookupByLibrary.simpleMessage("Edit Garden"),
        "garden_management_image_label":
            MessageLookupByLibrary.simpleMessage("Garden Image (Optional)"),
        "garden_management_image_preview_error":
            MessageLookupByLibrary.simpleMessage("Unable to load image"),
        "garden_management_image_url_label":
            MessageLookupByLibrary.simpleMessage("Image URL"),
        "garden_management_name_label":
            MessageLookupByLibrary.simpleMessage("Garden Name"),
        "garden_management_no_beds_desc": MessageLookupByLibrary.simpleMessage(
            "Create beds to organize your plantings"),
        "garden_management_no_beds_title":
            MessageLookupByLibrary.simpleMessage("No Garden Beds"),
        "garden_management_stats_area":
            MessageLookupByLibrary.simpleMessage("Total Area"),
        "garden_management_stats_beds":
            MessageLookupByLibrary.simpleMessage("Beds"),
        "garden_no_gardens":
            MessageLookupByLibrary.simpleMessage("No gardens yet."),
        "garden_retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "harvest_action_save": MessageLookupByLibrary.simpleMessage("Save"),
        "harvest_form_error_positive":
            MessageLookupByLibrary.simpleMessage("Invalid (> 0)"),
        "harvest_form_error_positive_or_zero":
            MessageLookupByLibrary.simpleMessage("Invalid (>= 0)"),
        "harvest_form_error_required":
            MessageLookupByLibrary.simpleMessage("Required"),
        "harvest_notes_label":
            MessageLookupByLibrary.simpleMessage("Notes / Quality"),
        "harvest_price_helper": MessageLookupByLibrary.simpleMessage(
            "Will be remembered for future harvests of this plant"),
        "harvest_price_label":
            MessageLookupByLibrary.simpleMessage("Estimated Price (€/kg)"),
        "harvest_snack_error":
            MessageLookupByLibrary.simpleMessage("Error recording harvest"),
        "harvest_snack_saved":
            MessageLookupByLibrary.simpleMessage("Harvest recorded"),
        "harvest_title": m47,
        "harvest_weight_label":
            MessageLookupByLibrary.simpleMessage("Harvested Weight (kg) *"),
        "history_hint_action":
            MessageLookupByLibrary.simpleMessage("Go to dashboard"),
        "history_hint_body": MessageLookupByLibrary.simpleMessage(
            "Select it by long-pressing from the dashboard."),
        "history_hint_title":
            MessageLookupByLibrary.simpleMessage("To view a garden\'s history"),
        "home_settings_fallback_label":
            MessageLookupByLibrary.simpleMessage("Settings (fallback)"),
        "info_exposure_full_sun":
            MessageLookupByLibrary.simpleMessage("Full sun"),
        "info_exposure_partial_sun":
            MessageLookupByLibrary.simpleMessage("Partial sun"),
        "info_exposure_shade": MessageLookupByLibrary.simpleMessage("Shade"),
        "info_season_all": MessageLookupByLibrary.simpleMessage("All seasons"),
        "info_season_autumn": MessageLookupByLibrary.simpleMessage("Autumn"),
        "info_season_spring": MessageLookupByLibrary.simpleMessage("Spring"),
        "info_season_summer": MessageLookupByLibrary.simpleMessage("Summer"),
        "info_season_winter": MessageLookupByLibrary.simpleMessage("Winter"),
        "info_water_high": MessageLookupByLibrary.simpleMessage("High"),
        "info_water_low": MessageLookupByLibrary.simpleMessage("Low"),
        "info_water_medium": MessageLookupByLibrary.simpleMessage("Medium"),
        "info_water_moderate": MessageLookupByLibrary.simpleMessage("Moderate"),
        "kpi_alignment_aligned":
            MessageLookupByLibrary.simpleMessage("aligned"),
        "kpi_alignment_aligned_actions":
            MessageLookupByLibrary.simpleMessage("Aligned"),
        "kpi_alignment_calculating":
            MessageLookupByLibrary.simpleMessage("Calculating alignment..."),
        "kpi_alignment_cta": MessageLookupByLibrary.simpleMessage(
            "Start planting and harvesting to see your alignment!"),
        "kpi_alignment_description": MessageLookupByLibrary.simpleMessage(
            "This tool evaluates how closely your sowing, planting, and harvesting align with the ideal windows recommended by the Intelligent Agenda."),
        "kpi_alignment_error":
            MessageLookupByLibrary.simpleMessage("Error during calculation"),
        "kpi_alignment_misaligned_actions":
            MessageLookupByLibrary.simpleMessage("Misaligned"),
        "kpi_alignment_title":
            MessageLookupByLibrary.simpleMessage("Living Alignment"),
        "kpi_alignment_total": MessageLookupByLibrary.simpleMessage("Total"),
        "language_changed_snackbar": m48,
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_french": MessageLookupByLibrary.simpleMessage("Français"),
        "language_german": MessageLookupByLibrary.simpleMessage("Deutsch"),
        "language_portuguese_br":
            MessageLookupByLibrary.simpleMessage("Português (Brasil)"),
        "language_spanish": MessageLookupByLibrary.simpleMessage("Español"),
        "language_title":
            MessageLookupByLibrary.simpleMessage("Language / Langue"),
        "lifecycle_cycle_completed":
            MessageLookupByLibrary.simpleMessage("cycle completed"),
        "lifecycle_days_ago": m49,
        "lifecycle_error_prefix":
            MessageLookupByLibrary.simpleMessage("Error: "),
        "lifecycle_error_title":
            MessageLookupByLibrary.simpleMessage("Error calculating lifecycle"),
        "lifecycle_harvest_expected":
            MessageLookupByLibrary.simpleMessage("Expected harvest"),
        "lifecycle_in_days": m50,
        "lifecycle_next_action":
            MessageLookupByLibrary.simpleMessage("Next action"),
        "lifecycle_now": MessageLookupByLibrary.simpleMessage("Now!"),
        "lifecycle_passed": MessageLookupByLibrary.simpleMessage("Passed"),
        "lifecycle_stage_fruiting":
            MessageLookupByLibrary.simpleMessage("Fruiting"),
        "lifecycle_stage_germination":
            MessageLookupByLibrary.simpleMessage("Germination"),
        "lifecycle_stage_growth":
            MessageLookupByLibrary.simpleMessage("Growth"),
        "lifecycle_stage_harvest":
            MessageLookupByLibrary.simpleMessage("Harvest"),
        "lifecycle_stage_unknown":
            MessageLookupByLibrary.simpleMessage("Unknown"),
        "lifecycle_update":
            MessageLookupByLibrary.simpleMessage("Update cycle"),
        "moon_phase_first_quarter":
            MessageLookupByLibrary.simpleMessage("First Quarter"),
        "moon_phase_full": MessageLookupByLibrary.simpleMessage("Full Moon"),
        "moon_phase_last_quarter":
            MessageLookupByLibrary.simpleMessage("Last Quarter"),
        "moon_phase_new": MessageLookupByLibrary.simpleMessage("New Moon"),
        "moon_phase_waning_crescent":
            MessageLookupByLibrary.simpleMessage("Waning Crescent"),
        "moon_phase_waning_gibbous":
            MessageLookupByLibrary.simpleMessage("Waning Gibbous"),
        "moon_phase_waxing_crescent":
            MessageLookupByLibrary.simpleMessage("Waxing Crescent"),
        "moon_phase_waxing_gibbous":
            MessageLookupByLibrary.simpleMessage("Waxing Gibbous"),
        "nut_calcium": MessageLookupByLibrary.simpleMessage("Calcium"),
        "nut_fiber": MessageLookupByLibrary.simpleMessage("Fiber"),
        "nut_iron": MessageLookupByLibrary.simpleMessage("Iron"),
        "nut_magnesium": MessageLookupByLibrary.simpleMessage("Magnesium"),
        "nut_manganese": MessageLookupByLibrary.simpleMessage("Manganese"),
        "nut_potassium": MessageLookupByLibrary.simpleMessage("Potassium"),
        "nut_protein": MessageLookupByLibrary.simpleMessage("Protein"),
        "nut_vitamin_c": MessageLookupByLibrary.simpleMessage("Vitamin C"),
        "nut_zinc": MessageLookupByLibrary.simpleMessage("Zinc"),
        "nutrition_dominant_production":
            MessageLookupByLibrary.simpleMessage("Dominant production:"),
        "nutrition_major_minerals_title":
            MessageLookupByLibrary.simpleMessage("Structure & Major Minerals"),
        "nutrition_month_dynamics_title": m51,
        "nutrition_no_data_period":
            MessageLookupByLibrary.simpleMessage("No data for this period"),
        "nutrition_no_harvest_month":
            MessageLookupByLibrary.simpleMessage("No harvest this month"),
        "nutrition_no_major_minerals":
            MessageLookupByLibrary.simpleMessage("No major minerals"),
        "nutrition_no_trace_elements":
            MessageLookupByLibrary.simpleMessage("No trace elements"),
        "nutrition_nutrients_origin": MessageLookupByLibrary.simpleMessage(
            "These nutrients come from your harvests of the month."),
        "nutrition_page_title":
            MessageLookupByLibrary.simpleMessage("Nutrition Signature"),
        "nutrition_seasonal_dynamics_desc": MessageLookupByLibrary.simpleMessage(
            "Explore the mineral and vitamin production of your garden, month by month."),
        "nutrition_seasonal_dynamics_title":
            MessageLookupByLibrary.simpleMessage("Seasonal Dynamics"),
        "nutrition_trace_elements_title":
            MessageLookupByLibrary.simpleMessage("Vitality & Trace Elements"),
        "pillar_economy_label":
            MessageLookupByLibrary.simpleMessage("Total harvest value"),
        "pillar_economy_title":
            MessageLookupByLibrary.simpleMessage("Garden Economy"),
        "pillar_export_button": MessageLookupByLibrary.simpleMessage("Export"),
        "pillar_export_label":
            MessageLookupByLibrary.simpleMessage("Retrieve your data"),
        "pillar_export_title": MessageLookupByLibrary.simpleMessage("Export"),
        "pillar_nutrition_label":
            MessageLookupByLibrary.simpleMessage("Nutritional Signature"),
        "pillar_nutrition_title":
            MessageLookupByLibrary.simpleMessage("Nutritional Balance"),
        "plant_added_favorites": m52,
        "plant_catalog_data_unknown":
            MessageLookupByLibrary.simpleMessage("Unknown data"),
        "plant_catalog_expand_window":
            MessageLookupByLibrary.simpleMessage("Expand (±2 months)"),
        "plant_catalog_filter_all": MessageLookupByLibrary.simpleMessage("All"),
        "plant_catalog_filter_green_only":
            MessageLookupByLibrary.simpleMessage("Green only"),
        "plant_catalog_filter_green_orange":
            MessageLookupByLibrary.simpleMessage("Green + Orange"),
        "plant_catalog_legend_green":
            MessageLookupByLibrary.simpleMessage("Ready this month"),
        "plant_catalog_legend_orange":
            MessageLookupByLibrary.simpleMessage("Close / Soon"),
        "plant_catalog_legend_red":
            MessageLookupByLibrary.simpleMessage("Out of season"),
        "plant_catalog_missing_period_data":
            MessageLookupByLibrary.simpleMessage("Missing period data"),
        "plant_catalog_no_recommended": MessageLookupByLibrary.simpleMessage(
            "No plants recommended for this period."),
        "plant_catalog_periods_prefix": m53,
        "plant_catalog_plant": MessageLookupByLibrary.simpleMessage("Plant"),
        "plant_catalog_search_hint":
            MessageLookupByLibrary.simpleMessage("Search for a plant..."),
        "plant_catalog_show_selection":
            MessageLookupByLibrary.simpleMessage("Show selection"),
        "plant_catalog_sow": MessageLookupByLibrary.simpleMessage("Sow"),
        "plant_catalog_title":
            MessageLookupByLibrary.simpleMessage("Plant Catalog"),
        "plant_custom_badge": MessageLookupByLibrary.simpleMessage("Custom"),
        "plant_detail_add_to_garden_todo": MessageLookupByLibrary.simpleMessage(
            "Adding to garden is not implemented yet"),
        "plant_detail_detail_exposure":
            MessageLookupByLibrary.simpleMessage("Exposure"),
        "plant_detail_detail_family":
            MessageLookupByLibrary.simpleMessage("Family"),
        "plant_detail_detail_maturity":
            MessageLookupByLibrary.simpleMessage("Maturity Duration"),
        "plant_detail_detail_spacing":
            MessageLookupByLibrary.simpleMessage("Spacing"),
        "plant_detail_detail_water":
            MessageLookupByLibrary.simpleMessage("Water Needs"),
        "plant_detail_not_found_body": MessageLookupByLibrary.simpleMessage(
            "This plant does not exist or could not be loaded."),
        "plant_detail_not_found_title":
            MessageLookupByLibrary.simpleMessage("Plant not found"),
        "plant_detail_popup_add_to_garden":
            MessageLookupByLibrary.simpleMessage("Add to garden"),
        "plant_detail_popup_share":
            MessageLookupByLibrary.simpleMessage("Share"),
        "plant_detail_section_culture":
            MessageLookupByLibrary.simpleMessage("Culture Details"),
        "plant_detail_section_instructions":
            MessageLookupByLibrary.simpleMessage("General Instructions"),
        "plant_detail_share_todo": MessageLookupByLibrary.simpleMessage(
            "Sharing is not implemented yet"),
        "planting_add_tooltip":
            MessageLookupByLibrary.simpleMessage("Add a planting"),
        "planting_card_harvest_estimate": m54,
        "planting_card_planted_date": m55,
        "planting_card_sown_date": m56,
        "planting_clear_filters":
            MessageLookupByLibrary.simpleMessage("Clear Filters"),
        "planting_create_action":
            MessageLookupByLibrary.simpleMessage("Create Planting"),
        "planting_creation_title":
            MessageLookupByLibrary.simpleMessage("New Planting"),
        "planting_creation_title_edit":
            MessageLookupByLibrary.simpleMessage("Edit Planting"),
        "planting_custom_plant_title":
            MessageLookupByLibrary.simpleMessage("Custom Plant"),
        "planting_date_future_error": MessageLookupByLibrary.simpleMessage(
            "Planting date cannot be in the future"),
        "planting_delete_confirm_body": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this planting? This action is irreversible."),
        "planting_delete_title":
            MessageLookupByLibrary.simpleMessage("Delete Planting"),
        "planting_detail_title":
            MessageLookupByLibrary.simpleMessage("Planting Details"),
        "planting_empty_first": MessageLookupByLibrary.simpleMessage(
            "Start by adding your first planting in this bed."),
        "planting_empty_no_result":
            MessageLookupByLibrary.simpleMessage("No Result"),
        "planting_empty_none":
            MessageLookupByLibrary.simpleMessage("No plantings"),
        "planting_filter_all_plants":
            MessageLookupByLibrary.simpleMessage("All plants"),
        "planting_filter_all_statuses":
            MessageLookupByLibrary.simpleMessage("All statuses"),
        "planting_history_action_planting":
            MessageLookupByLibrary.simpleMessage("Planting"),
        "planting_history_title":
            MessageLookupByLibrary.simpleMessage("Action History"),
        "planting_history_todo": MessageLookupByLibrary.simpleMessage(
            "Detailed history coming soon"),
        "planting_info_cm": m57,
        "planting_info_culture_title":
            MessageLookupByLibrary.simpleMessage("Culture Information"),
        "planting_info_days": m58,
        "planting_info_depth": MessageLookupByLibrary.simpleMessage("Depth"),
        "planting_info_exposure":
            MessageLookupByLibrary.simpleMessage("Exposure"),
        "planting_info_germination":
            MessageLookupByLibrary.simpleMessage("Germination time"),
        "planting_info_harvest_time":
            MessageLookupByLibrary.simpleMessage("Harvest time"),
        "planting_info_maturity":
            MessageLookupByLibrary.simpleMessage("Maturity"),
        "planting_info_none":
            MessageLookupByLibrary.simpleMessage("Not specified"),
        "planting_info_scientific_name_none":
            MessageLookupByLibrary.simpleMessage(
                "Scientific name not available"),
        "planting_info_season":
            MessageLookupByLibrary.simpleMessage("Planting Season"),
        "planting_info_spacing":
            MessageLookupByLibrary.simpleMessage("Spacing"),
        "planting_info_tips_title":
            MessageLookupByLibrary.simpleMessage("Growing Tips"),
        "planting_info_title":
            MessageLookupByLibrary.simpleMessage("Botanical Info"),
        "planting_info_water": MessageLookupByLibrary.simpleMessage("Water"),
        "planting_menu_ready_for_harvest":
            MessageLookupByLibrary.simpleMessage("Ready to harvest"),
        "planting_menu_statistics":
            MessageLookupByLibrary.simpleMessage("Statistics"),
        "planting_menu_test_data":
            MessageLookupByLibrary.simpleMessage("Test Data"),
        "planting_no_plant_selected":
            MessageLookupByLibrary.simpleMessage("No plant selected"),
        "planting_notes_hint":
            MessageLookupByLibrary.simpleMessage("Additional information..."),
        "planting_notes_label":
            MessageLookupByLibrary.simpleMessage("Notes (optional)"),
        "planting_plant_name_hint":
            MessageLookupByLibrary.simpleMessage("Ex: Cherry Tomato"),
        "planting_plant_name_label":
            MessageLookupByLibrary.simpleMessage("Plant Name"),
        "planting_plant_name_required":
            MessageLookupByLibrary.simpleMessage("Plant name is required"),
        "planting_plant_selection_label": m59,
        "planting_quantity_plants":
            MessageLookupByLibrary.simpleMessage("Number of plants"),
        "planting_quantity_positive": MessageLookupByLibrary.simpleMessage(
            "Quantity must be a positive number"),
        "planting_quantity_required":
            MessageLookupByLibrary.simpleMessage("Quantity is required"),
        "planting_quantity_seeds":
            MessageLookupByLibrary.simpleMessage("Number of seeds"),
        "planting_search_hint":
            MessageLookupByLibrary.simpleMessage("Search a planting..."),
        "planting_stat_in_growth":
            MessageLookupByLibrary.simpleMessage("In Growth"),
        "planting_stat_plantings":
            MessageLookupByLibrary.simpleMessage("Plantings"),
        "planting_stat_ready_for_harvest":
            MessageLookupByLibrary.simpleMessage("Ready to Harvest"),
        "planting_stat_success_rate":
            MessageLookupByLibrary.simpleMessage("Success Rate"),
        "planting_stat_total_quantity":
            MessageLookupByLibrary.simpleMessage("Total Quantity"),
        "planting_status_failed":
            MessageLookupByLibrary.simpleMessage("Failed"),
        "planting_status_growing":
            MessageLookupByLibrary.simpleMessage("Growing"),
        "planting_status_harvested":
            MessageLookupByLibrary.simpleMessage("Harvested"),
        "planting_status_planted":
            MessageLookupByLibrary.simpleMessage("Planted"),
        "planting_status_ready":
            MessageLookupByLibrary.simpleMessage("Ready to harvest"),
        "planting_status_sown": MessageLookupByLibrary.simpleMessage("Sown"),
        "planting_steps_add_button":
            MessageLookupByLibrary.simpleMessage("Add"),
        "planting_steps_date_prefix": m60,
        "planting_steps_dialog_add":
            MessageLookupByLibrary.simpleMessage("Add"),
        "planting_steps_dialog_hint":
            MessageLookupByLibrary.simpleMessage("Ex: Light mulching"),
        "planting_steps_dialog_title":
            MessageLookupByLibrary.simpleMessage("Add Step"),
        "planting_steps_done": MessageLookupByLibrary.simpleMessage("Done"),
        "planting_steps_empty":
            MessageLookupByLibrary.simpleMessage("No recommended steps"),
        "planting_steps_mark_done":
            MessageLookupByLibrary.simpleMessage("Mark Done"),
        "planting_steps_more": m61,
        "planting_steps_prediction_badge":
            MessageLookupByLibrary.simpleMessage("Prediction"),
        "planting_steps_see_all":
            MessageLookupByLibrary.simpleMessage("See all"),
        "planting_steps_see_less":
            MessageLookupByLibrary.simpleMessage("See less"),
        "planting_steps_title":
            MessageLookupByLibrary.simpleMessage("Step-by-step"),
        "planting_success_create": MessageLookupByLibrary.simpleMessage(
            "Planting created successfully"),
        "planting_success_update": MessageLookupByLibrary.simpleMessage(
            "Planting updated successfully"),
        "planting_tips_catalog": MessageLookupByLibrary.simpleMessage(
            "• Use the catalog to select a plant."),
        "planting_tips_none":
            MessageLookupByLibrary.simpleMessage("No tips available"),
        "planting_tips_notes": MessageLookupByLibrary.simpleMessage(
            "• Add notes to track special conditions."),
        "planting_tips_title": MessageLookupByLibrary.simpleMessage("Tips"),
        "planting_tips_type": MessageLookupByLibrary.simpleMessage(
            "• Choose \"Sown\" for seeds, \"Planted\" for seedlings."),
        "planting_title_template": m62,
        "privacy_policy_text": MessageLookupByLibrary.simpleMessage(
            "Sowing fully respects your privacy.\n\n• All data is stored locally on your device\n• No personal data is transmitted to third parties\n• No information is stored on an external server\n\nThe application works entirely offline. An Internet connection is only used to retrieve weather data or during exports."),
        "search_hint": MessageLookupByLibrary.simpleMessage("Search..."),
        "settings_about": MessageLookupByLibrary.simpleMessage("About"),
        "settings_application":
            MessageLookupByLibrary.simpleMessage("Application"),
        "settings_backup_action":
            MessageLookupByLibrary.simpleMessage("Create Backup"),
        "settings_backup_creating":
            MessageLookupByLibrary.simpleMessage("Creating Backup..."),
        "settings_backup_error": m73,
        "settings_backup_restore_section":
            MessageLookupByLibrary.simpleMessage("Backup & Restore"),
        "settings_backup_restore_subtitle":
            MessageLookupByLibrary.simpleMessage("Full backup of your data"),
        "settings_backup_success": MessageLookupByLibrary.simpleMessage(
            "Backup created successfully!"),
        "settings_choose_commune":
            MessageLookupByLibrary.simpleMessage("Choose a Location"),
        "settings_commune_default": m63,
        "settings_commune_selected": m64,
        "settings_commune_title":
            MessageLookupByLibrary.simpleMessage("Location for Weather"),
        "settings_display": MessageLookupByLibrary.simpleMessage("Display"),
        "settings_plants_catalog":
            MessageLookupByLibrary.simpleMessage("Plant Catalog"),
        "settings_plants_catalog_subtitle":
            MessageLookupByLibrary.simpleMessage("Search and browse plants"),
        "settings_privacy": MessageLookupByLibrary.simpleMessage("Privacy"),
        "settings_privacy_policy":
            MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "settings_quick_access":
            MessageLookupByLibrary.simpleMessage("Quick Access"),
        "settings_restore_action":
            MessageLookupByLibrary.simpleMessage("Restore Backup"),
        "settings_restore_error": m74,
        "settings_restore_success": MessageLookupByLibrary.simpleMessage(
            "Restore successful! Please restart the app."),
        "settings_restore_warning_content": MessageLookupByLibrary.simpleMessage(
            "Restoring a backup will overwrite ALL current data (gardens, plantings, settings). This action is irreversible. The app will restart after restore.\n\nAre you sure you want to proceed?"),
        "settings_restore_warning_title":
            MessageLookupByLibrary.simpleMessage("Warning"),
        "settings_search_commune_hint":
            MessageLookupByLibrary.simpleMessage("Search for a location..."),
        "settings_terms": MessageLookupByLibrary.simpleMessage("Terms of Use"),
        "settings_title": MessageLookupByLibrary.simpleMessage("Settings"),
        "settings_user_guide":
            MessageLookupByLibrary.simpleMessage("User Guide"),
        "settings_user_guide_subtitle":
            MessageLookupByLibrary.simpleMessage("Read the manual"),
        "settings_version": MessageLookupByLibrary.simpleMessage("Version"),
        "settings_version_dialog_content": m65,
        "settings_version_dialog_title":
            MessageLookupByLibrary.simpleMessage("App Version"),
        "settings_weather_selector":
            MessageLookupByLibrary.simpleMessage("Weather Selector"),
        "snackbar_commune_selected": m66,
        "soil_advice_status_ideal":
            MessageLookupByLibrary.simpleMessage("Optimal"),
        "soil_advice_status_sow_now":
            MessageLookupByLibrary.simpleMessage("Sow Now"),
        "soil_advice_status_sow_soon":
            MessageLookupByLibrary.simpleMessage("Soon"),
        "soil_advice_status_wait": MessageLookupByLibrary.simpleMessage("Wait"),
        "soil_sheet_action_cancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "soil_sheet_action_save": MessageLookupByLibrary.simpleMessage("Save"),
        "soil_sheet_input_error": MessageLookupByLibrary.simpleMessage(
            "Invalid value (-10.0 to 45.0)"),
        "soil_sheet_input_hint": MessageLookupByLibrary.simpleMessage("0.0"),
        "soil_sheet_input_label":
            MessageLookupByLibrary.simpleMessage("Temperature (°C)"),
        "soil_sheet_last_measure": m67,
        "soil_sheet_new_measure":
            MessageLookupByLibrary.simpleMessage("New measure (Anchor)"),
        "soil_sheet_snack_error": m68,
        "soil_sheet_snack_invalid": MessageLookupByLibrary.simpleMessage(
            "Invalid value. Enter -10.0 to 45.0"),
        "soil_sheet_snack_success":
            MessageLookupByLibrary.simpleMessage("Measure saved as anchor"),
        "soil_sheet_title":
            MessageLookupByLibrary.simpleMessage("Soil Temperature"),
        "soil_temp_about_content": MessageLookupByLibrary.simpleMessage(
            "The soil temperature displayed here is estimated by the app from climatic and seasonal data, according to the following formula:\n\nThis estimate gives a realistic trend of soil temperature when no direct measurement is available."),
        "soil_temp_about_title":
            MessageLookupByLibrary.simpleMessage("About Soil Temperature"),
        "soil_temp_action_measure":
            MessageLookupByLibrary.simpleMessage("Edit / Measure"),
        "soil_temp_advice_error": m69,
        "soil_temp_catalog_error": m70,
        "soil_temp_chart_error": m71,
        "soil_temp_current_label":
            MessageLookupByLibrary.simpleMessage("Current Temperature"),
        "soil_temp_db_empty":
            MessageLookupByLibrary.simpleMessage("Plant database is empty."),
        "soil_temp_formula_content": MessageLookupByLibrary.simpleMessage(
            "T_soil(n+1) = T_soil(n) + α × (T_air(n) − T_soil(n))\n\nWhere:\n• α: thermal diffusion coefficient (default 0.15 — recommended range 0.10–0.20).\n• T_soil(n): current soil temperature (°C).\n• T_air(n): current air temperature (°C).\n\nThe formula is implemented in the app code (ComputeSoilTempNextDayUsecase)."),
        "soil_temp_formula_label":
            MessageLookupByLibrary.simpleMessage("Calculation formula used:"),
        "soil_temp_measure_hint": MessageLookupByLibrary.simpleMessage(
            "You can manually enter the soil temperature in the \'Edit / Measure\' tab."),
        "soil_temp_no_advice": MessageLookupByLibrary.simpleMessage(
            "No plants with germination data found."),
        "soil_temp_reload_plants":
            MessageLookupByLibrary.simpleMessage("Reload plants"),
        "soil_temp_title":
            MessageLookupByLibrary.simpleMessage("Soil Temperature"),
        "stats_annual_evolution_title":
            MessageLookupByLibrary.simpleMessage("Annual Trend"),
        "stats_auto_summary_title":
            MessageLookupByLibrary.simpleMessage("Auto Summary"),
        "stats_crop_distribution_others":
            MessageLookupByLibrary.simpleMessage("Others"),
        "stats_crop_distribution_title":
            MessageLookupByLibrary.simpleMessage("Crop Distribution"),
        "stats_dominant_culture_title":
            MessageLookupByLibrary.simpleMessage("Dominant Crop by Month"),
        "stats_economy_no_harvest": MessageLookupByLibrary.simpleMessage(
            "No harvest in the selected period."),
        "stats_economy_no_harvest_desc": MessageLookupByLibrary.simpleMessage(
            "No data for the selected period."),
        "stats_economy_title":
            MessageLookupByLibrary.simpleMessage("Garden Economy"),
        "stats_key_months_title":
            MessageLookupByLibrary.simpleMessage("Key Garden Months"),
        "stats_kpi_avg_price":
            MessageLookupByLibrary.simpleMessage("Average Price"),
        "stats_kpi_total_revenue":
            MessageLookupByLibrary.simpleMessage("Total Revenue"),
        "stats_kpi_total_volume":
            MessageLookupByLibrary.simpleMessage("Total Volume"),
        "stats_least_profitable":
            MessageLookupByLibrary.simpleMessage("Least Profitable"),
        "stats_monthly_revenue_no_data":
            MessageLookupByLibrary.simpleMessage("No monthly data"),
        "stats_monthly_revenue_title":
            MessageLookupByLibrary.simpleMessage("Monthly Revenue"),
        "stats_most_profitable":
            MessageLookupByLibrary.simpleMessage("Most Profitable"),
        "stats_profitability_cycle_title":
            MessageLookupByLibrary.simpleMessage("Profitability Cycle"),
        "stats_revenue_history_title":
            MessageLookupByLibrary.simpleMessage("Revenue History"),
        "stats_screen_subtitle": MessageLookupByLibrary.simpleMessage(
            "Analyze in real-time and export your data."),
        "stats_screen_title":
            MessageLookupByLibrary.simpleMessage("Statistics"),
        "stats_table_crop": MessageLookupByLibrary.simpleMessage("Crop"),
        "stats_table_days": MessageLookupByLibrary.simpleMessage("Days (Avg)"),
        "stats_table_revenue":
            MessageLookupByLibrary.simpleMessage("Rev/Harvest"),
        "stats_table_type": MessageLookupByLibrary.simpleMessage("Type"),
        "stats_top_cultures_no_data":
            MessageLookupByLibrary.simpleMessage("No data"),
        "stats_top_cultures_percent_revenue":
            MessageLookupByLibrary.simpleMessage("of revenue"),
        "stats_top_cultures_title":
            MessageLookupByLibrary.simpleMessage("Top Crops (Value)"),
        "stats_type_fast": MessageLookupByLibrary.simpleMessage("Fast"),
        "stats_type_long_term":
            MessageLookupByLibrary.simpleMessage("Long Term"),
        "status_failed": MessageLookupByLibrary.simpleMessage("Failed"),
        "status_growing": MessageLookupByLibrary.simpleMessage("Growing"),
        "status_harvested": MessageLookupByLibrary.simpleMessage("Harvested"),
        "status_planted": MessageLookupByLibrary.simpleMessage("Planted"),
        "status_ready_to_harvest":
            MessageLookupByLibrary.simpleMessage("Ready to harvest"),
        "status_sown": MessageLookupByLibrary.simpleMessage("Sown"),
        "task_editor_action_cancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "task_editor_action_create":
            MessageLookupByLibrary.simpleMessage("Create"),
        "task_editor_action_save": MessageLookupByLibrary.simpleMessage("Save"),
        "task_editor_assignee_add": m72,
        "task_editor_assignee_label":
            MessageLookupByLibrary.simpleMessage("Assigned to"),
        "task_editor_assignee_none":
            MessageLookupByLibrary.simpleMessage("No results."),
        "task_editor_date_label":
            MessageLookupByLibrary.simpleMessage("Start Date"),
        "task_editor_description_label":
            MessageLookupByLibrary.simpleMessage("Description"),
        "task_editor_duration_label":
            MessageLookupByLibrary.simpleMessage("Estimated Duration"),
        "task_editor_duration_other":
            MessageLookupByLibrary.simpleMessage("Other"),
        "task_editor_error_title_required":
            MessageLookupByLibrary.simpleMessage("Required"),
        "task_editor_export_label":
            MessageLookupByLibrary.simpleMessage("Output / Share"),
        "task_editor_garden_all":
            MessageLookupByLibrary.simpleMessage("All Gardens"),
        "task_editor_option_docx":
            MessageLookupByLibrary.simpleMessage("Export — Word (.docx)"),
        "task_editor_option_none":
            MessageLookupByLibrary.simpleMessage("None (Save Only)"),
        "task_editor_option_pdf":
            MessageLookupByLibrary.simpleMessage("Export — PDF"),
        "task_editor_option_share":
            MessageLookupByLibrary.simpleMessage("Share (Text)"),
        "task_editor_photo_add":
            MessageLookupByLibrary.simpleMessage("Add Photo"),
        "task_editor_photo_change":
            MessageLookupByLibrary.simpleMessage("Change Photo"),
        "task_editor_photo_help": MessageLookupByLibrary.simpleMessage(
            "The photo will be automatically attached to PDF / Word upon creation / sending."),
        "task_editor_photo_label":
            MessageLookupByLibrary.simpleMessage("Task Photo"),
        "task_editor_photo_placeholder":
            MessageLookupByLibrary.simpleMessage("Add Photo (Coming Soon)"),
        "task_editor_photo_remove":
            MessageLookupByLibrary.simpleMessage("Remove Photo"),
        "task_editor_priority_label":
            MessageLookupByLibrary.simpleMessage("Priority"),
        "task_editor_recurrence_days_suffix":
            MessageLookupByLibrary.simpleMessage(" d"),
        "task_editor_recurrence_interval":
            MessageLookupByLibrary.simpleMessage("Every X days"),
        "task_editor_recurrence_label":
            MessageLookupByLibrary.simpleMessage("Recurrence"),
        "task_editor_recurrence_monthly":
            MessageLookupByLibrary.simpleMessage("Monthly (same day)"),
        "task_editor_recurrence_none":
            MessageLookupByLibrary.simpleMessage("None"),
        "task_editor_recurrence_repeat_label":
            MessageLookupByLibrary.simpleMessage("Repeat every "),
        "task_editor_recurrence_weekly":
            MessageLookupByLibrary.simpleMessage("Weekly (Days)"),
        "task_editor_time_label": MessageLookupByLibrary.simpleMessage("Time"),
        "task_editor_title_edit":
            MessageLookupByLibrary.simpleMessage("Edit Task"),
        "task_editor_title_field":
            MessageLookupByLibrary.simpleMessage("Title *"),
        "task_editor_title_new":
            MessageLookupByLibrary.simpleMessage("New Task"),
        "task_editor_type_label":
            MessageLookupByLibrary.simpleMessage("Task Type"),
        "task_editor_urgent_label":
            MessageLookupByLibrary.simpleMessage("Urgent"),
        "task_editor_zone_empty":
            MessageLookupByLibrary.simpleMessage("No beds for this garden"),
        "task_editor_zone_label":
            MessageLookupByLibrary.simpleMessage("Zone (Bed)"),
        "task_editor_zone_none":
            MessageLookupByLibrary.simpleMessage("No specific zone"),
        "task_kind_amendment":
            MessageLookupByLibrary.simpleMessage("Amendment 🪵"),
        "task_kind_buy": MessageLookupByLibrary.simpleMessage("Buy 🛒"),
        "task_kind_clean": MessageLookupByLibrary.simpleMessage("Clean 🧹"),
        "task_kind_generic": MessageLookupByLibrary.simpleMessage("Generic"),
        "task_kind_harvest": MessageLookupByLibrary.simpleMessage("Harvest 🧺"),
        "task_kind_pruning": MessageLookupByLibrary.simpleMessage("Pruning ✂️"),
        "task_kind_repair": MessageLookupByLibrary.simpleMessage("Repair 🛠️"),
        "task_kind_seeding": MessageLookupByLibrary.simpleMessage("Seeding 🌱"),
        "task_kind_treatment":
            MessageLookupByLibrary.simpleMessage("Treatment 🧪"),
        "task_kind_watering":
            MessageLookupByLibrary.simpleMessage("Watering 💧"),
        "task_kind_weeding": MessageLookupByLibrary.simpleMessage("Weeding 🌿"),
        "task_kind_winter_protection":
            MessageLookupByLibrary.simpleMessage("Winter Protection ❄️"),
        "terms_text": MessageLookupByLibrary.simpleMessage(
            "By using Sowing, you agree to:\n\n• Use the application responsibly\n• Not attempt to bypass its limitations\n• Respect intellectual property rights\n• Use only your own data\n\nThis application is provided as is, without warranty.\n\nThe Sowing team remains attentive to any future improvement or evolution."),
        "user_guide_text": MessageLookupByLibrary.simpleMessage(
            "1 — Welcome to Sowing\nSowing is an application designed to support gardeners in the lively and concrete monitoring of their crops.\nIt allows you to:\n• organize your gardens and plots,\n• follow your plantings throughout their life cycle,\n• plan your tasks at the right time,\n• keep a memory of what has been done,\n• take into account local weather and the rhythm of the seasons.\nThe application works mainly offline and keeps your data directly on your device.\nThis manual describes the common use of Sowing: getting started, creating gardens, plantings, calendar, weather, data export and best practices.\n\n2 — Understanding the interface\nThe dashboard\nUpon opening, Sowing displays a visual and organic dashboard.\nIt takes the form of a background image animated by interactive bubbles. Each bubble gives access to a major function of the application:\n• gardens,\n• air weather,\n• soil weather,\n• calendar,\n• activities,\n• statistics,\n• settings.\nGeneral navigation\nSimply touch a bubble to open the corresponding section.\nInside the pages, you will find depending on the context:\n• contextual menus,\n• \"+\" buttons to add an element,\n• edit or delete buttons.\n\n3 — Quick Start\nOpen the application\nAt launch, the dashboard is displayed automatically.\nConfigure the weather\nIn the settings, choose your location.\nThis information allows Sowing to display local weather adapted to your garden. If no location is selected, a default location is used.\nCreate your first garden\nWhen using for the first time, Sowing automatically guides you to create your first garden.\nYou can also create a garden manually from the dashboard.\nOn the main screen, touch the green leaf located in the freest area, to the right of the statistics and slightly above. This deliberately discreet area allows you to initiate the creation of a garden.\nYou can create up to five gardens.\nThis approach is part of the Sowing experience: there is no permanent and central \"+\" button. The application rather invites exploration and progressive discovery of space.\nThe areas linked to the gardens are also accessible from the Settings menu.\nOrganic calibration of the dashboard\nAn organic calibration mode allows:\n• to visualize the real location of interactive zones,\n• to move them by simple sliding of the finger.\nYou can thus position your gardens and modules exactly where you want on the image: at the top, at the bottom or at the place that suits you best.\nOnce validated, this organization is saved and kept in the application.\nCreate a plot\nIn a garden sheet:\n• choose \"Add a plot\",\n• indicate its name, its area and, if necessary, some notes,\n• save.\nAdd a planting\nIn a plot:\n• press the \"+\" button,\n• choose a plant from the catalog,\n• indicate the date, the quantity and useful information,\n• validate.\n\n4 — The organic dashboard\nThe dashboard is the central point of Sowing.\nIt allows:\n• to have an overview of your activity,\n• to quickly access the main functions,\n• to navigate intuitively.\nDepending on your settings, some bubbles may display synthetic information, such as the weather or upcoming tasks.\n\n5 — Gardens, plots and plantings\nThe gardens\nA garden represents a real place: vegetable garden, greenhouse, orchard, balcony, etc.\nYou can:\n• create several gardens,\n• modify their information,\n• delete them if necessary.\nThe plots\nA plot is a precise zone inside a garden.\nIt allows to structure the space, organize crops and group several plantings in the same place.\nThe plantings\nA planting corresponds to the introduction of a plant in a plot, at a given date.\nWhen creating a planting, Sowing offers two modes.\nSow\nThe \"Sow\" mode corresponds to putting a seed in the ground.\nIn this case:\n• the progression starts at 0%,\n• a step-by-step follow-up is proposed, particularly useful for beginner gardeners,\n• a progress bar visualizes the advancement of the crop cycle.\nThis follow-up allows to estimate:\n• the probable start of the harvest period,\n• the evolution of the crop over time, in a simple and visual way.\nPlant\nThe \"Plant\" mode is intended for plants already developed (plants from a greenhouse or purchased in a garden center).\nIn this case:\n• the plant starts with a progression of about 30%,\n• the follow-up is immediately more advanced,\n• the estimation of the harvest period is adjusted consequently.\nChoice of date\nWhen planting, you can freely choose the date.\nThis allows for example:\n• to fill in a planting carried out previously,\n• to correct a date if the application was not used at the time of sowing or planting.\nBy default, the current date is used.\nFollow-up and history\nEach planting has:\n• a progression follow-up,\n• information on its life cycle,\n• crop stages,\n• personal notes.\nAll actions (sowing, planting, care, harvesting) are automatically recorded in the garden history.\n\n6 — Plant catalog\nThe catalog brings together all the plants available when creating a planting.\nIt constitutes an scalable reference base, designed to cover current uses while remaining customizable.\nMain functions:\n• simple and quick search,\n• recognition of common and scientific names,\n• display of photos when available.\nCustom plants\nYou can create your own custom plants from:\nSettings → Plant catalog.\nIt is then possible to:\n• create a new plant,\n• fill in the essential parameters (name, type, useful information),\n• add an image to facilitate identification.\nThe custom plants are then usable like any other plant in the catalog.\n\n7 — Calendar and tasks\nThe calendar view\nThe calendar displays:\n• planned tasks,\n• important plantings,\n• estimated harvest periods.\nCreate a task\nFrom the calendar:\n• create a new task,\n• indicate a title, a date and a description,\n• choose a possible recurrence.\nThe tasks can be associated with a garden or a plot.\nTask management\nYou can:\n• modify a task,\n• delete it,\n• export it to share it.\n\n8 — Activities and history\nThis section constitutes the living memory of your gardens.\nSelection of a garden\nFrom the dashboard, long press a garden to select it.\nThe active garden is highlighted by a light green halo and a confirmation banner.\nThis selection allows to filter the displayed information.\nRecent activities\nThe \"Activities\" tab displays chronologically:\n• creations,\n• plantings,\n• care,\n• harvests,\n• manual actions.\nHistory by garden\nThe \"History\" tab presents the complete history of the selected garden, year after year.\nIt allows in particular to:\n• find past plantings,\n• check if a plant has already been cultivated in a given place,\n• better organize crop rotation.\n\n9 — Air weather and soil weather\nAir weather\nThe air weather provides essential information:\n• outside temperature,\n• precipitation (rain, snow, no rain),\n• day / night alternation.\nThis data helps to anticipate climatic risks and adapt interventions.\nSoil weather\nSowing integrates a soil weather module.\nThe user can fill in a measured temperature. From this data, the application dynamically estimates the evolution of the soil temperature over time.\nThis information allows:\n• to know which plants are really cultivable at a given time,\n• to adjust sowing to real conditions rather than a theoretical calendar.\nReal-time weather on the dashboard\nA central ovoid-shaped module displays at a glance:\n• the state of the sky,\n• day or night,\n• the phase and position of the moon for the selected location.\nTime navigation\nBy sliding your finger from left to right on the ovoid, you browse the forecasts hour by hour, up to more than 12 hours in advance.\nThe temperature and precipitation adjust dynamically during the gesture.\n\n10 — Recommendations\nSowing can offer recommendations adapted to your situation.\nThey rely on:\n• the season,\n• the weather,\n• the state of your plantings.\nEach recommendation specifies:\n• what to do,\n• when to act,\n• why the action is suggested.\n\n11 — Export and sharing\nPDF Export — calendar and tasks\nThe calendar tasks can be exported to PDF.\nThis allows to:\n• share clear information,\n• transmit a planned intervention,\n• keep a readable and dated trace.\nExcel Export — harvests and statistics\nThe harvest data can be exported in Excel format in order to:\n• analyze the results,\n• produce reports,\n• follow the evolution over time.\nDocument sharing\nThe generated documents can be shared via the applications available on your device (messaging, storage, transfer to a computer, etc.).\n\n12 — Backup and best practices\nThe data is stored locally on your device.\nRecommended best practices:\n• make a backup before a major update,\n• export your data regularly,\n• keep the application and the device up to date.\n\n13 — Settings\nThe Settings menu allows to adapt Sowing to your uses.\nYou can notably:\n• choose the language,\n• select your location,\n• access the plant catalog,\n• customize the dashboard.\nDashboard customization\nIt is possible to:\n• reposition each module,\n• adjust the visual space,\n• change the background image,\n• import your own image (feature coming soon).\nLegal information\nFrom the settings, you can consult:\n• the user guide,\n• the privacy policy,\n• the terms of use.\n\n14 — Frequently asked questions\nThe touch zones are not well aligned\nDepending on the phone or display settings, some zones may seem shifted.\nAn organic calibration mode allows to:\n• visualize the touch zones,\n• reposition them by sliding,\n• save the configuration for your device.\nCan I use Sowing without connection?\nYes. Sowing works offline for the management of gardens, plantings, tasks and history.\nA connection is only used:\n• for the recovery of weather data,\n• during the export or sharing of documents.\nNo other data is transmitted.\n\n15 — Final remark\nSowing is designed as a gardening companion: simple, lively and scalable.\nTake the time to observe, note and trust your experience as much as the tool."),
        "weather_action_retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "weather_data_gusts": MessageLookupByLibrary.simpleMessage("Gusts"),
        "weather_data_max": MessageLookupByLibrary.simpleMessage("Max"),
        "weather_data_min": MessageLookupByLibrary.simpleMessage("Min"),
        "weather_data_rain": MessageLookupByLibrary.simpleMessage("Rain"),
        "weather_data_speed": MessageLookupByLibrary.simpleMessage("Speed"),
        "weather_data_sunrise": MessageLookupByLibrary.simpleMessage("Sunrise"),
        "weather_data_sunset": MessageLookupByLibrary.simpleMessage("Sunset"),
        "weather_data_wind_max":
            MessageLookupByLibrary.simpleMessage("Max Wind"),
        "weather_error_loading":
            MessageLookupByLibrary.simpleMessage("Unable to load weather"),
        "weather_header_daily_summary":
            MessageLookupByLibrary.simpleMessage("DAILY SUMMARY"),
        "weather_header_next_24h":
            MessageLookupByLibrary.simpleMessage("NEXT 24H"),
        "weather_header_precipitations":
            MessageLookupByLibrary.simpleMessage("PRECIPITATION (24h)"),
        "weather_label_astro": MessageLookupByLibrary.simpleMessage("ASTRO"),
        "weather_label_pressure":
            MessageLookupByLibrary.simpleMessage("PRESSURE"),
        "weather_label_sun": MessageLookupByLibrary.simpleMessage("SUN"),
        "weather_label_wind": MessageLookupByLibrary.simpleMessage("WIND"),
        "weather_pressure_high": MessageLookupByLibrary.simpleMessage("High"),
        "weather_pressure_low": MessageLookupByLibrary.simpleMessage("Low"),
        "weather_provider_credit":
            MessageLookupByLibrary.simpleMessage("Data provided by Open-Meteo"),
        "weather_screen_title": MessageLookupByLibrary.simpleMessage("Weather"),
        "weather_today_label": MessageLookupByLibrary.simpleMessage("Today"),
        "wmo_code_0": MessageLookupByLibrary.simpleMessage("Clear sky"),
        "wmo_code_1": MessageLookupByLibrary.simpleMessage("Mainly clear"),
        "wmo_code_2": MessageLookupByLibrary.simpleMessage("Partly cloudy"),
        "wmo_code_3": MessageLookupByLibrary.simpleMessage("Overcast"),
        "wmo_code_45": MessageLookupByLibrary.simpleMessage("Fog"),
        "wmo_code_48":
            MessageLookupByLibrary.simpleMessage("Depositing rime fog"),
        "wmo_code_51": MessageLookupByLibrary.simpleMessage("Light drizzle"),
        "wmo_code_53": MessageLookupByLibrary.simpleMessage("Moderate drizzle"),
        "wmo_code_55": MessageLookupByLibrary.simpleMessage("Dense drizzle"),
        "wmo_code_61": MessageLookupByLibrary.simpleMessage("Slight rain"),
        "wmo_code_63": MessageLookupByLibrary.simpleMessage("Moderate rain"),
        "wmo_code_65": MessageLookupByLibrary.simpleMessage("Heavy rain"),
        "wmo_code_66":
            MessageLookupByLibrary.simpleMessage("Light freezing rain"),
        "wmo_code_67":
            MessageLookupByLibrary.simpleMessage("Heavy freezing rain"),
        "wmo_code_71": MessageLookupByLibrary.simpleMessage("Slight snow fall"),
        "wmo_code_73":
            MessageLookupByLibrary.simpleMessage("Moderate snow fall"),
        "wmo_code_75": MessageLookupByLibrary.simpleMessage("Heavy snow fall"),
        "wmo_code_77": MessageLookupByLibrary.simpleMessage("Snow grains"),
        "wmo_code_80":
            MessageLookupByLibrary.simpleMessage("Slight rain showers"),
        "wmo_code_81":
            MessageLookupByLibrary.simpleMessage("Moderate rain showers"),
        "wmo_code_82":
            MessageLookupByLibrary.simpleMessage("Violent rain showers"),
        "wmo_code_85":
            MessageLookupByLibrary.simpleMessage("Slight snow showers"),
        "wmo_code_86":
            MessageLookupByLibrary.simpleMessage("Heavy snow showers"),
        "wmo_code_95": MessageLookupByLibrary.simpleMessage("Thunderstorm"),
        "wmo_code_96": MessageLookupByLibrary.simpleMessage(
            "Thunderstorm with slight hail"),
        "wmo_code_99": MessageLookupByLibrary.simpleMessage(
            "Thunderstorm with heavy hail"),
        "wmo_code_unknown":
            MessageLookupByLibrary.simpleMessage("Unknown conditions")
      };
}
