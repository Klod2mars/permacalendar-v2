import 'package:hive/hive.dart';
import 'package:permacalendar/core/hive/type_ids.dart';

part 'entitlement.g.dart';

@HiveType(typeId: kTypeIdEntitlement)
class Entitlement extends HiveObject {
  @HiveField(0)
  final bool isPremium;

  @HiveField(1)
  final String? productId; // e.g., 'monthly_0_99', 'annual_6_99'

  @HiveField(2)
  final DateTime? expiresAt;

  @HiveField(3)
  final String? source; // 'revenuecat', 'manual', 'promo'

  @HiveField(4)
  final DateTime? lastValidatedAt;

  @HiveField(5)
  final Map<String, dynamic> metadata;

  Entitlement({
    required this.isPremium,
    this.productId,
    this.expiresAt,
    this.source,
    this.lastValidatedAt,
    this.metadata = const {},
  });

  /// Returns true if the entitlement is currently active
  bool get isActive {
    if (!isPremium) return false;
    if (expiresAt == null) return true; // Lifetime or infinite
    return expiresAt!.isAfter(DateTime.now());
  }

  /// Factory for a free/standard user
  factory Entitlement.free() {
    return Entitlement(
      isPremium: false,
      metadata: {'created_at': DateTime.now().toIso8601String()},
    );
  }

  /// Factory for a premium user
  factory Entitlement.premium({
    required String productId,
    DateTime? expiresAt,
    String source = 'revenuecat',
  }) {
    return Entitlement(
      isPremium: true,
      productId: productId,
      expiresAt: expiresAt,
      source: source,
      lastValidatedAt: DateTime.now(),
    );
  }

  Entitlement copyWith({
    bool? isPremium,
    String? productId,
    DateTime? expiresAt,
    String? source,
    DateTime? lastValidatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Entitlement(
      isPremium: isPremium ?? this.isPremium,
      productId: productId ?? this.productId,
      expiresAt: expiresAt ?? this.expiresAt,
      source: source ?? this.source,
      lastValidatedAt: lastValidatedAt ?? this.lastValidatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'Entitlement(isPremium: $isPremium, productId: $productId, expiresAt: $expiresAt, source: $source)';
  }
}
