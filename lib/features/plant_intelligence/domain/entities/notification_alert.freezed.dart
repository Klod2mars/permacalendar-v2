// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationAlert _$NotificationAlertFromJson(Map<String, dynamic> json) {
  return _NotificationAlert.fromJson(json);
}

/// @nodoc
mixin _$NotificationAlert {
  /// Identifiant unique de la notification
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;

  /// Titre de la notification
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;

  /// Message de la notification
  @HiveField(2)
  String get message => throw _privateConstructorUsedError;

  /// Type de notification
  @HiveField(3)
  NotificationType get type => throw _privateConstructorUsedError;

  /// Priorité de la notification
  @HiveField(4)
  NotificationPriority get priority => throw _privateConstructorUsedError;

  /// Sévérité de l'alerte
  @HiveField(14)
  AlertSeverity get severity => throw _privateConstructorUsedError;

  /// Date de Création
  @HiveField(5)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Date de lecture
  @HiveField(6)
  DateTime? get readAt => throw _privateConstructorUsedError;

  /// ID de la plante concernée (optionnel)
  @HiveField(7)
  String? get plantId => throw _privateConstructorUsedError;

  /// ID du jardin concerné (optionnel)
  @HiveField(8)
  String? get gardenId => throw _privateConstructorUsedError;

  /// ID de l'action associée (optionnel)
  @HiveField(9)
  String? get actionId => throw _privateConstructorUsedError;

  /// Statut de la notification
  @HiveField(10)
  NotificationStatus get status => throw _privateConstructorUsedError;

  /// Métadonnées flexibles
  @HiveField(11)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Date d'archivage
  @HiveField(12)
  DateTime? get archivedAt => throw _privateConstructorUsedError;

  /// Date de dismissal
  @HiveField(13)
  DateTime? get dismissedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationAlertCopyWith<NotificationAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationAlertCopyWith<$Res> {
  factory $NotificationAlertCopyWith(
          NotificationAlert value, $Res Function(NotificationAlert) then) =
      _$NotificationAlertCopyWithImpl<$Res, NotificationAlert>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String message,
      @HiveField(3) NotificationType type,
      @HiveField(4) NotificationPriority priority,
      @HiveField(14) AlertSeverity severity,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime? readAt,
      @HiveField(7) String? plantId,
      @HiveField(8) String? gardenId,
      @HiveField(9) String? actionId,
      @HiveField(10) NotificationStatus status,
      @HiveField(11) Map<String, dynamic> metadata,
      @HiveField(12) DateTime? archivedAt,
      @HiveField(13) DateTime? dismissedAt});
}

/// @nodoc
class _$NotificationAlertCopyWithImpl<$Res, $Val extends NotificationAlert>
    implements $NotificationAlertCopyWith<$Res> {
  _$NotificationAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? severity = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? plantId = freezed,
    Object? gardenId = freezed,
    Object? actionId = freezed,
    Object? status = null,
    Object? metadata = null,
    Object? archivedAt = freezed,
    Object? dismissedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plantId: freezed == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String?,
      gardenId: freezed == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String?,
      actionId: freezed == actionId
          ? _value.actionId
          : actionId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NotificationStatus,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dismissedAt: freezed == dismissedAt
          ? _value.dismissedAt
          : dismissedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationAlertImplCopyWith<$Res>
    implements $NotificationAlertCopyWith<$Res> {
  factory _$$NotificationAlertImplCopyWith(_$NotificationAlertImpl value,
          $Res Function(_$NotificationAlertImpl) then) =
      __$$NotificationAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String message,
      @HiveField(3) NotificationType type,
      @HiveField(4) NotificationPriority priority,
      @HiveField(14) AlertSeverity severity,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime? readAt,
      @HiveField(7) String? plantId,
      @HiveField(8) String? gardenId,
      @HiveField(9) String? actionId,
      @HiveField(10) NotificationStatus status,
      @HiveField(11) Map<String, dynamic> metadata,
      @HiveField(12) DateTime? archivedAt,
      @HiveField(13) DateTime? dismissedAt});
}

/// @nodoc
class __$$NotificationAlertImplCopyWithImpl<$Res>
    extends _$NotificationAlertCopyWithImpl<$Res, _$NotificationAlertImpl>
    implements _$$NotificationAlertImplCopyWith<$Res> {
  __$$NotificationAlertImplCopyWithImpl(_$NotificationAlertImpl _value,
      $Res Function(_$NotificationAlertImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? severity = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? plantId = freezed,
    Object? gardenId = freezed,
    Object? actionId = freezed,
    Object? status = null,
    Object? metadata = null,
    Object? archivedAt = freezed,
    Object? dismissedAt = freezed,
  }) {
    return _then(_$NotificationAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      plantId: freezed == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String?,
      gardenId: freezed == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String?,
      actionId: freezed == actionId
          ? _value.actionId
          : actionId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NotificationStatus,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dismissedAt: freezed == dismissedAt
          ? _value.dismissedAt
          : dismissedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationAlertImpl extends _NotificationAlert {
  const _$NotificationAlertImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.message,
      @HiveField(3) required this.type,
      @HiveField(4) required this.priority,
      @HiveField(14) this.severity = AlertSeverity.info,
      @HiveField(5) required this.createdAt,
      @HiveField(6) this.readAt,
      @HiveField(7) this.plantId,
      @HiveField(8) this.gardenId,
      @HiveField(9) this.actionId,
      @HiveField(10) this.status = NotificationStatus.unread,
      @HiveField(11) final Map<String, dynamic> metadata = const {},
      @HiveField(12) this.archivedAt,
      @HiveField(13) this.dismissedAt})
      : _metadata = metadata,
        super._();

  factory _$NotificationAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationAlertImplFromJson(json);

  /// Identifiant unique de la notification
  @override
  @HiveField(0)
  final String id;

  /// Titre de la notification
  @override
  @HiveField(1)
  final String title;

  /// Message de la notification
  @override
  @HiveField(2)
  final String message;

  /// Type de notification
  @override
  @HiveField(3)
  final NotificationType type;

  /// Priorité de la notification
  @override
  @HiveField(4)
  final NotificationPriority priority;

  /// Sévérité de l'alerte
  @override
  @JsonKey()
  @HiveField(14)
  final AlertSeverity severity;

  /// Date de Création
  @override
  @HiveField(5)
  final DateTime createdAt;

  /// Date de lecture
  @override
  @HiveField(6)
  final DateTime? readAt;

  /// ID de la plante concernée (optionnel)
  @override
  @HiveField(7)
  final String? plantId;

  /// ID du jardin concerné (optionnel)
  @override
  @HiveField(8)
  final String? gardenId;

  /// ID de l'action associée (optionnel)
  @override
  @HiveField(9)
  final String? actionId;

  /// Statut de la notification
  @override
  @JsonKey()
  @HiveField(10)
  final NotificationStatus status;

  /// Métadonnées flexibles
  final Map<String, dynamic> _metadata;

  /// Métadonnées flexibles
  @override
  @JsonKey()
  @HiveField(11)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  /// Date d'archivage
  @override
  @HiveField(12)
  final DateTime? archivedAt;

  /// Date de dismissal
  @override
  @HiveField(13)
  final DateTime? dismissedAt;

  @override
  String toString() {
    return 'NotificationAlert(id: $id, title: $title, message: $message, type: $type, priority: $priority, severity: $severity, createdAt: $createdAt, readAt: $readAt, plantId: $plantId, gardenId: $gardenId, actionId: $actionId, status: $status, metadata: $metadata, archivedAt: $archivedAt, dismissedAt: $dismissedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.archivedAt, archivedAt) ||
                other.archivedAt == archivedAt) &&
            (identical(other.dismissedAt, dismissedAt) ||
                other.dismissedAt == dismissedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      message,
      type,
      priority,
      severity,
      createdAt,
      readAt,
      plantId,
      gardenId,
      actionId,
      status,
      const DeepCollectionEquality().hash(_metadata),
      archivedAt,
      dismissedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationAlertImplCopyWith<_$NotificationAlertImpl> get copyWith =>
      __$$NotificationAlertImplCopyWithImpl<_$NotificationAlertImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationAlertImplToJson(
      this,
    );
  }
}

abstract class _NotificationAlert extends NotificationAlert {
  const factory _NotificationAlert(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final String message,
      @HiveField(3) required final NotificationType type,
      @HiveField(4) required final NotificationPriority priority,
      @HiveField(14) final AlertSeverity severity,
      @HiveField(5) required final DateTime createdAt,
      @HiveField(6) final DateTime? readAt,
      @HiveField(7) final String? plantId,
      @HiveField(8) final String? gardenId,
      @HiveField(9) final String? actionId,
      @HiveField(10) final NotificationStatus status,
      @HiveField(11) final Map<String, dynamic> metadata,
      @HiveField(12) final DateTime? archivedAt,
      @HiveField(13) final DateTime? dismissedAt}) = _$NotificationAlertImpl;
  const _NotificationAlert._() : super._();

  factory _NotificationAlert.fromJson(Map<String, dynamic> json) =
      _$NotificationAlertImpl.fromJson;

  @override

  /// Identifiant unique de la notification
  @HiveField(0)
  String get id;
  @override

  /// Titre de la notification
  @HiveField(1)
  String get title;
  @override

  /// Message de la notification
  @HiveField(2)
  String get message;
  @override

  /// Type de notification
  @HiveField(3)
  NotificationType get type;
  @override

  /// Priorité de la notification
  @HiveField(4)
  NotificationPriority get priority;
  @override

  /// Sévérité de l'alerte
  @HiveField(14)
  AlertSeverity get severity;
  @override

  /// Date de Création
  @HiveField(5)
  DateTime get createdAt;
  @override

  /// Date de lecture
  @HiveField(6)
  DateTime? get readAt;
  @override

  /// ID de la plante concernée (optionnel)
  @HiveField(7)
  String? get plantId;
  @override

  /// ID du jardin concerné (optionnel)
  @HiveField(8)
  String? get gardenId;
  @override

  /// ID de l'action associée (optionnel)
  @HiveField(9)
  String? get actionId;
  @override

  /// Statut de la notification
  @HiveField(10)
  NotificationStatus get status;
  @override

  /// Métadonnées flexibles
  @HiveField(11)
  Map<String, dynamic> get metadata;
  @override

  /// Date d'archivage
  @HiveField(12)
  DateTime? get archivedAt;
  @override

  /// Date de dismissal
  @HiveField(13)
  DateTime? get dismissedAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationAlertImplCopyWith<_$NotificationAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
