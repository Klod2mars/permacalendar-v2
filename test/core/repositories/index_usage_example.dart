/// Exemple d'utilisation des exports du fichier index.dart
/// 
/// Ce fichier démontre comment utiliser les repositories exportés
/// depuis un module externe (ex: features/, services/, etc.)
/// 
/// Pour utiliser ce snippet :
/// 1. Copiez les imports dans votre fichier
/// 2. Utilisez les classes comme montré dans les exemples

// ✅ Import unique depuis l'index (recommandé)
import 'package:permacalendar/core/repositories/index.dart';

// Alternative : imports directs (non recommandé, mais possible)
// import 'package:permacalendar/core/repositories/garden_repository.dart';
// import 'package:permacalendar/core/repositories/garden_hive_repository.dart';
// import 'package:permacalendar/core/repositories/garden_rules.dart';
// import 'package:permacalendar/core/repositories/garden_helpers.dart';
// import 'package:permacalendar/core/repositories/repository_providers.dart';

void exampleUsage() {
  // ✅ Exemple 1 : Utilisation de GardenRepository
  final gardenRepository = GardenRepository();
  final gardens = gardenRepository.getGardens();
  print('Nombre de jardins: ${gardens.length}');

  // ✅ Exemple 2 : Utilisation de GardenHiveRepository
  // final hiveRepository = GardenHiveRepository();
  // Note: N'oubliez pas d'initialiser Hive avant d'utiliser
  // await GardenHiveRepository.initialize();

  // ✅ Exemple 3 : Utilisation de GardenRules
  final gardenRules = GardenRules();
  final canCreate = gardenRules.canCreateNewGarden(gardens);
  print('Peut créer un nouveau jardin: $canCreate');

  // ✅ Exemple 4 : Utilisation de GardenHelpers (méthodes statiques)
  final totalArea = GardenHelpers.calculateTotalGardenArea(gardens);
  final largestGarden = GardenHelpers.getLargestGarden(gardens);
  print('Superficie totale: $totalArea m²');
  print('Plus grand jardin: ${largestGarden?.name}');

  // ✅ Exemple 5 : Utilisation avec Riverpod Provider
  // Dans un widget ou service utilisant Riverpod :
  // final repository = ref.read(gardenRepositoryProvider);
  // final gardens = await repository.getAllGardens();

  // ✅ Exemple 6 : Gestion des exceptions
  // Note: Cette fonction doit être async pour utiliser await
  // try {
  //   await gardenRepository.createGarden(/* garden */);
  // } on GardenValidationException catch (e) {
  //   print('Erreur de validation: $e');
  // } on GardenLimitException catch (e) {
  //   print('Limite atteinte: $e');
  // } on GardenNotFoundException catch (e) {
  //   print('Jardin non trouvé: $e');
  // } on GardenHiveException catch (e) {
  //   print('Erreur Hive: $e');
  // }

  // ✅ Exemple 7 : Utilisation de ValidationResult
  final validation = gardenRules.validateGardenCount(gardens);
  if (validation.isValid) {
    print('Validation OK');
  } else {
    print('Erreur: ${validation.errorMessage}');
  }
}

/// Exemple d'utilisation dans un service
class ExampleGardenService {
  final GardenRepository _repository;
  final GardenRules _rules;

  ExampleGardenService({
    GardenRepository? repository,
    GardenRules? rules,
  })  : _repository = repository ?? GardenRepository(),
        _rules = rules ?? GardenRules();

  Future<bool> createGardenWithValidation(/* Garden garden */) async {
    final existingGardens = _repository.getGardens();
    
    // Validation avec GardenRules
    final canCreate = _rules.canCreateNewGarden(existingGardens);
    if (!canCreate) {
      return false;
    }

    // Création avec GardenRepository
    // return await _repository.createGarden(garden);
    return true;
  }
}

/// Exemple d'utilisation dans un widget avec Riverpod
/// 
/// ```dart
/// class GardenListWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final repository = ref.read(gardenRepositoryProvider);
///     
///     return FutureBuilder<List<GardenFreezed>>(
///       future: repository.getAllGardens(),
///       builder: (context, snapshot) {
///         if (snapshot.hasData) {
///           return ListView.builder(
///             itemCount: snapshot.data!.length,
///             itemBuilder: (context, index) {
///               return Text(snapshot.data![index].name);
///             },
///           );
///         }
///         return CircularProgressIndicator();
///       },
///     );
///   }
/// }
/// ```

