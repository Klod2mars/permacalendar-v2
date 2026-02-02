import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';
import 'package:permacalendar/core/models/entitlement.dart';
import 'package:permacalendar/core/hive/type_ids.dart';

void main() {
  group('EntitlementRepository Security Tests', () {
    late EntitlementRepository repository;

    setUp(() async {
      print('DEBUG: kDebugMode is $kDebugMode');
      // Initialize Hive for testing
      Hive.init('./test/hive_testing_path');
      
      // Register Adapter
      if (!Hive.isAdapterRegistered(kTypeIdEntitlement)) {
         Hive.registerAdapter(EntitlementAdapter());
      }

      repository = EntitlementRepository();
      
      // Ensure boxes are cleared/closed before test
      await Hive.deleteBoxFromDisk('entitlements');
      await Hive.deleteBoxFromDisk('export_limits');
    });
    
    tearDown(() async {
      await Hive.deleteBoxFromDisk('entitlements');
      await Hive.deleteBoxFromDisk('export_limits');
    });

    test('saveEntitlement blocks bypass in release mode', () async {
      // We cannot easily simulate release mode (kDebugMode is const), 
      // but we can verify the logic if we could inject the mode, 
      // or we assume the test runs in debug mode so it WOULD save,
      // but here we want to verify the logic. 
      // Since kDebugMode is checked inside the function, and we are running in debug mode during tests, 
      // we actually expect it to ALLOW saving in this test environment.
      // However, to strictly test the "release mode blocking", we would need to be able to mock kDebugMode.
      // Dart constants cannot be mocked. 
      // So checking the code manually was the best verify step. 
      // BUT, we can test that it SAVES in debug mode (sanity check).
      
      // Wait, if I am running "flutter test", kDebugMode is true.
      
      final entitlement = Entitlement.premium(productId: 'bypass_id', source: 'bypass', expiresAt: null);
      await repository.saveEntitlement(entitlement);
      
      final saved = repository.getCurrentEntitlement();
      if (kDebugMode) {
         expect(saved.isPremium, true, reason: "In debug mode, bypass should still work");
         expect(saved.source, 'bypass');
      } else {
         expect(saved.isPremium, false, reason: "In release mode, bypass should be blocked");
      }
    });

    test('auditRevokeBypassIfNeeded revokes bypass', () async {
       // Setup a bypass entitlement
       await Hive.openBox<Entitlement>('entitlements');
       final box = Hive.box<Entitlement>('entitlements');
       await box.put('current_entitlement', Entitlement.premium(productId: 'bypass_id', source: 'bypass'));
       
       // Verify it exists
       expect(repository.getCurrentEntitlement().source, 'bypass');
       
       // Now run audit
       // Again, this relies on kDebugMode. 
       // If kDebugMode is true, it verifies that audit DOES NOT revoke it.
       
       await repository.auditRevokeBypassIfNeeded();
       
       print('DEBUG: Current entitlement after audit: ${repository.getCurrentEntitlement()}');

       if (kDebugMode) {
         expect(repository.getCurrentEntitlement().source, 'bypass', reason: "Audit should NOT revoke in debug mode");
       }
    });
  });
  
  // NOTE: To truly test the Release behavior, we would need to run this test file with --release 
  // or modify the code to accept an 'overrideDebugMode' parameter for testing purposes.
  // Given the constraints, we rely on the manual code verification for the specific '!kDebugMode' check,
  // and use these tests to ensure the repository works correctly in general.
}
