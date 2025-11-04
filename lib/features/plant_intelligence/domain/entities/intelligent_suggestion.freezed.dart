// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intelligent_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IntelligentSuggestion _$IntelligentSuggestionFromJson(
    Map<String, dynamic> json) {
  return _IntelligentSuggestion.fromJson(json);
}

/// @nodoc
mixin _$IntelligentSuggestion {
  /// Identifiant unique de la suggestion
  String get id => throw _privateConstructorUsedError;

  /// Identifiant du jardin concerné
  String get gardenId => throw _privateConstructorUsedError;

  /// Message de la suggestion (en français, clair et actionnable)
  /// Exemple : "C'est le moment idéal pour semer vos tomates"
  String get message => throw _privateConstructorUsedError;

  /// Niveau de priorité de la suggestion
  SuggestionPriority get priority => throw _privateConstructorUsedError;

  /// Catégorie de la suggestion
  SuggestionCategory get category => throw _privateConstructorUsedError;

  /// Date d'expiration de la suggestion (optionnelle)
  /// Si null, la suggestion reste active indéfiniment
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Suggestion lue par l'utilisateur ?
  bool get isRead => throw _privateConstructorUsedError;

  /// Suggestion actionnée par l'utilisateur ?
  bool get isActioned => throw _privateConstructorUsedError;

  /// Date de création de la suggestion
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IntelligentSuggestionCopyWith<IntelligentSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntelligentSuggestionCopyWith<$Res> {
  factory $IntelligentSuggestionCopyWith(IntelligentSuggestion value,
          $Res Function(IntelligentSuggestion) then) =
      _$IntelligentSuggestionCopyWithImpl<$Res, IntelligentSuggestion>;
  @useResult
  $Res call(
      {String id,
      String gardenId,
      String message,
      SuggestionPriority priority,
      SuggestionCategory category,
      DateTime? expiresAt,
      bool isRead,
      bool isActioned,
      DateTime createdAt});
}

/// @nodoc
class _$IntelligentSuggestionCopyWithImpl<$Res,
        $Val extends IntelligentSuggestion>
    implements $IntelligentSuggestionCopyWith<$Res> {
  _$IntelligentSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gardenId = null,
    Object? message = null,
    Object? priority = null,
    Object? category = null,
    Object? expiresAt = freezed,
    Object? isRead = null,
    Object? isActioned = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as SuggestionPriority,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SuggestionCategory,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isActioned: null == isActioned
          ? _value.isActioned
          : isActioned // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IntelligentSuggestionImplCopyWith<$Res>
    implements $IntelligentSuggestionCopyWith<$Res> {
  factory _$$IntelligentSuggestionImplCopyWith(
          _$IntelligentSuggestionImpl value,
          $Res Function(_$IntelligentSuggestionImpl) then) =
      __$$IntelligentSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String gardenId,
      String message,
      SuggestionPriority priority,
      SuggestionCategory category,
      DateTime? expiresAt,
      bool isRead,
      bool isActioned,
      DateTime createdAt});
}

/// @nodoc
class __$$IntelligentSuggestionImplCopyWithImpl<$Res>
    extends _$IntelligentSuggestionCopyWithImpl<$Res,
        _$IntelligentSuggestionImpl>
    implements _$$IntelligentSuggestionImplCopyWith<$Res> {
  __$$IntelligentSuggestionImplCopyWithImpl(_$IntelligentSuggestionImpl _value,
      $Res Function(_$IntelligentSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gardenId = null,
    Object? message = null,
    Object? priority = null,
    Object? category = null,
    Object? expiresAt = freezed,
    Object? isRead = null,
    Object? isActioned = null,
    Object? createdAt = null,
  }) {
    return _then(_$IntelligentSuggestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as SuggestionPriority,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SuggestionCategory,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isActioned: null == isActioned
          ? _value.isActioned
          : isActioned // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntelligentSuggestionImpl implements _IntelligentSuggestion {
  const _$IntelligentSuggestionImpl(
      {required this.id,
      required this.gardenId,
      required this.message,
      required this.priority,
      required this.category,
      this.expiresAt,
      this.isRead = false,
      this.isActioned = false,
      required this.createdAt});

  factory _$IntelligentSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntelligentSuggestionImplFromJson(json);

  /// Identifiant unique de la suggestion
  @override
  final String id;

  /// Identifiant du jardin concerné
  @override
  final String gardenId;

  /// Message de la suggestion (en français, clair et actionnable)
  /// Exemple : "C'est le moment idéal pour semer vos tomates"
  @override
  final String message;

  /// Niveau de priorité de la suggestion
  @override
  final SuggestionPriority priority;

  /// Catégorie de la suggestion
  @override
  final SuggestionCategory category;

  /// Date d'expiration de la suggestion (optionnelle)
  /// Si null, la suggestion reste active indéfiniment
  @override
  final DateTime? expiresAt;

  /// Suggestion lue par l'utilisateur ?
  @override
  @JsonKey()
  final bool isRead;

  /// Suggestion actionnée par l'utilisateur ?
  @override
  @JsonKey()
  final bool isActioned;

  /// Date de création de la suggestion
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'IntelligentSuggestion(id: $id, gardenId: $gardenId, message: $message, priority: $priority, category: $category, expiresAt: $expiresAt, isRead: $isRead, isActioned: $isActioned, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntelligentSuggestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isActioned, isActioned) ||
                other.isActioned == isActioned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, gardenId, message, priority,
      category, expiresAt, isRead, isActioned, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntelligentSuggestionImplCopyWith<_$IntelligentSuggestionImpl>
      get copyWith => __$$IntelligentSuggestionImplCopyWithImpl<
          _$IntelligentSuggestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IntelligentSuggestionImplToJson(
      this,
    );
  }
}

abstract class _IntelligentSuggestion implements IntelligentSuggestion {
  const factory _IntelligentSuggestion(
      {required final String id,
      required final String gardenId,
      required final String message,
      required final SuggestionPriority priority,
      required final SuggestionCategory category,
      final DateTime? expiresAt,
      final bool isRead,
      final bool isActioned,
      required final DateTime createdAt}) = _$IntelligentSuggestionImpl;

  factory _IntelligentSuggestion.fromJson(Map<String, dynamic> json) =
      _$IntelligentSuggestionImpl.fromJson;

  @override

  /// Identifiant unique de la suggestion
  String get id;
  @override

  /// Identifiant du jardin concerné
  String get gardenId;
  @override

  /// Message de la suggestion (en français, clair et actionnable)
  /// Exemple : "C'est le moment idéal pour semer vos tomates"
  String get message;
  @override

  /// Niveau de priorité de la suggestion
  SuggestionPriority get priority;
  @override

  /// Catégorie de la suggestion
  SuggestionCategory get category;
  @override

  /// Date d'expiration de la suggestion (optionnelle)
  /// Si null, la suggestion reste active indéfiniment
  DateTime? get expiresAt;
  @override

  /// Suggestion lue par l'utilisateur ?
  bool get isRead;
  @override

  /// Suggestion actionnée par l'utilisateur ?
  bool get isActioned;
  @override

  /// Date de création de la suggestion
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$IntelligentSuggestionImplCopyWith<_$IntelligentSuggestionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
