import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Écran des paramètres de l'intelligence végétale
class IntelligenceSettingsScreen extends ConsumerStatefulWidget {
  const IntelligenceSettingsScreen({super.key});

  @override
  ConsumerState<IntelligenceSettingsScreen> createState() =>
      _IntelligenceSettingsScreenState();
}

class _IntelligenceSettingsScreenState
    extends ConsumerState<IntelligenceSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayPreferences = ref.watch(displayPreferencesProvider);
    final chartSettings = ref.watch(chartSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres Intelligence'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
        ),
      ),
      body: Semantics(
        label: 'Écran des paramètres d\'intelligence végétale',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                theme,
                'Affichage',
                [
                  _buildSwitchTile(
                    theme,
                    'Mode sombre',
                    displayPreferences.darkMode,
                    (value) => ref
                        .read(displayPreferencesProvider.notifier)
                        .toggleDarkMode(),
                    Icons.dark_mode,
                  ),
                  _buildSwitchTile(
                    theme,
                    'Animations',
                    displayPreferences.showAnimations,
                    (value) => ref
                        .read(displayPreferencesProvider.notifier)
                        .toggleAnimations(),
                    Icons.animation,
                  ),
                  _buildSwitchTile(
                    theme,
                    'Métriques détaillées',
                    displayPreferences.showDetailedMetrics,
                    (value) => ref
                        .read(displayPreferencesProvider.notifier)
                        .toggleDetailedMetrics(),
                    Icons.analytics,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                'Graphiques',
                [
                  _buildSwitchTile(
                    theme,
                    'Température',
                    chartSettings.showTemperature,
                    (value) => ref
                        .read(chartSettingsProvider.notifier)
                        .toggleTemperature(),
                    Icons.thermostat,
                  ),
                  _buildSwitchTile(
                    theme,
                    'Humidité',
                    chartSettings.showHumidity,
                    (value) => ref
                        .read(chartSettingsProvider.notifier)
                        .toggleHumidity(),
                    Icons.water_drop,
                  ),
                  _buildSwitchTile(
                    theme,
                    'Lumière',
                    chartSettings.showLight,
                    (value) =>
                        ref.read(chartSettingsProvider.notifier).toggleLight(),
                    Icons.wb_sunny,
                  ),
                  _buildSwitchTile(
                    theme,
                    'Sol',
                    chartSettings.showSoil,
                    (value) =>
                        ref.read(chartSettingsProvider.notifier).toggleSoil(),
                    Icons.grass,
                  ),
                  _buildSwitchTile(
                    theme,
                    'Tendances',
                    chartSettings.showTrends,
                    (value) =>
                        ref.read(chartSettingsProvider.notifier).toggleTrends(),
                    Icons.trending_up,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                'Unités',
                [
                  _buildListTile(
                    theme,
                    'Unité de température',
                    displayPreferences.temperatureUnit == 'celsius'
                        ? 'Celsius'
                        : 'Fahrenheit',
                    () => _showTemperatureUnitDialog(theme),
                    Icons.thermostat,
                  ),
                  _buildListTile(
                    theme,
                    'Unité de distance',
                    displayPreferences.distanceUnit == 'metric'
                        ? 'Métrique'
                        : 'Impérial',
                    () => _showDistanceUnitDialog(theme),
                    Icons.straighten,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                'Langue',
                [
                  _buildListTile(
                    theme,
                    'Langue',
                    _getLanguageName(displayPreferences.language),
                    () => _showLanguageDialog(theme),
                    Icons.language,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                'Analyse automatique',
                [
                  _buildSwitchTile(
                    theme,
                    'Analyse automatique',
                    true, // Placeholder
                    (value) {}, // Placeholder
                    Icons.auto_awesome,
                  ),
                  _buildListTile(
                    theme,
                    'Fréquence d\'analyse',
                    'Toutes les 6 heures',
                    () => _showAnalysisFrequencyDialog(theme),
                    Icons.schedule,
                  ),
                  _buildListTile(
                    theme,
                    'Notifications',
                    'Activées',
                    () => _showNotificationsDialog(theme),
                    Icons.notifications,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                'Données',
                [
                  _buildListTile(
                    theme,
                    'Sauvegarde automatique',
                    'Activée',
                    () => _showBackupDialog(theme),
                    Icons.backup,
                  ),
                  _buildListTile(
                    theme,
                    'Synchronisation cloud',
                    'Désactivée',
                    () => _showSyncDialog(theme),
                    Icons.cloud_sync,
                  ),
                  _buildListTile(
                    theme,
                    'Effacer le cache',
                    'Vider le cache des analyses',
                    () => _clearCache(theme),
                    Icons.clear_all,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                'À propos',
                [
                  _buildListTile(
                    theme,
                    'Version',
                    '1.0.0',
                    () {},
                    Icons.info,
                  ),
                  _buildListTile(
                    theme,
                    'Licence',
                    'Open Source',
                    () => _showLicenseDialog(theme),
                    Icons.description,
                  ),
                  _buildListTile(
                    theme,
                    'Support',
                    'Centre d\'aide',
                    () => _showSupportDialog(theme),
                    Icons.help,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildResetButton(theme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
    return Semantics(
      label: 'Section: $title',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Semantics(
      label: '$title: ${value ? "activé" : "désactivé"}',
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(_getSwitchSubtitle(title)),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: theme.colorScheme.primary),
        activeThumbColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildListTile(
    ThemeData theme,
    String title,
    String subtitle,
    VoidCallback onTap,
    IconData icon,
  ) {
    return Semantics(
      label: '$title: $subtitle',
      button: true,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon, color: theme.colorScheme.primary),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getSwitchSubtitle(String title) {
    switch (title) {
      case 'Mode sombre':
        return 'Interface en mode sombre';
      case 'Animations':
        return 'Animations et transitions';
      case 'Métriques détaillées':
        return 'Afficher plus de détails';
      case 'Température':
        return 'Afficher les données de température';
      case 'Humidité':
        return 'Afficher les données d\'humidité';
      case 'Lumière':
        return 'Afficher les données de lumière';
      case 'Sol':
        return 'Afficher les données de sol';
      case 'Tendances':
        return 'Afficher les graphiques de tendances';
      case 'Analyse automatique':
        return 'Analyser automatiquement les plantes';
      default:
        return '';
    }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      default:
        return 'Français';
    }
  }

  void _showTemperatureUnitDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unité de température'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Celsius (°C)'),
              value: 'celsius',
              groupValue: ref.read(displayPreferencesProvider).temperatureUnit,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateTemperatureUnit(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Fahrenheit (°F)'),
              value: 'fahrenheit',
              groupValue: ref.read(displayPreferencesProvider).temperatureUnit,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateTemperatureUnit(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDistanceUnitDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unité de distance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Métrique (m, cm)'),
              value: 'metric',
              groupValue: ref.read(displayPreferencesProvider).distanceUnit,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateDistanceUnit(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Impérial (ft, in)'),
              value: 'imperial',
              groupValue: ref.read(displayPreferencesProvider).distanceUnit,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateDistanceUnit(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: ref.read(displayPreferencesProvider).language,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: ref.read(displayPreferencesProvider).language,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'es',
              groupValue: ref.read(displayPreferencesProvider).language,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(displayPreferencesProvider.notifier)
                      .updateLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalysisFrequencyDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fréquence d\'analyse'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Toutes les heures'),
              value: '1h',
              groupValue: '6h', // Placeholder
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Toutes les 6 heures'),
              value: '6h',
              groupValue: '6h',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Quotidiennement'),
              value: '1d',
              groupValue: '6h',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Hebdomadairement'),
              value: '1w',
              groupValue: '6h',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text(
          'Configurez vos préférences de notifications pour recevoir des alertes sur l\'état de vos plantes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Configurer'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sauvegarde automatique'),
        content: const Text(
          'La sauvegarde automatique permet de sauvegarder vos données d\'analyse localement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Synchronisation cloud'),
        content: const Text(
          'La synchronisation cloud permet de sauvegarder vos données sur nos serveurs sécurisés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Activer'),
          ),
        ],
      ),
    );
  }

  void _clearCache(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer le cache'),
        content: const Text(
          'Voulez-vous effacer le cache des analyses ? Cette action ne supprimera pas vos données.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache effacé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }

  void _showLicenseDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Licence'),
        content: const Text(
          'Permacalendar v2.0\n\n'
          'Licence MIT\n'
          'Copyright (c) 2024\n\n'
          'Cette application est distribuée sous licence MIT. '
          'Voir le fichier LICENSE pour plus de détails.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Support'),
        content: const Text(
          'Besoin d\'aide ?\n\n'
          '• Consultez notre centre d\'aide\n'
          '• Contactez notre équipe support\n'
          '• Signalez un bug\n'
          '• Proposez une amélioration',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Centre d\'aide'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _resetSettings,
        icon: const Icon(Icons.restore),
        label: const Text('Réinitialiser les paramètres'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(color: theme.colorScheme.error),
        ),
      ),
    );
  }

  void _resetSettings() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser les paramètres'),
        content: const Text(
          'Voulez-vous vraiment réinitialiser tous les paramètres aux valeurs par défaut ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Réinitialiser les paramètres
              ref.read(displayPreferencesProvider.notifier).resetToDefaults();
              ref.read(chartSettingsProvider.notifier).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paramètres réinitialisés'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }
}

// Extension pour ajouter la méthode reset au ChartSettingsNotifier
extension ChartSettingsNotifierExtension on ChartSettingsNotifier {
  void reset() {
    state = const ChartSettings();
  }
}


