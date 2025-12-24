import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dual_write_service.dart';

/// Provider pour le service de double écriture
/// Singleton car le service maintient un état interne (isEnabled)
final dualWriteServiceProvider = Provider<DualWriteService>((ref) {
  return DualWriteService();
});
