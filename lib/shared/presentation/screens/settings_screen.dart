ï»¿import 'package:flutter/material.dart';
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


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Paramètres',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Information
            _buildAppInfoSection(context, theme),
            const SizedBox(height: 24),

            // Garden Settings
            _buildGardenSettingsSection(context, theme),
            const SizedBox(height: 24),

            // Scientific Tools Settings
            _buildScientificToolsSection(context, theme, ref),
            const SizedBox(height: 24),

            // Quick Access to features
            _buildQuickAccessSection(context, theme),
            const SizedBox(height: 24),

            // Data Management
            _buildDataManagementSection(context, theme),
            const SizedBox(height: 24),

            // About
            
            // Calibration (nouveau)
            const CalibrationSettingsSection(),
            const SizedBox(height: 24),
_buildAboutSection(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: const Text(AppConstants.appVersion),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showVersionInfo(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: const Text('Mode debug'),
                subtitle: Text(
                    EnvironmentService.isDebugMode ? 'Activé' : 'Désactivé'),
                trailing: Icon(
                  EnvironmentService.isDebugMode
                      ? Icons.toggle_on
                      : Icons.toggle_off,
                  color: EnvironmentService.isDebugMode
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accès rapide',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Catalogue des plantes'),
                subtitle: const Text('Rechercher et consulter les plantes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.plants),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Exporter les données'),
                subtitle: const Text('CSV, JSON, PDF'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.export),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGardenSettingsSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jardins',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.eco),
                title: const Text('Limite de jardins'),
                subtitle: const Text(
                    'Maximum ${AppConstants.maxGardensPerUser} jardins'),
                trailing: const Icon(Icons.info_outline),
                onTap: () => _showGardenLimitInfo(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.eco),
                title: const Text('Validation des plantations'),
                subtitle: const Text('Vérification automatique des dates'),
                trailing: Icon(
                  EnvironmentService.isGardenValidationEnabled
                      ? Icons.toggle_on
                      : Icons.toggle_off,
                  color: EnvironmentService.isGardenValidationEnabled
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScientificToolsSection(
      BuildContext context, ThemeData theme, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Outils scientifiques',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud),
                title: const Text('Données météo'),
                subtitle: Text(EnvironmentService.isWeatherEnabled
                    ? 'Activées'
                    : 'Désactivées'),
                trailing: Icon(
                  EnvironmentService.isWeatherEnabled
                      ? Icons.toggle_on
                      : Icons.toggle_off,
                  color: EnvironmentService.isWeatherEnabled
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              const Divider(height: 1),
              Builder(builder: (ctx) {
                final selected = ref.watch(selectedCommuneProvider);
                final defaultLabel = EnvironmentService.defaultCommuneName;
                final subtitle = selected == null
                    ? 'Défaut: $defaultLabel'
                    : 'Sélectionnée: $selected';
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: const Text('Commune pour la météo'),
                  subtitle: Text(subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCommuneSelector(context, ref),
                );
              }),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Analyses avancées'),
                subtitle: Text(EnvironmentService.isAnalyticsEnabled
                    ? 'Activées'
                    : 'Désactivées'),
                trailing: Icon(
                  EnvironmentService.isAnalyticsEnabled
                      ? Icons.toggle_on
                      : Icons.toggle_off,
                  color: EnvironmentService.isAnalyticsEnabled
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export de données'),
                subtitle: const Text('CSV, JSON, PDF disponibles'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showExportInfo(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCommuneSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        String query = '';
        List<PlaceSuggestion> results = const [];
        bool loading = false;
        final theme = Theme.of(ctx);
        final svc = OpenMeteoService.instance;

        Future<void> performSearch(
            String q, void Function(void Function()) setState) async {
          setState(() {
            loading = true;
          });
          try {
            final r = await svc.searchPlaces(q, count: 12);
            setState(() {
              results = r;
            });
          } finally {
            setState(() {
              loading = false;
            });
          }
        }

        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisir une commune',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une commune…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      query = v;
                      if (query.trim().isEmpty) {
                        setState(() => results = const []);
                      } else {
                        // Pas de debounce raffiné ici; simple appel
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
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
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
                                  await ref
                                      .read(selectedCommuneProvider.notifier)
                                      .setCommune(p.name);
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDataManagementSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestion des données',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Sauvegarde'),
                subtitle: const Text('Exporter toutes les données'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showBackupOptions(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Restauration'),
                subtitle: const Text('Importer des données'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showRestoreOptions(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading:
                    Icon(Icons.delete_forever, color: theme.colorScheme.error),
                title: Text('Effacer toutes les données',
                    style: TextStyle(color: theme.colorScheme.error)),
                subtitle: const Text('Action irréversible'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDeleteAllDataDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'À propos',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Aide'),
                subtitle: const Text('Guide d\'utilisation'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showHelp(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Confidentialité'),
                subtitle: const Text('Politique de confidentialité'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPrivacyPolicy(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.gavel_outlined),
                title: const Text('Conditions d\'utilisation'),
                subtitle: const Text('Termes et conditions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTermsOfService(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showVersionInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Version de l\'application',
        content: 'Version: ${AppConstants.appVersion}\n\n'
            'Build: ${AppConstants.buildNumber}\n\n'
            'PermaCalendar 2.0 - Gestion de jardins permaculturels',
      ),
    );
  }

  void _showGardenLimitInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Limite de jardins',
        content:
            'Cette version permet de gérer jusqu\'à ${AppConstants.maxGardensPerUser} jardins simultanément. '
            'Cette limite assure des performances optimales et une expérience utilisateur fluide.',
      ),
    );
  }

  void _showExportInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Export de données',
        content: 'Vous pouvez exporter vos données dans plusieurs formats :\n\n'
            '• CSV : Pour les tableurs\n'
            '• JSON : Pour les développeurs\n'
            '• PDF : Pour l\'impression\n\n'
            'Accédez à cette fonctionnalité via le menu "Exporter" du tableau de bord.',
      ),
    );
  }

  void _showBackupOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Sauvegarde',
        content:
            'La fonctionnalité de sauvegarde sera disponible dans une prochaine version. '
            'En attendant, vous pouvez utiliser l\'export de données pour sauvegarder vos informations.',
      ),
    );
  }

  void _showRestoreOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Restauration',
        content:
            'La fonctionnalité de restauration sera disponible dans une prochaine version.',
      ),
    );
  }

  void _showDeleteAllDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Effacer toutes les données',
        content:
            'Cette action supprimera définitivement tous vos jardins, plantations et données. '
            'Cette action est irréversible.\n\n'
            'ÃŠtes-vous sûr de vouloir continuer ?',
        confirmText: 'Effacer',
        cancelText: 'Annuler',
        isDestructive: true,
        onConfirm: () {
          // TODO: Implement data deletion
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fonctionnalité à implémenter'),
            ),
          );
        },
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Aide',
        content:
            'PermaCalendar 2.0 vous aide à gérer vos jardins permaculturels.\n\n'
            'Fonctionnalités principales :\n'
            '• Gestion de jardins et parcelles\n'
            '• Catalogue de plantes\n'
            '• Suivi des plantations\n'
            '• Outils scientifiques\n'
            '• Export de données\n\n'
            'Pour plus d\'informations, consultez la documentation en ligne.',
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Politique de confidentialité',
        content: 'PermaCalendar 2.0 respecte votre vie privée.\n\n'
            '• Toutes les données sont stockées localement sur votre appareil\n'
            '• Aucune donnée personnelle n\'est transmise à des tiers\n'
            '• Les fonctionnalités sociales sont désactivées par défaut\n'
            '• Vous contrôlez entièrement vos données\n\n'
            'Cette application fonctionne entièrement hors ligne.',
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(
        title: 'Conditions d\'utilisation',
        content: 'En utilisant PermaCalendar 2.0, vous acceptez :\n\n'
            '• D\'utiliser l\'application de manière responsable\n'
            '• De ne pas tenter de contourner les limitations\n'
            '• De respecter les droits de propriété intellectuelle\n'
            '• D\'utiliser vos propres données\n\n'
            'Cette application est fournie "en l\'état" sans garantie.',
      ),
    );
  }
}


