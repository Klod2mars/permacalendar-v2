import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/calibration_state.dart';
import '../../screens/calibration_settings_screen.dart';
import '../../../../l10n/app_localizations.dart';

/// Section Calibration dans les paramètres
class CalibrationSettingsSection extends ConsumerWidget {
  const CalibrationSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibrationState = ref.watch(calibrationStateProvider);
    final l10n = AppLocalizations.of(context)!;

    // Calibration Organique Unifiée
    return _buildCalibrationTile(
      context: context,
      ref: ref,
      icon: Icons.auto_fix_high,
      title: l10n.calibration_organic_title,
      subtitle: l10n.calibration_organic_subtitle,
      isActive: calibrationState.activeType == CalibrationType.organic,
      onTap: () => _toggleOrganicCalibration(context, ref),
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.calibration_organic_disabled),
          backgroundColor: Colors.grey,
        ),
      );
    } else {
      ref.read(calibrationStateProvider.notifier).enableOrganicCalibration();
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              l10n.calibration_organic_enabled),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      context.go('/');
    }
  }
}
