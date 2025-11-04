import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_alert.dart';
import '../providers/notification_providers.dart';

/// Écran de configuration des préférences de notification
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(notificationPreferencesProvider);
    final preferencesNotifier =
        ref.watch(notificationPreferencesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Préférences de Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Réinitialiser par défaut',
            onPressed: () async {
              await preferencesNotifier.resetToDefaults();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Préférences réinitialisées'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: preferencesAsync.when(
        data: (preferences) => _buildPreferencesContent(
          context,
          ref,
          preferences,
          preferencesNotifier,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesContent(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> preferences,
    NotificationPreferencesNotifier notifier,
  ) {
    final enabled = preferences['enabled'] as bool? ?? true;
    final types = preferences['types'] as Map<String, dynamic>? ?? {};
    final priorities = preferences['priorities'] as Map<String, dynamic>? ?? {};
    final soundEnabled = preferences['soundEnabled'] as bool? ?? true;
    final vibrationEnabled = preferences['vibrationEnabled'] as bool? ?? true;

    return ListView(
      children: [
        // Section principale
        _buildSection(
          context,
          title: '🔔 Activation',
          children: [
            SwitchListTile(
              title: const Text('Notifications activées'),
              subtitle:
                  const Text('Activer ou désactiver toutes les notifications'),
              value: enabled,
              onChanged: (value) async {
                await notifier.setEnabled(value);
              },
            ),
          ],
        ),

        const Divider(height: 32),

        // Types de notifications
        _buildSection(
          context,
          title: '📋 Types de Notifications',
          children: [
            _buildTypeSwitch(
              context,
              notifier,
              enabled: enabled,
              type: NotificationType.weatherAlert,
              title: 'Alertes Météo',
              subtitle: 'Gel, chaleur, sécheresse, vent fort',
              icon: Icons.wb_sunny,
              value: types['weatherAlert'] as bool? ?? true,
            ),
            _buildTypeSwitch(
              context,
              notifier,
              enabled: enabled,
              type: NotificationType.criticalCondition,
              title: 'Conditions Critiques',
              subtitle: 'Plantes en situation critique',
              icon: Icons.warning,
              value: types['criticalCondition'] as bool? ?? true,
            ),
            _buildTypeSwitch(
              context,
              notifier,
              enabled: enabled,
              type: NotificationType.recommendation,
              title: 'Recommandations',
              subtitle: 'Actions suggérées pour vos plantes',
              icon: Icons.lightbulb,
              value: types['recommendation'] as bool? ?? true,
            ),
            _buildTypeSwitch(
              context,
              notifier,
              enabled: enabled,
              type: NotificationType.plantCondition,
              title: 'État des Plantes',
              subtitle: 'Changements dans l\'état de santé',
              icon: Icons.spa,
              value: types['plantCondition'] as bool? ?? true,
            ),
            _buildTypeSwitch(
              context,
              notifier,
              enabled: enabled,
              type: NotificationType.optimalCondition,
              title: 'Conditions Optimales',
              subtitle: 'Moment idéal pour planter',
              icon: Icons.wb_sunny_outlined,
              value: types['optimalCondition'] as bool? ?? false,
            ),
            _buildTypeSwitch(
              context,
              notifier,
              enabled: enabled,
              type: NotificationType.reminder,
              title: 'Rappels',
              subtitle: 'Rappels d\'actions à effectuer',
              icon: Icons.alarm,
              value: types['reminder'] as bool? ?? true,
            ),
          ],
        ),

        const Divider(height: 32),

        // Paramètres supplémentaires
        _buildSection(
          context,
          title: '⚙️ Paramètres',
          children: [
            SwitchListTile(
              title: const Text('Son'),
              subtitle: const Text('Jouer un son lors des notifications'),
              secondary: const Icon(Icons.volume_up),
              value: soundEnabled,
              onChanged: enabled
                  ? (value) async {
                      final updatedPrefs =
                          Map<String, dynamic>.from(preferences);
                      updatedPrefs['soundEnabled'] = value;
                      await notifier.updatePreferences(updatedPrefs);
                    }
                  : null,
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              subtitle: const Text('Vibrer lors des notifications importantes'),
              secondary: const Icon(Icons.vibration),
              value: vibrationEnabled,
              onChanged: enabled
                  ? (value) async {
                      final updatedPrefs =
                          Map<String, dynamic>.from(preferences);
                      updatedPrefs['vibrationEnabled'] = value;
                      await notifier.updatePreferences(updatedPrefs);
                    }
                  : null,
            ),
          ],
        ),

        const Divider(height: 32),

        // Statistiques
        _buildStatisticsSection(context, ref),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTypeSwitch(
    BuildContext context,
    NotificationPreferencesNotifier notifier, {
    required bool enabled,
    required NotificationType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon),
      value: value,
      onChanged: enabled
          ? (newValue) async {
              await notifier.setTypeEnabled(type, newValue);
            }
          : null,
    );
  }

  Widget _buildStatisticsSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(notificationStatsProvider);

    return statsAsync.when(
      data: (stats) {
        final total = stats['total'] as int? ?? 0;
        final unread = stats['unread'] as int? ?? 0;
        final active = stats['active'] as int? ?? 0;
        final criticalCount = stats['criticalCount'] as int? ?? 0;
        final urgentCount = stats['urgentCount'] as int? ?? 0;

        return _buildSection(
          context,
          title: '📊 Statistiques',
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Total de notifications'),
              trailing: Text(
                total.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.markunread),
              title: const Text('Non lues'),
              trailing: Text(
                unread.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: unread > 0 ? Colors.orange : null,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notification_important),
              title: const Text('Actives'),
              trailing: Text(
                active.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (criticalCount > 0)
              ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text('Critiques'),
                trailing: Text(
                  criticalCount.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            if (urgentCount > 0)
              ListTile(
                leading: const Icon(Icons.priority_high, color: Colors.orange),
                title: const Text('Urgentes'),
                trailing: Text(
                  urgentCount.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.orange,
                      ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
