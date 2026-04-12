import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_profile.freezed.dart';
part 'character_profile.g.dart';

// ═══════════════════════════════════════════════════════════════
//   F7: Character Profile (人设红线/设定禁区数据模型)
// ═══════════════════════════════════════════════════════════════

@freezed
class CharacterProfile with _$CharacterProfile {
  const factory CharacterProfile({
    required String id,
    required String novelId,
    required String name,
    @Default('') String alias,
    @Default('') String personality,
    @Default([]) List<String> redLines, // 人设红线
    @Default([]) List<String> backstories, // 背景故事
  }) = _CharacterProfile;

  factory CharacterProfile.fromJson(Map<String, dynamic> json) =>
      _$CharacterProfileFromJson(json);
}

@freezed
class NovelWorldSetting with _$NovelWorldSetting {
  const factory NovelWorldSetting({
    required String id,
    required String novelId,
    @Default('') String era, // 时代背景
    @Default('') String geography, // 地理区域
    @Default('') String powerSystem, // 力量体系
    @Default('') String society, // 社会结构
    @Default([]) List<String> forbiddenRules, // 设定禁区
    @Default([]) List<Foreshadow> foreshadows, // 伏笔列表
  }) = _NovelWorldSetting;

  factory NovelWorldSetting.fromJson(Map<String, dynamic> json) =>
      _$NovelWorldSettingFromJson(json);
}

@freezed
class Foreshadow with _$Foreshadow {
  const factory Foreshadow({
    required String id,
    required String title,
    @Default('') String setupChapterId, // 伏笔埋下的章节
    @Default('') String description,
    @Default(false) bool isResolved, // 是否已回收
    @Default('') String payoffChapterId, // 回收的章节
  }) = _Foreshadow;

  factory Foreshadow.fromJson(Map<String, dynamic> json) =>
      _$ForeshadowFromJson(json);
}
