import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permacalendar/core/models/entitlement.dart';

/// Repository for managing Entitlement data in Hive.
/// 
/// This repository handles the local storage of the user's subscription status.
/// It interacts with the 'entitlements' Hive box.
class EntitlementRepository {
  static const String _boxName = 'entitlements';
  static const String _keyName = 'current_entitlement';

  // Singleton
  static final EntitlementRepository _instance = EntitlementRepository._internal();
  factory EntitlementRepository() => _instance;
  EntitlementRepository._internal();

  Box<Entitlement>? _box;
  Box? _limitsBox;

  /// Initialize the Hive box. 
  /// Should be called during app initialization (after Hive.initFlutter and Adapter reg).
  Future<void> init() async {
    // Open Entitlements Box (Typed)
    if (_box == null || !_box!.isOpen) {
      try {
        _box = await Hive.openBox<Entitlement>(_boxName);
        debugPrint('📦 EntitlementRepository: Entitlements Box opened');
      } catch (e) {
        debugPrint('❌ EntitlementRepository: Failed to open entitlements box: $e');
      }
    }
    
    // Open Limits Box (Dynamic/Int)
    if (_limitsBox == null || !_limitsBox!.isOpen) {
      try {
        _limitsBox = await Hive.openBox('export_limits');
        debugPrint('📦 EntitlementRepository: Limits Box opened');
      } catch (e) {
        debugPrint('❌ EntitlementRepository: Failed to open limits box: $e');
      }
    }
  }

  /// Get the current entitlement. 
  /// Returns a Free entitlement if none exists or if box is closed.
  Entitlement getCurrentEntitlement() {
    if (_box == null || !_box!.isOpen) {
      debugPrint('⚠️ EntitlementRepository: Box not open, returning Free');
      return Entitlement.free();
    }
    
    return _box!.get(_keyName, defaultValue: Entitlement.free())!;
  }

  /// Save a new entitlement.
  Future<void> saveEntitlement(Entitlement entitlement) async {
    if (_box == null || _limitsBox == null) await init();
    
    // SECURITY: Block bypass in release mode
    if (!kDebugMode && entitlement.source == 'bypass') {
      debugPrint('⛔ Bypass entitlement blocked in release');
      return;
    }

    if (_box != null && _box!.isOpen) {
      await _box!.put(_keyName, entitlement);
      debugPrint('✅ Entitlement saved: ${entitlement.isPremium ? "PREMIUM" : "FREE"}');
    } else {
      debugPrint('❌ EntitlementRepository: Impossible to save, box closed');
    }
  }

  /// Check and revoke bypass entitlement if found in release mode.
  /// Should be called at app startup.
  Future<void> auditRevokeBypassIfNeeded() async {
    // Ensure boxes are open
    if (_box == null || _limitsBox == null) await init();

    if (_box == null || !_box!.isOpen) return;

    final ent = getCurrentEntitlement();
    if (!kDebugMode && ent.source == 'bypass') {
      debugPrint('⛔ Audit: Bypass entitlement detected in release mode. Revoking...');
      await clearEntitlement();
      await resetExportQuota();
      debugPrint('✅ Audit: Bypass revoked and quotas reset.');
    }
  }

  /// Clear entitlement (e.g. on logout or debug reset)
  Future<void> clearEntitlement() async {
    await init();
    
    if (_box != null && _box!.isOpen) {
      await _box!.delete(_keyName);
      debugPrint('🧹 Entitlement cleared');
    }
  }
  
  static const String _keyRemainingExports = 'remaining_exports';
  static const int kDefaultExportLimit = 5;

  /// Get remaining exports count
  int getRemainingExports() {
    if (_limitsBox == null || !_limitsBox!.isOpen) return kDefaultExportLimit;
    return _limitsBox!.get(_keyRemainingExports, defaultValue: kDefaultExportLimit) as int;
  }

  /// Decrement remaining exports
  Future<void> decrementRemainingExports() async {
    await init();
    
    final current = getRemainingExports();
    if (current > 0 && _limitsBox != null && _limitsBox!.isOpen) {
      await _limitsBox!.put(_keyRemainingExports, current - 1);
      debugPrint('📉 Export quota decremented: ${current - 1} remaining');
    }
  }

  /// Reset export quota (e.g. when premium status changes to expired, we might want to give them 5 fresh exports)
  Future<void> resetExportQuota() async {
     await init();
     if (_limitsBox != null && _limitsBox!.isOpen) {
        await _limitsBox!.put(_keyRemainingExports, kDefaultExportLimit);
        debugPrint('🔄 Export quota reset to $kDefaultExportLimit');
     }
  }

  /// Listen to entitlement changes
  ValueListenable<Box<Entitlement>> get listenable {
    if (_box == null || !_box!.isOpen) {
       throw HiveError('Entitlement box not open');
    }
    return _box!.listenable(keys: [_keyName]);
  }

  /// Listen to limits changes
  ValueListenable<Box>? get limitsListenable {
    if (_limitsBox == null || !_limitsBox!.isOpen) {
       return null;
    }
    return _limitsBox!.listenable(keys: [_keyRemainingExports]);
  }
}
