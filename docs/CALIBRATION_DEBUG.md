# Calibration Debug Overlay

## Overview

Le **Calibration Debug Overlay** permet de visualiser visuellement les zones calibrées sur le dashboard organique. Cet outil de développement facilite la validation et le debug des positions et tailles des zones interactives.

## Activation

Pour activer l'overlay de debug :

1. Ouvrir `lib/shared/presentation/screens/organic_dashboard_screen.dart`
2. Dans la classe `_OrganicDashboardScreenState`, localiser la variable :
   ```dart
   final bool _showCalibrationDebug = false;
   ```
3. Changer la valeur à `true` :
   ```dart
   final bool _showCalibrationDebug = true;
   ```
4. Relancer l'application

## Fonctionnement

### Zones affichées

L'overlay affiche des cercles colorés pour les zones suivantes :

- **METEO** : Blanc, position et taille depuis `PositionPersistence`
- **PH** : Bleu semi-transparent
- **TEMP_SOL** : Orange semi-transparent

### Source des données

Les positions sont lues depuis `SharedPreferences` via `PositionPersistence.readPosition()` :

- **Prefix** : `'organic'`
- **Format** : Coordonnées normalisées (0.0 - 1.0)
- **Clés** : `METEO`, `PH`, `TEMP_SOL`
- **Données** : `x`, `y`, `size`, `enabled`

### Architecture

```
CalibrationDebugOverlay
├── Position : Offset normalisé (0..1)
├── Size : Diamètre normalisé (0..1)
├── Color : Couleur du cercle
├── StrokeWidth : Épaisseur du contour
└── Circular : Forme (true = cercle, false = rectangle)
```

## Utilisation

### Validation des zones

1. Activer `_showCalibrationDebug = true`
2. Ouvrir le dashboard organique
3. Vérifier que les cercles correspondent aux éléments visuels
4. Valider que les zones tapables sont correctement alignées

### Debug de calibration

Si une zone n'est pas alignée :

1. Ouvrir les paramètres de calibration
2. Ajuster la position de la zone
3. Sauvegarder
4. Vérifier que l'overlay se met à jour correctement

### Désactivation

**Important** : Toujours remettre `_showCalibrationDebug = false` avant de committer ou de déployer en production.

## Limitations

- **Performance** : L'overlay utilise des `FutureBuilder` qui réinitialisent à chaque rebuild. Pour des performances optimales, désactiver en production.
- **Couleurs** : Les couleurs sont codées en dur pour chaque zone. Modifier dans `_buildDebugOverlays()` si nécessaire.
- **Zones disponibles** : Seules METEO, PH et TEMP_SOL sont affichées par défaut. Ajouter d'autres zones si nécessaire.

## Fichiers connexes

- `lib/shared/widgets/calibration_debug_overlay.dart` : Widget de l'overlay
- `lib/core/utils/position_persistence.dart` : Persistance et lecture des positions
- `lib/shared/presentation/screens/organic_dashboard_screen.dart` : Intégration

## Notes techniques

### Coordonnées normalisées

Le système utilise des coordonnées normalisées (0.0 - 1.0) pour garantir la compatibilité multi-résolutions :

```dart
final left = (position.dx * w).clamp(0.0, w);
final top = (position.dy * h).clamp(0.0, h);
final side = (size * (w < h ? w : h)).clamp(8.0, (w < h ? w : h));
```

### FutureBuilder

L'overlay utilise `FutureBuilder` pour lire les données de manière asynchrone :

```dart
FutureBuilder<Map<String, dynamic>?>(
  future: PositionPersistence.readPosition('organic', 'METEO'),
  builder: (context, snapshot) {
    // Construction de l'overlay
  },
)
```

