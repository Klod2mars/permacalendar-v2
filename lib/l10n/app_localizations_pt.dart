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
}
