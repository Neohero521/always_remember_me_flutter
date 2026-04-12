// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChapterGraph _$ChapterGraphFromJson(Map<String, dynamic> json) {
  return _ChapterGraph.fromJson(json);
}

/// @nodoc
mixin _$ChapterGraph {
  String get id => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChapterGraph to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterGraphCopyWith<ChapterGraph> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterGraphCopyWith<$Res> {
  factory $ChapterGraphCopyWith(
          ChapterGraph value, $Res Function(ChapterGraph) then) =
      _$ChapterGraphCopyWithImpl<$Res, ChapterGraph>;
  @useResult
  $Res call(
      {String id,
      String chapterId,
      String type,
      String data,
      DateTime createdAt});
}

/// @nodoc
class _$ChapterGraphCopyWithImpl<$Res, $Val extends ChapterGraph>
    implements $ChapterGraphCopyWith<$Res> {
  _$ChapterGraphCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? type = null,
    Object? data = null,
    Object? createdAt = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterGraphImplCopyWith<$Res>
    implements $ChapterGraphCopyWith<$Res> {
  factory _$$ChapterGraphImplCopyWith(
          _$ChapterGraphImpl value, $Res Function(_$ChapterGraphImpl) then) =
      __$$ChapterGraphImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chapterId,
      String type,
      String data,
      DateTime createdAt});
}

/// @nodoc
class __$$ChapterGraphImplCopyWithImpl<$Res>
    extends _$ChapterGraphCopyWithImpl<$Res, _$ChapterGraphImpl>
    implements _$$ChapterGraphImplCopyWith<$Res> {
  __$$ChapterGraphImplCopyWithImpl(
      _$ChapterGraphImpl _value, $Res Function(_$ChapterGraphImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChapterGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? type = null,
    Object? data = null,
    Object? createdAt = null,
  }) {
    return _then(_$ChapterGraphImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterGraphImpl implements _ChapterGraph {
  const _$ChapterGraphImpl(
      {required this.id,
      required this.chapterId,
      this.type = 'characterRelationship',
      this.data = '{}',
      required this.createdAt});

  factory _$ChapterGraphImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterGraphImplFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String data;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChapterGraph(id: $id, chapterId: $chapterId, type: $type, data: $data, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterGraphImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, chapterId, type, data, createdAt);

  /// Create a copy of ChapterGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterGraphImplCopyWith<_$ChapterGraphImpl> get copyWith =>
      __$$ChapterGraphImplCopyWithImpl<_$ChapterGraphImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterGraphImplToJson(
      this,
    );
  }
}

abstract class _ChapterGraph implements ChapterGraph {
  const factory _ChapterGraph(
      {required final String id,
      required final String chapterId,
      final String type,
      final String data,
      required final DateTime createdAt}) = _$ChapterGraphImpl;

  factory _ChapterGraph.fromJson(Map<String, dynamic> json) =
      _$ChapterGraphImpl.fromJson;

  @override
  String get id;
  @override
  String get chapterId;
  @override
  String get type;
  @override
  String get data;
  @override
  DateTime get createdAt;

  /// Create a copy of ChapterGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterGraphImplCopyWith<_$ChapterGraphImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphNode _$GraphNodeFromJson(Map<String, dynamic> json) {
  return _GraphNode.fromJson(json);
}

/// @nodoc
mixin _$GraphNode {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic>? get properties => throw _privateConstructorUsedError;

  /// Serializes this GraphNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphNodeCopyWith<GraphNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphNodeCopyWith<$Res> {
  factory $GraphNodeCopyWith(GraphNode value, $Res Function(GraphNode) then) =
      _$GraphNodeCopyWithImpl<$Res, GraphNode>;
  @useResult
  $Res call(
      {String id, String label, String type, Map<String, dynamic>? properties});
}

/// @nodoc
class _$GraphNodeCopyWithImpl<$Res, $Val extends GraphNode>
    implements $GraphNodeCopyWith<$Res> {
  _$GraphNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? type = null,
    Object? properties = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: freezed == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphNodeImplCopyWith<$Res>
    implements $GraphNodeCopyWith<$Res> {
  factory _$$GraphNodeImplCopyWith(
          _$GraphNodeImpl value, $Res Function(_$GraphNodeImpl) then) =
      __$$GraphNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String label, String type, Map<String, dynamic>? properties});
}

/// @nodoc
class __$$GraphNodeImplCopyWithImpl<$Res>
    extends _$GraphNodeCopyWithImpl<$Res, _$GraphNodeImpl>
    implements _$$GraphNodeImplCopyWith<$Res> {
  __$$GraphNodeImplCopyWithImpl(
      _$GraphNodeImpl _value, $Res Function(_$GraphNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? type = null,
    Object? properties = freezed,
  }) {
    return _then(_$GraphNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: freezed == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphNodeImpl implements _GraphNode {
  const _$GraphNodeImpl(
      {required this.id,
      required this.label,
      this.type = 'node',
      final Map<String, dynamic>? properties})
      : _properties = properties;

  factory _$GraphNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphNodeImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  @JsonKey()
  final String type;
  final Map<String, dynamic>? _properties;
  @override
  Map<String, dynamic>? get properties {
    final value = _properties;
    if (value == null) return null;
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GraphNode(id: $id, label: $label, type: $type, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, type,
      const DeepCollectionEquality().hash(_properties));

  /// Create a copy of GraphNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphNodeImplCopyWith<_$GraphNodeImpl> get copyWith =>
      __$$GraphNodeImplCopyWithImpl<_$GraphNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphNodeImplToJson(
      this,
    );
  }
}

abstract class _GraphNode implements GraphNode {
  const factory _GraphNode(
      {required final String id,
      required final String label,
      final String type,
      final Map<String, dynamic>? properties}) = _$GraphNodeImpl;

  factory _GraphNode.fromJson(Map<String, dynamic> json) =
      _$GraphNodeImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get type;
  @override
  Map<String, dynamic>? get properties;

  /// Create a copy of GraphNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphNodeImplCopyWith<_$GraphNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphEdge _$GraphEdgeFromJson(Map<String, dynamic> json) {
  return _GraphEdge.fromJson(json);
}

/// @nodoc
mixin _$GraphEdge {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;

  /// Serializes this GraphEdge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphEdgeCopyWith<GraphEdge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphEdgeCopyWith<$Res> {
  factory $GraphEdgeCopyWith(GraphEdge value, $Res Function(GraphEdge) then) =
      _$GraphEdgeCopyWithImpl<$Res, GraphEdge>;
  @useResult
  $Res call({String from, String to, String? label, double weight});
}

/// @nodoc
class _$GraphEdgeCopyWithImpl<$Res, $Val extends GraphEdge>
    implements $GraphEdgeCopyWith<$Res> {
  _$GraphEdgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? label = freezed,
    Object? weight = null,
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
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphEdgeImplCopyWith<$Res>
    implements $GraphEdgeCopyWith<$Res> {
  factory _$$GraphEdgeImplCopyWith(
          _$GraphEdgeImpl value, $Res Function(_$GraphEdgeImpl) then) =
      __$$GraphEdgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String from, String to, String? label, double weight});
}

/// @nodoc
class __$$GraphEdgeImplCopyWithImpl<$Res>
    extends _$GraphEdgeCopyWithImpl<$Res, _$GraphEdgeImpl>
    implements _$$GraphEdgeImplCopyWith<$Res> {
  __$$GraphEdgeImplCopyWithImpl(
      _$GraphEdgeImpl _value, $Res Function(_$GraphEdgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? label = freezed,
    Object? weight = null,
  }) {
    return _then(_$GraphEdgeImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphEdgeImpl implements _GraphEdge {
  const _$GraphEdgeImpl(
      {required this.from, required this.to, this.label, this.weight = 1.0});

  factory _$GraphEdgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphEdgeImplFromJson(json);

  @override
  final String from;
  @override
  final String to;
  @override
  final String? label;
  @override
  @JsonKey()
  final double weight;

  @override
  String toString() {
    return 'GraphEdge(from: $from, to: $to, label: $label, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphEdgeImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, from, to, label, weight);

  /// Create a copy of GraphEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphEdgeImplCopyWith<_$GraphEdgeImpl> get copyWith =>
      __$$GraphEdgeImplCopyWithImpl<_$GraphEdgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphEdgeImplToJson(
      this,
    );
  }
}

abstract class _GraphEdge implements GraphEdge {
  const factory _GraphEdge(
      {required final String from,
      required final String to,
      final String? label,
      final double weight}) = _$GraphEdgeImpl;

  factory _GraphEdge.fromJson(Map<String, dynamic> json) =
      _$GraphEdgeImpl.fromJson;

  @override
  String get from;
  @override
  String get to;
  @override
  String? get label;
  @override
  double get weight;

  /// Create a copy of GraphEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphEdgeImplCopyWith<_$GraphEdgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphData _$GraphDataFromJson(Map<String, dynamic> json) {
  return _GraphData.fromJson(json);
}

/// @nodoc
mixin _$GraphData {
  List<GraphNode> get nodes => throw _privateConstructorUsedError;
  List<GraphEdge> get edges => throw _privateConstructorUsedError;

  /// Serializes this GraphData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphDataCopyWith<GraphData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphDataCopyWith<$Res> {
  factory $GraphDataCopyWith(GraphData value, $Res Function(GraphData) then) =
      _$GraphDataCopyWithImpl<$Res, GraphData>;
  @useResult
  $Res call({List<GraphNode> nodes, List<GraphEdge> edges});
}

/// @nodoc
class _$GraphDataCopyWithImpl<$Res, $Val extends GraphData>
    implements $GraphDataCopyWith<$Res> {
  _$GraphDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphData
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
              as List<GraphNode>,
      edges: null == edges
          ? _value.edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<GraphEdge>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphDataImplCopyWith<$Res>
    implements $GraphDataCopyWith<$Res> {
  factory _$$GraphDataImplCopyWith(
          _$GraphDataImpl value, $Res Function(_$GraphDataImpl) then) =
      __$$GraphDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GraphNode> nodes, List<GraphEdge> edges});
}

/// @nodoc
class __$$GraphDataImplCopyWithImpl<$Res>
    extends _$GraphDataCopyWithImpl<$Res, _$GraphDataImpl>
    implements _$$GraphDataImplCopyWith<$Res> {
  __$$GraphDataImplCopyWithImpl(
      _$GraphDataImpl _value, $Res Function(_$GraphDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
  }) {
    return _then(_$GraphDataImpl(
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<GraphNode>,
      edges: null == edges
          ? _value._edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<GraphEdge>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphDataImpl implements _GraphData {
  const _$GraphDataImpl(
      {final List<GraphNode> nodes = const [],
      final List<GraphEdge> edges = const []})
      : _nodes = nodes,
        _edges = edges;

  factory _$GraphDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphDataImplFromJson(json);

  final List<GraphNode> _nodes;
  @override
  @JsonKey()
  List<GraphNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<GraphEdge> _edges;
  @override
  @JsonKey()
  List<GraphEdge> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  @override
  String toString() {
    return 'GraphData(nodes: $nodes, edges: $edges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphDataImpl &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_edges));

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphDataImplCopyWith<_$GraphDataImpl> get copyWith =>
      __$$GraphDataImplCopyWithImpl<_$GraphDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphDataImplToJson(
      this,
    );
  }
}

abstract class _GraphData implements GraphData {
  const factory _GraphData(
      {final List<GraphNode> nodes,
      final List<GraphEdge> edges}) = _$GraphDataImpl;

  factory _GraphData.fromJson(Map<String, dynamic> json) =
      _$GraphDataImpl.fromJson;

  @override
  List<GraphNode> get nodes;
  @override
  List<GraphEdge> get edges;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphDataImplCopyWith<_$GraphDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
