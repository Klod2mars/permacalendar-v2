import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

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



    // Image integration (Add a new page or append if possible, but keep simple: add to end of column if single page, or new page)
    // Actually, adding to the column above is best if it fits. 
    // To update safely, let's redefine the page build to include the image in the column.
    // However, I am replacing lines 50-68 which is the page build.
    
    // Check for image
    final imgPath = task.metadata['attachedImagePath'] as String?;
    pw.MemoryImage? attachedImage;
    if (imgPath != null && imgPath.isNotEmpty) {
      final f = File(imgPath);
      if (await f.exists()) {
        attachedImage = pw.MemoryImage(await f.readAsBytes());
      }
    }

    pdf.addPage(pw.MultiPage(
      build: (pw.Context ctx) => [
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
        if (attachedImage != null) ...[
           pw.SizedBox(height: 20),
           pw.Text('Photo jointe:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
           pw.SizedBox(height: 10),
           pw.Center(child: pw.Image(attachedImage, width: 380, fit: pw.BoxFit.contain)),
        ]
      ],
    ));

    final bytes = await pdf.save();
    final tmp = await getTemporaryDirectory();
    final sanitizedTitle = _sanitizeFilename(task.title);
    final fileName = sanitizedTitle.isNotEmpty ? sanitizedTitle : 'task_${task.id}';
    final file = File('${tmp.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static String _sanitizeFilename(String name) {
    // Keep only alphanumeric, spaces, hyphens and underscores
    // Replace spaces with underscores or keep them? Filesystems handle spaces, but underscores are safer.
    // Let's replace spaces with underscores and remove special chars.
    final validChars = RegExp(r'[a-zA-Z0-9\-_ ]');
    final buffer = StringBuffer();
    for (int i = 0; i < name.length; i++) {
      final char = name[i];
      if (validChars.hasMatch(char)) {
        buffer.write(char);
      } else {
        buffer.write('_');
      }
    }
    String result = buffer.toString().trim().replaceAll(RegExp(r'_+'), '_');
    if (result.length > 50) result = result.substring(0, 50); // Truncate if too long
    return result;
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



  /// Ouvre la feuille de partage système
  static Future<void> shareFile(File file, String mimeType, BuildContext? context, { String? shareText }) async {
    if (!await file.exists()) {
      throw Exception('Fichier introuvable pour le partage: ${file.path}');
    }
    
    final xFile = XFile(file.path, mimeType: mimeType);
    
    // Optional: only compute sharePositionOrigin if context != null and renderObject available
    Rect? sharePositionOrigin;
    try {
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final pos = box.localToGlobal(Offset.zero);
          sharePositionOrigin = Rect.fromLTWH(pos.dx, pos.dy, box.size.width, box.size.height);
        }
      }
    } catch (_) {
      // ignore: don't fail sharing for lack of position
    }
    
    await Share.shareXFiles(
      [xFile],
      text: shareText ?? 'Tâche PermaCalendar',
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
