// lib/shared/utils/calibration_utils.dart
import 'package:flutter/widgets.dart';

class RelativeRectData {
  final double left;
  final double top;
  final double width;
  final double height;

  const RelativeRectData({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  Map<String, double> toJson() => {
        'left': left,
        'top': top,
        'width': width,
        'height': height,
      };

  factory RelativeRectData.fromJson(Map<String, dynamic> json) {
    return RelativeRectData(
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}

/// Convertit un Rect global (en coordonnées écran) en relatif [0..1] par rapport
/// au conteneur identifié par [containerKey].
RelativeRectData toRelativeRect(Rect globalRect, GlobalKey containerKey) {
  final RenderBox box =
      containerKey.currentContext!.findRenderObject() as RenderBox;
  final origin = box.localToGlobal(Offset.zero);
  final Size size = box.size;

  final localRect = Rect.fromLTWH(
    globalRect.left - origin.dx,
    globalRect.top - origin.dy,
    globalRect.width,
    globalRect.height,
  );

  return RelativeRectData(
    left: (localRect.left) / size.width,
    top: (localRect.top) / size.height,
    width: (localRect.width) / size.width,
    height: (localRect.height) / size.height,
  );
}

/// Reconstruit un Rect absolu (en pixels) à partir d'un RelativeRectData
Rect fromRelativeRect(RelativeRectData r, Size containerSize) {
  return Rect.fromLTWH(
    (r.left * containerSize.width),
    (r.top * containerSize.height),
    (r.width * containerSize.width),
    (r.height * containerSize.height),
  );
}


