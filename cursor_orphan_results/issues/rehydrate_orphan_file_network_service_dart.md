# [rehydrate] Fichier orphelin: lib/core/services/network_service.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:dio/dio.dart';
    import 'package:flutter/foundation.dart';
    import 'package:permacalendar/core/services/environment_service.dart';
    
    /// Service réseau pour la communication avec le backend
    /// Préparé pour l'intégration future avec Hostinger
    class NetworkService {
      static NetworkService? _instance;
      static NetworkService get instance => _instance ??= NetworkService._();
    
      NetworkService._();
    
      late Dio _dio;
    
      /// Initialise le service réseau
      Future<void> initialize() async {
        _dio = Dio();
    
        // Configuration de base
        _dio.options = BaseOptions(
          baseUrl: EnvironmentService.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
    
        // Intercepteurs pour le debug et l'authentification
        if (EnvironmentService.isDebugMode) {
          _dio.interceptors.add(LogInterceptor(
            requestBody: true,
            responseBody: true,
            logPrint: (obj) => debugPrint(obj.toString()),
          ));
        }
    
        // Intercepteur d'authentification (préparé pour le futur)
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
