import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import '../../app_router.dart';
import '../../core/models/organic_zone_config.dart';
import '../../core/providers/organic_zones_provider.dart';
import '../../core/models/calibration_state.dart';
import '../widgets/calibration_debug_overlay.dart';
import '../../core/repositories/dashboard_slots_repository.dart'; // Nouvel import
import '../../core/providers/active_garden_provider.dart'; // Nouvel import

/// OrganicDashboardWidget ...
/// (le reste du fichier est inchangé jusqu'à la méthode _handleGardenTap)
/// ...
  void _handleGardenTap() async {
    // Convertir l'ID texte ("garden_3") en entier (3)
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) {
      print('DBG: Slot invalide pour id=${widget.id}');
      return;
    }

    final gardenId = await DashboardSlotsRepository.getGardenIdForSlot(slot);

    if (gardenId != null) {
      // Debug log utile pour diagnostiquer les slots problématiques
      if (kDebugMode) {
        debugPrint('DEBUG TAP_CALIB: slot=$slot -> gardenId=$gardenId');
      }

      // Naviguer vers le jardin existant avec le paramètre fromOrganic (booléen 'true')
      widget.ref.read(gardenProvider.notifier).selectGarden(gardenId);
      context.push('/gardens/$gardenId?fromOrganic=true');
    } else {
      // Ouvrir la création de jardin avec le slot numérique correct
      context.push('/gardens/create?slot=$slot');
    }
  }
