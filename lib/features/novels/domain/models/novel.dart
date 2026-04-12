import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel.freezed.dart';
part 'novel.g.dart';

@freezed
class Novel with _$Novel {
  const factory Novel({
    required String id,
    required String title,
    @Default('') String author,
    String? cover,
    @Default('') String introduction,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? wordCount,
  }) = _Novel;

  factory Novel.fromJson(Map<String, dynamic> json) => _$NovelFromJson(json);
}
