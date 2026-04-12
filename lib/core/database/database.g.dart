// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NovelsTable extends Novels with TableInfo<$NovelsTable, NovelEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _introductionMeta =
      const VerificationMeta('introduction');
  @override
  late final GeneratedColumn<String> introduction = GeneratedColumn<String>(
      'introduction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, author, cover, introduction, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novels';
  @override
  VerificationContext validateIntegrity(Insertable<NovelEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('introduction')) {
      context.handle(
          _introductionMeta,
          introduction.isAcceptableOrUnknown(
              data['introduction']!, _introductionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NovelEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NovelEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      introduction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}introduction'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NovelsTable createAlias(String alias) {
    return $NovelsTable(attachedDatabase, alias);
  }
}

class NovelEntity extends DataClass implements Insertable<NovelEntity> {
  final String id;
  final String title;
  final String author;
  final String? cover;
  final String introduction;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NovelEntity(
      {required this.id,
      required this.title,
      required this.author,
      this.cover,
      required this.introduction,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    map['introduction'] = Variable<String>(introduction);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NovelsCompanion toCompanion(bool nullToAbsent) {
    return NovelsCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      introduction: Value(introduction),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NovelEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NovelEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      cover: serializer.fromJson<String?>(json['cover']),
      introduction: serializer.fromJson<String>(json['introduction']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'cover': serializer.toJson<String?>(cover),
      'introduction': serializer.toJson<String>(introduction),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NovelEntity copyWith(
          {String? id,
          String? title,
          String? author,
          Value<String?> cover = const Value.absent(),
          String? introduction,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      NovelEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        cover: cover.present ? cover.value : this.cover,
        introduction: introduction ?? this.introduction,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NovelEntity copyWithCompanion(NovelsCompanion data) {
    return NovelEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      cover: data.cover.present ? data.cover.value : this.cover,
      introduction: data.introduction.present
          ? data.introduction.value
          : this.introduction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NovelEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('cover: $cover, ')
          ..write('introduction: $introduction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, author, cover, introduction, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NovelEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.cover == this.cover &&
          other.introduction == this.introduction &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NovelsCompanion extends UpdateCompanion<NovelEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> author;
  final Value<String?> cover;
  final Value<String> introduction;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NovelsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.cover = const Value.absent(),
    this.introduction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NovelsCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    this.cover = const Value.absent(),
    this.introduction = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NovelEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? cover,
    Expression<String>? introduction,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (cover != null) 'cover': cover,
      if (introduction != null) 'introduction': introduction,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NovelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? author,
      Value<String?>? cover,
      Value<String>? introduction,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return NovelsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      cover: cover ?? this.cover,
      introduction: introduction ?? this.introduction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (introduction.present) {
      map['introduction'] = Variable<String>(introduction.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NovelsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('cover: $cover, ')
          ..write('introduction: $introduction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters
    with TableInfo<$ChaptersTable, ChapterEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _novelIdMeta =
      const VerificationMeta('novelId');
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
      'novel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _graphIdMeta =
      const VerificationMeta('graphId');
  @override
  late final GeneratedColumn<String> graphId = GeneratedColumn<String>(
      'graph_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _wordCountMeta =
      const VerificationMeta('wordCount');
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
      'word_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, novelId, number, title, content, graphId, wordCount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(Insertable<ChapterEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('novel_id')) {
      context.handle(_novelIdMeta,
          novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta));
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('graph_id')) {
      context.handle(_graphIdMeta,
          graphId.isAcceptableOrUnknown(data['graph_id']!, _graphIdMeta));
    }
    if (data.containsKey('word_count')) {
      context.handle(_wordCountMeta,
          wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChapterEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      novelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}novel_id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      graphId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}graph_id']),
      wordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class ChapterEntity extends DataClass implements Insertable<ChapterEntity> {
  final String id;
  final String novelId;
  final int number;
  final String title;
  final String content;
  final String? graphId;
  final int wordCount;
  final DateTime createdAt;
  const ChapterEntity(
      {required this.id,
      required this.novelId,
      required this.number,
      required this.title,
      required this.content,
      this.graphId,
      required this.wordCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['novel_id'] = Variable<String>(novelId);
    map['number'] = Variable<int>(number);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || graphId != null) {
      map['graph_id'] = Variable<String>(graphId);
    }
    map['word_count'] = Variable<int>(wordCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      novelId: Value(novelId),
      number: Value(number),
      title: Value(title),
      content: Value(content),
      graphId: graphId == null && nullToAbsent
          ? const Value.absent()
          : Value(graphId),
      wordCount: Value(wordCount),
      createdAt: Value(createdAt),
    );
  }

  factory ChapterEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterEntity(
      id: serializer.fromJson<String>(json['id']),
      novelId: serializer.fromJson<String>(json['novelId']),
      number: serializer.fromJson<int>(json['number']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      graphId: serializer.fromJson<String?>(json['graphId']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'novelId': serializer.toJson<String>(novelId),
      'number': serializer.toJson<int>(number),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'graphId': serializer.toJson<String?>(graphId),
      'wordCount': serializer.toJson<int>(wordCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChapterEntity copyWith(
          {String? id,
          String? novelId,
          int? number,
          String? title,
          String? content,
          Value<String?> graphId = const Value.absent(),
          int? wordCount,
          DateTime? createdAt}) =>
      ChapterEntity(
        id: id ?? this.id,
        novelId: novelId ?? this.novelId,
        number: number ?? this.number,
        title: title ?? this.title,
        content: content ?? this.content,
        graphId: graphId.present ? graphId.value : this.graphId,
        wordCount: wordCount ?? this.wordCount,
        createdAt: createdAt ?? this.createdAt,
      );
  ChapterEntity copyWithCompanion(ChaptersCompanion data) {
    return ChapterEntity(
      id: data.id.present ? data.id.value : this.id,
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      number: data.number.present ? data.number.value : this.number,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      graphId: data.graphId.present ? data.graphId.value : this.graphId,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterEntity(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('graphId: $graphId, ')
          ..write('wordCount: $wordCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, novelId, number, title, content, graphId, wordCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterEntity &&
          other.id == this.id &&
          other.novelId == this.novelId &&
          other.number == this.number &&
          other.title == this.title &&
          other.content == this.content &&
          other.graphId == this.graphId &&
          other.wordCount == this.wordCount &&
          other.createdAt == this.createdAt);
}

class ChaptersCompanion extends UpdateCompanion<ChapterEntity> {
  final Value<String> id;
  final Value<String> novelId;
  final Value<int> number;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> graphId;
  final Value<int> wordCount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.novelId = const Value.absent(),
    this.number = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.graphId = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String novelId,
    required int number,
    required String title,
    this.content = const Value.absent(),
    this.graphId = const Value.absent(),
    this.wordCount = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        novelId = Value(novelId),
        number = Value(number),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<ChapterEntity> custom({
    Expression<String>? id,
    Expression<String>? novelId,
    Expression<int>? number,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? graphId,
    Expression<int>? wordCount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (novelId != null) 'novel_id': novelId,
      if (number != null) 'number': number,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (graphId != null) 'graph_id': graphId,
      if (wordCount != null) 'word_count': wordCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? novelId,
      Value<int>? number,
      Value<String>? title,
      Value<String>? content,
      Value<String?>? graphId,
      Value<int>? wordCount,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      number: number ?? this.number,
      title: title ?? this.title,
      content: content ?? this.content,
      graphId: graphId ?? this.graphId,
      wordCount: wordCount ?? this.wordCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (graphId.present) {
      map['graph_id'] = Variable<String>(graphId.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('graphId: $graphId, ')
          ..write('wordCount: $wordCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChapterGraphsTable extends ChapterGraphs
    with TableInfo<$ChapterGraphsTable, ChapterGraphEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterGraphsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('characterRelationship'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, chapterId, type, data, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapter_graphs';
  @override
  VerificationContext validateIntegrity(Insertable<ChapterGraphEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChapterGraphEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterGraphEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChapterGraphsTable createAlias(String alias) {
    return $ChapterGraphsTable(attachedDatabase, alias);
  }
}

class ChapterGraphEntity extends DataClass
    implements Insertable<ChapterGraphEntity> {
  final String id;
  final String chapterId;
  final String type;
  final String data;
  final DateTime createdAt;
  const ChapterGraphEntity(
      {required this.id,
      required this.chapterId,
      required this.type,
      required this.data,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['type'] = Variable<String>(type);
    map['data'] = Variable<String>(data);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChapterGraphsCompanion toCompanion(bool nullToAbsent) {
    return ChapterGraphsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      type: Value(type),
      data: Value(data),
      createdAt: Value(createdAt),
    );
  }

  factory ChapterGraphEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterGraphEntity(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      type: serializer.fromJson<String>(json['type']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'type': serializer.toJson<String>(type),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChapterGraphEntity copyWith(
          {String? id,
          String? chapterId,
          String? type,
          String? data,
          DateTime? createdAt}) =>
      ChapterGraphEntity(
        id: id ?? this.id,
        chapterId: chapterId ?? this.chapterId,
        type: type ?? this.type,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
      );
  ChapterGraphEntity copyWithCompanion(ChapterGraphsCompanion data) {
    return ChapterGraphEntity(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterGraphEntity(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chapterId, type, data, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterGraphEntity &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.type == this.type &&
          other.data == this.data &&
          other.createdAt == this.createdAt);
}

class ChapterGraphsCompanion extends UpdateCompanion<ChapterGraphEntity> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> type;
  final Value<String> data;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChapterGraphsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChapterGraphsCompanion.insert({
    required String id,
    required String chapterId,
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chapterId = Value(chapterId),
        createdAt = Value(createdAt);
  static Insertable<ChapterGraphEntity> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? type,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChapterGraphsCompanion copyWith(
      {Value<String>? id,
      Value<String>? chapterId,
      Value<String>? type,
      Value<String>? data,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ChapterGraphsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterGraphsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdvancedGraphsTable extends AdvancedGraphs
    with TableInfo<$AdvancedGraphsTable, AdvancedGraphEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdvancedGraphsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _graphJsonMeta =
      const VerificationMeta('graphJson');
  @override
  late final GeneratedColumn<String> graphJson = GeneratedColumn<String>(
      'graph_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, chapterId, graphJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'advanced_graphs';
  @override
  VerificationContext validateIntegrity(
      Insertable<AdvancedGraphEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('graph_json')) {
      context.handle(_graphJsonMeta,
          graphJson.isAcceptableOrUnknown(data['graph_json']!, _graphJsonMeta));
    } else if (isInserting) {
      context.missing(_graphJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdvancedGraphEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdvancedGraphEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      graphJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}graph_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AdvancedGraphsTable createAlias(String alias) {
    return $AdvancedGraphsTable(attachedDatabase, alias);
  }
}

class AdvancedGraphEntity extends DataClass
    implements Insertable<AdvancedGraphEntity> {
  final String id;
  final String chapterId;
  final String graphJson;
  final DateTime createdAt;
  const AdvancedGraphEntity(
      {required this.id,
      required this.chapterId,
      required this.graphJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['graph_json'] = Variable<String>(graphJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AdvancedGraphsCompanion toCompanion(bool nullToAbsent) {
    return AdvancedGraphsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      graphJson: Value(graphJson),
      createdAt: Value(createdAt),
    );
  }

  factory AdvancedGraphEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdvancedGraphEntity(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      graphJson: serializer.fromJson<String>(json['graphJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'graphJson': serializer.toJson<String>(graphJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AdvancedGraphEntity copyWith(
          {String? id,
          String? chapterId,
          String? graphJson,
          DateTime? createdAt}) =>
      AdvancedGraphEntity(
        id: id ?? this.id,
        chapterId: chapterId ?? this.chapterId,
        graphJson: graphJson ?? this.graphJson,
        createdAt: createdAt ?? this.createdAt,
      );
  AdvancedGraphEntity copyWithCompanion(AdvancedGraphsCompanion data) {
    return AdvancedGraphEntity(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      graphJson: data.graphJson.present ? data.graphJson.value : this.graphJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedGraphEntity(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('graphJson: $graphJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chapterId, graphJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdvancedGraphEntity &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.graphJson == this.graphJson &&
          other.createdAt == this.createdAt);
}

class AdvancedGraphsCompanion extends UpdateCompanion<AdvancedGraphEntity> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> graphJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AdvancedGraphsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.graphJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdvancedGraphsCompanion.insert({
    required String id,
    required String chapterId,
    required String graphJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chapterId = Value(chapterId),
        graphJson = Value(graphJson),
        createdAt = Value(createdAt);
  static Insertable<AdvancedGraphEntity> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? graphJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (graphJson != null) 'graph_json': graphJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdvancedGraphsCompanion copyWith(
      {Value<String>? id,
      Value<String>? chapterId,
      Value<String>? graphJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AdvancedGraphsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      graphJson: graphJson ?? this.graphJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (graphJson.present) {
      map['graph_json'] = Variable<String>(graphJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedGraphsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('graphJson: $graphJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterProfilesTable extends CharacterProfiles
    with TableInfo<$CharacterProfilesTable, CharacterProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _novelIdMeta =
      const VerificationMeta('novelId');
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
      'novel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _personalityMeta =
      const VerificationMeta('personality');
  @override
  late final GeneratedColumn<String> personality = GeneratedColumn<String>(
      'personality', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _redLinesMeta =
      const VerificationMeta('redLines');
  @override
  late final GeneratedColumn<String> redLines = GeneratedColumn<String>(
      'red_lines', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _backstoriesMeta =
      const VerificationMeta('backstories');
  @override
  late final GeneratedColumn<String> backstories = GeneratedColumn<String>(
      'backstories', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, novelId, name, alias, personality, redLines, backstories];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_profiles';
  @override
  VerificationContext validateIntegrity(
      Insertable<CharacterProfileEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('novel_id')) {
      context.handle(_novelIdMeta,
          novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta));
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    }
    if (data.containsKey('personality')) {
      context.handle(
          _personalityMeta,
          personality.isAcceptableOrUnknown(
              data['personality']!, _personalityMeta));
    }
    if (data.containsKey('red_lines')) {
      context.handle(_redLinesMeta,
          redLines.isAcceptableOrUnknown(data['red_lines']!, _redLinesMeta));
    }
    if (data.containsKey('backstories')) {
      context.handle(
          _backstoriesMeta,
          backstories.isAcceptableOrUnknown(
              data['backstories']!, _backstoriesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterProfileEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      novelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}novel_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
      personality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}personality'])!,
      redLines: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}red_lines'])!,
      backstories: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}backstories'])!,
    );
  }

  @override
  $CharacterProfilesTable createAlias(String alias) {
    return $CharacterProfilesTable(attachedDatabase, alias);
  }
}

class CharacterProfileEntity extends DataClass
    implements Insertable<CharacterProfileEntity> {
  final String id;
  final String novelId;
  final String name;
  final String alias;
  final String personality;
  final String redLines;
  final String backstories;
  const CharacterProfileEntity(
      {required this.id,
      required this.novelId,
      required this.name,
      required this.alias,
      required this.personality,
      required this.redLines,
      required this.backstories});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['novel_id'] = Variable<String>(novelId);
    map['name'] = Variable<String>(name);
    map['alias'] = Variable<String>(alias);
    map['personality'] = Variable<String>(personality);
    map['red_lines'] = Variable<String>(redLines);
    map['backstories'] = Variable<String>(backstories);
    return map;
  }

  CharacterProfilesCompanion toCompanion(bool nullToAbsent) {
    return CharacterProfilesCompanion(
      id: Value(id),
      novelId: Value(novelId),
      name: Value(name),
      alias: Value(alias),
      personality: Value(personality),
      redLines: Value(redLines),
      backstories: Value(backstories),
    );
  }

  factory CharacterProfileEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterProfileEntity(
      id: serializer.fromJson<String>(json['id']),
      novelId: serializer.fromJson<String>(json['novelId']),
      name: serializer.fromJson<String>(json['name']),
      alias: serializer.fromJson<String>(json['alias']),
      personality: serializer.fromJson<String>(json['personality']),
      redLines: serializer.fromJson<String>(json['redLines']),
      backstories: serializer.fromJson<String>(json['backstories']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'novelId': serializer.toJson<String>(novelId),
      'name': serializer.toJson<String>(name),
      'alias': serializer.toJson<String>(alias),
      'personality': serializer.toJson<String>(personality),
      'redLines': serializer.toJson<String>(redLines),
      'backstories': serializer.toJson<String>(backstories),
    };
  }

  CharacterProfileEntity copyWith(
          {String? id,
          String? novelId,
          String? name,
          String? alias,
          String? personality,
          String? redLines,
          String? backstories}) =>
      CharacterProfileEntity(
        id: id ?? this.id,
        novelId: novelId ?? this.novelId,
        name: name ?? this.name,
        alias: alias ?? this.alias,
        personality: personality ?? this.personality,
        redLines: redLines ?? this.redLines,
        backstories: backstories ?? this.backstories,
      );
  CharacterProfileEntity copyWithCompanion(CharacterProfilesCompanion data) {
    return CharacterProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      name: data.name.present ? data.name.value : this.name,
      alias: data.alias.present ? data.alias.value : this.alias,
      personality:
          data.personality.present ? data.personality.value : this.personality,
      redLines: data.redLines.present ? data.redLines.value : this.redLines,
      backstories:
          data.backstories.present ? data.backstories.value : this.backstories,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterProfileEntity(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('personality: $personality, ')
          ..write('redLines: $redLines, ')
          ..write('backstories: $backstories')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, novelId, name, alias, personality, redLines, backstories);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterProfileEntity &&
          other.id == this.id &&
          other.novelId == this.novelId &&
          other.name == this.name &&
          other.alias == this.alias &&
          other.personality == this.personality &&
          other.redLines == this.redLines &&
          other.backstories == this.backstories);
}

class CharacterProfilesCompanion
    extends UpdateCompanion<CharacterProfileEntity> {
  final Value<String> id;
  final Value<String> novelId;
  final Value<String> name;
  final Value<String> alias;
  final Value<String> personality;
  final Value<String> redLines;
  final Value<String> backstories;
  final Value<int> rowid;
  const CharacterProfilesCompanion({
    this.id = const Value.absent(),
    this.novelId = const Value.absent(),
    this.name = const Value.absent(),
    this.alias = const Value.absent(),
    this.personality = const Value.absent(),
    this.redLines = const Value.absent(),
    this.backstories = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterProfilesCompanion.insert({
    required String id,
    required String novelId,
    required String name,
    this.alias = const Value.absent(),
    this.personality = const Value.absent(),
    this.redLines = const Value.absent(),
    this.backstories = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        novelId = Value(novelId),
        name = Value(name);
  static Insertable<CharacterProfileEntity> custom({
    Expression<String>? id,
    Expression<String>? novelId,
    Expression<String>? name,
    Expression<String>? alias,
    Expression<String>? personality,
    Expression<String>? redLines,
    Expression<String>? backstories,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (novelId != null) 'novel_id': novelId,
      if (name != null) 'name': name,
      if (alias != null) 'alias': alias,
      if (personality != null) 'personality': personality,
      if (redLines != null) 'red_lines': redLines,
      if (backstories != null) 'backstories': backstories,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? novelId,
      Value<String>? name,
      Value<String>? alias,
      Value<String>? personality,
      Value<String>? redLines,
      Value<String>? backstories,
      Value<int>? rowid}) {
    return CharacterProfilesCompanion(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      personality: personality ?? this.personality,
      redLines: redLines ?? this.redLines,
      backstories: backstories ?? this.backstories,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (personality.present) {
      map['personality'] = Variable<String>(personality.value);
    }
    if (redLines.present) {
      map['red_lines'] = Variable<String>(redLines.value);
    }
    if (backstories.present) {
      map['backstories'] = Variable<String>(backstories.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterProfilesCompanion(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('personality: $personality, ')
          ..write('redLines: $redLines, ')
          ..write('backstories: $backstories, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NovelWorldSettingsTable extends NovelWorldSettings
    with TableInfo<$NovelWorldSettingsTable, NovelWorldSettingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelWorldSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _novelIdMeta =
      const VerificationMeta('novelId');
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
      'novel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eraMeta = const VerificationMeta('era');
  @override
  late final GeneratedColumn<String> era = GeneratedColumn<String>(
      'era', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _geographyMeta =
      const VerificationMeta('geography');
  @override
  late final GeneratedColumn<String> geography = GeneratedColumn<String>(
      'geography', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _powerSystemMeta =
      const VerificationMeta('powerSystem');
  @override
  late final GeneratedColumn<String> powerSystem = GeneratedColumn<String>(
      'power_system', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _societyMeta =
      const VerificationMeta('society');
  @override
  late final GeneratedColumn<String> society = GeneratedColumn<String>(
      'society', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _forbiddenRulesMeta =
      const VerificationMeta('forbiddenRules');
  @override
  late final GeneratedColumn<String> forbiddenRules = GeneratedColumn<String>(
      'forbidden_rules', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _foreshadowsMeta =
      const VerificationMeta('foreshadows');
  @override
  late final GeneratedColumn<String> foreshadows = GeneratedColumn<String>(
      'foreshadows', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        novelId,
        era,
        geography,
        powerSystem,
        society,
        forbiddenRules,
        foreshadows
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novel_world_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<NovelWorldSettingEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('novel_id')) {
      context.handle(_novelIdMeta,
          novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta));
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('era')) {
      context.handle(
          _eraMeta, era.isAcceptableOrUnknown(data['era']!, _eraMeta));
    }
    if (data.containsKey('geography')) {
      context.handle(_geographyMeta,
          geography.isAcceptableOrUnknown(data['geography']!, _geographyMeta));
    }
    if (data.containsKey('power_system')) {
      context.handle(
          _powerSystemMeta,
          powerSystem.isAcceptableOrUnknown(
              data['power_system']!, _powerSystemMeta));
    }
    if (data.containsKey('society')) {
      context.handle(_societyMeta,
          society.isAcceptableOrUnknown(data['society']!, _societyMeta));
    }
    if (data.containsKey('forbidden_rules')) {
      context.handle(
          _forbiddenRulesMeta,
          forbiddenRules.isAcceptableOrUnknown(
              data['forbidden_rules']!, _forbiddenRulesMeta));
    }
    if (data.containsKey('foreshadows')) {
      context.handle(
          _foreshadowsMeta,
          foreshadows.isAcceptableOrUnknown(
              data['foreshadows']!, _foreshadowsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NovelWorldSettingEntity map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NovelWorldSettingEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      novelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}novel_id'])!,
      era: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}era'])!,
      geography: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geography'])!,
      powerSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}power_system'])!,
      society: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}society'])!,
      forbiddenRules: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}forbidden_rules'])!,
      foreshadows: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}foreshadows'])!,
    );
  }

  @override
  $NovelWorldSettingsTable createAlias(String alias) {
    return $NovelWorldSettingsTable(attachedDatabase, alias);
  }
}

class NovelWorldSettingEntity extends DataClass
    implements Insertable<NovelWorldSettingEntity> {
  final String id;
  final String novelId;
  final String era;
  final String geography;
  final String powerSystem;
  final String society;
  final String forbiddenRules;
  final String foreshadows;
  const NovelWorldSettingEntity(
      {required this.id,
      required this.novelId,
      required this.era,
      required this.geography,
      required this.powerSystem,
      required this.society,
      required this.forbiddenRules,
      required this.foreshadows});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['novel_id'] = Variable<String>(novelId);
    map['era'] = Variable<String>(era);
    map['geography'] = Variable<String>(geography);
    map['power_system'] = Variable<String>(powerSystem);
    map['society'] = Variable<String>(society);
    map['forbidden_rules'] = Variable<String>(forbiddenRules);
    map['foreshadows'] = Variable<String>(foreshadows);
    return map;
  }

  NovelWorldSettingsCompanion toCompanion(bool nullToAbsent) {
    return NovelWorldSettingsCompanion(
      id: Value(id),
      novelId: Value(novelId),
      era: Value(era),
      geography: Value(geography),
      powerSystem: Value(powerSystem),
      society: Value(society),
      forbiddenRules: Value(forbiddenRules),
      foreshadows: Value(foreshadows),
    );
  }

  factory NovelWorldSettingEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NovelWorldSettingEntity(
      id: serializer.fromJson<String>(json['id']),
      novelId: serializer.fromJson<String>(json['novelId']),
      era: serializer.fromJson<String>(json['era']),
      geography: serializer.fromJson<String>(json['geography']),
      powerSystem: serializer.fromJson<String>(json['powerSystem']),
      society: serializer.fromJson<String>(json['society']),
      forbiddenRules: serializer.fromJson<String>(json['forbiddenRules']),
      foreshadows: serializer.fromJson<String>(json['foreshadows']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'novelId': serializer.toJson<String>(novelId),
      'era': serializer.toJson<String>(era),
      'geography': serializer.toJson<String>(geography),
      'powerSystem': serializer.toJson<String>(powerSystem),
      'society': serializer.toJson<String>(society),
      'forbiddenRules': serializer.toJson<String>(forbiddenRules),
      'foreshadows': serializer.toJson<String>(foreshadows),
    };
  }

  NovelWorldSettingEntity copyWith(
          {String? id,
          String? novelId,
          String? era,
          String? geography,
          String? powerSystem,
          String? society,
          String? forbiddenRules,
          String? foreshadows}) =>
      NovelWorldSettingEntity(
        id: id ?? this.id,
        novelId: novelId ?? this.novelId,
        era: era ?? this.era,
        geography: geography ?? this.geography,
        powerSystem: powerSystem ?? this.powerSystem,
        society: society ?? this.society,
        forbiddenRules: forbiddenRules ?? this.forbiddenRules,
        foreshadows: foreshadows ?? this.foreshadows,
      );
  NovelWorldSettingEntity copyWithCompanion(NovelWorldSettingsCompanion data) {
    return NovelWorldSettingEntity(
      id: data.id.present ? data.id.value : this.id,
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      era: data.era.present ? data.era.value : this.era,
      geography: data.geography.present ? data.geography.value : this.geography,
      powerSystem:
          data.powerSystem.present ? data.powerSystem.value : this.powerSystem,
      society: data.society.present ? data.society.value : this.society,
      forbiddenRules: data.forbiddenRules.present
          ? data.forbiddenRules.value
          : this.forbiddenRules,
      foreshadows:
          data.foreshadows.present ? data.foreshadows.value : this.foreshadows,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NovelWorldSettingEntity(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('era: $era, ')
          ..write('geography: $geography, ')
          ..write('powerSystem: $powerSystem, ')
          ..write('society: $society, ')
          ..write('forbiddenRules: $forbiddenRules, ')
          ..write('foreshadows: $foreshadows')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, novelId, era, geography, powerSystem,
      society, forbiddenRules, foreshadows);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NovelWorldSettingEntity &&
          other.id == this.id &&
          other.novelId == this.novelId &&
          other.era == this.era &&
          other.geography == this.geography &&
          other.powerSystem == this.powerSystem &&
          other.society == this.society &&
          other.forbiddenRules == this.forbiddenRules &&
          other.foreshadows == this.foreshadows);
}

class NovelWorldSettingsCompanion
    extends UpdateCompanion<NovelWorldSettingEntity> {
  final Value<String> id;
  final Value<String> novelId;
  final Value<String> era;
  final Value<String> geography;
  final Value<String> powerSystem;
  final Value<String> society;
  final Value<String> forbiddenRules;
  final Value<String> foreshadows;
  final Value<int> rowid;
  const NovelWorldSettingsCompanion({
    this.id = const Value.absent(),
    this.novelId = const Value.absent(),
    this.era = const Value.absent(),
    this.geography = const Value.absent(),
    this.powerSystem = const Value.absent(),
    this.society = const Value.absent(),
    this.forbiddenRules = const Value.absent(),
    this.foreshadows = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NovelWorldSettingsCompanion.insert({
    required String id,
    required String novelId,
    this.era = const Value.absent(),
    this.geography = const Value.absent(),
    this.powerSystem = const Value.absent(),
    this.society = const Value.absent(),
    this.forbiddenRules = const Value.absent(),
    this.foreshadows = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        novelId = Value(novelId);
  static Insertable<NovelWorldSettingEntity> custom({
    Expression<String>? id,
    Expression<String>? novelId,
    Expression<String>? era,
    Expression<String>? geography,
    Expression<String>? powerSystem,
    Expression<String>? society,
    Expression<String>? forbiddenRules,
    Expression<String>? foreshadows,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (novelId != null) 'novel_id': novelId,
      if (era != null) 'era': era,
      if (geography != null) 'geography': geography,
      if (powerSystem != null) 'power_system': powerSystem,
      if (society != null) 'society': society,
      if (forbiddenRules != null) 'forbidden_rules': forbiddenRules,
      if (foreshadows != null) 'foreshadows': foreshadows,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NovelWorldSettingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? novelId,
      Value<String>? era,
      Value<String>? geography,
      Value<String>? powerSystem,
      Value<String>? society,
      Value<String>? forbiddenRules,
      Value<String>? foreshadows,
      Value<int>? rowid}) {
    return NovelWorldSettingsCompanion(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      era: era ?? this.era,
      geography: geography ?? this.geography,
      powerSystem: powerSystem ?? this.powerSystem,
      society: society ?? this.society,
      forbiddenRules: forbiddenRules ?? this.forbiddenRules,
      foreshadows: foreshadows ?? this.foreshadows,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (era.present) {
      map['era'] = Variable<String>(era.value);
    }
    if (geography.present) {
      map['geography'] = Variable<String>(geography.value);
    }
    if (powerSystem.present) {
      map['power_system'] = Variable<String>(powerSystem.value);
    }
    if (society.present) {
      map['society'] = Variable<String>(society.value);
    }
    if (forbiddenRules.present) {
      map['forbidden_rules'] = Variable<String>(forbiddenRules.value);
    }
    if (foreshadows.present) {
      map['foreshadows'] = Variable<String>(foreshadows.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NovelWorldSettingsCompanion(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('era: $era, ')
          ..write('geography: $geography, ')
          ..write('powerSystem: $powerSystem, ')
          ..write('society: $society, ')
          ..write('forbiddenRules: $forbiddenRules, ')
          ..write('foreshadows: $foreshadows, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NovelsTable novels = $NovelsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $ChapterGraphsTable chapterGraphs = $ChapterGraphsTable(this);
  late final $AdvancedGraphsTable advancedGraphs = $AdvancedGraphsTable(this);
  late final $CharacterProfilesTable characterProfiles =
      $CharacterProfilesTable(this);
  late final $NovelWorldSettingsTable novelWorldSettings =
      $NovelWorldSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        novels,
        chapters,
        chapterGraphs,
        advancedGraphs,
        characterProfiles,
        novelWorldSettings
      ];
}

typedef $$NovelsTableCreateCompanionBuilder = NovelsCompanion Function({
  required String id,
  required String title,
  Value<String> author,
  Value<String?> cover,
  Value<String> introduction,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NovelsTableUpdateCompanionBuilder = NovelsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> author,
  Value<String?> cover,
  Value<String> introduction,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$NovelsTableFilterComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get introduction => $composableBuilder(
      column: $table.introduction, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NovelsTableOrderingComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get introduction => $composableBuilder(
      column: $table.introduction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NovelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get introduction => $composableBuilder(
      column: $table.introduction, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NovelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NovelsTable,
    NovelEntity,
    $$NovelsTableFilterComposer,
    $$NovelsTableOrderingComposer,
    $$NovelsTableAnnotationComposer,
    $$NovelsTableCreateCompanionBuilder,
    $$NovelsTableUpdateCompanionBuilder,
    (NovelEntity, BaseReferences<_$AppDatabase, $NovelsTable, NovelEntity>),
    NovelEntity,
    PrefetchHooks Function()> {
  $$NovelsTableTableManager(_$AppDatabase db, $NovelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NovelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NovelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NovelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> author = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String> introduction = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NovelsCompanion(
            id: id,
            title: title,
            author: author,
            cover: cover,
            introduction: introduction,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> author = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String> introduction = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NovelsCompanion.insert(
            id: id,
            title: title,
            author: author,
            cover: cover,
            introduction: introduction,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NovelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NovelsTable,
    NovelEntity,
    $$NovelsTableFilterComposer,
    $$NovelsTableOrderingComposer,
    $$NovelsTableAnnotationComposer,
    $$NovelsTableCreateCompanionBuilder,
    $$NovelsTableUpdateCompanionBuilder,
    (NovelEntity, BaseReferences<_$AppDatabase, $NovelsTable, NovelEntity>),
    NovelEntity,
    PrefetchHooks Function()>;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  required String id,
  required String novelId,
  required int number,
  required String title,
  Value<String> content,
  Value<String?> graphId,
  Value<int> wordCount,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<String> id,
  Value<String> novelId,
  Value<int> number,
  Value<String> title,
  Value<String> content,
  Value<String?> graphId,
  Value<int> wordCount,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get novelId => $composableBuilder(
      column: $table.novelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get graphId => $composableBuilder(
      column: $table.graphId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordCount => $composableBuilder(
      column: $table.wordCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get novelId => $composableBuilder(
      column: $table.novelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get graphId => $composableBuilder(
      column: $table.graphId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordCount => $composableBuilder(
      column: $table.wordCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get novelId =>
      $composableBuilder(column: $table.novelId, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get graphId =>
      $composableBuilder(column: $table.graphId, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChaptersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTable,
    ChapterEntity,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (
      ChapterEntity,
      BaseReferences<_$AppDatabase, $ChaptersTable, ChapterEntity>
    ),
    ChapterEntity,
    PrefetchHooks Function()> {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> novelId = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> graphId = const Value.absent(),
            Value<int> wordCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersCompanion(
            id: id,
            novelId: novelId,
            number: number,
            title: title,
            content: content,
            graphId: graphId,
            wordCount: wordCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String novelId,
            required int number,
            required String title,
            Value<String> content = const Value.absent(),
            Value<String?> graphId = const Value.absent(),
            Value<int> wordCount = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersCompanion.insert(
            id: id,
            novelId: novelId,
            number: number,
            title: title,
            content: content,
            graphId: graphId,
            wordCount: wordCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChaptersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTable,
    ChapterEntity,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (
      ChapterEntity,
      BaseReferences<_$AppDatabase, $ChaptersTable, ChapterEntity>
    ),
    ChapterEntity,
    PrefetchHooks Function()>;
typedef $$ChapterGraphsTableCreateCompanionBuilder = ChapterGraphsCompanion
    Function({
  required String id,
  required String chapterId,
  Value<String> type,
  Value<String> data,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ChapterGraphsTableUpdateCompanionBuilder = ChapterGraphsCompanion
    Function({
  Value<String> id,
  Value<String> chapterId,
  Value<String> type,
  Value<String> data,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ChapterGraphsTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterGraphsTable> {
  $$ChapterGraphsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ChapterGraphsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterGraphsTable> {
  $$ChapterGraphsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ChapterGraphsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterGraphsTable> {
  $$ChapterGraphsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChapterGraphsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChapterGraphsTable,
    ChapterGraphEntity,
    $$ChapterGraphsTableFilterComposer,
    $$ChapterGraphsTableOrderingComposer,
    $$ChapterGraphsTableAnnotationComposer,
    $$ChapterGraphsTableCreateCompanionBuilder,
    $$ChapterGraphsTableUpdateCompanionBuilder,
    (
      ChapterGraphEntity,
      BaseReferences<_$AppDatabase, $ChapterGraphsTable, ChapterGraphEntity>
    ),
    ChapterGraphEntity,
    PrefetchHooks Function()> {
  $$ChapterGraphsTableTableManager(_$AppDatabase db, $ChapterGraphsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterGraphsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterGraphsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterGraphsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChapterGraphsCompanion(
            id: id,
            chapterId: chapterId,
            type: type,
            data: data,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chapterId,
            Value<String> type = const Value.absent(),
            Value<String> data = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChapterGraphsCompanion.insert(
            id: id,
            chapterId: chapterId,
            type: type,
            data: data,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChapterGraphsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChapterGraphsTable,
    ChapterGraphEntity,
    $$ChapterGraphsTableFilterComposer,
    $$ChapterGraphsTableOrderingComposer,
    $$ChapterGraphsTableAnnotationComposer,
    $$ChapterGraphsTableCreateCompanionBuilder,
    $$ChapterGraphsTableUpdateCompanionBuilder,
    (
      ChapterGraphEntity,
      BaseReferences<_$AppDatabase, $ChapterGraphsTable, ChapterGraphEntity>
    ),
    ChapterGraphEntity,
    PrefetchHooks Function()>;
typedef $$AdvancedGraphsTableCreateCompanionBuilder = AdvancedGraphsCompanion
    Function({
  required String id,
  required String chapterId,
  required String graphJson,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AdvancedGraphsTableUpdateCompanionBuilder = AdvancedGraphsCompanion
    Function({
  Value<String> id,
  Value<String> chapterId,
  Value<String> graphJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AdvancedGraphsTableFilterComposer
    extends Composer<_$AppDatabase, $AdvancedGraphsTable> {
  $$AdvancedGraphsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get graphJson => $composableBuilder(
      column: $table.graphJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AdvancedGraphsTableOrderingComposer
    extends Composer<_$AppDatabase, $AdvancedGraphsTable> {
  $$AdvancedGraphsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get graphJson => $composableBuilder(
      column: $table.graphJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AdvancedGraphsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdvancedGraphsTable> {
  $$AdvancedGraphsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get graphJson =>
      $composableBuilder(column: $table.graphJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AdvancedGraphsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AdvancedGraphsTable,
    AdvancedGraphEntity,
    $$AdvancedGraphsTableFilterComposer,
    $$AdvancedGraphsTableOrderingComposer,
    $$AdvancedGraphsTableAnnotationComposer,
    $$AdvancedGraphsTableCreateCompanionBuilder,
    $$AdvancedGraphsTableUpdateCompanionBuilder,
    (
      AdvancedGraphEntity,
      BaseReferences<_$AppDatabase, $AdvancedGraphsTable, AdvancedGraphEntity>
    ),
    AdvancedGraphEntity,
    PrefetchHooks Function()> {
  $$AdvancedGraphsTableTableManager(
      _$AppDatabase db, $AdvancedGraphsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdvancedGraphsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdvancedGraphsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdvancedGraphsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> graphJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AdvancedGraphsCompanion(
            id: id,
            chapterId: chapterId,
            graphJson: graphJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chapterId,
            required String graphJson,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AdvancedGraphsCompanion.insert(
            id: id,
            chapterId: chapterId,
            graphJson: graphJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AdvancedGraphsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AdvancedGraphsTable,
    AdvancedGraphEntity,
    $$AdvancedGraphsTableFilterComposer,
    $$AdvancedGraphsTableOrderingComposer,
    $$AdvancedGraphsTableAnnotationComposer,
    $$AdvancedGraphsTableCreateCompanionBuilder,
    $$AdvancedGraphsTableUpdateCompanionBuilder,
    (
      AdvancedGraphEntity,
      BaseReferences<_$AppDatabase, $AdvancedGraphsTable, AdvancedGraphEntity>
    ),
    AdvancedGraphEntity,
    PrefetchHooks Function()>;
typedef $$CharacterProfilesTableCreateCompanionBuilder
    = CharacterProfilesCompanion Function({
  required String id,
  required String novelId,
  required String name,
  Value<String> alias,
  Value<String> personality,
  Value<String> redLines,
  Value<String> backstories,
  Value<int> rowid,
});
typedef $$CharacterProfilesTableUpdateCompanionBuilder
    = CharacterProfilesCompanion Function({
  Value<String> id,
  Value<String> novelId,
  Value<String> name,
  Value<String> alias,
  Value<String> personality,
  Value<String> redLines,
  Value<String> backstories,
  Value<int> rowid,
});

class $$CharacterProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterProfilesTable> {
  $$CharacterProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get novelId => $composableBuilder(
      column: $table.novelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get redLines => $composableBuilder(
      column: $table.redLines, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backstories => $composableBuilder(
      column: $table.backstories, builder: (column) => ColumnFilters(column));
}

class $$CharacterProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterProfilesTable> {
  $$CharacterProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get novelId => $composableBuilder(
      column: $table.novelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get redLines => $composableBuilder(
      column: $table.redLines, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backstories => $composableBuilder(
      column: $table.backstories, builder: (column) => ColumnOrderings(column));
}

class $$CharacterProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterProfilesTable> {
  $$CharacterProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get novelId =>
      $composableBuilder(column: $table.novelId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => column);

  GeneratedColumn<String> get redLines =>
      $composableBuilder(column: $table.redLines, builder: (column) => column);

  GeneratedColumn<String> get backstories => $composableBuilder(
      column: $table.backstories, builder: (column) => column);
}

class $$CharacterProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CharacterProfilesTable,
    CharacterProfileEntity,
    $$CharacterProfilesTableFilterComposer,
    $$CharacterProfilesTableOrderingComposer,
    $$CharacterProfilesTableAnnotationComposer,
    $$CharacterProfilesTableCreateCompanionBuilder,
    $$CharacterProfilesTableUpdateCompanionBuilder,
    (
      CharacterProfileEntity,
      BaseReferences<_$AppDatabase, $CharacterProfilesTable,
          CharacterProfileEntity>
    ),
    CharacterProfileEntity,
    PrefetchHooks Function()> {
  $$CharacterProfilesTableTableManager(
      _$AppDatabase db, $CharacterProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterProfilesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> novelId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<String> personality = const Value.absent(),
            Value<String> redLines = const Value.absent(),
            Value<String> backstories = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CharacterProfilesCompanion(
            id: id,
            novelId: novelId,
            name: name,
            alias: alias,
            personality: personality,
            redLines: redLines,
            backstories: backstories,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String novelId,
            required String name,
            Value<String> alias = const Value.absent(),
            Value<String> personality = const Value.absent(),
            Value<String> redLines = const Value.absent(),
            Value<String> backstories = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CharacterProfilesCompanion.insert(
            id: id,
            novelId: novelId,
            name: name,
            alias: alias,
            personality: personality,
            redLines: redLines,
            backstories: backstories,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CharacterProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CharacterProfilesTable,
    CharacterProfileEntity,
    $$CharacterProfilesTableFilterComposer,
    $$CharacterProfilesTableOrderingComposer,
    $$CharacterProfilesTableAnnotationComposer,
    $$CharacterProfilesTableCreateCompanionBuilder,
    $$CharacterProfilesTableUpdateCompanionBuilder,
    (
      CharacterProfileEntity,
      BaseReferences<_$AppDatabase, $CharacterProfilesTable,
          CharacterProfileEntity>
    ),
    CharacterProfileEntity,
    PrefetchHooks Function()>;
typedef $$NovelWorldSettingsTableCreateCompanionBuilder
    = NovelWorldSettingsCompanion Function({
  required String id,
  required String novelId,
  Value<String> era,
  Value<String> geography,
  Value<String> powerSystem,
  Value<String> society,
  Value<String> forbiddenRules,
  Value<String> foreshadows,
  Value<int> rowid,
});
typedef $$NovelWorldSettingsTableUpdateCompanionBuilder
    = NovelWorldSettingsCompanion Function({
  Value<String> id,
  Value<String> novelId,
  Value<String> era,
  Value<String> geography,
  Value<String> powerSystem,
  Value<String> society,
  Value<String> forbiddenRules,
  Value<String> foreshadows,
  Value<int> rowid,
});

class $$NovelWorldSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $NovelWorldSettingsTable> {
  $$NovelWorldSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get novelId => $composableBuilder(
      column: $table.novelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get era => $composableBuilder(
      column: $table.era, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geography => $composableBuilder(
      column: $table.geography, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get powerSystem => $composableBuilder(
      column: $table.powerSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get society => $composableBuilder(
      column: $table.society, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get forbiddenRules => $composableBuilder(
      column: $table.forbiddenRules,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foreshadows => $composableBuilder(
      column: $table.foreshadows, builder: (column) => ColumnFilters(column));
}

class $$NovelWorldSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $NovelWorldSettingsTable> {
  $$NovelWorldSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get novelId => $composableBuilder(
      column: $table.novelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get era => $composableBuilder(
      column: $table.era, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geography => $composableBuilder(
      column: $table.geography, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get powerSystem => $composableBuilder(
      column: $table.powerSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get society => $composableBuilder(
      column: $table.society, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get forbiddenRules => $composableBuilder(
      column: $table.forbiddenRules,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foreshadows => $composableBuilder(
      column: $table.foreshadows, builder: (column) => ColumnOrderings(column));
}

class $$NovelWorldSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NovelWorldSettingsTable> {
  $$NovelWorldSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get novelId =>
      $composableBuilder(column: $table.novelId, builder: (column) => column);

  GeneratedColumn<String> get era =>
      $composableBuilder(column: $table.era, builder: (column) => column);

  GeneratedColumn<String> get geography =>
      $composableBuilder(column: $table.geography, builder: (column) => column);

  GeneratedColumn<String> get powerSystem => $composableBuilder(
      column: $table.powerSystem, builder: (column) => column);

  GeneratedColumn<String> get society =>
      $composableBuilder(column: $table.society, builder: (column) => column);

  GeneratedColumn<String> get forbiddenRules => $composableBuilder(
      column: $table.forbiddenRules, builder: (column) => column);

  GeneratedColumn<String> get foreshadows => $composableBuilder(
      column: $table.foreshadows, builder: (column) => column);
}

class $$NovelWorldSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NovelWorldSettingsTable,
    NovelWorldSettingEntity,
    $$NovelWorldSettingsTableFilterComposer,
    $$NovelWorldSettingsTableOrderingComposer,
    $$NovelWorldSettingsTableAnnotationComposer,
    $$NovelWorldSettingsTableCreateCompanionBuilder,
    $$NovelWorldSettingsTableUpdateCompanionBuilder,
    (
      NovelWorldSettingEntity,
      BaseReferences<_$AppDatabase, $NovelWorldSettingsTable,
          NovelWorldSettingEntity>
    ),
    NovelWorldSettingEntity,
    PrefetchHooks Function()> {
  $$NovelWorldSettingsTableTableManager(
      _$AppDatabase db, $NovelWorldSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NovelWorldSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NovelWorldSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NovelWorldSettingsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> novelId = const Value.absent(),
            Value<String> era = const Value.absent(),
            Value<String> geography = const Value.absent(),
            Value<String> powerSystem = const Value.absent(),
            Value<String> society = const Value.absent(),
            Value<String> forbiddenRules = const Value.absent(),
            Value<String> foreshadows = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NovelWorldSettingsCompanion(
            id: id,
            novelId: novelId,
            era: era,
            geography: geography,
            powerSystem: powerSystem,
            society: society,
            forbiddenRules: forbiddenRules,
            foreshadows: foreshadows,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String novelId,
            Value<String> era = const Value.absent(),
            Value<String> geography = const Value.absent(),
            Value<String> powerSystem = const Value.absent(),
            Value<String> society = const Value.absent(),
            Value<String> forbiddenRules = const Value.absent(),
            Value<String> foreshadows = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NovelWorldSettingsCompanion.insert(
            id: id,
            novelId: novelId,
            era: era,
            geography: geography,
            powerSystem: powerSystem,
            society: society,
            forbiddenRules: forbiddenRules,
            foreshadows: foreshadows,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NovelWorldSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NovelWorldSettingsTable,
    NovelWorldSettingEntity,
    $$NovelWorldSettingsTableFilterComposer,
    $$NovelWorldSettingsTableOrderingComposer,
    $$NovelWorldSettingsTableAnnotationComposer,
    $$NovelWorldSettingsTableCreateCompanionBuilder,
    $$NovelWorldSettingsTableUpdateCompanionBuilder,
    (
      NovelWorldSettingEntity,
      BaseReferences<_$AppDatabase, $NovelWorldSettingsTable,
          NovelWorldSettingEntity>
    ),
    NovelWorldSettingEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NovelsTableTableManager get novels =>
      $$NovelsTableTableManager(_db, _db.novels);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$ChapterGraphsTableTableManager get chapterGraphs =>
      $$ChapterGraphsTableTableManager(_db, _db.chapterGraphs);
  $$AdvancedGraphsTableTableManager get advancedGraphs =>
      $$AdvancedGraphsTableTableManager(_db, _db.advancedGraphs);
  $$CharacterProfilesTableTableManager get characterProfiles =>
      $$CharacterProfilesTableTableManager(_db, _db.characterProfiles);
  $$NovelWorldSettingsTableTableManager get novelWorldSettings =>
      $$NovelWorldSettingsTableTableManager(_db, _db.novelWorldSettings);
}
