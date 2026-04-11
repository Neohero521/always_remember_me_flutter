# Always Remember Me Flutter v2.0 测试报告

**测试日期：** 2026-04-11
**测试方式：** 静态代码审查
**代码路径：** `/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`

---

## 一、功能代码审查

### F1 - 书架章节丢失Bug修复 ✅ 通过

**相关代码：**
- `NovelProvider._loadBookData()` (novel_provider.dart ~line 1118)
- `StorageService.loadNovelDataForBook()` (storage_service.dart)

**审查结果：**

1. **`batchMergedGraphs` JSON序列化修复** ✅ 正确
   - **保存** (`_saveCurrentBookData`): `_batchMergedGraphs.map((g) => const JsonEncoder.withIndent('  ').convert(g)).toList()` — 每项转为 JSON 字符串
   - **加载** (`_loadBookData`): `(data.batchMergedGraphs ?? []).map((s) => json.decode(s) as Map<String, dynamic>).toList()` — 正确反序列化
   - **Storage Service** 正确存储为 `List<String>`，读取时解码为 `Map<String, dynamic>`
   - 序列化/反序列化链路完整，无数据丢失风险

2. **双重保存验证机制** ✅ 正确
   - `importBook()` 末尾有二次验证逻辑（第 1377-1382 行）：
     ```dart
     final verify = await _storage.loadNovelDataForBook(bookId);
     if (verify == null || verify.chapters == null || verify.chapters!.isEmpty) {
       debugPrint('[importBook] 保存验证失败，重新保存一次');
       await _saveCurrentBookData();
       // ...
     }
     ```
   - 若二次保存仍失败，抛出 `StateError` 而非静默继续

3. **启动时章节数校验** ✅ 正确
   - `_loadSettings()` 遍历书架所有书，从 Hive 读取 `actualCount`，与 `book.chapterCount` 对比，不一致则校正

**结论：** F1 修复方案设计完整，双重验证机制可有效防止章节丢失。

---

### F2 - 魔改章节图谱更新按钮 ✅ 通过

**相关代码：**
- `write_screen.dart` 第 194-197 行（UI按钮）
- `novel_provider.dart` `updateModifiedChapterGraph()` (line ~888)

**审查结果：**

1. **UI入口** ✅ 正确
   - "更新图谱"按钮仅在 `_isEditing == true` 时显示
   - 位于 WriteScreen 编辑模式下的基准章节内容卡片中

2. **Provider方法** ✅ 正确
   - `updateModifiedChapterGraph(chapterId, modifiedContent)` 接收用户编辑后的内容
   - 调用 `apiService.generateSingleChapterGraph(..., isModified: true)`
   - 同步更新 `_chapterGraphMap` 和 `_chapters` 内存状态
   - 自动触发 `_schedulePersist()` 持久化

**结论：** F2 功能完整，编辑→更新图谱→持久化链路正确。

---

### F3 - 一键批量续写 ✅ 通过（有小瑕疵）

**相关代码：**
- `write_screen.dart` 第 569-626 行 `_runBatchContinueWrite()`
- `write_screen.dart` 第 628-662 行 `_BatchProgressDialog`

**审查结果：**

1. **进度对话框** ✅ 正确
   - 使用 `showDialog(barrierDismissible: false)` 阻塞式显示
   - `_BatchProgressDialog` 每 500ms 轮询更新状态

2. **停止机制** ✅ 正确
   - `_stopBatchWrite` 标志位在每次循环开始时检查
   - 点击"停止"时调用 `Navigator.pop()` 关闭对话框（`onStop` 设置 `_stopBatchWrite = true`）
   - 循环结束后检查到 `_stopBatchWrite` 时直接返回，不显示总结

3. **状态管理** ✅ 正确
   - `_batchTotal`, `_batchCurrent`, `_batchSuccess`, `_batchFailed` 均有维护
   - `_batchFailedTitles` 记录失败章节名

4. **小瑕疵** ⚠️ 非阻塞
   - `_showBatchSummary` 在 `_stopBatchWrite` 为 true 时不会显示（因为对话框已在停止时关闭）
   - 用户点击停止后不知道有多少成功/失败，需改进可考虑不自动关闭对话框

5. **请求频率** ⚠️ 有风险
   - 单次续写后 `delay(500ms)`，无全局 API 调用速率限制
   - 恶意/误操作可短时间大量请求 API

**结论：** F3 功能基本正确，停止机制有效。建议增加 API 请求频率限制。

---

### F4 - 阅读器滚动位置持久化 ✅ 通过

**相关代码：**
- `reader_screen.dart` 第 54-88 行（位置保存/加载）
- `reader_screen.dart` 第 283-318 行 `_ChapterPage`（滚动恢复）

**审查结果：**

1. **保存时机** ✅ 正确
   - `dispose()` 时调用 `_persistScrollPosition()`
   - 切换章节时（`_onPageChanged`）先保存旧章节位置
   - 使用 fraction（0.0~1.0）而非绝对像素值，与屏幕尺寸无关

2. **加载时机** ✅ 正确
   - `_ChapterPage.initState` 中用 `SchedulerBinding.instance.addPostFrameCallback` 在布局完成后恢复位置
   - `jumpTo()` 设置绝对位置（考虑内容高度）

3. **SharedPreferences Key设计** ✅ 正确
   - Key: `reader_scroll_${bookId}_${chapterId}`，按书和章节隔离

**结论：** F4 实现完整正确，滚动位置恢复逻辑健壮。

---

### F5 - 图谱合规性校验 ✅ 通过

**相关代码：**
- `novel_provider.dart` `validateAllChapterGraphsCompliance()` (line ~807)
- `chapters_screen.dart` `_validateCompliance()` (line ~305)

**审查结果：**

1. **校验规则** ✅ 正确
   - **字段检查：** 7个必填字段（`人物信息`, `世界观设定`, `核心剧情线`, `文风特点`, `实体关系网络`, `变更与依赖信息`, `逆向分析洞察`）
   - **字数检查：** `chapter.content.length < minWordCount`（默认1200）
   - **自洽得分检查：** `score < minScore`（默认60）

2. **UI菜单入口** ✅ 正确
   - `ChaptersScreen` 的 `PopupMenuButton` → `validate_compliance`

3. **汇总对话框** ✅ 正确
   - 显示通过率百分比
   - 失败章节列出 + 可点击跳转 ReaderScreen

4. **注意：** `mergedGraph` 的校验（`validateGraphCompliance`）用的是8个字段（多了`全局基础信息`），而单章图谱用的是7个字段，这是有意的设计差异（非Bug）

**结论：** F5 功能完整，校验规则清晰，UI流程顺畅。

---

## 二、安全测试

### 🔴 BLOCKER 1：API Key 明文存储

**问题：** API Key 存储在 SharedPreferences，完全无加密。

```dart
// novel_provider.dart _saveSettings()
await prefs.setString('novel_app_settings', json.encode({
  'apiBaseUrl': _apiBaseUrl,
  'apiKey': _apiKey,  // 明文！
  ...
}));
```

**风险：** 设备被 root / 解锁后可直接读取 API Key。
**建议：** 使用 flutter_secure_storage 替代 SharedPreferences 存储敏感信息。

### ⚠️ 风险 2：Hive 数据未加密

**问题：** Hive 数据（章节内容、图谱等）存储在未加密的本地文件。

**风险：** 设备被 root 后可读取所有小说内容。
**建议：** 如需加密，使用 `hive_flutter` 的加密盒子或应用级加密。

### ⚠️ 风险 3：批量续写无 API 请求频率限制

**问题：** `_runBatchContinueWrite` 中单次续写完成后仅 `delay(500ms)`。

```dart
// write_screen.dart line 621
await Future.delayed(const Duration(milliseconds: 500));
```

**风险：** 用户或恶意代码可短时间触发大量 API 请求（1000章节 = 约500秒即可全部发出）。
**建议：** 添加全局请求计数器 + 时间窗口限流，或在 Provider 层面限制批量操作的总请求速率。

---

## 三、用例测试结论

| 用例 | 静态审查结果 | 备注 |
|------|------------|------|
| F1: 书架章节丢失修复 | ✅ 通过 | 双重保存验证机制有效 |
| F2: 魔改章节图谱更新 | ✅ 通过 | 编辑→更新→持久化链路正确 |
| F3: 批量续写（进度+停止） | ✅ 通过（有小瑕疵） | 停止机制有效，瑕疵见上方 |
| F4: 阅读器滚动位置持久化 | ✅ 通过 | fraction方式跨屏幕兼容 |
| F5: 图谱合规性校验 | ✅ 通过 | 7字段+字数+得分校验正确 |
| API Key 安全存储 | 🔴 BLOCKER | 明文存储需修复 |
| Hive 数据加密 | ⚠️ 风险 | 未加密，建议说明 |
| API 请求频率限制 | ⚠️ 风险 | 无全局限流 |

---

## 四、总结

**v2.0 新增功能代码质量：良好**

5个新功能中，代码实现均正确，逻辑链路清晰。主要问题集中在**安全层面**（API Key 明文存储），建议推动 developer-agent 优先修复。

**阻塞问题：** 1个（API Key 明文存储）
**风险问题：** 2个（数据加密、请求限流）
**轻微问题：** 1个（批量续写停止后无结果提示）
