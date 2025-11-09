/// Exemple d'utilisation des exports du fichier index.dart
/// 
/// Ce fichier dÃ©montre comment utiliser les repositories exportÃ©s
/// depuis un module externe (ex: features/, services/, etc.)
/// 
/// Pour utiliser ce snippet :
/// 1. Copiez les imports dans votre fichier
/// 2. Utilisez les classes comme montrÃ© dans les exemples

// âœ… Import unique depuis l'index (recommandÃ©)

import '../../test_setup_stub.dart';

import 'package:permacalendar/core/repositories/index.dart';

// Alternative : imports directs (non recommandÃ©, mais possible)
// import 'package:permacalendar/core/repositories/garden_repository.dart';
// import 'package:permacalendar/core/repositories/garden_hive_repository.dart';
// import 'package:permacalendar/core/repositories/garden_rules.dart';
// import 'package:permacalendar/core/repositories/garden_helpers.dart';
// import 'package:permacalendar/core/repositories/repository_providers.dart';

void exampleUsage() {
  // âœ… Exemple 1 : Utilisation de GardenRepository
  final gardenRepository = GardenRepository();
  final gardens = gardenRepository.getGardens();
  print('Nombre de jardins: ${gardens.length}');

  // âœ… Exemple 2 : Utilisation de GardenHiveRepository
  // final hiveRepository = GardenHiveRepository();
  // Note: N'oubliez pas d'initialiser Hive avant d'utiliser
  // await GardenHiveRepository.initialize();

  // âœ… Exemple 3 : Utilisation de GardenRules
  final gardenRules = GardenRules();
  final canCreate = gardenRules.canCreateNewGarden(gardens);
  print('Peut crÃ©er un nouveau jardin: $canCreate');

  // âœ… Exemple 4 : Utilisation de GardenHelpers (mÃ©thodes statiques)
  final totalArea = GardenHelpers.calculateTotalGardenArea(gardens);
  final largestGarden = GardenHelpers.getLargestGarden(gardens);
  print('Superficie totale: $totalArea mÂ²');
  print('Plus grand jardin: ${largestGarden?.name}');

  // âœ… Exemple 5 : Utilisation avec Riverpod Provider
  // Dans un widget ou service utilisant Riverpod :
  // final repository = ref.read(gardenRepositoryProvider);
  // final gardens = await repository.getAllGardens();

  // âœ… Exemple 6 : Gestion des exceptions
  // Note: Cette fonction doit Ãªtre async pour utiliser await
  // try {
  //   await gardenRepository.createGarden(/* garden */);
  // } on GardenValidationException catch (e) {
  //   print('Erreur de validation: $e');
  // } on GardenLimitException catch (e) {
  //   print('Limite atteinte: $e');
  // } on GardenNotFoundException catch (e) {
  //   print('Jardin non trouvÃ©: $e');
  // } on GardenHiveException catch (e) {
  //   print('Erreur Hive: $e');
  // }

  // âœ… Exemple 7 : Utilisation de ValidationResult
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

    // CrÃ©ation avec GardenRepository
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


