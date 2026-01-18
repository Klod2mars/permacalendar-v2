// lib/shared/presentation/screens/calibration_settings_screen.dart

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/device_calibration_key.dart';
import '../../../core/utils/calibration_storage.dart';
import '../../../core/providers/organic_zones_provider.dart';
import '../../../core/models/calibration_state.dart';
import '../../../features/home/presentation/providers/dashboard_image_settings_provider.dart'; // [NEW]
import '../../../app_router.dart';
import '../../../l10n/app_localizations.dart';

class CalibrationSettingsScreen extends ConsumerStatefulWidget {
  const CalibrationSettingsScreen({super.key});

  @override
  ConsumerState<CalibrationSettingsScreen> createState() =>
      _CalibrationSettingsScreenState();
}

class _CalibrationSettingsScreenState
    extends ConsumerState<CalibrationSettingsScreen> {
  bool _autoApply = false;

  String? _currentKey;

  Map<String, dynamic>? _currentProfile;

  @override
  void initState() {
    super.initState();

    _loadAutoApply();

    _refreshCurrentProfile();
  }

  Future<void> _loadAutoApply() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _autoApply = prefs.getBool('calibration_auto_apply') ?? false;
    });
  }

  Future<void> _toggleAutoApply(bool v) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('calibration_auto_apply', v);

    setState(() {
      _autoApply = v;
    });
  }

  Future<void> _refreshCurrentProfile() async {
    final key = await deviceCalibrationKey(context);

    final profile = await CalibrationStorage.loadProfile(key);

    setState(() {
      _currentKey = key;

      _currentProfile = profile;
    });
  }

  Future<void> _exportCurrentProfile() async {
    await _refreshCurrentProfile();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (_currentProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.calibration_snack_no_profile)));

      return;
    }

    final json = CalibrationStorage.exportProfile(_currentProfile!);

    await Clipboard.setData(ClipboardData(text: json));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.calibration_snack_profile_copied)));
  }

  Future<void> _importProfileFromClipboard() async {
    final clip = await Clipboard.getData('text/plain');
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final text = clip?.text ?? '';

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.calibration_snack_clipboard_empty)));

      return;
    }

    try {
      final Map<String, dynamic> profile =
          CalibrationStorage.importProfile(text);

      if (!mounted) return;
      final key = await deviceCalibrationKey(context);

      await CalibrationStorage.saveProfile(key, profile);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.calibration_snack_profile_imported)));

      await _refreshCurrentProfile();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.calibration_snack_import_error(e.toString()))));
    }
  }

  Future<void> _resetProfileForDevice() async {
    final key = await deviceCalibrationKey(context);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    await CalibrationStorage.deleteProfile(key);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.calibration_snack_profile_deleted)));

    await _refreshCurrentProfile();
  }

  Future<void> _saveCurrentCalibrationAsProfile() async {
    try {
      final zones = ref.read(organicZonesProvider);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;

      if (zones.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  l10n.calibration_snack_no_calibration)),
        );

        return;
      }

      // Convert current zones state to profile format

      final profile = <String, Map<String, dynamic>>{};

      zones.forEach((zoneId, config) {
        profile[zoneId] = {
          'x': config.position.dx,
          'y': config.position.dy,
          'size': config.size,
          'enabled': config.enabled,
        };
      });

      final key = await deviceCalibrationKey(context);

      await CalibrationStorage.saveProfile(key, profile);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                l10n.calibration_snack_saved_as_profile)),
      );

      await _refreshCurrentProfile();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.calibration_snack_save_error(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calibration_organic_title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(l10n.calibration_auto_apply),
              value: _autoApply,
              onChanged: _toggleAutoApply,
            ),
            const Divider(),
            _buildImageSettingsControls(ref, context),
            const Divider(),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.tune),
              label: Text(l10n.calibration_calibrate_now),
              onPressed: () {
                // 1) Activer le mode calibration organique
                ref
                    .read(calibrationStateProvider.notifier)
                    .enableOrganicCalibration();

                // 2) Naviguer vers l'accueil (dashboard) qui lira le provider et affichera l'overlay
                // Nous utilisons GoRouter afin de garantir l'affichage de HomeScreen (qui prend en compte calibrationStateProvider)
                context.go(AppRoutes.home);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label:
                  Text(l10n.calibration_save_profile),
              onPressed: _saveCurrentCalibrationAsProfile,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save_alt),
              label: Text(l10n.calibration_export_profile),
              onPressed: _exportCurrentProfile,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.paste),
              label: Text(l10n.calibration_import_profile),
              onPressed: _importProfileFromClipboard,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.restore),
              label: Text(l10n.calibration_reset_profile),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: Text(l10n.calibration_dialog_confirm_title),
                    content: Text(
                        l10n.calibration_dialog_delete_profile),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(c).pop(false),
                          child: Text(l10n.common_cancel)),
                      TextButton(
                          onPressed: () => Navigator.of(c).pop(true),
                          child: Text(l10n.calibration_action_delete)),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _resetProfileForDevice();
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshCurrentProfile,
              child: Text(l10n.calibration_refresh_profile),
            ),
            const SizedBox(height: 12),
            if (_currentKey != null) ...[
              Text(
                l10n.calibration_key_device(_currentKey!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  _currentProfile == null
                      ? l10n.calibration_no_profile
                      : CalibrationStorage.exportProfile(_currentProfile!),
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSettingsControls(WidgetRef ref, BuildContext context) {
    final settings = ref.watch(dashboardImageSettingsProvider);
    final notifier = ref.read(dashboardImageSettingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.calibration_image_settings_title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Align X
        Row(
          children: [
            SizedBox(width: 60, child: Text(l10n.calibration_pos_x)),
            Expanded(
              child: Slider(
                value: settings.alignX,
                min: -1.0,
                max: 1.0,
                divisions: 200,
                label: settings.alignX.toStringAsFixed(2),
                onChanged: (v) => notifier.setAlignX(v),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(settings.alignX.toStringAsFixed(2),
                  textAlign: TextAlign.end),
            ),
          ],
        ),
        // Align Y
        Row(
          children: [
            SizedBox(width: 60, child: Text(l10n.calibration_pos_y)),
            Expanded(
              child: Slider(
                value: settings.alignY,
                min: -1.0,
                max: 1.0,
                divisions: 200,
                label: settings.alignY.toStringAsFixed(2),
                onChanged: (v) => notifier.setAlignY(v),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(settings.alignY.toStringAsFixed(2),
                  textAlign: TextAlign.end),
            ),
          ],
        ),
        // Zoom
        Row(
          children: [
            SizedBox(width: 60, child: Text(l10n.calibration_zoom)),
            Expanded(
              child: Slider(
                value: settings.zoom,
                min: 1.0,
                max: 1.6,
                divisions: 60,
                label: settings.zoom.toStringAsFixed(2),
                onChanged: (v) => notifier.setZoom(v),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(settings.zoom.toStringAsFixed(2),
                  textAlign: TextAlign.end),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.restore),
            label: Text(l10n.calibration_reset_image),
            onPressed: () => notifier.reset(),
          ),
        ),
      ],
    );
  }
}
