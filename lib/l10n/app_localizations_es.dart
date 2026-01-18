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
}
