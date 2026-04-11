# Always Remember Me Flutter — 迭代计划 v1.0

> 项目总指挥：鲸鱼娘 🐋
> 制定日期：2026-04-11

---

## 一、功能优先级列表

### P0 — 必须做（直接影响核心流程）

| # | 功能 | 说明 |
|---|------|------|
| P0-1 | **书架 Bug 验证与修复** | 点击书架后章节丢失，需验证 `selectBook` / `_loadBookData` / Hive 持久化链路 |
| P0-2 | **魔改章节图谱更新 UI 按钮** | `NovelProvider.updateModifiedChapterGraph()` 已存在，但 WriteScreen 无触发入口 |
| P0-3 | **一键批量续写** | 核心功能未实现，需从选章节→循环调用 `generateWrite` →追加到链条 |

### P1 — 重要（体验明显提升）

| # | 功能 | 说明 |
|---|------|------|
| P1-1 | **章节阅读器优化** | 字号持久化已有基础，但 App 重启后未恢复；阅读进度（滚动位置）未保存 |
| P1-2 | **图谱合规性校验 UI 按钮** | `validateGraphCompliance()` 已存在，但 `chapters_screen.dart` 的 `check_graph_status` 只校验章节图谱，未调用合并图谱合规校验 |

### P2 — 优化（锦上添花）

| # | 功能 | 说明 |
|---|------|------|
| P2-1 | **ReaderScreen 图谱快捷入口** | 阅读章节时可直接查看/刷新该章图谱 |
| P2-2 | **批量续写进度可视化** | 显示当前第几章、成功率等 |
| P2-3 | **书架书籍封面/缩略图** | 当前占位符偏简陋 |

---

## 二、每个功能的核心开发步骤

---

### P0-1：书架 Bug 验证与修复

**问题描述**
点击书架卡片 → `selectBook(book.id)` → 切换后章节列表为空，或章节数与元数据不一致。

**根因分析（代码级）**

代码中 `selectBook` 的逻辑：
```
prevBookId = _currentBookId（切换前的书）
await _saveCurrentBookData(prevBookId: prevBookId)  // 保存旧书
await _loadBookData(bookId)                         // 加载新书
```

可能问题点：
1. `_loadBookData` 在数据为空时返回 `false`，但 `selectBook` 返回值只影响 snackbar，不阻断流程
2. `Hive` 写入可能存在延迟，`verify` 验证时机过早
3. `importBook` 中 cacheKey 比对逻辑 `_lastImportCacheKey == cacheKey` 在某些边界下错误复用旧章节
4. `bookshelf` 元数据 `chapterCount` 与实际 Hive 中的章节数可能不一致（启动时校正逻辑存在但可能不完整）

**验证步骤**
1. 清空 Hive 数据（删盒子的 box 文件），重新导入一本书，确认章节数正确
2. 切到其他书（或重新进入 App），再切回来，观察章节是否还在
3. 检查 `Hive` 目录中该书的 box 是否存在且非空
4. 在 `_loadBookData` 关键节点加 `debugPrint`，确认数据流向

**修复方案（待验证后确定）**
- 方案A：引入版本号字段，每次导入自增，cacheKey 带上版本号确保强制重解析
- 方案B：`importBook` 时强制重新解析，不走 cacheKey 复用逻辑
- 方案C：修复 `_loadBookData` 的数据恢复路径（null safe）

---

### P0-2：魔改章节图谱更新 UI 按钮

**现状**
- `NovelProvider.updateModifiedChapterGraph(chapterId, modifiedContent)` ✅ 已实现
- `WriteScreen` 有 `_editedContent` 变量和 `_contentController`，支持编辑基准章节内容
- 但编辑后没有任何"更新图谱"按钮

**开发步骤**

```
Step 1: WriteScreen 增加"保存魔改"和"更新图谱"按钮
  - 位置：基准章节内容预览区下方（_isEditing == true 时显示）
  - 逻辑：
    a. 用户修改内容 → 点"保存魔改" → 调用 provider 内部更新章节内容（不调 API）
    b. 点"更新图谱" → 调用 updateModifiedChapterGraph → 成功后刷新 UI

Step 2: 增加状态反馈
  - 更新图谱时显示 loading
  - 完成后 snackbar 提示

Step 3: 在章节详情页（chapters_screen bottomSheet）也加"魔改后更新图谱"按钮
  - 已有"重新生成"按钮，需确认是否复用或新增"仅更新内容"
```

---

### P0-3：一键批量续写

**现状**
- `generateWrite({String? modifiedContent})` ✅ 单章续写已实现
- `continueFromChain(chainId)` ✅ 链条续写已实现
- UI 上每次只能手动触发一次

**开发步骤**

```
Step 1: WriteScreen 增加"批量续写"Tab 或模式切换
  - 入口：当前"AI续写" Tab 顶部加 TabBar："单章续写 / 批量续写"
  - 批量模式 UI：
    - 起始章节选择（下拉）
    - 结束章节选择（下拉）
    - 目标续写章节数（默认5章）
    - 预估时间显示

Step 2: 批量续写核心逻辑（NovelProvider 新增方法）
  ```
  Future<List<ContinueChapter>> batchGenerateWrite({
    required int startChapterId,
    required int endChapterId,  // 或直接传目标数量
    Function(int current, int total)? onProgress,
  })
  ```
  - 循环 start→end，依次调用 generateWrite()
  - 每章成功后追加到 _continueChain
  - 支持中断（stopFlag）

Step 3: 进度可视化
  - WriteScreen 批量模式下显示进度条
  - 显示：当前第X章/共Y章，正在续写"第N章"...
  - 支持"停止"按钮

Step 4: 批量完成后
  - 自动合并全量图谱（可选弹窗询问）
  - 显示生成结果摘要
```

---

### P1-1：章节阅读器优化

**现状**
- 字号控制：`_lastFontSize` 缓存，`dispose` 时保存 ✅
- 重启后字号恢复：`_loadSettings` 从 SharedPreferences 读取 ✅
- 阅读进度（章节ID）：`_currentChapterId` ✅
- **缺失**：滚动位置（paragraph index / scroll offset）未保存

**开发步骤**

```
Step 1: 在 Chapter 模型增加字段
  - int? lastReadScrollOffset  // 滚动偏移量
  - (可选) int? lastReadParagraphIndex  // 段落索引

Step 2: ReaderScreen 滚动位置监听
  - SingleChildScrollView 加 ScrollController
  - onScroll 记录 offset（或取当前可见段落 index）
  - 离开页面时保存

Step 3: 进入章节时恢复滚动位置
  - WidgetsBinding.instance.addPostFrameCallback 中 scrollTo(offset)

Step 4: ReaderScreen 顶部状态栏增加"阅读位置恢复"提示
```

---

### P1-2：图谱合规性校验 UI 按钮

**现状**
- `NovelProvider.validateGraphCompliance()` ✅ 已实现（检查合并图谱8字段+字数）
- `ChaptersScreen` 的 PopupMenu 有 `check_graph_status`，但只调用 `validateChapterGraphStatus()`（章节级），**不检查合并图谱合规性**

**开发步骤**

```
Step 1: 在 chapters_screen 的 bottomSheet 详情页增加"图谱合规性校验"按钮
  - 位置：知识图谱查看区上方
  - 调用 provider.validateGraphCompliance()
  - 结果弹窗显示：
    - 通过：显示字数 + 逻辑自洽性得分
    - 不通过：显示缺少哪些字段 + 原因

Step 2: 考虑在 chapters_screen 顶部区域加一个"图谱合规状态"徽章
  - 绿标：通过 / 红标：未通过 / 灰标：未校验
```

---

## 三、整体里程碑预估

```
里程碑 M1（1-2天）: Bug修复 + 基础UI补全
  ✅ P0-1 书架Bug验证与修复
  ✅ P0-2 魔改章节图谱更新按钮
  → 交付物：可测试 APK（内部）

里程碑 M2（2-3天）: 核心功能完成
  ✅ P0-3 一键批量续写
  ✅ P1-1 阅读器优化

里程碑 M3（1-2天）: 完善收尾
  ✅ P1-2 图谱合规性校验 UI
  ✅ 整体自测 + 打包验证

预计总工期：4-7天（视哥哥测试反馈轮次）
```

---

## 四、需要哥哥确认的问题

### Q1. 批量续写边界确认
- 批量续写的范围是**基于已有章节**续写到第N章，还是**从某章开始自动续写N个新章节**？
- 当前 `generateWrite` 是以"基准章节"为起点续写"下一章"；批量续写是按顺序从第X章续写到第Y章（共Y-X+1章），还是从最后一个已有章节继续续写新N章？

### Q2. 书架Bug必现条件
- 哥哥能否描述**精确复现步骤**？比如：
  1. 导入某本书 → 解析N章 ✅
  2. 退出 APP（或者不退出？）
  3. 再次打开 → 点击书架 → 章节丢失
- 是每次都复现，还是偶发？

### Q3. 批量续写完成后
- 批量续写完成后，是否需要**自动导出**到 TXT 文件（方便哥哥复制到其他阅读器）？
- 还是只需要保存到 App 内即可？

### Q4. 阅读器字号
- 字号范围当前是 12-28，是否合适？需要增加更多档位（如 10-36）？

### Q5. APK 构建方式
- 目前构建 APK 用的是什么命令？（`flutter build apk --release`？）
- 是否需要配置签名？

---

以上为「迭代计划 v1.0」，请哥哥过目后确认方向，我们即可开工！💪
