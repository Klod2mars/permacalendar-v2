// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Sowing';

  @override
  String get settings_title => 'Configurações';

  @override
  String get home_settings_fallback_label => 'Configurações (fallback)';

  @override
  String get settings_application => 'Aplicação';

  @override
  String get settings_version => 'Versão';

  @override
  String get settings_display => 'Exibição';

  @override
  String get settings_weather_selector => 'Seletor de Clima';

  @override
  String get settings_commune_title => 'Localização para Clima';

  @override
  String get settings_choose_commune => 'Escolher Localização';

  @override
  String get settings_search_commune_hint => 'Pesquisar local...';

  @override
  String settings_commune_default(String label) {
    return 'Padrão: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Selecionado: $label';
  }

  @override
  String get settings_quick_access => 'Acesso Rápido';

  @override
  String get settings_plants_catalog => 'Catálogo de Plantas';

  @override
  String get settings_plants_catalog_subtitle => 'Pesquisar e ver plantas';

  @override
  String get settings_about => 'Sobre';

  @override
  String get settings_user_guide => 'Guia do Usuário';

  @override
  String get settings_user_guide_subtitle => 'Consulte o manual';

  @override
  String get settings_privacy => 'Privacidade';

  @override
  String get settings_privacy_policy => 'Política de Privacidade';

  @override
  String get settings_terms => 'Termos de Uso';

  @override
  String get settings_version_dialog_title => 'Versão do App';

  @override
  String settings_version_dialog_content(String version) {
    return 'Versão: $version – Gestão Dinâmica de Jardim\n\nSowing - Gestão de Jardins Vivos';
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
    return 'Idioma alterado: $label';
  }

  @override
  String get calibration_title => 'Calibração';

  @override
  String get calibration_subtitle => 'Personalize a exibição do seu painel';

  @override
  String get calibration_organic_title => 'Calibração Orgânica';

  @override
  String get calibration_organic_subtitle =>
      'Modo unificado: Imagem, Céu, Módulos';

  @override
  String get calibration_organic_disabled =>
      '🌿 Calibração orgânica desativada';

  @override
  String get calibration_organic_enabled =>
      '🌿 Modo de calibração orgânica ativado. Selecione uma das três abas.';

  @override
  String get garden_list_title => 'Meus Jardins';

  @override
  String get garden_error_title => 'Erro de carregamento';

  @override
  String garden_error_subtitle(String error) {
    return 'Não foi possível carregar a lista de jardins: $error';
  }

  @override
  String get garden_retry => 'Tentar novamente';

  @override
  String get garden_no_gardens => 'Nenhum jardim por enquanto.';

  @override
  String get garden_archived_info =>
      'Você tem jardins arquivados. Ative a exibição para vê-los.';

  @override
  String get garden_add_tooltip => 'Adicionar jardim';

  @override
  String get plant_catalog_title => 'Catálogo de Plantas';

  @override
  String get plant_custom_badge => 'Personalizado';

  @override
  String get plant_detail_not_found_title => 'Planta não encontrada';

  @override
  String get plant_detail_not_found_body =>
      'Esta planta não existe ou não pôde ser carregada.';

  @override
  String plant_added_favorites(String plant) {
    return '$plant adicionada aos favoritos';
  }

  @override
  String get plant_detail_popup_add_to_garden => 'Adicionar ao jardim';

  @override
  String get plant_detail_popup_share => 'Compartilhar';

  @override
  String get plant_detail_share_todo => 'Compartilhamento não implementado';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Adição ao jardim não implementada';

  @override
  String get plant_detail_section_culture => 'Detalhes de Cultivo';

  @override
  String get plant_detail_section_instructions => 'Instruções Gerais';

  @override
  String get plant_detail_detail_family => 'Família';

  @override
  String get plant_detail_detail_maturity => 'Maturação';

  @override
  String get plant_detail_detail_spacing => 'Espaçamento';

  @override
  String get plant_detail_detail_exposure => 'Exposição';

  @override
  String get plant_detail_detail_water => 'Necessidade de água';

  @override
  String planting_title_template(String gardenBedName) {
    return 'Plantios - $gardenBedName';
  }

  @override
  String get planting_menu_statistics => 'Estatísticas';

  @override
  String get planting_menu_ready_for_harvest => 'Pronto para colher';

  @override
  String get planting_menu_test_data => 'Dados de teste';

  @override
  String get planting_search_hint => 'Pesquisar plantio...';

  @override
  String get planting_filter_all_statuses => 'Todos os status';

  @override
  String get planting_filter_all_plants => 'Todas as plantas';

  @override
  String get planting_stat_plantings => 'Plantios';

  @override
  String get planting_stat_total_quantity => 'Quantidade total';

  @override
  String get planting_stat_success_rate => 'Taxa de sucesso';

  @override
  String get planting_stat_in_growth => 'Em crescimento';

  @override
  String get planting_stat_ready_for_harvest => 'Pronto p/ colher';

  @override
  String get planting_empty_none => 'Nenhum plantio';

  @override
  String get planting_empty_first =>
      'Comece adicionando seu primeiro plantio nesta parcela.';

  @override
  String get planting_create_action => 'Criar Plantio';

  @override
  String get planting_empty_no_result => 'Sem resultados';

  @override
  String get planting_clear_filters => 'Limpar filtros';

  @override
  String get planting_add_tooltip => 'Adicionar plantio';

  @override
  String get search_hint => 'Pesquisar...';

  @override
  String get error_page_title => 'Página não encontrada';

  @override
  String error_page_message(String uri) {
    return 'A página \"$uri\" não existe.';
  }

  @override
  String get error_page_back => 'Voltar ao Início';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get dialog_cancel => 'Cancelar';

  @override
  String snackbar_commune_selected(String name) {
    return 'Localização selecionada: $name';
  }

  @override
  String get common_validate => 'Validar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get empty_action_create => 'Criar';

  @override
  String get user_guide_text =>
      '1 — Bem-vindo ao Sowing\n(Tradução em andamento...)\nSowing é um aplicativo projetado para apoiar jardineiros no monitoramento vivo e concreto de suas culturas.\n...';

  @override
  String get privacy_policy_text =>
      'Sowing respeita totalmente a sua privacidade.\n\n• Todos os dados são armazenados localmente no seu dispositivo\n• Nenhum dado pessoal é transmitido a terceiros\n• Nenhuma informação é armazenada em um servidor externo\n\nO aplicativo funciona inteiramente offline. Uma conexão com a Internet é usada apenas para recuperar dados meteorológicos ou durante as exportações.';

  @override
  String get terms_text =>
      'Ao usar o Sowing, você concorda em:\n\n• Usar o aplicativo de forma responsável\n• Não tentar contornar suas limitações\n• Respeitar os direitos de propriedade intelectual\n• Usar apenas seus próprios dados\n\nEste aplicativo é fornecido como está, sem garantia.\n\nA equipe Sowing permanece atenta a qualquer melhoria ou evolução futura.';

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
  String get task_editor_error_title_required => 'Required';

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
}
