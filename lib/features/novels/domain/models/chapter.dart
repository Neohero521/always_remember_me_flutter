import 'package:freezed_annotation/freezed_annotation.dart';
import 'chapter_graph.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String novelId,
    required int number,
    required String title,
    @Default('') String content,
    String? graphId,
    @Default(0) int wordCount,
    required DateTime createdAt,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}
