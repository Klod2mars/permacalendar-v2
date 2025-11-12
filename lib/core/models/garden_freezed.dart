import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'garden_freezed.freezed.dart';
part 'garden_freezed.g.dart';

@freezed
class GardenFreezed with _$GardenFreezed {
  const factory GardenFreezed({
    required String id,
    required String name,
    String? description, // Rendre optionnel
    @Default(0.0) double totalAreaInSquareMeters, // Valeur par défaut
    @Default('') String location, // Valeur par défaut
    required DateTime createdAt,
    required DateTime updatedAt,
    String? imageUrl,
    @Default({}) Map<String, dynamic> metadata,
    @Default(true) bool isActive,
  }) = _GardenFreezed;

  factory GardenFreezed.fromJson(Map<String, dynamic> json) =>
      _$GardenFreezedFromJson(json);

  // Factory constructor CORRIGÉ
  factory GardenFreezed.create({
    required String name,
    String? description,
    double? totalAreaInSquareMeters, // Optionnel
    String? location, // Optionnel
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return GardenFreezed(
      id: const Uuid().v4(),
      name: name,
      description: description,
      totalAreaInSquareMeters: totalAreaInSquareMeters ?? 0.0, // Gère null
      location: location ?? '', // Gère null
      createdAt: now,
      updatedAt: now,
      imageUrl: imageUrl,
      metadata: metadata ?? {},
    );
  }
}

// Extension pour ajouter des méthodes utilitaires
extension GardenFreezedExtension on GardenFreezed {
  // Validation adaptée pour les champs optionnels
  bool get isValid {
    return name.isNotEmpty && name.length >= 2;
    // Suppression des validations de totalAreaInSquareMeters et location
    // car elles ont maintenant des valeurs par défaut dans le modèle
  }

  // Marquer comme mis à jour
  GardenFreezed markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }

  // Mettre à jour les métadonnées
  GardenFreezed updateMetadata(String key, dynamic value) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata[key] = value;
    return copyWith(
      metadata: newMetadata,
      updatedAt: DateTime.now(),
    );
  }

  // Supprimer une métadonnée
  GardenFreezed removeMetadata(String key) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata.remove(key);
    return copyWith(
      metadata: newMetadata,
      updatedAt: DateTime.now(),
    );
  }
}

