import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:docx_template/docx_template.dart';
import 'package:intl/intl.dart';

import '../../core/models/activity.dart';
import '../../core/data/hive/garden_boxes.dart';

class TaskDocumentGenerator {
  /// Génère un PDF simple pour la tâche donnée
  static Future<File> generateTaskPdf(Activity task) async {
    final pdf = pw.Document();
    
    // Résolution des noms
    String gardenName = '-';
    String bedName = '-';
    
    if (task.metadata != null) {
      final gId = task.metadata?['gardenId'] as String?;
      if (gId != null) {
        final g = GardenBoxes.getGarden(gId);
        if (g != null) gardenName = g.name;
      }
      
      final bId = task.metadata?['zoneGardenBedId'] as String?;
      if (bId != null) { // Note: ID might need parsing or lookup depending on exact metadata structure
         final b = GardenBoxes.getGardenBedById(bId);
         if (b != null) bedName = b.name;
      }
    }

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    // Retrieve nextRunDate from metadata or fallback to timestamp
    DateTime nextRun = task.timestamp;
    if (task.metadata['nextRunDate'] != null) {
      nextRun = DateTime.tryParse(task.metadata['nextRunDate']) ?? task.timestamp;
    }
    final dateStr = dateFormat.format(nextRun);

    final String tKind = task.metadata['taskKind'] is String 
        ? task.metadata['taskKind'] 
        : (task.type.name);

    final bool isUrgent = task.metadata['urgent'] == true;

    pdf.addPage(pw.Page(build: (pw.Context ctx) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Tâche: ${task.title}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          _buildPdfRow('Description', task.description ?? '-'),
          _buildPdfRow('Jardin', gardenName),
          _buildPdfRow('Parcelle / Zone', bedName),
          _buildPdfRow('Date prévue', dateStr),
          _buildPdfRow('Durée', '${task.metadata?['durationMinutes'] ?? '-'} min'),
          _buildPdfRow('Type', tKind),
          _buildPdfRow('Priorité', task.metadata?['priority']?.toString() ?? '-'),
          _buildPdfRow('Urgent', isUrgent ? 'OUI' : 'Non'),
          _buildPdfRow('Assigné à', task.metadata?['assignee']?.toString() ?? '-'),
          // Ajoutez d'autres champs si nécessaire
        ],
      );
    }));

    final bytes = await pdf.save();
    final tmp = await getTemporaryDirectory();
    final file = File('${tmp.path}/permatask_${task.id}.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 120,
            child: pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  /// Génère un DOCX via template pour la tâche donnée
  static Future<File> generateTaskDocx(Activity task) async {
    // 1. Charger le template
    final data = await rootBundle.load('assets/templates/task_template.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);

    // 2. Préparer le contenu
    // Résolution des noms (similaire au PDF)
    String gardenName = '-';
    String bedName = '-';
    
    if (task.metadata != null) {
      final gId = task.metadata?['gardenId'] as String?;
      if (gId != null) {
        final g = GardenBoxes.getGarden(gId);
        if (g != null) gardenName = g.name;
      }
      
      final bId = task.metadata?['zoneGardenBedId'] as String?;
      if (bId != null) {
         final b = GardenBoxes.getGardenBedById(bId);
         if (b != null) bedName = b.name;
      }
    }

    // Prepare data from metadata
    DateTime nextRun = task.timestamp;
    if (task.metadata['nextRunDate'] != null) {
      nextRun = DateTime.tryParse(task.metadata['nextRunDate']) ?? task.timestamp;
    }
    final String tKind = task.metadata['taskKind'] is String 
        ? task.metadata['taskKind'] 
        : (task.type.name);
    final bool isUrgent = task.metadata['urgent'] == true;
    final bool hasRecurrence = task.metadata['recurrence'] != null;

    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    final content = Content();
    content
      ..add(TextContent('title', task.title))
      ..add(TextContent('description', task.description ?? ''))
      ..add(TextContent('garden', gardenName))
      ..add(TextContent('bed', bedName))
      ..add(TextContent('date', dateFormat.format(nextRun)))
      ..add(TextContent('time', timeFormat.format(nextRun)))
      ..add(TextContent('duration', '${task.metadata?['durationMinutes'] ?? ""}'))
      ..add(TextContent('type', tKind))
      ..add(TextContent('priority', task.metadata?['priority']?.toString() ?? ""))
      ..add(TextContent('urgent', isUrgent ? "OUI" : "Non"))
      ..add(TextContent('assignee', task.metadata?['assignee']?.toString() ?? ""))
      ..add(TextContent('recurrence', hasRecurrence ? "Oui" : "Non"));

    // 3. Générer
    final generated = await docx.generate(content);
    if (generated == null) {
      throw Exception('Echec de la génération DOCX (template potentiellement invalide ou mismatch)');
    }

    final tmp = await getTemporaryDirectory();
    final file = File('${tmp.path}/permatask_${task.id}.docx');
    await file.writeAsBytes(generated);
    return file;
  }

  /// Ouvre la feuille de partage système
  static Future<void> shareFile(File file, String mimeType, BuildContext context, { String? shareText }) async {
    if (!await file.exists()) {
      throw Exception('Fichier introuvable pour le partage: ${file.path}');
    }
    
    final xFile = XFile(file.path, mimeType: mimeType);
    
    // Sur iPad / Tablettes, sharePositionOrigin est recommandé, mais optionnel.
    // context.findRenderObject() as RenderBox? ...
    
    await Share.shareXFiles(
      [xFile],
      text: shareText ?? 'Tâche PermaCalendar',
    );
  }
}
