// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intelligence_runtime_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IntelligentAlertsState {
  List<NotificationAlert> get activeAlerts =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IntelligentAlertsStateCopyWith<IntelligentAlertsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntelligentAlertsStateCopyWith<$Res> {
  factory $IntelligentAlertsStateCopyWith(IntelligentAlertsState value,
          $Res Function(IntelligentAlertsState) then) =
      _$IntelligentAlertsStateCopyWithImpl<$Res, IntelligentAlertsState>;
  @useResult
  $Res call({List<NotificationAlert> activeAlerts});
}

/// @nodoc
class _$IntelligentAlertsStateCopyWithImpl<$Res,
        $Val extends IntelligentAlertsState>
    implements $IntelligentAlertsStateCopyWith<$Res> {
  _$IntelligentAlertsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeAlerts = null,
  }) {
    return _then(_value.copyWith(
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as List<NotificationAlert>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IntelligentAlertsStateImplCopyWith<$Res>
    implements $IntelligentAlertsStateCopyWith<$Res> {
  factory _$$IntelligentAlertsStateImplCopyWith(
          _$IntelligentAlertsStateImpl value,
          $Res Function(_$IntelligentAlertsStateImpl) then) =
      __$$IntelligentAlertsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<NotificationAlert> activeAlerts});
}

/// @nodoc
class __$$IntelligentAlertsStateImplCopyWithImpl<$Res>
    extends _$IntelligentAlertsStateCopyWithImpl<$Res,
        _$IntelligentAlertsStateImpl>
    implements _$$IntelligentAlertsStateImplCopyWith<$Res> {
  __$$IntelligentAlertsStateImplCopyWithImpl(
      _$IntelligentAlertsStateImpl _value,
      $Res Function(_$IntelligentAlertsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeAlerts = null,
  }) {
    return _then(_$IntelligentAlertsStateImpl(
      activeAlerts: null == activeAlerts
          ? _value._activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as List<NotificationAlert>,
    ));
  }
}

/// @nodoc

class _$IntelligentAlertsStateImpl implements _IntelligentAlertsState {
  const _$IntelligentAlertsStateImpl(
      {final List<NotificationAlert> activeAlerts =
          const <NotificationAlert>[]})
      : _activeAlerts = activeAlerts;

  final List<NotificationAlert> _activeAlerts;
  @override
  @JsonKey()
  List<NotificationAlert> get activeAlerts {
    if (_activeAlerts is EqualUnmodifiableListView) return _activeAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeAlerts);
  }

  @override
  String toString() {
    return 'IntelligentAlertsState(activeAlerts: $activeAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntelligentAlertsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._activeAlerts, _activeAlerts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_activeAlerts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntelligentAlertsStateImplCopyWith<_$IntelligentAlertsStateImpl>
      get copyWith => __$$IntelligentAlertsStateImplCopyWithImpl<
          _$IntelligentAlertsStateImpl>(this, _$identity);
}

abstract class _IntelligentAlertsState implements IntelligentAlertsState {
  const factory _IntelligentAlertsState(
          {final List<NotificationAlert> activeAlerts}) =
      _$IntelligentAlertsStateImpl;

  @override
  List<NotificationAlert> get activeAlerts;
  @override
  @JsonKey(ignore: true)
  _$$IntelligentAlertsStateImplCopyWith<_$IntelligentAlertsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
