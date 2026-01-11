import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/plants_repository.dart';
import '../../models/plant_localized.dart';

// Configuration
const String kStingerBaseUrl = 'https://packs.permacalendar.app'; // Replace with real URL later

class PackManager {
  final Dio _dio;
  final PlantsRepository _repo;

  PackManager(this._dio, this._repo);

  Future<Map<String, dynamic>> fetchManifest() async {
    final response = await _dio.get('$kStingerBaseUrl/manifest.json');
    return response.data;
  }

  Future<void> downloadAndInstallPack(String locale, String expectedSha256) async {
    // 1. Download
    final tempDir = await getTemporaryDirectory();
    final zipFile = File('${tempDir.path}/pack_$locale.zip');
    
    await _dio.download(
      '$kStingerBaseUrl/packs/plants_${locale}_latest.zip', // Simplified URL scheme
      zipFile.path,
      onReceiveProgress: (received, total) {
        // TODO: Expose progress via stream/provider
      },
    );

    // 2. Verify SHA256
    final bytes = await zipFile.readAsBytes();
    final digest = sha256.convert(bytes);
    if (digest.toString() != expectedSha256) {
      throw Exception('Pack integrity check failed! Expected $expectedSha256, got $digest');
    }

    // 3. Unzip
    final inputStream = InputFileStream(zipFile.path);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    
    File? jsonFile;
    
    // Extract to temp
    for (var file in archive.files) {
      if (file.isFile) {
        final outputStream = OutputFileStream('${tempDir.path}/${file.name}');
        file.writeContent(outputStream);
        outputStream.close();
        if (file.name.endsWith('.json') && !file.name.contains('index')) {
           jsonFile = File('${tempDir.path}/${file.name}');
        }
      }
    }
    
    if (jsonFile == null) {
      throw Exception('No JSON data file found in pack');
    }

    // 4. Parse & Import
    final jsonString = await jsonFile.readAsString();
    // Assuming structure is List<PlantLocalized> or similar wrapper
    // Since implementing the full JSON parser for the Hive object might be complex if the JSON doesn't match exactly the Hive fields (e.g. TypeAdapter).
    // The `tools` generate a JSON. `PlantLocalized` is a Hive object.
    // We need to map JSON -> PlantLocalized manually or use a fromJson factory.
    // I'll assume I add `fromJson` to `PlantLocalized` or do it here.
    // For now, doing it here to avoid modifying model immediately.
    
    final List<dynamic> jsonData = jsonDecode(jsonString);
    final List<PlantLocalized> plants = jsonData.map((item) {
       // Minimal mapping
       return PlantLocalized(
         id: item['id'],
         scientificName: item['scientificName'],
         localized: (item['localized'] as Map).map((k, v) => MapEntry(k, LocalizedPlantFields(
            commonName: v['commonName'] ?? '',
            shortDescription: v['shortDescription'] ?? '',
            // ... map other fields
            source: v['source'] ?? 'pack',
            needsReview: v['needsReview'] ?? false
         ))),
         lastUpdated: DateTime.parse(item['lastUpdated'] ?? DateTime.now().toIso8601String()),
         schemaVersion: item['schemaVersion'] ?? 1,
       );
    }).toList();

    await _repo.importData(plants, locale);

    // Cleanup
    await zipFile.delete();
    // Delete extracted files?
  }
}

final packManagerProvider = Provider<PackManager>((ref) {
  final dio = Dio(); // Or get from a dioProvider
  final repo = ref.read(plantsRepositoryProvider);
  return PackManager(dio, repo);
});
