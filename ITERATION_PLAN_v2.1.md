# Always Remember Me Flutter — v2.1 迭代计划

## 📋 Bug 根因分析

### 🔴 BLOCKER: "二次验证不通过"（导入小说保存失败）

**错误抛出位置**: `novel_provider.dart:1386`
```dart
throw StateError('[importBook] 小说保存失败（二次验证不通过），请重启APP后重新导入');
```

**完整链路追踪**:

1. `importBook()` 执行流程:
   - Step 1: `await _saveCurrentBookData(prevBookId: oldBookId)` 保存旧书
   - Step 2: 计算 `cacheKey = '$_currentBookId|novelText'`，判断是否复用已有章节
   - Step 3: `parsed = ChapterService.splitByRegex(novelText, regex)` 解析章节
   - Step 4: `_chapters = parsed` 更新内存状态
   - Step 5: `_currentBookId = bookId`（timestamp）
   - Step 6: `await _saveCurrentBookData()` → 调用 `saveNovelDataForBook(bookId, NovelPersistData(chapters: _chapters, ...))`
   - Step 7: `await _storage.saveBookshelf(_bookshelf)`
   - Step 8: **验证** `await _storage.loadNovelDataForBook(bookId)` → 检查 `verify.chapters` 是否为 null 或 empty

2. **根因定位**: 问题出在 `loadNovelDataForBook()` 的 `hasChapters` 判断逻辑（`storage_service.dart`）:

```dart
final hasChapters = rawChaptersCheck != null &&
    (rawChaptersCheck is String && rawChaptersCheck.isNotEmpty ||
     rawChaptersCheck is List && (rawChaptersCheck as List).isNotEmpty);
final hasLastParsed = rawLastParsed != null && rawLastParsed != '';
if (!hasChapters && !hasLastParsed) return null;
```

关键问题：当 `rawChaptersCheck` 是**空 List `[]`** 时：
- `rawChaptersCheck is String` → false
- `rawChaptersCheck is List && isNotEmpty` → false（因为空列表 `isNotEmpty == false`）
- 结果：`hasChapters = false`

即使 `hasLastParsed = true`（`lastParsedText` 非空），由于 `!hasChapters && !hasLastParsed` 为 false（因为 `hasLastParsed = true`），逻辑上不会 return null。但反过来，如果 `hasChapters = false` 且 `hasLastParsed = false`，就会 return null。

**真正的根因是 `hasChapters` 判断逻辑有缺陷**：当 `rawChaptersCheck` 是**空 List**（而不是 null）时，判断为 false，但数据实际已保存。此时 `verify.chapters` 为 `[]`（空列表），触发验证失败的 `isEmpty` 检查。

**触发条件推测**:
- 用户导入小说时，`ChapterService.splitByRegex` 未能成功拆分章节（正则不匹配小说格式）
- 导致 `parsed` 为空列表或章节数极少
- `saveNovelDataForBook` 写入 `chapters: []`
- 验证时 `verify.chapters!.isEmpty == true` → 触发二次保存 → 二次保存也是 `[]` → 抛出错误

**修复方案**（2 个关键改动）:

**Fix 1: `storage_service.dart` — 修复 `hasChapters` 判断**
```dart
// 原代码对空 List 误判为"无章节数据"
final hasChapters = rawChaptersCheck != null &&
    (rawChaptersCheck is String && rawChaptersCheck.isNotEmpty ||
     rawChaptersCheck is List && (rawChaptersCheck as List).isNotEmpty);
// 修复：key 存在就认为有章节数据（哪怕是空列表也是合法数据）
final hasChapters = b.containsKey('${p}chapters');
```

**Fix 2: `novel_provider.dart` — `importBook` 验证逻辑优化**
- 空章节不应该是"保存失败"，而是正常状态（用户可能导入纯文本或无法拆分的文件）
- 验证应改为：检查 Hive 读取是否返回数据（非 null），而不是检查章节是否非空
- 如果 `verify == null`，才说明真的保存失败

---

## 📝 其他问题

### ⚠️ 问题 2: 批量续写停止后无结果提示
- **位置**: `generateWrite` / `continueFromChain` / `stopWrite`
- **问题**: 用户点击停止后，`_stopFlag` 被设置为 true，但 `continueChain` 中的已有续写结果仍然在内存中。UI 需要显示"已停止，X 条续写结果已保存"。
- **修复**: 在 `stopWrite` 中，除了设置标志位，还应更新一个 `stoppedWithResults` 状态，让 UI 可以提示用户有部分结果。

---

## 🗺️ v2.1 迭代计划

### P0（必须修复，发布 blocker）
| # | 文件 | 改动 | 优先级 |
|---|------|------|--------|
| 1 | `lib/services/storage_service.dart` | Fix `hasChapters` 判断：用 `containsKey` 代替类型判断 | P0 |
| 2 | `lib/providers/novel_provider.dart` `importBook` | 验证逻辑改为 `verify == null` 才算失败；空章节是合法状态 | P0 |
| 3 | `lib/providers/novel_provider.dart` `importBook` | 移除 `_lastImportCacheKey` 缓存逻辑（它是 bug 的帮凶，且收益极低） | P0 |

### P1（重要体验）
| # | 文件 | 改动 | 优先级 |
|---|------|------|--------|
| 4 | `lib/providers/novel_provider.dart` `stopWrite` | 增加 `stoppedWithResults` 状态标记 | P1 |
| 5 | `lib/screens/write/write_screen.dart` | 批量续写停止后显示结果提示 | P1 |

---

## ⏱️ 时间线

| 阶段 | 内容 | 预计工作量 |
|------|------|-----------|
| Phase 1 | Fix P0: 修复 storage_service + importBook 验证逻辑 + 移除缓存 | 1-2h |
| Phase 2 | P1: 停止续写结果提示 | 1h |
| Phase 3 | 构建 APK 测试验证 | 30min |

**总计**: ~3-4 小时

---

## 🔧 修复详情（供 developer-agent 参考）

### Fix 1: `lib/services/storage_service.dart` — `hasChapters` 修复

找到 `loadNovelDataForBook` 中的这段代码：

```dart
final rawChaptersCheck = b.get('${p}chapters');
final hasChapters = rawChaptersCheck != null &&
    (rawChaptersCheck is String && rawChaptersCheck.isNotEmpty ||
     rawChaptersCheck is List && (rawChaptersCheck as List).isNotEmpty);
final hasLastParsed = rawLastParsed != null && rawLastParsed != '';
if (!hasChapters && !hasLastParsed) return null;
```

替换为：

```dart
final hasChapters = b.containsKey('${p}chapters');
final hasLastParsed = rawLastParsed != null && rawLastParsed != '';
if (!hasChapters && !hasLastParsed) return null;
```

### Fix 2: `lib/providers/novel_provider.dart` — `importBook` 验证逻辑

找到验证逻辑（约在 1373-1391 行）：

```dart
final verify = await _storage.loadNovelDataForBook(bookId);
if (verify == null || verify.chapters == null || verify.chapters!.isEmpty) {
  debugPrint('[importBook] 保存验证失败，重新保存一次');
  await _saveCurrentBookData();
  final verify2 = await _storage.loadNovelDataForBook(bookId);
  if (verify2 == null || verify2.chapters == null || verify2.chapters!.isEmpty) {
    debugPrint('[importBook] 二次保存验证也失败！bookId=$bookId，Hive 数据可能损坏');
    throw StateError('[importBook] 小说保存失败（二次验证不通过），请重启APP后重新导入');
  }
  debugPrint('[importBook] 二次保存后验证: ${verify2.chapters!.length} 个章节（已恢复）');
} else {
  debugPrint('[importBook] 验证通过: ${verify.chapters!.length} 个章节');
}
```

替换为：

```dart
final verify = await _storage.loadNovelDataForBook(bookId);
if (verify == null) {
  debugPrint('[importBook] 保存验证失败（Hive 无数据），重新保存一次');
  await _saveCurrentBookData();
  final verify2 = await _storage.loadNovelDataForBook(bookId);
  if (verify2 == null) {
    debugPrint('[importBook] 二次保存验证也失败！bookId=$bookId，Hive 数据可能损坏');
    throw StateError('[importBook] 小说保存失败（Hive 写入异常），请重启APP后重新导入');
  }
  debugPrint('[importBook] 二次保存后验证成功: chapters=${verify2.chapters?.length ?? 0}');
} else {
  debugPrint('[importBook] 验证通过: chapters=${verify.chapters?.length ?? 0}（空列表为合法状态）');
}
```

### Fix 3: `lib/providers/novel_provider.dart` — 移除 `importBook` 中的缓存逻辑

找到 `importBook` 中的缓存检查（约在 1323-1335 行）：

```dart
List<Chapter> parsed;
final cacheKey = '$_currentBookId|novelText';
if (_lastImportCacheKey == cacheKey && _chapters.isNotEmpty) {
  // 同一本书的同一文本：复用
  parsed = _chapters;
} else {
  // 不同书，或文本已变化：强制重新解析
  if (customRegex != null && customRegex.isNotEmpty) {
    parsed = ChapterService.splitByRegex(novelText, customRegex);
  } else if (wordCount != null) {
    parsed = ChapterService.splitByWordCount(novelText, wordCount);
  } else {
    final regex = _currentAutoRegex.isNotEmpty ? _currentAutoRegex : '';
    parsed = ChapterService.splitByRegex(novelText, regex);
  }
  _lastImportCacheKey = cacheKey;
}
```

替换为（简化，去掉缓存机制）：

```dart
List<Chapter> parsed;
if (customRegex != null && customRegex.isNotEmpty) {
  parsed = ChapterService.splitByRegex(novelText, customRegex);
} else if (wordCount != null) {
  parsed = ChapterService.splitByWordCount(novelText, wordCount);
} else {
  final regex = _currentAutoRegex.isNotEmpty ? _currentAutoRegex : '';
  parsed = ChapterService.splitByRegex(novelText, regex);
}
```

同时删除 `_lastImportCacheKey` 相关字段和使用（该字段仅用于这个缓存逻辑，移除后不影响其他功能）。
