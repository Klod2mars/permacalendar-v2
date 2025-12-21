# Logic Updates

1. **PlantingProvider**:
   - `recordHarvest` signature updated to accept `quantityKg` and `pricePerKg`.
   - Uses `HarvestRepository` to store the record.
   - Updates `Planting` status to 'Récolté'.
   - Emits correct `GardenEvent`.

2. **HarvestRecordsProvider**:
   - Fetches from `HarvestRepository`.
