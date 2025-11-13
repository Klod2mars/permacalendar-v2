# Experimental Climate Cells V2

## Overview

This is an experimental prototype (V2) exploring an organic, cellular layout for climate data. The design is inspired by plant tissue under a microscope, with interconnected cells that form a fused, living tissue appearance.

## Key Features

### Visual Design
- **Fused Cellular Structure**: Cells are visually touching and interconnected, creating a single organic mass
- **Organic Blob Shapes**: Each cell uses custom cubic bezier curves to create irregular, asymmetric blob shapes (NOT circles or rectangles)
- **Soft Radial Gradients**: Each cell has its own radial gradient for depth and organic feel
- **Subtle Borders**: Overlay borders provide definition while maintaining the organic aesthetic

### Layout
The widget consists of 5 interconnected cells:

1. **Weather Cell** (Top, Large)
   - Sky blue gradient
   - Shows current weather (temp high/low)
   - Largest cell to accommodate icon + temperature display

2. **Forecast Cell** (Right, Medium-Large)  
   - Lavender gradient
   - Shows forecast indicator
   - Slightly stretched horizontally

3. **Soil Temperature Cell** (Left, Medium)
   - Light green gradient
   - Displays soil temperature
   - Medium-sized vertical cell

4. **Alert Cell** (Bottom-Left, Medium)
   - Soft coral/pink gradient
   - Shows alert indicator
   - Compact cell for warnings

5. **pH Cell** (Center, Nucleus)
   - Medium turquoise gradient
   - **Pulsating animation** (subtle scale animation)
   - Acts as the "nucleus" of the cellular structure
   - Smallest central cell

### Technical Implementation

#### Custom Painter
- `OrganicCellsPainter`: Creates the fused cellular shapes
- `_createOrganicBlob()`: Generates individual cell paths using cubic bezier curves
- Radial gradients applied to each cell
- Asymmetry parameter for organic irregularity

#### Layout Strategy
- Uses `CustomPaint` for background cells
- `Stack` with `Positioned` widgets for content overlay
- Breathing margin (20px) around entire cluster to avoid screen edges
- Content positioned precisely over cell centers

#### Interaction
- `GestureDetector` on each cell area
- TODO: Connect to actual navigation (currently placeholder)
- Touch feedback ready for implementation

## Color Palette

- **Weather**: `Color.fromRGBO(135, 206, 235, 0.85)` - Sky blue
- **Forecast**: `Color.fromRGBO(221, 192, 222, 0.85)` - Lavender
- **Soil Temp**: `Color.fromRGBO(173, 216, 181, 0.85)` - Light green
- **Alert**: `Color.fromRGBO(255, 182, 193, 0.85)` - Light pink
- **pH**: `Color.fromRGBO(102, 205, 170, 0.90)` - Medium turquoise

## Usage

### Access the Prototype

The V2 prototype is accessible via:

1. **Route**: `/experimental-cells-v2`
2. **Navigation**: Home screen → Click "Test Cells V2" icon in AppBar
3. **Direct import**: `ExperimentalClimateCellsV2()` widget

### Example Screen

```dart
import 'package:permacalendar/features/climate/presentation/experimental/experimental_climate_cells_v2.dart';

// In your widget tree:
const ExperimentalClimateScreenV2()
```

## Next Steps (TODO)

- [ ] Connect cell taps to actual navigation flows
- [ ] Integrate real climate data (currently using placeholders)
- [ ] Add visual feedback for cell touches
- [ ] Adjust cell sizes and positions based on data availability
- [ ] Consider making cell shapes responsive to actual values
- [ ] Add subtle animations when data changes
- [ ] Integration testing with existing climate panels

## Comparison with V1

| Feature | V1 | V2 |
|---------|----|----|
| Cell shape | Rounded rectangles | Organic blobs |
| Fusion | Separate tiles with spacing | Fully fused, interconnected |
| Borders | Distinct shadows | Subtle overlay borders |
| Background | Optional leaf decorations | No background decorations |
| Curvature | Fixed border radius | Dynamic cubic bezier curves |
| Asymmetry | None | Variable asymmetry parameter |
| Visual style | Geometric | Organic, tissue-like |

## Development Notes

- This is an **experimental prototype** - not intended for production
- Keep the code isolated and readable for further iterations
- All interactive features are placeholders (TODO comments)
- Positioning is hardcoded for now; consider making it responsive
- CustomPainter performance is acceptable for this use case

## File Structure

```
lib/features/climate/presentation/experimental/
├── experimental_climate_cells_v1.dart  (Previous prototype)
├── experimental_climate_cells_v2.dart  (This V2 prototype)
└── README_V2.md                        (This documentation)
```

## Credits

Inspired by plant tissue microscopy images and organic cellular structures in nature.
