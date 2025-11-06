// tools/orphan_analyzer.dart
// Analyse non-destructive pour détecter les fichiers/providers/symboles orphelins
import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  final outputDir = args.isNotEmpty ? args[0] : 'cursor_orphan_results';
  final messageIdx = args.length > 1 ? args[1] : '12';
  final libDir = Directory('lib');
  
  if (!libDir.existsSync()) {
    stderr.writeln('Erreur: le dossier lib/ n\'existe pas.');
    exit(1);
  }

  print('🔍 Analyse des orphelins en cours...');
  print('📁 Dossier de sortie: $outputDir');
  print('🔖 Message IDX: $messageIdx');
  
  final output = Directory(outputDir);
  if (!output.existsSync()) {
    output.createSync(recursive: true);
  }
  
  // Stocker messageIdx pour les citations
  final citationMarker = messageIdx;

  // 1. Analyse des fichiers non référencés
  print('\n1️⃣  Analyse des fichiers non référencés...');
  await analyzeUnreferencedFiles(libDir, output, citationMarker);

  // 2. Analyse des providers Riverpod orphelins
  print('2️⃣  Analyse des providers Riverpod...');
  await analyzeProviders(libDir, output, citationMarker);

  // 3. Analyse des symboles top-level non utilisés
  print('3️⃣  Analyse des symboles top-level...');
  await analyzeUnusedSymbols(libDir, output, citationMarker);

  // 4. Génération du rapport consolidé
  print('4️⃣  Génération du rapport consolidé...');
  await generateReport(output, citationMarker);

  // 5. Génération des templates d'issues GitHub
  print('5️⃣  Génération des templates d\'issues...');
  await generateIssueTemplates(output, citationMarker);

  print('\n✅ Analyse terminée! Résultats dans: $outputDir');
}

Future<void> analyzeUnreferencedFiles(Directory libDir, Directory output, String messageIdx) async {
  final dartFiles = <File>[];
  await _collectDartFiles(libDir, dartFiles);
  
  final packageName = await _getPackageName();
  final referencedFiles = <String>{};
  final allFiles = <String, File>{};

  // Collecter tous les fichiers et leurs imports potentiels
  for (var file in dartFiles) {
    final relPath = path.relative(file.path, from: libDir.path);
    allFiles[relPath] = file;
    
    try {
      final content = await file.readAsString();
      final imports = _extractImports(content);
      
      for (var imp in imports) {
        // Nettoyer l'import pour trouver le fichier correspondant
        String? filePath;
        if (imp.startsWith('package:$packageName/')) {
          filePath = imp.substring('package:$packageName/'.length);
        } else if (imp.startsWith('package:') || imp.startsWith('dart:') || imp.startsWith('flutter:')) {
          continue; // Import externe
        } else if (imp.startsWith("'") || imp.startsWith('"')) {
          // Import relatif
          final importPath = imp.replaceAll(RegExp("['\"]"), '');
          final dir = path.dirname(relPath);
          filePath = path.normalize(path.join(dir, importPath));
        }
        
        if (filePath != null && filePath.endsWith('.dart')) {
          referencedFiles.add(filePath.replaceAll('\\', '/'));
        }
      }
    } catch (e) {
      stderr.writeln('Erreur lecture ${file.path}: $e');
    }
  }

  // Trouver les fichiers non référencés
  final unreferenced = <String>[];
  for (var entry in allFiles.entries) {
    final relPath = entry.key.replaceAll('\\', '/');
    final fileName = path.basenameWithoutExtension(relPath);
    
    // Vérifier si le fichier est référencé
    bool isReferenced = referencedFiles.contains(relPath);
    
    // Vérifier aussi par nom de classe/fichier (cas barrel files)
    if (!isReferenced) {
      for (var ref in referencedFiles) {
        if (ref.contains(fileName)) {
          isReferenced = true;
          break;
        }
      }
    }
    
    // Exclure main.dart et fichiers d'export
    if (relPath == 'main.dart' || relPath.contains('/main.dart')) {
      continue;
    }
    
    // Vérifier si le fichier contient des exports (barrel file)
    final file = entry.value;
    try {
      final content = await file.readAsString();
      if (content.contains('export ') && content.contains('package:$packageName/')) {
        // Probable barrel file, vérifier s'il est importé
        isReferenced = true;
      }
    } catch (_) {}
    
    if (!isReferenced) {
      unreferenced.add(relPath);
    }
  }

  final reportFile = File(path.join(output.path, 'unreferenced_files.txt'));
  final reportLines = <String>[
    'Fichiers Dart potentiellement non référencés:',
    '${'=' * 60}',
    '',
    'Total fichiers analysés: ${allFiles.length}',
    'Fichiers non référencés: ${unreferenced.length}',
    '',
  ];
  
  for (var f in unreferenced) {
    reportLines.add('Non référencé: lib/$f 【${messageIdx}†lib/$f】');
  }
  
  await reportFile.writeAsString(reportLines.join('\n') + '\n');
  
  print('   📄 ${unreferenced.length} fichier(s) potentiellement non référencé(s)');
}

Future<void> analyzeProviders(Directory libDir, Directory output, String messageIdx) async {
  final providers = <ProviderInfo>[];
  final dartFiles = <File>[];
  await _collectDartFiles(libDir, dartFiles);

  for (var file in dartFiles) {
    try {
      final content = await file.readAsString();
      final lines = content.split('\n');
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        
        // Détecter les déclarations de providers
        if (line.contains(RegExp(r'final\s+\w+\s*=\s*.*Provider|StateNotifierProvider|ChangeNotifierProvider|FutureProvider|StreamProvider'))) {
          final match = RegExp(r'final\s+([A-Za-z0-9_]+)\s*=').firstMatch(line);
          if (match != null) {
            final name = match.group(1);
            if (name != null && name.endsWith('Provider')) {
              providers.add(ProviderInfo(
                name: name,
                file: path.relative(file.path, from: libDir.path),
                line: i + 1,
                declaration: line.trim(),
              ));
            }
          }
        }
      }
    } catch (e) {
      stderr.writeln('Erreur analyse ${file.path}: $e');
    }
  }

  // Vérifier l'utilisation de chaque provider
  final orphanProviders = <ProviderInfo>[];
  final usedProviders = <ProviderInfo>[];

  for (var provider in providers) {
    bool isUsed = false;
    
    for (var file in dartFiles) {
      if (file.path.contains(provider.file)) {
        continue; // Ignorer le fichier de déclaration
      }
      
      try {
        final content = await file.readAsString();
        // Chercher l'utilisation du provider
        if (content.contains(provider.name) ||
            content.contains('ref.watch(${provider.name})') ||
            content.contains('ref.read(${provider.name})') ||
            content.contains('ref.listen(${provider.name})')) {
          isUsed = true;
          break;
        }
      } catch (_) {}
    }
    
    if (isUsed) {
      usedProviders.add(provider);
    } else {
      orphanProviders.add(provider);
    }
  }

  final reportFile = File(path.join(output.path, 'orphan_providers.txt'));
  final reportLines = <String>[
    'Analyse des providers Riverpod',
    '${'=' * 60}',
    '',
    'Total providers trouvés: ${providers.length}',
    'Providers utilisés: ${usedProviders.length}',
    'Providers orphelins: ${orphanProviders.length}',
    '',
    '${'=' * 60}',
    'PROVIDERS ORPHELINS:',
    '${'=' * 60}',
  ];
  
  for (var p in orphanProviders) {
    reportLines.add('ORPHELIN: ${p.name} (declared in ${p.file}:${p.line}) 【${messageIdx}†${p.file}:${p.line}】');
    reportLines.add('  ${p.declaration}');
    reportLines.add('');
  }
  
  reportLines.add('${'=' * 60}');
  reportLines.add('PROVIDERS UTILISÉS:');
  reportLines.add('${'=' * 60}');
  for (var p in usedProviders) {
    reportLines.add('UTILISE: ${p.name} (declared in ${p.file}:${p.line})');
  }
  
  await reportFile.writeAsString(reportLines.join('\n') + '\n');
  
  print('   🔌 ${orphanProviders.length}/${providers.length} provider(s) orphelin(s)');
}

Future<void> analyzeUnusedSymbols(Directory libDir, Directory output, String messageIdx) async {
  final unusedSymbols = <SymbolInfo>[];
  final dartFiles = <File>[];
  await _collectDartFiles(libDir, dartFiles);
  
  // Map pour stocker le contenu de tous les fichiers
  final fileContents = <String, String>{};
  for (var file in dartFiles) {
    try {
      fileContents[file.path] = await file.readAsString();
    } catch (e) {
      fileContents[file.path] = '';
      stderr.writeln('Erreur lecture ${file.path}: $e');
    }
  }

  // Analyser chaque fichier pour trouver les symboles top-level
  for (var file in dartFiles) {
    try {
      final content = fileContents[file.path]!;
      final symbols = _extractTopLevelSymbols(content, file.path);
      
      for (var symbol in symbols) {
        // Vérifier si le symbole est utilisé ailleurs
        bool isUsed = false;
        for (var entry in fileContents.entries) {
          if (entry.key == file.path) continue; // Ignorer le fichier de déclaration
          
          // Chercher le symbole (avec word boundaries)
          final pattern = RegExp('\\b${RegExp.escape(symbol.name)}\\b');
          if (pattern.hasMatch(entry.value)) {
            isUsed = true;
            break;
          }
        }
        
        if (!isUsed) {
          unusedSymbols.add(symbol);
        }
      }
    } catch (e) {
      stderr.writeln('Erreur analyse symboles ${file.path}: $e');
    }
  }

  final reportFile = File(path.join(output.path, 'unused_symbols.txt'));
  final grouped = <String, List<SymbolInfo>>{};
  for (var symbol in unusedSymbols) {
    grouped.putIfAbsent(symbol.file, () => []).add(symbol);
  }

  final buffer = StringBuffer();
  buffer.writeln('Symboles top-level non référencés');
  buffer.writeln('${'=' * 60}');
  buffer.writeln('Total symboles orphelins: ${unusedSymbols.length}\n');
  
  for (var entry in grouped.entries) {
    buffer.writeln('== Fichier: ${entry.key}');
    for (var symbol in entry.value) {
      buffer.writeln(' - ${symbol.kind}: ${symbol.name} @ligne ${symbol.line} 【${messageIdx}†${symbol.file}:${symbol.line}】');
    }
    buffer.writeln('');
  }

  await reportFile.writeAsString(buffer.toString());
  print('   🔤 ${unusedSymbols.length} symbole(s) top-level non référencé(s)');
}

Future<void> generateReport(Directory output, String messageIdx) async {
  final reportFile = File(path.join(output.path, 'orphan_report.md'));
  final buffer = StringBuffer();
  
  buffer.writeln('# Rapport d\'analyse des orphelins');
  buffer.writeln('');
  buffer.writeln('## Résumé');
  buffer.writeln('');
  buffer.writeln('- Date: ${DateTime.now().toIso8601String()}');
  buffer.writeln('- Projet: PermaCalendar v2');
  buffer.writeln('');

  // Fichiers non référencés
  final unreferencedFile = File(path.join(output.path, 'unreferenced_files.txt'));
  if (unreferencedFile.existsSync()) {
      buffer.writeln('### Fichiers probablement non référencés');
      buffer.writeln('');
      // Extraire les fichiers avec leurs marqueurs de citation
      final lines = await unreferencedFile.readAsLines();
      for (var line in lines) {
        if (line.startsWith('Non référencé:')) {
          buffer.writeln('- $line');
        }
      }
      buffer.writeln('');
  }

  // Providers orphelins
  final providersFile = File(path.join(output.path, 'orphan_providers.txt'));
  if (providersFile.existsSync()) {
      buffer.writeln('### Providers (potentiellement orphelins)');
      buffer.writeln('');
      final lines = await providersFile.readAsLines();
      bool inOrphans = false;
      for (var line in lines) {
        if (line.contains('PROVIDERS ORPHELINS:')) {
          inOrphans = true;
          buffer.writeln('```');
          continue;
        }
        if (line.contains('PROVIDERS UTILISÉS:')) {
          inOrphans = false;
          buffer.writeln('```');
          buffer.writeln('');
          break;
        }
        if (inOrphans && line.startsWith('ORPHELIN:')) {
          buffer.writeln('- $line');
        }
      }
      if (inOrphans) buffer.writeln('```');
      buffer.writeln('');
  }

  // Symboles non utilisés
  final symbolsFile = File(path.join(output.path, 'unused_symbols.txt'));
  if (symbolsFile.existsSync()) {
      buffer.writeln('### Symboles top-level non référencés');
      buffer.writeln('');
      final lines = await symbolsFile.readAsLines();
      String? currentFile;
      for (var line in lines) {
        if (line.startsWith('== Fichier:')) {
          currentFile = line.substring('== Fichier: '.length);
          continue;
        }
        if (line.startsWith(' - ') && currentFile != null) {
          buffer.writeln('- $currentFile :: $line');
        }
      }
      buffer.writeln('');
  }

  // Checklist de faux-positifs
  buffer.writeln('## Checklist de faux-positifs (à vérifier manuellement)');
  buffer.writeln('');
  buffer.writeln('- [ ] Exports via barrel files (lib/my_package.dart ou lib/src/exports.dart)');
  buffer.writeln('- [ ] Références dynamiques / reflection / usage par code généré (.g.dart, .freezed.dart)');
  buffer.writeln('- [ ] Usage uniquement dans tests, intégrations ou config dynamique');
  buffer.writeln('- [ ] Providers utilisés via .family, .notifier, ou par référence indirecte');
  buffer.writeln('- [ ] Widgets référencés via des strings (routes)');
  buffer.writeln('- [ ] Code conditionnel (asserts, platform-specific)');
  buffer.writeln('');
  buffer.writeln('## Format des marqueurs de citation');
  buffer.writeln('');
  buffer.writeln('Chaque item détecté est annoté avec un marqueur `【message_idx†source】`:');
  buffer.writeln('- `message_idx`: Identifiant de message (configurable, défaut: $messageIdx)');
  buffer.writeln('- `source`: Chemin du fichier ou `chemin:ligne` pour la position exacte');
  buffer.writeln('');
  buffer.writeln('Ces marqueurs permettent d\'agréger automatiquement les preuves dans des systèmes');
  buffer.writeln('externes (issue tracker, Notion, etc.) et de retrouver rapidement la position exacte.');
  buffer.writeln('');

  await reportFile.writeAsString(buffer.toString());
}

Future<void> generateIssueTemplates(Directory output, String messageIdx) async {
  final issuesDir = Directory(path.join(output.path, 'issues'));
  if (!issuesDir.existsSync()) {
    issuesDir.createSync(recursive: true);
  }

  // Templates pour providers orphelins
  final providersFile = File(path.join(output.path, 'orphan_providers.txt'));
  if (await providersFile.exists()) {
    final lines = await providersFile.readAsLines();
    String? currentProvider;
    String? currentFile;
    int? currentLine;
    
    for (var line in lines) {
      if (line.startsWith('ORPHELIN:')) {
        // Extraire le nom du provider et la déclaration
        final match = RegExp(r'ORPHELIN: (\w+) \(declared in (.+?):(\d+)\)').firstMatch(line);
        if (match != null) {
          currentProvider = match.group(1);
          currentFile = match.group(2);
          currentLine = int.tryParse(match.group(3) ?? '');
          
          if (currentProvider != null && currentFile != null && currentLine != null) {
            final safeName = currentProvider.replaceAll(RegExp(r'[/:]'), '_');
            final issueFile = File(path.join(issuesDir.path, 'rehydrate_orphan_provider_$safeName.md'));
            
            final content = '''# [rehydrate] Provider orphelin: $currentProvider

- **Type**: provider (Riverpod)
- **Déclaration**: $currentFile:$currentLine 【$messageIdx†$currentFile:$currentLine】
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: ${path.basename(output.path)}/orphan_providers.txt
- **Plan de ré-intégration**:
  1. Vérifier exports/barrel files et références indirectes
  2. Rechercher usages dynamiques (.family, .notifier, string-based routes)
  3. Ajouter usages/tests et réintroduire import si nécessaire
  4. Faire PR et reviewer
''';
            
            await issueFile.writeAsString(content);
          }
        }
      }
    }
  }

  // Templates pour fichiers orphelins
  final unreferencedFile = File(path.join(output.path, 'unreferenced_files.txt'));
  if (await unreferencedFile.exists()) {
    final lines = await unreferencedFile.readAsLines();
    
    for (var line in lines) {
      if (line.startsWith('Non référencé:')) {
        final match = RegExp(r'Non référencé: (.+?) 【').firstMatch(line);
        if (match != null) {
          final filePath = match.group(1);
          if (filePath != null) {
            final fileName = path.basename(filePath);
            final safeName = fileName.replaceAll(RegExp(r'[/:.]'), '_');
            final issueFile = File(path.join(issuesDir.path, 'rehydrate_orphan_file_$safeName.md'));
            
            // Lire les premières lignes du fichier pour l'extrait
            String snippet = '';
            try {
              final sourceFile = File(filePath);
              if (await sourceFile.exists()) {
                final sourceContent = await sourceFile.readAsLines();
                snippet = sourceContent.take(40).map((l) => '    $l').join('\n');
              }
            } catch (_) {
              snippet = '    (Impossible de lire le fichier)';
            }
            
            final content = '''# [rehydrate] Fichier orphelin: $filePath

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: ${path.basename(output.path)}/unreferenced_files.txt
- **Extrait du fichier**:
```dart
$snippet
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
''';
            
            await issueFile.writeAsString(content);
          }
        }
      }
    }
  }

  print('   📝 Templates d\'issues générés dans: ${issuesDir.path}');
}

// Helpers
Future<void> _collectDartFiles(Directory dir, List<File> files) async {
  await for (var entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Exclure les fichiers générés
      if (!entity.path.contains('.g.dart') && 
          !entity.path.contains('.freezed.dart')) {
        files.add(entity);
      }
    }
  }
}

Future<String> _getPackageName() async {
  final pubspec = File('pubspec.yaml');
  if (await pubspec.exists()) {
    final content = await pubspec.readAsString();
    final match = RegExp(r'^name:\s*(.+)$', multiLine: true).firstMatch(content);
    if (match != null) {
      return match.group(1)!.trim();
    }
  }
  return 'permacalendar';
}

List<String> _extractImports(String content) {
  final imports = <String>[];
  final lines = content.split('\n');
  
  for (var line in lines) {
    line = line.trim();
    if (line.startsWith('import ') || line.startsWith('export ')) {
      final match = RegExp(r'(import|export)\s+(.+?);').firstMatch(line);
      if (match != null) {
        imports.add(match.group(2)!.trim());
      }
    }
  }
  
  return imports;
}

List<SymbolInfo> _extractTopLevelSymbols(String content, String filePath) {
  final symbols = <SymbolInfo>[];
  final lines = content.split('\n');
  
  // Patterns simplifiés pour détecter les déclarations top-level
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    
    // Classes
    final classMatch = RegExp(r'^(abstract\s+)?class\s+([A-Z][A-Za-z0-9_]+)').firstMatch(line);
    if (classMatch != null) {
      symbols.add(SymbolInfo(
        name: classMatch.group(2)!,
        file: filePath,
        line: i + 1,
        kind: 'class',
      ));
      continue;
    }
    
    // Enums
    final enumMatch = RegExp(r'^enum\s+([A-Z][A-Za-z0-9_]+)').firstMatch(line);
    if (enumMatch != null) {
      symbols.add(SymbolInfo(
        name: enumMatch.group(1)!,
        file: filePath,
        line: i + 1,
        kind: 'enum',
      ));
      continue;
    }
    
    // Mixins
    final mixinMatch = RegExp(r'^mixin\s+([A-Z][A-Za-z0-9_]+)').firstMatch(line);
    if (mixinMatch != null) {
      symbols.add(SymbolInfo(
        name: mixinMatch.group(1)!,
        file: filePath,
        line: i + 1,
        kind: 'mixin',
      ));
      continue;
    }
    
    // Extensions
    final extensionMatch = RegExp(r'^extension\s+([A-Z][A-Za-z0-9_]+)?').firstMatch(line);
    if (extensionMatch != null && extensionMatch.group(1) != null) {
      symbols.add(SymbolInfo(
        name: extensionMatch.group(1)!,
        file: filePath,
        line: i + 1,
        kind: 'extension',
      ));
      continue;
    }
    
    // Top-level functions
    final functionMatch = RegExp(r'^([A-Za-z][A-Za-z0-9_<>]*)\s+([a-z][A-Za-z0-9_]+)\s*\([^)]*\)').firstMatch(line);
    if (functionMatch != null && !line.contains('=')) {
      symbols.add(SymbolInfo(
        name: functionMatch.group(2)!,
        file: filePath,
        line: i + 1,
        kind: 'function',
      ));
      continue;
    }
    
    // Top-level variables (final/const)
    final varMatch = RegExp(r'^(final|const|var)\s+([a-z][A-Za-z0-9_]+)').firstMatch(line);
    if (varMatch != null && !line.contains('(')) {
      symbols.add(SymbolInfo(
        name: varMatch.group(2)!,
        file: filePath,
        line: i + 1,
        kind: 'top-level-var',
      ));
    }
  }
  
  return symbols;
}

class ProviderInfo {
  final String name;
  final String file;
  final int line;
  final String declaration;
  
  ProviderInfo({
    required this.name,
    required this.file,
    required this.line,
    required this.declaration,
  });
}

class SymbolInfo {
  final String name;
  final String file;
  final int line;
  final String kind;
  
  SymbolInfo({
    required this.name,
    required this.file,
    required this.line,
    required this.kind,
  });
}

