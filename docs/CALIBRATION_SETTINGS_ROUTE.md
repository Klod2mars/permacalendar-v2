# Calibration Organique - Settings Route
If your app uses a centralized router, add a route for CalibrationSettingsScreen:
Example (GoRouter):
```dart
GoRoute(
  path: '/settings/calibration',
  builder: (context, state) => const CalibrationSettingsScreen(),
);
```
Or use Navigator.push(MaterialPageRoute(builder: (_) => const CalibrationSettingsScreen()));

