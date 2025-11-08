import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:permacalendar/core/services/environment_service.dart';
import 'package:permacalendar/core/services/network_service.dart';

import '../../domain/entities/garden_context.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/weather_condition.dart';

/// Source de données distante pour l'Intelligence Végétale.
///
/// 🔌 **Rôle principal**
/// - Fournir un accès réseau sécurisé (Dio via `NetworkService`) aux APIs
///   d'intelligence végétale.
/// - Synchroniser les données locales (Hive) avec le backend lorsque
///   `EnvironmentService.isBackendEnabled` est actif.
/// - Servir de passerelle unique vers l'IA distante consommée par
///   `PlantIntelligenceRepositoryImpl`, `IntelligentRecommendationEngine`
///   et les processeurs temps-réel (`RealTimeDataProcessor`).
/// - Compléter les données issues de `plantDataSourceProvider` avant
///   synchronisation afin de conserver les identifiants cohérents côté backend.
///
/// 🧩 **Intégration Riverpod 3**
/// - Le provider `plantIntelligenceRemoteDataSourceProvider` (défini dans
///   `IntelligenceModule`) injecte l'implémentation en lecture seule via
///   `ref.read()` pour éviter tout état global.
/// - Les opérations asynchrones critiques (ex: statut de synchronisation)
///   sont exposées via un `FutureProvider.autoDispose` pour une intégration
///   directe dans l'UI sans fuite mémoire.
///
/// 🔒 **Sécurisation**
/// - Chaque appel réseau est encapsulé dans une stratégie résiliente
///   (`timeout`, `SocketException`, `NetworkException`).
/// - Retourne des valeurs sûres (listes vides, `null`, `false`) en cas
///   d'indisponibilité afin de ne jamais bloquer l'orchestrateur.
/// - Jette `PlantIntelligenceRemoteDataSourceException` pour les charges
///   utiles corrompues afin de faciliter le diagnostic et la remontée aux
///   tests.
///
/// 🧭 **Bonnes pratiques**
/// - Préférer `ref.read(IntelligenceModule.remoteSyncStatusProvider)` dans
///   les widgets pour obtenir l'état réseau actuel (`autoDispose`).
/// - Les méthodes de synchronisation peuvent être appelées depuis des
///   `AsyncNotifier` Riverpod pour profiter des mécanismes de retry.
/// - S'assurer que `EnvironmentService.initialize()` est appelé au démarrage
///   afin de charger la configuration (URL, timeouts, etc.).
abstract class PlantIntelligenceRemoteDataSource {
  // ==================== GESTION DES CONDITIONS ====================

  /// Synchronise les conditions d'une plante avec le serveur distant
  ///
  /// [condition] - Condition à synchroniser
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncPlantCondition(PlantCondition condition);

  /// Récupère les conditions d'une plante depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  ///
  /// Retourne les conditions distantes ou null si non trouvées
  Future<PlantCondition?> getRemotePlantCondition(String plantId);

  /// Récupère l'historique des conditions depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  /// [startDate] - Date de début
  /// [endDate] - Date de fin
  ///
  /// Retourne la liste des conditions historiques distantes
  Future<List<PlantCondition>> getRemotePlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
  });

  // ==================== GESTION DES RECOMMANDATIONS ====================

  /// Synchronise une recommandation avec le serveur distant
  ///
  /// [recommendation] - Recommandation à synchroniser
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncRecommendation(Recommendation recommendation);

  /// Récupère les recommandations depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  ///
  /// Retourne la liste des recommandations distantes
  Future<List<Recommendation>> getRemoteRecommendations(String plantId);

  /// Met à jour le statut d'une recommandation sur le serveur distant
  ///
  /// [recommendationId] - Identifiant de la recommandation
  /// [status] - Nouveau statut
  /// [metadata] - Métadonnées additionnelles
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> updateRemoteRecommendationStatus({
    required String recommendationId,
    required String status,
    Map<String, dynamic>? metadata,
  });

  // ==================== GESTION DES DONNÉES MÉTÉOROLOGIQUES ====================

  /// Synchronise les conditions météorologiques avec le serveur distant
  ///
  /// [weather] - Conditions météorologiques à synchroniser
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncWeatherCondition(WeatherCondition weather);

  /// Récupère les données météorologiques depuis le serveur distant
  ///
  /// [gardenId] - Identifiant du jardin
  /// [startDate] - Date de début
  /// [endDate] - Date de fin
  ///
  /// Retourne la liste des conditions météorologiques distantes
  Future<List<WeatherCondition>> getRemoteWeatherData({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
  });

  // ==================== GESTION DU CONTEXTE JARDIN ====================

  /// Synchronise le contexte d'un jardin avec le serveur distant
  ///
  /// [garden] - Contexte du jardin à synchroniser
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncGardenContext(GardenContext garden);

  /// Récupère le contexte d'un jardin depuis le serveur distant
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne le contexte du jardin distant ou null si non trouvé
  Future<GardenContext?> getRemoteGardenContext(String gardenId);

  /// Récupère tous les jardins d'un utilisateur depuis le serveur distant
  ///
  /// [userId] - Identifiant de l'utilisateur
  ///
  /// Retourne la liste des contextes de jardins distants
  Future<List<GardenContext>> getRemoteUserGardens(String userId);

  // ==================== GESTION DES ANALYSES ====================

  /// Synchronise le résultat d'une analyse avec le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse
  /// [result] - Résultat de l'analyse
  /// [confidence] - Niveau de confiance
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  });

  /// Récupère les analyses depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse (optionnel)
  ///
  /// Retourne la liste des analyses distantes
  Future<List<Map<String, dynamic>>> getRemoteAnalyses({
    required String plantId,
    String? analysisType,
  });

  // ==================== GESTION DES ALERTES ====================

  /// Synchronise une alerte avec le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  /// [alertType] - Type d'alerte
  /// [severity] - Niveau de sévérité
  /// [message] - Message de l'alerte
  /// [data] - Données additionnelles
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  });

  /// Récupère les alertes depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante (optionnel)
  /// [gardenId] - Identifiant du jardin (optionnel)
  ///
  /// Retourne la liste des alertes distantes
  Future<List<Map<String, dynamic>>> getRemoteAlerts({
    String? plantId,
    String? gardenId,
  });

  /// Marque une alerte comme résolue sur le serveur distant
  ///
  /// [alertId] - Identifiant de l'alerte
  /// [resolution] - Description de la résolution
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> resolveRemoteAlert({
    required String alertId,
    required String resolution,
  });

  // ==================== GESTION DES PRÉFÉRENCES UTILISATEUR ====================

  /// Synchronise les préférences utilisateur avec le serveur distant
  ///
  /// [userId] - Identifiant de l'utilisateur
  /// [preferences] - Préférences à synchroniser
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  });

  /// Récupère les préférences utilisateur depuis le serveur distant
  ///
  /// [userId] - Identifiant de l'utilisateur
  ///
  /// Retourne les préférences distantes ou null si non trouvées
  Future<Map<String, dynamic>?> getRemoteUserPreferences(String userId);

  // ==================== SERVICES D'INTELLIGENCE AVANCÉE ====================

  /// Demande une analyse avancée depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse demandée
  /// [inputData] - Données d'entrée pour l'analyse
  ///
  /// Retourne le résultat de l'analyse avancée
  Future<Map<String, dynamic>?> requestAdvancedAnalysis({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> inputData,
  });

  /// Récupère les recommandations personnalisées depuis le serveur distant
  ///
  /// [plantId] - Identifiant de la plante
  /// [context] - Contexte pour la personnalisation
  ///
  /// Retourne la liste des recommandations personnalisées
  Future<List<Recommendation>> getPersonalizedRecommendations({
    required String plantId,
    required Map<String, dynamic> context,
  });

  /// Envoie des données de feedback pour améliorer les algorithmes
  ///
  /// [plantId] - Identifiant de la plante
  /// [feedbackType] - Type de feedback
  /// [feedbackData] - Données de feedback
  ///
  /// Retourne true si l'envoi a réussi
  Future<bool> sendFeedback({
    required String plantId,
    required String feedbackType,
    required Map<String, dynamic> feedbackData,
  });

  // ==================== SYNCHRONISATION ET ÉTAT ====================

  /// Vérifie la connectivité avec le serveur distant
  ///
  /// Retourne true si la connexion est disponible
  Future<bool> isConnected();

  /// Obtient le statut de synchronisation
  ///
  /// Retourne un objet contenant le statut de synchronisation
  Future<SyncStatus> getSyncStatus();

  /// Force une synchronisation complète avec le serveur distant
  ///
  /// [userId] - Identifiant de l'utilisateur
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> forceFullSync(String userId);

  /// Annule une synchronisation en cours
  ///
  /// Retourne true si l'annulation a réussi
  Future<bool> cancelSync();
}

/// Statut de synchronisation avec le serveur distant
class SyncStatus {
  final bool isConnected;
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final String? lastSyncError;
  final int pendingOperations;
  final Map<String, dynamic> metadata;

  const SyncStatus({
    required this.isConnected,
    required this.isSyncing,
    this.lastSyncTime,
    this.lastSyncError,
    required this.pendingOperations,
    required this.metadata,
  });

  factory SyncStatus.fromJson(Map<String, dynamic> json) {
    return SyncStatus(
      isConnected: json['isConnected'] as bool? ?? false,
      isSyncing: json['isSyncing'] as bool? ?? false,
      lastSyncTime: _tryParseDate(json['lastSyncTime']),
      lastSyncError: json['lastSyncError'] as String?,
      pendingOperations: json['pendingOperations'] as int? ?? 0,
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : const <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() => {
        'isConnected': isConnected,
        'isSyncing': isSyncing,
        'lastSyncTime': lastSyncTime?.toIso8601String(),
        'lastSyncError': lastSyncError,
        'pendingOperations': pendingOperations,
        'metadata': metadata,
      };

  static DateTime? _tryParseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }
}

class PlantIntelligenceRemoteDataSourceImpl
    implements PlantIntelligenceRemoteDataSource {
  PlantIntelligenceRemoteDataSourceImpl({
    required NetworkService networkService,
    Duration requestTimeout = const Duration(seconds: 12),
    bool Function()? isBackendEnabled,
  })  : _networkService = networkService,
        _requestTimeout = requestTimeout,
        _isBackendEnabled = isBackendEnabled ??
            (() => EnvironmentService.isBackendEnabled);

  final NetworkService _networkService;
  final Duration _requestTimeout;
  final bool Function() _isBackendEnabled;

  // ==================== GESTION DES CONDITIONS ====================

  @override
  Future<bool> syncPlantCondition(PlantCondition condition) {
    return _executeMutation(
      operation: 'syncPlantCondition',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.plantConditions(condition.plantId),
        data: condition.toJson(),
      ),
    );
  }

  @override
  Future<PlantCondition?> getRemotePlantCondition(String plantId) {
    return _executeQuery<Map<String, dynamic>, PlantCondition?>(
      operation: 'getRemotePlantCondition',
      request: () => _networkService.get<Map<String, dynamic>>(
        _ApiRoutes.currentCondition(plantId),
      ),
      parser: (data) {
        if (data == null || data.isEmpty) {
          return null;
        }
        return PlantCondition.fromJson(
          Map<String, dynamic>.from(data),
        );
      },
      fallback: null,
    );
  }

  @override
  Future<List<PlantCondition>> getRemotePlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _executeQuery<List<dynamic>, List<PlantCondition>>(
      operation: 'getRemotePlantConditionHistory',
      request: () => _networkService.get<List<dynamic>>(
        _ApiRoutes.plantConditionHistory(plantId),
        queryParameters: _dateRangeQuery(startDate, endDate),
      ),
      parser: (data) => _mapList<PlantCondition>(
        data,
        operation: 'getRemotePlantConditionHistory',
        mapper: (json) => PlantCondition.fromJson(json),
      ),
      fallback: const <PlantCondition>[],
    );
  }

  // ==================== GESTION DES RECOMMANDATIONS ====================

  @override
  Future<bool> syncRecommendation(Recommendation recommendation) {
    return _executeMutation(
      operation: 'syncRecommendation',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.recommendations(recommendation.plantId),
        data: recommendation.toJson(),
      ),
    );
  }

  @override
  Future<List<Recommendation>> getRemoteRecommendations(String plantId) {
    return _executeQuery<List<dynamic>, List<Recommendation>>(
      operation: 'getRemoteRecommendations',
      request: () => _networkService.get<List<dynamic>>(
        _ApiRoutes.recommendations(plantId),
      ),
      parser: (data) => _mapList<Recommendation>(
        data,
        operation: 'getRemoteRecommendations',
        mapper: (json) => Recommendation.fromJson(json),
      ),
      fallback: const <Recommendation>[],
    );
  }

  @override
  Future<bool> updateRemoteRecommendationStatus({
    required String recommendationId,
    required String status,
    Map<String, dynamic>? metadata,
  }) {
    return _executeMutation(
      operation: 'updateRemoteRecommendationStatus',
      request: () => _networkService.put<dynamic>(
        _ApiRoutes.recommendationStatus(recommendationId),
        data: {
          'status': status,
          if (metadata != null) 'metadata': metadata,
        },
      ),
    );
  }

  // ==================== GESTION DES DONNÉES MÉTÉOROLOGIQUES ====================

  @override
  Future<bool> syncWeatherCondition(WeatherCondition weather) {
    return _executeMutation(
      operation: 'syncWeatherCondition',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.weatherCollection(),
        data: weather.toJson(),
      ),
    );
  }

  @override
  Future<List<WeatherCondition>> getRemoteWeatherData({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _executeQuery<List<dynamic>, List<WeatherCondition>>(
      operation: 'getRemoteWeatherData',
      request: () => _networkService.get<List<dynamic>>(
        _ApiRoutes.weather(gardenId),
        queryParameters: _dateRangeQuery(startDate, endDate),
      ),
      parser: (data) => _mapList<WeatherCondition>(
        data,
        operation: 'getRemoteWeatherData',
        mapper: (json) => WeatherCondition.fromJson(json),
      ),
      fallback: const <WeatherCondition>[],
    );
  }

  // ==================== GESTION DU CONTEXTE JARDIN ====================

  @override
  Future<bool> syncGardenContext(GardenContext garden) {
    return _executeMutation(
      operation: 'syncGardenContext',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.garden(garden.gardenId),
        data: garden.toJson(),
      ),
    );
  }

  @override
  Future<GardenContext?> getRemoteGardenContext(String gardenId) {
    return _executeQuery<Map<String, dynamic>, GardenContext?>(
      operation: 'getRemoteGardenContext',
      request: () => _networkService.get<Map<String, dynamic>>(
        _ApiRoutes.garden(gardenId),
      ),
      parser: (data) {
        if (data == null || data.isEmpty) {
          return null;
        }
        return GardenContext.fromJson(Map<String, dynamic>.from(data));
      },
      fallback: null,
    );
  }

  @override
  Future<List<GardenContext>> getRemoteUserGardens(String userId) {
    return _executeQuery<List<dynamic>, List<GardenContext>>(
      operation: 'getRemoteUserGardens',
      request: () => _networkService.get<List<dynamic>>(
        _ApiRoutes.userGardens(userId),
      ),
      parser: (data) => _mapList<GardenContext>(
        data,
        operation: 'getRemoteUserGardens',
        mapper: (json) => GardenContext.fromJson(json),
      ),
      fallback: const <GardenContext>[],
    );
  }

  // ==================== GESTION DES ANALYSES ====================

  @override
  Future<bool> syncAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  }) {
    return _executeMutation(
      operation: 'syncAnalysisResult',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.analyses(plantId),
        data: {
          'analysisType': analysisType,
          'result': result,
          'confidence': confidence,
        },
      ),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getRemoteAnalyses({
    required String plantId,
    String? analysisType,
  }) {
    return _executeQuery<List<dynamic>, List<Map<String, dynamic>>>(
      operation: 'getRemoteAnalyses',
      request: () => _networkService.get<List<dynamic>>(
        _ApiRoutes.analyses(plantId),
        queryParameters: {
          if (analysisType != null) 'analysisType': analysisType,
        },
      ),
      parser: (data) => _mapList<Map<String, dynamic>>(
        data,
        operation: 'getRemoteAnalyses',
        mapper: (json) => json,
      ),
      fallback: const <Map<String, dynamic>>[],
    );
  }

  // ==================== GESTION DES ALERTES ====================

  @override
  Future<bool> syncAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  }) {
    return _executeMutation(
      operation: 'syncAlert',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.alerts(),
        data: {
          'plantId': plantId,
          'alertType': alertType,
          'severity': severity,
          'message': message,
          if (data != null) 'data': data,
        },
      ),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getRemoteAlerts({
    String? plantId,
    String? gardenId,
  }) {
    return _executeQuery<List<dynamic>, List<Map<String, dynamic>>>(
      operation: 'getRemoteAlerts',
      request: () => _networkService.get<List<dynamic>>(
        _ApiRoutes.alerts(),
        queryParameters: {
          if (plantId != null) 'plantId': plantId,
          if (gardenId != null) 'gardenId': gardenId,
        },
      ),
      parser: (data) => _mapList<Map<String, dynamic>>(
        data,
        operation: 'getRemoteAlerts',
        mapper: (json) => json,
      ),
      fallback: const <Map<String, dynamic>>[],
    );
  }

  @override
  Future<bool> resolveRemoteAlert({
    required String alertId,
    required String resolution,
  }) {
    return _executeMutation(
      operation: 'resolveRemoteAlert',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.resolveAlert(alertId),
        data: {'resolution': resolution},
      ),
    );
  }

  // ==================== GESTION DES PRÉFÉRENCES UTILISATEUR ====================

  @override
  Future<bool> syncUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) {
    return _executeMutation(
      operation: 'syncUserPreferences',
      request: () => _networkService.put<dynamic>(
        _ApiRoutes.preferences(userId),
        data: preferences,
      ),
    );
  }

  @override
  Future<Map<String, dynamic>?> getRemoteUserPreferences(String userId) {
    return _executeQuery<Map<String, dynamic>, Map<String, dynamic>?>(
      operation: 'getRemoteUserPreferences',
      request: () => _networkService.get<Map<String, dynamic>>(
        _ApiRoutes.preferences(userId),
      ),
      parser: (data) {
        if (data == null || data.isEmpty) {
          return null;
        }
        return Map<String, dynamic>.from(data);
      },
      fallback: null,
    );
  }

  // ==================== SERVICES D'INTELLIGENCE AVANCÉE ====================

  @override
  Future<Map<String, dynamic>?> requestAdvancedAnalysis({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> inputData,
  }) {
    return _executeQuery<Map<String, dynamic>, Map<String, dynamic>?>(
      operation: 'requestAdvancedAnalysis',
      request: () => _networkService.post<Map<String, dynamic>>(
        _ApiRoutes.advancedAnalysis(plantId),
        data: {
          'analysisType': analysisType,
          'inputData': inputData,
        },
      ),
      parser: (data) => data == null ? null : Map<String, dynamic>.from(data),
      fallback: null,
    );
  }

  @override
  Future<List<Recommendation>> getPersonalizedRecommendations({
    required String plantId,
    required Map<String, dynamic> context,
  }) {
    return _executeQuery<List<dynamic>, List<Recommendation>>(
      operation: 'getPersonalizedRecommendations',
      request: () => _networkService.post<List<dynamic>>(
        _ApiRoutes.personalizedRecommendations(plantId),
        data: context,
      ),
      parser: (data) => _mapList<Recommendation>(
        data,
        operation: 'getPersonalizedRecommendations',
        mapper: (json) => Recommendation.fromJson(json),
      ),
      fallback: const <Recommendation>[],
    );
  }

  @override
  Future<bool> sendFeedback({
    required String plantId,
    required String feedbackType,
    required Map<String, dynamic> feedbackData,
  }) {
    return _executeMutation(
      operation: 'sendFeedback',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.feedback(plantId),
        data: {
          'feedbackType': feedbackType,
          'feedbackData': feedbackData,
        },
      ),
    );
  }

  // ==================== SYNCHRONISATION ET ÉTAT ====================

  @override
  Future<bool> isConnected() async {
    if (!_backendEnabled) {
      return false;
    }

    try {
      await _ensureNetworkReady();
      return await _networkService.isBackendAvailable();
    } on NetworkException catch (e) {
      _log('isConnected network exception: ${e.message}');
      return false;
    } on SocketException {
      return false;
    }
  }

  @override
  Future<SyncStatus> getSyncStatus() {
    return _executeQuery<Map<String, dynamic>, SyncStatus>(
      operation: 'getSyncStatus',
      request: () => _networkService.get<Map<String, dynamic>>(
        _ApiRoutes.syncStatus(),
      ),
      parser: (data) {
        if (data == null) {
          return const SyncStatus(
            isConnected: false,
            isSyncing: false,
            pendingOperations: 0,
            metadata: <String, dynamic>{},
          );
        }
        return SyncStatus.fromJson(Map<String, dynamic>.from(data));
      },
      fallback: const SyncStatus(
        isConnected: false,
        isSyncing: false,
        pendingOperations: 0,
        metadata: <String, dynamic>{},
      ),
      rethrowOnInvalidPayload: false,
    );
  }

  @override
  Future<bool> forceFullSync(String userId) {
    return _executeMutation(
      operation: 'forceFullSync',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.forceSync(),
        data: {'userId': userId},
      ),
    );
  }

  @override
  Future<bool> cancelSync() {
    return _executeMutation(
      operation: 'cancelSync',
      request: () => _networkService.post<dynamic>(
        _ApiRoutes.cancelSync(),
      ),
    );
  }

  // ==================== HELPERS ====================

  bool get _backendEnabled => _isBackendEnabled();

  Future<void> _ensureNetworkReady() async {
    if (!_networkService.isInitialized) {
      await _networkService.initialize();
    }
  }

  Map<String, dynamic> _dateRangeQuery(DateTime? startDate, DateTime? endDate) {
    return {
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
    };
  }

  void _log(String message) {
    EnvironmentService.log('[PlantIntelligenceRemoteDataSource] $message');
  }

  List<T> _mapList<T>(
    List<dynamic>? raw, {
    required String operation,
    required T Function(Map<String, dynamic> json) mapper,
  }) {
    if (raw == null) {
      return List<T>.unmodifiable(<T>[]);
    }

    final results = <T>[];
    for (final item in raw) {
      if (item is! Map) {
        throw PlantIntelligenceRemoteDataSourceException(
          'Invalid payload format for $operation',
          code: 'INVALID_PAYLOAD',
          originalError: item,
        );
      }
      results.add(mapper(Map<String, dynamic>.from(item as Map)));
    }

    return List<T>.unmodifiable(results);
  }

  Future<TResult> _executeQuery<TPayload, TResult>({
    required String operation,
    required Future<Response<TPayload>> Function() request,
    required TResult Function(TPayload? data) parser,
    required TResult fallback,
    bool rethrowOnInvalidPayload = true,
  }) async {
    if (!_backendEnabled) {
      return fallback;
    }

    try {
      await _ensureNetworkReady();
      final response = await request().timeout(_requestTimeout);
      return parser(response.data);
    } on TimeoutException catch (e, stackTrace) {
      _log('Timeout during $operation: $e');
      EnvironmentService.logError(
        'Timeout during $operation',
        e,
      );
      EnvironmentService.logError('StackTrace', stackTrace);
      return fallback;
    } on SocketException catch (e) {
      _log('SocketException during $operation: $e');
      return fallback;
    } on NetworkException catch (e) {
      _log('NetworkException during $operation: ${e.message}');
      return fallback;
    } on PlantIntelligenceRemoteDataSourceException {
      rethrow;
    } catch (e, stackTrace) {
      if (rethrowOnInvalidPayload) {
        throw PlantIntelligenceRemoteDataSourceException(
          'Unexpected error during $operation',
          code: 'UNEXPECTED_ERROR',
          originalError: e,
        );
      }
      EnvironmentService.logError(
        'Unexpected payload error during $operation',
        e,
      );
      EnvironmentService.logError('StackTrace', stackTrace);
      return fallback;
    }
  }

  Future<bool> _executeMutation({
    required String operation,
    required Future<Response<dynamic>> Function() request,
  }) {
    return _executeQuery<dynamic, bool>(
      operation: operation,
      request: request,
      parser: (data) {
        if (data is bool) {
          return data;
        }
        if (data is Map<String, dynamic>) {
          return data['success'] as bool? ?? data['ok'] as bool? ?? true;
        }
        return true;
      },
      fallback: false,
      rethrowOnInvalidPayload: false,
    );
  }
}

class _ApiRoutes {
  static const String base = '/plant-intelligence';

  static String plant(String plantId) => '$base/plants/$plantId';
  static String plantConditions(String plantId) => '${plant(plantId)}/conditions';
  static String currentCondition(String plantId) => '${plantConditions(plantId)}/current';
  static String plantConditionHistory(String plantId) => '${plantConditions(plantId)}/history';
  static String recommendations(String plantId) => '${plant(plantId)}/recommendations';
  static String recommendationStatus(String recommendationId) => '$base/recommendations/$recommendationId/status';
  static String weatherCollection() => '$base/weather';
  static String weather(String gardenId) => '$base/gardens/$gardenId/weather';
  static String garden(String gardenId) => '$base/gardens/$gardenId';
  static String userGardens(String userId) => '$base/users/$userId/gardens';
  static String analyses(String plantId) => '${plant(plantId)}/analyses';
  static String alerts() => '$base/alerts';
  static String resolveAlert(String alertId) => '${alerts()}/$alertId/resolve';
  static String preferences(String userId) => '$base/users/$userId/preferences';
  static String advancedAnalysis(String plantId) => '${plant(plantId)}/analyses/advanced';
  static String personalizedRecommendations(String plantId) => '${plant(plantId)}/recommendations/personalized';
  static String feedback(String plantId) => '${plant(plantId)}/feedback';
  static String syncStatus() => '$base/sync/status';
  static String forceSync() => '$base/sync/force';
  static String cancelSync() => '$base/sync/cancel';
}

/// Exception pour les erreurs de la source de données distante
class PlantIntelligenceRemoteDataSourceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const PlantIntelligenceRemoteDataSourceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    final codeStr = code != null ? ' [$code]' : '';
    return 'PlantIntelligenceRemoteDataSourceException$codeStr: $message';
  }
}
