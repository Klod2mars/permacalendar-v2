# Weather Integration Guide

## Providers

- currentWeatherProvider: Returns current temperature, min/max, icon, description, code, and condition.
- forecastProvider: Returns a list of DailyWeatherPoint for future days.
- forecastHistoryProvider: Unified J-14 → J+7 timeline as TimelineWeatherPoint.
- globalWeatherProvider: Aggregates current + forecast for dashboard access.
- weatherHaloColorProvider: Reactive halo color derived from hourly weather and narrative mode.

## Key Files

- lib/features/climate/presentation/providers/weather_providers.dart
- lib/features/home/providers/living_leaf_providers.dart
- lib/features/climate/presentation/anim/weather_halo_controller.dart
- lib/features/climate/presentation/utils/halo_color_maps.dart

## UI Integrations

- Garden Dashboard: Uses currentWeatherProvider to display temperature and icon.
- Insight Hub: Uses forecastProvider for today precipitation summary.
- Forecast/History Screen: Uses forecastHistoryProvider to render a timeline.
- Climate Rosace: Consumes currentWeatherProvider and forecastProvider; halo color via weatherHaloColorProvider when narrative mode is ON.

## Color Mapping (Halo)

- Sunny: yellow‑green (lime)
- Rainy: blue
- Cold (snow/frost): cyan
- Hot: orange
- Cloudy: grey
- Stormy: purple

## Clean Architecture Notes

- UI consumes providers; no data → domain imports leakage.
- OpenMeteoService is used in providers; domain wrapper `WeatherViewData` (climate/domain/models) used where needed.


