# Script de Migration Notifiers Riverpod 3

## Fichiers à migrer

### DÉJÀ FAIT ✅
1. ✅ lib/core/providers/activity_tracker_v3_provider.dart (AsyncNotifier)
2. ✅ lib/features/plant_catalog/providers/plant_catalog_provider.dart  
3. ✅ lib/features/weather/providers/commune_provider.dart

### EN COURS
4. lib/features/garden/providers/garden_provider.dart
5. lib/features/garden_bed/providers/garden_bed_provider.dart
6. lib/features/planting/providers/planting_provider.dart
7. lib/features/planting/providers/germination_provider.dart (AsyncNotifier)
8. lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart
9. lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart
10. lib/features/plant_intelligence/presentation/providers/notification_providers.dart (AsyncNotifier)
11. lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart
12. lib/features/plant_intelligence/presentation/providers/garden_context_sync_provider.dart

## Patterns de migration

### Pattern 1: StateNotifier<T> → Notifier<T>
```dart
// AVANT
class MyNotifier extends StateNotifier<MyState> {
  MyNotifier() : super(MyState.initial());
}

// APRÈS
class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() => MyState.initial();
}
```

### Pattern 2: StateNotifier<AsyncValue<T>> → AsyncNotifier<T>
```dart
// AVANT
class MyNotifier extends StateNotifier<AsyncValue<List<Item>>> {
  MyNotifier() : super(const AsyncValue.loading()) {
    _load();
  }
  
  Future<void> _load() async {
    try {
      final data = await loadData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// APRÈS
class MyNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() async {
    return await loadData();
  }
}
```

### Pattern 3: StateNotifierProvider → NotifierProvider
```dart
// AVANT
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

// APRÈS
final myProvider = NotifierProvider<MyNotifier, MyState>(MyNotifier.new);

// Si besoin de ref
final myProvider = NotifierProvider<MyNotifier, MyState>(() {
  return MyNotifier(ref: ref);
});
```

### Pattern 4: StateNotifierProvider<X, AsyncValue<T>> → AsyncNotifierProvider
```dart
// AVANT
final myProvider = StateNotifierProvider<MyNotifier, AsyncValue<List<Item>>>((ref) {
  return MyNotifier();
});

// APRÈS
final myProvider = AsyncNotifierProvider<MyNotifier, List<Item>>(() {
  return MyNotifier();
});
```

## Points d'attention

1. **Champs privés** : Les anciens notifiers avaient souvent des champs privés (_repository, etc.) 
   → Dans Riverpod 3, utiliser `ref.read(provider)` dans les méthodes

2. **Initialisation** : StateNotifier appelait souvent du code sync dans le constructeur
   → Dans Riverpod 3, utiliser `build()` qui est appelé de manière sécurisée

3. **AsyncNotifier** : Si le State utilise AsyncValue, migrer vers AsyncNotifier
   → Supprimer les `AsyncValue.loading()`, `AsyncValue.data()`, etc.
   → `build()` retourne directement la valeur, pas un AsyncValue

4. **Family providers** : StateNotifierProvider.family → NotifierProvider.family

5. **Constructor with ref** : Si besoin d'accéder à ref dans le constructeur
   → Passer ref explicitement ou utiliser NotifierProvider(() => MyNotifier())

