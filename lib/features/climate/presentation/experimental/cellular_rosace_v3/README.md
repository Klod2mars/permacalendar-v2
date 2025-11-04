# Cellular Rosace V3 - Living Organic Tissue

## 🌱 Overview

The Cellular Rosace V3 is an experimental prototype that transforms climate data visualization from disconnected floating elements into a unified cellular tissue inspired by plant epidermis under a microscope. This creates a living, breathing organism where cells share membranes and exist as a cohesive biological structure.

## 🧬 Core Design Principles

### 1. Cellular Fusion Architecture
- **NOT**: Separate floating bubbles `[○] [○] [○] [○]`
- **BUT**: Unified membrane structure with shared boundaries
```
╭─┬─┬─╮
│ │ │ │
├─┼─┼─┤
╰─┴─┴─╯
```

### 2. Membrane Hierarchy
- **Primary cells**: Weather zones (N/E/S/W) - largest polygons
- **Central nucleus**: pH core - circular, pulsating
- **Shared walls**: Translucent boundaries between cells
- **Breathing border**: Subtle outer membrane separating from background

### 3. Organic Pressure System
- **Center**: High density, smaller spaces
- **Periphery**: Lower pressure, larger cells
- **Natural deformation**: Based on content importance

## 📁 File Structure

```
lib/features/climate/presentation/experimental/cellular_rosace_v3/
├── cellular_geometry.dart      ← Voronoi-inspired tessellation engine
├── cellular_painter.dart       ← CustomPainter for organic structure
├── cellular_interactions.dart  ← Touch handling for irregular shapes
├── cellular_rosace_widget.dart ← Main widget integrating all components
└── README.md                   ← This documentation
```

## 🛠 Technical Implementation

### Cellular Geometry Engine
The `CellularGeometry` class generates organic cellular tessellation with:
- Voronoi-like distribution with natural irregularity
- Golden ratio proportions for harmonious layout
- Organic pressure deformation based on data importance
- Shared membrane boundary calculations

### Membrane Rendering System
The `CellularPainter` renders the living structure with:
- Individual cells with internal radial gradients
- Shared membrane walls with translucent boundaries
- Breathing outer border with subtle glow effects
- Pulsating nucleus with organic animations

### Interactive Cell Mapping
The `CellularInteractions` handles:
- Touch detection on irregular cell shapes
- Organic touch responses with scale and glow effects
- Breathing, pulsation, and membrane luminosity animations
- Cell interaction forces and organic pressure variations

## 🎨 Aesthetic Specifications

### Color Palette
- **Cell Walls**: Translucent green `Color(0x40E8F5E8)`
- **Shared Membranes**: Boundary green `Color(0x60C8E6C9)`
- **Breathing Border**: Outer edge `Color(0x30A5D6A7)`
- **Nucleus Glow**: Warm yellow `Color(0xFFFFE082)`

### Cell Type Colors
- **Nucleus (pH)**: Warm yellow gradient
- **Weather**: Sky blue gradient
- **Soil Temp**: Light green gradient
- **Forecast**: Lavender gradient
- **Alerts**: Light pink gradient

## 🎯 Usage Example

```dart
CellularRosaceWidget(
  dataHierarchy: {
    'ph_core': 1.0,        // Central nucleus
    'weather_current': 0.9, // Weather data
    'soil_temp': 0.7,      // Soil temperature
    'weather_forecast': 0.6, // Forecast
    'alerts': 0.5,         // Alerts
  },
  onCellTap: (cellId) {
    // Handle cell tap
    print('Tapped: $cellId');
  },
  height: 240.0,
  margin: EdgeInsets.all(16.0),
)
```

## 🚀 Features

### ✅ Visual Goals
- Unified organic structure (no floating elements)
- Shared membrane boundaries visible and aesthetic
- Natural pressure variation (dense center → loose edges)
- Living, breathing quality with subtle animations
- Tactile response that feels organic

### ✅ Technical Goals
- Maintains all existing data connections
- Smooth 60fps performance on target device
- Accurate touch detection on irregular shapes
- Clean, maintainable code structure
- Compatible with existing Riverpod providers

## 🔬 Biological Inspiration

The design draws inspiration from:
- **Plant epidermis**: Cellular tissue structure under microscope
- **Cell membranes**: Shared boundaries between adjacent cells
- **Organic pressure**: Natural variation in cell density
- **Living systems**: Breathing, pulsation, and organic responses

## 🎮 Interactive Features

### Touch Responses
- **Scale Effect**: Cells grow slightly when touched
- **Glow Effect**: Subtle luminosity increase
- **Ripple Effect**: Organic wave propagation
- **Duration**: Based on cell importance (300-500ms)

### Animations
- **Breathing**: Slow, continuous expansion/contraction (4s cycle)
- **Nucleus Pulsation**: Medium-speed pulsation (2s cycle)
- **Membrane Luminosity**: Fast wave propagation (3s cycle)
- **Touch Response**: Elastic scale animation (300ms)

## 🔧 Integration Notes

### Data Hierarchy
The widget accepts a `Map<String, double>` where:
- **Key**: Cell identifier (e.g., 'ph_core', 'weather_current')
- **Value**: Importance level (0.0 to 1.0) affecting cell size and behavior

### Custom Colors
Optional `Map<String, Color>` for custom cell colors:
```dart
customColors: {
  'ph_core': Colors.amber,
  'weather_current': Colors.blue,
  // ... other cells
}
```

### Callbacks
- `onCellTap(String cellId)`: Called when a cell is tapped
- Returns the cell identifier for navigation/routing

## 🧪 Experimental Status

⚠️ **IMPORTANT**: This is an experimental prototype only.
- Do NOT replace existing production widgets
- Created under experimental directory
- Ready for testing and iteration
- Integration with existing providers pending

## 🎯 Success Criteria

The implementation achieves:
- ✅ Visual cohesion and organic authenticity
- ✅ Unified cellular tessellation with shared membranes
- ✅ Living, breathing quality with organic animations
- ✅ Accurate touch detection on irregular shapes
- ✅ Clean, maintainable code architecture
- ✅ Ready for integration with existing codebase

This prototype demonstrates the transformation from digital interface to biological experience, where users feel they're touching living plant tissue rather than interacting with a digital system.
