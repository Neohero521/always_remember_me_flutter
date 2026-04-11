# Always Remember Me v3.0 测试报告

**测试时间：** 2026-04-11
**测试方式：** 代码审查（Code Review）+ 静态分析
**测试范围：** UI/交互、核心功能逻辑、重点 Bug 修复验证

---

## 一、UI/交互验收

### ✅ 1. App 启动直接进入 WriteScreen（续写首页）

**验证结果：** 通过

**证据：**
```dart
// main.dart
initialRoute: AppRoutes.home,  // AppRoutes.home = '/'
routes: {
  AppRoutes.home: (_) => const WriteScreen(),  // WriteScreen 是默认首页
  ...
}
```

---

### ✅ 2. AppBar 显示书名 + 阅读按钮 + 设置菜单

**验证结果：** 通过

**证据（write_screen.dart）：**
```dart
AppBar(
  // 书名（可点击跳转书架）
  title: GestureDetector(
    onTap: () => Navigator.pushNamed(context, AppRoutes.bookshelf),
    child: Row(
      children: [
        Flexible(child: Text(bookTitle, ...)),
        if (provider.chapters.isNotEmpty)
          const Icon(Icons.arrow_drop_down, size: 18),
      ],
    ),
  ),
  actions: [
    // 阅读按钮
    if (provider.chapters.isNotEmpty)
      IconButton(
        icon: const Text('📖', style: TextStyle(fontSize: 18)),
        tooltip: '阅读小说',
        onPressed: () => Navigator.pushNamed(context, AppRoutes.reader),
      ),
    // 设置菜单
    PopupMenuButton<String>(
      icon: const Text('⋮', style: TextStyle(fontSize: 22)),
      onSelected: (v) {
        if (v == 'settings') Navigator.pushNamed(context, AppRoutes.settings);
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'settings',
          child: Row(children: [
            Icon(Icons.settings, size: 18),
            SizedBox(width: 8),
            Text('⚙️ 设置'),
          ]),
        ),
      ],
    ),
  ],
)
```

---

### ✅ 3. WriteScreen 有 TabBar：[续写 / 链条 / 图谱状态]

**验证结果：** 通过

**证据（write_screen.dart）：**
```dart
TabBar(
  controller: _tabController,
  labelColor: CutePixelColors.lavender,
  indicatorColor: CutePixelColors.lavender,
  tabs: const [
    Tab(text: '✍️ 续写'),
    Tab(text: '🔗 链条'),
    Tab(text: '🌲 图谱状态'),
  ],
)
body: TabBarView(
  controller: _tabController,
  children: const [WriteTab(), ChainTab(), GraphStatusTab()],
)
```

---

### ✅ 4. Drawer 可正常展开/收起

**验证结果：** 通过

**证据（write_screen.dart）：**
```dart
Scaffold(
  drawer: const AppDrawer(),  // Drawer 绑定正确
  ...
)
AppBar(
  leading: Builder(
    builder: (ctx) => IconButton(
      icon: const Text('☰', style: TextStyle(fontSize: 22)),
      onPressed: () => Scaffold.of(ctx).openDrawer(),
    ),
  ),
)
```

---

### ✅ 5. Drawer 菜单：续写/书架/章节管理/全局图谱/导入小说/设置

**验证结果：** 通过

**证据（drawer_menu.dart）：**
| 菜单项 | Emoji | 路由 |
|--------|-------|------|
| 续写 | ✍️ | AppRoutes.home |
| 我的书架 | 📚 | AppRoutes.bookshelf |
| 章节管理 | 📖 | AppRoutes.chapters |
| 全局图谱 | 🌲 | AppRoutes.graph |
| 导入小说 | 📥 | AppRoutes.import |
| 设置 | ⚙️ | AppRoutes.settings |

---

### ✅ 6. 各菜单项正确跳转到对应 Screen

**验证结果：** 通过

**证据（drawer_menu.dart）：**
```dart
void _navigateTo(BuildContext context, String route) {
  Navigator.of(context).pop();  // 先关闭 Drawer
  if (route == AppRoutes.home && ModalRoute.of(context)?.settings.name == '/') {
    return;  // 已在首页不重复跳转
  }
  Navigator.of(context).pushNamed(route);
}
```

---

## 二、核心功能回归测试

### ✅ 书架：导入小说 → 保存 → 书架显示

**验证结果：** 通过（逻辑完整）

**关键代码路径：**
1. `ImportScreen._pickFile()` → 文件选择
2. `ImportScreen._startImport()` → 调用 `provider.importBook()`
3. `NovelProvider.importBook()`:
   - 保存旧书 `_saveCurrentBookData()`
   - 解析章节 `ChapterService.splitByRegex()`
   - 创建书籍元数据 `NovelBook.fromImport()`
   - **立即写入 Hive** `_saveCurrentBookData()`
   - **验证保存成功** — 加载并验证 `loadNovelDataForBook()`
   - 二次保存机制：验证失败则重新保存，**二次验证仍失败则抛出 `StateError`**

```dart
// importBook 中的二次验证
final verify = await _storage.loadNovelDataForBook(bookId);
if (verify == null) {
  await _saveCurrentBookData();
  final verify2 = await _storage.loadNovelDataForBook(bookId);
  if (verify2 == null) {
    throw StateError('[importBook] 小说保存失败（二次验证不通过），请重启APP后重新导入');
  }
}
```

---

### ✅ 书架：点击小说 → 切换选中书

**验证结果：** 通过

**关键代码路径（novel_provider.dart）：**
```dart
Future<bool> selectBook(String bookId) async {
  final prevBookId = _currentBookId;
  // 1. 保存旧书
  if (prevBookId != null) {
    await _saveCurrentBookData(prevBookId: prevBookId);
  }
  // 2. 加载新书
  _currentBookId = bookId;
  _isLoadingBook = true;
  notifyListeners();
  final hasData = await _loadBookData(bookId);
  _isLoadingBook = false;
  notifyListeners();
  // 3. 保存 last_book_id
  await prefs.setString('last_book_id', bookId);
  return hasData;
}
```
- 正确处理"同一本书"情况（复用 `_loadBookData`）
- 正确处理"旧书数据未丢失"时切换到新书的流程

---

### ✅ 续写：单章续写流程正常

**验证结果：** 通过

**流程：**
1. 选择基准章节 → `selectBaseChapter()`
2. 点击"开始续写" → `generateWrite()`
   - 执行前置校验 `runPrecheck()`
   - 构建 systemPrompt（含人设红线、设定禁区、伏笔、矛盾预警）
   - 调用 API `apiService.generateContinuation()`
   - 质量评估（如开启）→ 不合格则重新生成
   - 保存到 `_continueChain`
   - 自动生成图谱（如开启）`updateGraphWithContinueContent()`
3. 预览显示 `_writePreview`

---

### ✅ 续写：批量续写（进度 + 停止）

**验证结果：** 通过

**证据（write_tab.dart）：**
```dart
void _startBatchContinue(...) {
  showDialog(..., barrierDismissible: false,
    child: _BatchProgressDialog(state: state, onStop: state.stop = true)
  );
  // 循环续写，state.stop=true 时立即退出
  for (int i = 0; i < targetChapters.length; i++) {
    if (state.stop) { Navigator.pop(context); return; }
    ...
  }
}
```

`_BatchProgressDialog` 实时显示：
- 当前进度 `第 X / Y 章`
- 成功/失败计数
- 当前状态文本

---

### ✅ 续写：防空回检测正常工作

**验证结果：** 通过

**证据（novel_provider.dart `generateWrite`）：**
```dart
if (_stopFlag) {
  _writePreview = '';
  return null;
}
// 质量评估后不合格也重新生成
if (!_qualityResult!.isPassed && !_stopFlag) {
  continueContent = await apiService.generateContinuation(...);
  if (_stopFlag) { _writePreview = ''; return null; }
}
```
- `_stopFlag` 在 `stopWrite()` 和 `stopGraphGeneration()` 中设置
- 每次 API 调用前后都检查 `_stopFlag`

---

### ✅ 章节：图谱生成

**验证结果：** 通过

**证据（novel_provider.dart）：**
- 单章：`generateGraphForChapter(chapterId)` → `apiService.generateSingleChapterGraph()`
- 批量：`generateGraphsForAllChapters()` → 循环 + 1s 间隔 + `_stopFlag` 支持停止
- 进度文本：`graphProgressText` 实时更新

---

### ✅ 章节：合规校验

**验证结果：** 通过

**证据（novel_provider.dart）：**
```dart
void validateGraphCompliance() {
  // 8个必填字段检查
  // 字数检查（≥1200）
  // 自洽得分检查
}
Future<List<Map<String, dynamic>>> validateAllChapterGraphsCompliance(...) {
  // 遍历所有章节图谱
  // 7个必填字段 + 字数 + 自洽得分
}
```

---

### ✅ 阅读器：滚动位置恢复

**验证结果：** 通过（v3.0 新增 F4 功能）

**证据（reader_screen.dart）：**
```dart
// 保存滚动位置
Future<void> _persistScrollPosition(String bookId, int chapterId,
    ScrollController controller) async {
  final fraction = (controller.offset / maxExtent).clamp(0.0, 1.0);
  await prefs.setDouble('reader_scroll_${bookId}_$chapterId', fraction);
}

// 恢复滚动位置
class _ChapterPage {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final fraction = prefs.getDouble('reader_scroll_${bookId}_${chapter.id}') ?? 0.0;
    _scrollController.jumpTo(fraction * maxExtent);
  });
}

// dispose 时也保存
@override
void dispose() {
  _saveCurrentScrollPosition();
  _persistScrollPosition(_currentBookId!, _lastChapterId!, _currentScrollController!);
}
```

---

### ✅ 设置：API 配置保存（flutter_secure_storage）

**验证结果：** 通过

**证据（novel_provider.dart）：**
```dart
// _saveSettings 使用 flutter_secure_storage
await _secureStorage.write(key: 'apiBaseUrl', value: _apiBaseUrl);
await _secureStorage.write(key: 'apiKey', value: _apiKey);
await _secureStorage.write(key: 'selectedModel', value: _selectedModel);
await _secureStorage.write(key: 'writeWordCount', value: _writeWordCount.toString());
await _secureStorage.write(key: 'enableQualityCheck', value: _enableQualityCheck.toString());
await _secureStorage.write(key: 'autoUpdateGraphAfterWrite', value: _autoUpdateGraphAfterWrite.toString());
```

**迁移逻辑：** `_loadSettings` 兼容旧版 SharedPreferences 迁移到新存储。

---

## 三、重点 Bug 验证

### ✅ Bug 1: 书架章节丢失 — 已修复

**问题描述：** v2.x 中导入小说后章节丢失（保存验证不通过导致数据丢失）

**修复代码（novel_provider.dart `importBook`）：**
```dart
// 1. 立即同步保存
await _saveCurrentBookData();

// 2. 验证保存成功
final verify = await _storage.loadNovelDataForBook(bookId);
if (verify == null) {
  // 3. 二次保存
  await _saveCurrentBookData();
  final verify2 = await _storage.loadNovelDataForBook(bookId);
  if (verify2 == null) {
    // 4. 二次仍失败则抛出明确错误（不静默丢失数据）
    throw StateError('[importBook] 小说保存失败（二次验证不通过），请重启APP后重新导入');
  }
  debugPrint('[importBook] 二次保存后验证成功');
}
```

**结论：** 修复完整，通过二次验证机制确保数据不丢失。

---

### ✅ Bug 2: 二次验证不通过 — 已修复

**问题描述：** v2.x 中 `loadNovelDataForBook()` 首次返回 null 后无补救

**修复代码（novel_provider.dart）：**

**`importBook` 中的处理：**
```dart
final verify = await _storage.loadNovelDataForBook(bookId);
if (verify == null) {
  await _saveCurrentBookData();  // 重新保存
  final verify2 = await _storage.loadNovelDataForBook(bookId);
  if (verify2 == null) {
    throw StateError('...二次验证不通过...');  // 明确报错
  }
}
```

**`_loadBookData` 中的处理：**
```dart
if (data == null) {
  // 数据不存在时，初始化为空状态（而非报错）
  _chapters = [];
  _chapterGraphMap = {};
  // 并同步更新书架元数据 chapterCount=0
  _bookshelf[nullShelfIdx] = _bookshelf[nullShelfIdx].copyWithMeta(chapterCount: 0);
  return false;  // 返回 false 让调用方处理
}
```

**结论：** 修复完整，二次验证机制到位，异常路径均已处理。

---

## 四、额外发现

### ⚠️ 发现 1: selectBook 切书时潜在数据问题（轻微）

**位置：** `novel_provider.dart` `selectBook()`

**分析：**
```dart
Future<bool> selectBook(String bookId) async {
  final prevBookId = _currentBookId;
  // ...保存旧书...
  if (prevBookId != null) {
    await _saveCurrentBookData(prevBookId: prevBookId);  // ✅ 正确
  }
  _currentBookId = bookId;
  // ...加载新书...
}
```

当前代码**已正确处理**——`_saveCurrentBookData(prevBookId: prevBookId)` 使用显式传入的 `prevBookId`，不受 `_currentBookId` 已更新的影响。但发现：

在切书时，`_saveCurrentBookData` 使用的是**内存中的当前书数据**（`_chapters` 等），这是正确的，因为切书前旧书数据还保留在内存中。

**结论：** 无 bug，但建议未来版本可添加"保存前刷新旧书数据"的注释说明逻辑。

---

### ℹ️ 发现 2: 版本号显示为 v1.0.0

**位置：** `settings_screen.dart` 的关于卡片

```dart
Text('版本 1.0.0 · 小说续写辅助工具')
```

而 Drawer 显示 `v3.0.0`。建议统一为 v3.0.0。

---

## 五、总结

| 验收项 | 结果 |
|--------|------|
| App 启动进入 WriteScreen | ✅ 通过 |
| AppBar 书名+阅读+设置 | ✅ 通过 |
| WriteScreen TabBar | ✅ 通过 |
| Drawer 展开/收起 | ✅ 通过 |
| Drawer 菜单完整 | ✅ 通过 |
| Drawer 路由跳转 | ✅ 通过 |
| 书架：导入→保存→显示 | ✅ 通过 |
| 书架：切书 | ✅ 通过 |
| 续写：单章流程 | ✅ 通过 |
| 续写：批量+停止 | ✅ 通过 |
| 续写：防空回检测 | ✅ 通过 |
| 章节：图谱生成 | ✅ 通过 |
| 章节：合规校验 | ✅ 通过 |
| 阅读器：滚动恢复 | ✅ 通过（F4 新增） |
| 设置：secure_storage | ✅ 通过 |
| Bug 书架章节丢失 | ✅ 已修复 |
| Bug 二次验证不通过 | ✅ 已修复 |

**整体结论：v3.0 UI 重构功能完整，所有核心逻辑验收通过，两个重点 Bug 均已修复。**

---

*本报告基于静态代码审查，未进行实际 APK 运行测试。建议在真机/模拟器上执行完整功能流程测试。*
