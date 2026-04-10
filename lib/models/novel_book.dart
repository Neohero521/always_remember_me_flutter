import 'package:hive/hive.dart';

part 'novel_book.g.dart';

@HiveType(typeId: 12)
class NovelBook extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? coverPath;

  @HiveField(3)
  int chapterCount;

  @HiveField(4)
  DateTime importedAt;

  @HiveField(5)
  DateTime? lastReadAt;

  @HiveField(6)
  int lastReadChapterId;

  @HiveField(7)
  double readProgress;

  @HiveField(8)
  String rawFileName;

  NovelBook({
    required this.id,
    required this.title,
    this.coverPath,
    this.chapterCount = 0,
    required this.importedAt,
    this.lastReadAt,
    this.lastReadChapterId = 0,
    this.readProgress = 0.0,
    this.rawFileName = '',
  });

  factory NovelBook.fromImport({
    required String id,
    required String rawFileName,
    String? customTitle,
  }) {
    final title = customTitle ?? rawFileName.replaceAll(RegExp(r'\.txt$', caseSensitive: false), '');
    return NovelBook(
      id: id,
      title: title,
      rawFileName: rawFileName,
      importedAt: DateTime.now(),
    );
  }

  NovelBook copyWithMeta({
    int? chapterCount,
    int? lastReadChapterId,
    double? readProgress,
    DateTime? lastReadAt,
    String? title,
  }) {
    return NovelBook(
      id: id,
      title: title ?? this.title,
      coverPath: coverPath,
      chapterCount: chapterCount ?? this.chapterCount,
      importedAt: importedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      lastReadChapterId: lastReadChapterId ?? this.lastReadChapterId,
      readProgress: readProgress ?? this.readProgress,
      rawFileName: rawFileName,
    );
  }
}
