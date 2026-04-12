// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CharacterProfile _$CharacterProfileFromJson(Map<String, dynamic> json) {
  return _CharacterProfile.fromJson(json);
}

/// @nodoc
mixin _$CharacterProfile {
  String get id => throw _privateConstructorUsedError;
  String get novelId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get personality => throw _privateConstructorUsedError;
  List<String> get redLines => throw _privateConstructorUsedError; // 人设红线
  List<String> get backstories => throw _privateConstructorUsedError;

  /// Serializes this CharacterProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CharacterProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterProfileCopyWith<CharacterProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterProfileCopyWith<$Res> {
  factory $CharacterProfileCopyWith(
          CharacterProfile value, $Res Function(CharacterProfile) then) =
      _$CharacterProfileCopyWithImpl<$Res, CharacterProfile>;
  @useResult
  $Res call(
      {String id,
      String novelId,
      String name,
      String alias,
      String personality,
      List<String> redLines,
      List<String> backstories});
}

/// @nodoc
class _$CharacterProfileCopyWithImpl<$Res, $Val extends CharacterProfile>
    implements $CharacterProfileCopyWith<$Res> {
  _$CharacterProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? novelId = null,
    Object? name = null,
    Object? alias = null,
    Object? personality = null,
    Object? redLines = null,
    Object? backstories = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      novelId: null == novelId
          ? _value.novelId
          : novelId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      personality: null == personality
          ? _value.personality
          : personality // ignore: cast_nullable_to_non_nullable
              as String,
      redLines: null == redLines
          ? _value.redLines
          : redLines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      backstories: null == backstories
          ? _value.backstories
          : backstories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterProfileImplCopyWith<$Res>
    implements $CharacterProfileCopyWith<$Res> {
  factory _$$CharacterProfileImplCopyWith(_$CharacterProfileImpl value,
          $Res Function(_$CharacterProfileImpl) then) =
      __$$CharacterProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String novelId,
      String name,
      String alias,
      String personality,
      List<String> redLines,
      List<String> backstories});
}

/// @nodoc
class __$$CharacterProfileImplCopyWithImpl<$Res>
    extends _$CharacterProfileCopyWithImpl<$Res, _$CharacterProfileImpl>
    implements _$$CharacterProfileImplCopyWith<$Res> {
  __$$CharacterProfileImplCopyWithImpl(_$CharacterProfileImpl _value,
      $Res Function(_$CharacterProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of CharacterProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? novelId = null,
    Object? name = null,
    Object? alias = null,
    Object? personality = null,
    Object? redLines = null,
    Object? backstories = null,
  }) {
    return _then(_$CharacterProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      novelId: null == novelId
          ? _value.novelId
          : novelId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      personality: null == personality
          ? _value.personality
          : personality // ignore: cast_nullable_to_non_nullable
              as String,
      redLines: null == redLines
          ? _value._redLines
          : redLines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      backstories: null == backstories
          ? _value._backstories
          : backstories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterProfileImpl implements _CharacterProfile {
  const _$CharacterProfileImpl(
      {required this.id,
      required this.novelId,
      required this.name,
      this.alias = '',
      this.personality = '',
      final List<String> redLines = const [],
      final List<String> backstories = const []})
      : _redLines = redLines,
        _backstories = backstories;

  factory _$CharacterProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String novelId;
  @override
  final String name;
  @override
  @JsonKey()
  final String alias;
  @override
  @JsonKey()
  final String personality;
  final List<String> _redLines;
  @override
  @JsonKey()
  List<String> get redLines {
    if (_redLines is EqualUnmodifiableListView) return _redLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_redLines);
  }

// 人设红线
  final List<String> _backstories;
// 人设红线
  @override
  @JsonKey()
  List<String> get backstories {
    if (_backstories is EqualUnmodifiableListView) return _backstories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_backstories);
  }

  @override
  String toString() {
    return 'CharacterProfile(id: $id, novelId: $novelId, name: $name, alias: $alias, personality: $personality, redLines: $redLines, backstories: $backstories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.novelId, novelId) || other.novelId == novelId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.personality, personality) ||
                other.personality == personality) &&
            const DeepCollectionEquality().equals(other._redLines, _redLines) &&
            const DeepCollectionEquality()
                .equals(other._backstories, _backstories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      novelId,
      name,
      alias,
      personality,
      const DeepCollectionEquality().hash(_redLines),
      const DeepCollectionEquality().hash(_backstories));

  /// Create a copy of CharacterProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterProfileImplCopyWith<_$CharacterProfileImpl> get copyWith =>
      __$$CharacterProfileImplCopyWithImpl<_$CharacterProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterProfileImplToJson(
      this,
    );
  }
}

abstract class _CharacterProfile implements CharacterProfile {
  const factory _CharacterProfile(
      {required final String id,
      required final String novelId,
      required final String name,
      final String alias,
      final String personality,
      final List<String> redLines,
      final List<String> backstories}) = _$CharacterProfileImpl;

  factory _CharacterProfile.fromJson(Map<String, dynamic> json) =
      _$CharacterProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get novelId;
  @override
  String get name;
  @override
  String get alias;
  @override
  String get personality;
  @override
  List<String> get redLines; // 人设红线
  @override
  List<String> get backstories;

  /// Create a copy of CharacterProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterProfileImplCopyWith<_$CharacterProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NovelWorldSetting _$NovelWorldSettingFromJson(Map<String, dynamic> json) {
  return _NovelWorldSetting.fromJson(json);
}

/// @nodoc
mixin _$NovelWorldSetting {
  String get id => throw _privateConstructorUsedError;
  String get novelId => throw _privateConstructorUsedError;
  String get era => throw _privateConstructorUsedError; // 时代背景
  String get geography => throw _privateConstructorUsedError; // 地理区域
  String get powerSystem => throw _privateConstructorUsedError; // 力量体系
  String get society => throw _privateConstructorUsedError; // 社会结构
  List<String> get forbiddenRules => throw _privateConstructorUsedError; // 设定禁区
  List<Foreshadow> get foreshadows => throw _privateConstructorUsedError;

  /// Serializes this NovelWorldSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NovelWorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NovelWorldSettingCopyWith<NovelWorldSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NovelWorldSettingCopyWith<$Res> {
  factory $NovelWorldSettingCopyWith(
          NovelWorldSetting value, $Res Function(NovelWorldSetting) then) =
      _$NovelWorldSettingCopyWithImpl<$Res, NovelWorldSetting>;
  @useResult
  $Res call(
      {String id,
      String novelId,
      String era,
      String geography,
      String powerSystem,
      String society,
      List<String> forbiddenRules,
      List<Foreshadow> foreshadows});
}

/// @nodoc
class _$NovelWorldSettingCopyWithImpl<$Res, $Val extends NovelWorldSetting>
    implements $NovelWorldSettingCopyWith<$Res> {
  _$NovelWorldSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NovelWorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? novelId = null,
    Object? era = null,
    Object? geography = null,
    Object? powerSystem = null,
    Object? society = null,
    Object? forbiddenRules = null,
    Object? foreshadows = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      novelId: null == novelId
          ? _value.novelId
          : novelId // ignore: cast_nullable_to_non_nullable
              as String,
      era: null == era
          ? _value.era
          : era // ignore: cast_nullable_to_non_nullable
              as String,
      geography: null == geography
          ? _value.geography
          : geography // ignore: cast_nullable_to_non_nullable
              as String,
      powerSystem: null == powerSystem
          ? _value.powerSystem
          : powerSystem // ignore: cast_nullable_to_non_nullable
              as String,
      society: null == society
          ? _value.society
          : society // ignore: cast_nullable_to_non_nullable
              as String,
      forbiddenRules: null == forbiddenRules
          ? _value.forbiddenRules
          : forbiddenRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      foreshadows: null == foreshadows
          ? _value.foreshadows
          : foreshadows // ignore: cast_nullable_to_non_nullable
              as List<Foreshadow>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NovelWorldSettingImplCopyWith<$Res>
    implements $NovelWorldSettingCopyWith<$Res> {
  factory _$$NovelWorldSettingImplCopyWith(_$NovelWorldSettingImpl value,
          $Res Function(_$NovelWorldSettingImpl) then) =
      __$$NovelWorldSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String novelId,
      String era,
      String geography,
      String powerSystem,
      String society,
      List<String> forbiddenRules,
      List<Foreshadow> foreshadows});
}

/// @nodoc
class __$$NovelWorldSettingImplCopyWithImpl<$Res>
    extends _$NovelWorldSettingCopyWithImpl<$Res, _$NovelWorldSettingImpl>
    implements _$$NovelWorldSettingImplCopyWith<$Res> {
  __$$NovelWorldSettingImplCopyWithImpl(_$NovelWorldSettingImpl _value,
      $Res Function(_$NovelWorldSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NovelWorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? novelId = null,
    Object? era = null,
    Object? geography = null,
    Object? powerSystem = null,
    Object? society = null,
    Object? forbiddenRules = null,
    Object? foreshadows = null,
  }) {
    return _then(_$NovelWorldSettingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      novelId: null == novelId
          ? _value.novelId
          : novelId // ignore: cast_nullable_to_non_nullable
              as String,
      era: null == era
          ? _value.era
          : era // ignore: cast_nullable_to_non_nullable
              as String,
      geography: null == geography
          ? _value.geography
          : geography // ignore: cast_nullable_to_non_nullable
              as String,
      powerSystem: null == powerSystem
          ? _value.powerSystem
          : powerSystem // ignore: cast_nullable_to_non_nullable
              as String,
      society: null == society
          ? _value.society
          : society // ignore: cast_nullable_to_non_nullable
              as String,
      forbiddenRules: null == forbiddenRules
          ? _value._forbiddenRules
          : forbiddenRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      foreshadows: null == foreshadows
          ? _value._foreshadows
          : foreshadows // ignore: cast_nullable_to_non_nullable
              as List<Foreshadow>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NovelWorldSettingImpl implements _NovelWorldSetting {
  const _$NovelWorldSettingImpl(
      {required this.id,
      required this.novelId,
      this.era = '',
      this.geography = '',
      this.powerSystem = '',
      this.society = '',
      final List<String> forbiddenRules = const [],
      final List<Foreshadow> foreshadows = const []})
      : _forbiddenRules = forbiddenRules,
        _foreshadows = foreshadows;

  factory _$NovelWorldSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$NovelWorldSettingImplFromJson(json);

  @override
  final String id;
  @override
  final String novelId;
  @override
  @JsonKey()
  final String era;
// 时代背景
  @override
  @JsonKey()
  final String geography;
// 地理区域
  @override
  @JsonKey()
  final String powerSystem;
// 力量体系
  @override
  @JsonKey()
  final String society;
// 社会结构
  final List<String> _forbiddenRules;
// 社会结构
  @override
  @JsonKey()
  List<String> get forbiddenRules {
    if (_forbiddenRules is EqualUnmodifiableListView) return _forbiddenRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forbiddenRules);
  }

// 设定禁区
  final List<Foreshadow> _foreshadows;
// 设定禁区
  @override
  @JsonKey()
  List<Foreshadow> get foreshadows {
    if (_foreshadows is EqualUnmodifiableListView) return _foreshadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foreshadows);
  }

  @override
  String toString() {
    return 'NovelWorldSetting(id: $id, novelId: $novelId, era: $era, geography: $geography, powerSystem: $powerSystem, society: $society, forbiddenRules: $forbiddenRules, foreshadows: $foreshadows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NovelWorldSettingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.novelId, novelId) || other.novelId == novelId) &&
            (identical(other.era, era) || other.era == era) &&
            (identical(other.geography, geography) ||
                other.geography == geography) &&
            (identical(other.powerSystem, powerSystem) ||
                other.powerSystem == powerSystem) &&
            (identical(other.society, society) || other.society == society) &&
            const DeepCollectionEquality()
                .equals(other._forbiddenRules, _forbiddenRules) &&
            const DeepCollectionEquality()
                .equals(other._foreshadows, _foreshadows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      novelId,
      era,
      geography,
      powerSystem,
      society,
      const DeepCollectionEquality().hash(_forbiddenRules),
      const DeepCollectionEquality().hash(_foreshadows));

  /// Create a copy of NovelWorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NovelWorldSettingImplCopyWith<_$NovelWorldSettingImpl> get copyWith =>
      __$$NovelWorldSettingImplCopyWithImpl<_$NovelWorldSettingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NovelWorldSettingImplToJson(
      this,
    );
  }
}

abstract class _NovelWorldSetting implements NovelWorldSetting {
  const factory _NovelWorldSetting(
      {required final String id,
      required final String novelId,
      final String era,
      final String geography,
      final String powerSystem,
      final String society,
      final List<String> forbiddenRules,
      final List<Foreshadow> foreshadows}) = _$NovelWorldSettingImpl;

  factory _NovelWorldSetting.fromJson(Map<String, dynamic> json) =
      _$NovelWorldSettingImpl.fromJson;

  @override
  String get id;
  @override
  String get novelId;
  @override
  String get era; // 时代背景
  @override
  String get geography; // 地理区域
  @override
  String get powerSystem; // 力量体系
  @override
  String get society; // 社会结构
  @override
  List<String> get forbiddenRules; // 设定禁区
  @override
  List<Foreshadow> get foreshadows;

  /// Create a copy of NovelWorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NovelWorldSettingImplCopyWith<_$NovelWorldSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Foreshadow _$ForeshadowFromJson(Map<String, dynamic> json) {
  return _Foreshadow.fromJson(json);
}

/// @nodoc
mixin _$Foreshadow {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get setupChapterId => throw _privateConstructorUsedError; // 伏笔埋下的章节
  String get description => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError; // 是否已回收
  String get payoffChapterId => throw _privateConstructorUsedError;

  /// Serializes this Foreshadow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Foreshadow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForeshadowCopyWith<Foreshadow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForeshadowCopyWith<$Res> {
  factory $ForeshadowCopyWith(
          Foreshadow value, $Res Function(Foreshadow) then) =
      _$ForeshadowCopyWithImpl<$Res, Foreshadow>;
  @useResult
  $Res call(
      {String id,
      String title,
      String setupChapterId,
      String description,
      bool isResolved,
      String payoffChapterId});
}

/// @nodoc
class _$ForeshadowCopyWithImpl<$Res, $Val extends Foreshadow>
    implements $ForeshadowCopyWith<$Res> {
  _$ForeshadowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Foreshadow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? setupChapterId = null,
    Object? description = null,
    Object? isResolved = null,
    Object? payoffChapterId = null,
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
      setupChapterId: null == setupChapterId
          ? _value.setupChapterId
          : setupChapterId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      payoffChapterId: null == payoffChapterId
          ? _value.payoffChapterId
          : payoffChapterId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForeshadowImplCopyWith<$Res>
    implements $ForeshadowCopyWith<$Res> {
  factory _$$ForeshadowImplCopyWith(
          _$ForeshadowImpl value, $Res Function(_$ForeshadowImpl) then) =
      __$$ForeshadowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String setupChapterId,
      String description,
      bool isResolved,
      String payoffChapterId});
}

/// @nodoc
class __$$ForeshadowImplCopyWithImpl<$Res>
    extends _$ForeshadowCopyWithImpl<$Res, _$ForeshadowImpl>
    implements _$$ForeshadowImplCopyWith<$Res> {
  __$$ForeshadowImplCopyWithImpl(
      _$ForeshadowImpl _value, $Res Function(_$ForeshadowImpl) _then)
      : super(_value, _then);

  /// Create a copy of Foreshadow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? setupChapterId = null,
    Object? description = null,
    Object? isResolved = null,
    Object? payoffChapterId = null,
  }) {
    return _then(_$ForeshadowImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      setupChapterId: null == setupChapterId
          ? _value.setupChapterId
          : setupChapterId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      payoffChapterId: null == payoffChapterId
          ? _value.payoffChapterId
          : payoffChapterId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForeshadowImpl implements _Foreshadow {
  const _$ForeshadowImpl(
      {required this.id,
      required this.title,
      this.setupChapterId = '',
      this.description = '',
      this.isResolved = false,
      this.payoffChapterId = ''});

  factory _$ForeshadowImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForeshadowImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String setupChapterId;
// 伏笔埋下的章节
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isResolved;
// 是否已回收
  @override
  @JsonKey()
  final String payoffChapterId;

  @override
  String toString() {
    return 'Foreshadow(id: $id, title: $title, setupChapterId: $setupChapterId, description: $description, isResolved: $isResolved, payoffChapterId: $payoffChapterId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForeshadowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.setupChapterId, setupChapterId) ||
                other.setupChapterId == setupChapterId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.payoffChapterId, payoffChapterId) ||
                other.payoffChapterId == payoffChapterId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, setupChapterId,
      description, isResolved, payoffChapterId);

  /// Create a copy of Foreshadow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForeshadowImplCopyWith<_$ForeshadowImpl> get copyWith =>
      __$$ForeshadowImplCopyWithImpl<_$ForeshadowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForeshadowImplToJson(
      this,
    );
  }
}

abstract class _Foreshadow implements Foreshadow {
  const factory _Foreshadow(
      {required final String id,
      required final String title,
      final String setupChapterId,
      final String description,
      final bool isResolved,
      final String payoffChapterId}) = _$ForeshadowImpl;

  factory _Foreshadow.fromJson(Map<String, dynamic> json) =
      _$ForeshadowImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get setupChapterId; // 伏笔埋下的章节
  @override
  String get description;
  @override
  bool get isResolved; // 是否已回收
  @override
  String get payoffChapterId;

  /// Create a copy of Foreshadow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForeshadowImplCopyWith<_$ForeshadowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
