import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:permacalendar/core/services/environment_service.dart';

/// Service réseau pour la communication avec le backend
///
/// **Responsabilité :**
/// - Gestion des requêtes HTTP (GET, POST, PUT, DELETE)
/// - Upload de fichiers
/// - Gestion des erreurs réseau avec retry automatique
/// - Authentification (préparé pour le futur)
/// - Logging en mode debug
///
/// **Architecture :**
/// Utilise Dio comme client HTTP avec intercepteurs pour :
/// - Logging (mode debug uniquement)
/// - Authentification (Bearer token - préparé)
/// - Retry automatique sur erreurs temporaires
///
/// **Usage avec Riverpod :**
/// ```dart
/// final networkService = ref.read(NetworkModule.networkServiceProvider);
/// await networkService.initialize();
/// final response = await networkService.get('/api/data');
/// ```
///
/// **Gestion des erreurs :**
/// Toutes les erreurs sont converties en `NetworkException` avec un type
/// spécifique (timeout, connectionError, badRequest, etc.)
///
/// **Retry automatique :**
/// Les requêtes échouant avec des erreurs temporaires (timeout, 5xx)
/// sont automatiquement réessayées jusqu'à 3 fois avec backoff exponentiel.
class NetworkService {
  NetworkService();

  late Dio _dio;
  bool _initialized = false;

  /// Initialise le service réseau
  ///
  /// **Doit être appelé avant toute utilisation du service.**
  ///
  /// Configure Dio avec :
  /// - Base URL depuis EnvironmentService
  /// - Timeouts (30 secondes par défaut)
  /// - Intercepteurs (logging, auth, retry)
  Future<void> initialize() async {
    if (_initialized) return;

    _dio = Dio();

    // Configuration de base
    final timeout = Duration(
      milliseconds: EnvironmentService.apiTimeout,
    );

    _dio.options = BaseOptions(
      baseUrl: EnvironmentService.apiBaseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Intercepteur de retry pour les erreurs temporaires
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
      ),
    );

    // Intercepteurs pour le debug
    if (EnvironmentService.isDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }

    // Intercepteur d'authentification (préparé pour le futur)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TODO: Ajouter le token d'authentification quand disponible
        // final token = await AuthService.getToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Gestion des erreurs d'authentification
        if (error.response?.statusCode == 401) {
          // TODO: Gérer l'expiration du token
          // await AuthService.refreshToken();
        }
        handler.next(error);
      },
    ));

    _initialized = true;
  }

  /// Vérifie si le service est initialisé
  bool get isInitialized => _initialized;

  /// Vérifie que le service est initialisé, sinon lance une exception
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'NetworkService must be initialized before use. '
        'Call initialize() first.',
      );
    }
  }

  /// Vérifie si le backend est disponible
  ///
  /// Effectue une requête GET sur `/health` pour vérifier la disponibilité.
  ///
  /// **Retourne :**
  /// - `true` si le backend répond avec un status 200
  /// - `false` si le backend est désactivé, non disponible ou en erreur
  Future<bool> isBackendAvailable() async {
    if (!EnvironmentService.isBackendEnabled) return false;
    _ensureInitialized();

    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// GET request générique
  ///
  /// **Paramètres :**
  /// - `path` : Chemin de l'endpoint (relatif à la base URL)
  /// - `queryParameters` : Paramètres de requête optionnels
  /// - `options` : Options Dio supplémentaires
  ///
  /// **Retourne :** `Response<T>` avec les données typées
  ///
  /// **Lance :** `NetworkException` en cas d'erreur
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInitialized();
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request générique
  ///
  /// **Paramètres :**
  /// - `path` : Chemin de l'endpoint (relatif à la base URL)
  /// - `data` : Données à envoyer dans le body
  /// - `queryParameters` : Paramètres de requête optionnels
  /// - `options` : Options Dio supplémentaires
  ///
  /// **Retourne :** `Response<T>` avec les données typées
  ///
  /// **Lance :** `NetworkException` en cas d'erreur
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInitialized();
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request générique
  ///
  /// **Paramètres :**
  /// - `path` : Chemin de l'endpoint (relatif à la base URL)
  /// - `data` : Données à envoyer dans le body
  /// - `queryParameters` : Paramètres de requête optionnels
  /// - `options` : Options Dio supplémentaires
  ///
  /// **Retourne :** `Response<T>` avec les données typées
  ///
  /// **Lance :** `NetworkException` en cas d'erreur
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInitialized();
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request générique
  ///
  /// **Paramètres :**
  /// - `path` : Chemin de l'endpoint (relatif à la base URL)
  /// - `data` : Données à envoyer dans le body (optionnel)
  /// - `queryParameters` : Paramètres de requête optionnels
  /// - `options` : Options Dio supplémentaires
  ///
  /// **Retourne :** `Response<T>` avec les données typées
  ///
  /// **Lance :** `NetworkException` en cas d'erreur
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInitialized();
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload de fichier
  ///
  /// **Paramètres :**
  /// - `path` : Chemin de l'endpoint (relatif à la base URL)
  /// - `filePath` : Chemin local du fichier à uploader
  /// - `fieldName` : Nom du champ dans le FormData (défaut: 'file')
  /// - `data` : Données supplémentaires à envoyer
  /// - `onSendProgress` : Callback pour suivre la progression de l'upload
  ///
  /// **Retourne :** `Response<T>` avec les données typées
  ///
  /// **Lance :** `NetworkException` en cas d'erreur
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    _ensureInitialized();
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Gestion des erreurs Dio
  NetworkException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Timeout de connexion',
          type: NetworkExceptionType.timeout,
          originalError: e,
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final responseData = e.response?.data;
        
        // Essayer d'extraire le message d'erreur depuis différentes structures
        String message = 'Erreur serveur';
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] as String? ??
              responseData['error'] as String? ??
              responseData['detail'] as String? ??
              message;
        } else if (responseData is String) {
          message = responseData;
        }

        return NetworkException(
          message,
          type: _getExceptionTypeFromStatusCode(statusCode),
          statusCode: statusCode,
          originalError: e,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          'Requête annulée',
          type: NetworkExceptionType.cancelled,
          originalError: e,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          'Erreur de connexion',
          type: NetworkExceptionType.connectionError,
          originalError: e,
        );
    }
  }

  NetworkExceptionType _getExceptionTypeFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return NetworkExceptionType.badRequest;
      case 401:
        return NetworkExceptionType.unauthorized;
      case 403:
        return NetworkExceptionType.forbidden;
      case 404:
        return NetworkExceptionType.notFound;
      case 500:
      case 502:
      case 503:
      case 504:
        return NetworkExceptionType.serverError;
      default:
        return NetworkExceptionType.unknown;
    }
  }
}

/// Intercepteur Dio pour retry automatique sur erreurs temporaires
///
/// **Stratégie de retry :**
/// - Retry uniquement sur erreurs temporaires (timeout, 5xx)
/// - Backoff exponentiel entre les tentatives
/// - Maximum 3 tentatives par défaut
class RetryInterceptor extends Interceptor {
  final int retries;
  final List<Duration> retryDelays;
  final Dio dio;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    required this.retryDelays,
  }) : assert(
          retryDelays.length == retries,
          'retryDelays must have the same length as retries',
        );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    // Vérifier si on peut retry
    if (retryCount < retries && _shouldRetry(err)) {
      final delay = retryDelays[retryCount];

      // Attendre avant de retry
      await Future.delayed(delay);

      // Mettre à jour le compteur de retry
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      // Réessayer la requête
      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Si le retry échoue, continuer avec l'erreur
        if (e is DioException) {
          handler.next(e);
        } else {
          handler.next(err);
        }
        return;
      }
    }

    // Pas de retry possible, passer l'erreur
    handler.next(err);
  }

  /// Vérifie si l'erreur justifie un retry
  bool _shouldRetry(DioException err) {
    // Retry sur timeouts
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry sur erreurs serveur (5xx)
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return true;
    }

    // Retry sur erreurs de connexion
    if (err.type == DioExceptionType.connectionError) {
      return true;
    }

    return false;
  }
}

/// Exception réseau personnalisée
class NetworkException implements Exception {
  final String message;
  final NetworkExceptionType type;
  final int? statusCode;
  final DioException? originalError;

  const NetworkException(
    this.message, {
    required this.type,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Types d'exceptions réseau
enum NetworkExceptionType {
  timeout,
  connectionError,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  serverError,
  cancelled,
  unknown,
}
