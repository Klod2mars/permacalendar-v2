import 'package:riverpod/riverpod.dart';

/// Notifier qui garde l'ID du jardin "actif".
/// Usage attendu :
///   ref.watch(activeGardenIdProvider);
///   ref.read(activeGardenIdProvider.notifier).setActiveGarden(gardenId);
class ActiveGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  /// Définit le jardin actif (ID)
  void setActiveGarden(String gardenId) {
    state = gardenId;
  }

  /// Efface la sélection
  void clear() {
    state = null;
  }
}

/// Provider exposant l'ID du jardin actif (String?).
final activeGardenIdProvider = NotifierProvider<ActiveGardenIdNotifier, String?>(ActiveGardenIdNotifier.new);


