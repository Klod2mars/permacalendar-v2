import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/organic_zones_provider.dart';

/// NOTE: Widget de debug pour exporter les positions et backups Hive.
/// Adapté pour lire l'état Riverpod (OrganicZonesProvider) car la persistance
/// utilise SharedPreferences et non Hive pour les positions.

class DebugExportPositionsPage extends ConsumerStatefulWidget {
  const DebugExportPositionsPage({super.key});

  @override
  ConsumerState<DebugExportPositionsPage> createState() => _DebugExportPositionsPageState();
}

class _DebugExportPositionsPageState extends ConsumerState<DebugExportPositionsPage> {
  String _log = '';

  void _logAdd(String s) {
    if (mounted) {
      setState(() { _log = '$_log\n$s'; });
    } else {
      _log = '$_log\n$s';
    }
    debugPrint(s);
  }

  Future<String> _getExportDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Tentative générique de conversion d'un objet stored -> Map.
  Map<String, dynamic> _toMap(dynamic obj) {
    try {
      if (obj == null) return {};
      if (obj is Map) return Map<String, dynamic>.from(obj);
      // If the object has toJson / toMap method use it
      if (obj is dynamic) {
        try {
          // ignore: avoid_dynamic_calls
          return Map<String, dynamic>.from(obj.toJson());
        } catch (_) {}
        try {
          // ignore: avoid_dynamic_calls
          return Map<String, dynamic>.from(obj.toMap());
        } catch (_) {}
      }
      // Fallback: try jsonEncode->jsonDecode
      final s = jsonEncode(obj);
      final decoded = jsonDecode(s);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (e) {
      // best-effort
    }
    // Last resort, store string representation
    return {'_raw': obj.toString()};
  }

  Future<void> _export() async {
    try {
      final exportDir = await _getExportDirPath();
      _logAdd('Export dir: $exportDir');

      // 1) Export Hive Boxes (Backup)
      // Liste des boxes identifiées lors de l'audit
      final candidateBoxes = [
        'gardens',
        'garden_beds',
        'plantings',
        'harvests',
        'dashboard_slots',
        'garden_layout_v1', // Legacy checks
        'garden_bubbles',
        'garden_bubble_positions'
      ];

      for (final name in candidateBoxes) {
        try {
          bool isBoxOpen = Hive.isBoxOpen(name);
          Box box;
          
          if (isBoxOpen) {
            box = Hive.box(name);
          } else if (await Hive.boxExists(name)) {
             // Ouvre en lecture seule si possible (Hive n'a pas de mode strictement RO explicit, mais on ne fait que lire)
            box = await Hive.openBox(name);
          } else {
            _logAdd('Box Hive non trouvée/existante: $name');
            continue;
          }

          final keys = box.keys.toList();
          final List<Map<String, dynamic>> exported = [];
          for (final key in keys) {
            final val = box.get(key);
            exported.add({
              'key': key.toString(),
              'value': _toMap(val),
            });
          }

          final backupPath = '$exportDir/hive_backup_$name.json';
          final jsonStr = jsonEncode(exported);
          await File(backupPath).writeAsString(jsonStr, flush: true);
          _logAdd('✅ Backup Hive créé: $name -> $backupPath (${exported.length} items)');

          if (!isBoxOpen) {
            await box.close();
          }

        } catch (e) {
          _logAdd('❌ Erreur lecture Box $name : $e');
        }
      }

      // 2) Export des positions depuis Riverpod (Mémoire)
      // C'est la source de vérité pour le dashboard actuel
      Map<String, dynamic>? positionsJson;
      try {
        final currentZones = ref.read(organicZonesProvider);
        if (currentZones.isNotEmpty) {
          _logAdd('Lecture des positions depuis organicZonesProvider (${currentZones.length} zones)...');
          
          final List<Map<String, dynamic>> bubblesList = [];
          
          for (final entry in currentZones.entries) {
            final zone = entry.value;
            bubblesList.add({
              "id": zone.id,
              "x": double.parse(zone.position.dx.toStringAsFixed(4)),
              "y": double.parse(zone.position.dy.toStringAsFixed(4)),
              "r": double.parse(zone.size.toStringAsFixed(4)),
              "state": zone.enabled ? "created" : "placeholder",
              "name": zone.name,
              "meta": {
                "enabled": zone.enabled
              }
            });
          }

          positionsJson = {
            "image": "assets/images/backgrounds/dashboard_organic_final.png",
            "maxBubbles": bubblesList.length,
            "bubbles": bubblesList,
            "exportDate": DateTime.now().toIso8601String(),
            "source": "organicZonesProvider (Riverpod)"
          };
        } else {
             _logAdd('⚠️ organicZonesProvider est vide. Tentative via SharedPreferences direct...');
            // Fallback: Read SharedPreferences manually if provider is empty (unlikely if app is running)
            final prefs = await SharedPreferences.getInstance();
            final keys = prefs.getKeys().where((k) => k.startsWith('organic_')).toList();
             _logAdd('Clés SharedPreferences trouvées: ${keys.length}');
             // On ne reconstruit pas tout ici pour l'instant, on suppose que le provider est à jour.
        }

      } catch (e) {
        _logAdd('❌ Erreur lecture Riverpod: $e');
      }

      // 3) Ecriture du fichier final dashboard_bubbles_from_device.json
      if (positionsJson != null) {
        final outPath = '$exportDir/dashboard_bubbles_from_device.json';
        await File(outPath).writeAsString(jsonEncode(positionsJson), flush: true);
        _logAdd('✅✅✅ EXPORT SUCCESS -> $outPath');
        _logAdd('Contenu: ${positionsJson['bubbles'].length} bulles.');
      } else {
        _logAdd('⚠️ Pas de positions trouvées (Provider vide et pas de fallback actif).');
      }

    } catch (e, st) {
      _logAdd('❌ FATAL EXPORT ERROR: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Debug Positions'),
        backgroundColor: Colors.amber, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Cet outil exporte :\n1. Dumps des boxes Hive (gardens, beds...)\n2. Le JSON des positions actuelles (Riverpod)\n\nFichiers écrits dans Documents app.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('LANCER EXPORT (Safe)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: _export,
            ),
            const Divider(height: 30),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.black12,
                child: SingleChildScrollView(
                  child: Text(_log, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
