import 'package:riverpod/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/notification_alert.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_state.dart';

part 'intelligence_runtime_providers.freezed.dart';

// ------------------------------------------------------------
// 🧠 Core Runtime Providers - Notifiers Autoritatifs
// ------------------------------------------------------------

class CurrentIntelligenceGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

// =======================
// ✅ IntelligentAlertsState (restauré définitivement)
// =======================
@freezed
class IntelligentAlertsState with _$IntelligentAlertsState {
  const factory IntelligentAlertsState({
    @Default(<NotificationAlert>[]) List<NotificationAlert> activeAlerts,
  }) = _IntelligentAlertsState;
}

class IntelligentAlertsNotifier extends Notifier<IntelligentAlertsState> {
  @override
  IntelligentAlertsState build() => IntelligentAlertsState();

  void dismissAlert(String id) {
    state = IntelligentAlertsState(
      activeAlerts: state.activeAlerts.where((a) => a.id != id).toList(),
    );
  }

  void acknowledgeAlert(String id) {
    // TODO: Persister dans le repository
  }

  void resolveAlert(String id) {
    // TODO: Implémenter la logique de résolution
  }
}

class ContextualRecommendationsState {
  final List<Recommendation> contextualRecommendations;
  final List<Recommendation> appliedRecommendations;
  ContextualRecommendationsState({
    this.contextualRecommendations = const [],
    this.appliedRecommendations = const [],
  });
}

class ContextualRecommendationsNotifier
    extends Notifier<ContextualRecommendationsState> {
  @override
  ContextualRecommendationsState build() =>
      ContextualRecommendationsState();

  void applyRecommendation(String id) {
    final recommendation = state.contextualRecommendations.firstWhere(
      (r) => r.id == id,
      orElse: () => throw StateError('Recommendation not found: $id'),
    );
    state = ContextualRecommendationsState(
      contextualRecommendations: state.contextualRecommendations.where((r) => r.id != id).toList(),
      appliedRecommendations: [...state.appliedRecommendations, recommendation],
    );
  }

  void dismissRecommendation(String id) {
    state = ContextualRecommendationsState(
      contextualRecommendations: state.contextualRecommendations.where((r) => r.id != id).toList(),
      appliedRecommendations: state.appliedRecommendations,
    );
  }
}

class RealTimeAnalysisState {
  final bool isRunning;
  final Duration updateInterval;
  const RealTimeAnalysisState({
    this.isRunning = false,
    this.updateInterval = const Duration(minutes: 15),
  });
}

class RealTimeAnalysisNotifier extends Notifier<RealTimeAnalysisState> {
  @override
  RealTimeAnalysisState build() => const RealTimeAnalysisState();

  void startRealTimeAnalysis() => state = RealTimeAnalysisState(isRunning: true, updateInterval: state.updateInterval);
  void stopRealTimeAnalysis() => state = RealTimeAnalysisState(isRunning: false, updateInterval: state.updateInterval);
  void updateAnalysisInterval(Duration interval) => state = RealTimeAnalysisState(isRunning: state.isRunning, updateInterval: interval);
}

// Providers publics
final currentIntelligenceGardenIdProvider =
    NotifierProvider<CurrentIntelligenceGardenIdNotifier, String?>(() => CurrentIntelligenceGardenIdNotifier());

final intelligentAlertsProvider =
    NotifierProvider<IntelligentAlertsNotifier, IntelligentAlertsState>(() => IntelligentAlertsNotifier());

final contextualRecommendationsProvider =
    NotifierProvider<ContextualRecommendationsNotifier, ContextualRecommendationsState>(
        () => ContextualRecommendationsNotifier());

final realTimeAnalysisProvider =
    NotifierProvider<RealTimeAnalysisNotifier, RealTimeAnalysisState>(
        () => RealTimeAnalysisNotifier());

