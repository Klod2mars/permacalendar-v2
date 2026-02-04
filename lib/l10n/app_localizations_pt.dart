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
  String get garden_creation_dialog_title => 'Crie seu primeiro jardim';

  @override
  String get garden_creation_dialog_description =>
      'Dê um nome ao seu espaço de permacultura para começar.';

  @override
  String get garden_creation_name_label => 'Nome do jardim';

  @override
  String get garden_creation_name_hint => 'Ex: Minha Horta';

  @override
  String get garden_creation_name_required => 'O nome é obrigatório';

  @override
  String get garden_creation_create_button => 'Criar';

  @override
  String get settings_title => 'Configurações';

  @override
  String get home_settings_fallback_label => 'Configurações (fallback)';

  @override
  String get settings_application => 'Aplicativo';

  @override
  String get settings_version => 'Versão';

  @override
  String get settings_display => 'Exibição';

  @override
  String get settings_weather_selector => 'Seletor de Clima';

  @override
  String get settings_commune_title => 'Localização para clima';

  @override
  String get settings_choose_commune => 'Escolher localização';

  @override
  String get settings_search_commune_hint => 'Pesquisar um local...';

  @override
  String settings_commune_default(String label) {
    return 'Padrão: $label';
  }

  @override
  String settings_commune_selected(String label) {
    return 'Selecionado: $label';
  }

  @override
  String get settings_notifications_title => 'Notifications';

  @override
  String get settings_notifications_subtitle =>
      'Activer les rappels et alertes';

  @override
  String get settings_notification_permission_dialog_title =>
      'Permission requise';

  @override
  String get settings_notification_permission_dialog_content =>
      'Les notifications sont désactivées. Veuillez les activer dans les paramètres système pour recevoir les rappels.';

  @override
  String get settings_open_system_settings => 'Ouvrir les paramètres';

  @override
  String get settings_quick_access => 'Acesso rápido';

  @override
  String get settings_plants_catalog => 'Catálogo de plantas';

  @override
  String get settings_plants_catalog_subtitle =>
      'Pesquisar e visualizar plantas';

  @override
  String get settings_about => 'Sobre';

  @override
  String get settings_user_guide => 'Guia do usuário';

  @override
  String get settings_user_guide_subtitle => 'Ler o manual';

  @override
  String get settings_privacy => 'Privacidade';

  @override
  String get settings_privacy_policy => 'Política de privacidade';

  @override
  String get settings_terms => 'Termos de uso';

  @override
  String get settings_version_dialog_title => 'Versão do aplicativo';

  @override
  String settings_version_dialog_content(String version) {
    return 'Versão: $version – Gestão de jardim dinâmica\n\nSowing - Gestão de jardins vivos';
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
  String get garden_no_gardens => 'Nenhum jardim ainda.';

  @override
  String get garden_archived_info =>
      'Você tem jardins arquivados. Ative a exibição de jardins arquivados para vê-los.';

  @override
  String get garden_add_tooltip => 'Adicionar jardim';

  @override
  String get plant_catalog_title => 'Catálogo de plantas';

  @override
  String get plant_catalog_search_hint => 'Pesquisar planta...';

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
  String get plant_detail_share_todo =>
      'Compartilhamento ainda não implementado';

  @override
  String get plant_detail_add_to_garden_todo =>
      'Adicionar ao jardim ainda não implementado';

  @override
  String get plant_detail_section_culture => 'Detalhes de cultura';

  @override
  String get plant_detail_section_instructions => 'Instruções gerais';

  @override
  String get plant_detail_detail_family => 'Família';

  @override
  String get plant_detail_detail_maturity => 'Tempo de maturação';

  @override
  String get plant_detail_detail_spacing => 'Espaçamento';

  @override
  String get plant_detail_detail_exposure => 'Exposição';

  @override
  String get plant_detail_detail_water => 'Necessidades de água';

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
  String get planting_stat_ready_for_harvest => 'Pronto para colher';

  @override
  String get planting_empty_none => 'Nenhum plantio';

  @override
  String get planting_empty_first =>
      'Adicione seu primeiro plantio neste canteiro.';

  @override
  String get planting_create_action => 'Criar plantio';

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
  String get error_page_back => 'Voltar ao início';

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
  String get common_save => 'Salvar';

  @override
  String get empty_action_create => 'Criar';

  @override
  String get user_guide_text =>
      '1 — Bem-vindo ao Sowing\nSowing é um aplicativo projetado para apoiar jardineiros no monitoramento vivo e concreto de suas culturas.\nEle permite que você:\n• organize seus jardins e canteiros,\n• acompanhe seus plantios ao longo de seu ciclo de vida,\n• planeje suas tarefas no momento certo,\n• mantenha uma memória do que foi feito,\n• leve em consideração o clima local e o ritmo das estações.\nO aplicativo funciona principalmente offline e mantém seus dados diretamente no seu dispositivo.\nEste manual descreve o uso comum do Sowing: primeiros passos, criação de jardins, plantios, calendário, clima, exportação de dados e melhores práticas.\n\n2 — Compreendendo a interface\nO painel\nAo abrir, o Sowing exibe um painel visual e orgânico.\nEle toma a forma de uma imagem de fundo animada por bolhas interativas. Cada bolha dá acesso a uma função principal do aplicativo:\n• jardins,\n• clima do ar,\n• clima do solo,\n• calendário,\n• atividades,\n• estatísticas,\n• configurações.\nNavegação geral\nBasta tocar em uma bolha para abrir a seção correspondente.\nDentro das páginas, você encontrará dependendo do contexto:\n• menus contextuais,\n• botões \"+\" para adicionar um elemento,\n• botões de edição ou exclusão.\n\n3 — Início rápido\nAbrir o aplicativo\nAo iniciar, o painel é exibido automaticamente.\nConfigurar o clima\nNas configurações, escolha sua localização.\nEsta informação permite ao Sowing exibir o clima local adaptado ao seu jardim. Se nenhuma localização for selecionada, uma padrão é usada.\nCriar seu primeiro jardim\nAo usar pela primeira vez, o Sowing guia você automaticamente para criar seu primeiro jardim.\nVocê também pode criar um jardim manualmente a partir do painel.\nNa tela principal, toque na folha verde localizada na área mais livre, à direita das estatísticas e um pouco acima. Esta área deliberadamente discreta permite iniciar a criação de um jardim.\nVocê pode criar até cinco jardins.\nEssa abordagem faz parte da experiência Sowing: não há um botão \"+\" permanente e central. O aplicativo convida mais à exploração e descoberta progressiva do espaço.\nAs áreas vinculadas aos jardins também são acessíveis pelo menu Configurações.\nCalibração orgânica do painel\nUm modo de calibração orgânica permite:\n• visualizar a localização real das zonas interativas,\n• movê-las simplesmente deslizando o dedo.\nAssim você pode posicionar seus jardins e módulos exatamente onde quiser na imagem: acima, abaixo ou no local que melhor lhe convier.\nUma vez validada, essa organização é salva e mantida no aplicativo.\nCriar um canteiro\nEm uma ficha de jardim:\n• escolha \"Adicionar um canteiro\",\n• indique seu nome, sua área e, se necessário, algumas notas,\n• salve.\nAdicionar um plantio\nEm um canteiro:\n• pressione o botão \"+\",\n• escolha uma planta do catálogo,\n• indique a data, a quantidade e informações úteis,\n• valide.\n\n4 — O painel orgânico\nO painel é o ponto central do Sowing.\nEle permite:\n• ter uma visão geral de sua atividade,\n• acessar rapidamente as funções principais,\n• navegar intuitivamente.\nDependendo de suas configurações, algumas bolhas podem exibir informações sintéticas, como o clima ou tarefas futuras.\n\n5 — Jardins, canteiros e plantios\nOs jardins\nUm jardim representa um local real: horta, estufa, pomar, varanda, etc.\nVocê pode:\n• criar vários jardins,\n• modificar suas informações,\n• excluí-los se necessário.\nOs canteiros\nUm canteiro é uma zona precisa dentro de um jardim.\nPermite estruturar o espaço, organizar culturas e agrupar vários plantios no mesmo local.\nOs plantios\nUm plantio corresponde à introdução de uma planta em um canteiro, em uma data determinada.\nAo criar um plantio, o Sowing oferece dois modos.\nSemear\nO modo \"Semear\" corresponde a colocar uma semente na terra.\nNeste caso:\n• o progresso começa em 0%,\n• um acompanhamento passo a passo é proposto, particularmente útil para jardineiros iniciantes,\n• uma barra de progresso visualiza o avanço do ciclo de cultivo.\nEste acompanhamento permite estimar:\n• o início provável do período de colheita,\n• a evolução da cultura ao longo do tempo, de uma maneira simples e visual.\nPlantar\nO modo \"Plantar\" destina-se a plantas já desenvolvidas (plantas de uma estufa ou compradas em um centro de jardinagem).\nNeste caso:\n• a planta começa com um progresso de aproximadamente 30%,\n• o acompanhamento é imediatamente mais avançado,\n• a estimativa do período de colheita é ajustada de acordo.\nEscolha da data\nAo plantar, você pode escolher livremente a data.\nIsso permite por exemplo:\n• preencher um plantio realizado anteriormente,\n• corrigir uma data se o aplicativo não foi usado no momento da semeadura ou plantio.\nPor padrão, a data atual é usada.\nAcompanhamento e histórico\nCada plantio tem:\n• um acompanhamento de progresso,\n• informações sobre seu ciclo de vida,\n• estágios de cultivo,\n• notas pessoais.\nTodas as ações (semeadura, plantio, cuidado, colheita) são registradas automaticamente no histórico do jardim.\n\n6 — Catálogo de plantas\nO catálogo reúne todas as plantas disponíveis ao criar um plantio.\nConstitui uma base de referência escalável, projetada para cobrir usos atuais enquanto permanece personalizável.\nFunções principais:\n• pesquisa simples e rápida,\n• reconhecimento de nomes comuns e científicos,\n• exibição de fotos quando disponíveis.\nPlantas personalizadas\nVocê pode criar suas próprias plantas personalizadas a partir de:\nConfigurações → Catálogo de plantas.\nEntão é possível:\n• criar uma nova planta,\n• preencher os parâmetros essenciais (nome, tipo, informações úteis),\n• adicionar uma imagem para facilitar a identificação.\nAs plantas personalizadas são então utilizáveis como qualquer outra planta no catálogo.\n\n7 — Calendário e tarefas\nA visualização de calendário\nO calendário exibe:\n• tarefas planejadas,\n• plantios importantes,\n• períodos de colheita estimados.\nCriar uma tarefa\nDo calendário:\n• crie uma nova tarefa,\n• indique um título, uma data e uma descrição,\n• escolha uma possível recorrência.\nAs tarefas podem ser associadas a um jardim ou a um canteiro.\nGestão de tarefas\nVocê pode:\n• modificar uma tarefa,\n• excluí-la,\n• exportá-la para compartilhá-la.\n\n8 — Atividades e histórico\nEsta seção constitui a memória viva de seus jardins.\nSeleção de um jardim\nDo painel, mantenha pressionado um jardim para selecioná-lo.\nO jardim ativo é destacado com um halo verde claro e um banner de confirmação.\nEsta seleção permite filtrar as informações exibidas.\nAtividades recentes\nA aba \"Atividades\" exibe cronologicamente:\n• criações,\n• plantios,\n• cuidados,\n• colheitas,\n• ações manuais.\nHistórico por jardim\nA aba \"Histórico\" apresenta o histórico completo do jardim selecionado, ano após ano.\nPermite em particular:\n• encontrar plantios passados,\n• verificar se uma planta já foi cultivada em um local determinado,\n• organizar melhor a rotação de culturas.\n\n9 — Clima do ar e clima do solo\nClima do ar\nO clima do ar fornece informações essenciais:\n• temperatura externa,\n• precipitações (chuva, neve, sem chuva),\n• alternância dia / noite.\nEsses dados ajudam a antecipar riscos climáticos e adaptar intervenções.\nClima do solo\nO Sowing integra um módulo de clima do solo.\nO usuário pode preencher uma temperatura medida. A partir desses dados, o aplicativo estima dinamicamente a evolução da temperatura do solo ao longo do tempo.\nEsta informação permite:\n• saber quais plantas são realmente cultiváveis em um determinado momento,\n• ajustar a semeadura às condições reais em vez de um calendário teórico.\nClima em tempo real no painel\nUm módulo central em forma de ovo exibe de relance:\n• o estado do céu,\n• dia ou noite,\n• a fase e posição da lua para a localização selecionada.\nNavegação no tempo\nDeslizando o dedo da esquerda para a direita sobre o ovo, você navega pelas previsões hora a hora, até mais de 12 horas de antecedência.\nA temperatura e as precipitações se ajustam dinamicamente durante o gesto.\n\n10 — Recomendações\nO Sowing pode oferecer recomendações adaptadas à sua situação.\nElas baseiam-se em:\n• a estação,\n• o clima,\n• o estado de seus plantios.\nCada recomendação especifica:\n• o que fazer,\n• quando agir,\n• por que a ação é sugerida.\n\n11 — Exportação e compartilhamento\nExportação PDF — calendário e tarefas\nAs tarefas do calendário podem ser exportadas para PDF.\nIsso permite:\n• compartilhar informações claras,\n• transmitir uma intervenção planejada,\n• manter um rastro legível e datado.\nExportação Excel — colheitas e estatísticas\nOs dados de colheita podem ser exportados em formato Excel para:\n• analisar os resultados,\n• produzir relatórios,\n• acompanhar a evolução ao longo do tempo.\nCompartilhamento de documentos\nOs documentos gerados podem ser compartilhados através dos aplicativos disponíveis no seu dispositivo (mensagens, armazenamento, transferência para um computador, etc.).\n\n12 — Backup e melhores práticas\nOs dados são armazenados localmente no seu dispositivo.\nMelhores práticas recomendadas:\n• faça um backup antes de uma atualização importante,\n• exporte seus dados regularmente,\n• mantenha o aplicativo e o dispositivo atualizados.\n\n13 — Configurações\nO menu Configurações permite adaptar o Sowing aos seus usos.\nVocê pode notavelmente:\n• escolher o idioma,\n• selecionar sua localização,\n• acessar o catálogo de plantas,\n• personalizar o painel.\nPersonalização do painel\nÉ possível:\n• reposicionar cada módulo,\n• ajustar o espaço visual,\n• alterar a imagem de fundo,\n• importar sua própria imagem (função em breve).\nInformações legais\nNas configurações, você pode consultar:\n• o guia do usuário,\n• a política de privacidade,\n• os termos de uso.\n\n14 — Perguntas frequentes\nAs zonas táteis não estão bem alinhadas\nDependendo do telefone ou das configurações de exibição, algumas zonas podem parecer deslocadas.\nUm modo de calibração orgânica permite:\n• visualizar as zonas táteis,\n• reposicioná-las deslizando,\n• salvar a configuração para o seu dispositivo.\nPosso usar o Sowing offline?\nSim. O Sowing funciona offline para a gestão de jardins, plantios, tarefas e histórico.\nApenas uma conexão é usada:\n• para a recuperação de dados meteorológicos,\n• durante a exportação ou compartilhamento de documentos.\nNenhum outro dado é transmitido.\n\n15 — Observação final\nO Sowing é projetado como um companheiro de jardinagem: simples, vivo e escalável.\nAproveite o tempo para observar, anotar e confiar em sua experiência tanto quanto na ferramenta.';

  @override
  String get privacy_policy_text =>
      'O Sowing respeita totalmente sua privacidade.\n\n• Todos os dados são armazenados localmente no seu dispositivo\n• Nenhum dado pessoal é transmitido a terceiros\n• Nenhuma informação é armazenada em um servidor externo\n\nO aplicativo funciona completamente offline. Uma conexão com a Internet é usada apenas para recuperar dados meteorológicos ou durante as exportações.';

  @override
  String get terms_text =>
      'Ao usar o Sowing, você concorda em:\n\n• Usar o aplicativo de maneira responsável\n• Não tentar contornar suas limitações\n• Respeitar os direitos de propriedade intelectual\n• Usar apenas seus próprios dados\n\nEste aplicativo é fornecido como está, sem garantia.\n\nA equipe do Sowing permanece aberta a qualquer melhoria ou evolução futura.';

  @override
  String get calibration_auto_apply =>
      'Aplicar automaticamente para este dispositivo';

  @override
  String get calibration_calibrate_now => 'Calibrar agora';

  @override
  String get calibration_save_profile => 'Salvar calibração atual como perfil';

  @override
  String get calibration_export_profile => 'Exportar perfil (cópia JSON)';

  @override
  String get calibration_import_profile =>
      'Importar perfil da área de transferência';

  @override
  String get calibration_reset_profile =>
      'Redefinir perfil para este dispositivo';

  @override
  String get calibration_refresh_profile => 'Atualizar visualização do perfil';

  @override
  String calibration_key_device(String key) {
    return 'Chave do dispositivo: $key';
  }

  @override
  String get calibration_no_profile =>
      'Nenhum perfil salvo para este dispositivo.';

  @override
  String get calibration_image_settings_title =>
      'Configurações de Imagem de Fundo (Persistente)';

  @override
  String get calibration_pos_x => 'Pos X';

  @override
  String get calibration_pos_y => 'Pos Y';

  @override
  String get calibration_zoom => 'Zoom';

  @override
  String get calibration_reset_image => 'Redefinir padrões de imagem';

  @override
  String get calibration_dialog_confirm_title => 'Confirmar';

  @override
  String get calibration_dialog_delete_profile =>
      'Excluir perfil de calibração para este dispositivo?';

  @override
  String get calibration_action_delete => 'Excluir';

  @override
  String get calibration_snack_no_profile =>
      'Nenhum perfil encontrado para este dispositivo.';

  @override
  String get calibration_snack_profile_copied =>
      'Perfil copiado para a área de transferência.';

  @override
  String get calibration_snack_clipboard_empty =>
      'Área de transferência vazia.';

  @override
  String get calibration_snack_profile_imported =>
      'Perfil importado e salvo para este dispositivo.';

  @override
  String calibration_snack_import_error(String error) {
    return 'Erro de importação JSON: $error';
  }

  @override
  String get calibration_snack_profile_deleted =>
      'Perfil excluído para este dispositivo.';

  @override
  String get calibration_snack_no_calibration =>
      'Nenhuma calibração salva. Calibre a partir do painel primeiro.';

  @override
  String get calibration_snack_saved_as_profile =>
      'Calibração atual salva como perfil para este dispositivo.';

  @override
  String calibration_snack_save_error(String error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String get calibration_overlay_saved => 'Calibração salva';

  @override
  String calibration_overlay_error_save(String error) {
    return 'Erro ao salvar calibração: $error';
  }

  @override
  String get calibration_instruction_image =>
      'Arraste para mover, pince para ampliar a imagem de fundo.';

  @override
  String get calibration_instruction_sky =>
      'Ajuste o ovo dia/noite (centro, tamanho, rotação).';

  @override
  String get calibration_instruction_modules =>
      'Mova os módulos (bolhas) para o local desejado.';

  @override
  String get calibration_instruction_none =>
      'Selecione uma ferramenta para começar.';

  @override
  String get calibration_tool_image => 'Imagem';

  @override
  String get calibration_tool_sky => 'Céu';

  @override
  String get calibration_tool_modules => 'Módulos';

  @override
  String get calibration_action_validate_exit => 'Validar e Sair';

  @override
  String get garden_management_create_title => 'Criar Jardim';

  @override
  String get garden_management_edit_title => 'Editar Jardim';

  @override
  String get garden_management_name_label => 'Nome do Jardim';

  @override
  String get garden_management_desc_label => 'Descrição';

  @override
  String get garden_management_image_label => 'Imagem do Jardim (Opcional)';

  @override
  String get garden_management_image_url_label => 'URL da Imagem';

  @override
  String get garden_management_image_preview_error =>
      'Não foi possível carregar a imagem';

  @override
  String get garden_management_create_submit => 'Criar Jardim';

  @override
  String get garden_management_create_submitting => 'Criando...';

  @override
  String get garden_management_created_success => 'Jardim criado com sucesso';

  @override
  String get garden_management_create_error => 'Falha ao criar jardim';

  @override
  String get garden_management_delete_confirm_title => 'Excluir Jardim';

  @override
  String get garden_management_delete_confirm_body =>
      'Tem certeza de que deseja excluir este jardim? Isso também excluirá todos os canteiros e plantios associados. Esta ação é irreversível.';

  @override
  String get garden_management_delete_success => 'Jardim excluído com sucesso';

  @override
  String get garden_management_archived_tag => 'Jardim Arquivado';

  @override
  String get garden_management_beds_title => 'Canteiros do Jardim';

  @override
  String get garden_management_no_beds_title => 'Sem Canteiros';

  @override
  String get garden_management_no_beds_desc =>
      'Crie canteiros para organizar seus plantios';

  @override
  String get garden_management_add_bed_label => 'Criar Canteiro';

  @override
  String get garden_management_stats_beds => 'Canteiros';

  @override
  String get garden_management_stats_area => 'Área Total';

  @override
  String get dashboard_weather_stats => 'Detalhes do Clima';

  @override
  String get dashboard_soil_temp => 'Temp. Solo';

  @override
  String get dashboard_air_temp => 'Temperatura';

  @override
  String get dashboard_statistics => 'Estatísticas';

  @override
  String get dashboard_calendar => 'Calendário';

  @override
  String get dashboard_activities => 'Atividades';

  @override
  String get dashboard_weather => 'Clima';

  @override
  String get dashboard_settings => 'Configurações';

  @override
  String dashboard_garden_n(int number) {
    return 'Jardim $number';
  }

  @override
  String dashboard_garden_created(String name) {
    return 'Jardim \"$name\" criado com sucesso';
  }

  @override
  String get dashboard_garden_create_error => 'Erro ao criar jardim.';

  @override
  String get calendar_title => 'Calendário de cultivo';

  @override
  String get calendar_refreshed => 'Calendário atualizado';

  @override
  String get calendar_new_task_tooltip => 'Nova Tarefa';

  @override
  String get calendar_task_saved_title => 'Tarefa salva';

  @override
  String get calendar_ask_export_pdf =>
      'Deseja enviar a ficha da tarefa para alguém?';

  @override
  String get action_no_thanks => 'Não, obrigado';

  @override
  String get action_pdf => 'PDF';

  @override
  String get calendar_task_modified => 'Tarefa modificada';

  @override
  String get calendar_delete_confirm_title => 'Excluir tarefa?';

  @override
  String calendar_delete_confirm_content(String title) {
    return '\"$title\" será excluída.';
  }

  @override
  String get calendar_task_deleted => 'Tarefa excluída';

  @override
  String calendar_restore_error(Object error) {
    return 'Erro de restauração: $error';
  }

  @override
  String calendar_delete_error(Object error) {
    return 'Erro de exclusão: $error';
  }

  @override
  String get calendar_action_assign => 'Enviar / Atribuir a...';

  @override
  String get calendar_assign_title => 'Atribuir / Enviar';

  @override
  String get calendar_assign_hint => 'Digite nome ou e-mail';

  @override
  String get calendar_assign_field => 'Nome ou E-mail';

  @override
  String calendar_task_assigned(String name) {
    return 'Tarefa atribuída a $name';
  }

  @override
  String calendar_assign_error(Object error) {
    return 'Erro de atribuição: $error';
  }

  @override
  String calendar_export_error(Object error) {
    return 'Erro de exportação PDF: $error';
  }

  @override
  String get calendar_personal_notification => 'Notification';

  @override
  String get calendar_personal_notification_on => 'Activée';

  @override
  String get calendar_personal_notification_off => 'Désactivée';

  @override
  String get calendar_notify_before => 'Prévenir avant';

  @override
  String get minutes => 'minutes';

  @override
  String get calendar_previous_month => 'Mês anterior';

  @override
  String get calendar_next_month => 'Próximo mês';

  @override
  String get calendar_limit_reached => 'Limite atingido';

  @override
  String get calendar_drag_instruction => 'Deslize para navegar';

  @override
  String get common_refresh => 'Atualizar';

  @override
  String get common_yes => 'Sim';

  @override
  String get common_no => 'Não';

  @override
  String get common_delete => 'Excluir';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_undo => 'Desfazer';

  @override
  String common_error_prefix(Object error) {
    return 'Erro: $error';
  }

  @override
  String get common_retry => 'Tentar novamente';

  @override
  String get calendar_no_events => 'Sem eventos hoje';

  @override
  String calendar_events_of(String date) {
    return 'Eventos de $date';
  }

  @override
  String get calendar_section_plantings => 'Plantios';

  @override
  String get calendar_section_harvests => 'Colheitas esperadas';

  @override
  String get calendar_section_tasks => 'Tarefas agendadas';

  @override
  String get calendar_filter_tasks => 'Tarefas';

  @override
  String get common_attention => 'Atenção';

  @override
  String get limit_beds_reached_message =>
      'Para garantir uma fluidez perfeita, o limite é fixado em 100 parcelas por jardim. Você atingiu este limite de conforto.';

  @override
  String get limit_plantings_reached_message =>
      'Limite de 6 plantas atingido.\nPor favor, remova uma planta desta parcela para adicionar uma nova.';

  @override
  String get limit_gardens_reached_message =>
      'Limite de 5 jardins actifs atteinte.\nVeuillez archiver ou supprimer un jardin pour en créer un nouveau.';

  @override
  String get calendar_filter_maintenance => 'Manutenção';

  @override
  String get calendar_filter_harvests => 'Colheitas';

  @override
  String get calendar_filter_urgent => 'Urgente';

  @override
  String get common_general_error => 'Ocorreu um erro';

  @override
  String get common_error => 'Erro';

  @override
  String get settings_backup_restore_section => 'Backup e Restauração';

  @override
  String get settings_backup_restore_subtitle => 'Backup completo dos dados';

  @override
  String get settings_backup_action => 'Criar backup';

  @override
  String get settings_restore_action => 'Restaurar backup';

  @override
  String get settings_backup_creating => 'Criando backup...';

  @override
  String get settings_backup_success => 'Backup criado com sucesso!';

  @override
  String get settings_restore_warning_title => 'Atenção';

  @override
  String get settings_restore_warning_content =>
      'A restauração de um backup substituirá TODOS os dados atuais. Esta ação é irreversível. O aplicativo precisará ser reiniciado.\n\nTem certeza que deseja continuar?';

  @override
  String get settings_restore_success =>
      'Restauração bem-sucedida! Reinicie o aplicativo.';

  @override
  String settings_backup_error(Object error) {
    return 'Falha no backup: $error';
  }

  @override
  String settings_restore_error(Object error) {
    return 'Falha na restauração: $error';
  }

  @override
  String get settings_backup_compatible_zip => 'Compatível com ZIP';

  @override
  String get backup_share_subject => 'Backup PermaCalendar';

  @override
  String get task_editor_title_new => 'Nova Tarefa';

  @override
  String get task_editor_title_edit => 'Editar Tarefa';

  @override
  String get task_editor_title_field => 'Título *';

  @override
  String get activity_screen_title => 'Atividades e Histórico';

  @override
  String activity_tab_recent_garden(String gardenName) {
    return 'Recente ($gardenName)';
  }

  @override
  String get activity_tab_recent_global => 'Recente (Global)';

  @override
  String get activity_tab_history => 'Histórico';

  @override
  String get activity_history_section_title => 'Histórico — ';

  @override
  String get activity_history_empty =>
      'Nenhum jardim selecionado.\nPara ver o histórico de um jardim, pressione longamente nele no painel.';

  @override
  String get activity_empty_title => 'Nenhuma atividade encontrada';

  @override
  String get activity_empty_subtitle =>
      'As atividades de jardinagem aparecerão aqui';

  @override
  String get activity_error_loading => 'Erro ao carregar atividades';

  @override
  String get activity_priority_important => 'Importante';

  @override
  String get activity_priority_normal => 'Normal';

  @override
  String get activity_time_just_now => 'Agora mesmo';

  @override
  String activity_time_minutes_ago(int minutes) {
    return 'há $minutes min';
  }

  @override
  String activity_time_hours_ago(int hours) {
    return 'há $hours h';
  }

  @override
  String activity_time_days_ago(int count) {
    return 'há $count dias';
  }

  @override
  String activity_metadata_garden(String name) {
    return 'Jardim: $name';
  }

  @override
  String activity_metadata_bed(String name) {
    return 'Canteiro: $name';
  }

  @override
  String activity_metadata_plant(String name) {
    return 'Planta: $name';
  }

  @override
  String activity_metadata_quantity(String quantity) {
    return 'Quantidade: $quantity';
  }

  @override
  String activity_metadata_date(String date) {
    return 'Data: $date';
  }

  @override
  String activity_metadata_maintenance(String type) {
    return 'Manutenção: $type';
  }

  @override
  String activity_metadata_weather(String weather) {
    return 'Clima: $weather';
  }

  @override
  String get task_editor_error_title_required => 'Obrigatório';

  @override
  String get history_hint_title => 'Para ver o histórico de um jardim';

  @override
  String get history_hint_body =>
      'Selecione-o pressionando longamente no painel.';

  @override
  String get history_hint_action => 'Ir ao painel';

  @override
  String activity_desc_garden_created(String name) {
    return 'Jardim \"$name\" criado';
  }

  @override
  String activity_desc_bed_created(String name) {
    return 'Canteiro \"$name\" criado';
  }

  @override
  String activity_desc_planting_created(String name) {
    return 'Plantio de \"$name\" adicionado';
  }

  @override
  String activity_desc_germination(String name) {
    return 'Germinação de \"$name\" confirmada';
  }

  @override
  String activity_desc_harvest(String name) {
    return 'Colheita de \"$name\" registrada';
  }

  @override
  String activity_desc_maintenance(String type) {
    return 'Manutenção: $type';
  }

  @override
  String activity_desc_garden_deleted(String name) {
    return 'Jardim \"$name\" excluído';
  }

  @override
  String activity_desc_bed_deleted(String name) {
    return 'Canteiro \"$name\" excluído';
  }

  @override
  String activity_desc_planting_deleted(String name) {
    return 'Plantio de \"$name\" excluído';
  }

  @override
  String activity_desc_garden_updated(String name) {
    return 'Jardim \"$name\" atualizado';
  }

  @override
  String activity_desc_bed_updated(String name) {
    return 'Canteiro \"$name\" atualizado';
  }

  @override
  String activity_desc_planting_updated(String name) {
    return 'Plantio de \"$name\" atualizado';
  }

  @override
  String get planting_steps_title => 'Passo a passo';

  @override
  String get planting_steps_add_button => 'Adicionar';

  @override
  String get planting_steps_see_less => 'Ver menos';

  @override
  String get planting_steps_see_all => 'Ver tudo';

  @override
  String get planting_steps_empty => 'Nenhum passo recomendado';

  @override
  String planting_steps_more(int count) {
    return '+ $count mais passos';
  }

  @override
  String get planting_steps_prediction_badge => 'Previsão';

  @override
  String planting_steps_date_prefix(String date) {
    return 'Em $date';
  }

  @override
  String get planting_steps_done => 'Feito';

  @override
  String get planting_steps_mark_done => 'Marcar como feito';

  @override
  String get planting_steps_dialog_title => 'Adicionar Passo';

  @override
  String get planting_steps_dialog_hint => 'Ex: Cobertura leve';

  @override
  String get planting_steps_dialog_add => 'Adicionar';

  @override
  String get planting_status_sown => 'Semeado';

  @override
  String get planting_status_planted => 'Plantado';

  @override
  String get planting_status_growing => 'Crescendo';

  @override
  String get planting_status_ready => 'Pronto para colher';

  @override
  String get planting_status_harvested => 'Colhido';

  @override
  String get planting_status_failed => 'Falhou';

  @override
  String planting_card_sown_date(String date) {
    return 'Semeado em $date';
  }

  @override
  String planting_card_planted_date(String date) {
    return 'Plantado em $date';
  }

  @override
  String planting_card_harvest_estimate(String date) {
    return 'Est. colheita: $date';
  }

  @override
  String get planting_info_title => 'Info Botânica';

  @override
  String get planting_info_tips_title => 'Dicas de Cultivo';

  @override
  String get planting_info_maturity => 'Maturidade';

  @override
  String planting_info_days(Object days) {
    return '$days dias';
  }

  @override
  String get planting_info_spacing => 'Espaçamento';

  @override
  String planting_info_cm(Object cm) {
    return '$cm cm';
  }

  @override
  String get planting_info_depth => 'Profundidade';

  @override
  String get planting_info_exposure => 'Exposição';

  @override
  String get planting_info_water => 'Água';

  @override
  String get planting_info_season => 'Estação de plantio';

  @override
  String get planting_info_scientific_name_none =>
      'Nome científico não disponível';

  @override
  String get planting_info_culture_title => 'Info de Cultivo';

  @override
  String get planting_info_germination => 'Tempo de germinação';

  @override
  String get planting_info_harvest_time => 'Tempo de colheita';

  @override
  String get planting_info_none => 'Não especificado';

  @override
  String get planting_tips_none => 'Nenhuma dica disponível';

  @override
  String get planting_history_title => 'Histórico de ações';

  @override
  String get planting_history_action_planting => 'Plantio';

  @override
  String get planting_history_todo => 'Histórico detalhado em breve';

  @override
  String get task_editor_garden_all => 'Todos os Jardins';

  @override
  String get task_editor_zone_label => 'Zona (Canteiro)';

  @override
  String get task_editor_zone_none => 'Nenhuma zona específica';

  @override
  String get task_editor_zone_empty => 'Nenhum canteiro para este jardim';

  @override
  String get task_editor_description_label => 'Descrição';

  @override
  String get task_editor_date_label => 'Data de Início';

  @override
  String get task_editor_time_label => 'Hora';

  @override
  String get task_editor_duration_label => 'Duração Estimada';

  @override
  String get task_editor_duration_other => 'Outro';

  @override
  String get task_editor_type_label => 'Tipo de Tarefa';

  @override
  String get task_editor_priority_label => 'Prioridade';

  @override
  String get task_editor_urgent_label => 'Urgente';

  @override
  String get task_editor_option_none => 'Nenhum (Apenas Salvar)';

  @override
  String get task_editor_option_share => 'Compartilhar (Texto)';

  @override
  String get task_editor_option_pdf => 'Exportar — PDF';

  @override
  String get task_editor_option_docx => 'Exportar — Word (.docx)';

  @override
  String get task_editor_export_label => 'Saída / Compartilhar';

  @override
  String get task_editor_photo_placeholder => 'Adicionar Foto (Em breve)';

  @override
  String get task_editor_action_create => 'Criar';

  @override
  String get task_editor_action_save => 'Salvar';

  @override
  String get task_editor_action_cancel => 'Cancelar';

  @override
  String get task_editor_assignee_label => 'Atribuído a';

  @override
  String task_editor_assignee_add(String name) {
    return 'Adicionar \"$name\" aos favoritos';
  }

  @override
  String get task_editor_assignee_none => 'Sem resultados.';

  @override
  String get task_editor_recurrence_label => 'Recorrência';

  @override
  String get task_editor_recurrence_none => 'Nenhuma';

  @override
  String get task_editor_recurrence_interval => 'A cada X dias';

  @override
  String get task_editor_recurrence_weekly => 'Semanalmente (Dias)';

  @override
  String get task_editor_recurrence_monthly => 'Mensalmente (mesmo dia)';

  @override
  String get task_editor_recurrence_repeat_label => 'Repetir a cada ';

  @override
  String get task_editor_recurrence_days_suffix => ' d';

  @override
  String get task_kind_generic => 'Genérico';

  @override
  String get task_kind_repair => 'Reparo 🛠️';

  @override
  String get soil_temp_title => 'Temperatura do Solo';

  @override
  String soil_temp_chart_error(Object error) {
    return 'Erro no gráfico: $error';
  }

  @override
  String get soil_temp_about_title => 'Sobre a Temp. do Solo';

  @override
  String get soil_temp_about_content =>
      'A temperatura do solo exibida aqui é estimada pelo aplicativo a partir de dados climáticos e sazonais, de acordo com a seguinte fórmula:\n\nEsta estimativa fornece uma tendência realista da temperatura do solo quando não há medição direta disponível.';

  @override
  String get soil_temp_formula_label => 'Fórmula de cálculo usada:';

  @override
  String get soil_temp_formula_content =>
      'T_solo(n+1) = T_solo(n) + α × (T_ar(n) − T_solo(n))\n\nCom:\n• α : coeficiente de difusão térmica (padrão 0,15 — intervalo recomendado 0,10–0,20).\n• T_solo(n) : temperatura atual do solo (°C).\n• T_ar(n) : temperatura atual do ar (°C).\n\nA fórmula está implementada no código do aplicativo (ComputeSoilTempNextDayUsecase).';

  @override
  String get soil_temp_current_label => 'Temperatura atual';

  @override
  String get soil_temp_action_measure => 'Editar / Medir';

  @override
  String get soil_temp_measure_hint =>
      'Você pode inserir manualmente a temperatura do solo na aba \'Editar / Medir\'.';

  @override
  String soil_temp_catalog_error(Object error) {
    return 'Erro no catálogo: $error';
  }

  @override
  String soil_temp_advice_error(Object error) {
    return 'Erro de conselho: $error';
  }

  @override
  String get soil_temp_db_empty => 'Banco de dados de plantas vazio.';

  @override
  String get soil_temp_reload_plants => 'Recarregar plantas';

  @override
  String get soil_temp_no_advice =>
      'Nenhuma planta com dados de germinação encontrada.';

  @override
  String get soil_advice_status_ideal => 'Ideal';

  @override
  String get soil_advice_status_sow_now => 'Semear Agora';

  @override
  String get soil_advice_status_sow_soon => 'Em Breve';

  @override
  String get soil_advice_status_wait => 'Aguardar';

  @override
  String get soil_sheet_title => 'Temperatura do Solo';

  @override
  String soil_sheet_last_measure(String temp, String date) {
    return 'Última medida: $temp°C ($date)';
  }

  @override
  String get soil_sheet_new_measure => 'Nova medida (Âncora)';

  @override
  String get soil_sheet_input_label => 'Temperatura (°C)';

  @override
  String get soil_sheet_input_error => 'Valor inválido (-10.0 a 45.0)';

  @override
  String get soil_sheet_input_hint => '0.0';

  @override
  String get soil_sheet_action_cancel => 'Cancelar';

  @override
  String get soil_sheet_action_save => 'Salvar';

  @override
  String get soil_sheet_snack_invalid =>
      'Valor inválido. Digite entre -10.0 e 45.0';

  @override
  String get soil_sheet_snack_success => 'Medida salva como âncora';

  @override
  String soil_sheet_snack_error(Object error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String get weather_screen_title => 'Clima';

  @override
  String get weather_provider_credit => 'Dados fornecidos por Open-Meteo';

  @override
  String get weather_error_loading => 'Não foi possível carregar o clima';

  @override
  String get weather_action_retry => 'Tentar Novamente';

  @override
  String get weather_header_next_24h => 'PRÓXIMAS 24H';

  @override
  String get weather_header_daily_summary => 'RESUMO DIÁRIO';

  @override
  String get weather_header_precipitations => 'PRECIPITAÇÃO (24h)';

  @override
  String get weather_label_wind => 'VENTO';

  @override
  String get weather_label_pressure => 'PRESSÃO';

  @override
  String get weather_label_sun => 'SOL';

  @override
  String get weather_label_astro => 'ASTRO';

  @override
  String get weather_data_speed => 'Velocidade';

  @override
  String get weather_data_gusts => 'Rajadas';

  @override
  String get weather_data_sunrise => 'Nascer do sol';

  @override
  String get weather_data_sunset => 'Pôr do sol';

  @override
  String get weather_data_rain => 'Chuva';

  @override
  String get weather_data_max => 'Máx';

  @override
  String get weather_data_min => 'Mín';

  @override
  String get weather_data_wind_max => 'Vento Máx';

  @override
  String get weather_pressure_high => 'Alta';

  @override
  String get weather_pressure_low => 'Baixa';

  @override
  String get weather_today_label => 'Hoje';

  @override
  String get moon_phase_new => 'Lua Nova';

  @override
  String get moon_phase_waxing_crescent => 'Lua Crescente';

  @override
  String get moon_phase_first_quarter => 'Quarto Crescente';

  @override
  String get moon_phase_waxing_gibbous => 'Gibosa Crescente';

  @override
  String get moon_phase_full => 'Lua Cheia';

  @override
  String get moon_phase_waning_gibbous => 'Gibosa Minguante';

  @override
  String get moon_phase_last_quarter => 'Quarto Minguante';

  @override
  String get moon_phase_waning_crescent => 'Lua Minguante';

  @override
  String get wmo_code_0 => 'Céu limpo';

  @override
  String get wmo_code_1 => 'Principalmente limpo';

  @override
  String get wmo_code_2 => 'Parcialmente nublado';

  @override
  String get wmo_code_3 => 'Encoberto';

  @override
  String get wmo_code_45 => 'Nevoeiro';

  @override
  String get wmo_code_48 => 'Nevoeiro com sincelo';

  @override
  String get wmo_code_51 => 'Garoa leve';

  @override
  String get wmo_code_53 => 'Garoa moderada';

  @override
  String get wmo_code_55 => 'Garoa densa';

  @override
  String get wmo_code_61 => 'Chuva leve';

  @override
  String get wmo_code_63 => 'Chuva moderada';

  @override
  String get wmo_code_65 => 'Chuva forte';

  @override
  String get wmo_code_66 => 'Chuva congelante leve';

  @override
  String get wmo_code_67 => 'Chuva congelante forte';

  @override
  String get wmo_code_71 => 'Queda de neve leve';

  @override
  String get wmo_code_73 => 'Queda de neve moderada';

  @override
  String get wmo_code_75 => 'Queda de neve forte';

  @override
  String get wmo_code_77 => 'Grãos de neve';

  @override
  String get wmo_code_80 => 'Pancadas de chuva leves';

  @override
  String get wmo_code_81 => 'Pancadas de chuva moderadas';

  @override
  String get wmo_code_82 => 'Pancadas de chuva violentas';

  @override
  String get wmo_code_85 => 'Pancadas de neve leves';

  @override
  String get wmo_code_86 => 'Pancadas de neve fortes';

  @override
  String get wmo_code_95 => 'Trovoada';

  @override
  String get wmo_code_96 => 'Trovoada com granizo leve';

  @override
  String get wmo_code_99 => 'Trovoada com granizo forte';

  @override
  String get wmo_code_unknown => 'Condições desconhecidas';

  @override
  String get task_kind_buy => 'Comprar 🛒';

  @override
  String get task_kind_clean => 'Limpar 🧹';

  @override
  String get task_kind_watering => 'Regar 💧';

  @override
  String get task_kind_seeding => 'Semear 🌱';

  @override
  String get task_kind_pruning => 'Podar ✂️';

  @override
  String get task_kind_weeding => 'Capinar 🌿';

  @override
  String get task_kind_amendment => 'Adubação 🪵';

  @override
  String get task_kind_treatment => 'Tratamento 🧪';

  @override
  String get task_kind_harvest => 'Colher 🧺';

  @override
  String get task_kind_winter_protection => 'Proteção de inverno ❄️';

  @override
  String get garden_detail_title_error => 'Erro';

  @override
  String get garden_detail_subtitle_not_found =>
      'O jardim solicitado não existe ou foi excluído.';

  @override
  String garden_detail_subtitle_error_beds(Object error) {
    return 'Não foi possível carregar canteiros: $error';
  }

  @override
  String get garden_action_edit => 'Editar';

  @override
  String get garden_action_archive => 'Arquivar';

  @override
  String get garden_action_unarchive => 'Desarquivar';

  @override
  String get garden_action_delete => 'Excluir';

  @override
  String garden_created_at(Object date) {
    return 'Criado em $date';
  }

  @override
  String get garden_bed_delete_confirm_title => 'Excluir Canteiro';

  @override
  String garden_bed_delete_confirm_body(Object bedName) {
    return 'Tem certeza de que deseja excluir \"$bedName\"? Esta ação é irreversível.';
  }

  @override
  String get garden_bed_deleted_snack => 'Canteiro excluído';

  @override
  String garden_bed_delete_error(Object error) {
    return 'Erro ao excluir canteiro: $error';
  }

  @override
  String get common_back => 'Voltar';

  @override
  String get garden_action_disable => 'Desativar';

  @override
  String get garden_action_enable => 'Ativar';

  @override
  String get garden_action_modify => 'Modificar';

  @override
  String get bed_create_title_new => 'Novo Canteiro';

  @override
  String get bed_create_title_edit => 'Editar Canteiro';

  @override
  String get bed_form_name_label => 'Nome do Canteiro *';

  @override
  String get bed_form_name_hint => 'Ex: Canteiro Norte, Parcela 1';

  @override
  String get bed_form_size_label => 'Área (m²) *';

  @override
  String get bed_form_size_hint => 'Ex: 10.5';

  @override
  String get bed_form_desc_label => 'Descrição';

  @override
  String get bed_form_desc_hint => 'Descrição...';

  @override
  String get bed_form_submit_create => 'Criar';

  @override
  String get bed_form_submit_edit => 'Salvar';

  @override
  String get bed_snack_created => 'Canteiro criado com sucesso';

  @override
  String get bed_snack_updated => 'Canteiro atualizado com sucesso';

  @override
  String get bed_form_error_name_required => 'Nome é obrigatório';

  @override
  String get bed_form_error_name_length =>
      'O nome deve ter pelo menos 2 caracteres';

  @override
  String get bed_form_error_size_required => 'Área é obrigatória';

  @override
  String get bed_form_error_size_invalid => 'Por favor, insira uma área válida';

  @override
  String get bed_form_error_size_max => 'A área não pode exceder 1000 m²';

  @override
  String get status_sown => 'Semeado';

  @override
  String get status_planted => 'Plantado';

  @override
  String get status_growing => 'Crescendo';

  @override
  String get status_ready_to_harvest => 'Pronto para colher';

  @override
  String get status_harvested => 'Colhido';

  @override
  String get status_failed => 'Falhou';

  @override
  String bed_card_sown_on(Object date) {
    return 'Semeado em $date';
  }

  @override
  String get bed_card_harvest_start => 'início colheita aprox.';

  @override
  String get bed_action_harvest => 'Colher';

  @override
  String get lifecycle_error_title => 'Erro ao calcular ciclo';

  @override
  String get lifecycle_error_prefix => 'Erro: ';

  @override
  String get lifecycle_cycle_completed => 'ciclo completado';

  @override
  String get lifecycle_stage_germination => 'Germinação';

  @override
  String get lifecycle_stage_growth => 'Crescimento';

  @override
  String get lifecycle_stage_fruiting => 'Frutificação';

  @override
  String get lifecycle_stage_harvest => 'Colheita';

  @override
  String get lifecycle_stage_unknown => 'Desconhecido';

  @override
  String get lifecycle_harvest_expected => 'Colheita esperada';

  @override
  String lifecycle_in_days(Object days) {
    return 'Em $days dias';
  }

  @override
  String get lifecycle_passed => 'Passado';

  @override
  String get lifecycle_now => 'Agora!';

  @override
  String get lifecycle_next_action => 'Próxima ação';

  @override
  String get lifecycle_update => 'Atualizar ciclo';

  @override
  String lifecycle_days_ago(Object days) {
    return 'há $days dias';
  }

  @override
  String get planting_detail_title => 'Detalhes do Plantio';

  @override
  String get companion_beneficial => 'Plantas benéficas';

  @override
  String get companion_avoid => 'Plantas a evitar';

  @override
  String get common_close => 'Fechar';

  @override
  String get bed_detail_surface => 'Área';

  @override
  String get bed_detail_details => 'Detalhes';

  @override
  String get bed_detail_notes => 'Notas';

  @override
  String get bed_detail_current_plantings => 'Plantios Atuais';

  @override
  String get bed_detail_no_plantings_title => 'Sem Plantios';

  @override
  String get bed_detail_no_plantings_desc =>
      'Este canteiro ainda não tem plantios.';

  @override
  String get bed_detail_add_planting => 'Adicionar Plantio';

  @override
  String get bed_delete_planting_confirm_title => 'Excluir Plantio?';

  @override
  String get bed_delete_planting_confirm_body =>
      'Esta ação é irreversível. Você realmente deseja excluir este plantio?';

  @override
  String harvest_title(Object plantName) {
    return 'Colheita: $plantName';
  }

  @override
  String get harvest_weight_label => 'Peso Colhido (kg) *';

  @override
  String harvest_price_label(String currencyUnit) {
    return 'Preço Estimado ($currencyUnit)';
  }

  @override
  String get harvest_price_helper =>
      'Será lembrado para futuras colheitas desta planta';

  @override
  String get harvest_notes_label => 'Notas / Qualidade';

  @override
  String get harvest_action_save => 'Salvar';

  @override
  String get harvest_snack_saved => 'Colheita registrada';

  @override
  String get harvest_snack_error => 'Erro ao registrar colheita';

  @override
  String get harvest_form_error_required => 'Obrigatório';

  @override
  String get harvest_form_error_positive => 'Inválido (> 0)';

  @override
  String get harvest_form_error_positive_or_zero => 'Inválido (>= 0)';

  @override
  String get info_exposure_full_sun => 'Sol pleno';

  @override
  String get info_exposure_partial_sun => 'Sol parcial';

  @override
  String get info_exposure_shade => 'Sombra';

  @override
  String get info_water_low => 'Baixo';

  @override
  String get info_water_medium => 'Médio';

  @override
  String get info_water_high => 'Alto';

  @override
  String get info_water_moderate => 'Moderado';

  @override
  String get info_season_spring => 'Primavera';

  @override
  String get info_season_summer => 'Verão';

  @override
  String get info_season_autumn => 'Outono';

  @override
  String get info_season_winter => 'Inverno';

  @override
  String get info_season_all => 'Todas as estações';

  @override
  String get common_duplicate => 'Duplicar';

  @override
  String get planting_delete_title => 'Excluir plantio';

  @override
  String get planting_delete_confirm_body =>
      'Você tem certeza que deseja excluir este plantio? Esta ação é irreversível.';

  @override
  String get planting_creation_title => 'Novo Plantio';

  @override
  String get planting_creation_title_edit => 'Editar Plantio';

  @override
  String get planting_quantity_seeds => 'Número de sementes';

  @override
  String get planting_quantity_plants => 'Número de plantas';

  @override
  String get planting_quantity_required => 'Quantidade é obrigatória';

  @override
  String get planting_quantity_positive =>
      'A quantidade deve ser um número positivo';

  @override
  String planting_plant_selection_label(Object plantName) {
    return 'Planta: $plantName';
  }

  @override
  String get planting_no_plant_selected => 'Nenhuma planta selecionada';

  @override
  String get planting_custom_plant_title => 'Planta Personalizada';

  @override
  String get planting_plant_name_label => 'Nome da Planta';

  @override
  String get planting_plant_name_hint => 'Ex: Tomate Cereja';

  @override
  String get planting_plant_name_required => 'Nome da planta é obrigatório';

  @override
  String get planting_notes_label => 'Notas (opcional)';

  @override
  String get planting_notes_hint => 'Informações adicionais...';

  @override
  String get planting_tips_title => 'Dicas';

  @override
  String get planting_tips_catalog =>
      '• Use o catálogo para selecionar uma planta.';

  @override
  String get planting_tips_type =>
      '• Escolha \"Semeado\" para sementes, \"Plantado\" para mudas.';

  @override
  String get planting_tips_notes =>
      '• Adicione notas para acompanhar condições especiais.';

  @override
  String get planting_date_future_error =>
      'Data de plantio não pode ser no futuro';

  @override
  String get planting_success_create => 'Plantio criado com sucesso';

  @override
  String get planting_success_update => 'Plantio atualizado com sucesso';

  @override
  String get stats_screen_title => 'Estatísticas';

  @override
  String get stats_screen_subtitle =>
      'Analise em tempo real e exporte seus dados.';

  @override
  String get kpi_alignment_title => 'Alinhamento Vivo';

  @override
  String get kpi_alignment_description =>
      'Esta ferramenta avalia quão próximas suas semeaduras, plantios e colheitas estão das janelas ideais recomendadas pela Agenda Inteligente.';

  @override
  String get kpi_alignment_cta =>
      'Comece a plantar e colher para ver seu alinhamento!';

  @override
  String get kpi_alignment_aligned => 'alinhado';

  @override
  String get kpi_alignment_total => 'Total';

  @override
  String get kpi_alignment_aligned_actions => 'Alinhado';

  @override
  String get kpi_alignment_misaligned_actions => 'Desalinhado';

  @override
  String get kpi_alignment_calculating => 'Calculando alinhamento...';

  @override
  String get kpi_alignment_error => 'Erro durante o cálculo';

  @override
  String get pillar_economy_title => 'Economia do Jardim';

  @override
  String get pillar_nutrition_title => 'Balanço Nutricional';

  @override
  String get pillar_export_title => 'Exportar';

  @override
  String get pillar_economy_label => 'Valor total da colheita';

  @override
  String get pillar_nutrition_label => 'Assinatura Nutricional';

  @override
  String get pillar_export_label => 'Recuperar seus dados';

  @override
  String get pillar_export_button => 'Exportar';

  @override
  String get stats_economy_title => 'Economia do Jardim';

  @override
  String get stats_economy_no_harvest =>
      'Nenhuma colheita no período selecionado.';

  @override
  String get stats_economy_no_harvest_desc =>
      'Sem dados para o período selecionado.';

  @override
  String get stats_kpi_total_revenue => 'Receita Total';

  @override
  String get stats_kpi_total_volume => 'Volume Total';

  @override
  String get stats_kpi_avg_price => 'Preço Médio';

  @override
  String get stats_top_cultures_title => 'Melhores Culturas (Valor)';

  @override
  String get stats_top_cultures_no_data => 'Sem dados';

  @override
  String get stats_top_cultures_percent_revenue => 'da receita';

  @override
  String get stats_monthly_revenue_title => 'Receita Mensal';

  @override
  String get stats_monthly_revenue_no_data => 'Sem dados mensais';

  @override
  String get stats_dominant_culture_title => 'Cultura Dominante por Mês';

  @override
  String get stats_annual_evolution_title => 'Tendência Anual';

  @override
  String get stats_crop_distribution_title => 'Distribuição de Culturas';

  @override
  String get stats_crop_distribution_others => 'Outros';

  @override
  String get stats_key_months_title => 'Meses Chave do Jardim';

  @override
  String get stats_most_profitable => 'Mais Lucrativo';

  @override
  String get stats_least_profitable => 'Menos Lucrativo';

  @override
  String get stats_auto_summary_title => 'Auto Resumo';

  @override
  String get stats_revenue_history_title => 'Histórico de Receita';

  @override
  String get stats_profitability_cycle_title => 'Ciclo de Rentabilidade';

  @override
  String get stats_table_crop => 'Cultura';

  @override
  String get stats_table_days => 'Dias (Méd)';

  @override
  String get stats_table_revenue => 'Rec/Colheita';

  @override
  String get stats_table_type => 'Tipo';

  @override
  String get stats_type_fast => 'Rápido';

  @override
  String get stats_type_long_term => 'Longo Prazo';

  @override
  String get nutrition_page_title => 'Assinatura Nutricional';

  @override
  String get nutrition_seasonal_dynamics_title => 'Dinâmica Sazonal';

  @override
  String get nutrition_seasonal_dynamics_desc =>
      'Explore a produção de minerais e vitaminas do seu jardim, mês a mês.';

  @override
  String get nutrition_no_harvest_month => 'Nenhuma colheita neste mês';

  @override
  String get nutrition_major_minerals_title =>
      'Estrutura e Principais Minerais';

  @override
  String get nutrition_trace_elements_title => 'Vitalidade e Oligoelementos';

  @override
  String get nutrition_no_data_period => 'Sem dados para este período';

  @override
  String get nutrition_no_major_minerals => 'Sem principais minerais';

  @override
  String get nutrition_no_trace_elements => 'Sem oligoelementos';

  @override
  String nutrition_month_dynamics_title(String month) {
    return 'Dinâmica de $month';
  }

  @override
  String get nutrition_dominant_production => 'Produção dominante:';

  @override
  String get nutrition_nutrients_origin =>
      'Estes nutrientes vêm de suas colheitas do mês.';

  @override
  String get nut_calcium => 'Cálcio';

  @override
  String get nut_potassium => 'Potássio';

  @override
  String get nut_magnesium => 'Magnésio';

  @override
  String get nut_iron => 'Ferro';

  @override
  String get nut_zinc => 'Zinco';

  @override
  String get nut_manganese => 'Manganês';

  @override
  String get nut_vitamin_c => 'Vitamina C';

  @override
  String get nut_fiber => 'Fibra';

  @override
  String get nut_protein => 'Proteína';

  @override
  String get export_builder_title => 'Construtor de Exportação';

  @override
  String get export_scope_section => '1. Escopo';

  @override
  String get export_scope_period => 'Período';

  @override
  String get export_scope_period_all => 'Todo o Histórico';

  @override
  String get export_filter_garden_title => 'Filtrar por Jardim';

  @override
  String get export_filter_garden_all => 'Todos os jardins';

  @override
  String export_filter_garden_count(Object count) {
    return '$count jardim(ns) selecionado(s)';
  }

  @override
  String get export_filter_garden_edit => 'Editar seleção';

  @override
  String get export_filter_garden_select_dialog_title => 'Selecionar Jardins';

  @override
  String get export_blocks_section => '2. Blocos de Dados';

  @override
  String get export_block_activity => 'Atividades (Diário)';

  @override
  String get export_block_harvest => 'Colheitas (Produção)';

  @override
  String get export_block_garden => 'Jardins (Estrutura)';

  @override
  String get export_block_garden_bed => 'Canteiros (Estrutura)';

  @override
  String get export_block_plant => 'Plantas (Catálogo)';

  @override
  String get export_block_desc_activity =>
      'Histórico completo de intervenções e eventos';

  @override
  String get export_block_desc_harvest => 'Dados de produção e rendimentos';

  @override
  String get export_block_desc_garden => 'Metadados dos jardins selecionados';

  @override
  String get export_block_desc_garden_bed =>
      'Detalhes dos canteiros (área, orientação...)';

  @override
  String get export_block_desc_plant => 'Lista de plantas usadas';

  @override
  String get export_columns_section => '3. Detalhes e Colunas';

  @override
  String export_columns_count(Object count) {
    return '$count colunas selecionadas';
  }

  @override
  String get export_format_section => '4. Formato de Arquivo';

  @override
  String get export_format_separate => 'Planilhas Separadas (Padrão)';

  @override
  String get export_format_separate_subtitle =>
      'Uma planilha por tipo de dado (Recomendado)';

  @override
  String get export_format_flat => 'Tabela Única (Plana / BI)';

  @override
  String get export_format_flat_subtitle =>
      'Uma grande tabela para Tabelas Dinâmicas';

  @override
  String get export_action_generate => 'Gerar Exportação Excel';

  @override
  String get export_generating => 'Gerando...';

  @override
  String get export_success_title => 'Exportação Concluída';

  @override
  String get export_success_share_text =>
      'Aqui está sua exportação do PermaCalendar';

  @override
  String export_error_snack(Object error) {
    return 'Erro: $error';
  }

  @override
  String get export_field_garden_name => 'Nome do Jardim';

  @override
  String get export_field_garden_id => 'ID do Jardim';

  @override
  String get export_field_garden_surface => 'Área (m²)';

  @override
  String get export_field_garden_creation => 'Data de Criação';

  @override
  String get export_field_bed_name => 'Nome do Canteiro';

  @override
  String get export_field_bed_id => 'ID Canteiro';

  @override
  String get export_field_bed_surface => 'Área (m²)';

  @override
  String get export_field_bed_plant_count => 'Nº Plantas';

  @override
  String get export_field_plant_name => 'Nome comum';

  @override
  String get export_field_plant_id => 'ID Planta';

  @override
  String get export_field_plant_scientific => 'Nome científico';

  @override
  String get export_field_plant_family => 'Família';

  @override
  String get export_field_plant_variety => 'Variedade';

  @override
  String get export_field_harvest_date => 'Data Colheita';

  @override
  String get export_field_harvest_qty => 'Quantidade (kg)';

  @override
  String get export_field_harvest_plant_name => 'Planta';

  @override
  String get export_field_harvest_price => 'Preço/kg';

  @override
  String get export_field_harvest_value => 'Valor Total';

  @override
  String get export_field_harvest_notes => 'Notas';

  @override
  String get export_field_harvest_garden_name => 'Jardim';

  @override
  String get export_field_harvest_garden_id => 'ID Jardim';

  @override
  String get export_field_harvest_bed_name => 'Canteiro';

  @override
  String get export_field_harvest_bed_id => 'ID Canteiro';

  @override
  String get export_field_activity_date => 'Data';

  @override
  String get export_field_activity_type => 'Tipo';

  @override
  String get export_field_activity_title => 'Título';

  @override
  String get export_field_activity_desc => 'Descrição';

  @override
  String get export_field_activity_entity => 'Entidade Alvo';

  @override
  String get export_field_activity_entity_id => 'ID Alvo';

  @override
  String get export_activity_type_garden_created => 'Criação de jardim';

  @override
  String get export_activity_type_garden_updated => 'Atualização de jardim';

  @override
  String get export_activity_type_garden_deleted => 'Remoção de jardim';

  @override
  String get export_activity_type_bed_created => 'Criação de canteiro';

  @override
  String get export_activity_type_bed_updated => 'Atualização de canteiro';

  @override
  String get export_activity_type_bed_deleted => 'Remoção de canteiro';

  @override
  String get export_activity_type_planting_created => 'Nova plantação';

  @override
  String get export_activity_type_planting_updated =>
      'Atualização de plantação';

  @override
  String get export_activity_type_planting_deleted => 'Remoção de plantação';

  @override
  String get export_activity_type_harvest => 'Colheita';

  @override
  String get export_activity_type_maintenance => 'Manutenção';

  @override
  String get export_activity_type_weather => 'Clima';

  @override
  String get export_activity_type_error => 'Erro';

  @override
  String get export_excel_total => 'TOTAL';

  @override
  String get export_excel_unknown => 'Desconhecido';

  @override
  String get export_field_advanced_suffix => ' (Avançado)';

  @override
  String get export_field_desc_garden_name => 'Nome do jardim';

  @override
  String get export_field_desc_garden_id => 'ID técnico único';

  @override
  String get export_field_desc_garden_surface => 'Superficie total do jardim';

  @override
  String get export_field_desc_garden_creation =>
      'Data de criação no aplicativo';

  @override
  String get export_field_desc_bed_name => 'Nome do canteiro';

  @override
  String get export_field_desc_bed_id => 'ID técnico único';

  @override
  String get export_field_desc_bed_surface => 'Superficie do canteiro';

  @override
  String get export_field_desc_bed_plant_count => 'Número de culturas atuais';

  @override
  String get export_field_desc_plant_name => 'Nome comum da planta';

  @override
  String get export_field_desc_plant_id => 'ID técnico único';

  @override
  String get export_field_desc_plant_scientific => 'Denominação botânica';

  @override
  String get export_field_desc_plant_family => 'Família botânica';

  @override
  String get export_field_desc_plant_variety => 'Variedade específica';

  @override
  String get export_field_desc_harvest_date => 'Data da colheita';

  @override
  String get export_field_desc_harvest_qty => 'Peso colhido em kg';

  @override
  String get export_field_desc_harvest_plant_name => 'Nome da planta colhida';

  @override
  String get export_field_desc_harvest_price => 'Preço por kg configurado';

  @override
  String get export_field_desc_harvest_value => 'Quantidade * Preço/kg';

  @override
  String get export_field_desc_harvest_notes => 'Observações da colheita';

  @override
  String get export_field_desc_harvest_garden_name =>
      'Nome do jardim de origem';

  @override
  String get export_field_desc_harvest_garden_id => 'ID único do jardim';

  @override
  String get export_field_desc_harvest_bed_name => 'Canteiro de origem';

  @override
  String get export_field_desc_harvest_bed_id => 'ID do canteiro';

  @override
  String get export_field_desc_activity_date => 'Data da atividade';

  @override
  String get export_field_desc_activity_type =>
      'Categoria da ação (Semeadura, Colheita, Cuidado...)';

  @override
  String get export_field_desc_activity_title => 'Resumo da ação';

  @override
  String get export_field_desc_activity_desc => 'Detalhes completos';

  @override
  String get export_field_desc_activity_entity =>
      'Nome do objeto afetado (Planta, Canteiro...)';

  @override
  String get export_field_desc_activity_entity_id => 'ID do objeto afetado';

  @override
  String get plant_catalog_sow => 'Semear';

  @override
  String get plant_catalog_plant => 'Plantar';

  @override
  String get plant_catalog_show_selection => 'Mostrar seleção';

  @override
  String get plant_catalog_filter_green_only => 'Apenas verdes';

  @override
  String get plant_catalog_filter_green_orange => 'Verdes + Laranjas';

  @override
  String get plant_catalog_filter_all => 'Todos';

  @override
  String get plant_catalog_no_recommended =>
      'Nenhuma planta recomendada para o período.';

  @override
  String get plant_catalog_expand_window => 'Expandir (±2 meses)';

  @override
  String get plant_catalog_missing_period_data => 'Dados do período em falta';

  @override
  String plant_catalog_periods_prefix(String months) {
    return 'Períodos: $months';
  }

  @override
  String get plant_catalog_legend_green => 'Pronto este mês';

  @override
  String get plant_catalog_legend_orange => 'Perto / Em breve';

  @override
  String get plant_catalog_legend_red => 'Fora de época';

  @override
  String get plant_catalog_data_unknown => 'Dados desconhecidos';

  @override
  String get task_editor_photo_label => 'Foto da tarefa';

  @override
  String get task_editor_photo_add => 'Adicionar foto';

  @override
  String get task_editor_photo_change => 'Alterar foto';

  @override
  String get task_editor_photo_remove => 'Remover foto';

  @override
  String get task_editor_photo_help =>
      'A foto será anexada automaticamente ao PDF ao criar / enviar.';

  @override
  String get export_block_nutrition => 'Nutrition (Agrégation)';

  @override
  String get export_block_desc_nutrition =>
      'Indicateurs nutritionnels agrégés par nutriment';

  @override
  String get export_field_nutrient_key => 'Chave nutriente';

  @override
  String get export_field_nutrient_label => 'Nutriente';

  @override
  String get export_field_nutrient_unit => 'Unidade';

  @override
  String get export_field_nutrient_total => 'Total disponível';

  @override
  String get export_field_mass_with_data_kg => 'Massa com dados (kg)';

  @override
  String get export_field_contributing_records => 'Nº Colheitas';

  @override
  String get export_field_data_confidence => 'Confiança';

  @override
  String get export_field_coverage_percent => 'Méd. DRI (%)';

  @override
  String get export_field_lower_bound_coverage => 'Min DRI (%)';

  @override
  String get export_field_upper_bound_coverage => 'Max DRI (%)';

  @override
  String get settings_garden_config_title => 'Configuração do Jardim';

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
  String get settings_last_frost_date_label => 'Última Geada (Primavera)';

  @override
  String get settings_last_frost_date_title => 'Data da Última Geada';

  @override
  String settings_status_estimated(String value) {
    return '$value (Estimado)';
  }

  @override
  String get settings_status_unknown => 'Desconhecido';

  @override
  String get settings_currency_label => 'Moeda';

  @override
  String get settings_currency_selector_title => 'Escolher moeda';

  @override
  String get settings_commune_search_placeholder_start =>
      'Digite o nome de uma cidade para começar.';

  @override
  String settings_commune_search_no_results(String query) {
    return 'Nenhum resultado para \"$query\".';
  }

  @override
  String get settings_zone_auto_recommended => 'Automático (Recomendado)';

  @override
  String get settings_date_auto => 'Automático';

  @override
  String get settings_reset_date_button => 'Redefinir data';

  @override
  String get settings_terms_subtitle => 'Termos e condições';

  @override
  String get language_italian => 'Italiano';

  @override
  String get zone_nh_temperate_europe =>
      'Temperado - Hemisfério Norte (Eurásia)';

  @override
  String get zone_nh_temperate_na => 'Temperado - América do Norte';

  @override
  String get zone_sh_temperate => 'Temperado - Hemisfério Sul';

  @override
  String get zone_mediterranean => 'Mediterrâneo';

  @override
  String get zone_tropical => 'Tropical';

  @override
  String get zone_arid => 'Árido / Desértico';

  @override
  String get stats_pillar_economy => 'ECONOMIA';

  @override
  String get stats_pillar_nutrition => 'NUTRIÇÃO';

  @override
  String get stats_pillar_export => 'EXPORTAÇÃO';

  @override
  String get stats_data_label => 'DADOS';

  @override
  String get stats_radar_vitamins => 'Vitaminas';

  @override
  String get stats_radar_minerals => 'Minerais';

  @override
  String get stats_radar_fibers => 'Fibras';

  @override
  String get stats_radar_proteins => 'Proteínas';

  @override
  String get stats_radar_energy => 'Energia';

  @override
  String get stats_radar_antiox => 'Antiox';

  @override
  String get custom_plant_new_title => 'Nova planta';

  @override
  String get custom_plant_edit_title => 'Editar planta';

  @override
  String get custom_plant_action_save_creation => 'Criar planta';

  @override
  String get custom_plant_action_save_modification => 'Salvar alterações';

  @override
  String get custom_plant_delete_confirm_title => 'Excluir planta?';

  @override
  String get custom_plant_delete_confirm_body => 'Esta ação é irreversível.';

  @override
  String get custom_plant_saved_success => 'Planta salva com sucesso';

  @override
  String get custom_plant_common_name_label => 'Nome comum *';

  @override
  String get custom_plant_common_name_required => 'Obrigatório';

  @override
  String get custom_plant_scientific_name_label => 'Nome científico';

  @override
  String get custom_plant_family_label => 'Família';

  @override
  String get custom_plant_description_label => 'Descrição';

  @override
  String get custom_plant_price_title => 'Preço';

  @override
  String custom_plant_price_label(String currency) {
    return 'Preço médio por Kg ($currency)';
  }

  @override
  String get custom_plant_price_hint => 'ex: 4.50';

  @override
  String get custom_plant_nutrition_title => 'Nutrição (por 100g)';

  @override
  String get custom_plant_nutrition_cal => 'Calorias';

  @override
  String get custom_plant_nutrition_prot => 'Proteínas';

  @override
  String get custom_plant_nutrition_carb => 'Carboidratos';

  @override
  String get custom_plant_nutrition_fat => 'Gorduras';

  @override
  String get custom_plant_notes_title => 'Notas & Associações';

  @override
  String get custom_plant_notes_label => 'Notas pessoais';

  @override
  String get custom_plant_notes_hint =>
      'Plantas companheiras, dicas de cultivo...';

  @override
  String get custom_plant_cycle_title => 'Ciclo de cultivo';

  @override
  String get custom_plant_sowing_period => 'Período de semeadura';

  @override
  String get custom_plant_harvest_period => 'Período de colheita';

  @override
  String get custom_plant_select_months => 'Selecione os meses abaixo';

  @override
  String get custom_plant_add_photo => 'Adicionar foto';

  @override
  String get custom_plant_delete_photo => 'Remover foto';

  @override
  String get custom_plant_pick_camera => 'Tirar foto';

  @override
  String get custom_plant_pick_gallery => 'Escolher da galeria';

  @override
  String custom_plant_pick_error(Object error) {
    return 'Erro ao selecionar imagem: $error';
  }

  @override
  String get garden_no_location => 'Sem local';

  @override
  String get export_filename_prefix => 'Exportação';

  @override
  String get export_field_desc_nutrient_key => 'Identificador técnico';

  @override
  String get export_field_desc_nutrient_label => 'Nome do nutriente';

  @override
  String get export_field_desc_nutrient_unit => 'Unidade de medida';

  @override
  String get export_field_desc_nutrient_total => 'Quantidade total calculada';

  @override
  String get export_field_desc_mass_with_data_kg =>
      'Massa total colheitas com dados';

  @override
  String get export_field_desc_contributing_records =>
      'Número de colheitas com dados';

  @override
  String get export_field_desc_data_confidence =>
      'Confiança (Massa com dados / Massa total)';

  @override
  String get export_field_desc_coverage_percent => 'Percentual cobertura DRI';

  @override
  String get export_field_desc_lower_bound_coverage =>
      'Estimativa baixa cobertura';

  @override
  String get export_field_desc_upper_bound_coverage =>
      'Estimativa alta cobertura';

  @override
  String get nutrition_inventory_title => 'Inventário Nutricional';

  @override
  String get nutrition_mode_interpretation => 'Interpretação';

  @override
  String get nutrition_mode_measure => 'Medida';

  @override
  String get calendar_mark_as_done => 'Marcar como feito';

  @override
  String get calendar_mark_as_todo => 'Marcar como a fazer';

  @override
  String get step_germination_title => 'Germinação esperada';

  @override
  String step_germination_desc(Object days) {
    return 'Aparecimento de rebentos (est. ~$days dias)';
  }

  @override
  String get step_watering_title => 'Rega recomendada';

  @override
  String get step_watering_desc_regular => 'Rega regular conforme necessário';

  @override
  String step_watering_desc_amount(Object amount) {
    return 'Quantidade: $amount';
  }

  @override
  String get step_thinning_title => 'Desbaste recomendado';

  @override
  String get step_thinning_desc_default => 'Desbastar para espaçamento ideal';

  @override
  String get step_weeding_title => 'Sacha recomendada';

  @override
  String get step_weeding_desc_regular => 'Sachar conforme necessário';

  @override
  String step_weeding_desc_freq(Object freq) {
    return 'Frequência: $freq';
  }

  @override
  String get step_harvest_estimated_title => 'Colheita estimada';

  @override
  String step_harvest_estimated_desc(Object days) {
    return 'Estimativa baseada em $days dias';
  }

  @override
  String get step_harvest_start_title => 'Início da colheita';

  @override
  String get step_harvest_start_desc => 'Início previsto da colheita';

  @override
  String get step_harvest_end_title => 'Fim da colheita';

  @override
  String get step_harvest_end_desc => 'Fim previsto da colheita';

  @override
  String get step_bio_control_title => 'Controlo biológico';

  @override
  String step_bio_control_prep_title(Object number) {
    return 'Preparação $number controlo bio';
  }

  @override
  String get step_add_step_title => 'Adicionar passo';

  @override
  String get step_dialog_title_label => 'Título';

  @override
  String get step_dialog_desc_label => 'Descrição';

  @override
  String get step_dialog_no_date => 'Sem data';

  @override
  String get step_dialog_pick_date => 'Selecionar data';

  @override
  String get common_add => 'Adicionar';

  @override
  String get common_done => 'Feito';

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
