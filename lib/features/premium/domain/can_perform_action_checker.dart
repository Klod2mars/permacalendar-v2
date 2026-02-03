import 'package:permacalendar/core/models/entitlement.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';

/// Service check permissions logic
/// 
/// Centralizes all checks (Paywall gating).
class CanPerformActionChecker {
  final EntitlementRepository _repository;

  CanPerformActionChecker({EntitlementRepository? repository})
      : _repository = repository ?? EntitlementRepository();

  /// Constants for limits
  static const int kFreePlantLimit = 3;
  static const int kFreeGardenLimit = 1;
  static const int kFreeBedLimit = 1;

  /// Check if user can create a new garden bed.
  bool canCreateBed(int currentBedCount) {
    if (_isPremium()) return true;
    return currentBedCount < kFreeBedLimit;
  }

  /// Check if user can add a new plant.
  /// 
  /// [currentPlantCount] is the current number of plants in the garden/catalog.
  /// Returns true if action is allowed.
  bool canAddPlant(int currentPlantCount) {
    if (_isPremium()) return true;
    return currentPlantCount < kFreePlantLimit;
  }

  /// Check if user can create a new garden.
  bool canCreateGarden(int currentGardenCount) {
    if (_isPremium()) return true;
    return currentGardenCount < kFreeGardenLimit;
  }

  /// Check if user can use advanced export (e.g. XLS).
  /// PDF/Text might be free, but structured data could be premium.
  bool canExportAdvanced() {
    if (_isPremium()) return true;
    
    // Check remaining exports for free users
    final remaining = _repository.getRemainingExports();
    return remaining > 0;
  }

  /// Check if user can export calendar (uses same limit as advanced export).
  bool canExportCalendar() {
    return canExportAdvanced();
  }
  
  /// Check if user can remove watermarks (for exports).
  bool canRemoveWatermark() {
    return _isPremium();
  }

  /// Helper: Check premium status via repository
  bool _isPremium() {
    final entitlement = _repository.getCurrentEntitlement();
    return entitlement.isActive;
  }
  
  /// Returns the current limit for plants (for UI display)
  /// Returns -1 if infinite.
  int get plantLimit {
    if (_isPremium()) return -1;
    return kFreePlantLimit;
  }
}
