import 'package:riverpod/riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provider d'état pour la commune sélectionnée (stockée localement via Hive)
final selectedCommuneProvider =
    NotifierProvider<SelectedCommuneNotifier, String?>(
        SelectedCommuneNotifier.new);

class SelectedCommuneNotifier extends Notifier<String?> {
  static const String _boxName = 'settings';
  static const String _keySelectedCommune = 'selected_commune_name';

  Box<dynamic>? _box;

  @override
  String? build() {
    _initialize();
    return null;
  }

  Future<void> _initialize() async {
    try {
      _box = await Hive.openBox<dynamic>(_boxName);
      final saved = _box!.get(_keySelectedCommune) as String?;
      if (saved != null) {
        state = saved;
      }
    } catch (_) {
      // Ignorer les erreurs d'ouverture; état par défaut = null
    }
  }

  Future<void> setCommune(String communeName) async {
    state = communeName;
    try {
      final box = _box ?? await Hive.openBox<dynamic>(_boxName);
      await box.put(_keySelectedCommune, communeName);
    } catch (_) {
      // Ignorer les erreurs d'écriture
    }
  }
}


