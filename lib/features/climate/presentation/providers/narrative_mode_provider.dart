import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for narrative mode setting
/// Controls whether the rosace halo evolves with hourly weather or remains static
/// Default: ON (true) for immersive experience
final narrativeModeProvider = NotifierProvider<NarrativeModeNotifier, bool>(
    () => NarrativeModeNotifier());

/// Provider for narrative mode with persistence
/// TODO: In future phases, integrate with user preferences storage
final narrativeModePersistedProvider =
    NotifierProvider<NarrativeModeNotifier, bool>(
        () => NarrativeModeNotifier());

/// Notifier for narrative mode with future persistence capability
class NarrativeModeNotifier extends Notifier<bool> {
  @override
  bool build() => true; // Default ON

  /// Toggle narrative mode
  void toggle() {
    state = !state;
    // TODO: Persist to user preferences
  }

  /// Set narrative mode explicitly
  void setNarrativeMode(bool enabled) {
    state = enabled;
    // TODO: Persist to user preferences
  }
}
