# Experimental Climate Cells V1

## Overview

This is an experimental prototype exploring an organic, cellular layout for climate data visualization in the PermaCalendar Flutter application. The design is inspired by plant tissue structures with irregular, softly rounded cell-like shapes.

**⚠️ IMPORTANT**: This is NOT a replacement for the existing `ClimateRosacePanel`. It's a purely experimental sandbox for visual exploration (Phase P5.0).

## Visual Concept

- **Layout**: Organic cluster of 4-5 irregular, softly rounded "cells"
- **Center Cell**: pH value with a subtle pulsating animation (acting as a living nucleus)
- **Surrounding Cells**: Weather, soil temperature, alerts, and forecast data
- **Aesthetics**: Translucent glass effect with organic curves using Bezier paths
- **Inspiration**: Microscopic plant tissue structures (see reference image)

## Components

### Main Widget
- `ExperimentalClimateCellsV1`: The main widget displaying the cellular layout

### Supporting Classes
- `_CellContainer`: Individual rounded cell container with backdrop blur
- `CellsBackgroundPainter`: Custom painter for organic background shapes using quadratic Bezier curves
- `ExperimentalClimateScreen`: Full-screen wrapper for visual testing

## Data (Placeholder)

Currently using static placeholder data:
- **pH**: "pH 6.8" (central nucleus, pulsating)
- **Soil Temp**: "10.4°"
- **Weather**: "14° / 7°"
- **Alerts**: "!"
- **Forecast**: "📈"

## Navigation

Accessible via the app router at route: `/experimental-cells`

A test button is available in the home screen AppBar (grid icon).

## Technical Details

- **Animation**: Continuous pulse animation on the central pH cell (2s cycle)
- **Positioning**: Stack + Positioned widgets for organic arrangement
- **Styling**: Backdrop blur with translucent colors
- **Curves**: Quadratic Bezier paths for organic shapes
- **Height**: 280dp container

## Future Iterations

Based on visual evaluation, potential next steps could include:
1. Refining cell shapes and positioning
2. Adding real data integration
3. Implementing touch interactions
4. Exploring color schemes
5. Adding transition animations
6. Aligning with the leaf background image

## Files

- `experimental_climate_cells_v1.dart` - Main implementation
- `README.md` - This file
