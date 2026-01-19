// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sowing';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get home_settings_fallback_label => 'Ajustes (respaldo)';

  @override
  String get settings_application => 'Aplicación';

  @override
  String get settings_version => 'Versión';

  @override
  String get settings_display => 'Visualización';

  @override
  String get settings_weather_selector => 'Selector de clima';

  @override
  String get settings_commune_title => 'Ubicación para el clima';

  @override
  String get settings_choose_commune => 'Elegir una ubicación';

  @override
  String get settings_search_commune_hint => 'Buscar una ubicación...';

  @override
  String settings_commune_default(String label) {
    return 'Por defecto: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Seleccionada: $label';
  }

  @override
  String get settings_quick_access => 'Acceso rápido';

  @override
  String get settings_plants_catalog => 'Catálogo de plantas';

  @override
  String get settings_plants_catalog_subtitle => 'Buscar y ver plantas';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_user_guide => 'Guía de usuario';

  @override
  String get settings_user_guide_subtitle => 'Consultar el manual';

  @override
  String get settings_privacy => 'Privacidad';

  @override
  String get settings_privacy_policy => 'Política de privacidad';

  @override
  String get settings_terms => 'Condiciones de uso';

  @override
  String get settings_version_dialog_title => 'Versión de la aplicación';

  @override
  String settings_version_dialog_content(String version) {
    return 'Versión: $version – Gestión de jardines dinámica\n\nSowing - Gestión de jardines vivos';
  }

  @override
  String get language_title => 'Idioma / Language';

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
    return 'Idioma cambiado: $label';
  }

  @override
  String get calibration_title => 'Calibración';

  @override
  String get calibration_subtitle => 'Personaliza la visualización de tu panel';

  @override
  String get calibration_organic_title => 'Calibración Orgánica';

  @override
  String get calibration_organic_subtitle =>
      'Modo unificado: Imagen, El Cielo, Módulos';

  @override
  String get calibration_organic_disabled =>
      '🌿 Calibración orgánica desactivada';

  @override
  String get calibration_organic_enabled =>
      '🌿 Modo de calibración orgánica activado. Seleccione una de las tres pestañas.';

  @override
  String get garden_list_title => 'Mis jardines';

  @override
  String get garden_error_title => 'Error de carga';

  @override
  String garden_error_subtitle(String error) {
    return 'No se puede cargar la lista de jardines: $error';
  }

  @override
  String get garden_retry => 'Reintentar';

  @override
  String get garden_no_gardens => 'Ningún jardín por el momento.';

  @override
  String get garden_archived_info =>
      'Tienes jardines archivados. Activa la visualización de jardines archivados para verlos.';

  @override
  String get garden_add_tooltip => 'Añadir un jardín';

  @override
  String get plant_catalog_title => 'Catálogo de plantas';

  @override
  String get plant_custom_badge => 'Personalizado';

  @override
  String get plant_detail_not_found_title => 'Planta no encontrada';

  @override
  String get plant_detail_not_found_body =>
      'Esta planta no existe o no se pudo cargar.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant añadida a favoritos';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Añadir al jardín';

  @override
  String get plant_detail_popup_share => 'Compartir';

  @override
  String get plant_detail_share_todo => 'Compartir no implementado';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Añadir al jardín no implementado';

  @override
  String get plant_detail_section_culture => 'Detalles de cultivo';

  @override
  String get plant_detail_section_instructions => 'Instrucciones generales';

  @override
  String get plant_detail_detail_family => 'Familia';

  @override
  String get plant_detail_detail_maturity => 'Duración de maduración';

  @override
  String get plant_detail_detail_spacing => 'Espaciamiento';

  @override
  String get plant_detail_detail_exposure => 'Exposición';

  @override
  String get plant_detail_detail_water => 'Necesidades de agua';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Plantaciones - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Estadísticas';

  @override
  String get planting_menu_ready_for_harvest => 'Listo para cosechar';

  @override
  String get planting_menu_test_data => 'Datos de prueba';

  @override
  String get planting_search_hint => 'Buscar una plantación...';

  @override
  String get planting_filter_all_statuses => 'Todos los estados';

  @override
  String get planting_filter_all_plants => 'Todas las plantas';

  @override
  String get planting_stat_plantings => 'Plantaciones';

  @override
  String get planting_stat_total_quantity => 'Cantidad total';

  @override
  String get planting_stat_success_rate => 'Tasa de éxito';

  @override
  String get planting_stat_in_growth => 'En crecimiento';

  @override
  String get planting_stat_ready_for_harvest => 'Listo para cosechar';

  @override
  String get planting_empty_none => 'Ninguna plantación';

  @override
  String get planting_empty_first =>
      'Comienza añadiendo tu primera plantación en esta parcela.';

  @override
  String get planting_create_action => 'Crear plantación';

  @override
  String get planting_empty_no_result => 'Sin resultados';

  @override
  String get planting_clear_filters => 'Borrar filtros';

  @override
  String get planting_add_tooltip => 'Añadir una plantación';

  @override
  String get search_hint => 'Buscar...';

  @override
  String get error_page_title => 'Página no encontrada';

  @override
  String error_page_message(String uri) {
    return 'La página \"$uri\" no existe.';
  }

  @override
  String get error_page_back => 'Volver al inicio';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get dialog_cancel => 'Cancelar';

  @override
  String snackbar_commune_selected(String name) {
    return 'Ubicación seleccionada: $name';
  }

  @override
  String get common_validate => 'Validar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get empty_action_create => 'Crear';

  @override
  String get user_guide_text =>
      '1 — Bienvenido a Sowing\n(Traducción en curso...)\nSowing es una aplicación diseñada para acompañar a los jardineros en el seguimiento vivo y concreto de sus cultivos.\n...';

  @override
  String get privacy_policy_text =>
      'Sowing respeta plenamente su privacidad.\n\n• Todos los datos se almacenan localmente en su dispositivo\n• No se transmiten datos personales a terceros\n• Ninguna información se almacena en un servidor externo\n\nLa aplicación funciona completamente sin conexión. Una conexión a Internet solo se utiliza para recuperar datos meteorológicos o durante las exportaciones.';

  @override
  String get terms_text =>
      'Al usar Sowing, usted acepta:\n\n• Usar la aplicación de manera responsable\n• No intentar eludir sus limitaciones\n• Respetar los derechos de propiedad intelectual\n• Usar solo sus propios datos\n\nEsta aplicación se proporciona tal cual, sin garantía.\n\nEl equipo de Sowing permanece atento a cualquier mejora o evolución futura.';

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
  String get task_editor_error_title_required => 'Required';

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
  String get garden_detail_title_error => 'Erreur';

  @override
  String get garden_detail_subtitle_not_found =>
      'Le jardin demande n\'existe pas ou a été supprimé.';

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
  String get harvest_price_label => 'Prix estimé (€/kg)';

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
}
