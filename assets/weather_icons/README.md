# Icônes Météo Organiques

Ce dossier contient les icônes météo du pack organique DeeVid pour la bulle météo centrale.

## Structure des icônes

- `clear_day.png` - Ciel clair (code 0)
- `partly_cloudy.png` - Partiellement nuageux (codes 1, 2, 3)
- `fog.png` - Brouillard (codes 45, 48)
- `drizzle.png` - Bruine (codes 51, 53, 55)
- `rain.png` - Pluie (codes 61, 63, 65)
- `freezing_rain.png` - Pluie verglaçante (codes 66, 67)
- `showers.png` - Averses (codes 80, 81, 82)
- `snow.png` - Neige (codes 71, 73, 75, 77)
- `snow_showers.png` - Averses de neige (codes 85, 86)
- `thunderstorm.png` - Orage (codes 95, 96, 99)
- `wind.png` - Vent (codes 20-29)
- `default.png` - Icône par défaut

## Spécifications

- **Taille** : 24x24px (optimisé pour la bulle météo)
- **Format** : PNG avec transparence
- **Style** : Organique, cohérent avec le design DeeVid
- **Couleur** : Vert bioluminescent, adaptable via `color` property

## Utilisation

Les icônes sont automatiquement mappées via `WeatherIconMapper` selon les codes météo WMO de l'API Open-Meteo.
