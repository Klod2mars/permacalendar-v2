
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permacalendar/core/services/planting_consistency_service.dart';

class AuditDashboard extends StatefulWidget {
  const AuditDashboard({super.key});

  @override
  State<AuditDashboard> createState() => _AuditDashboardState();
}

class _AuditDashboardState extends State<AuditDashboard> {
  PlantingConsistencyReport? _report;
  bool _isLoading = false;
  final PlantingConsistencyService _service = PlantingConsistencyService();

  Future<void> _runAudit() async {
    setState(() => _isLoading = true);
    final report = await _service.audit();
    setState(() {
      _report = report;
      _isLoading = false;
    });
  }

  Future<void> _runMigration() async {
     setState(() => _isLoading = true);
     final report = await _service.runMigration();
     setState(() {
       _report = report;
       _isLoading = false;
     });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Migration terminée. ${report.fixedPlantings.length} corrections appliquées.'))
     );
  }

  void _copyCsvToClipboard() {
    if (_report == null) return;
    final buffer = StringBuffer();
    buffer.writeln('--- ORPHANS CSV ---');
    buffer.writeln('PlantingID,PlantName,PlantID');
    for (final o in _report!.orphans) {
      buffer.writeln('${o.id},${o.plantName},${o.plantId}');
    }
    buffer.writeln('\n--- MISSING ASSETS ---');
    for (final m in _report!.missingAssets) {
      buffer.writeln(m);
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rapport copié dans le presse-papier'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Plantations'),
        actions: [
          if (_report != null)
            IconButton(icon: const Icon(Icons.copy), onPressed: _copyCsvToClipboard)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _runAudit,
                  icon: const Icon(Icons.search),
                  label: const Text('Lancer Audit'),
                ),
                ElevatedButton.icon(
                  onPressed: (_isLoading || _report == null) ? null : _runMigration,
                  icon: const Icon(Icons.build),
                  label: const Text('Réparer (Migration)'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100, foregroundColor: Colors.brown),
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          if (_report != null) ...[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('Orphelins: ${_report!.orphans.length} | Images manquantes: ${_report!.missingAssets.length} | Corrigés: ${_report!.fixedPlantings.length}',
                 style: const TextStyle(fontWeight: FontWeight.bold)),
             ),
             Expanded(
               child: DefaultTabController(
                 length: 3,
                 child: Column(
                   children: [
                     const TabBar(
                       labelColor: Colors.black,
                       tabs: [
                         Tab(text: 'Orphelins'),
                         Tab(text: 'Missing Assets'),
                         Tab(text: 'Logs'),
                       ],
                     ),
                     Expanded(
                       child: TabBarView(
                         children: [
                           // Orphans List
                           ListView.builder(
                             itemCount: _report!.orphans.length,
                             itemBuilder: (ctx, i) {
                               final p = _report!.orphans[i];
                               return ListTile(
                                 title: Text(p.plantName),
                                 subtitle: Text('ID: ${p.plantId} (Planting: ${p.id})'),
                                 leading: const Icon(Icons.broken_image, color: Colors.red),
                               );
                             },
                           ),
                           // Missing Assets List
                           ListView.builder(
                             itemCount: _report!.missingAssets.length,
                             itemBuilder: (ctx, i) => ListTile(
                               title: Text(_report!.missingAssets[i], style: const TextStyle(fontSize: 12)),
                               leading: const Icon(Icons.image_not_supported, color: Colors.orange),
                             ),
                           ),
                           // Logs
                           ListView.builder(
                             itemCount: _report!.logs.length,
                             itemBuilder: (ctx, i) => Text(_report!.logs[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 10)),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
          ] else
            const Expanded(child: Center(child: Text('Appuyez sur "Lancer Audit" pour commencer.'))),
        ],
      ),
    );
  }
}
