import 'package:riverpod/riverpod.dart';
import '../services/network_service.dart';

/// Module d'injection de dépendances pour le service réseau
///
/// Ce module centralise la configuration et l'injection du NetworkService
/// pour la communication avec le backend.
///
/// **Architecture :**
/// ```
/// NetworkService
///   └─→ Dio (client HTTP)
///        ├─→ RetryInterceptor (retry automatique)
///        ├─→ LogInterceptor (debug uniquement)
///        └─→ AuthInterceptor (préparé pour le futur)
///        └─→ EnvironmentService (configuration)
/// ```
///
/// **Usage de base :**
/// ```dart
/// // Dans un widget ou un provider
/// final networkService = ref.read(NetworkModule.networkServiceProvider);
/// await networkService.initialize();
/// 
/// // Vérifier la disponibilité du backend
/// final isAvailable = await networkService.isBackendAvailable();
/// 
/// // Faire une requête GET
/// try {
///   final response = await networkService.get<Map<String, dynamic>>('/api/data');
///   print(response.data);
/// } on NetworkException catch (e) {
///   print('Erreur réseau: ${e.message}');
/// }
/// ```
///
/// **Usage avec FutureProvider :**
/// ```dart
/// final dataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
///   final networkService = ref.read(NetworkModule.networkServiceProvider);
///   await networkService.initialize();
///   
///   final response = await networkService.get<Map<String, dynamic>>('/api/data');
///   return response.data ?? {};
/// });
/// ```
///
/// **Gestion des erreurs :**
/// ```dart
/// try {
///   final response = await networkService.post('/api/users', data: userData);
/// } on NetworkException catch (e) {
///   switch (e.type) {
///     case NetworkExceptionType.timeout:
///       // Gérer le timeout
///       break;
///     case NetworkExceptionType.unauthorized:
///       // Rediriger vers la page de connexion
///       break;
///     case NetworkExceptionType.serverError:
///       // Afficher un message d'erreur serveur
///       break;
///     default:
///       // Gérer les autres erreurs
///   }
/// }
/// ```
///
/// **Initialisation :**
/// Le service doit être initialisé avant utilisation. L'initialisation configure :
/// - La base URL depuis `EnvironmentService.apiBaseUrl`
/// - Les timeouts depuis `EnvironmentService.apiTimeout`
/// - Les intercepteurs (retry, logging, auth)
///
/// **Retry automatique :**
/// Le service réessaie automatiquement les requêtes échouant avec :
/// - Timeouts (connection, send, receive)
/// - Erreurs serveur (5xx)
/// - Erreurs de connexion
///
/// Stratégie : 3 tentatives maximum avec backoff exponentiel (1s, 2s, 4s)
class NetworkModule {
  NetworkModule._(); // Private constructor pour empêcher l'instanciation

  /// Provider pour le service réseau
  ///
  /// **Responsabilité :**
  /// - Gestion des requêtes HTTP (GET, POST, PUT, DELETE)
  /// - Upload de fichiers
  /// - Gestion des erreurs réseau avec types spécifiques
  /// - Retry automatique sur erreurs temporaires (3 tentatives max)
  /// - Authentification (préparé pour le futur)
  /// - Logging en mode debug
  ///
  /// **Méthodes disponibles :**
  /// - `initialize()` : Initialise le service (obligatoire avant utilisation)
  /// - `isBackendAvailable()` : Vérifie la disponibilité du backend
  /// - `get<T>(path, ...)` : Requête GET
  /// - `post<T>(path, data, ...)` : Requête POST
  /// - `put<T>(path, data, ...)` : Requête PUT
  /// - `delete<T>(path, ...)` : Requête DELETE
  /// - `uploadFile<T>(path, filePath, ...)` : Upload de fichier
  ///
  /// **Note importante :**
  /// Le service doit être initialisé via `initialize()` avant toute utilisation.
  /// L'initialisation configure Dio avec les intercepteurs et la base URL.
  ///
  /// **Exemple complet :**
  /// ```dart
  /// class MyRepository {
  ///   final NetworkService _networkService;
  ///
  ///   MyRepository(this._networkService);
  ///
  ///   Future<List<User>> getUsers() async {
  ///     await _networkService.initialize();
  ///     final response = await _networkService.get<List<dynamic>>('/users');
  ///     return (response.data ?? []).map((json) => User.fromJson(json)).toList();
  ///   }
  /// }
  ///
  /// // Dans un provider
  /// final myRepositoryProvider = Provider<MyRepository>((ref) {
  ///   final networkService = ref.read(NetworkModule.networkServiceProvider);
  ///   return MyRepository(networkService);
  /// });
  /// ```
  static final networkServiceProvider = Provider<NetworkService>((ref) {
    return NetworkService();
  });
}

