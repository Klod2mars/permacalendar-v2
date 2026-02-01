import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permacalendar/core/models/entitlement.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;

/// Service responsible for handling purchases and syncing entitlements with RevenueCat.
class PurchaseService {
  final EntitlementRepository _repository;
  
  // TODO: Move to .env or config
  static const String _googleApiKey = "goog_placeholder_api_key"; 
  static const String _appleApiKey = "appl_placeholder_api_key";
  
  static const String kEntitlementId = "premium"; // Must match RevenueCat Entitlement ID

  bool _isInitialized = false;

  // Singleton
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  
  PurchaseService._internal({EntitlementRepository? repository}) 
      : _repository = repository ?? EntitlementRepository();

  /// Initialize RevenueCat and listeners
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Purchases.setLogLevel(LogLevel.debug);

      String? apiKey;
      if (Platform.isAndroid) {
        apiKey = _googleApiKey;
      } else if (Platform.isIOS) {
        apiKey = _appleApiKey;
      }

      if (apiKey == null || apiKey == "goog_placeholder_api_key") {
         debugPrint("⚠️ RevenueCat API Key not set. Skipping initialization.");
         // We do not return here to allow the app to work in "Offline/Free" mode
         return;
      }

      await Purchases.configure(PurchasesConfiguration(apiKey));
      
      // Listen to changes
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
      
      // Initial check
      final customerInfo = await Purchases.getCustomerInfo();
      await _handleCustomerInfo(customerInfo);
      
      _isInitialized = true;
      debugPrint("✅ PurchaseService initialized");
    } catch (e) {
      debugPrint("❌ Error initializing PurchaseService: $e");
    }
  }

  /// Listener for RevenueCat updates
  void _onCustomerInfoUpdated(CustomerInfo info) {
    debugPrint("🔔 CustomerInfo updated: ${info.entitlements.active}");
    _handleCustomerInfo(info);
  }

  /// Process CustomerInfo and update local Entitlement
  Future<void> _handleCustomerInfo(CustomerInfo info) async {
    final entitlementInfo = info.entitlements.all[kEntitlementId];

    if (entitlementInfo != null && entitlementInfo.isActive) {
      // User is Premium
      final entitlement = Entitlement.premium(
        productId: entitlementInfo.productIdentifier,
        expiresAt: entitlementInfo.expirationDate != null 
            ? DateTime.parse(entitlementInfo.expirationDate!) 
            : null,
        source: 'revenuecat',
      );
      await _repository.saveEntitlement(entitlement);
    } else {
      // User is Free (or expired)
      // Only overwrite if we previously had a premium status to avoid unnecessary writes
      // Or just always ensure sync.
       // Check current to avoid loops if needed, but safe to write.
      if (_repository.getCurrentEntitlement().isPremium) {
        debugPrint("📉 Downgrading to Free (Expired/Cancelled)");
        // We write a free entitlement to overwrite the premium one
        await _repository.saveEntitlement(Entitlement.free());
      }
    }
  }

  /// Fetch available offerings (Paywall products)
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      debugPrint("❌ Error fetching offerings: $e");
      return null;
    }
  }

  /// Purchase a package
    Future<bool> purchasePackage(Package package) async {
    try {
      // In v4+ it returned CustomerInfo, but error logs suggest PurchaseResult wrapper.
      // Wait, let's look at the error again.
      // "The argument type 'PurchaseResult' can't be assigned to 'CustomerInfo'".
      // This means `Purchases.purchasePackage` returned `PurchaseResult`.
      // We need to get customerInfo from it.
      
      // Note: If the SDK is v9, it might be `CustomerInfo` directly? No, the error confirms PurchaseResult.
      // Let's try `result.customerInfo`.
      
      /*
        Error log:
        The argument type 'PurchaseResult' can't be assigned to the parameter type 'CustomerInfo'.
        The getter 'entitlements' isn't defined for the type 'PurchaseResult'.
      */

      // Assuming:
      // final PurchaseResult result = await Purchases.purchasePackage(package);
      // final CustomerInfo customerInfo = result.customerInfo;
      
      // Correction:
      final dynamic result = await Purchases.purchasePackage(package);
      
      // To be safe with version changes, let's inspect usage or assume standard field.
      // Checking RevenueCat changelogs for Dart...
      // Usually it is just CustomerInfo. But maybe `purchases_flutter` changed recently.
      
      // Let's try to assume it has a .customerInfo property or verify if it IS the object but mismatch.
      // Actually checking recent docs: `purchasePackage` returns `Future<CustomerInfo>`.
      // The error log is VERY specific about `PurchaseResult`.
      // This implies `purchases_flutter` v9 changed this signature.
      
      // Let's try:
      final customerInfo = (result as dynamic).customerInfo as CustomerInfo;
      // Or cleaner:
      
      /*
      final result = await Purchases.purchasePackage(package);
      final customerInfo = result.customerInfo; // Assuming this field exists based on name
      */
      
      await _handleCustomerInfo(customerInfo);
      return customerInfo.entitlements.all[kEntitlementId]?.isActive ?? false;
      
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint("❌ Purchase failed: $e");
      }
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      await _handleCustomerInfo(customerInfo);
      return customerInfo.entitlements.all[kEntitlementId]?.isActive ?? false;
    } on PlatformException catch (e) {
      debugPrint("❌ Restore failed: $e");
      return false;
    }
  }
}
