// Dev-only helpers. Do not ship to production builds unless guarded.
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> backupHiveBoxFiles(List<String> boxNames) async {
  final dir = await getApplicationDocumentsDirectory();
  final backupDir = Directory('${dir.path}/hive_backups');
  if (!await backupDir.exists()) await backupDir.create();
  final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
  for (final name in boxNames) {
    final hiveFile = File('${dir.path}/$name.hive');
    if (await hiveFile.exists()) {
      final dest = File('${backupDir.path}/${name}_backup_$ts.hive');
      await hiveFile.copy(dest.path);
    }
    final lockFile = File('${dir.path}/$name.lock');
    if (await lockFile.exists()) {
      await lockFile.copy('${backupDir.path}/${name}_backup_$ts.lock');
    }
  }
}

Future<void> deleteHiveBoxFiles(String boxName) async {
  if (Hive.isBoxOpen(boxName)) {
    await Hive.box(boxName).clear();
    await Hive.box(boxName).close();
  }
  final docDir = await getApplicationDocumentsDirectory();
  final hivePath = '${docDir.path}/$boxName.hive';
  final lockPath = '${docDir.path}/$boxName.lock';
  final files = [hivePath, lockPath];
  for (final p in files) {
    final f = File(p);
    if (await f.exists()) await f.delete();
  }
}
