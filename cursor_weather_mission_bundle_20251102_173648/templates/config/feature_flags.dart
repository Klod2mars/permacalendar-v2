// Do not enable without completing backups & audit.
// Toggle progressively (staging → canary → 100%).
class FeatureFlags {
  static const bool weatherV2Enabled = false; // set true after rebuild & QA
}
