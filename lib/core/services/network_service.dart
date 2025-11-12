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
  }

  /// Vérifie si le backend est disponible
  Future<bool> isBackendAvailable() async {
    if (!EnvironmentService.isBackendEnabled) return false;

    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// GET request générique
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
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
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
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
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
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
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
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
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
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
        final message = e.response?.data?['message'] ?? 'Erreur serveur';

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
        return NetworkExceptionType.serverError;
      default:
        return NetworkExceptionType.unknown;
    }
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

