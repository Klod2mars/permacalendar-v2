# Patch Application Guide: Statistics Pillar Containment & Polish

This patch updates the `StatisticsPillarCard` widget to implement a strict circular containment layout with neon glow and glassmorphism effects ("Conscience du Vivant" style).

## Contents
- Refactored `StatisticsPillarCard` to use `AspectRatio(1:1)`, `LayoutBuilder`, and constrained content.
- Added responsive scaling for text and KPIs.
- Constrained placeholders to prevent overflows.

## How to Apply
1. Ensure your local repository is clean or stash changes.
2. Apply the patch using git:
   ```bash
   git apply statistics-pillar-containment.patch
   ```
3. Run project clean run script (Yellow/Jaune) to rebuild:
   ```bash
   ./scripts/clean_run.sh
   # or
   flutter clean && flutter pub get && flutter run
   ```

## Verification
- Check the "Conscience du Vivant" dashboard.
- Verify that all 4 pillars are perfect circles.
- Verify that content (texts, charts) scales down inside the bubbles and does not overflow (no yellow/black stripes).
