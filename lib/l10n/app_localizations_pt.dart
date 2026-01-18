// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'PermaCalendar';

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
  String get settings_about => 'Sobre';

  @override
  String get settings_user_guide => 'Guia do Usuário';

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
    return 'Versão: $version – Gestão Dinâmica de Jardim\n\nPermaCalendar - Gestão de Jardins Vivos';
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
}
