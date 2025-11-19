*** Fichier: lib/features/home/widgets/invisible_garden_zone.dart
@@
import '../../../core/repositories/dashboard_slots_repository.dart';
+import '../../../core/data/hive/garden_boxes.dart';
+import '../../../core/adapters/garden_migration_adapters.dart';
import 'package:permacalendar/app_router.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:flutter/material.dart';
@@
   /// Récupère le jardin associé à ce slot
   /// Dans le nouveau système, on utilise l'ordre des jardins pour les associer aux slots
   GardenFreezed? _getGardenForSlot(WidgetRef ref) {
     final gardenState = ref.watch(gardenProvider);
 
     final activeGardens = gardenState.activeGardens;
 
     // 1) Si la box dashboard_slots est prête, tenter la lecture persistante (prévalente)
 
     final mappedId =
         DashboardSlotsRepository.getGardenIdForSlotSync(widget.slotNumber);
 
     if (mappedId != null) {
       final matches = activeGardens.where((g) => g.id == mappedId).toList();
 
       if (matches.isNotEmpty) return matches.first;
 
-      // mappedId existe mais jardin non chargé -> fallback index
+      // mappedId existe mais jardin non chargé -> tenter résolution legacy (synchronique)
+      // Si l'ID pointe vers un ancien modèle Garden (box 'gardens'), on le récupère
+      // et le convertit en GardenFreezed via GardenMigrationAdapters.
+      try {
+        final legacyGarden = GardenBoxes.getGarden(mappedId);
+        if (legacyGarden != null) {
+          return GardenMigrationAdapters.fromLegacy(legacyGarden);
+        }
+      } catch (e) {
+        // Logging léger ; on continue le fallback index ci-dessous
+        debugPrint('[InvisibleGardenZone] legacy lookup failed for $mappedId: $e');
+      }
+
+      // mappedId existe mais jardin non chargé -> fallback index
     }
 
     // 2) Fallback : associer les jardins actifs aux slots par ordre d'index (ancienne logique)
 
     if (widget.slotNumber > 0 && widget.slotNumber <= activeGardens.length) {
       return activeGardens[widget.slotNumber - 1];
     }