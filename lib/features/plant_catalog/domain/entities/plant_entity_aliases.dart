// lib/features/plant_catalog/domain/entities/plant_entity_aliases.dart
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

/// Alias / helpers utiles pour l'UI.
/// On ne modifie pas la classe générée, on ajoute une extension.
extension PlantFreezedUiAliases on PlantFreezed {
  /// Alias simple : `name` -> `commonName`
  String get name => commonName;

  /// `subtitle` : on expose le nom scientifique si non vide, sinon null.
  String? get subtitle {
    final s = scientificName;
    return (s.trim().isNotEmpty) ? s.trim() : null;
  }

  /// `imagePath` : recherche pragmatique dans metadata['imagePath'|'image'|'imageUrl'].
  /// Retourne null si absent.
  String? get imagePath {
    final dynamic v =
        metadata['imagePath'] ?? metadata['image'] ?? metadata['imageUrl'];
    if (v == null) return null;
    if (v is String) return v.trim();
    return v.toString().trim();
  }
}
