# Audit Report: Hive & i18n

## Status
**SUCCESS** - A safe TypeId has been identified.

## Hive Box Analysis
The codebase uses a mix of Legacy (0-18) and Modern (25+) TypeIds.
- **Legacy Range (0-18)**: Fully occupied and must be preserved (Sanctuary).
- **Modern Range (25-30)**: Fully occupied (25, 26, 27, 28, 29, 30).
- **Extended Range (31+)**: 31 and 32 are taken.
- **TypeId 33**: **AVAILABLE** and safe to use.

## Sanctuary Boxes
The following boxes are identified as "Sanctuary" and must NOT be written to by the i18n pipeline or new adapters:
- `gardens` (TypeId 0)
- `garden_beds` (TypeId 1)
- `plants` (TypeId 2)
- `plantings` (TypeId 3)
- `gardens_v2` (TypeId 10)

## Recommendation
We will use **TypeId 33** for the new `PlantLocalized` adapter.

```dart
/// PlantLocalized - Multilingual plant data (offline packs)
const int kTypeIdPlantLocalized = 33;
```

## Next Steps
1. Proceed with `PlantLocalized` model using TypeId 33.
2. Implement `LocaleProvider` and Settings.
3. Build the Node.js tooling pipeline.
