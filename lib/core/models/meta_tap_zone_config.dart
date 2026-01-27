import 'dart:ui';

/// Configuration for a "Meta Tap Zone".
///
/// A Meta Tap Zone is a purely functional tap area that is NOT tied to the
/// biological/vivant logic of the application. It is used for meta-features
/// like "Credit & Contact", "Easter Eggs", or specific navigation shortcuts
/// that must remain decoupled from the main organic engine.
///
/// It supports the same normalized positioning (0..1) as [OrganicZoneConfig].
class MetaTapZoneConfig {
  final String id;
  final String? bubbleId; // Optional: ID of the passive bubble this zone is visually attached to.
  final Offset position; // Normalized position (0.0 - 1.0) relative to container.
  final double size; // Normalized size (0.0 - 1.0) relative to container shortest side.
  final bool enabled;
  final int layoutVersion;
  final DateTime updatedAt;

  const MetaTapZoneConfig({
    required this.id,
    this.bubbleId,
    required this.position,
    required this.size,
    required this.enabled,
    required this.layoutVersion,
    required this.updatedAt,
  });

  MetaTapZoneConfig copyWith({
    String? id,
    String? bubbleId,
    Offset? position,
    double? size,
    bool? enabled,
    int? layoutVersion,
    DateTime? updatedAt,
  }) {
    return MetaTapZoneConfig(
      id: id ?? this.id,
      bubbleId: bubbleId ?? this.bubbleId,
      position: position ?? this.position,
      size: size ?? this.size,
      enabled: enabled ?? this.enabled,
      layoutVersion: layoutVersion ?? this.layoutVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /* 
   * Serialization is handled via simple maps or distinct fields in PositionPersistence,
   * but we can add toJson/fromJson if needed for debug or migrations.
   */
  
  @override
  String toString() => 'MetaTapZoneConfig(id: $id, pos: $position, size: $size, enabled: $enabled)';
}
