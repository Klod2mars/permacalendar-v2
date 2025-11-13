import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/calibration_state.dart';
import '../../screens/calibration_settings_screen.dart';

/// Section Calibration dans les paramètres
class CalibrationSettingsSection extends ConsumerWidget {
  const CalibrationSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibrationState = ref.watch(calibrationStateProvider);
    final isCalibrating = calibrationState.activeType != CalibrationType.none;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.tune, color: Colors.green),
                const SizedBox(width: 12),
                Text(
                  'Calibration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Personnalisez l\'affichage de votre dashboard',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const Divider(height: 32),

            // Calibration Organique Unifiée
            _buildCalibrationTile(
              context: context,
              ref: ref,
              icon: Icons.auto_fix_high,
              title: 'Calibration Organique',
              subtitle: 'Activer le mode unifié pour ajuster les zones',
              isActive: calibrationState.activeType == CalibrationType.organic,
              onTap: () => _toggleOrganicCalibration(context, ref),
            ),

            const SizedBox(height: 16),

            // Gestion des profils de calibration
            ListTile(
              leading: const Icon(Icons.tune, color: Colors.green),
              title: const Text('Calibration organique'),
              subtitle: const Text(
                  'Ajuster et gérer les profils de calibration par appareil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const CalibrationSettingsScreen()),
                );
              },
            ),

            // Message d'avertissement si calibration active
            if (isCalibrating) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Mode calibration actif. Retournez au dashboard pour ajuster.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationTile({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.green : Colors.grey.withOpacity(0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isActive ? Icons.check_circle : Icons.arrow_forward_ios,
              color: isActive ? Colors.green : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleOrganicCalibration(BuildContext context, WidgetRef ref) {
    final calibrationState = ref.read(calibrationStateProvider);
    if (calibrationState.activeType == CalibrationType.organic) {
      ref.read(calibrationStateProvider.notifier).disableCalibration();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ðŸŒ¿ Calibration organique désactivée'),
          backgroundColor: Colors.grey,
        ),
      );
    } else {
      ref.read(calibrationStateProvider.notifier).enableOrganicCalibration();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'ðŸŒ¿ Mode calibration organique activé. Retournez au dashboard.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      context.go('/');
    }
  }
}


