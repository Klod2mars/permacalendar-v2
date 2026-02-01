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

  /// Initialize the Hive box. 
  /// Should be called during app initialization (after Hive.initFlutter and Adapter reg).
  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    
    try {
      _box = await Hive.openBox<Entitlement>(_boxName);
      debugPrint('📦 EntitlementRepository: Box opened');
    } catch (e) {
      debugPrint('❌ EntitlementRepository: Failed to open box: $e');
      // Fallback or retry logic could be added here
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
    if (_box == null || !_box!.isOpen) await init();
    
    if (_box != null && _box!.isOpen) {
      await _box!.put(_keyName, entitlement);
      debugPrint('✅ Entitlement saved: ${entitlement.isPremium ? "PREMIUM" : "FREE"}');
    } else {
      debugPrint('❌ EntitlementRepository: Impossible to save, box closed');
    }
  }

  /// Clear entitlement (e.g. on logout or debug reset)
  Future<void> clearEntitlement() async {
    if (_box == null || !_box!.isOpen) await init();
    
    if (_box != null && _box!.isOpen) {
      await _box!.delete(_keyName);
      debugPrint('🧹 Entitlement cleared');
    }
  }
  
  /// Listen to entitlement changes
  ValueListenable<Box<Entitlement>> get listenable {
    if (_box == null || !_box!.isOpen) {
       throw HiveError('Entitlement box not open');
    }
    return _box!.listenable(keys: [_keyName]);
  }
}
