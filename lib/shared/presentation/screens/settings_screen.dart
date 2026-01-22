// lib/shared/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // pour debugPrint
import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/environment_service.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/dialogs.dart';
import '../../../app_router.dart';
import '../../../features/weather/providers/commune_provider.dart';
import '../../../core/services/open_meteo_service.dart';
import '../widgets/settings/calibration_settings_section.dart';
import '../widgets/settings/backup_restore_section.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../features/climate/data/commune_storage.dart';
import '../../../features/settings/presentation/screens/language_settings_page.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.settings_title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildAppInfoSection(context, theme),
          const SizedBox(height: 24),
          _buildDisplaySection(context, theme, ref),
          const SizedBox(height: 24),
          _buildScientificToolsSection(context, theme, ref),
          const SizedBox(height: 24),
          _buildQuickAccessSection(context, theme),
          const SizedBox(height: 24),
          const CalibrationSettingsSection(),
          const SizedBox(height: 24),
          const BackupRestoreSection(),
          const SizedBox(height: 24),
          _buildAboutSection(context, theme),
        ]),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_application,
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settings_version),
            subtitle: const Text(AppConstants.appVersion),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showVersionInfo(context),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildDisplaySection(
      BuildContext context, ThemeData theme, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_display,
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language_title),
            subtitle: const Text('Français, English, Español...'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LanguageSettingsPage(),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildQuickAccessSection(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_quick_access,
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(l10n.settings_plants_catalog),
            subtitle: Text(l10n.settings_plants_catalog_subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.plants),
          ),
        ]),
      ),
    ]);
  }



  Widget _buildScientificToolsSection(
      BuildContext context, ThemeData theme, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_weather_selector,
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          Builder(builder: (ctx) {
            final selected = ref.watch(selectedCommuneProvider);
            final defaultLabel = EnvironmentService.defaultCommuneName;
            final subtitle = selected == null
                ? l10n.settings_commune_default(defaultLabel)
                : l10n.settings_commune_selected(selected);
            return ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(l10n.settings_commune_title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showCommuneSelector(context, ref),
            );
          }),
        ]),
      ),
    ]);
  }

  void _showCommuneSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalCtx) {
        String query = '';
        List<PlaceSuggestion> results = const [];
        bool loading = false;
        final svc = OpenMeteoService.instance;

        Future<void> performSearch(
            String q, void Function(void Function()) setState) async {
          setState(() => loading = true);
          try {
            final r = await svc.searchPlaces(q, count: 12);
            setState(() => results = r);
          } finally {
            setState(() => loading = false);
          }
        }

        return StatefulBuilder(builder: (sbCtx, setState) {
          final l10n = AppLocalizations.of(context)!;
          final theme = Theme.of(sbCtx);
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(sbCtx).viewInsets.bottom,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settings_choose_commune,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.settings_search_commune_hint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      query = v;
                      if (query.trim().isEmpty) {
                        setState(() => results = const []);
                      } else {
                        performSearch(query, setState);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (loading) const LinearProgressIndicator(),
                  Flexible(
                    child: results.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              query.isEmpty
                                  ? 'Saisissez un nom de commune pour commencer.'
                                  : 'Aucun résultat pour "$query".',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.outline),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final p = results[i];
                              final subtitle = [p.admin1, p.country]
                                  .where((s) => s.isNotEmpty)
                                  .join(' • ');
                              return ListTile(
                                leading: const Icon(Icons.place),
                                title: Text(p.name),
                                subtitle: Text(subtitle),
                                onTap: () async {
                                  // Mettre à jour le provider existant (nom)
                                  await ref
                                      .read(selectedCommuneProvider.notifier)
                                      .setCommune(p.name);

                                  // Synchroniser AppSettings pour que les providers météo détectent le changement
                                  await ref
                                      .read(appSettingsProvider.notifier)
                                      .setSelectedCommune(p.name);


                                  // Tenter de résoudre les coordonnées et les persister
                                  // PATCH: On utilise directement les coordonnées de la suggestion
                                  // au lieu de relancer une recherche par nom.
                                  try {
                                    await ref
                                        .read(appSettingsProvider.notifier)
                                        .setLastCoordinates(
                                            p.latitude, p.longitude);
                                    await CommuneStorage.saveCommune(
                                        p.name, p.latitude, p.longitude);

                                    try {
                                      // Forcer Riverpod à relire la commune persistée et à rafraîchir la météo
                                      ref.invalidate(persistedCoordinatesProvider);
                                      ref.invalidate(currentWeatherProvider);
                                    } catch (e, st) {
                                      // Ne pas bloquer l'expérience utilisateur en cas d'erreur d'invalidation.
                                      // Log en debug pour faciliter le diagnostic.
                                      debugPrint(
                                          'Failed to invalidate weather providers after commune save: $e\n$st');
                                    }
                                  } catch (_) {
                                    // Ne pas bloquer l'expérience
                                  }

                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Commune sélectionnée: ${p.name}')),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ]),
          );
        });
      },
    );
  }

  Widget _buildAboutSection(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_about,
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.settings_user_guide),
            subtitle: Text(l10n.settings_user_guide_subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelp(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settings_privacy),
            subtitle: Text(l10n.settings_privacy_policy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.settings_terms),
            subtitle: const Text('Termes et conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(context),
          ),
        ]),
      ),
    ]);
  }

  void _showVersionInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_version_dialog_title,
        content: l10n.settings_version_dialog_content("1.2"),
      ),
    );
  }



  void _showHelp(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_user_guide,
        content: l10n.user_guide_text,
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_privacy_policy,
        content: l10n.privacy_policy_text,
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_terms,
        content: l10n.terms_text,
      ),
    );
  }
}
