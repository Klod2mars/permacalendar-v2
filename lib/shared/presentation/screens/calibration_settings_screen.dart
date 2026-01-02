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

    if (_currentProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Aucun profil trouvé pour cet appareil.')));

      return;
    }

    final json = CalibrationStorage.exportProfile(_currentProfile!);

    await Clipboard.setData(ClipboardData(text: json));

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil copié dans le presse-papiers.')));
  }

  Future<void> _importProfileFromClipboard() async {
    final clip = await Clipboard.getData('text/plain');

    final text = clip?.text ?? '';

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Presse-papiers vide.')));

      return;
    }

    try {
      final Map<String, dynamic> profile =
          CalibrationStorage.importProfile(text);

      final key = await deviceCalibrationKey(context);

      await CalibrationStorage.saveProfile(key, profile);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profil importé et sauvegardé pour cet appareil.')));

      await _refreshCurrentProfile();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur import JSON: $e')));
    }
  }

  Future<void> _resetProfileForDevice() async {
    final key = await deviceCalibrationKey(context);

    await CalibrationStorage.deleteProfile(key);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil supprimé pour cet appareil.')));

    await _refreshCurrentProfile();
  }

  Future<void> _saveCurrentCalibrationAsProfile() async {
    try {
      final zones = ref.read(organicZonesProvider);

      if (zones.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Aucune calibration enregistrée. Calibrez d\'abord depuis le dashboard.')),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Calibration actuelle sauvegardée comme profil pour cet appareil.')),
      );

      await _refreshCurrentProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calibration Organique')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Appliquer automatiquement pour cet appareil'),
              value: _autoApply,
              onChanged: _toggleAutoApply,
            ),
            const Divider(),
            _buildImageSettingsControls(ref, context),
            const Divider(),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.tune),
              label: const Text('Calibrer maintenant'),
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
                  const Text('Sauvegarder calibration actuelle comme profil'),
              onPressed: _saveCurrentCalibrationAsProfile,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save_alt),
              label: const Text('Exporter profil (copie JSON)'),
              onPressed: _exportCurrentProfile,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.paste),
              label: const Text('Importer profil depuis presse-papiers'),
              onPressed: _importProfileFromClipboard,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text('Réinitialiser profil pour cet appareil'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Confirmer'),
                    content: const Text(
                        'Supprimer le profil de calibration pour cet appareil ?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(c).pop(false),
                          child: const Text('Annuler')),
                      TextButton(
                          onPressed: () => Navigator.of(c).pop(true),
                          child: const Text('Supprimer')),
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
              child: const Text('Actualiser aperçu profil'),
            ),
            const SizedBox(height: 12),
            if (_currentKey != null) ...[
              Text(
                'Clé appareil: $_currentKey',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  _currentProfile == null
                      ? 'Aucun profil enregistré pour cet appareil.'
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Réglages Image de Fond (Persistant)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Align X
        Row(
          children: [
            const SizedBox(width: 60, child: Text('Pos X')),
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
            const SizedBox(width: 60, child: Text('Pos Y')),
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
            const SizedBox(width: 60, child: Text('Zoom')),
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
            label: const Text('Reset Image Defaults'),
            onPressed: () => notifier.reset(),
          ),
        ),
      ],
    );
  }
}
