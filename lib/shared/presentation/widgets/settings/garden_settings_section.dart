import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/services/environment_service.dart';
import '../../../../core/utils/constants.dart';
import 'settings_group.dart';
import 'settings_tile.dart';

/// Garden settings section
///
/// Contains garden-related settings including calibration mode toggle.
/// This section provides access to garden management features and calibration controls.
class GardenSettingsSection extends ConsumerWidget {
  const GardenSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return SettingsGroup(
      title: 'Jardins',
      description: 'Configuration des jardins et calibration des positions',
      children: [
        SettingsTile.simple(
          leading: Icons.eco,
          title: 'Limite de jardins',
          subtitle: 'Maximum ${AppConstants.maxGardensPerUser} jardins',
          trailing: const Icon(Icons.info_outline),
          onTap: () => _showGardenLimitInfo(context),
        ),
        SettingsTile.simple(
          leading: Icons.eco,
          title: 'Validation des plantations',
          subtitle: 'Vérification automatique des dates',
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
    );
  }

  void _showGardenLimitInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limite de jardins'),
        content: const Text(
          'Cette version permet de gérer jusqu\'à ${AppConstants.maxGardensPerUser} jardins simultanément. '
          'Cette limite assure des performances optimales et une expérience utilisateur fluide.',
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
}


