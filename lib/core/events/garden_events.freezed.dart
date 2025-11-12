// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GardenEvent {
  String get gardenId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String gardenId, String plantingId,
            String plantId, DateTime timestamp, Map<String, dynamic>? metadata)
        plantingAdded,
    required TResult Function(
            String gardenId,
            String plantingId,
            double harvestYield,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        plantingHarvested,
    required TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        weatherChanged,
    required TResult Function(
            String gardenId,
            String activityType,
            String? targetId,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        activityPerformed,
    required TResult Function(
            String gardenId, DateTime timestamp, Map<String, dynamic>? metadata)
        gardenContextUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult? Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult? Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult? Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult? Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantingAddedEvent value) plantingAdded,
    required TResult Function(PlantingHarvestedEvent value) plantingHarvested,
    required TResult Function(WeatherChangedEvent value) weatherChanged,
    required TResult Function(ActivityPerformedEvent value) activityPerformed,
    required TResult Function(GardenContextUpdatedEvent value)
        gardenContextUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantingAddedEvent value)? plantingAdded,
    TResult? Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult? Function(WeatherChangedEvent value)? weatherChanged,
    TResult? Function(ActivityPerformedEvent value)? activityPerformed,
    TResult? Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantingAddedEvent value)? plantingAdded,
    TResult Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult Function(WeatherChangedEvent value)? weatherChanged,
    TResult Function(ActivityPerformedEvent value)? activityPerformed,
    TResult Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GardenEventCopyWith<GardenEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenEventCopyWith<$Res> {
  factory $GardenEventCopyWith(
          GardenEvent value, $Res Function(GardenEvent) then) =
      _$GardenEventCopyWithImpl<$Res, GardenEvent>;
  @useResult
  $Res call(
      {String gardenId, DateTime timestamp, Map<String, dynamic>? metadata});
}

/// @nodoc
class _$GardenEventCopyWithImpl<$Res, $Val extends GardenEvent>
    implements $GardenEventCopyWith<$Res> {
  _$GardenEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantingAddedEventImplCopyWith<$Res>
    implements $GardenEventCopyWith<$Res> {
  factory _$$PlantingAddedEventImplCopyWith(_$PlantingAddedEventImpl value,
          $Res Function(_$PlantingAddedEventImpl) then) =
      __$$PlantingAddedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      String plantingId,
      String plantId,
      DateTime timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PlantingAddedEventImplCopyWithImpl<$Res>
    extends _$GardenEventCopyWithImpl<$Res, _$PlantingAddedEventImpl>
    implements _$$PlantingAddedEventImplCopyWith<$Res> {
  __$$PlantingAddedEventImplCopyWithImpl(_$PlantingAddedEventImpl _value,
      $Res Function(_$PlantingAddedEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? plantingId = null,
    Object? plantId = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PlantingAddedEventImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      plantingId: null == plantingId
          ? _value.plantingId
          : plantingId // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$PlantingAddedEventImpl implements PlantingAddedEvent {
  const _$PlantingAddedEventImpl(
      {required this.gardenId,
      required this.plantingId,
      required this.plantId,
      required this.timestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final String gardenId;
  @override
  final String plantingId;
  @override
  final String plantId;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GardenEvent.plantingAdded(gardenId: $gardenId, plantingId: $plantingId, plantId: $plantId, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantingAddedEventImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.plantingId, plantingId) ||
                other.plantingId == plantingId) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gardenId, plantingId, plantId,
      timestamp, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantingAddedEventImplCopyWith<_$PlantingAddedEventImpl> get copyWith =>
      __$$PlantingAddedEventImplCopyWithImpl<_$PlantingAddedEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String gardenId, String plantingId,
            String plantId, DateTime timestamp, Map<String, dynamic>? metadata)
        plantingAdded,
    required TResult Function(
            String gardenId,
            String plantingId,
            double harvestYield,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        plantingHarvested,
    required TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        weatherChanged,
    required TResult Function(
            String gardenId,
            String activityType,
            String? targetId,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        activityPerformed,
    required TResult Function(
            String gardenId, DateTime timestamp, Map<String, dynamic>? metadata)
        gardenContextUpdated,
  }) {
    return plantingAdded(gardenId, plantingId, plantId, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult? Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult? Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult? Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult? Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
  }) {
    return plantingAdded?.call(
        gardenId, plantingId, plantId, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (plantingAdded != null) {
      return plantingAdded(gardenId, plantingId, plantId, timestamp, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantingAddedEvent value) plantingAdded,
    required TResult Function(PlantingHarvestedEvent value) plantingHarvested,
    required TResult Function(WeatherChangedEvent value) weatherChanged,
    required TResult Function(ActivityPerformedEvent value) activityPerformed,
    required TResult Function(GardenContextUpdatedEvent value)
        gardenContextUpdated,
  }) {
    return plantingAdded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantingAddedEvent value)? plantingAdded,
    TResult? Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult? Function(WeatherChangedEvent value)? weatherChanged,
    TResult? Function(ActivityPerformedEvent value)? activityPerformed,
    TResult? Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
  }) {
    return plantingAdded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantingAddedEvent value)? plantingAdded,
    TResult Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult Function(WeatherChangedEvent value)? weatherChanged,
    TResult Function(ActivityPerformedEvent value)? activityPerformed,
    TResult Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (plantingAdded != null) {
      return plantingAdded(this);
    }
    return orElse();
  }
}

abstract class PlantingAddedEvent implements GardenEvent {
  const factory PlantingAddedEvent(
      {required final String gardenId,
      required final String plantingId,
      required final String plantId,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata}) = _$PlantingAddedEventImpl;

  @override
  String get gardenId;
  String get plantingId;
  String get plantId;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PlantingAddedEventImplCopyWith<_$PlantingAddedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlantingHarvestedEventImplCopyWith<$Res>
    implements $GardenEventCopyWith<$Res> {
  factory _$$PlantingHarvestedEventImplCopyWith(
          _$PlantingHarvestedEventImpl value,
          $Res Function(_$PlantingHarvestedEventImpl) then) =
      __$$PlantingHarvestedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      String plantingId,
      double harvestYield,
      DateTime timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PlantingHarvestedEventImplCopyWithImpl<$Res>
    extends _$GardenEventCopyWithImpl<$Res, _$PlantingHarvestedEventImpl>
    implements _$$PlantingHarvestedEventImplCopyWith<$Res> {
  __$$PlantingHarvestedEventImplCopyWithImpl(
      _$PlantingHarvestedEventImpl _value,
      $Res Function(_$PlantingHarvestedEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? plantingId = null,
    Object? harvestYield = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PlantingHarvestedEventImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      plantingId: null == plantingId
          ? _value.plantingId
          : plantingId // ignore: cast_nullable_to_non_nullable
              as String,
      harvestYield: null == harvestYield
          ? _value.harvestYield
          : harvestYield // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$PlantingHarvestedEventImpl implements PlantingHarvestedEvent {
  const _$PlantingHarvestedEventImpl(
      {required this.gardenId,
      required this.plantingId,
      required this.harvestYield,
      required this.timestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final String gardenId;
  @override
  final String plantingId;
  @override
  final double harvestYield;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GardenEvent.plantingHarvested(gardenId: $gardenId, plantingId: $plantingId, harvestYield: $harvestYield, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantingHarvestedEventImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.plantingId, plantingId) ||
                other.plantingId == plantingId) &&
            (identical(other.harvestYield, harvestYield) ||
                other.harvestYield == harvestYield) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gardenId, plantingId,
      harvestYield, timestamp, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantingHarvestedEventImplCopyWith<_$PlantingHarvestedEventImpl>
      get copyWith => __$$PlantingHarvestedEventImplCopyWithImpl<
          _$PlantingHarvestedEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String gardenId, String plantingId,
            String plantId, DateTime timestamp, Map<String, dynamic>? metadata)
        plantingAdded,
    required TResult Function(
            String gardenId,
            String plantingId,
            double harvestYield,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        plantingHarvested,
    required TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        weatherChanged,
    required TResult Function(
            String gardenId,
            String activityType,
            String? targetId,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        activityPerformed,
    required TResult Function(
            String gardenId, DateTime timestamp, Map<String, dynamic>? metadata)
        gardenContextUpdated,
  }) {
    return plantingHarvested(
        gardenId, plantingId, harvestYield, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult? Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult? Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult? Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult? Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
  }) {
    return plantingHarvested?.call(
        gardenId, plantingId, harvestYield, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (plantingHarvested != null) {
      return plantingHarvested(
          gardenId, plantingId, harvestYield, timestamp, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantingAddedEvent value) plantingAdded,
    required TResult Function(PlantingHarvestedEvent value) plantingHarvested,
    required TResult Function(WeatherChangedEvent value) weatherChanged,
    required TResult Function(ActivityPerformedEvent value) activityPerformed,
    required TResult Function(GardenContextUpdatedEvent value)
        gardenContextUpdated,
  }) {
    return plantingHarvested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantingAddedEvent value)? plantingAdded,
    TResult? Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult? Function(WeatherChangedEvent value)? weatherChanged,
    TResult? Function(ActivityPerformedEvent value)? activityPerformed,
    TResult? Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
  }) {
    return plantingHarvested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantingAddedEvent value)? plantingAdded,
    TResult Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult Function(WeatherChangedEvent value)? weatherChanged,
    TResult Function(ActivityPerformedEvent value)? activityPerformed,
    TResult Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (plantingHarvested != null) {
      return plantingHarvested(this);
    }
    return orElse();
  }
}

abstract class PlantingHarvestedEvent implements GardenEvent {
  const factory PlantingHarvestedEvent(
      {required final String gardenId,
      required final String plantingId,
      required final double harvestYield,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata}) = _$PlantingHarvestedEventImpl;

  @override
  String get gardenId;
  String get plantingId;
  double get harvestYield;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PlantingHarvestedEventImplCopyWith<_$PlantingHarvestedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WeatherChangedEventImplCopyWith<$Res>
    implements $GardenEventCopyWith<$Res> {
  factory _$$WeatherChangedEventImplCopyWith(_$WeatherChangedEventImpl value,
          $Res Function(_$WeatherChangedEventImpl) then) =
      __$$WeatherChangedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      double previousTemperature,
      double currentTemperature,
      DateTime timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$WeatherChangedEventImplCopyWithImpl<$Res>
    extends _$GardenEventCopyWithImpl<$Res, _$WeatherChangedEventImpl>
    implements _$$WeatherChangedEventImplCopyWith<$Res> {
  __$$WeatherChangedEventImplCopyWithImpl(_$WeatherChangedEventImpl _value,
      $Res Function(_$WeatherChangedEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? previousTemperature = null,
    Object? currentTemperature = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$WeatherChangedEventImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      previousTemperature: null == previousTemperature
          ? _value.previousTemperature
          : previousTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      currentTemperature: null == currentTemperature
          ? _value.currentTemperature
          : currentTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$WeatherChangedEventImpl implements WeatherChangedEvent {
  const _$WeatherChangedEventImpl(
      {required this.gardenId,
      required this.previousTemperature,
      required this.currentTemperature,
      required this.timestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final String gardenId;
  @override
  final double previousTemperature;
  @override
  final double currentTemperature;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GardenEvent.weatherChanged(gardenId: $gardenId, previousTemperature: $previousTemperature, currentTemperature: $currentTemperature, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherChangedEventImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.previousTemperature, previousTemperature) ||
                other.previousTemperature == previousTemperature) &&
            (identical(other.currentTemperature, currentTemperature) ||
                other.currentTemperature == currentTemperature) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      gardenId,
      previousTemperature,
      currentTemperature,
      timestamp,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherChangedEventImplCopyWith<_$WeatherChangedEventImpl> get copyWith =>
      __$$WeatherChangedEventImplCopyWithImpl<_$WeatherChangedEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String gardenId, String plantingId,
            String plantId, DateTime timestamp, Map<String, dynamic>? metadata)
        plantingAdded,
    required TResult Function(
            String gardenId,
            String plantingId,
            double harvestYield,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        plantingHarvested,
    required TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        weatherChanged,
    required TResult Function(
            String gardenId,
            String activityType,
            String? targetId,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        activityPerformed,
    required TResult Function(
            String gardenId, DateTime timestamp, Map<String, dynamic>? metadata)
        gardenContextUpdated,
  }) {
    return weatherChanged(
        gardenId, previousTemperature, currentTemperature, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult? Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult? Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult? Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult? Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
  }) {
    return weatherChanged?.call(
        gardenId, previousTemperature, currentTemperature, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (weatherChanged != null) {
      return weatherChanged(gardenId, previousTemperature, currentTemperature,
          timestamp, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantingAddedEvent value) plantingAdded,
    required TResult Function(PlantingHarvestedEvent value) plantingHarvested,
    required TResult Function(WeatherChangedEvent value) weatherChanged,
    required TResult Function(ActivityPerformedEvent value) activityPerformed,
    required TResult Function(GardenContextUpdatedEvent value)
        gardenContextUpdated,
  }) {
    return weatherChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantingAddedEvent value)? plantingAdded,
    TResult? Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult? Function(WeatherChangedEvent value)? weatherChanged,
    TResult? Function(ActivityPerformedEvent value)? activityPerformed,
    TResult? Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
  }) {
    return weatherChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantingAddedEvent value)? plantingAdded,
    TResult Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult Function(WeatherChangedEvent value)? weatherChanged,
    TResult Function(ActivityPerformedEvent value)? activityPerformed,
    TResult Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (weatherChanged != null) {
      return weatherChanged(this);
    }
    return orElse();
  }
}

abstract class WeatherChangedEvent implements GardenEvent {
  const factory WeatherChangedEvent(
      {required final String gardenId,
      required final double previousTemperature,
      required final double currentTemperature,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata}) = _$WeatherChangedEventImpl;

  @override
  String get gardenId;
  double get previousTemperature;
  double get currentTemperature;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$WeatherChangedEventImplCopyWith<_$WeatherChangedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActivityPerformedEventImplCopyWith<$Res>
    implements $GardenEventCopyWith<$Res> {
  factory _$$ActivityPerformedEventImplCopyWith(
          _$ActivityPerformedEventImpl value,
          $Res Function(_$ActivityPerformedEventImpl) then) =
      __$$ActivityPerformedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      String activityType,
      String? targetId,
      DateTime timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ActivityPerformedEventImplCopyWithImpl<$Res>
    extends _$GardenEventCopyWithImpl<$Res, _$ActivityPerformedEventImpl>
    implements _$$ActivityPerformedEventImplCopyWith<$Res> {
  __$$ActivityPerformedEventImplCopyWithImpl(
      _$ActivityPerformedEventImpl _value,
      $Res Function(_$ActivityPerformedEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? activityType = null,
    Object? targetId = freezed,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$ActivityPerformedEventImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ActivityPerformedEventImpl implements ActivityPerformedEvent {
  const _$ActivityPerformedEventImpl(
      {required this.gardenId,
      required this.activityType,
      this.targetId,
      required this.timestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final String gardenId;
  @override
  final String activityType;
// watering, fertilizing, pruning, etc.
  @override
  final String? targetId;
// planting ou bed ID
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GardenEvent.activityPerformed(gardenId: $gardenId, activityType: $activityType, targetId: $targetId, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityPerformedEventImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gardenId, activityType, targetId,
      timestamp, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityPerformedEventImplCopyWith<_$ActivityPerformedEventImpl>
      get copyWith => __$$ActivityPerformedEventImplCopyWithImpl<
          _$ActivityPerformedEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String gardenId, String plantingId,
            String plantId, DateTime timestamp, Map<String, dynamic>? metadata)
        plantingAdded,
    required TResult Function(
            String gardenId,
            String plantingId,
            double harvestYield,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        plantingHarvested,
    required TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        weatherChanged,
    required TResult Function(
            String gardenId,
            String activityType,
            String? targetId,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        activityPerformed,
    required TResult Function(
            String gardenId, DateTime timestamp, Map<String, dynamic>? metadata)
        gardenContextUpdated,
  }) {
    return activityPerformed(
        gardenId, activityType, targetId, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult? Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult? Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult? Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult? Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
  }) {
    return activityPerformed?.call(
        gardenId, activityType, targetId, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (activityPerformed != null) {
      return activityPerformed(
          gardenId, activityType, targetId, timestamp, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantingAddedEvent value) plantingAdded,
    required TResult Function(PlantingHarvestedEvent value) plantingHarvested,
    required TResult Function(WeatherChangedEvent value) weatherChanged,
    required TResult Function(ActivityPerformedEvent value) activityPerformed,
    required TResult Function(GardenContextUpdatedEvent value)
        gardenContextUpdated,
  }) {
    return activityPerformed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantingAddedEvent value)? plantingAdded,
    TResult? Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult? Function(WeatherChangedEvent value)? weatherChanged,
    TResult? Function(ActivityPerformedEvent value)? activityPerformed,
    TResult? Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
  }) {
    return activityPerformed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantingAddedEvent value)? plantingAdded,
    TResult Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult Function(WeatherChangedEvent value)? weatherChanged,
    TResult Function(ActivityPerformedEvent value)? activityPerformed,
    TResult Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (activityPerformed != null) {
      return activityPerformed(this);
    }
    return orElse();
  }
}

abstract class ActivityPerformedEvent implements GardenEvent {
  const factory ActivityPerformedEvent(
      {required final String gardenId,
      required final String activityType,
      final String? targetId,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata}) = _$ActivityPerformedEventImpl;

  @override
  String get gardenId;
  String get activityType; // watering, fertilizing, pruning, etc.
  String? get targetId;
  @override // planting ou bed ID
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ActivityPerformedEventImplCopyWith<_$ActivityPerformedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GardenContextUpdatedEventImplCopyWith<$Res>
    implements $GardenEventCopyWith<$Res> {
  factory _$$GardenContextUpdatedEventImplCopyWith(
          _$GardenContextUpdatedEventImpl value,
          $Res Function(_$GardenContextUpdatedEventImpl) then) =
      __$$GardenContextUpdatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId, DateTime timestamp, Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$GardenContextUpdatedEventImplCopyWithImpl<$Res>
    extends _$GardenEventCopyWithImpl<$Res, _$GardenContextUpdatedEventImpl>
    implements _$$GardenContextUpdatedEventImplCopyWith<$Res> {
  __$$GardenContextUpdatedEventImplCopyWithImpl(
      _$GardenContextUpdatedEventImpl _value,
      $Res Function(_$GardenContextUpdatedEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$GardenContextUpdatedEventImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$GardenContextUpdatedEventImpl implements GardenContextUpdatedEvent {
  const _$GardenContextUpdatedEventImpl(
      {required this.gardenId,
      required this.timestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final String gardenId;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GardenEvent.gardenContextUpdated(gardenId: $gardenId, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenContextUpdatedEventImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gardenId, timestamp,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenContextUpdatedEventImplCopyWith<_$GardenContextUpdatedEventImpl>
      get copyWith => __$$GardenContextUpdatedEventImplCopyWithImpl<
          _$GardenContextUpdatedEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String gardenId, String plantingId,
            String plantId, DateTime timestamp, Map<String, dynamic>? metadata)
        plantingAdded,
    required TResult Function(
            String gardenId,
            String plantingId,
            double harvestYield,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        plantingHarvested,
    required TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        weatherChanged,
    required TResult Function(
            String gardenId,
            String activityType,
            String? targetId,
            DateTime timestamp,
            Map<String, dynamic>? metadata)
        activityPerformed,
    required TResult Function(
            String gardenId, DateTime timestamp, Map<String, dynamic>? metadata)
        gardenContextUpdated,
  }) {
    return gardenContextUpdated(gardenId, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult? Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult? Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult? Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult? Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
  }) {
    return gardenContextUpdated?.call(gardenId, timestamp, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String gardenId, String plantingId, String plantId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingAdded,
    TResult Function(String gardenId, String plantingId, double harvestYield,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        plantingHarvested,
    TResult Function(
            String gardenId,
            double previousTemperature,
            double currentTemperature,
            DateTime timestamp,
            Map<String, dynamic>? metadata)?
        weatherChanged,
    TResult Function(String gardenId, String activityType, String? targetId,
            DateTime timestamp, Map<String, dynamic>? metadata)?
        activityPerformed,
    TResult Function(String gardenId, DateTime timestamp,
            Map<String, dynamic>? metadata)?
        gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (gardenContextUpdated != null) {
      return gardenContextUpdated(gardenId, timestamp, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlantingAddedEvent value) plantingAdded,
    required TResult Function(PlantingHarvestedEvent value) plantingHarvested,
    required TResult Function(WeatherChangedEvent value) weatherChanged,
    required TResult Function(ActivityPerformedEvent value) activityPerformed,
    required TResult Function(GardenContextUpdatedEvent value)
        gardenContextUpdated,
  }) {
    return gardenContextUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlantingAddedEvent value)? plantingAdded,
    TResult? Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult? Function(WeatherChangedEvent value)? weatherChanged,
    TResult? Function(ActivityPerformedEvent value)? activityPerformed,
    TResult? Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
  }) {
    return gardenContextUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlantingAddedEvent value)? plantingAdded,
    TResult Function(PlantingHarvestedEvent value)? plantingHarvested,
    TResult Function(WeatherChangedEvent value)? weatherChanged,
    TResult Function(ActivityPerformedEvent value)? activityPerformed,
    TResult Function(GardenContextUpdatedEvent value)? gardenContextUpdated,
    required TResult orElse(),
  }) {
    if (gardenContextUpdated != null) {
      return gardenContextUpdated(this);
    }
    return orElse();
  }
}

abstract class GardenContextUpdatedEvent implements GardenEvent {
  const factory GardenContextUpdatedEvent(
      {required final String gardenId,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata}) = _$GardenContextUpdatedEventImpl;

  @override
  String get gardenId;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$GardenContextUpdatedEventImplCopyWith<_$GardenContextUpdatedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

