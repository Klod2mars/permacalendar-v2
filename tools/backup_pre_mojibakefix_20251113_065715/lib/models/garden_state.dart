ï»¿import 'package:freezed_annotation/freezed_annotation.dart';
import 'garden_freezed.dart';

part 'garden_state.freezed.dart';

@freezed
class GardenState with _$GardenState {
  const GardenState._(); // Constructeur privé pour permettre les getters

  const factory GardenState({
    @Default(false) bool isLoading,
    @Default([]) List<GardenFreezed> gardens,
    String? error,
    GardenFreezed? selectedGarden,
  }) = _GardenState;

  // État initial
  factory GardenState.initial() => const GardenState();

  // État de chargement
  factory GardenState.loading() => const GardenState(isLoading: true);

  // État avec erreur
  factory GardenState.error(String error) => GardenState(error: error);

  // État avec données
  factory GardenState.loaded(List<GardenFreezed> gardens) =>
      GardenState(gardens: gardens);

  // GETTERS CRITIQUES - Intégrés directement dans la classe
  /// Vérifie si l'état est en erreur
  bool get hasError => error != null;

  /// Vérifie si l'état contient des données
  bool get hasData => gardens.isNotEmpty;

  /// Vérifie si on peut ajouter un nouveau jardin (limite de 5)
  bool get canAddGarden => activeGardens.length < 5;

  /// Nombre de jardins actifs
  int get activeGardensCount => activeGardens.length;

  /// Jardins actifs seulement
  List<GardenFreezed> get activeGardens =>
      gardens.where((g) => g.isActive).toList();

  /// MÉTHODE UTILITAIRE
  /// Trouve un jardin par son ID
  GardenFreezed? findGardenById(String id) {
    try {
      return gardens.firstWhere((garden) => garden.id == id);
    } catch (e) {
      return null;
    }
  }
}


