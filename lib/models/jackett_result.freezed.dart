// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jackett_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JackettResult _$JackettResultFromJson(Map<String, dynamic> json) {
  return _JackettResult.fromJson(json);
}

/// @nodoc
mixin _$JackettResult {
  String get title => throw _privateConstructorUsedError;
  String get tracker => throw _privateConstructorUsedError;
  DateTime get publishDate => throw _privateConstructorUsedError;
  int get seeders => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  String? get magnetUri => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get languages => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  bool get isCached => throw _privateConstructorUsedError;

  /// Serializes this JackettResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JackettResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JackettResultCopyWith<JackettResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JackettResultCopyWith<$Res> {
  factory $JackettResultCopyWith(
          JackettResult value, $Res Function(JackettResult) then) =
      _$JackettResultCopyWithImpl<$Res, JackettResult>;
  @useResult
  $Res call(
      {String title,
      String tracker,
      DateTime publishDate,
      int seeders,
      int size,
      String? link,
      String? magnetUri,
      String? description,
      List<String> languages,
      List<String> categories,
      bool isCached});
}

/// @nodoc
class _$JackettResultCopyWithImpl<$Res, $Val extends JackettResult>
    implements $JackettResultCopyWith<$Res> {
  _$JackettResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JackettResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? tracker = null,
    Object? publishDate = null,
    Object? seeders = null,
    Object? size = null,
    Object? link = freezed,
    Object? magnetUri = freezed,
    Object? description = freezed,
    Object? languages = null,
    Object? categories = null,
    Object? isCached = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tracker: null == tracker
          ? _value.tracker
          : tracker // ignore: cast_nullable_to_non_nullable
              as String,
      publishDate: null == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      seeders: null == seeders
          ? _value.seeders
          : seeders // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      magnetUri: freezed == magnetUri
          ? _value.magnetUri
          : magnetUri // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCached: null == isCached
          ? _value.isCached
          : isCached // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JackettResultImplCopyWith<$Res>
    implements $JackettResultCopyWith<$Res> {
  factory _$$JackettResultImplCopyWith(
          _$JackettResultImpl value, $Res Function(_$JackettResultImpl) then) =
      __$$JackettResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String tracker,
      DateTime publishDate,
      int seeders,
      int size,
      String? link,
      String? magnetUri,
      String? description,
      List<String> languages,
      List<String> categories,
      bool isCached});
}

/// @nodoc
class __$$JackettResultImplCopyWithImpl<$Res>
    extends _$JackettResultCopyWithImpl<$Res, _$JackettResultImpl>
    implements _$$JackettResultImplCopyWith<$Res> {
  __$$JackettResultImplCopyWithImpl(
      _$JackettResultImpl _value, $Res Function(_$JackettResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of JackettResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? tracker = null,
    Object? publishDate = null,
    Object? seeders = null,
    Object? size = null,
    Object? link = freezed,
    Object? magnetUri = freezed,
    Object? description = freezed,
    Object? languages = null,
    Object? categories = null,
    Object? isCached = null,
  }) {
    return _then(_$JackettResultImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tracker: null == tracker
          ? _value.tracker
          : tracker // ignore: cast_nullable_to_non_nullable
              as String,
      publishDate: null == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      seeders: null == seeders
          ? _value.seeders
          : seeders // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      magnetUri: freezed == magnetUri
          ? _value.magnetUri
          : magnetUri // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCached: null == isCached
          ? _value.isCached
          : isCached // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JackettResultImpl implements _JackettResult {
  const _$JackettResultImpl(
      {required this.title,
      required this.tracker,
      required this.publishDate,
      required this.seeders,
      required this.size,
      this.link,
      this.magnetUri,
      this.description,
      final List<String> languages = const [],
      final List<String> categories = const [],
      this.isCached = false})
      : _languages = languages,
        _categories = categories;

  factory _$JackettResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$JackettResultImplFromJson(json);

  @override
  final String title;
  @override
  final String tracker;
  @override
  final DateTime publishDate;
  @override
  final int seeders;
  @override
  final int size;
  @override
  final String? link;
  @override
  final String? magnetUri;
  @override
  final String? description;
  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final bool isCached;

  @override
  String toString() {
    return 'JackettResult(title: $title, tracker: $tracker, publishDate: $publishDate, seeders: $seeders, size: $size, link: $link, magnetUri: $magnetUri, description: $description, languages: $languages, categories: $categories, isCached: $isCached)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JackettResultImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.tracker, tracker) || other.tracker == tracker) &&
            (identical(other.publishDate, publishDate) ||
                other.publishDate == publishDate) &&
            (identical(other.seeders, seeders) || other.seeders == seeders) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.magnetUri, magnetUri) ||
                other.magnetUri == magnetUri) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.isCached, isCached) ||
                other.isCached == isCached));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      tracker,
      publishDate,
      seeders,
      size,
      link,
      magnetUri,
      description,
      const DeepCollectionEquality().hash(_languages),
      const DeepCollectionEquality().hash(_categories),
      isCached);

  /// Create a copy of JackettResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JackettResultImplCopyWith<_$JackettResultImpl> get copyWith =>
      __$$JackettResultImplCopyWithImpl<_$JackettResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JackettResultImplToJson(
      this,
    );
  }
}

abstract class _JackettResult implements JackettResult {
  const factory _JackettResult(
      {required final String title,
      required final String tracker,
      required final DateTime publishDate,
      required final int seeders,
      required final int size,
      final String? link,
      final String? magnetUri,
      final String? description,
      final List<String> languages,
      final List<String> categories,
      final bool isCached}) = _$JackettResultImpl;

  factory _JackettResult.fromJson(Map<String, dynamic> json) =
      _$JackettResultImpl.fromJson;

  @override
  String get title;
  @override
  String get tracker;
  @override
  DateTime get publishDate;
  @override
  int get seeders;
  @override
  int get size;
  @override
  String? get link;
  @override
  String? get magnetUri;
  @override
  String? get description;
  @override
  List<String> get languages;
  @override
  List<String> get categories;
  @override
  bool get isCached;

  /// Create a copy of JackettResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JackettResultImplCopyWith<_$JackettResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
