## gardenBedProvider
defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311
usages: 13
provider_type: NotifierProvider

### Before (excerpt)
`dart
  }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});

`"
  ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 += "

  if (    FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});
) {
    ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 += 
_first call_: lib\features\garden_bed\providers\garden_bed_scoped_provider.dart:17
`dart
    FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});

`"
    ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 `"
  ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 += "

  if (    FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});
) {
    ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 +=  _first call_: lib\features\garden_bed\providers\garden_bed_scoped_provider.dart:17 `dart     FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});
 += "
  }

  ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 `"
  ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 += "

  if (    FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});
) {
    ## gardenBedProvider defined_in: lib\features\garden_bed\providers\garden_bed_provider.dart:311 usages: 13 provider_type: NotifierProvider  ### Before (excerpt) `dart   }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});
 +=  _first call_: lib\features\garden_bed\providers\garden_bed_scoped_provider.dart:17 `dart     FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});
 += 
1. Convert the provider definition to $familyType and add a positional parameter in the closure: (ref, param) => ....
2. Thread the new parameter through the provider logic (state, repository lookups, keys) so each invocation is scoped correctly.
3. Update every ef.watch/ef.read call to pass the parameter explicitly (e.g. ef.watch(gardenBedProvider(param))).
4. Adjust any helper methods or widgets that previously consumed $prov to accept and forward the parameter.
5. Add or update tests that cover at least two parameter values to confirm the .family conversion.

### Review checklist
- [ ] Ensure the parameter type is explicit in the .family generics.
- [ ] Confirm no lingering zero-argument usages remain.
- [ ] Consider memoization or caching impacts after .family migration.

