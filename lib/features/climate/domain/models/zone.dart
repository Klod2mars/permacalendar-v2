import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

@freezed
class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String name,
    String? description,
    @Default(0) int monthShift,
    @Default(false) bool preferRelativeRules,
    @Default(false) bool preferSeasonDefinition,
    @Default([]) List<String> tags,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
}
