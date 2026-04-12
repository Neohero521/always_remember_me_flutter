// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_knowledge_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChapterKnowledgeGraph _$ChapterKnowledgeGraphFromJson(
    Map<String, dynamic> json) {
  return _ChapterKnowledgeGraph.fromJson(json);
}

/// @nodoc
mixin _$ChapterKnowledgeGraph {
  String get id => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  BasicChapterInfo get basicInfo => throw _privateConstructorUsedError;
  List<CharacterInfo> get characters => throw _privateConstructorUsedError;
  WorldSetting get worldSetting => throw _privateConstructorUsedError;
  PlotLine get mainPlot => throw _privateConstructorUsedError;
  List<PlotLine> get subplots => throw _privateConstructorUsedError;
  WritingStyle get writingStyle => throw _privateConstructorUsedError;
  List<EntityRelation> get relations => throw _privateConstructorUsedError;
  GraphChange get changeInfo => throw _privateConstructorUsedError;
  ReverseAnalysis get reverseAnalysis => throw _privateConstructorUsedError;

  /// Serializes this ChapterKnowledgeGraph to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterKnowledgeGraphCopyWith<ChapterKnowledgeGraph> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterKnowledgeGraphCopyWith<$Res> {
  factory $ChapterKnowledgeGraphCopyWith(ChapterKnowledgeGraph value,
          $Res Function(ChapterKnowledgeGraph) then) =
      _$ChapterKnowledgeGraphCopyWithImpl<$Res, ChapterKnowledgeGraph>;
  @useResult
  $Res call(
      {String id,
      String chapterId,
      String version,
      BasicChapterInfo basicInfo,
      List<CharacterInfo> characters,
      WorldSetting worldSetting,
      PlotLine mainPlot,
      List<PlotLine> subplots,
      WritingStyle writingStyle,
      List<EntityRelation> relations,
      GraphChange changeInfo,
      ReverseAnalysis reverseAnalysis});

  $BasicChapterInfoCopyWith<$Res> get basicInfo;
  $WorldSettingCopyWith<$Res> get worldSetting;
  $PlotLineCopyWith<$Res> get mainPlot;
  $WritingStyleCopyWith<$Res> get writingStyle;
  $GraphChangeCopyWith<$Res> get changeInfo;
  $ReverseAnalysisCopyWith<$Res> get reverseAnalysis;
}

/// @nodoc
class _$ChapterKnowledgeGraphCopyWithImpl<$Res,
        $Val extends ChapterKnowledgeGraph>
    implements $ChapterKnowledgeGraphCopyWith<$Res> {
  _$ChapterKnowledgeGraphCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? version = null,
    Object? basicInfo = null,
    Object? characters = null,
    Object? worldSetting = null,
    Object? mainPlot = null,
    Object? subplots = null,
    Object? writingStyle = null,
    Object? relations = null,
    Object? changeInfo = null,
    Object? reverseAnalysis = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      basicInfo: null == basicInfo
          ? _value.basicInfo
          : basicInfo // ignore: cast_nullable_to_non_nullable
              as BasicChapterInfo,
      characters: null == characters
          ? _value.characters
          : characters // ignore: cast_nullable_to_non_nullable
              as List<CharacterInfo>,
      worldSetting: null == worldSetting
          ? _value.worldSetting
          : worldSetting // ignore: cast_nullable_to_non_nullable
              as WorldSetting,
      mainPlot: null == mainPlot
          ? _value.mainPlot
          : mainPlot // ignore: cast_nullable_to_non_nullable
              as PlotLine,
      subplots: null == subplots
          ? _value.subplots
          : subplots // ignore: cast_nullable_to_non_nullable
              as List<PlotLine>,
      writingStyle: null == writingStyle
          ? _value.writingStyle
          : writingStyle // ignore: cast_nullable_to_non_nullable
              as WritingStyle,
      relations: null == relations
          ? _value.relations
          : relations // ignore: cast_nullable_to_non_nullable
              as List<EntityRelation>,
      changeInfo: null == changeInfo
          ? _value.changeInfo
          : changeInfo // ignore: cast_nullable_to_non_nullable
              as GraphChange,
      reverseAnalysis: null == reverseAnalysis
          ? _value.reverseAnalysis
          : reverseAnalysis // ignore: cast_nullable_to_non_nullable
              as ReverseAnalysis,
    ) as $Val);
  }

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BasicChapterInfoCopyWith<$Res> get basicInfo {
    return $BasicChapterInfoCopyWith<$Res>(_value.basicInfo, (value) {
      return _then(_value.copyWith(basicInfo: value) as $Val);
    });
  }

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorldSettingCopyWith<$Res> get worldSetting {
    return $WorldSettingCopyWith<$Res>(_value.worldSetting, (value) {
      return _then(_value.copyWith(worldSetting: value) as $Val);
    });
  }

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlotLineCopyWith<$Res> get mainPlot {
    return $PlotLineCopyWith<$Res>(_value.mainPlot, (value) {
      return _then(_value.copyWith(mainPlot: value) as $Val);
    });
  }

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WritingStyleCopyWith<$Res> get writingStyle {
    return $WritingStyleCopyWith<$Res>(_value.writingStyle, (value) {
      return _then(_value.copyWith(writingStyle: value) as $Val);
    });
  }

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GraphChangeCopyWith<$Res> get changeInfo {
    return $GraphChangeCopyWith<$Res>(_value.changeInfo, (value) {
      return _then(_value.copyWith(changeInfo: value) as $Val);
    });
  }

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReverseAnalysisCopyWith<$Res> get reverseAnalysis {
    return $ReverseAnalysisCopyWith<$Res>(_value.reverseAnalysis, (value) {
      return _then(_value.copyWith(reverseAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChapterKnowledgeGraphImplCopyWith<$Res>
    implements $ChapterKnowledgeGraphCopyWith<$Res> {
  factory _$$ChapterKnowledgeGraphImplCopyWith(
          _$ChapterKnowledgeGraphImpl value,
          $Res Function(_$ChapterKnowledgeGraphImpl) then) =
      __$$ChapterKnowledgeGraphImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chapterId,
      String version,
      BasicChapterInfo basicInfo,
      List<CharacterInfo> characters,
      WorldSetting worldSetting,
      PlotLine mainPlot,
      List<PlotLine> subplots,
      WritingStyle writingStyle,
      List<EntityRelation> relations,
      GraphChange changeInfo,
      ReverseAnalysis reverseAnalysis});

  @override
  $BasicChapterInfoCopyWith<$Res> get basicInfo;
  @override
  $WorldSettingCopyWith<$Res> get worldSetting;
  @override
  $PlotLineCopyWith<$Res> get mainPlot;
  @override
  $WritingStyleCopyWith<$Res> get writingStyle;
  @override
  $GraphChangeCopyWith<$Res> get changeInfo;
  @override
  $ReverseAnalysisCopyWith<$Res> get reverseAnalysis;
}

/// @nodoc
class __$$ChapterKnowledgeGraphImplCopyWithImpl<$Res>
    extends _$ChapterKnowledgeGraphCopyWithImpl<$Res,
        _$ChapterKnowledgeGraphImpl>
    implements _$$ChapterKnowledgeGraphImplCopyWith<$Res> {
  __$$ChapterKnowledgeGraphImplCopyWithImpl(_$ChapterKnowledgeGraphImpl _value,
      $Res Function(_$ChapterKnowledgeGraphImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? version = null,
    Object? basicInfo = null,
    Object? characters = null,
    Object? worldSetting = null,
    Object? mainPlot = null,
    Object? subplots = null,
    Object? writingStyle = null,
    Object? relations = null,
    Object? changeInfo = null,
    Object? reverseAnalysis = null,
  }) {
    return _then(_$ChapterKnowledgeGraphImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      basicInfo: null == basicInfo
          ? _value.basicInfo
          : basicInfo // ignore: cast_nullable_to_non_nullable
              as BasicChapterInfo,
      characters: null == characters
          ? _value._characters
          : characters // ignore: cast_nullable_to_non_nullable
              as List<CharacterInfo>,
      worldSetting: null == worldSetting
          ? _value.worldSetting
          : worldSetting // ignore: cast_nullable_to_non_nullable
              as WorldSetting,
      mainPlot: null == mainPlot
          ? _value.mainPlot
          : mainPlot // ignore: cast_nullable_to_non_nullable
              as PlotLine,
      subplots: null == subplots
          ? _value._subplots
          : subplots // ignore: cast_nullable_to_non_nullable
              as List<PlotLine>,
      writingStyle: null == writingStyle
          ? _value.writingStyle
          : writingStyle // ignore: cast_nullable_to_non_nullable
              as WritingStyle,
      relations: null == relations
          ? _value._relations
          : relations // ignore: cast_nullable_to_non_nullable
              as List<EntityRelation>,
      changeInfo: null == changeInfo
          ? _value.changeInfo
          : changeInfo // ignore: cast_nullable_to_non_nullable
              as GraphChange,
      reverseAnalysis: null == reverseAnalysis
          ? _value.reverseAnalysis
          : reverseAnalysis // ignore: cast_nullable_to_non_nullable
              as ReverseAnalysis,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterKnowledgeGraphImpl extends _ChapterKnowledgeGraph {
  const _$ChapterKnowledgeGraphImpl(
      {required this.id,
      required this.chapterId,
      this.version = kKnowledgeGraphVersion,
      required this.basicInfo,
      final List<CharacterInfo> characters = const [],
      this.worldSetting = const WorldSetting(),
      required this.mainPlot,
      final List<PlotLine> subplots = const [],
      required this.writingStyle,
      final List<EntityRelation> relations = const [],
      required this.changeInfo,
      required this.reverseAnalysis})
      : _characters = characters,
        _subplots = subplots,
        _relations = relations,
        super._();

  factory _$ChapterKnowledgeGraphImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterKnowledgeGraphImplFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;
  @override
  @JsonKey()
  final String version;
  @override
  final BasicChapterInfo basicInfo;
  final List<CharacterInfo> _characters;
  @override
  @JsonKey()
  List<CharacterInfo> get characters {
    if (_characters is EqualUnmodifiableListView) return _characters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_characters);
  }

  @override
  @JsonKey()
  final WorldSetting worldSetting;
  @override
  final PlotLine mainPlot;
  final List<PlotLine> _subplots;
  @override
  @JsonKey()
  List<PlotLine> get subplots {
    if (_subplots is EqualUnmodifiableListView) return _subplots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subplots);
  }

  @override
  final WritingStyle writingStyle;
  final List<EntityRelation> _relations;
  @override
  @JsonKey()
  List<EntityRelation> get relations {
    if (_relations is EqualUnmodifiableListView) return _relations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relations);
  }

  @override
  final GraphChange changeInfo;
  @override
  final ReverseAnalysis reverseAnalysis;

  @override
  String toString() {
    return 'ChapterKnowledgeGraph(id: $id, chapterId: $chapterId, version: $version, basicInfo: $basicInfo, characters: $characters, worldSetting: $worldSetting, mainPlot: $mainPlot, subplots: $subplots, writingStyle: $writingStyle, relations: $relations, changeInfo: $changeInfo, reverseAnalysis: $reverseAnalysis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterKnowledgeGraphImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.basicInfo, basicInfo) ||
                other.basicInfo == basicInfo) &&
            const DeepCollectionEquality()
                .equals(other._characters, _characters) &&
            (identical(other.worldSetting, worldSetting) ||
                other.worldSetting == worldSetting) &&
            (identical(other.mainPlot, mainPlot) ||
                other.mainPlot == mainPlot) &&
            const DeepCollectionEquality().equals(other._subplots, _subplots) &&
            (identical(other.writingStyle, writingStyle) ||
                other.writingStyle == writingStyle) &&
            const DeepCollectionEquality()
                .equals(other._relations, _relations) &&
            (identical(other.changeInfo, changeInfo) ||
                other.changeInfo == changeInfo) &&
            (identical(other.reverseAnalysis, reverseAnalysis) ||
                other.reverseAnalysis == reverseAnalysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chapterId,
      version,
      basicInfo,
      const DeepCollectionEquality().hash(_characters),
      worldSetting,
      mainPlot,
      const DeepCollectionEquality().hash(_subplots),
      writingStyle,
      const DeepCollectionEquality().hash(_relations),
      changeInfo,
      reverseAnalysis);

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterKnowledgeGraphImplCopyWith<_$ChapterKnowledgeGraphImpl>
      get copyWith => __$$ChapterKnowledgeGraphImplCopyWithImpl<
          _$ChapterKnowledgeGraphImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterKnowledgeGraphImplToJson(
      this,
    );
  }
}

abstract class _ChapterKnowledgeGraph extends ChapterKnowledgeGraph {
  const factory _ChapterKnowledgeGraph(
          {required final String id,
          required final String chapterId,
          final String version,
          required final BasicChapterInfo basicInfo,
          final List<CharacterInfo> characters,
          final WorldSetting worldSetting,
          required final PlotLine mainPlot,
          final List<PlotLine> subplots,
          required final WritingStyle writingStyle,
          final List<EntityRelation> relations,
          required final GraphChange changeInfo,
          required final ReverseAnalysis reverseAnalysis}) =
      _$ChapterKnowledgeGraphImpl;
  const _ChapterKnowledgeGraph._() : super._();

  factory _ChapterKnowledgeGraph.fromJson(Map<String, dynamic> json) =
      _$ChapterKnowledgeGraphImpl.fromJson;

  @override
  String get id;
  @override
  String get chapterId;
  @override
  String get version;
  @override
  BasicChapterInfo get basicInfo;
  @override
  List<CharacterInfo> get characters;
  @override
  WorldSetting get worldSetting;
  @override
  PlotLine get mainPlot;
  @override
  List<PlotLine> get subplots;
  @override
  WritingStyle get writingStyle;
  @override
  List<EntityRelation> get relations;
  @override
  GraphChange get changeInfo;
  @override
  ReverseAnalysis get reverseAnalysis;

  /// Create a copy of ChapterKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterKnowledgeGraphImplCopyWith<_$ChapterKnowledgeGraphImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BasicChapterInfo _$BasicChapterInfoFromJson(Map<String, dynamic> json) {
  return _BasicChapterInfo.fromJson(json);
}

/// @nodoc
mixin _$BasicChapterInfo {
  String get chapterNumber => throw _privateConstructorUsedError;
  String get chapterVersion => throw _privateConstructorUsedError;
  String get chapterNodeId => throw _privateConstructorUsedError;
  int get chapterWordCount => throw _privateConstructorUsedError;
  List<String> get narrativeTimelineNodes => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  String? get keyEvents => throw _privateConstructorUsedError;

  /// Serializes this BasicChapterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BasicChapterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BasicChapterInfoCopyWith<BasicChapterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicChapterInfoCopyWith<$Res> {
  factory $BasicChapterInfoCopyWith(
          BasicChapterInfo value, $Res Function(BasicChapterInfo) then) =
      _$BasicChapterInfoCopyWithImpl<$Res, BasicChapterInfo>;
  @useResult
  $Res call(
      {String chapterNumber,
      String chapterVersion,
      String chapterNodeId,
      int chapterWordCount,
      List<String> narrativeTimelineNodes,
      String? summary,
      String? keyEvents});
}

/// @nodoc
class _$BasicChapterInfoCopyWithImpl<$Res, $Val extends BasicChapterInfo>
    implements $BasicChapterInfoCopyWith<$Res> {
  _$BasicChapterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BasicChapterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterNumber = null,
    Object? chapterVersion = null,
    Object? chapterNodeId = null,
    Object? chapterWordCount = null,
    Object? narrativeTimelineNodes = null,
    Object? summary = freezed,
    Object? keyEvents = freezed,
  }) {
    return _then(_value.copyWith(
      chapterNumber: null == chapterNumber
          ? _value.chapterNumber
          : chapterNumber // ignore: cast_nullable_to_non_nullable
              as String,
      chapterVersion: null == chapterVersion
          ? _value.chapterVersion
          : chapterVersion // ignore: cast_nullable_to_non_nullable
              as String,
      chapterNodeId: null == chapterNodeId
          ? _value.chapterNodeId
          : chapterNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      chapterWordCount: null == chapterWordCount
          ? _value.chapterWordCount
          : chapterWordCount // ignore: cast_nullable_to_non_nullable
              as int,
      narrativeTimelineNodes: null == narrativeTimelineNodes
          ? _value.narrativeTimelineNodes
          : narrativeTimelineNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      keyEvents: freezed == keyEvents
          ? _value.keyEvents
          : keyEvents // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasicChapterInfoImplCopyWith<$Res>
    implements $BasicChapterInfoCopyWith<$Res> {
  factory _$$BasicChapterInfoImplCopyWith(_$BasicChapterInfoImpl value,
          $Res Function(_$BasicChapterInfoImpl) then) =
      __$$BasicChapterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String chapterNumber,
      String chapterVersion,
      String chapterNodeId,
      int chapterWordCount,
      List<String> narrativeTimelineNodes,
      String? summary,
      String? keyEvents});
}

/// @nodoc
class __$$BasicChapterInfoImplCopyWithImpl<$Res>
    extends _$BasicChapterInfoCopyWithImpl<$Res, _$BasicChapterInfoImpl>
    implements _$$BasicChapterInfoImplCopyWith<$Res> {
  __$$BasicChapterInfoImplCopyWithImpl(_$BasicChapterInfoImpl _value,
      $Res Function(_$BasicChapterInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BasicChapterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterNumber = null,
    Object? chapterVersion = null,
    Object? chapterNodeId = null,
    Object? chapterWordCount = null,
    Object? narrativeTimelineNodes = null,
    Object? summary = freezed,
    Object? keyEvents = freezed,
  }) {
    return _then(_$BasicChapterInfoImpl(
      chapterNumber: null == chapterNumber
          ? _value.chapterNumber
          : chapterNumber // ignore: cast_nullable_to_non_nullable
              as String,
      chapterVersion: null == chapterVersion
          ? _value.chapterVersion
          : chapterVersion // ignore: cast_nullable_to_non_nullable
              as String,
      chapterNodeId: null == chapterNodeId
          ? _value.chapterNodeId
          : chapterNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      chapterWordCount: null == chapterWordCount
          ? _value.chapterWordCount
          : chapterWordCount // ignore: cast_nullable_to_non_nullable
              as int,
      narrativeTimelineNodes: null == narrativeTimelineNodes
          ? _value._narrativeTimelineNodes
          : narrativeTimelineNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      keyEvents: freezed == keyEvents
          ? _value.keyEvents
          : keyEvents // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasicChapterInfoImpl implements _BasicChapterInfo {
  const _$BasicChapterInfoImpl(
      {required this.chapterNumber,
      required this.chapterVersion,
      required this.chapterNodeId,
      required this.chapterWordCount,
      required final List<String> narrativeTimelineNodes,
      this.summary,
      this.keyEvents})
      : _narrativeTimelineNodes = narrativeTimelineNodes;

  factory _$BasicChapterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicChapterInfoImplFromJson(json);

  @override
  final String chapterNumber;
  @override
  final String chapterVersion;
  @override
  final String chapterNodeId;
  @override
  final int chapterWordCount;
  final List<String> _narrativeTimelineNodes;
  @override
  List<String> get narrativeTimelineNodes {
    if (_narrativeTimelineNodes is EqualUnmodifiableListView)
      return _narrativeTimelineNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_narrativeTimelineNodes);
  }

  @override
  final String? summary;
  @override
  final String? keyEvents;

  @override
  String toString() {
    return 'BasicChapterInfo(chapterNumber: $chapterNumber, chapterVersion: $chapterVersion, chapterNodeId: $chapterNodeId, chapterWordCount: $chapterWordCount, narrativeTimelineNodes: $narrativeTimelineNodes, summary: $summary, keyEvents: $keyEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicChapterInfoImpl &&
            (identical(other.chapterNumber, chapterNumber) ||
                other.chapterNumber == chapterNumber) &&
            (identical(other.chapterVersion, chapterVersion) ||
                other.chapterVersion == chapterVersion) &&
            (identical(other.chapterNodeId, chapterNodeId) ||
                other.chapterNodeId == chapterNodeId) &&
            (identical(other.chapterWordCount, chapterWordCount) ||
                other.chapterWordCount == chapterWordCount) &&
            const DeepCollectionEquality().equals(
                other._narrativeTimelineNodes, _narrativeTimelineNodes) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.keyEvents, keyEvents) ||
                other.keyEvents == keyEvents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      chapterNumber,
      chapterVersion,
      chapterNodeId,
      chapterWordCount,
      const DeepCollectionEquality().hash(_narrativeTimelineNodes),
      summary,
      keyEvents);

  /// Create a copy of BasicChapterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicChapterInfoImplCopyWith<_$BasicChapterInfoImpl> get copyWith =>
      __$$BasicChapterInfoImplCopyWithImpl<_$BasicChapterInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicChapterInfoImplToJson(
      this,
    );
  }
}

abstract class _BasicChapterInfo implements BasicChapterInfo {
  const factory _BasicChapterInfo(
      {required final String chapterNumber,
      required final String chapterVersion,
      required final String chapterNodeId,
      required final int chapterWordCount,
      required final List<String> narrativeTimelineNodes,
      final String? summary,
      final String? keyEvents}) = _$BasicChapterInfoImpl;

  factory _BasicChapterInfo.fromJson(Map<String, dynamic> json) =
      _$BasicChapterInfoImpl.fromJson;

  @override
  String get chapterNumber;
  @override
  String get chapterVersion;
  @override
  String get chapterNodeId;
  @override
  int get chapterWordCount;
  @override
  List<String> get narrativeTimelineNodes;
  @override
  String? get summary;
  @override
  String? get keyEvents;

  /// Create a copy of BasicChapterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicChapterInfoImplCopyWith<_$BasicChapterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CharacterInfo _$CharacterInfoFromJson(Map<String, dynamic> json) {
  return _CharacterInfo.fromJson(json);
}

/// @nodoc
mixin _$CharacterInfo {
  String get uniqueId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get personalityTraits => throw _privateConstructorUsedError;
  String get identityBackground => throw _privateConstructorUsedError;
  String get coreBehaviorMotive => throw _privateConstructorUsedError;
  String get relationshipChanges => throw _privateConstructorUsedError;
  String get characterArcChange => throw _privateConstructorUsedError;
  List<String> get dialogueStyles => throw _privateConstructorUsedError;
  int get appearanceCount => throw _privateConstructorUsedError;

  /// Serializes this CharacterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterInfoCopyWith<CharacterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterInfoCopyWith<$Res> {
  factory $CharacterInfoCopyWith(
          CharacterInfo value, $Res Function(CharacterInfo) then) =
      _$CharacterInfoCopyWithImpl<$Res, CharacterInfo>;
  @useResult
  $Res call(
      {String uniqueId,
      String name,
      String alias,
      String personalityTraits,
      String identityBackground,
      String coreBehaviorMotive,
      String relationshipChanges,
      String characterArcChange,
      List<String> dialogueStyles,
      int appearanceCount});
}

/// @nodoc
class _$CharacterInfoCopyWithImpl<$Res, $Val extends CharacterInfo>
    implements $CharacterInfoCopyWith<$Res> {
  _$CharacterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uniqueId = null,
    Object? name = null,
    Object? alias = null,
    Object? personalityTraits = null,
    Object? identityBackground = null,
    Object? coreBehaviorMotive = null,
    Object? relationshipChanges = null,
    Object? characterArcChange = null,
    Object? dialogueStyles = null,
    Object? appearanceCount = null,
  }) {
    return _then(_value.copyWith(
      uniqueId: null == uniqueId
          ? _value.uniqueId
          : uniqueId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      personalityTraits: null == personalityTraits
          ? _value.personalityTraits
          : personalityTraits // ignore: cast_nullable_to_non_nullable
              as String,
      identityBackground: null == identityBackground
          ? _value.identityBackground
          : identityBackground // ignore: cast_nullable_to_non_nullable
              as String,
      coreBehaviorMotive: null == coreBehaviorMotive
          ? _value.coreBehaviorMotive
          : coreBehaviorMotive // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipChanges: null == relationshipChanges
          ? _value.relationshipChanges
          : relationshipChanges // ignore: cast_nullable_to_non_nullable
              as String,
      characterArcChange: null == characterArcChange
          ? _value.characterArcChange
          : characterArcChange // ignore: cast_nullable_to_non_nullable
              as String,
      dialogueStyles: null == dialogueStyles
          ? _value.dialogueStyles
          : dialogueStyles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appearanceCount: null == appearanceCount
          ? _value.appearanceCount
          : appearanceCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterInfoImplCopyWith<$Res>
    implements $CharacterInfoCopyWith<$Res> {
  factory _$$CharacterInfoImplCopyWith(
          _$CharacterInfoImpl value, $Res Function(_$CharacterInfoImpl) then) =
      __$$CharacterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uniqueId,
      String name,
      String alias,
      String personalityTraits,
      String identityBackground,
      String coreBehaviorMotive,
      String relationshipChanges,
      String characterArcChange,
      List<String> dialogueStyles,
      int appearanceCount});
}

/// @nodoc
class __$$CharacterInfoImplCopyWithImpl<$Res>
    extends _$CharacterInfoCopyWithImpl<$Res, _$CharacterInfoImpl>
    implements _$$CharacterInfoImplCopyWith<$Res> {
  __$$CharacterInfoImplCopyWithImpl(
      _$CharacterInfoImpl _value, $Res Function(_$CharacterInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uniqueId = null,
    Object? name = null,
    Object? alias = null,
    Object? personalityTraits = null,
    Object? identityBackground = null,
    Object? coreBehaviorMotive = null,
    Object? relationshipChanges = null,
    Object? characterArcChange = null,
    Object? dialogueStyles = null,
    Object? appearanceCount = null,
  }) {
    return _then(_$CharacterInfoImpl(
      uniqueId: null == uniqueId
          ? _value.uniqueId
          : uniqueId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      personalityTraits: null == personalityTraits
          ? _value.personalityTraits
          : personalityTraits // ignore: cast_nullable_to_non_nullable
              as String,
      identityBackground: null == identityBackground
          ? _value.identityBackground
          : identityBackground // ignore: cast_nullable_to_non_nullable
              as String,
      coreBehaviorMotive: null == coreBehaviorMotive
          ? _value.coreBehaviorMotive
          : coreBehaviorMotive // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipChanges: null == relationshipChanges
          ? _value.relationshipChanges
          : relationshipChanges // ignore: cast_nullable_to_non_nullable
              as String,
      characterArcChange: null == characterArcChange
          ? _value.characterArcChange
          : characterArcChange // ignore: cast_nullable_to_non_nullable
              as String,
      dialogueStyles: null == dialogueStyles
          ? _value._dialogueStyles
          : dialogueStyles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appearanceCount: null == appearanceCount
          ? _value.appearanceCount
          : appearanceCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterInfoImpl implements _CharacterInfo {
  const _$CharacterInfoImpl(
      {required this.uniqueId,
      required this.name,
      this.alias = '',
      this.personalityTraits = '',
      this.identityBackground = '',
      this.coreBehaviorMotive = '',
      this.relationshipChanges = '',
      this.characterArcChange = '',
      final List<String> dialogueStyles = const [],
      this.appearanceCount = 0})
      : _dialogueStyles = dialogueStyles;

  factory _$CharacterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterInfoImplFromJson(json);

  @override
  final String uniqueId;
  @override
  final String name;
  @override
  @JsonKey()
  final String alias;
  @override
  @JsonKey()
  final String personalityTraits;
  @override
  @JsonKey()
  final String identityBackground;
  @override
  @JsonKey()
  final String coreBehaviorMotive;
  @override
  @JsonKey()
  final String relationshipChanges;
  @override
  @JsonKey()
  final String characterArcChange;
  final List<String> _dialogueStyles;
  @override
  @JsonKey()
  List<String> get dialogueStyles {
    if (_dialogueStyles is EqualUnmodifiableListView) return _dialogueStyles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dialogueStyles);
  }

  @override
  @JsonKey()
  final int appearanceCount;

  @override
  String toString() {
    return 'CharacterInfo(uniqueId: $uniqueId, name: $name, alias: $alias, personalityTraits: $personalityTraits, identityBackground: $identityBackground, coreBehaviorMotive: $coreBehaviorMotive, relationshipChanges: $relationshipChanges, characterArcChange: $characterArcChange, dialogueStyles: $dialogueStyles, appearanceCount: $appearanceCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterInfoImpl &&
            (identical(other.uniqueId, uniqueId) ||
                other.uniqueId == uniqueId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.personalityTraits, personalityTraits) ||
                other.personalityTraits == personalityTraits) &&
            (identical(other.identityBackground, identityBackground) ||
                other.identityBackground == identityBackground) &&
            (identical(other.coreBehaviorMotive, coreBehaviorMotive) ||
                other.coreBehaviorMotive == coreBehaviorMotive) &&
            (identical(other.relationshipChanges, relationshipChanges) ||
                other.relationshipChanges == relationshipChanges) &&
            (identical(other.characterArcChange, characterArcChange) ||
                other.characterArcChange == characterArcChange) &&
            const DeepCollectionEquality()
                .equals(other._dialogueStyles, _dialogueStyles) &&
            (identical(other.appearanceCount, appearanceCount) ||
                other.appearanceCount == appearanceCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uniqueId,
      name,
      alias,
      personalityTraits,
      identityBackground,
      coreBehaviorMotive,
      relationshipChanges,
      characterArcChange,
      const DeepCollectionEquality().hash(_dialogueStyles),
      appearanceCount);

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterInfoImplCopyWith<_$CharacterInfoImpl> get copyWith =>
      __$$CharacterInfoImplCopyWithImpl<_$CharacterInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterInfoImplToJson(
      this,
    );
  }
}

abstract class _CharacterInfo implements CharacterInfo {
  const factory _CharacterInfo(
      {required final String uniqueId,
      required final String name,
      final String alias,
      final String personalityTraits,
      final String identityBackground,
      final String coreBehaviorMotive,
      final String relationshipChanges,
      final String characterArcChange,
      final List<String> dialogueStyles,
      final int appearanceCount}) = _$CharacterInfoImpl;

  factory _CharacterInfo.fromJson(Map<String, dynamic> json) =
      _$CharacterInfoImpl.fromJson;

  @override
  String get uniqueId;
  @override
  String get name;
  @override
  String get alias;
  @override
  String get personalityTraits;
  @override
  String get identityBackground;
  @override
  String get coreBehaviorMotive;
  @override
  String get relationshipChanges;
  @override
  String get characterArcChange;
  @override
  List<String> get dialogueStyles;
  @override
  int get appearanceCount;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterInfoImplCopyWith<_$CharacterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorldSetting _$WorldSettingFromJson(Map<String, dynamic> json) {
  return _WorldSetting.fromJson(json);
}

/// @nodoc
mixin _$WorldSetting {
  String get eraBackground => throw _privateConstructorUsedError;
  List<String> get geographyRegions => throw _privateConstructorUsedError;
  String get powerSystem => throw _privateConstructorUsedError;
  String get socialStructure => throw _privateConstructorUsedError;
  List<String> get itemsAndCreatures => throw _privateConstructorUsedError;
  List<String> get hiddenForeshadows => throw _privateConstructorUsedError;
  Map<String, dynamic> get customSettings => throw _privateConstructorUsedError;

  /// Serializes this WorldSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldSettingCopyWith<WorldSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldSettingCopyWith<$Res> {
  factory $WorldSettingCopyWith(
          WorldSetting value, $Res Function(WorldSetting) then) =
      _$WorldSettingCopyWithImpl<$Res, WorldSetting>;
  @useResult
  $Res call(
      {String eraBackground,
      List<String> geographyRegions,
      String powerSystem,
      String socialStructure,
      List<String> itemsAndCreatures,
      List<String> hiddenForeshadows,
      Map<String, dynamic> customSettings});
}

/// @nodoc
class _$WorldSettingCopyWithImpl<$Res, $Val extends WorldSetting>
    implements $WorldSettingCopyWith<$Res> {
  _$WorldSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eraBackground = null,
    Object? geographyRegions = null,
    Object? powerSystem = null,
    Object? socialStructure = null,
    Object? itemsAndCreatures = null,
    Object? hiddenForeshadows = null,
    Object? customSettings = null,
  }) {
    return _then(_value.copyWith(
      eraBackground: null == eraBackground
          ? _value.eraBackground
          : eraBackground // ignore: cast_nullable_to_non_nullable
              as String,
      geographyRegions: null == geographyRegions
          ? _value.geographyRegions
          : geographyRegions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      powerSystem: null == powerSystem
          ? _value.powerSystem
          : powerSystem // ignore: cast_nullable_to_non_nullable
              as String,
      socialStructure: null == socialStructure
          ? _value.socialStructure
          : socialStructure // ignore: cast_nullable_to_non_nullable
              as String,
      itemsAndCreatures: null == itemsAndCreatures
          ? _value.itemsAndCreatures
          : itemsAndCreatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hiddenForeshadows: null == hiddenForeshadows
          ? _value.hiddenForeshadows
          : hiddenForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customSettings: null == customSettings
          ? _value.customSettings
          : customSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldSettingImplCopyWith<$Res>
    implements $WorldSettingCopyWith<$Res> {
  factory _$$WorldSettingImplCopyWith(
          _$WorldSettingImpl value, $Res Function(_$WorldSettingImpl) then) =
      __$$WorldSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eraBackground,
      List<String> geographyRegions,
      String powerSystem,
      String socialStructure,
      List<String> itemsAndCreatures,
      List<String> hiddenForeshadows,
      Map<String, dynamic> customSettings});
}

/// @nodoc
class __$$WorldSettingImplCopyWithImpl<$Res>
    extends _$WorldSettingCopyWithImpl<$Res, _$WorldSettingImpl>
    implements _$$WorldSettingImplCopyWith<$Res> {
  __$$WorldSettingImplCopyWithImpl(
      _$WorldSettingImpl _value, $Res Function(_$WorldSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eraBackground = null,
    Object? geographyRegions = null,
    Object? powerSystem = null,
    Object? socialStructure = null,
    Object? itemsAndCreatures = null,
    Object? hiddenForeshadows = null,
    Object? customSettings = null,
  }) {
    return _then(_$WorldSettingImpl(
      eraBackground: null == eraBackground
          ? _value.eraBackground
          : eraBackground // ignore: cast_nullable_to_non_nullable
              as String,
      geographyRegions: null == geographyRegions
          ? _value._geographyRegions
          : geographyRegions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      powerSystem: null == powerSystem
          ? _value.powerSystem
          : powerSystem // ignore: cast_nullable_to_non_nullable
              as String,
      socialStructure: null == socialStructure
          ? _value.socialStructure
          : socialStructure // ignore: cast_nullable_to_non_nullable
              as String,
      itemsAndCreatures: null == itemsAndCreatures
          ? _value._itemsAndCreatures
          : itemsAndCreatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hiddenForeshadows: null == hiddenForeshadows
          ? _value._hiddenForeshadows
          : hiddenForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customSettings: null == customSettings
          ? _value._customSettings
          : customSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldSettingImpl implements _WorldSetting {
  const _$WorldSettingImpl(
      {this.eraBackground = '',
      final List<String> geographyRegions = const [],
      this.powerSystem = '',
      this.socialStructure = '',
      final List<String> itemsAndCreatures = const [],
      final List<String> hiddenForeshadows = const [],
      final Map<String, dynamic> customSettings = const {}})
      : _geographyRegions = geographyRegions,
        _itemsAndCreatures = itemsAndCreatures,
        _hiddenForeshadows = hiddenForeshadows,
        _customSettings = customSettings;

  factory _$WorldSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldSettingImplFromJson(json);

  @override
  @JsonKey()
  final String eraBackground;
  final List<String> _geographyRegions;
  @override
  @JsonKey()
  List<String> get geographyRegions {
    if (_geographyRegions is EqualUnmodifiableListView)
      return _geographyRegions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geographyRegions);
  }

  @override
  @JsonKey()
  final String powerSystem;
  @override
  @JsonKey()
  final String socialStructure;
  final List<String> _itemsAndCreatures;
  @override
  @JsonKey()
  List<String> get itemsAndCreatures {
    if (_itemsAndCreatures is EqualUnmodifiableListView)
      return _itemsAndCreatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemsAndCreatures);
  }

  final List<String> _hiddenForeshadows;
  @override
  @JsonKey()
  List<String> get hiddenForeshadows {
    if (_hiddenForeshadows is EqualUnmodifiableListView)
      return _hiddenForeshadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hiddenForeshadows);
  }

  final Map<String, dynamic> _customSettings;
  @override
  @JsonKey()
  Map<String, dynamic> get customSettings {
    if (_customSettings is EqualUnmodifiableMapView) return _customSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customSettings);
  }

  @override
  String toString() {
    return 'WorldSetting(eraBackground: $eraBackground, geographyRegions: $geographyRegions, powerSystem: $powerSystem, socialStructure: $socialStructure, itemsAndCreatures: $itemsAndCreatures, hiddenForeshadows: $hiddenForeshadows, customSettings: $customSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldSettingImpl &&
            (identical(other.eraBackground, eraBackground) ||
                other.eraBackground == eraBackground) &&
            const DeepCollectionEquality()
                .equals(other._geographyRegions, _geographyRegions) &&
            (identical(other.powerSystem, powerSystem) ||
                other.powerSystem == powerSystem) &&
            (identical(other.socialStructure, socialStructure) ||
                other.socialStructure == socialStructure) &&
            const DeepCollectionEquality()
                .equals(other._itemsAndCreatures, _itemsAndCreatures) &&
            const DeepCollectionEquality()
                .equals(other._hiddenForeshadows, _hiddenForeshadows) &&
            const DeepCollectionEquality()
                .equals(other._customSettings, _customSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eraBackground,
      const DeepCollectionEquality().hash(_geographyRegions),
      powerSystem,
      socialStructure,
      const DeepCollectionEquality().hash(_itemsAndCreatures),
      const DeepCollectionEquality().hash(_hiddenForeshadows),
      const DeepCollectionEquality().hash(_customSettings));

  /// Create a copy of WorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldSettingImplCopyWith<_$WorldSettingImpl> get copyWith =>
      __$$WorldSettingImplCopyWithImpl<_$WorldSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldSettingImplToJson(
      this,
    );
  }
}

abstract class _WorldSetting implements WorldSetting {
  const factory _WorldSetting(
      {final String eraBackground,
      final List<String> geographyRegions,
      final String powerSystem,
      final String socialStructure,
      final List<String> itemsAndCreatures,
      final List<String> hiddenForeshadows,
      final Map<String, dynamic> customSettings}) = _$WorldSettingImpl;

  factory _WorldSetting.fromJson(Map<String, dynamic> json) =
      _$WorldSettingImpl.fromJson;

  @override
  String get eraBackground;
  @override
  List<String> get geographyRegions;
  @override
  String get powerSystem;
  @override
  String get socialStructure;
  @override
  List<String> get itemsAndCreatures;
  @override
  List<String> get hiddenForeshadows;
  @override
  Map<String, dynamic> get customSettings;

  /// Create a copy of WorldSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldSettingImplCopyWith<_$WorldSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlotLine _$PlotLineFromJson(Map<String, dynamic> json) {
  return _PlotLine.fromJson(json);
}

/// @nodoc
mixin _$PlotLine {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get keyEvents => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'main' | 'subplot'
  String get conflictProgress => throw _privateConstructorUsedError;
  List<String> get unresolvedForeshadows => throw _privateConstructorUsedError;

  /// Serializes this PlotLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlotLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlotLineCopyWith<PlotLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlotLineCopyWith<$Res> {
  factory $PlotLineCopyWith(PlotLine value, $Res Function(PlotLine) then) =
      _$PlotLineCopyWithImpl<$Res, PlotLine>;
  @useResult
  $Res call(
      {String id,
      String description,
      List<String> keyEvents,
      String type,
      String conflictProgress,
      List<String> unresolvedForeshadows});
}

/// @nodoc
class _$PlotLineCopyWithImpl<$Res, $Val extends PlotLine>
    implements $PlotLineCopyWith<$Res> {
  _$PlotLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlotLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? keyEvents = null,
    Object? type = null,
    Object? conflictProgress = null,
    Object? unresolvedForeshadows = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      keyEvents: null == keyEvents
          ? _value.keyEvents
          : keyEvents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      conflictProgress: null == conflictProgress
          ? _value.conflictProgress
          : conflictProgress // ignore: cast_nullable_to_non_nullable
              as String,
      unresolvedForeshadows: null == unresolvedForeshadows
          ? _value.unresolvedForeshadows
          : unresolvedForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlotLineImplCopyWith<$Res>
    implements $PlotLineCopyWith<$Res> {
  factory _$$PlotLineImplCopyWith(
          _$PlotLineImpl value, $Res Function(_$PlotLineImpl) then) =
      __$$PlotLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      List<String> keyEvents,
      String type,
      String conflictProgress,
      List<String> unresolvedForeshadows});
}

/// @nodoc
class __$$PlotLineImplCopyWithImpl<$Res>
    extends _$PlotLineCopyWithImpl<$Res, _$PlotLineImpl>
    implements _$$PlotLineImplCopyWith<$Res> {
  __$$PlotLineImplCopyWithImpl(
      _$PlotLineImpl _value, $Res Function(_$PlotLineImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlotLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? keyEvents = null,
    Object? type = null,
    Object? conflictProgress = null,
    Object? unresolvedForeshadows = null,
  }) {
    return _then(_$PlotLineImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      keyEvents: null == keyEvents
          ? _value._keyEvents
          : keyEvents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      conflictProgress: null == conflictProgress
          ? _value.conflictProgress
          : conflictProgress // ignore: cast_nullable_to_non_nullable
              as String,
      unresolvedForeshadows: null == unresolvedForeshadows
          ? _value._unresolvedForeshadows
          : unresolvedForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlotLineImpl implements _PlotLine {
  const _$PlotLineImpl(
      {required this.id,
      this.description = '',
      final List<String> keyEvents = const [],
      this.type = 'main',
      this.conflictProgress = '',
      final List<String> unresolvedForeshadows = const []})
      : _keyEvents = keyEvents,
        _unresolvedForeshadows = unresolvedForeshadows;

  factory _$PlotLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlotLineImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String description;
  final List<String> _keyEvents;
  @override
  @JsonKey()
  List<String> get keyEvents {
    if (_keyEvents is EqualUnmodifiableListView) return _keyEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyEvents);
  }

  @override
  @JsonKey()
  final String type;
// 'main' | 'subplot'
  @override
  @JsonKey()
  final String conflictProgress;
  final List<String> _unresolvedForeshadows;
  @override
  @JsonKey()
  List<String> get unresolvedForeshadows {
    if (_unresolvedForeshadows is EqualUnmodifiableListView)
      return _unresolvedForeshadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unresolvedForeshadows);
  }

  @override
  String toString() {
    return 'PlotLine(id: $id, description: $description, keyEvents: $keyEvents, type: $type, conflictProgress: $conflictProgress, unresolvedForeshadows: $unresolvedForeshadows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlotLineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._keyEvents, _keyEvents) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.conflictProgress, conflictProgress) ||
                other.conflictProgress == conflictProgress) &&
            const DeepCollectionEquality()
                .equals(other._unresolvedForeshadows, _unresolvedForeshadows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      const DeepCollectionEquality().hash(_keyEvents),
      type,
      conflictProgress,
      const DeepCollectionEquality().hash(_unresolvedForeshadows));

  /// Create a copy of PlotLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlotLineImplCopyWith<_$PlotLineImpl> get copyWith =>
      __$$PlotLineImplCopyWithImpl<_$PlotLineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlotLineImplToJson(
      this,
    );
  }
}

abstract class _PlotLine implements PlotLine {
  const factory _PlotLine(
      {required final String id,
      final String description,
      final List<String> keyEvents,
      final String type,
      final String conflictProgress,
      final List<String> unresolvedForeshadows}) = _$PlotLineImpl;

  factory _PlotLine.fromJson(Map<String, dynamic> json) =
      _$PlotLineImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  List<String> get keyEvents;
  @override
  String get type; // 'main' | 'subplot'
  @override
  String get conflictProgress;
  @override
  List<String> get unresolvedForeshadows;

  /// Create a copy of PlotLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlotLineImplCopyWith<_$PlotLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WritingStyle _$WritingStyleFromJson(Map<String, dynamic> json) {
  return _WritingStyle.fromJson(json);
}

/// @nodoc
mixin _$WritingStyle {
  String get narrativePerspective => throw _privateConstructorUsedError;
  String get languageStyle => throw _privateConstructorUsedError;
  List<String> get dialogueFeatures => throw _privateConstructorUsedError;
  List<String> get rhetoricalDevices => throw _privateConstructorUsedError;
  String get pacingRhythm => throw _privateConstructorUsedError;
  String get emotionalTone => throw _privateConstructorUsedError;

  /// Serializes this WritingStyle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WritingStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WritingStyleCopyWith<WritingStyle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WritingStyleCopyWith<$Res> {
  factory $WritingStyleCopyWith(
          WritingStyle value, $Res Function(WritingStyle) then) =
      _$WritingStyleCopyWithImpl<$Res, WritingStyle>;
  @useResult
  $Res call(
      {String narrativePerspective,
      String languageStyle,
      List<String> dialogueFeatures,
      List<String> rhetoricalDevices,
      String pacingRhythm,
      String emotionalTone});
}

/// @nodoc
class _$WritingStyleCopyWithImpl<$Res, $Val extends WritingStyle>
    implements $WritingStyleCopyWith<$Res> {
  _$WritingStyleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WritingStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? narrativePerspective = null,
    Object? languageStyle = null,
    Object? dialogueFeatures = null,
    Object? rhetoricalDevices = null,
    Object? pacingRhythm = null,
    Object? emotionalTone = null,
  }) {
    return _then(_value.copyWith(
      narrativePerspective: null == narrativePerspective
          ? _value.narrativePerspective
          : narrativePerspective // ignore: cast_nullable_to_non_nullable
              as String,
      languageStyle: null == languageStyle
          ? _value.languageStyle
          : languageStyle // ignore: cast_nullable_to_non_nullable
              as String,
      dialogueFeatures: null == dialogueFeatures
          ? _value.dialogueFeatures
          : dialogueFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rhetoricalDevices: null == rhetoricalDevices
          ? _value.rhetoricalDevices
          : rhetoricalDevices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pacingRhythm: null == pacingRhythm
          ? _value.pacingRhythm
          : pacingRhythm // ignore: cast_nullable_to_non_nullable
              as String,
      emotionalTone: null == emotionalTone
          ? _value.emotionalTone
          : emotionalTone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WritingStyleImplCopyWith<$Res>
    implements $WritingStyleCopyWith<$Res> {
  factory _$$WritingStyleImplCopyWith(
          _$WritingStyleImpl value, $Res Function(_$WritingStyleImpl) then) =
      __$$WritingStyleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String narrativePerspective,
      String languageStyle,
      List<String> dialogueFeatures,
      List<String> rhetoricalDevices,
      String pacingRhythm,
      String emotionalTone});
}

/// @nodoc
class __$$WritingStyleImplCopyWithImpl<$Res>
    extends _$WritingStyleCopyWithImpl<$Res, _$WritingStyleImpl>
    implements _$$WritingStyleImplCopyWith<$Res> {
  __$$WritingStyleImplCopyWithImpl(
      _$WritingStyleImpl _value, $Res Function(_$WritingStyleImpl) _then)
      : super(_value, _then);

  /// Create a copy of WritingStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? narrativePerspective = null,
    Object? languageStyle = null,
    Object? dialogueFeatures = null,
    Object? rhetoricalDevices = null,
    Object? pacingRhythm = null,
    Object? emotionalTone = null,
  }) {
    return _then(_$WritingStyleImpl(
      narrativePerspective: null == narrativePerspective
          ? _value.narrativePerspective
          : narrativePerspective // ignore: cast_nullable_to_non_nullable
              as String,
      languageStyle: null == languageStyle
          ? _value.languageStyle
          : languageStyle // ignore: cast_nullable_to_non_nullable
              as String,
      dialogueFeatures: null == dialogueFeatures
          ? _value._dialogueFeatures
          : dialogueFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rhetoricalDevices: null == rhetoricalDevices
          ? _value._rhetoricalDevices
          : rhetoricalDevices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pacingRhythm: null == pacingRhythm
          ? _value.pacingRhythm
          : pacingRhythm // ignore: cast_nullable_to_non_nullable
              as String,
      emotionalTone: null == emotionalTone
          ? _value.emotionalTone
          : emotionalTone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WritingStyleImpl implements _WritingStyle {
  const _$WritingStyleImpl(
      {this.narrativePerspective = '第三人称',
      this.languageStyle = '',
      final List<String> dialogueFeatures = const [],
      final List<String> rhetoricalDevices = const [],
      this.pacingRhythm = '',
      this.emotionalTone = ''})
      : _dialogueFeatures = dialogueFeatures,
        _rhetoricalDevices = rhetoricalDevices;

  factory _$WritingStyleImpl.fromJson(Map<String, dynamic> json) =>
      _$$WritingStyleImplFromJson(json);

  @override
  @JsonKey()
  final String narrativePerspective;
  @override
  @JsonKey()
  final String languageStyle;
  final List<String> _dialogueFeatures;
  @override
  @JsonKey()
  List<String> get dialogueFeatures {
    if (_dialogueFeatures is EqualUnmodifiableListView)
      return _dialogueFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dialogueFeatures);
  }

  final List<String> _rhetoricalDevices;
  @override
  @JsonKey()
  List<String> get rhetoricalDevices {
    if (_rhetoricalDevices is EqualUnmodifiableListView)
      return _rhetoricalDevices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rhetoricalDevices);
  }

  @override
  @JsonKey()
  final String pacingRhythm;
  @override
  @JsonKey()
  final String emotionalTone;

  @override
  String toString() {
    return 'WritingStyle(narrativePerspective: $narrativePerspective, languageStyle: $languageStyle, dialogueFeatures: $dialogueFeatures, rhetoricalDevices: $rhetoricalDevices, pacingRhythm: $pacingRhythm, emotionalTone: $emotionalTone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WritingStyleImpl &&
            (identical(other.narrativePerspective, narrativePerspective) ||
                other.narrativePerspective == narrativePerspective) &&
            (identical(other.languageStyle, languageStyle) ||
                other.languageStyle == languageStyle) &&
            const DeepCollectionEquality()
                .equals(other._dialogueFeatures, _dialogueFeatures) &&
            const DeepCollectionEquality()
                .equals(other._rhetoricalDevices, _rhetoricalDevices) &&
            (identical(other.pacingRhythm, pacingRhythm) ||
                other.pacingRhythm == pacingRhythm) &&
            (identical(other.emotionalTone, emotionalTone) ||
                other.emotionalTone == emotionalTone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      narrativePerspective,
      languageStyle,
      const DeepCollectionEquality().hash(_dialogueFeatures),
      const DeepCollectionEquality().hash(_rhetoricalDevices),
      pacingRhythm,
      emotionalTone);

  /// Create a copy of WritingStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WritingStyleImplCopyWith<_$WritingStyleImpl> get copyWith =>
      __$$WritingStyleImplCopyWithImpl<_$WritingStyleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WritingStyleImplToJson(
      this,
    );
  }
}

abstract class _WritingStyle implements WritingStyle {
  const factory _WritingStyle(
      {final String narrativePerspective,
      final String languageStyle,
      final List<String> dialogueFeatures,
      final List<String> rhetoricalDevices,
      final String pacingRhythm,
      final String emotionalTone}) = _$WritingStyleImpl;

  factory _WritingStyle.fromJson(Map<String, dynamic> json) =
      _$WritingStyleImpl.fromJson;

  @override
  String get narrativePerspective;
  @override
  String get languageStyle;
  @override
  List<String> get dialogueFeatures;
  @override
  List<String> get rhetoricalDevices;
  @override
  String get pacingRhythm;
  @override
  String get emotionalTone;

  /// Create a copy of WritingStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WritingStyleImplCopyWith<_$WritingStyleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EntityRelation _$EntityRelationFromJson(Map<String, dynamic> json) {
  return _EntityRelation.fromJson(json);
}

/// @nodoc
mixin _$EntityRelation {
  String get entityA => throw _privateConstructorUsedError;
  String get relation => throw _privateConstructorUsedError;
  String get entityB => throw _privateConstructorUsedError;
  Map<String, dynamic> get properties => throw _privateConstructorUsedError;

  /// Serializes this EntityRelation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityRelationCopyWith<EntityRelation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityRelationCopyWith<$Res> {
  factory $EntityRelationCopyWith(
          EntityRelation value, $Res Function(EntityRelation) then) =
      _$EntityRelationCopyWithImpl<$Res, EntityRelation>;
  @useResult
  $Res call(
      {String entityA,
      String relation,
      String entityB,
      Map<String, dynamic> properties});
}

/// @nodoc
class _$EntityRelationCopyWithImpl<$Res, $Val extends EntityRelation>
    implements $EntityRelationCopyWith<$Res> {
  _$EntityRelationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityA = null,
    Object? relation = null,
    Object? entityB = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      entityA: null == entityA
          ? _value.entityA
          : entityA // ignore: cast_nullable_to_non_nullable
              as String,
      relation: null == relation
          ? _value.relation
          : relation // ignore: cast_nullable_to_non_nullable
              as String,
      entityB: null == entityB
          ? _value.entityB
          : entityB // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntityRelationImplCopyWith<$Res>
    implements $EntityRelationCopyWith<$Res> {
  factory _$$EntityRelationImplCopyWith(_$EntityRelationImpl value,
          $Res Function(_$EntityRelationImpl) then) =
      __$$EntityRelationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String entityA,
      String relation,
      String entityB,
      Map<String, dynamic> properties});
}

/// @nodoc
class __$$EntityRelationImplCopyWithImpl<$Res>
    extends _$EntityRelationCopyWithImpl<$Res, _$EntityRelationImpl>
    implements _$$EntityRelationImplCopyWith<$Res> {
  __$$EntityRelationImplCopyWithImpl(
      _$EntityRelationImpl _value, $Res Function(_$EntityRelationImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityA = null,
    Object? relation = null,
    Object? entityB = null,
    Object? properties = null,
  }) {
    return _then(_$EntityRelationImpl(
      entityA: null == entityA
          ? _value.entityA
          : entityA // ignore: cast_nullable_to_non_nullable
              as String,
      relation: null == relation
          ? _value.relation
          : relation // ignore: cast_nullable_to_non_nullable
              as String,
      entityB: null == entityB
          ? _value.entityB
          : entityB // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntityRelationImpl implements _EntityRelation {
  const _$EntityRelationImpl(
      {required this.entityA,
      required this.relation,
      required this.entityB,
      final Map<String, dynamic> properties = const {}})
      : _properties = properties;

  factory _$EntityRelationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntityRelationImplFromJson(json);

  @override
  final String entityA;
  @override
  final String relation;
  @override
  final String entityB;
  final Map<String, dynamic> _properties;
  @override
  @JsonKey()
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  String toString() {
    return 'EntityRelation(entityA: $entityA, relation: $relation, entityB: $entityB, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityRelationImpl &&
            (identical(other.entityA, entityA) || other.entityA == entityA) &&
            (identical(other.relation, relation) ||
                other.relation == relation) &&
            (identical(other.entityB, entityB) || other.entityB == entityB) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, entityA, relation, entityB,
      const DeepCollectionEquality().hash(_properties));

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityRelationImplCopyWith<_$EntityRelationImpl> get copyWith =>
      __$$EntityRelationImplCopyWithImpl<_$EntityRelationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntityRelationImplToJson(
      this,
    );
  }
}

abstract class _EntityRelation implements EntityRelation {
  const factory _EntityRelation(
      {required final String entityA,
      required final String relation,
      required final String entityB,
      final Map<String, dynamic> properties}) = _$EntityRelationImpl;

  factory _EntityRelation.fromJson(Map<String, dynamic> json) =
      _$EntityRelationImpl.fromJson;

  @override
  String get entityA;
  @override
  String get relation;
  @override
  String get entityB;
  @override
  Map<String, dynamic> get properties;

  /// Create a copy of EntityRelation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntityRelationImplCopyWith<_$EntityRelationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphChange _$GraphChangeFromJson(Map<String, dynamic> json) {
  return _GraphChange.fromJson(json);
}

/// @nodoc
mixin _$GraphChange {
  List<String> get globalChanges => throw _privateConstructorUsedError;
  List<String> get prerequisiteChapterDependencies =>
      throw _privateConstructorUsedError;
  List<String> get impactOnFutureChapters => throw _privateConstructorUsedError;
  List<String> get conflictWarnings => throw _privateConstructorUsedError;

  /// Serializes this GraphChange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphChangeCopyWith<GraphChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphChangeCopyWith<$Res> {
  factory $GraphChangeCopyWith(
          GraphChange value, $Res Function(GraphChange) then) =
      _$GraphChangeCopyWithImpl<$Res, GraphChange>;
  @useResult
  $Res call(
      {List<String> globalChanges,
      List<String> prerequisiteChapterDependencies,
      List<String> impactOnFutureChapters,
      List<String> conflictWarnings});
}

/// @nodoc
class _$GraphChangeCopyWithImpl<$Res, $Val extends GraphChange>
    implements $GraphChangeCopyWith<$Res> {
  _$GraphChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? globalChanges = null,
    Object? prerequisiteChapterDependencies = null,
    Object? impactOnFutureChapters = null,
    Object? conflictWarnings = null,
  }) {
    return _then(_value.copyWith(
      globalChanges: null == globalChanges
          ? _value.globalChanges
          : globalChanges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prerequisiteChapterDependencies: null == prerequisiteChapterDependencies
          ? _value.prerequisiteChapterDependencies
          : prerequisiteChapterDependencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      impactOnFutureChapters: null == impactOnFutureChapters
          ? _value.impactOnFutureChapters
          : impactOnFutureChapters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      conflictWarnings: null == conflictWarnings
          ? _value.conflictWarnings
          : conflictWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphChangeImplCopyWith<$Res>
    implements $GraphChangeCopyWith<$Res> {
  factory _$$GraphChangeImplCopyWith(
          _$GraphChangeImpl value, $Res Function(_$GraphChangeImpl) then) =
      __$$GraphChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> globalChanges,
      List<String> prerequisiteChapterDependencies,
      List<String> impactOnFutureChapters,
      List<String> conflictWarnings});
}

/// @nodoc
class __$$GraphChangeImplCopyWithImpl<$Res>
    extends _$GraphChangeCopyWithImpl<$Res, _$GraphChangeImpl>
    implements _$$GraphChangeImplCopyWith<$Res> {
  __$$GraphChangeImplCopyWithImpl(
      _$GraphChangeImpl _value, $Res Function(_$GraphChangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? globalChanges = null,
    Object? prerequisiteChapterDependencies = null,
    Object? impactOnFutureChapters = null,
    Object? conflictWarnings = null,
  }) {
    return _then(_$GraphChangeImpl(
      globalChanges: null == globalChanges
          ? _value._globalChanges
          : globalChanges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prerequisiteChapterDependencies: null == prerequisiteChapterDependencies
          ? _value._prerequisiteChapterDependencies
          : prerequisiteChapterDependencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      impactOnFutureChapters: null == impactOnFutureChapters
          ? _value._impactOnFutureChapters
          : impactOnFutureChapters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      conflictWarnings: null == conflictWarnings
          ? _value._conflictWarnings
          : conflictWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphChangeImpl implements _GraphChange {
  const _$GraphChangeImpl(
      {final List<String> globalChanges = const [],
      final List<String> prerequisiteChapterDependencies = const [],
      final List<String> impactOnFutureChapters = const [],
      final List<String> conflictWarnings = const []})
      : _globalChanges = globalChanges,
        _prerequisiteChapterDependencies = prerequisiteChapterDependencies,
        _impactOnFutureChapters = impactOnFutureChapters,
        _conflictWarnings = conflictWarnings;

  factory _$GraphChangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphChangeImplFromJson(json);

  final List<String> _globalChanges;
  @override
  @JsonKey()
  List<String> get globalChanges {
    if (_globalChanges is EqualUnmodifiableListView) return _globalChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_globalChanges);
  }

  final List<String> _prerequisiteChapterDependencies;
  @override
  @JsonKey()
  List<String> get prerequisiteChapterDependencies {
    if (_prerequisiteChapterDependencies is EqualUnmodifiableListView)
      return _prerequisiteChapterDependencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisiteChapterDependencies);
  }

  final List<String> _impactOnFutureChapters;
  @override
  @JsonKey()
  List<String> get impactOnFutureChapters {
    if (_impactOnFutureChapters is EqualUnmodifiableListView)
      return _impactOnFutureChapters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_impactOnFutureChapters);
  }

  final List<String> _conflictWarnings;
  @override
  @JsonKey()
  List<String> get conflictWarnings {
    if (_conflictWarnings is EqualUnmodifiableListView)
      return _conflictWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conflictWarnings);
  }

  @override
  String toString() {
    return 'GraphChange(globalChanges: $globalChanges, prerequisiteChapterDependencies: $prerequisiteChapterDependencies, impactOnFutureChapters: $impactOnFutureChapters, conflictWarnings: $conflictWarnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphChangeImpl &&
            const DeepCollectionEquality()
                .equals(other._globalChanges, _globalChanges) &&
            const DeepCollectionEquality().equals(
                other._prerequisiteChapterDependencies,
                _prerequisiteChapterDependencies) &&
            const DeepCollectionEquality().equals(
                other._impactOnFutureChapters, _impactOnFutureChapters) &&
            const DeepCollectionEquality()
                .equals(other._conflictWarnings, _conflictWarnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_globalChanges),
      const DeepCollectionEquality().hash(_prerequisiteChapterDependencies),
      const DeepCollectionEquality().hash(_impactOnFutureChapters),
      const DeepCollectionEquality().hash(_conflictWarnings));

  /// Create a copy of GraphChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphChangeImplCopyWith<_$GraphChangeImpl> get copyWith =>
      __$$GraphChangeImplCopyWithImpl<_$GraphChangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphChangeImplToJson(
      this,
    );
  }
}

abstract class _GraphChange implements GraphChange {
  const factory _GraphChange(
      {final List<String> globalChanges,
      final List<String> prerequisiteChapterDependencies,
      final List<String> impactOnFutureChapters,
      final List<String> conflictWarnings}) = _$GraphChangeImpl;

  factory _GraphChange.fromJson(Map<String, dynamic> json) =
      _$GraphChangeImpl.fromJson;

  @override
  List<String> get globalChanges;
  @override
  List<String> get prerequisiteChapterDependencies;
  @override
  List<String> get impactOnFutureChapters;
  @override
  List<String> get conflictWarnings;

  /// Create a copy of GraphChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphChangeImplCopyWith<_$GraphChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReverseAnalysis _$ReverseAnalysisFromJson(Map<String, dynamic> json) {
  return _ReverseAnalysis.fromJson(json);
}

/// @nodoc
mixin _$ReverseAnalysis {
  String get aiInsights => throw _privateConstructorUsedError;
  List<String> get callbackForeshadows => throw _privateConstructorUsedError;
  Map<String, dynamic> get qualityAssessment =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get narrativeGaps => throw _privateConstructorUsedError;

  /// Serializes this ReverseAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReverseAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReverseAnalysisCopyWith<ReverseAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReverseAnalysisCopyWith<$Res> {
  factory $ReverseAnalysisCopyWith(
          ReverseAnalysis value, $Res Function(ReverseAnalysis) then) =
      _$ReverseAnalysisCopyWithImpl<$Res, ReverseAnalysis>;
  @useResult
  $Res call(
      {String aiInsights,
      List<String> callbackForeshadows,
      Map<String, dynamic> qualityAssessment,
      Map<String, dynamic> narrativeGaps});
}

/// @nodoc
class _$ReverseAnalysisCopyWithImpl<$Res, $Val extends ReverseAnalysis>
    implements $ReverseAnalysisCopyWith<$Res> {
  _$ReverseAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReverseAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiInsights = null,
    Object? callbackForeshadows = null,
    Object? qualityAssessment = null,
    Object? narrativeGaps = null,
  }) {
    return _then(_value.copyWith(
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as String,
      callbackForeshadows: null == callbackForeshadows
          ? _value.callbackForeshadows
          : callbackForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
      qualityAssessment: null == qualityAssessment
          ? _value.qualityAssessment
          : qualityAssessment // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      narrativeGaps: null == narrativeGaps
          ? _value.narrativeGaps
          : narrativeGaps // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReverseAnalysisImplCopyWith<$Res>
    implements $ReverseAnalysisCopyWith<$Res> {
  factory _$$ReverseAnalysisImplCopyWith(_$ReverseAnalysisImpl value,
          $Res Function(_$ReverseAnalysisImpl) then) =
      __$$ReverseAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String aiInsights,
      List<String> callbackForeshadows,
      Map<String, dynamic> qualityAssessment,
      Map<String, dynamic> narrativeGaps});
}

/// @nodoc
class __$$ReverseAnalysisImplCopyWithImpl<$Res>
    extends _$ReverseAnalysisCopyWithImpl<$Res, _$ReverseAnalysisImpl>
    implements _$$ReverseAnalysisImplCopyWith<$Res> {
  __$$ReverseAnalysisImplCopyWithImpl(
      _$ReverseAnalysisImpl _value, $Res Function(_$ReverseAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReverseAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiInsights = null,
    Object? callbackForeshadows = null,
    Object? qualityAssessment = null,
    Object? narrativeGaps = null,
  }) {
    return _then(_$ReverseAnalysisImpl(
      aiInsights: null == aiInsights
          ? _value.aiInsights
          : aiInsights // ignore: cast_nullable_to_non_nullable
              as String,
      callbackForeshadows: null == callbackForeshadows
          ? _value._callbackForeshadows
          : callbackForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
      qualityAssessment: null == qualityAssessment
          ? _value._qualityAssessment
          : qualityAssessment // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      narrativeGaps: null == narrativeGaps
          ? _value._narrativeGaps
          : narrativeGaps // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReverseAnalysisImpl implements _ReverseAnalysis {
  const _$ReverseAnalysisImpl(
      {this.aiInsights = '',
      final List<String> callbackForeshadows = const [],
      final Map<String, dynamic> qualityAssessment = const {},
      final Map<String, dynamic> narrativeGaps = const {}})
      : _callbackForeshadows = callbackForeshadows,
        _qualityAssessment = qualityAssessment,
        _narrativeGaps = narrativeGaps;

  factory _$ReverseAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReverseAnalysisImplFromJson(json);

  @override
  @JsonKey()
  final String aiInsights;
  final List<String> _callbackForeshadows;
  @override
  @JsonKey()
  List<String> get callbackForeshadows {
    if (_callbackForeshadows is EqualUnmodifiableListView)
      return _callbackForeshadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_callbackForeshadows);
  }

  final Map<String, dynamic> _qualityAssessment;
  @override
  @JsonKey()
  Map<String, dynamic> get qualityAssessment {
    if (_qualityAssessment is EqualUnmodifiableMapView)
      return _qualityAssessment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_qualityAssessment);
  }

  final Map<String, dynamic> _narrativeGaps;
  @override
  @JsonKey()
  Map<String, dynamic> get narrativeGaps {
    if (_narrativeGaps is EqualUnmodifiableMapView) return _narrativeGaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_narrativeGaps);
  }

  @override
  String toString() {
    return 'ReverseAnalysis(aiInsights: $aiInsights, callbackForeshadows: $callbackForeshadows, qualityAssessment: $qualityAssessment, narrativeGaps: $narrativeGaps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReverseAnalysisImpl &&
            (identical(other.aiInsights, aiInsights) ||
                other.aiInsights == aiInsights) &&
            const DeepCollectionEquality()
                .equals(other._callbackForeshadows, _callbackForeshadows) &&
            const DeepCollectionEquality()
                .equals(other._qualityAssessment, _qualityAssessment) &&
            const DeepCollectionEquality()
                .equals(other._narrativeGaps, _narrativeGaps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      aiInsights,
      const DeepCollectionEquality().hash(_callbackForeshadows),
      const DeepCollectionEquality().hash(_qualityAssessment),
      const DeepCollectionEquality().hash(_narrativeGaps));

  /// Create a copy of ReverseAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReverseAnalysisImplCopyWith<_$ReverseAnalysisImpl> get copyWith =>
      __$$ReverseAnalysisImplCopyWithImpl<_$ReverseAnalysisImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReverseAnalysisImplToJson(
      this,
    );
  }
}

abstract class _ReverseAnalysis implements ReverseAnalysis {
  const factory _ReverseAnalysis(
      {final String aiInsights,
      final List<String> callbackForeshadows,
      final Map<String, dynamic> qualityAssessment,
      final Map<String, dynamic> narrativeGaps}) = _$ReverseAnalysisImpl;

  factory _ReverseAnalysis.fromJson(Map<String, dynamic> json) =
      _$ReverseAnalysisImpl.fromJson;

  @override
  String get aiInsights;
  @override
  List<String> get callbackForeshadows;
  @override
  Map<String, dynamic> get qualityAssessment;
  @override
  Map<String, dynamic> get narrativeGaps;

  /// Create a copy of ReverseAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReverseAnalysisImplCopyWith<_$ReverseAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MergedKnowledgeGraph _$MergedKnowledgeGraphFromJson(Map<String, dynamic> json) {
  return _MergedKnowledgeGraph.fromJson(json);
}

/// @nodoc
mixin _$MergedKnowledgeGraph {
  String get id => throw _privateConstructorUsedError;
  String get novelId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  GlobalBasicInfo get globalBasicInfo => throw _privateConstructorUsedError;
  List<CharacterInfo> get characterPool => throw _privateConstructorUsedError;
  WorldSettingPool get worldSettingPool => throw _privateConstructorUsedError;
  FullPlotTimeline get fullPlotTimeline => throw _privateConstructorUsedError;
  WritingStyleGuide get writingStyleGuide => throw _privateConstructorUsedError;
  List<EntityRelation> get entityNetwork => throw _privateConstructorUsedError;
  List<ReverseDependency> get reverseDepMap =>
      throw _privateConstructorUsedError;
  ReverseAnalysis get reverseAnalysis => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MergedKnowledgeGraph to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MergedKnowledgeGraphCopyWith<MergedKnowledgeGraph> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MergedKnowledgeGraphCopyWith<$Res> {
  factory $MergedKnowledgeGraphCopyWith(MergedKnowledgeGraph value,
          $Res Function(MergedKnowledgeGraph) then) =
      _$MergedKnowledgeGraphCopyWithImpl<$Res, MergedKnowledgeGraph>;
  @useResult
  $Res call(
      {String id,
      String novelId,
      String version,
      GlobalBasicInfo globalBasicInfo,
      List<CharacterInfo> characterPool,
      WorldSettingPool worldSettingPool,
      FullPlotTimeline fullPlotTimeline,
      WritingStyleGuide writingStyleGuide,
      List<EntityRelation> entityNetwork,
      List<ReverseDependency> reverseDepMap,
      ReverseAnalysis reverseAnalysis,
      DateTime? createdAt,
      DateTime? updatedAt});

  $GlobalBasicInfoCopyWith<$Res> get globalBasicInfo;
  $WorldSettingPoolCopyWith<$Res> get worldSettingPool;
  $FullPlotTimelineCopyWith<$Res> get fullPlotTimeline;
  $WritingStyleGuideCopyWith<$Res> get writingStyleGuide;
  $ReverseAnalysisCopyWith<$Res> get reverseAnalysis;
}

/// @nodoc
class _$MergedKnowledgeGraphCopyWithImpl<$Res,
        $Val extends MergedKnowledgeGraph>
    implements $MergedKnowledgeGraphCopyWith<$Res> {
  _$MergedKnowledgeGraphCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? novelId = null,
    Object? version = null,
    Object? globalBasicInfo = null,
    Object? characterPool = null,
    Object? worldSettingPool = null,
    Object? fullPlotTimeline = null,
    Object? writingStyleGuide = null,
    Object? entityNetwork = null,
    Object? reverseDepMap = null,
    Object? reverseAnalysis = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      globalBasicInfo: null == globalBasicInfo
          ? _value.globalBasicInfo
          : globalBasicInfo // ignore: cast_nullable_to_non_nullable
              as GlobalBasicInfo,
      characterPool: null == characterPool
          ? _value.characterPool
          : characterPool // ignore: cast_nullable_to_non_nullable
              as List<CharacterInfo>,
      worldSettingPool: null == worldSettingPool
          ? _value.worldSettingPool
          : worldSettingPool // ignore: cast_nullable_to_non_nullable
              as WorldSettingPool,
      fullPlotTimeline: null == fullPlotTimeline
          ? _value.fullPlotTimeline
          : fullPlotTimeline // ignore: cast_nullable_to_non_nullable
              as FullPlotTimeline,
      writingStyleGuide: null == writingStyleGuide
          ? _value.writingStyleGuide
          : writingStyleGuide // ignore: cast_nullable_to_non_nullable
              as WritingStyleGuide,
      entityNetwork: null == entityNetwork
          ? _value.entityNetwork
          : entityNetwork // ignore: cast_nullable_to_non_nullable
              as List<EntityRelation>,
      reverseDepMap: null == reverseDepMap
          ? _value.reverseDepMap
          : reverseDepMap // ignore: cast_nullable_to_non_nullable
              as List<ReverseDependency>,
      reverseAnalysis: null == reverseAnalysis
          ? _value.reverseAnalysis
          : reverseAnalysis // ignore: cast_nullable_to_non_nullable
              as ReverseAnalysis,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GlobalBasicInfoCopyWith<$Res> get globalBasicInfo {
    return $GlobalBasicInfoCopyWith<$Res>(_value.globalBasicInfo, (value) {
      return _then(_value.copyWith(globalBasicInfo: value) as $Val);
    });
  }

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorldSettingPoolCopyWith<$Res> get worldSettingPool {
    return $WorldSettingPoolCopyWith<$Res>(_value.worldSettingPool, (value) {
      return _then(_value.copyWith(worldSettingPool: value) as $Val);
    });
  }

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FullPlotTimelineCopyWith<$Res> get fullPlotTimeline {
    return $FullPlotTimelineCopyWith<$Res>(_value.fullPlotTimeline, (value) {
      return _then(_value.copyWith(fullPlotTimeline: value) as $Val);
    });
  }

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WritingStyleGuideCopyWith<$Res> get writingStyleGuide {
    return $WritingStyleGuideCopyWith<$Res>(_value.writingStyleGuide, (value) {
      return _then(_value.copyWith(writingStyleGuide: value) as $Val);
    });
  }

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReverseAnalysisCopyWith<$Res> get reverseAnalysis {
    return $ReverseAnalysisCopyWith<$Res>(_value.reverseAnalysis, (value) {
      return _then(_value.copyWith(reverseAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MergedKnowledgeGraphImplCopyWith<$Res>
    implements $MergedKnowledgeGraphCopyWith<$Res> {
  factory _$$MergedKnowledgeGraphImplCopyWith(_$MergedKnowledgeGraphImpl value,
          $Res Function(_$MergedKnowledgeGraphImpl) then) =
      __$$MergedKnowledgeGraphImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String novelId,
      String version,
      GlobalBasicInfo globalBasicInfo,
      List<CharacterInfo> characterPool,
      WorldSettingPool worldSettingPool,
      FullPlotTimeline fullPlotTimeline,
      WritingStyleGuide writingStyleGuide,
      List<EntityRelation> entityNetwork,
      List<ReverseDependency> reverseDepMap,
      ReverseAnalysis reverseAnalysis,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $GlobalBasicInfoCopyWith<$Res> get globalBasicInfo;
  @override
  $WorldSettingPoolCopyWith<$Res> get worldSettingPool;
  @override
  $FullPlotTimelineCopyWith<$Res> get fullPlotTimeline;
  @override
  $WritingStyleGuideCopyWith<$Res> get writingStyleGuide;
  @override
  $ReverseAnalysisCopyWith<$Res> get reverseAnalysis;
}

/// @nodoc
class __$$MergedKnowledgeGraphImplCopyWithImpl<$Res>
    extends _$MergedKnowledgeGraphCopyWithImpl<$Res, _$MergedKnowledgeGraphImpl>
    implements _$$MergedKnowledgeGraphImplCopyWith<$Res> {
  __$$MergedKnowledgeGraphImplCopyWithImpl(_$MergedKnowledgeGraphImpl _value,
      $Res Function(_$MergedKnowledgeGraphImpl) _then)
      : super(_value, _then);

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? novelId = null,
    Object? version = null,
    Object? globalBasicInfo = null,
    Object? characterPool = null,
    Object? worldSettingPool = null,
    Object? fullPlotTimeline = null,
    Object? writingStyleGuide = null,
    Object? entityNetwork = null,
    Object? reverseDepMap = null,
    Object? reverseAnalysis = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MergedKnowledgeGraphImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      novelId: null == novelId
          ? _value.novelId
          : novelId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      globalBasicInfo: null == globalBasicInfo
          ? _value.globalBasicInfo
          : globalBasicInfo // ignore: cast_nullable_to_non_nullable
              as GlobalBasicInfo,
      characterPool: null == characterPool
          ? _value._characterPool
          : characterPool // ignore: cast_nullable_to_non_nullable
              as List<CharacterInfo>,
      worldSettingPool: null == worldSettingPool
          ? _value.worldSettingPool
          : worldSettingPool // ignore: cast_nullable_to_non_nullable
              as WorldSettingPool,
      fullPlotTimeline: null == fullPlotTimeline
          ? _value.fullPlotTimeline
          : fullPlotTimeline // ignore: cast_nullable_to_non_nullable
              as FullPlotTimeline,
      writingStyleGuide: null == writingStyleGuide
          ? _value.writingStyleGuide
          : writingStyleGuide // ignore: cast_nullable_to_non_nullable
              as WritingStyleGuide,
      entityNetwork: null == entityNetwork
          ? _value._entityNetwork
          : entityNetwork // ignore: cast_nullable_to_non_nullable
              as List<EntityRelation>,
      reverseDepMap: null == reverseDepMap
          ? _value._reverseDepMap
          : reverseDepMap // ignore: cast_nullable_to_non_nullable
              as List<ReverseDependency>,
      reverseAnalysis: null == reverseAnalysis
          ? _value.reverseAnalysis
          : reverseAnalysis // ignore: cast_nullable_to_non_nullable
              as ReverseAnalysis,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MergedKnowledgeGraphImpl extends _MergedKnowledgeGraph {
  const _$MergedKnowledgeGraphImpl(
      {required this.id,
      required this.novelId,
      this.version = kKnowledgeGraphVersion,
      required this.globalBasicInfo,
      final List<CharacterInfo> characterPool = const [],
      this.worldSettingPool = const WorldSettingPool(),
      required this.fullPlotTimeline,
      required this.writingStyleGuide,
      final List<EntityRelation> entityNetwork = const [],
      final List<ReverseDependency> reverseDepMap = const [],
      required this.reverseAnalysis,
      this.createdAt,
      this.updatedAt})
      : _characterPool = characterPool,
        _entityNetwork = entityNetwork,
        _reverseDepMap = reverseDepMap,
        super._();

  factory _$MergedKnowledgeGraphImpl.fromJson(Map<String, dynamic> json) =>
      _$$MergedKnowledgeGraphImplFromJson(json);

  @override
  final String id;
  @override
  final String novelId;
  @override
  @JsonKey()
  final String version;
  @override
  final GlobalBasicInfo globalBasicInfo;
  final List<CharacterInfo> _characterPool;
  @override
  @JsonKey()
  List<CharacterInfo> get characterPool {
    if (_characterPool is EqualUnmodifiableListView) return _characterPool;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_characterPool);
  }

  @override
  @JsonKey()
  final WorldSettingPool worldSettingPool;
  @override
  final FullPlotTimeline fullPlotTimeline;
  @override
  final WritingStyleGuide writingStyleGuide;
  final List<EntityRelation> _entityNetwork;
  @override
  @JsonKey()
  List<EntityRelation> get entityNetwork {
    if (_entityNetwork is EqualUnmodifiableListView) return _entityNetwork;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entityNetwork);
  }

  final List<ReverseDependency> _reverseDepMap;
  @override
  @JsonKey()
  List<ReverseDependency> get reverseDepMap {
    if (_reverseDepMap is EqualUnmodifiableListView) return _reverseDepMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reverseDepMap);
  }

  @override
  final ReverseAnalysis reverseAnalysis;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MergedKnowledgeGraph(id: $id, novelId: $novelId, version: $version, globalBasicInfo: $globalBasicInfo, characterPool: $characterPool, worldSettingPool: $worldSettingPool, fullPlotTimeline: $fullPlotTimeline, writingStyleGuide: $writingStyleGuide, entityNetwork: $entityNetwork, reverseDepMap: $reverseDepMap, reverseAnalysis: $reverseAnalysis, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MergedKnowledgeGraphImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.novelId, novelId) || other.novelId == novelId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.globalBasicInfo, globalBasicInfo) ||
                other.globalBasicInfo == globalBasicInfo) &&
            const DeepCollectionEquality()
                .equals(other._characterPool, _characterPool) &&
            (identical(other.worldSettingPool, worldSettingPool) ||
                other.worldSettingPool == worldSettingPool) &&
            (identical(other.fullPlotTimeline, fullPlotTimeline) ||
                other.fullPlotTimeline == fullPlotTimeline) &&
            (identical(other.writingStyleGuide, writingStyleGuide) ||
                other.writingStyleGuide == writingStyleGuide) &&
            const DeepCollectionEquality()
                .equals(other._entityNetwork, _entityNetwork) &&
            const DeepCollectionEquality()
                .equals(other._reverseDepMap, _reverseDepMap) &&
            (identical(other.reverseAnalysis, reverseAnalysis) ||
                other.reverseAnalysis == reverseAnalysis) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      novelId,
      version,
      globalBasicInfo,
      const DeepCollectionEquality().hash(_characterPool),
      worldSettingPool,
      fullPlotTimeline,
      writingStyleGuide,
      const DeepCollectionEquality().hash(_entityNetwork),
      const DeepCollectionEquality().hash(_reverseDepMap),
      reverseAnalysis,
      createdAt,
      updatedAt);

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MergedKnowledgeGraphImplCopyWith<_$MergedKnowledgeGraphImpl>
      get copyWith =>
          __$$MergedKnowledgeGraphImplCopyWithImpl<_$MergedKnowledgeGraphImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MergedKnowledgeGraphImplToJson(
      this,
    );
  }
}

abstract class _MergedKnowledgeGraph extends MergedKnowledgeGraph {
  const factory _MergedKnowledgeGraph(
      {required final String id,
      required final String novelId,
      final String version,
      required final GlobalBasicInfo globalBasicInfo,
      final List<CharacterInfo> characterPool,
      final WorldSettingPool worldSettingPool,
      required final FullPlotTimeline fullPlotTimeline,
      required final WritingStyleGuide writingStyleGuide,
      final List<EntityRelation> entityNetwork,
      final List<ReverseDependency> reverseDepMap,
      required final ReverseAnalysis reverseAnalysis,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$MergedKnowledgeGraphImpl;
  const _MergedKnowledgeGraph._() : super._();

  factory _MergedKnowledgeGraph.fromJson(Map<String, dynamic> json) =
      _$MergedKnowledgeGraphImpl.fromJson;

  @override
  String get id;
  @override
  String get novelId;
  @override
  String get version;
  @override
  GlobalBasicInfo get globalBasicInfo;
  @override
  List<CharacterInfo> get characterPool;
  @override
  WorldSettingPool get worldSettingPool;
  @override
  FullPlotTimeline get fullPlotTimeline;
  @override
  WritingStyleGuide get writingStyleGuide;
  @override
  List<EntityRelation> get entityNetwork;
  @override
  List<ReverseDependency> get reverseDepMap;
  @override
  ReverseAnalysis get reverseAnalysis;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MergedKnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MergedKnowledgeGraphImplCopyWith<_$MergedKnowledgeGraphImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GlobalBasicInfo _$GlobalBasicInfoFromJson(Map<String, dynamic> json) {
  return _GlobalBasicInfo.fromJson(json);
}

/// @nodoc
mixin _$GlobalBasicInfo {
  String get novelName => throw _privateConstructorUsedError;
  int get totalChapterCount => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  int? get totalWordCount => throw _privateConstructorUsedError;
  String? get novelGenre => throw _privateConstructorUsedError;

  /// Serializes this GlobalBasicInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlobalBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalBasicInfoCopyWith<GlobalBasicInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalBasicInfoCopyWith<$Res> {
  factory $GlobalBasicInfoCopyWith(
          GlobalBasicInfo value, $Res Function(GlobalBasicInfo) then) =
      _$GlobalBasicInfoCopyWithImpl<$Res, GlobalBasicInfo>;
  @useResult
  $Res call(
      {String novelName,
      int totalChapterCount,
      String version,
      int? totalWordCount,
      String? novelGenre});
}

/// @nodoc
class _$GlobalBasicInfoCopyWithImpl<$Res, $Val extends GlobalBasicInfo>
    implements $GlobalBasicInfoCopyWith<$Res> {
  _$GlobalBasicInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? novelName = null,
    Object? totalChapterCount = null,
    Object? version = null,
    Object? totalWordCount = freezed,
    Object? novelGenre = freezed,
  }) {
    return _then(_value.copyWith(
      novelName: null == novelName
          ? _value.novelName
          : novelName // ignore: cast_nullable_to_non_nullable
              as String,
      totalChapterCount: null == totalChapterCount
          ? _value.totalChapterCount
          : totalChapterCount // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      totalWordCount: freezed == totalWordCount
          ? _value.totalWordCount
          : totalWordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      novelGenre: freezed == novelGenre
          ? _value.novelGenre
          : novelGenre // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalBasicInfoImplCopyWith<$Res>
    implements $GlobalBasicInfoCopyWith<$Res> {
  factory _$$GlobalBasicInfoImplCopyWith(_$GlobalBasicInfoImpl value,
          $Res Function(_$GlobalBasicInfoImpl) then) =
      __$$GlobalBasicInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String novelName,
      int totalChapterCount,
      String version,
      int? totalWordCount,
      String? novelGenre});
}

/// @nodoc
class __$$GlobalBasicInfoImplCopyWithImpl<$Res>
    extends _$GlobalBasicInfoCopyWithImpl<$Res, _$GlobalBasicInfoImpl>
    implements _$$GlobalBasicInfoImplCopyWith<$Res> {
  __$$GlobalBasicInfoImplCopyWithImpl(
      _$GlobalBasicInfoImpl _value, $Res Function(_$GlobalBasicInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlobalBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? novelName = null,
    Object? totalChapterCount = null,
    Object? version = null,
    Object? totalWordCount = freezed,
    Object? novelGenre = freezed,
  }) {
    return _then(_$GlobalBasicInfoImpl(
      novelName: null == novelName
          ? _value.novelName
          : novelName // ignore: cast_nullable_to_non_nullable
              as String,
      totalChapterCount: null == totalChapterCount
          ? _value.totalChapterCount
          : totalChapterCount // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      totalWordCount: freezed == totalWordCount
          ? _value.totalWordCount
          : totalWordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      novelGenre: freezed == novelGenre
          ? _value.novelGenre
          : novelGenre // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GlobalBasicInfoImpl implements _GlobalBasicInfo {
  const _$GlobalBasicInfoImpl(
      {required this.novelName,
      required this.totalChapterCount,
      required this.version,
      this.totalWordCount,
      this.novelGenre});

  factory _$GlobalBasicInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalBasicInfoImplFromJson(json);

  @override
  final String novelName;
  @override
  final int totalChapterCount;
  @override
  final String version;
  @override
  final int? totalWordCount;
  @override
  final String? novelGenre;

  @override
  String toString() {
    return 'GlobalBasicInfo(novelName: $novelName, totalChapterCount: $totalChapterCount, version: $version, totalWordCount: $totalWordCount, novelGenre: $novelGenre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalBasicInfoImpl &&
            (identical(other.novelName, novelName) ||
                other.novelName == novelName) &&
            (identical(other.totalChapterCount, totalChapterCount) ||
                other.totalChapterCount == totalChapterCount) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.totalWordCount, totalWordCount) ||
                other.totalWordCount == totalWordCount) &&
            (identical(other.novelGenre, novelGenre) ||
                other.novelGenre == novelGenre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, novelName, totalChapterCount,
      version, totalWordCount, novelGenre);

  /// Create a copy of GlobalBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalBasicInfoImplCopyWith<_$GlobalBasicInfoImpl> get copyWith =>
      __$$GlobalBasicInfoImplCopyWithImpl<_$GlobalBasicInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalBasicInfoImplToJson(
      this,
    );
  }
}

abstract class _GlobalBasicInfo implements GlobalBasicInfo {
  const factory _GlobalBasicInfo(
      {required final String novelName,
      required final int totalChapterCount,
      required final String version,
      final int? totalWordCount,
      final String? novelGenre}) = _$GlobalBasicInfoImpl;

  factory _GlobalBasicInfo.fromJson(Map<String, dynamic> json) =
      _$GlobalBasicInfoImpl.fromJson;

  @override
  String get novelName;
  @override
  int get totalChapterCount;
  @override
  String get version;
  @override
  int? get totalWordCount;
  @override
  String? get novelGenre;

  /// Create a copy of GlobalBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalBasicInfoImplCopyWith<_$GlobalBasicInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorldSettingPool _$WorldSettingPoolFromJson(Map<String, dynamic> json) {
  return _WorldSettingPool.fromJson(json);
}

/// @nodoc
mixin _$WorldSettingPool {
  List<String> get allEras => throw _privateConstructorUsedError;
  List<String> get allGeography => throw _privateConstructorUsedError;
  List<String> get allPowerSystems => throw _privateConstructorUsedError;
  List<String> get allSocialStructures => throw _privateConstructorUsedError;
  List<String> get allItemsAndCreatures => throw _privateConstructorUsedError;
  List<String> get allForeshadows => throw _privateConstructorUsedError;

  /// Serializes this WorldSettingPool to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldSettingPool
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldSettingPoolCopyWith<WorldSettingPool> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldSettingPoolCopyWith<$Res> {
  factory $WorldSettingPoolCopyWith(
          WorldSettingPool value, $Res Function(WorldSettingPool) then) =
      _$WorldSettingPoolCopyWithImpl<$Res, WorldSettingPool>;
  @useResult
  $Res call(
      {List<String> allEras,
      List<String> allGeography,
      List<String> allPowerSystems,
      List<String> allSocialStructures,
      List<String> allItemsAndCreatures,
      List<String> allForeshadows});
}

/// @nodoc
class _$WorldSettingPoolCopyWithImpl<$Res, $Val extends WorldSettingPool>
    implements $WorldSettingPoolCopyWith<$Res> {
  _$WorldSettingPoolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldSettingPool
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allEras = null,
    Object? allGeography = null,
    Object? allPowerSystems = null,
    Object? allSocialStructures = null,
    Object? allItemsAndCreatures = null,
    Object? allForeshadows = null,
  }) {
    return _then(_value.copyWith(
      allEras: null == allEras
          ? _value.allEras
          : allEras // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allGeography: null == allGeography
          ? _value.allGeography
          : allGeography // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allPowerSystems: null == allPowerSystems
          ? _value.allPowerSystems
          : allPowerSystems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allSocialStructures: null == allSocialStructures
          ? _value.allSocialStructures
          : allSocialStructures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allItemsAndCreatures: null == allItemsAndCreatures
          ? _value.allItemsAndCreatures
          : allItemsAndCreatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allForeshadows: null == allForeshadows
          ? _value.allForeshadows
          : allForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldSettingPoolImplCopyWith<$Res>
    implements $WorldSettingPoolCopyWith<$Res> {
  factory _$$WorldSettingPoolImplCopyWith(_$WorldSettingPoolImpl value,
          $Res Function(_$WorldSettingPoolImpl) then) =
      __$$WorldSettingPoolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> allEras,
      List<String> allGeography,
      List<String> allPowerSystems,
      List<String> allSocialStructures,
      List<String> allItemsAndCreatures,
      List<String> allForeshadows});
}

/// @nodoc
class __$$WorldSettingPoolImplCopyWithImpl<$Res>
    extends _$WorldSettingPoolCopyWithImpl<$Res, _$WorldSettingPoolImpl>
    implements _$$WorldSettingPoolImplCopyWith<$Res> {
  __$$WorldSettingPoolImplCopyWithImpl(_$WorldSettingPoolImpl _value,
      $Res Function(_$WorldSettingPoolImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldSettingPool
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allEras = null,
    Object? allGeography = null,
    Object? allPowerSystems = null,
    Object? allSocialStructures = null,
    Object? allItemsAndCreatures = null,
    Object? allForeshadows = null,
  }) {
    return _then(_$WorldSettingPoolImpl(
      allEras: null == allEras
          ? _value._allEras
          : allEras // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allGeography: null == allGeography
          ? _value._allGeography
          : allGeography // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allPowerSystems: null == allPowerSystems
          ? _value._allPowerSystems
          : allPowerSystems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allSocialStructures: null == allSocialStructures
          ? _value._allSocialStructures
          : allSocialStructures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allItemsAndCreatures: null == allItemsAndCreatures
          ? _value._allItemsAndCreatures
          : allItemsAndCreatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allForeshadows: null == allForeshadows
          ? _value._allForeshadows
          : allForeshadows // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldSettingPoolImpl implements _WorldSettingPool {
  const _$WorldSettingPoolImpl(
      {final List<String> allEras = const [],
      final List<String> allGeography = const [],
      final List<String> allPowerSystems = const [],
      final List<String> allSocialStructures = const [],
      final List<String> allItemsAndCreatures = const [],
      final List<String> allForeshadows = const []})
      : _allEras = allEras,
        _allGeography = allGeography,
        _allPowerSystems = allPowerSystems,
        _allSocialStructures = allSocialStructures,
        _allItemsAndCreatures = allItemsAndCreatures,
        _allForeshadows = allForeshadows;

  factory _$WorldSettingPoolImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldSettingPoolImplFromJson(json);

  final List<String> _allEras;
  @override
  @JsonKey()
  List<String> get allEras {
    if (_allEras is EqualUnmodifiableListView) return _allEras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allEras);
  }

  final List<String> _allGeography;
  @override
  @JsonKey()
  List<String> get allGeography {
    if (_allGeography is EqualUnmodifiableListView) return _allGeography;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allGeography);
  }

  final List<String> _allPowerSystems;
  @override
  @JsonKey()
  List<String> get allPowerSystems {
    if (_allPowerSystems is EqualUnmodifiableListView) return _allPowerSystems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allPowerSystems);
  }

  final List<String> _allSocialStructures;
  @override
  @JsonKey()
  List<String> get allSocialStructures {
    if (_allSocialStructures is EqualUnmodifiableListView)
      return _allSocialStructures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allSocialStructures);
  }

  final List<String> _allItemsAndCreatures;
  @override
  @JsonKey()
  List<String> get allItemsAndCreatures {
    if (_allItemsAndCreatures is EqualUnmodifiableListView)
      return _allItemsAndCreatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allItemsAndCreatures);
  }

  final List<String> _allForeshadows;
  @override
  @JsonKey()
  List<String> get allForeshadows {
    if (_allForeshadows is EqualUnmodifiableListView) return _allForeshadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allForeshadows);
  }

  @override
  String toString() {
    return 'WorldSettingPool(allEras: $allEras, allGeography: $allGeography, allPowerSystems: $allPowerSystems, allSocialStructures: $allSocialStructures, allItemsAndCreatures: $allItemsAndCreatures, allForeshadows: $allForeshadows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldSettingPoolImpl &&
            const DeepCollectionEquality().equals(other._allEras, _allEras) &&
            const DeepCollectionEquality()
                .equals(other._allGeography, _allGeography) &&
            const DeepCollectionEquality()
                .equals(other._allPowerSystems, _allPowerSystems) &&
            const DeepCollectionEquality()
                .equals(other._allSocialStructures, _allSocialStructures) &&
            const DeepCollectionEquality()
                .equals(other._allItemsAndCreatures, _allItemsAndCreatures) &&
            const DeepCollectionEquality()
                .equals(other._allForeshadows, _allForeshadows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allEras),
      const DeepCollectionEquality().hash(_allGeography),
      const DeepCollectionEquality().hash(_allPowerSystems),
      const DeepCollectionEquality().hash(_allSocialStructures),
      const DeepCollectionEquality().hash(_allItemsAndCreatures),
      const DeepCollectionEquality().hash(_allForeshadows));

  /// Create a copy of WorldSettingPool
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldSettingPoolImplCopyWith<_$WorldSettingPoolImpl> get copyWith =>
      __$$WorldSettingPoolImplCopyWithImpl<_$WorldSettingPoolImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldSettingPoolImplToJson(
      this,
    );
  }
}

abstract class _WorldSettingPool implements WorldSettingPool {
  const factory _WorldSettingPool(
      {final List<String> allEras,
      final List<String> allGeography,
      final List<String> allPowerSystems,
      final List<String> allSocialStructures,
      final List<String> allItemsAndCreatures,
      final List<String> allForeshadows}) = _$WorldSettingPoolImpl;

  factory _WorldSettingPool.fromJson(Map<String, dynamic> json) =
      _$WorldSettingPoolImpl.fromJson;

  @override
  List<String> get allEras;
  @override
  List<String> get allGeography;
  @override
  List<String> get allPowerSystems;
  @override
  List<String> get allSocialStructures;
  @override
  List<String> get allItemsAndCreatures;
  @override
  List<String> get allForeshadows;

  /// Create a copy of WorldSettingPool
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldSettingPoolImplCopyWith<_$WorldSettingPoolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FullPlotTimeline _$FullPlotTimelineFromJson(Map<String, dynamic> json) {
  return _FullPlotTimeline.fromJson(json);
}

/// @nodoc
mixin _$FullPlotTimeline {
  List<TimelineNode> get nodes => throw _privateConstructorUsedError;
  List<TimelineEdge> get edges => throw _privateConstructorUsedError;

  /// Serializes this FullPlotTimeline to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FullPlotTimeline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FullPlotTimelineCopyWith<FullPlotTimeline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FullPlotTimelineCopyWith<$Res> {
  factory $FullPlotTimelineCopyWith(
          FullPlotTimeline value, $Res Function(FullPlotTimeline) then) =
      _$FullPlotTimelineCopyWithImpl<$Res, FullPlotTimeline>;
  @useResult
  $Res call({List<TimelineNode> nodes, List<TimelineEdge> edges});
}

/// @nodoc
class _$FullPlotTimelineCopyWithImpl<$Res, $Val extends FullPlotTimeline>
    implements $FullPlotTimelineCopyWith<$Res> {
  _$FullPlotTimelineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FullPlotTimeline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
  }) {
    return _then(_value.copyWith(
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<TimelineNode>,
      edges: null == edges
          ? _value.edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<TimelineEdge>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FullPlotTimelineImplCopyWith<$Res>
    implements $FullPlotTimelineCopyWith<$Res> {
  factory _$$FullPlotTimelineImplCopyWith(_$FullPlotTimelineImpl value,
          $Res Function(_$FullPlotTimelineImpl) then) =
      __$$FullPlotTimelineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TimelineNode> nodes, List<TimelineEdge> edges});
}

/// @nodoc
class __$$FullPlotTimelineImplCopyWithImpl<$Res>
    extends _$FullPlotTimelineCopyWithImpl<$Res, _$FullPlotTimelineImpl>
    implements _$$FullPlotTimelineImplCopyWith<$Res> {
  __$$FullPlotTimelineImplCopyWithImpl(_$FullPlotTimelineImpl _value,
      $Res Function(_$FullPlotTimelineImpl) _then)
      : super(_value, _then);

  /// Create a copy of FullPlotTimeline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
  }) {
    return _then(_$FullPlotTimelineImpl(
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<TimelineNode>,
      edges: null == edges
          ? _value._edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<TimelineEdge>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FullPlotTimelineImpl implements _FullPlotTimeline {
  const _$FullPlotTimelineImpl(
      {final List<TimelineNode> nodes = const [],
      final List<TimelineEdge> edges = const []})
      : _nodes = nodes,
        _edges = edges;

  factory _$FullPlotTimelineImpl.fromJson(Map<String, dynamic> json) =>
      _$$FullPlotTimelineImplFromJson(json);

  final List<TimelineNode> _nodes;
  @override
  @JsonKey()
  List<TimelineNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<TimelineEdge> _edges;
  @override
  @JsonKey()
  List<TimelineEdge> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  @override
  String toString() {
    return 'FullPlotTimeline(nodes: $nodes, edges: $edges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FullPlotTimelineImpl &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_edges));

  /// Create a copy of FullPlotTimeline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FullPlotTimelineImplCopyWith<_$FullPlotTimelineImpl> get copyWith =>
      __$$FullPlotTimelineImplCopyWithImpl<_$FullPlotTimelineImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FullPlotTimelineImplToJson(
      this,
    );
  }
}

abstract class _FullPlotTimeline implements FullPlotTimeline {
  const factory _FullPlotTimeline(
      {final List<TimelineNode> nodes,
      final List<TimelineEdge> edges}) = _$FullPlotTimelineImpl;

  factory _FullPlotTimeline.fromJson(Map<String, dynamic> json) =
      _$FullPlotTimelineImpl.fromJson;

  @override
  List<TimelineNode> get nodes;
  @override
  List<TimelineEdge> get edges;

  /// Create a copy of FullPlotTimeline
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FullPlotTimelineImplCopyWith<_$FullPlotTimelineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineNode _$TimelineNodeFromJson(Map<String, dynamic> json) {
  return _TimelineNode.fromJson(json);
}

/// @nodoc
mixin _$TimelineNode {
  String get id => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get event => throw _privateConstructorUsedError;
  String get timeline => throw _privateConstructorUsedError;
  Map<String, dynamic> get properties => throw _privateConstructorUsedError;

  /// Serializes this TimelineNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineNodeCopyWith<TimelineNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineNodeCopyWith<$Res> {
  factory $TimelineNodeCopyWith(
          TimelineNode value, $Res Function(TimelineNode) then) =
      _$TimelineNodeCopyWithImpl<$Res, TimelineNode>;
  @useResult
  $Res call(
      {String id,
      String chapterId,
      String event,
      String timeline,
      Map<String, dynamic> properties});
}

/// @nodoc
class _$TimelineNodeCopyWithImpl<$Res, $Val extends TimelineNode>
    implements $TimelineNodeCopyWith<$Res> {
  _$TimelineNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? event = null,
    Object? timeline = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelineNodeImplCopyWith<$Res>
    implements $TimelineNodeCopyWith<$Res> {
  factory _$$TimelineNodeImplCopyWith(
          _$TimelineNodeImpl value, $Res Function(_$TimelineNodeImpl) then) =
      __$$TimelineNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chapterId,
      String event,
      String timeline,
      Map<String, dynamic> properties});
}

/// @nodoc
class __$$TimelineNodeImplCopyWithImpl<$Res>
    extends _$TimelineNodeCopyWithImpl<$Res, _$TimelineNodeImpl>
    implements _$$TimelineNodeImplCopyWith<$Res> {
  __$$TimelineNodeImplCopyWithImpl(
      _$TimelineNodeImpl _value, $Res Function(_$TimelineNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimelineNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? event = null,
    Object? timeline = null,
    Object? properties = null,
  }) {
    return _then(_$TimelineNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineNodeImpl implements _TimelineNode {
  const _$TimelineNodeImpl(
      {required this.id,
      required this.chapterId,
      required this.event,
      this.timeline = '',
      final Map<String, dynamic> properties = const {}})
      : _properties = properties;

  factory _$TimelineNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineNodeImplFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;
  @override
  final String event;
  @override
  @JsonKey()
  final String timeline;
  final Map<String, dynamic> _properties;
  @override
  @JsonKey()
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  String toString() {
    return 'TimelineNode(id: $id, chapterId: $chapterId, event: $event, timeline: $timeline, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.timeline, timeline) ||
                other.timeline == timeline) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, chapterId, event, timeline,
      const DeepCollectionEquality().hash(_properties));

  /// Create a copy of TimelineNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineNodeImplCopyWith<_$TimelineNodeImpl> get copyWith =>
      __$$TimelineNodeImplCopyWithImpl<_$TimelineNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineNodeImplToJson(
      this,
    );
  }
}

abstract class _TimelineNode implements TimelineNode {
  const factory _TimelineNode(
      {required final String id,
      required final String chapterId,
      required final String event,
      final String timeline,
      final Map<String, dynamic> properties}) = _$TimelineNodeImpl;

  factory _TimelineNode.fromJson(Map<String, dynamic> json) =
      _$TimelineNodeImpl.fromJson;

  @override
  String get id;
  @override
  String get chapterId;
  @override
  String get event;
  @override
  String get timeline;
  @override
  Map<String, dynamic> get properties;

  /// Create a copy of TimelineNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineNodeImplCopyWith<_$TimelineNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineEdge _$TimelineEdgeFromJson(Map<String, dynamic> json) {
  return _TimelineEdge.fromJson(json);
}

/// @nodoc
mixin _$TimelineEdge {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  /// Serializes this TimelineEdge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineEdgeCopyWith<TimelineEdge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineEdgeCopyWith<$Res> {
  factory $TimelineEdgeCopyWith(
          TimelineEdge value, $Res Function(TimelineEdge) then) =
      _$TimelineEdgeCopyWithImpl<$Res, TimelineEdge>;
  @useResult
  $Res call({String from, String to, String label});
}

/// @nodoc
class _$TimelineEdgeCopyWithImpl<$Res, $Val extends TimelineEdge>
    implements $TimelineEdgeCopyWith<$Res> {
  _$TimelineEdgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelineEdgeImplCopyWith<$Res>
    implements $TimelineEdgeCopyWith<$Res> {
  factory _$$TimelineEdgeImplCopyWith(
          _$TimelineEdgeImpl value, $Res Function(_$TimelineEdgeImpl) then) =
      __$$TimelineEdgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String from, String to, String label});
}

/// @nodoc
class __$$TimelineEdgeImplCopyWithImpl<$Res>
    extends _$TimelineEdgeCopyWithImpl<$Res, _$TimelineEdgeImpl>
    implements _$$TimelineEdgeImplCopyWith<$Res> {
  __$$TimelineEdgeImplCopyWithImpl(
      _$TimelineEdgeImpl _value, $Res Function(_$TimelineEdgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimelineEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? label = null,
  }) {
    return _then(_$TimelineEdgeImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineEdgeImpl implements _TimelineEdge {
  const _$TimelineEdgeImpl(
      {required this.from, required this.to, this.label = ''});

  factory _$TimelineEdgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineEdgeImplFromJson(json);

  @override
  final String from;
  @override
  final String to;
  @override
  @JsonKey()
  final String label;

  @override
  String toString() {
    return 'TimelineEdge(from: $from, to: $to, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineEdgeImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, from, to, label);

  /// Create a copy of TimelineEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineEdgeImplCopyWith<_$TimelineEdgeImpl> get copyWith =>
      __$$TimelineEdgeImplCopyWithImpl<_$TimelineEdgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineEdgeImplToJson(
      this,
    );
  }
}

abstract class _TimelineEdge implements TimelineEdge {
  const factory _TimelineEdge(
      {required final String from,
      required final String to,
      final String label}) = _$TimelineEdgeImpl;

  factory _TimelineEdge.fromJson(Map<String, dynamic> json) =
      _$TimelineEdgeImpl.fromJson;

  @override
  String get from;
  @override
  String get to;
  @override
  String get label;

  /// Create a copy of TimelineEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineEdgeImplCopyWith<_$TimelineEdgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WritingStyleGuide _$WritingStyleGuideFromJson(Map<String, dynamic> json) {
  return _WritingStyleGuide.fromJson(json);
}

/// @nodoc
mixin _$WritingStyleGuide {
  WritingStyle get dominantStyle => throw _privateConstructorUsedError;
  List<WritingStyle> get chapterStyles => throw _privateConstructorUsedError;
  Map<String, dynamic> get styleEvolution => throw _privateConstructorUsedError;

  /// Serializes this WritingStyleGuide to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WritingStyleGuide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WritingStyleGuideCopyWith<WritingStyleGuide> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WritingStyleGuideCopyWith<$Res> {
  factory $WritingStyleGuideCopyWith(
          WritingStyleGuide value, $Res Function(WritingStyleGuide) then) =
      _$WritingStyleGuideCopyWithImpl<$Res, WritingStyleGuide>;
  @useResult
  $Res call(
      {WritingStyle dominantStyle,
      List<WritingStyle> chapterStyles,
      Map<String, dynamic> styleEvolution});

  $WritingStyleCopyWith<$Res> get dominantStyle;
}

/// @nodoc
class _$WritingStyleGuideCopyWithImpl<$Res, $Val extends WritingStyleGuide>
    implements $WritingStyleGuideCopyWith<$Res> {
  _$WritingStyleGuideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WritingStyleGuide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dominantStyle = null,
    Object? chapterStyles = null,
    Object? styleEvolution = null,
  }) {
    return _then(_value.copyWith(
      dominantStyle: null == dominantStyle
          ? _value.dominantStyle
          : dominantStyle // ignore: cast_nullable_to_non_nullable
              as WritingStyle,
      chapterStyles: null == chapterStyles
          ? _value.chapterStyles
          : chapterStyles // ignore: cast_nullable_to_non_nullable
              as List<WritingStyle>,
      styleEvolution: null == styleEvolution
          ? _value.styleEvolution
          : styleEvolution // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  /// Create a copy of WritingStyleGuide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WritingStyleCopyWith<$Res> get dominantStyle {
    return $WritingStyleCopyWith<$Res>(_value.dominantStyle, (value) {
      return _then(_value.copyWith(dominantStyle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WritingStyleGuideImplCopyWith<$Res>
    implements $WritingStyleGuideCopyWith<$Res> {
  factory _$$WritingStyleGuideImplCopyWith(_$WritingStyleGuideImpl value,
          $Res Function(_$WritingStyleGuideImpl) then) =
      __$$WritingStyleGuideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WritingStyle dominantStyle,
      List<WritingStyle> chapterStyles,
      Map<String, dynamic> styleEvolution});

  @override
  $WritingStyleCopyWith<$Res> get dominantStyle;
}

/// @nodoc
class __$$WritingStyleGuideImplCopyWithImpl<$Res>
    extends _$WritingStyleGuideCopyWithImpl<$Res, _$WritingStyleGuideImpl>
    implements _$$WritingStyleGuideImplCopyWith<$Res> {
  __$$WritingStyleGuideImplCopyWithImpl(_$WritingStyleGuideImpl _value,
      $Res Function(_$WritingStyleGuideImpl) _then)
      : super(_value, _then);

  /// Create a copy of WritingStyleGuide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dominantStyle = null,
    Object? chapterStyles = null,
    Object? styleEvolution = null,
  }) {
    return _then(_$WritingStyleGuideImpl(
      dominantStyle: null == dominantStyle
          ? _value.dominantStyle
          : dominantStyle // ignore: cast_nullable_to_non_nullable
              as WritingStyle,
      chapterStyles: null == chapterStyles
          ? _value._chapterStyles
          : chapterStyles // ignore: cast_nullable_to_non_nullable
              as List<WritingStyle>,
      styleEvolution: null == styleEvolution
          ? _value._styleEvolution
          : styleEvolution // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WritingStyleGuideImpl implements _WritingStyleGuide {
  const _$WritingStyleGuideImpl(
      {required this.dominantStyle,
      final List<WritingStyle> chapterStyles = const [],
      final Map<String, dynamic> styleEvolution = const {}})
      : _chapterStyles = chapterStyles,
        _styleEvolution = styleEvolution;

  factory _$WritingStyleGuideImpl.fromJson(Map<String, dynamic> json) =>
      _$$WritingStyleGuideImplFromJson(json);

  @override
  final WritingStyle dominantStyle;
  final List<WritingStyle> _chapterStyles;
  @override
  @JsonKey()
  List<WritingStyle> get chapterStyles {
    if (_chapterStyles is EqualUnmodifiableListView) return _chapterStyles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chapterStyles);
  }

  final Map<String, dynamic> _styleEvolution;
  @override
  @JsonKey()
  Map<String, dynamic> get styleEvolution {
    if (_styleEvolution is EqualUnmodifiableMapView) return _styleEvolution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_styleEvolution);
  }

  @override
  String toString() {
    return 'WritingStyleGuide(dominantStyle: $dominantStyle, chapterStyles: $chapterStyles, styleEvolution: $styleEvolution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WritingStyleGuideImpl &&
            (identical(other.dominantStyle, dominantStyle) ||
                other.dominantStyle == dominantStyle) &&
            const DeepCollectionEquality()
                .equals(other._chapterStyles, _chapterStyles) &&
            const DeepCollectionEquality()
                .equals(other._styleEvolution, _styleEvolution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dominantStyle,
      const DeepCollectionEquality().hash(_chapterStyles),
      const DeepCollectionEquality().hash(_styleEvolution));

  /// Create a copy of WritingStyleGuide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WritingStyleGuideImplCopyWith<_$WritingStyleGuideImpl> get copyWith =>
      __$$WritingStyleGuideImplCopyWithImpl<_$WritingStyleGuideImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WritingStyleGuideImplToJson(
      this,
    );
  }
}

abstract class _WritingStyleGuide implements WritingStyleGuide {
  const factory _WritingStyleGuide(
      {required final WritingStyle dominantStyle,
      final List<WritingStyle> chapterStyles,
      final Map<String, dynamic> styleEvolution}) = _$WritingStyleGuideImpl;

  factory _WritingStyleGuide.fromJson(Map<String, dynamic> json) =
      _$WritingStyleGuideImpl.fromJson;

  @override
  WritingStyle get dominantStyle;
  @override
  List<WritingStyle> get chapterStyles;
  @override
  Map<String, dynamic> get styleEvolution;

  /// Create a copy of WritingStyleGuide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WritingStyleGuideImplCopyWith<_$WritingStyleGuideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReverseDependency _$ReverseDependencyFromJson(Map<String, dynamic> json) {
  return _ReverseDependency.fromJson(json);
}

/// @nodoc
mixin _$ReverseDependency {
  String get chapterId => throw _privateConstructorUsedError;
  List<String> get dependsOn => throw _privateConstructorUsedError;
  List<String> get affectsChapters => throw _privateConstructorUsedError;

  /// Serializes this ReverseDependency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReverseDependency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReverseDependencyCopyWith<ReverseDependency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReverseDependencyCopyWith<$Res> {
  factory $ReverseDependencyCopyWith(
          ReverseDependency value, $Res Function(ReverseDependency) then) =
      _$ReverseDependencyCopyWithImpl<$Res, ReverseDependency>;
  @useResult
  $Res call(
      {String chapterId, List<String> dependsOn, List<String> affectsChapters});
}

/// @nodoc
class _$ReverseDependencyCopyWithImpl<$Res, $Val extends ReverseDependency>
    implements $ReverseDependencyCopyWith<$Res> {
  _$ReverseDependencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReverseDependency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? dependsOn = null,
    Object? affectsChapters = null,
  }) {
    return _then(_value.copyWith(
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      dependsOn: null == dependsOn
          ? _value.dependsOn
          : dependsOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      affectsChapters: null == affectsChapters
          ? _value.affectsChapters
          : affectsChapters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReverseDependencyImplCopyWith<$Res>
    implements $ReverseDependencyCopyWith<$Res> {
  factory _$$ReverseDependencyImplCopyWith(_$ReverseDependencyImpl value,
          $Res Function(_$ReverseDependencyImpl) then) =
      __$$ReverseDependencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String chapterId, List<String> dependsOn, List<String> affectsChapters});
}

/// @nodoc
class __$$ReverseDependencyImplCopyWithImpl<$Res>
    extends _$ReverseDependencyCopyWithImpl<$Res, _$ReverseDependencyImpl>
    implements _$$ReverseDependencyImplCopyWith<$Res> {
  __$$ReverseDependencyImplCopyWithImpl(_$ReverseDependencyImpl _value,
      $Res Function(_$ReverseDependencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReverseDependency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? dependsOn = null,
    Object? affectsChapters = null,
  }) {
    return _then(_$ReverseDependencyImpl(
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      dependsOn: null == dependsOn
          ? _value._dependsOn
          : dependsOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      affectsChapters: null == affectsChapters
          ? _value._affectsChapters
          : affectsChapters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReverseDependencyImpl implements _ReverseDependency {
  const _$ReverseDependencyImpl(
      {required this.chapterId,
      final List<String> dependsOn = const [],
      final List<String> affectsChapters = const []})
      : _dependsOn = dependsOn,
        _affectsChapters = affectsChapters;

  factory _$ReverseDependencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReverseDependencyImplFromJson(json);

  @override
  final String chapterId;
  final List<String> _dependsOn;
  @override
  @JsonKey()
  List<String> get dependsOn {
    if (_dependsOn is EqualUnmodifiableListView) return _dependsOn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dependsOn);
  }

  final List<String> _affectsChapters;
  @override
  @JsonKey()
  List<String> get affectsChapters {
    if (_affectsChapters is EqualUnmodifiableListView) return _affectsChapters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_affectsChapters);
  }

  @override
  String toString() {
    return 'ReverseDependency(chapterId: $chapterId, dependsOn: $dependsOn, affectsChapters: $affectsChapters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReverseDependencyImpl &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            const DeepCollectionEquality()
                .equals(other._dependsOn, _dependsOn) &&
            const DeepCollectionEquality()
                .equals(other._affectsChapters, _affectsChapters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      chapterId,
      const DeepCollectionEquality().hash(_dependsOn),
      const DeepCollectionEquality().hash(_affectsChapters));

  /// Create a copy of ReverseDependency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReverseDependencyImplCopyWith<_$ReverseDependencyImpl> get copyWith =>
      __$$ReverseDependencyImplCopyWithImpl<_$ReverseDependencyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReverseDependencyImplToJson(
      this,
    );
  }
}

abstract class _ReverseDependency implements ReverseDependency {
  const factory _ReverseDependency(
      {required final String chapterId,
      final List<String> dependsOn,
      final List<String> affectsChapters}) = _$ReverseDependencyImpl;

  factory _ReverseDependency.fromJson(Map<String, dynamic> json) =
      _$ReverseDependencyImpl.fromJson;

  @override
  String get chapterId;
  @override
  List<String> get dependsOn;
  @override
  List<String> get affectsChapters;

  /// Create a copy of ReverseDependency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReverseDependencyImplCopyWith<_$ReverseDependencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
