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
  String get garden_creation_dialog_title => 'Crea tu primer jardín';

  @override
  String get garden_creation_dialog_description =>
      'Dale un nombre a tu espacio de permacultura para comenzar.';

  @override
  String get garden_creation_name_label => 'Nombre del jardín';

  @override
  String get garden_creation_name_hint => 'Ej: Mi Huerto';

  @override
  String get garden_creation_name_required => 'El nombre es obligatorio';

  @override
  String get garden_creation_create_button => 'Crear';

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
  String get settings_choose_commune => 'Elegir ubicación';

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
  String get settings_notifications_title => 'Notificaciones';

  @override
  String get settings_notifications_subtitle =>
      'Activar recordatorios y alertas';

  @override
  String get settings_notification_permission_dialog_title =>
      'Permiso requerido';

  @override
  String get settings_notification_permission_dialog_content =>
      'Las notificaciones están desactivadas. Por favor, actívelas en la configuración del sistema para recibir recordatorios.';

  @override
  String get settings_open_system_settings => 'Abrir ajustes';

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
      'Modo unificado: Imagen, Cielo, Módulos';

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
  String get plant_catalog_search_hint => 'Buscar una planta...';

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
  String get plant_detail_share_todo => 'Compartir no implementado todavía';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Añadir al jardín no implementado todavía';

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
  String get common_save => 'Guardar';

  @override
  String get empty_action_create => 'Crear';

  @override
  String get user_guide_text =>
      '1 — Bienvenido a Sowing\nSowing es una aplicación diseñada para apoyar a los jardineros en el seguimiento animado y concreto de sus cultivos.\nLe permite:\n• organizar sus jardines y parcelas,\n• seguir sus plantaciones a lo largo de su ciclo de vida,\n• planificar sus tareas en el momento adecuado,\n• mantener un recuerdo de lo que se ha hecho,\n• tener en cuenta el clima local y el ritmo de las estaciones.\nLa aplicación funciona principalmente sin conexión y mantiene sus datos directamente en su dispositivo.\nEste manual describe el uso común de Sowing: primeros pasos, creación de jardines, plantaciones, calendario, clima, exportación de datos y mejores prácticas.\n\n2 — Comprendiendo la interfaz\nEl tablero\nAl abrir, Sowing muestra un tablero visual y orgánico.\nToma la forma de una imagen de fondo animada por burbujas interactivas. Cada burbuja da acceso a una función principal de la aplicación:\n• jardines,\n• clima aéreo,\n• clima del suelo,\n• calendario,\n• actividades,\n• estadísticas,\n• ajustes.\nNavegación general\nSimplemente toque una burbuja para abrir la sección correspondiente.\nDentro de las páginas, encontrará dependiendo del contexto:\n• menús contextuales,\n• botones \"+\" para añadir un elemento,\n• botones de edición o eliminación.\n\n3 — Inicio rápido\nAbrir la aplicación\nAl iniciar, el tablero se muestra automáticamente.\nConfigurar el clima\nEn los ajustes, elija su ubicación.\nEsta información permite a Sowing mostrar el clima local adaptado a su jardín. Si no se selecciona ninguna ubicación, se utiliza una predeterminada.\nCrear su primer jardín\nAl usar por primera vez, Sowing le guía automáticamente para crear su primer jardín.\nTambién puede crear un jardín manualmente desde el tablero.\nEn la pantalla principal, toque la hoja verde ubicada en el área más libre, a la derecha de las estadísticas y ligeramente arriba. Esta área deliberadamente discreta le permite iniciar la creación de un jardín.\nPuede crear hasta cinco jardines.\nEste enfoque es parte de la experiencia Sowing: no hay un botón \"+\" permanente y central. La aplicación invita más bien a la exploración y el descubrimiento progresivo del espacio.\nLas áreas vinculadas a los jardines también son accesibles desde el menú Ajustes.\nCalibración orgánica del tablero\nUn modo de calibración orgánica permite:\n• visualizar la ubicación real de las zonas interactivas,\n• moverlas simplemente deslizando el dedo.\nAsí puede posicionar sus jardines y módulos exactamente donde quiera en la imagen: arriba, abajo o en el lugar que mejor le convenga.\nUna vez validada, esta organización se guarda y se mantiene en la aplicación.\nCrear una parcela\nEn una ficha de jardín:\n• elija \"Añadir una parcela\",\n• indique su nombre, su área y, si es necesario, algunas notas,\n• guarde.\nAñadir una plantación\nEn una parcela:\n• presione el botón \"+\",\n• elija una planta del catálogo,\n• indique la fecha, la cantidad e información útil,\n• valide.\n\n4 — El tablero orgánico\nEl tablero es el punto central de Sowing.\nPermite:\n• tener una visión general de su actividad,\n• acceder rápidamente a las funciones principales,\n• navegar intuitivamente.\nDependiendo de sus ajustes, algunas burbujas pueden mostrar información sintética, como el clima o las tareas próximas.\n\n5 — Jardines, parcelas y plantaciones\nLos jardines\nUn jardín representa un lugar real: huerto, invernadero, huerto frutal, balcón, etc.\nPuede:\n• crear varios jardines,\n• modificar su información,\n• eliminarlos si es necesario.\nLas parcelas\nUna parcela es una zona precisa dentro de un jardín.\nPermite estructurar el espacio, organizar cultivos y agrupar varias plantaciones en el mismo lugar.\nLas plantaciones\nUna plantación corresponde a la introducción de una planta en una parcela, en una fecha dada.\nAl crear una plantación, Sowing ofrece dos modos.\nSembrar\nEl modo \"Sembrar\" corresponde a poner una semilla en la tierra.\nEn este caso:\n• el progreso comienza en 0%,\n• se propone un seguimiento paso a paso, particularmente útil para jardineros principiantes,\n• una barra de progreso visualiza el avance del ciclo de cultivo.\nEste seguimiento permite estimar:\n• el inicio probable del período de cosecha,\n• la evolución del cultivo a lo largo del tiempo, de una manera simple y visual.\nPlantar\nEl modo \"Plantar\" está destinado a plantas ya desarrolladas (plantas de un invernadero o compradas en un centro de jardinería).\nEn este caso:\n• la planta comienza con un progreso de aproximadamente 30%,\n• el seguimiento es inmediatamente más avanzado,\n• la estimación del período de cosecha se ajusta en consecuencia.\nElección de fecha\nAl plantar, puede elegir libremente la fecha.\nEsto permite por ejemplo:\n• rellenar una plantación realizada anteriormente,\n• corregir una fecha si la aplicación no se usó en el momento de la siembra o plantación.\nPor defecto, se utiliza la fecha actual.\nSeguimiento e historial\nCada plantación tiene:\n• un seguimiento de progreso,\n• información sobre su ciclo de vida,\n• etapas de cultivo,\n• notas personales.\nTodas las acciones (siembra, plantación, cuidado, cosecha) se registran automáticamente en el historial del jardín.\n\n6 — Catálogo de plantas\nEl catálogo reúne todas las plantas disponibles al crear una plantación.\nConstituye una base de referencia escalable, diseñada para cubrir usos actuales mientras permanece personalizable.\nFunciones principales:\n• búsqueda simple y rápida,\n• reconocimiento de nombres comunes y científicos,\n• visualización de fotos cuando están disponibles.\nPlantas personalizadas\nPuede crear sus propias plantas personalizadas desde:\nAjustes → Catálogo de plantas.\nEntonces es posible:\n• crear una nueva planta,\n• rellenar los parámetros esenciales (nombre, tipo, información útil),\n• añadir una imagen para facilitar la identificación.\nLas plantas personalizadas son entonces utilizables como cualquier otra planta en el catálogo.\n\n7 — Calendario y tareas\nLa vista de calendario\nEl calendario muestra:\n• tareas planificadas,\n• plantaciones importantes,\n• períodos de cosecha estimados.\nCrear una tarea\nDesde el calendario:\n• cree una nueva tarea,\n• indique un título, una fecha y una descripción,\n• elija una posible recurrencia.\nLas tareas pueden asociarse con un jardín o una parcela.\nGestión de tareas\nPuede:\n• modificar una tarea,\n• eliminarla,\n• exportarla para compartirla.\n\n8 — Actividades e historial\nEsta sección constituye la memoria viva de sus jardines.\nSelección de un jardín\nDesde el tablero, mantenga presionado un jardín para seleccionarlo.\nEl jardín activo se resalta con un halo verde claro y un banner de confirmación.\nEsta selección permite filtrar la información mostrada.\nActividades recientes\nLa pestaña \"Actividades\" muestra cronológicamente:\n• creaciones,\n• plantaciones,\n• cuidados,\n• cosechas,\n• acciones manuales.\nHistorial por jardín\nLa pestaña \"Historial\" presenta el historial completo del jardín seleccionado, año tras año.\nPermite en particular:\n• encontrar plantaciones pasadas,\n• verificar si una planta ya se ha cultivado en un lugar dado,\n• organizar mejor la rotación de cultivos.\n\n9 — Clima aéreo y clima del suelo\nClima aéreo\nEl clima aéreo proporciona información esencial:\n• temperatura exterior,\n• precipitaciones (lluvia, nieve, sin lluvia),\n• alternancia día / noche.\nEstos datos ayudan a anticipar riesgos climáticos y adaptar intervenciones.\nClima del suelo\nSowing integra un módulo de clima del suelo.\nEl usuario puede rellenar una temperatura medida. A partir de estos datos, la aplicación estima dinámicamente la evolución de la temperatura del suelo a lo largo del tiempo.\nEsta información permite:\n• saber qué plantas son realmente cultivables en un momento dado,\n• ajustar la siembra a las condiciones reales en lugar de un calendario teórico.\nClima en tiempo real en el tablero\nUn módulo central en forma de ovoide muestra de un vistazo:\n• el estado del cielo,\n• día o noche,\n• la fase y posición de la luna para la ubicación seleccionada.\nNavegación en el tiempo\nDeslizando el dedo de izquierda a derecha sobre el ovoide, navega por las previsiones hora por hora, hasta más de 12 horas por adelantado.\nLa temperatura y las precipitaciones se ajustan dinámicamente durante el gesto.\n\n10 — Recomendaciones\nSowing puede ofrecer recomendaciones adaptadas a su situación.\nSe basan en:\n• la temporada,\n• el clima,\n• el estado de sus plantaciones.\nCada recomendación especifica:\n• qué hacer,\n• cuándo actuar,\n• por qué se sugiere la acción.\n\n11 — Exportación y uso compartido\nExportación PDF — calendario y tareas\nLas tareas del calendario se pueden exportar a PDF.\nEsto permite:\n• compartir información clara,\n• transmitir una intervención planificada,\n• mantener un rastro legible y fechado.\nExportación Excel — cosechas y estadísticas\nLos datos de cosecha se pueden exportar en formato Excel para:\n• analizar los resultados,\n• producir informes,\n• seguir la evolución a lo largo del tiempo.\nUso compartido de documentos\nLos documentos generados se pueden compartir a través de las aplicaciones disponibles en su dispositivo (mensajería, almacenamiento, transferencia a una computadora, etc.).\n\n12 — Copia de seguridad y mejores prácticas\nLos datos se almacenan localmente en su dispositivo.\nMejores prácticas recomendadas:\n• haga una copia de seguridad antes de una actualización importante,\n• exporte sus datos regularmente,\n• mantenga la aplicación y el dispositivo actualizados.\n\n13 — Ajustes\nEl menú Ajustes permite adaptar Sowing a sus usos.\nPuede notablemente:\n• elegir el idioma,\n• seleccionar su ubicación,\n• acceder al catálogo de plantas,\n• personalizar el tablero.\nPersonalización del tablero\nEs posible:\n• reposicionar cada módulo,\n• ajustar el espacio visual,\n• cambiar la imagen de fondo,\n• importar su propia imagen (función próximamente).\nInformación legal\nDesde los ajustes, puede consultar:\n• la guía de usuario,\n• la política de privacidad,\n• las condiciones de uso.\n\n14 — Preguntas frecuentes\nLas zonas táctiles no están bien alineadas\nDependiendo del teléfono o los ajustes de pantalla, algunas zonas pueden parecer desplazadas.\nUn modo de calibración orgánica permite:\n• visualizar las zonas táctiles,\n• reposicionarlas deslizándolas,\n• guardar la configuración para su dispositivo.\n¿Puedo usar Sowing sin conexión?\nSí. Sowing funciona sin conexión para la gestión de jardines, plantaciones, tareas e historial.\nSolo se utiliza una conexión:\n• para la recuperación de datos meteorológicos,\n• durante la exportación o uso compartido de documentos.\nNo se transmiten otros datos.\n\n15 — Observación final\nSowing está diseñado como un compañero de jardinería: simple, vivo y escalable.\nTómese el tiempo para observar, anotar y confiar en su experiencia tanto como en la herramienta.';

  @override
  String get privacy_policy_text =>
      'Sowing respeta plenamente su privacidad.\n\n• Todos los datos se almacenan localmente en su dispositivo\n• No se transmiten datos personales a terceros\n• Ninguna información se almacena en un servidor externo\n\nLa aplicación funciona completamente sin conexión. Una conexión a Internet solo se utiliza para recuperar datos meteorológicos o durante las exportaciones.';

  @override
  String get terms_text =>
      'Al usar Sowing, usted acepta:\n\n• Usar la aplicación de manera responsable\n• No intentar eludir sus limitaciones\n• Respetar los derechos de propiedad intelectual\n• Usar solo sus propios datos\n\nEsta aplicación se proporciona tal cual, sin garantía.\n\nEl equipo de Sowing permanece atento a cualquier mejora o evolución futura.';

  @override
  String get calibration_auto_apply =>
      'Aplicar automáticamente para este dispositivo';

  @override
  String get calibration_calibrate_now => 'Calibrar ahora';

  @override
  String get calibration_save_profile =>
      'Guardar calibración actual como perfil';

  @override
  String get calibration_export_profile => 'Exportar perfil (copia JSON)';

  @override
  String get calibration_import_profile => 'Importar perfil desde portapapeles';

  @override
  String get calibration_reset_profile =>
      'Restablecer perfil para este dispositivo';

  @override
  String get calibration_refresh_profile =>
      'Actualizar vista previa del perfil';

  @override
  String calibration_key_device(String key) {
    return 'Clave del dispositivo: $key';
  }

  @override
  String get calibration_no_profile =>
      'No hay perfil guardado para este dispositivo.';

  @override
  String get calibration_image_settings_title =>
      'Ajustes de imagen de fondo (Persistente)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image =>
      'Restablecer valores predeterminados de imagen';

  @override
  String get calibration_dialog_confirm_title => 'Confirmar';

  @override
  String get calibration_dialog_delete_profile =>
      '¿Eliminar perfil de calibración para este dispositivo?';

  @override
  String get calibration_action_delete => 'Eliminar';

  @override
  String get calibration_snack_no_profile =>
      'No se encontró perfil para este dispositivo.';

  @override
  String get calibration_snack_profile_copied =>
      'Perfil copiado al portapapeles.';

  @override
  String get calibration_snack_clipboard_empty => 'Portapapeles vacío.';

  @override
  String get calibration_snack_profile_imported =>
      'Perfil importado y guardado para este dispositivo.';

  @override
  String calibration_snack_import_error(String error) {
    return 'Error de importación JSON: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Perfil eliminado para este dispositivo.';

  @override
  String get calibration_snack_no_calibration =>
      'No hay calibración guardada. Calibre desde el tablero primero.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Calibración actual guardada como perfil para este dispositivo.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get calibration_overlay_saved => 'Calibración guardada';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Error al guardar calibración: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Arrastre para mover, pellizque para hacer zoom en la imagen de fondo.';

  @override
  String get calibration_instruction_sky =>
      'Ajuste el ovoide día/noche (centro, tamaño, rotación).';

  @override
  String get calibration_instruction_modules =>
      'Mueva los módulos (burbujas) a la ubicación deseada.';

  @override
  String get calibration_instruction_none =>
      'Seleccione una herramienta para comenzar.';

  @override
  String get calibration_tool_image => 'Imagen';

  @override
  String get calibration_tool_sky => 'Cielo';

  @override
  String get calibration_tool_modules => 'Módulos';

  @override
  String get calibration_action_validate_exit => 'Validar y salir';

  @override
  String get garden_management_create_title => 'Crear un jardín';

  @override
  String get garden_management_edit_title => 'Editar jardín';

  @override
  String get garden_management_name_label => 'Nombre del jardín';

  @override
  String get garden_management_desc_label => 'Descripción';

  @override
  String get garden_management_image_label => 'Imagen del jardín (Opcional)';

  @override
  String get garden_management_image_url_label => 'URL de la imagen';

  @override
  String get garden_management_image_preview_error =>
      'No se puede cargar la imagen';

  @override
  String get garden_management_create_submit => 'Crear jardín';

  @override
  String get garden_management_create_submitting => 'Creando...';

  @override
  String get garden_management_created_success => 'Jardín creado con éxito';

  @override
  String get garden_management_create_error => 'Error al crear jardín';

  @override
  String get garden_management_delete_confirm_title => 'Eliminar jardín';

  @override
  String get garden_management_delete_confirm_body =>
      '¿Está seguro de que desea eliminar este jardín? Esto también eliminará todas las parcelas y plantaciones asociadas. Esta acción es irreversible.';

  @override
  String get garden_management_delete_success => 'Jardín eliminado con éxito';

  @override
  String get garden_management_archived_tag => 'Jardín archivado';

  @override
  String get garden_management_beds_title => 'Parcelas del jardín';

  @override
  String get garden_management_no_beds_title => 'Sin parcelas';

  @override
  String get garden_management_no_beds_desc =>
      'Cree parcelas para organizar sus plantaciones';

  @override
  String get garden_management_add_bed_label => 'Crear parcela';

  @override
  String get garden_management_stats_beds => 'Parcelas';

  @override
  String get garden_management_stats_area => 'Área total';

  @override
  String get dashboard_weather_stats => 'Detalles del clima';

  @override
  String get dashboard_soil_temp => 'Temp. suelo';

  @override
  String get dashboard_air_temp => 'Temperatura';

  @override
  String get dashboard_statistics => 'Estadísticas';

  @override
  String get dashboard_calendar => 'Calendario';

  @override
  String get dashboard_activities => 'Actividades';

  @override
  String get dashboard_weather => 'Clima';

  @override
  String get dashboard_settings => 'Ajustes';

  @override
  String dashboard_garden_n(int number) {
    return 'Jardín $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Jardín \"$name\" creado con éxito';
  }

  @override
  String get dashboard_garden_create_error => 'Error al crear jardín.';

  @override
  String get calendar_title => 'Calendario de cultivo';

  @override
  String get calendar_refreshed => 'Calendario actualizado';

  @override
  String get calendar_new_task_tooltip => 'Nueva tarea';

  @override
  String get calendar_task_saved_title => 'Tarea guardada';

  @override
  String get calendar_ask_export_pdf =>
      '¿Desea enviar la ficha de la tarea a alguien?';

  @override
  String get action_no_thanks => 'No, gracias';

  @override
  String get action_pdf => 'PDF';

  @override
  String get calendar_task_modified => 'Tarea modificada';

  @override
  String get calendar_delete_confirm_title => '¿Eliminar tarea?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" será eliminada.';
  }

  @override
  String get calendar_task_deleted => 'Tarea eliminada';

  @override
  String calendar_restore_error(Object error) {
    return 'Error de restauración: $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Error de eliminación: $error';
  }

  @override
  String get calendar_action_assign => 'Enviar / Asignar a...';

  @override
  String get calendar_assign_title => 'Asignar / Enviar';

  @override
  String get calendar_assign_hint => 'Ingrese nombre o correo electrónico';

  @override
  String get calendar_assign_field => 'Nombre o correo electrónico';

  @override
  String calendar_task_assigned(String name) {
    return 'Tarea asignada a $name';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Error de asignación: $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'Error de exportación PDF: $error';
  }

  @override
  String get calendar_personal_notification => 'Notificación';

  @override
  String get calendar_personal_notification_on => 'Activada';

  @override
  String get calendar_personal_notification_off => 'Desactivada';

  @override
  String get calendar_notify_before => 'Notificar antes';

  @override
  String get minutes => 'minutos';

  @override
  String get calendar_previous_month => 'Mes anterior';

  @override
  String get calendar_next_month => 'Mes siguiente';

  @override
  String get calendar_limit_reached => 'Límite alcanzado';

  @override
  String get calendar_drag_instruction => 'Deslizar para navegar';

  @override
  String get common_refresh => 'Actualizar';

  @override
  String get common_yes => 'Sí';

  @override
  String get common_no => 'No';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_undo => 'Deshacer';

  @override
  String common_error_prefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get common_retry => 'Reintentar';

  @override
  String get calendar_no_events => 'Sin eventos hoy';

  @override
  String calendar_events_of(String date) {
    return 'Eventos del $date';
  }

  @override
  String get calendar_section_plantings => 'Plantaciones';

  @override
  String get calendar_section_harvests => 'Cosechas esperadas';

  @override
  String get calendar_section_tasks => 'Tareas programadas';

  @override
  String get calendar_filter_tasks => 'Tareas';

  @override
  String get common_attention => 'Atención';

  @override
  String get limit_beds_reached_message =>
      'Para garantizar una fluidez perfecta, el límite se establece en 100 parcelas por jardín. Has alcanzado este umbral de confort.';

  @override
  String get limit_plantings_reached_message =>
      'Límite de 6 plantas alcanzado.\nPor favor, retire una planta de esta parcela para añadir una nueva.';

  @override
  String get limit_gardens_reached_message =>
      'Limite de 5 jardins actifs atteinte.\nVeuillez archiver ou supprimer un jardin pour en créer un nouveau.';

  @override
  String get calendar_filter_maintenance => 'Mantenimiento';

  @override
  String get calendar_filter_harvests => 'Cosechas';

  @override
  String get calendar_filter_urgent => 'Urgente';

  @override
  String get common_general_error => 'Ocurrió un error';

  @override
  String get common_error => 'Error';

  @override
  String get settings_backup_restore_section =>
      'Copia de seguridad y Restauración';

  @override
  String get settings_backup_restore_subtitle => 'Copia de seguridad completa';

  @override
  String get settings_backup_action => 'Crear copia de seguridad';

  @override
  String get settings_restore_action => 'Restaurar copia de seguridad';

  @override
  String get settings_backup_creating => 'Creando copia de seguridad...';

  @override
  String get settings_backup_success => '¡Copia de seguridad creada con éxito!';

  @override
  String get settings_restore_warning_title => 'Atención';

  @override
  String get settings_restore_warning_content =>
      'Restaurar una copia sobrescribirá TODOS los datos actuales. Esta acción es irreversible. La aplicación deberá reiniciarse.\n\n¿Seguro que desea continuar?';

  @override
  String get settings_restore_success =>
      '¡Restauración exitosa! Reinicie la aplicación.';

  @override
  String settings_backup_error(Object error) {
    return 'Fallo de copia: $error';
  }

  @override
  String settings_restore_error(Object error) {
    return 'Fallo de restauración: $error';
  }

  @override
  String get settings_backup_compatible_zip => 'Compatible con ZIP';

  @override
  String get backup_share_subject => 'Copia de seguridad PermaCalendar';

  @override
  String get task_editor_title_new => 'Nueva tarea';

  @override
  String get task_editor_title_edit => 'Editar tarea';

  @override
  String get task_editor_title_field => 'Título *';

  @override
  String get activity_screen_title => 'Actividades e Historial';

  @override
  String activity_tab_recent_garden(String gardenName) {
    return 'Reciente ($gardenName)';
  }

  @override
  String get activity_tab_recent_global => 'Reciente (Global)';

  @override
  String get activity_tab_history => 'Historial';

  @override
  String get activity_history_section_title => 'Historial — ';

  @override
  String get activity_history_empty =>
      'Ningún jardín seleccionado.\nPara ver el historial de un jardín, manténgalo presionado desde el tablero.';

  @override
  String get activity_empty_title => 'No se encontraron actividades';

  @override
  String get activity_empty_subtitle =>
      'Las actividades de jardinería aparecerán aquí';

  @override
  String get activity_error_loading => 'Error al cargar actividades';

  @override
  String get activity_priority_important => 'Importante';

  @override
  String get activity_priority_normal => 'Normal';

  @override
  String get activity_time_just_now => 'Ahora mismo';

  @override
  String activity_time_minutes_ago(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String activity_time_hours_ago(int hours) {
    return 'hace $hours h';
  }

  @override
  String activity_time_days_ago(int count) {
    return 'hace $count días';
  }

  @override
  String activity_metadata_garden(String name) {
    return 'Jardín: $name';
  }

  @override
  String activity_metadata_bed(String name) {
    return 'Parcela: $name';
  }

  @override
  String activity_metadata_plant(String name) {
    return 'Planta: $name';
  }

  @override
  String activity_metadata_quantity(String quantity) {
    return 'Cantidad: $quantity';
  }

  @override
  String activity_metadata_date(String date) {
    return 'Fecha: $date';
  }

  @override
  String activity_metadata_maintenance(String type) {
    return 'Mantenimiento: $type';
  }

  @override
  String activity_metadata_weather(String weather) {
    return 'Clima: $weather';
  }

  @override
  String get task_editor_error_title_required => 'Requerido';

  @override
  String get history_hint_title => 'Para ver el historial de un jardín';

  @override
  String get history_hint_body =>
      'Selecciónelo manteniendo presionado desde el tablero.';

  @override
  String get history_hint_action => 'Ir al tablero';

  @override
  String activity_desc_garden_created(String name) {
    return 'Jardín \"$name\" creado';
  }

  @override
  String activity_desc_bed_created(String name) {
    return 'Parcela \"$name\" creada';
  }

  @override
  String activity_desc_planting_created(String name) {
    return 'Plantación de \"$name\" añadida';
  }

  @override
  String activity_desc_germination(String name) {
    return 'Germinación de \"$name\" confirmada';
  }

  @override
  String activity_desc_harvest(String name) {
    return 'Cosecha de \"$name\" registrada';
  }

  @override
  String activity_desc_maintenance(String type) {
    return 'Mantenimiento: $type';
  }

  @override
  String activity_desc_garden_deleted(String name) {
    return 'Jardín \"$name\" eliminado';
  }

  @override
  String activity_desc_bed_deleted(String name) {
    return 'Parcela \"$name\" eliminada';
  }

  @override
  String activity_desc_planting_deleted(String name) {
    return 'Plantación de \"$name\" eliminada';
  }

  @override
  String activity_desc_garden_updated(String name) {
    return 'Jardín \"$name\" actualizado';
  }

  @override
  String activity_desc_bed_updated(String name) {
    return 'Parcela \"$name\" actualizada';
  }

  @override
  String activity_desc_planting_updated(String name) {
    return 'Plantación de \"$name\" actualizada';
  }

  @override
  String get planting_steps_title => 'Paso a paso';

  @override
  String get planting_steps_add_button => 'Añadir';

  @override
  String get planting_steps_see_less => 'Ver menos';

  @override
  String get planting_steps_see_all => 'Ver todo';

  @override
  String get planting_steps_empty => 'No hay pasos recomendados';

  @override
  String planting_steps_more(int count) {
    return '+ $count pasos más';
  }

  @override
  String get planting_steps_prediction_badge => 'Predicción';

  @override
  String planting_steps_date_prefix(String date) {
    return 'El $date';
  }

  @override
  String get planting_steps_done => 'Hecho';

  @override
  String get planting_steps_mark_done => 'Marcar como hecho';

  @override
  String get planting_steps_dialog_title => 'Añadir paso';

  @override
  String get planting_steps_dialog_hint => 'Ej: Acolchado ligero';

  @override
  String get planting_steps_dialog_add => 'Añadir';

  @override
  String get planting_status_sown => 'Sembrado';

  @override
  String get planting_status_planted => 'Plantado';

  @override
  String get planting_status_growing => 'En crecimiento';

  @override
  String get planting_status_ready => 'Listo para cosechar';

  @override
  String get planting_status_harvested => 'Cosechado';

  @override
  String get planting_status_failed => 'Fallido';

  @override
  String planting_card_sown_date(String date) {
    return 'Sembrado el $date';
  }

  @override
  String planting_card_planted_date(String date) {
    return 'Plantado el $date';
  }

  @override
  String planting_card_harvest_estimate(String date) {
    return 'Est. cosecha: $date';
  }

  @override
  String get planting_info_title => 'Info botánica';

  @override
  String get planting_info_tips_title => 'Consejos de cultivo';

  @override
  String get planting_info_maturity => 'Madurez';

  @override
  String planting_info_days(Object days) {
    return '$days días';
  }

  @override
  String get planting_info_spacing => 'Espaciamiento';

  @override
  String planting_info_cm(Object cm) {
    return '$cm cm';
  }

  @override
  String get planting_info_depth => 'Profundidad';

  @override
  String get planting_info_exposure => 'Exposición';

  @override
  String get planting_info_water => 'Agua';

  @override
  String get planting_info_season => 'Temporada de siembra';

  @override
  String get planting_info_scientific_name_none =>
      'Nombre científico no disponible';

  @override
  String get planting_info_culture_title => 'Información de cultivo';

  @override
  String get planting_info_germination => 'Tiempo de germinación';

  @override
  String get planting_info_harvest_time => 'Tiempo de cosecha';

  @override
  String get planting_info_none => 'No especificado';

  @override
  String get planting_tips_none => 'No hay consejos disponibles';

  @override
  String get planting_history_title => 'Historial de acciones';

  @override
  String get planting_history_action_planting => 'Plantación';

  @override
  String get planting_history_todo => 'Historial detallado próximamente';

  @override
  String get task_editor_garden_all => 'Todos los jardines';

  @override
  String get task_editor_zone_label => 'Zona (Parcela)';

  @override
  String get task_editor_zone_none => 'Sin zona específica';

  @override
  String get task_editor_zone_empty => 'No hay parcelas para este jardín';

  @override
  String get task_editor_description_label => 'Descripción';

  @override
  String get task_editor_date_label => 'Fecha de inicio';

  @override
  String get task_editor_time_label => 'Hora';

  @override
  String get task_editor_duration_label => 'Duración estimada';

  @override
  String get task_editor_duration_other => 'Otro';

  @override
  String get task_editor_type_label => 'Tipo de tarea';

  @override
  String get task_editor_priority_label => 'Prioridad';

  @override
  String get task_editor_urgent_label => 'Urgente';

  @override
  String get task_editor_option_none => 'Ninguno (Solo guardar)';

  @override
  String get task_editor_option_share => 'Compartir (Texto)';

  @override
  String get task_editor_option_pdf => 'Exportar — PDF';

  @override
  String get task_editor_option_docx => 'Exportar — Word (.docx)';

  @override
  String get task_editor_export_label => 'Salida / Compartir';

  @override
  String get task_editor_photo_placeholder => 'Añadir foto (Próximamente)';

  @override
  String get task_editor_action_create => 'Crear';

  @override
  String get task_editor_action_save => 'Guardar';

  @override
  String get task_editor_action_cancel => 'Cancelar';

  @override
  String get task_editor_assignee_label => 'Asignado a';

  @override
  String task_editor_assignee_add(String name) {
    return 'Añadir \"$name\" a favoritos';
  }

  @override
  String get task_editor_assignee_none => 'Sin resultados.';

  @override
  String get task_editor_recurrence_label => 'Recurrencia';

  @override
  String get task_editor_recurrence_none => 'Ninguna';

  @override
  String get task_editor_recurrence_interval => 'Cada X días';

  @override
  String get task_editor_recurrence_weekly => 'Semanalmente (Días)';

  @override
  String get task_editor_recurrence_monthly => 'Mensualmente (mismo día)';

  @override
  String get task_editor_recurrence_repeat_label => 'Repetir cada ';

  @override
  String get task_editor_recurrence_days_suffix => ' d';

  @override
  String get task_kind_generic => 'Genérico';

  @override
  String get task_kind_repair => 'Reparación 🛠️';

  @override
  String get soil_temp_title => 'Temperatura del suelo';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Error de gráfico: $error';
  }

  @override
  String get soil_temp_about_title => 'Acerca de la temp. del suelo';

  @override
  String get soil_temp_about_content =>
      'La temperatura del suelo mostrada aquí es estimada por la aplicación a partir de datos climáticos y estacionales, según la siguiente fórmula:\n\nEsta estimación permite dar una tendencia realista de la temperatura del suelo cuando no hay medición directa disponible.';

  @override
  String get soil_temp_formula_label => 'Fórmula de cálculo utilizada:';

  @override
  String get soil_temp_formula_content =>
      'T_suelo(n+1) = T_suelo(n) + α × (T_aire(n) − T_suelo(n))\n\nCon:\n• α : coeficiente de difusión térmica (valor por defecto 0.15 — rango recomendado 0.10–0.20).\n• T_suelo(n) : temperatura actual del suelo (°C).\n• T_aire(n) : temperatura actual del aire (°C).\n\nLa fórmula está implementada en el código de la aplicación (ComputeSoilTempNextDayUsecase).';

  @override
  String get soil_temp_current_label => 'Temperatura actual';

  @override
  String get soil_temp_action_measure => 'Editar / Medir';

  @override
  String get soil_temp_measure_hint =>
      'Puede ingresar manualmente la temperatura del suelo en la pestaña \'Editar / Medir\'.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Error del catálogo: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Error de consejo: $error';
  }

  @override
  String get soil_temp_db_empty => 'La base de datos de plantas está vacía.';

  @override
  String get soil_temp_reload_plants => 'Recargar plantas';

  @override
  String get soil_temp_no_advice =>
      'No se encontraron plantas con datos de germinación.';

  @override
  String get soil_advice_status_ideal => 'Óptimo';

  @override
  String get soil_advice_status_sow_now => 'Sembrar ahora';

  @override
  String get soil_advice_status_sow_soon => 'Pronto';

  @override
  String get soil_advice_status_wait => 'Esperar';

  @override
  String get soil_sheet_title => 'Temperatura del suelo';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Última medida: $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'Nueva medida (Ancla)';

  @override
  String get soil_sheet_input_label => 'Temperatura (°C)';

  @override
  String get soil_sheet_input_error => 'Valor inválido (-10.0 a 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Cancelar';

  @override
  String get soil_sheet_action_save => 'Guardar';

  @override
  String get soil_sheet_snack_invalid =>
      'Valor inválido. Ingrese entre -10.0 y 45.0';

  @override
  String get soil_sheet_snack_success => 'Medida guardada como ancla';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get weather_screen_title => 'Clima';

  @override
  String get weather_provider_credit => 'Datos proporcionados por Open-Meteo';

  @override
  String get weather_error_loading => 'No se puede cargar el clima';

  @override
  String get weather_action_retry => 'Reintentar';

  @override
  String get weather_header_next_24h => 'PRÓXIMAS 24H';

  @override
  String get weather_header_daily_summary => 'RESUMEN DIARIO';

  @override
  String get weather_header_precipitations => 'PRECIPITACIÓN (24h)';

  @override
  String get weather_label_wind => 'VIENTO';

  @override
  String get weather_label_pressure => 'PRESIÓN';

  @override
  String get weather_label_sun => 'SOL';

  @override
  String get weather_label_astro => 'ASTRO';

  @override
  String get weather_data_speed => 'Velocidad';

  @override
  String get weather_data_gusts => 'Ráfagas';

  @override
  String get weather_data_sunrise => 'Amanecer';

  @override
  String get weather_data_sunset => 'Atardecer';

  @override
  String get weather_data_rain => 'Lluvia';

  @override
  String get weather_data_max => 'Máx';

  @override
  String get weather_data_min => 'Mín';

  @override
  String get weather_data_wind_max => 'Viento Máx';

  @override
  String get weather_pressure_high => 'Alta';

  @override
  String get weather_pressure_low => 'Baja';

  @override
  String get weather_today_label => 'Hoy';

  @override
  String get moon_phase_new => 'Luna Nueva';

  @override
  String get moon_phase_waxing_crescent => 'Luna Creciente';

  @override
  String get moon_phase_first_quarter => 'Cuarto Creciente';

  @override
  String get moon_phase_waxing_gibbous => 'Gibosa Creciente';

  @override
  String get moon_phase_full => 'Luna Llena';

  @override
  String get moon_phase_waning_gibbous => 'Gibosa Menguante';

  @override
  String get moon_phase_last_quarter => 'Cuarto Menguante';

  @override
  String get moon_phase_waning_crescent => 'Luna Menguante';

  @override
  String get wmo_code_0 => 'Despejado';

  @override
  String get wmo_code_1 => 'Mayormente despejado';

  @override
  String get wmo_code_2 => 'Parcialmente nublado';

  @override
  String get wmo_code_3 => 'Nublado';

  @override
  String get wmo_code_45 => 'Niebla';

  @override
  String get wmo_code_48 => 'Niebla con escarcha';

  @override
  String get wmo_code_51 => 'Llovizna ligera';

  @override
  String get wmo_code_53 => 'Llovizna moderada';

  @override
  String get wmo_code_55 => 'Llovizna densa';

  @override
  String get wmo_code_61 => 'Lluvia ligera';

  @override
  String get wmo_code_63 => 'Lluvia moderada';

  @override
  String get wmo_code_65 => 'Lluvia fuerte';

  @override
  String get wmo_code_66 => 'Lluvia helada ligera';

  @override
  String get wmo_code_67 => 'Lluvia helada fuerte';

  @override
  String get wmo_code_71 => 'Nevada ligera';

  @override
  String get wmo_code_73 => 'Nevada moderada';

  @override
  String get wmo_code_75 => 'Nevada fuerte';

  @override
  String get wmo_code_77 => 'Granos de nieve';

  @override
  String get wmo_code_80 => 'Chubascos de lluvia ligeros';

  @override
  String get wmo_code_81 => 'Chubascos de lluvia moderados';

  @override
  String get wmo_code_82 => 'Chubascos de lluvia violentos';

  @override
  String get wmo_code_85 => 'Chubascos de nieve ligeros';

  @override
  String get wmo_code_86 => 'Chubascos de nieve fuertes';

  @override
  String get wmo_code_95 => 'Tormenta';

  @override
  String get wmo_code_96 => 'Tormenta con granizo ligero';

  @override
  String get wmo_code_99 => 'Tormenta con granizo fuerte';

  @override
  String get wmo_code_unknown => 'Condiciones desconocidas';

  @override
  String get task_kind_buy => 'Comprar 🛒';

  @override
  String get task_kind_clean => 'Limpiar 🧹';

  @override
  String get task_kind_watering => 'Regar 💧';

  @override
  String get task_kind_seeding => 'Sembrar 🌱';

  @override
  String get task_kind_pruning => 'Podar ✂️';

  @override
  String get task_kind_weeding => 'Deshierbar 🌿';

  @override
  String get task_kind_amendment => 'Enmienda 🪵';

  @override
  String get task_kind_treatment => 'Tratamiento 🧪';

  @override
  String get task_kind_harvest => 'Cosechar 🧺';

  @override
  String get task_kind_winter_protection => 'Protección invernal ❄️';

  @override
  String get garden_detail_title_error => 'Error';

  @override
  String get garden_detail_subtitle_not_found =>
      'El jardín solicitado no existe o ha sido eliminado.';

  @override
  String garden_detail_subtitle_error_beds(Object error) {
    return 'No se pueden cargar las parcelas: $error';
  }

  @override
  String get garden_action_edit => 'Editar';

  @override
  String get garden_action_archive => 'Archivar';

  @override
  String get garden_action_unarchive => 'Desarchivar';

  @override
  String get garden_action_delete => 'Eliminar';

  @override
  String garden_created_at(Object date) {
    return 'Creado el $date';
  }

  @override
  String get garden_bed_delete_confirm_title => 'Eliminar parcela';

  @override
  String garden_bed_delete_confirm_body(Object bedName) {
    return '¿Está seguro de que desea eliminar \"$bedName\"? Esta acción es irreversible.';
  }

  @override
  String get garden_bed_deleted_snack => 'Parcela eliminada';

  @override
  String garden_bed_delete_error(Object error) {
    return 'Error al eliminar la parcela: $error';
  }

  @override
  String get common_back => 'Atrás';

  @override
  String get garden_action_disable => 'Deshabilitar';

  @override
  String get garden_action_enable => 'Habilitar';

  @override
  String get garden_action_modify => 'Modificar';

  @override
  String get bed_create_title_new => 'Nueva parcela';

  @override
  String get bed_create_title_edit => 'Editar parcela';

  @override
  String get bed_form_name_label => 'Nombre de la parcela *';

  @override
  String get bed_form_name_hint => 'Ej: Parcela Norte, Zona 1';

  @override
  String get bed_form_size_label => 'Área (m²) *';

  @override
  String get bed_form_size_hint => 'Ej: 10.5';

  @override
  String get bed_form_desc_label => 'Descripción';

  @override
  String get bed_form_desc_hint => 'Descripción...';

  @override
  String get bed_form_submit_create => 'Crear';

  @override
  String get bed_form_submit_edit => 'Guardar';

  @override
  String get bed_snack_created => 'Parcela creada con éxito';

  @override
  String get bed_snack_updated => 'Parcela actualizada con éxito';

  @override
  String get bed_form_error_name_required => 'Se requiere el nombre';

  @override
  String get bed_form_error_name_length =>
      'El nombre debe tener al menos 2 caracteres';

  @override
  String get bed_form_error_size_required => 'Se requiere el área';

  @override
  String get bed_form_error_size_invalid => 'Por favor ingrese un área válida';

  @override
  String get bed_form_error_size_max => 'El área no puede exceder los 1000 m²';

  @override
  String get status_sown => 'Sembrado';

  @override
  String get status_planted => 'Plantado';

  @override
  String get status_growing => 'En crecimiento';

  @override
  String get status_ready_to_harvest => 'Listo para cosechar';

  @override
  String get status_harvested => 'Cosechado';

  @override
  String get status_failed => 'Fallido';

  @override
  String bed_card_sown_on(Object date) {
    return 'Sembrado el $date';
  }

  @override
  String get bed_card_harvest_start => 'inicio cosecha aprox.';

  @override
  String get bed_action_harvest => 'Cosechar';

  @override
  String get lifecycle_error_title => 'Error al calcular ciclo';

  @override
  String get lifecycle_error_prefix => 'Error: ';

  @override
  String get lifecycle_cycle_completed => 'ciclo completado';

  @override
  String get lifecycle_stage_germination => 'Germinación';

  @override
  String get lifecycle_stage_growth => 'Crecimiento';

  @override
  String get lifecycle_stage_fruiting => 'Fructificación';

  @override
  String get lifecycle_stage_harvest => 'Cosecha';

  @override
  String get lifecycle_stage_unknown => 'Desconocido';

  @override
  String get lifecycle_harvest_expected => 'Cosecha esperada';

  @override
  String lifecycle_in_days(Object days) {
    return 'En $days días';
  }

  @override
  String get lifecycle_passed => 'Pasado';

  @override
  String get lifecycle_now => '¡Ahora!';

  @override
  String get lifecycle_next_action => 'Siguiente acción';

  @override
  String get lifecycle_update => 'Actualizar ciclo';

  @override
  String lifecycle_days_ago(Object days) {
    return 'hace $days días';
  }

  @override
  String get planting_detail_title => 'Detalles de la siembra';

  @override
  String get companion_beneficial => 'Plantas beneficiosas';

  @override
  String get companion_avoid => 'Plantas a evitar';

  @override
  String get common_close => 'Cerrar';

  @override
  String get bed_detail_surface => 'Área';

  @override
  String get bed_detail_details => 'Detalles';

  @override
  String get bed_detail_notes => 'Notas';

  @override
  String get bed_detail_current_plantings => 'Plantaciones actuales';

  @override
  String get bed_detail_no_plantings_title => 'Sin plantaciones';

  @override
  String get bed_detail_no_plantings_desc =>
      'Esta parcela aún no tiene plantaciones.';

  @override
  String get bed_detail_add_planting => 'Añadir plantación';

  @override
  String get bed_delete_planting_confirm_title => '¿Eliminar plantación?';

  @override
  String get bed_delete_planting_confirm_body =>
      'Esta acción es irreversible. ¿Realmente desea eliminar esta plantación?';

  @override
  String harvest_title(Object plantName) {
    return 'Cosecha: $plantName';
  }

  @override
  String get harvest_weight_label => 'Peso cosechado (kg) *';

  @override
  String harvest_price_label(String currencyUnit) {
    return 'Precio estimado ($currencyUnit)';
  }

  @override
  String get harvest_price_helper =>
      'Se recordará para futuras cosechas de esta planta';

  @override
  String get harvest_notes_label => 'Notas / Calidad';

  @override
  String get harvest_action_save => 'Guardar';

  @override
  String get harvest_snack_saved => 'Cosecha registrada';

  @override
  String get harvest_snack_error => 'Error al registrar cosecha';

  @override
  String get harvest_form_error_required => 'Requerido';

  @override
  String get harvest_form_error_positive => 'Inválido (> 0)';

  @override
  String get harvest_form_error_positive_or_zero => 'Inválido (>= 0)';

  @override
  String get info_exposure_full_sun => 'Pleno sol';

  @override
  String get info_exposure_partial_sun => 'Sol parcial';

  @override
  String get info_exposure_shade => 'Sombra';

  @override
  String get info_water_low => 'Bajo';

  @override
  String get info_water_medium => 'Medio';

  @override
  String get info_water_high => 'Alto';

  @override
  String get info_water_moderate => 'Moderado';

  @override
  String get info_season_spring => 'Primavera';

  @override
  String get info_season_summer => 'Verano';

  @override
  String get info_season_autumn => 'Otoño';

  @override
  String get info_season_winter => 'Invierno';

  @override
  String get info_season_all => 'Todas las estaciones';

  @override
  String get common_duplicate => 'Duplicar';

  @override
  String get planting_delete_title => 'Eliminar plantación';

  @override
  String get planting_delete_confirm_body =>
      '¿Está seguro de que desea eliminar esta plantación? Esta acción es irreversible.';

  @override
  String get planting_creation_title => 'Nueva plantación';

  @override
  String get planting_creation_title_edit => 'Editar plantación';

  @override
  String get planting_quantity_seeds => 'Número de semillas';

  @override
  String get planting_quantity_plants => 'Número de plantas';

  @override
  String get planting_quantity_required => 'Se requiere la cantidad';

  @override
  String get planting_quantity_positive =>
      'La cantidad debe ser un número positivo';

  @override
  String planting_plant_selection_label(Object plantName) {
    return 'Planta: $plantName';
  }

  @override
  String get planting_no_plant_selected => 'Ninguna planta seleccionada';

  @override
  String get planting_custom_plant_title => 'Planta personalizada';

  @override
  String get planting_plant_name_label => 'Nombre de la planta';

  @override
  String get planting_plant_name_hint => 'Ej: Tomate Cherry';

  @override
  String get planting_plant_name_required =>
      'Se requiere el nombre de la planta';

  @override
  String get planting_notes_label => 'Notas (opcional)';

  @override
  String get planting_notes_hint => 'Información adicional...';

  @override
  String get planting_tips_title => 'Consejos';

  @override
  String get planting_tips_catalog =>
      '• Utilice el catálogo para seleccionar una planta.';

  @override
  String get planting_tips_type =>
      '• Elija \"Sembrado\" para semillas, \"Plantado\" para plántulas.';

  @override
  String get planting_tips_notes =>
      '• Añada notas para rastrear condiciones especiales.';

  @override
  String get planting_date_future_error =>
      'La fecha de plantación no puede estar en el futuro';

  @override
  String get planting_success_create => 'Plantación creada con éxito';

  @override
  String get planting_success_update => 'Plantación actualizada con éxito';

  @override
  String get stats_screen_title => 'Estadísticas';

  @override
  String get stats_screen_subtitle =>
      'Analiza en tiempo real y exporta tus datos.';

  @override
  String get kpi_alignment_title => 'Alineación Viva';

  @override
  String get kpi_alignment_description =>
      'Esta herramienta evalúa cuán cerca están tus siembras, plantaciones y cosechas de las ventanas ideales recomendadas por la Agenda Inteligente.';

  @override
  String get kpi_alignment_cta =>
      '¡Comienza a plantar y cosechar para ver tu alineación!';

  @override
  String get kpi_alignment_aligned => 'alineado';

  @override
  String get kpi_alignment_total => 'Total';

  @override
  String get kpi_alignment_aligned_actions => 'Alineado';

  @override
  String get kpi_alignment_misaligned_actions => 'Desalineado';

  @override
  String get kpi_alignment_calculating => 'Calculando alineación...';

  @override
  String get kpi_alignment_error => 'Error durante el cálculo';

  @override
  String get pillar_economy_title => 'Economía del Jardín';

  @override
  String get pillar_nutrition_title => 'Equilibrio Nutricional';

  @override
  String get pillar_export_title => 'Exportar';

  @override
  String get pillar_economy_label => 'Valor total de cosecha';

  @override
  String get pillar_nutrition_label => 'Firma Nutricional';

  @override
  String get pillar_export_label => 'Recuperar sus datos';

  @override
  String get pillar_export_button => 'Exportar';

  @override
  String get stats_economy_title => 'Economía del Jardín';

  @override
  String get stats_economy_no_harvest =>
      'Sin cosecha en el período seleccionado.';

  @override
  String get stats_economy_no_harvest_desc =>
      'Sin datos para el período seleccionado.';

  @override
  String get stats_kpi_total_revenue => 'Ingresos Totales';

  @override
  String get stats_kpi_total_volume => 'Volumen Total';

  @override
  String get stats_kpi_avg_price => 'Precio Promedio';

  @override
  String get stats_top_cultures_title => 'Mejores Cultivos (Valor)';

  @override
  String get stats_top_cultures_no_data => 'Sin datos';

  @override
  String get stats_top_cultures_percent_revenue => 'de ingresos';

  @override
  String get stats_monthly_revenue_title => 'Ingresos Mensuales';

  @override
  String get stats_monthly_revenue_no_data => 'Sin datos mensuales';

  @override
  String get stats_dominant_culture_title => 'Cultivo Dominante por Mes';

  @override
  String get stats_annual_evolution_title => 'Tendencia Anual';

  @override
  String get stats_crop_distribution_title => 'Distribución de Cultivos';

  @override
  String get stats_crop_distribution_others => 'Otros';

  @override
  String get stats_key_months_title => 'Meses Clave del Jardín';

  @override
  String get stats_most_profitable => 'Más Rentable';

  @override
  String get stats_least_profitable => 'Menos Rentable';

  @override
  String get stats_auto_summary_title => 'Resumen Automático';

  @override
  String get stats_revenue_history_title => 'Historial de Ingresos';

  @override
  String get stats_profitability_cycle_title => 'Ciclo de Rentabilidad';

  @override
  String get stats_table_crop => 'Cultivo';

  @override
  String get stats_table_days => 'Días (Prom)';

  @override
  String get stats_table_revenue => 'Ing/Cosecha';

  @override
  String get stats_table_type => 'Tipo';

  @override
  String get stats_type_fast => 'Rápido';

  @override
  String get stats_type_long_term => 'Largo Plazo';

  @override
  String get nutrition_page_title => 'Firma Nutricional';

  @override
  String get nutrition_seasonal_dynamics_title => 'Dinámicas Estacionales';

  @override
  String get nutrition_seasonal_dynamics_desc =>
      'Explore la producción de minerales y vitaminas de su jardín, mes a mes.';

  @override
  String get nutrition_no_harvest_month => 'Sin cosecha este mes';

  @override
  String get nutrition_major_minerals_title => 'Estructura y Minerales Mayores';

  @override
  String get nutrition_trace_elements_title => 'Vitalidad y Oligoelementos';

  @override
  String get nutrition_no_data_period => 'Sin datos para este período';

  @override
  String get nutrition_no_major_minerals => 'Sin minerales mayores';

  @override
  String get nutrition_no_trace_elements => 'Sin oligoelementos';

  @override
  String nutrition_month_dynamics_title(String month) {
    return 'Dinámicas de $month';
  }

  @override
  String get nutrition_dominant_production => 'Producción dominante:';

  @override
  String get nutrition_nutrients_origin =>
      'Estos nutrientes provienen de sus cosechas del mes.';

  @override
  String get nut_calcium => 'Calcio';

  @override
  String get nut_potassium => 'Potasio';

  @override
  String get nut_magnesium => 'Magnesio';

  @override
  String get nut_iron => 'Hierro';

  @override
  String get nut_zinc => 'Zinc';

  @override
  String get nut_manganese => 'Manganeso';

  @override
  String get nut_vitamin_c => 'Vitamina C';

  @override
  String get nut_fiber => 'Fibra';

  @override
  String get nut_protein => 'Proteína';

  @override
  String get export_builder_title => 'Constructor de Exportación';

  @override
  String get export_scope_section => '1. Alcance';

  @override
  String get export_scope_period => 'Período';

  @override
  String get export_scope_period_all => 'Todo el Historial';

  @override
  String get export_filter_garden_title => 'Filtrar por Jardín';

  @override
  String get export_filter_garden_all => 'Todos los jardines';

  @override
  String export_filter_garden_count(Object count) {
    return '$count jardín(es) seleccionado(s)';
  }

  @override
  String get export_filter_garden_edit => 'Editar selección';

  @override
  String get export_filter_garden_select_dialog_title => 'Seleccionar Jardines';

  @override
  String get export_blocks_section => '2. Bloques de Datos';

  @override
  String get export_block_activity => 'Actividades (Diario)';

  @override
  String get export_block_harvest => 'Cosechas (Producción)';

  @override
  String get export_block_garden => 'Jardines (Estructura)';

  @override
  String get export_block_garden_bed => 'Parcelas (Estructura)';

  @override
  String get export_block_plant => 'Plantas (Catálogo)';

  @override
  String get export_block_desc_activity =>
      'Historial completo de intervenciones y eventos';

  @override
  String get export_block_desc_harvest => 'Datos de producción y rendimientos';

  @override
  String get export_block_desc_garden => 'Metadatos de jardines seleccionados';

  @override
  String get export_block_desc_garden_bed =>
      'Detalles de parcelas (área, orientación...)';

  @override
  String get export_block_desc_plant => 'Lista de plantas utilizadas';

  @override
  String get export_columns_section => '3. Detalles y Columnas';

  @override
  String export_columns_count(Object count) {
    return '$count columnas seleccionadas';
  }

  @override
  String get export_format_section => '4. Formato de Archivo';

  @override
  String get export_format_separate => 'Hojas Separadas (Estándar)';

  @override
  String get export_format_separate_subtitle =>
      'Una hoja por tipo de dato (Recomendado)';

  @override
  String get export_format_flat => 'Tabla Única (Plana / BI)';

  @override
  String get export_format_flat_subtitle =>
      'Una tabla grande para Tablas Dinámicas';

  @override
  String get export_action_generate => 'Generar Exportación Excel';

  @override
  String get export_generating => 'Generando...';

  @override
  String get export_success_title => 'Exportación Completa';

  @override
  String get export_success_share_text =>
      'Aquí está su exportación de PermaCalendar';

  @override
  String export_error_snack(Object error) {
    return 'Error: $error';
  }

  @override
  String get export_field_garden_name => 'Nombre del Jardín';

  @override
  String get export_field_garden_id => 'ID del Jardín';

  @override
  String get export_field_garden_surface => 'Área (m²)';

  @override
  String get export_field_garden_creation => 'Fecha de Creación';

  @override
  String get export_field_bed_name => 'Nombre de la Parcela';

  @override
  String get export_field_bed_id => 'ID de Parcela';

  @override
  String get export_field_bed_surface => 'Área (m²)';

  @override
  String get export_field_bed_plant_count => 'Nº Plantas';

  @override
  String get export_field_plant_name => 'Nombre común';

  @override
  String get export_field_plant_id => 'ID Planta';

  @override
  String get export_field_plant_scientific => 'Nombre científico';

  @override
  String get export_field_plant_family => 'Familia';

  @override
  String get export_field_plant_variety => 'Variedad';

  @override
  String get export_field_harvest_date => 'Fecha Cosecha';

  @override
  String get export_field_harvest_qty => 'Cantidad (kg)';

  @override
  String get export_field_harvest_plant_name => 'Planta';

  @override
  String get export_field_harvest_price => 'Precio/kg';

  @override
  String get export_field_harvest_value => 'Valor Total';

  @override
  String get export_field_harvest_notes => 'Notas';

  @override
  String get export_field_harvest_garden_name => 'Jardín';

  @override
  String get export_field_harvest_garden_id => 'ID Jardín';

  @override
  String get export_field_harvest_bed_name => 'Parcela';

  @override
  String get export_field_harvest_bed_id => 'ID Parcela';

  @override
  String get export_field_activity_date => 'Fecha';

  @override
  String get export_field_activity_type => 'Tipo';

  @override
  String get export_field_activity_title => 'Título';

  @override
  String get export_field_activity_desc => 'Descripción';

  @override
  String get export_field_activity_entity => 'Entidad Objetivo';

  @override
  String get export_field_activity_entity_id => 'ID Objetivo';

  @override
  String get export_activity_type_garden_created => 'Jardín creado';

  @override
  String get export_activity_type_garden_updated => 'Jardín actualizado';

  @override
  String get export_activity_type_garden_deleted => 'Jardín eliminado';

  @override
  String get export_activity_type_bed_created => 'Parcela creada';

  @override
  String get export_activity_type_bed_updated => 'Parcela actualizada';

  @override
  String get export_activity_type_bed_deleted => 'Parcela eliminada';

  @override
  String get export_activity_type_planting_created => 'Nueva plantación';

  @override
  String get export_activity_type_planting_updated => 'Plantación actualizada';

  @override
  String get export_activity_type_planting_deleted => 'Plantación eliminada';

  @override
  String get export_activity_type_harvest => 'Cosecha';

  @override
  String get export_activity_type_maintenance => 'Mantenimiento';

  @override
  String get export_activity_type_weather => 'Clima';

  @override
  String get export_activity_type_error => 'Error';

  @override
  String get export_excel_total => 'TOTAL';

  @override
  String get export_excel_unknown => 'Desconocido';

  @override
  String get export_field_advanced_suffix => ' (Avanzado)';

  @override
  String get export_field_desc_garden_name => 'Nombre del jardín';

  @override
  String get export_field_desc_garden_id => 'ID técnico único';

  @override
  String get export_field_desc_garden_surface => 'Superficie total del jardín';

  @override
  String get export_field_desc_garden_creation =>
      'Fecha de creación en la aplicación';

  @override
  String get export_field_desc_bed_name => 'Nombre de la parcela';

  @override
  String get export_field_desc_bed_id => 'ID técnico único';

  @override
  String get export_field_desc_bed_surface => 'Superficie de la parcela';

  @override
  String get export_field_desc_bed_plant_count => 'Número de cultivos actuales';

  @override
  String get export_field_desc_plant_name => 'Nombre común de la planta';

  @override
  String get export_field_desc_plant_id => 'ID técnico único';

  @override
  String get export_field_desc_plant_scientific => 'Denominación botánica';

  @override
  String get export_field_desc_plant_family => 'Familia botánica';

  @override
  String get export_field_desc_plant_variety => 'Variedad específica';

  @override
  String get export_field_desc_harvest_date => 'Fecha del evento de cosecha';

  @override
  String get export_field_desc_harvest_qty => 'Peso cosechado en kg';

  @override
  String get export_field_desc_harvest_plant_name =>
      'Nombre de la planta cosechada';

  @override
  String get export_field_desc_harvest_price => 'Precio por kg configurado';

  @override
  String get export_field_desc_harvest_value => 'Cantidad * Precio/kg';

  @override
  String get export_field_desc_harvest_notes => 'Observaciones de la cosecha';

  @override
  String get export_field_desc_harvest_garden_name =>
      'Nombre del jardín de origen';

  @override
  String get export_field_desc_harvest_garden_id => 'ID único del jardín';

  @override
  String get export_field_desc_harvest_bed_name => 'Parcela de origen';

  @override
  String get export_field_desc_harvest_bed_id => 'ID de la parcela';

  @override
  String get export_field_desc_activity_date => 'Fecha de la actividad';

  @override
  String get export_field_desc_activity_type =>
      'Categoría de acción (Siembra, Cosecha, Cuidado...)';

  @override
  String get export_field_desc_activity_title => 'Resumen de la acción';

  @override
  String get export_field_desc_activity_desc => 'Detalles completos';

  @override
  String get export_field_desc_activity_entity =>
      'Nombre del objeto afectado (Planta, Parcela...)';

  @override
  String get export_field_desc_activity_entity_id => 'ID del objeto afectado';

  @override
  String get plant_catalog_sow => 'Sembrar';

  @override
  String get plant_catalog_plant => 'Plantar';

  @override
  String get plant_catalog_show_selection => 'Mostrar selección';

  @override
  String get plant_catalog_filter_green_only => 'Verdes solo';

  @override
  String get plant_catalog_filter_green_orange => 'Verdes + Naranjas';

  @override
  String get plant_catalog_filter_all => 'Todos';

  @override
  String get plant_catalog_no_recommended =>
      'No hay plantas recomendadas para este período.';

  @override
  String get plant_catalog_expand_window => 'Ampliar (±2 meses)';

  @override
  String get plant_catalog_missing_period_data => 'Datos de período faltantes';

  @override
  String plant_catalog_periods_prefix(String months) {
    return 'Períodos: $months';
  }

  @override
  String get plant_catalog_legend_green => 'Listo este mes';

  @override
  String get plant_catalog_legend_orange => 'Cerca / Pronto';

  @override
  String get plant_catalog_legend_red => 'Fuera de temporada';

  @override
  String get plant_catalog_data_unknown => 'Datos desconocidos';

  @override
  String get task_editor_photo_label => 'Foto de la tarea';

  @override
  String get task_editor_photo_add => 'Añadir una foto';

  @override
  String get task_editor_photo_change => 'Cambiar foto';

  @override
  String get task_editor_photo_remove => 'Quitar foto';

  @override
  String get task_editor_photo_help =>
      'La foto se adjuntará automáticamente al PDF al crear / enviar.';

  @override
  String get export_block_nutrition => 'Nutrition (Agrégation)';

  @override
  String get export_block_desc_nutrition =>
      'Indicateurs nutritionnels agrégés par nutriment';

  @override
  String get export_field_nutrient_key => 'Clave nutriente';

  @override
  String get export_field_nutrient_label => 'Nutriente';

  @override
  String get export_field_nutrient_unit => 'Unidad';

  @override
  String get export_field_nutrient_total => 'Total disponible';

  @override
  String get export_field_mass_with_data_kg => 'Masa con datos (kg)';

  @override
  String get export_field_contributing_records => 'Nº Cosechas';

  @override
  String get export_field_data_confidence => 'Confianza';

  @override
  String get export_field_coverage_percent => 'Prom. DRI (%)';

  @override
  String get export_field_lower_bound_coverage => 'Min DRI (%)';

  @override
  String get export_field_upper_bound_coverage => 'Max DRI (%)';

  @override
  String get settings_garden_config_title => 'Configuración del Jardín';

  @override
  String get settings_climatic_zone_label => 'Zona Climática';

  @override
  String settings_status_manual(String value) {
    return '$value (Manual)';
  }

  @override
  String settings_status_auto(String value) {
    return '$value (Auto)';
  }

  @override
  String get settings_status_detecting => 'Detectando...';

  @override
  String get settings_last_frost_date_label => 'Última Helada (Primavera)';

  @override
  String get settings_last_frost_date_title => 'Fecha de Última Helada';

  @override
  String settings_status_estimated(String value) {
    return '$value (Estimado)';
  }

  @override
  String get settings_status_unknown => 'Desconocido';

  @override
  String get settings_currency_label => 'Moneda';

  @override
  String get settings_currency_selector_title => 'Elegir moneda';

  @override
  String get settings_commune_search_placeholder_start =>
      'Ingrese el nombre de una ciudad para comenzar.';

  @override
  String settings_commune_search_no_results(String query) {
    return 'Sin resultados para \"$query\".';
  }

  @override
  String get settings_zone_auto_recommended => 'Automático (Recomendado)';

  @override
  String get settings_date_auto => 'Automático';

  @override
  String get settings_reset_date_button => 'Restablecer fecha';

  @override
  String get settings_terms_subtitle => 'Términos y condiciones';

  @override
  String get language_italian => 'Italiano';

  @override
  String get zone_nh_temperate_europe =>
      'Templado - Hemisferio Norte (Eurasia)';

  @override
  String get zone_nh_temperate_na => 'Templado - América del Norte';

  @override
  String get zone_sh_temperate => 'Templado - Hemisferio Sur';

  @override
  String get zone_mediterranean => 'Mediterráneo';

  @override
  String get zone_tropical => 'Tropical';

  @override
  String get zone_arid => 'Árido / Desierto';

  @override
  String get stats_pillar_economy => 'ECONOMÍA';

  @override
  String get stats_pillar_nutrition => 'NUTRICIÓN';

  @override
  String get stats_pillar_export => 'EXPORTACIÓN';

  @override
  String get stats_data_label => 'DATOS';

  @override
  String get stats_radar_vitamins => 'Vitaminas';

  @override
  String get stats_radar_minerals => 'Minerales';

  @override
  String get stats_radar_fibers => 'Fibras';

  @override
  String get stats_radar_proteins => 'Proteínas';

  @override
  String get stats_radar_energy => 'Energía';

  @override
  String get stats_radar_antiox => 'Antiox';

  @override
  String get custom_plant_new_title => 'Nueva planta';

  @override
  String get custom_plant_edit_title => 'Editar planta';

  @override
  String get custom_plant_action_save_creation => 'Crear planta';

  @override
  String get custom_plant_action_save_modification => 'Guardar cambios';

  @override
  String get custom_plant_delete_confirm_title => '¿Eliminar planta?';

  @override
  String get custom_plant_delete_confirm_body => 'Esta acción es irreversible.';

  @override
  String get custom_plant_saved_success => 'Planta guardada con éxito';

  @override
  String get custom_plant_common_name_label => 'Nombre común *';

  @override
  String get custom_plant_common_name_required => 'Requerido';

  @override
  String get custom_plant_scientific_name_label => 'Nombre científico';

  @override
  String get custom_plant_family_label => 'Familia';

  @override
  String get custom_plant_description_label => 'Descripción';

  @override
  String get custom_plant_price_title => 'Precio';

  @override
  String custom_plant_price_label(String currency) {
    return 'Precio medio por Kg ($currency)';
  }

  @override
  String get custom_plant_price_hint => 'ej: 4.50';

  @override
  String get custom_plant_nutrition_title => 'Nutrición (por 100g)';

  @override
  String get custom_plant_nutrition_cal => 'Calorías';

  @override
  String get custom_plant_nutrition_prot => 'Proteínas';

  @override
  String get custom_plant_nutrition_carb => 'Carbohidratos';

  @override
  String get custom_plant_nutrition_fat => 'Grasas';

  @override
  String get custom_plant_notes_title => 'Notas y Asociaciones';

  @override
  String get custom_plant_notes_label => 'Notas personales';

  @override
  String get custom_plant_notes_hint =>
      'Plantas compañeras, consejos de cultivo...';

  @override
  String get custom_plant_cycle_title => 'Ciclo de cultivo';

  @override
  String get custom_plant_sowing_period => 'Periodo de siembra';

  @override
  String get custom_plant_harvest_period => 'Periodo de cosecha';

  @override
  String get custom_plant_select_months => 'Seleccione los meses abajo';

  @override
  String get custom_plant_add_photo => 'Añadir foto';

  @override
  String get custom_plant_delete_photo => 'Eliminar foto';

  @override
  String get custom_plant_pick_camera => 'Tomar foto';

  @override
  String get custom_plant_pick_gallery => 'Elegir de la galería';

  @override
  String custom_plant_pick_error(Object error) {
    return 'Error al seleccionar imagen: $error';
  }

  @override
  String get garden_no_location => 'Sin ubicación';

  @override
  String get export_filename_prefix => 'Exportación';

  @override
  String get export_field_desc_nutrient_key => 'Identificador técnico';

  @override
  String get export_field_desc_nutrient_label => 'Nombre del nutriente';

  @override
  String get export_field_desc_nutrient_unit => 'Unidad de medida';

  @override
  String get export_field_desc_nutrient_total => 'Cantidad total calculada';

  @override
  String get export_field_desc_mass_with_data_kg =>
      'Masa total de cosechas con datos';

  @override
  String get export_field_desc_contributing_records =>
      'Número de cosechas con datos';

  @override
  String get export_field_desc_data_confidence =>
      'Confianza (Masa con datos / Masa total)';

  @override
  String get export_field_desc_coverage_percent =>
      'Porcentaje de cobertura DRI';

  @override
  String get export_field_desc_lower_bound_coverage =>
      'Estimación baja de cobertura';

  @override
  String get export_field_desc_upper_bound_coverage =>
      'Estimación alta de cobertura';

  @override
  String get nutrition_inventory_title => 'Inventario Nutricional';

  @override
  String get nutrition_mode_interpretation => 'Interpretación';

  @override
  String get nutrition_mode_measure => 'Medida';

  @override
  String get calendar_mark_as_done => 'Marcar como hecho';

  @override
  String get calendar_mark_as_todo => 'Marcar como pendiente';

  @override
  String get step_germination_title => 'Germinación esperada';

  @override
  String step_germination_desc(Object days) {
    return 'Aparición de brotes (est. ~$days días)';
  }

  @override
  String get step_watering_title => 'Riego recomendado';

  @override
  String get step_watering_desc_regular => 'Riego regular según necesidad';

  @override
  String step_watering_desc_amount(Object amount) {
    return 'Cantidad: $amount';
  }

  @override
  String get step_thinning_title => 'Aclareo recomendado';

  @override
  String get step_thinning_desc_default => 'Aclarar para espacio óptimo';

  @override
  String get step_weeding_title => 'Deshierbe recomendado';

  @override
  String get step_weeding_desc_regular => 'Deshierbar según necesidad';

  @override
  String step_weeding_desc_freq(Object freq) {
    return 'Frecuencia: $freq';
  }

  @override
  String get step_harvest_estimated_title => 'Cosecha estimada';

  @override
  String step_harvest_estimated_desc(Object days) {
    return 'Estimación basada en $days días';
  }

  @override
  String get step_harvest_start_title => 'Inicio de cosecha';

  @override
  String get step_harvest_start_desc => 'Inicio previsto de la cosecha';

  @override
  String get step_harvest_end_title => 'Fin de cosecha';

  @override
  String get step_harvest_end_desc => 'Fin previsto de la cosecha';

  @override
  String get step_bio_control_title => 'Control biológico';

  @override
  String step_bio_control_prep_title(Object number) {
    return 'Preparación $number control biológico';
  }

  @override
  String get step_add_step_title => 'Añadir paso';

  @override
  String get step_dialog_title_label => 'Título';

  @override
  String get step_dialog_desc_label => 'Descripción';

  @override
  String get step_dialog_no_date => 'Sin fecha';

  @override
  String get step_dialog_pick_date => 'Seleccionar fecha';

  @override
  String get common_add => 'Añadir';

  @override
  String get common_done => 'Hecho';

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
