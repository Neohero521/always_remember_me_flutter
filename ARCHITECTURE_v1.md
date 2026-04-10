# Always Remember Me Flutter — 架构设计 v1.0

> 解决 P0 阻断问题：核心状态持久化（Hive 方案）

---

## 1. 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 框架 | Flutter 3.x / Dart 3.x | minimum SDK 21 |
| 状态管理 | Provider ^6.1.1 | 现有实现 |
| 持久化（核心） | Hive ^2.2.3 + hive_flutter ^1.1.0 | 本次新增，解决大对象存储 |
| 持久化（轻量） | SharedPreferences ^2.2.2 | 保留，存储 API Key 等小配置 |
| HTTP | http ^1.2.0 | 现有 |
| 文件选择 | file_picker ^6.1.1 | 现有 |
| 路径 | path_provider ^2.1.2 | Hive 初始化需要 |

---

## 2. 状态管理现状（NovelProvider 字段清单）

### 2.1 完整字段分类

| 字段 | 类型 | 大小估算 | 当前持久化 | 需持久化 |
|------|------|---------|-----------|---------|
| `_apiBaseUrl` | String | ~100B | ✅ SharedPreferences | ❌ |
| `_apiKey` | String | ~100B | ✅ SharedPreferences | ❌ |
| `_selectedModel` | String | ~50B | ✅ SharedPreferences | ❌ |
| `_writeWordCount` | int | 4B | ✅ SharedPreferences | ❌ |
| `_enableQualityCheck` | bool | 1B | ✅ SharedPreferences | ❌ |
| `_autoUpdateGraphAfterWrite` | bool | 1B | ✅ SharedPreferences | ❌ |
| `_readerFontSize` | int | 4B | ✅ SharedPreferences | ❌ |
| `_currentChapterId` | int? | 4B | ✅ SharedPreferences | ❌ |
| `_chapters` | `List<Chapter>` | **MB级** | ❌ | ✅ **P0** |
| `_currentRegexIndex` | int | 4B | ❌ | ✅ |
| `_lastParsedText` | String | ~1MB+ | ❌ | ✅ |
| `_sortedRegexList` | `List<RegexMatchResult>` | ~KB | ❌ | ✅ |
| `_customRegex` | String | ~100B | ❌ | ✅ |
| `_chapterGraphMap` | `Map<int, Map<String,dynamic>>` | **MB级** | ❌ | ✅ **P0** |
| `_mergedGraph` | `Map<String,dynamic>?` | **MB级** | ❌ | ✅ **P0** |
| `_batchMergedGraphs` | `List<Map<String,dynamic>>` | **MB级** | ❌ | ✅ **P0** |
| `_continueChain` | `List<ContinueChapter>` | **MB级** | ❌ | ✅ **P0** |
| `_continueIdCounter` | int | 4B | ❌ | ✅ |
| `_selectedBaseChapterId` | String | ~50B | ❌ | ✅ |
| `_writePreview` | String | ~10KB | ❌ | ✅ |
| `_precheckResult` | `PrecheckResult?` | ~5KB | ❌ | ✅ |
| `_qualityResult` | `QualityResult?` | ~5KB | ❌ | ✅ |
| `_qualityResultShow` | bool | 1B | ❌ | ✅ |
| `_graphComplianceResult` | String? | ~500B | ❌ | ✅ |
| `_graphCompliancePass` | bool? | 1B | ❌ | ✅ |

### 2.2 当前 `_saveSettings` / `loadSettings` 覆盖范围

**仅覆盖 8 个字段（全部为小数据）：**
```
apiBaseUrl, apiKey, selectedModel, writeWordCount,
enableQualityCheck, autoUpdateGraphAfterWrite,
readerFontSize, currentChapterId
```

**P0 阻断字段全部未持久化：**
`chapters[]`, `chapterGraphMap{}`, `continueChain[]`, `mergedGraph{}`, `batchMergedGraphs[]`

---

## 3. 持久化方案选型

| 方案 | 优点 | 缺点 | 结论 |
|------|------|------|------|
| A. 扩展 SharedPreferences | 无新依赖 | 只能存 KB 级；章节+图谱 MB 级会导致 ANR / OOM | ❌ 不适合 |
| B. Hive | 支持大对象（MB级）+ 压缩 + 类型安全 + 速度快；Flutter 生态成熟；无需 schema 迁移（轻量 adapter） | 需引入新依赖 | ✅ **推荐** |
| C. sqflite | 结构化查询能力 | Schema 迁移复杂；章节文本需拆表或 JSON blob；收益成本比低 | ❌ 过度设计 |

**选型结论：Hive ^2.2.3**

Hive 天然适合本场景：
- `Box` 直接存 `List<Map>` / `Map` — 无需 ORM
- 支持 `gzip` 压缩（`HiveAesCodec`）— 章节内容+图谱数据压缩后体积可减少 70%+
- `TypeAdapter` 序列化 Chapter/ContinueChapter — 类型安全
- 异步读写，不阻塞 UI 线程
- 已有 `path_provider` 依赖，无需额外路径配置

---

## 4. Hive 数据结构设计

### 4.1 Box 划分

```
boxes:
├── novelBox (name: 'novel_data')
│   ├── chapters          → List<Chapter>            (Hive TypeId: 10)
│   ├── chapterGraphMap   → Map<int, String>          (key=int, value=JSON string)
│   ├── continueChain     → List<ContinueChapter>    (Hive TypeId: 11)
│   ├── continueIdCounter → int
│   ├── mergedGraph       → String?                  (JSON string)
│   ├── batchMergedGraphs → List<String>             (List of JSON strings)
│   ├── lastParsedText    → String
│   ├── currentRegexIndex → int
│   ├── customRegex       → String
│   ├── selectedBaseChapterId → String
│   ├── writePreview      → String
│   ├── precheckResult    → String?                  (JSON string)
│   ├── qualityResult     → String?                  (JSON string)
│   ├── qualityResultShow → bool
│   └── graphCompliance   → String?                 (JSON string)
│
└── settingsBox (name: 'app_settings')  ← 替代 SharedPreferences（可选迁移）
    ├── apiBaseUrl           → String
    ├── apiKey               → String
    ├── selectedModel        → String
    ├── writeWordCount        → int
    ├── enableQualityCheck    → bool
    ├── autoUpdateGraphAfterWrite → bool
    ├── readerFontSize        → int
    └── currentChapterId      → int?
```

### 4.2 为什么 `chapterGraphMap` 用 `Map<int, String>` 而不是 `Map<int, Map<String,dynamic>>`？

- Hive 的 `Map<K, V>` 要求 `K` 和 `V` 都是 Hive 适配的类型
- `Map<String, dynamic>` 不是Hive内建类型，无法直接存储
- 解决方案：将 `Map<String, dynamic>` 序列化为 **JSON string** 再存入
- 读取时用 `json.decode()` 反序列化
- 同理：`mergedGraph` 存 `String?`，`batchMergedGraphs` 存 `List<String>`

### 4.3 Hive TypeAdapter 注册表

| TypeId | 类型 | 说明 |
|--------|------|------|
| 10 | `Chapter` | 已在 `models/chapter.dart` |
| 11 | `ContinueChapter` | 已在 `models/chapter.dart` |

> 注意：`RegexMatchResult` / `ChapterRegexPreset` 为临时解析状态，不需要持久化。

---

## 5. 迁移计划（SharedPreferences → Hive）

### 5.1 第一阶段：双写兼容（0→1）
- 新增 `StorageService` 基于 Hive
- `loadSettings()` 优先从 Hive 读；若 Hive 为空则降级读 SharedPreferences
- `_saveSettings()` 同时写 Hive 和 SharedPreferences（SharedPreferences 端不再更新新字段）

### 5.2 第二阶段：完全迁移（1→2）
- Hive 稳定运行后，移除 SharedPreferences 的双写
- 保留 SharedPreferences 是为了旧版本用户升级时数据不丢失

### 5.3 数据清理策略
- 用户每次成功 `parseChapters` 时，清除旧的 `lastParsedText` + `sortedRegexList`
- `parseChaptersByWordCount` 清除 `_customRegex`
- 初始化时检测 Hive 版本号字段，若版本号旧则提示用户是否清除旧数据

---

## 6. 实施步骤

### Step 1: 添加依赖

```yaml
# pubspec.yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.2   # 已有

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
```

### Step 2: 生成 TypeAdapter

在 `models/chapter.dart` 中使用 `@HiveType` / `@HiveField` 注解：

```dart
// Chapter → TypeId 10
// ContinueChapter → TypeId 11
```

运行 `dart run build_runner build` 生成 `chapter.g.dart`。

### Step 3: 创建 StorageService

```
lib/services/storage_service.dart
```

核心接口：
```dart
abstract class StorageService {
  Future<void> init();
  Future<void> saveNovelData(NovelData data);
  Future<NovelData?> loadNovelData();
  Future<void> clearNovelData();
}
```

### Step 4: 改造 NovelProvider

- 注入 `StorageService`
- `loadSettings()` 改为 `await StorageService.loadNovelData()`
- 每个状态变更后 **debounce** 异步写 Hive（300ms 延迟，避免频繁 IO）
- 对 `_chapterGraphMap`、`mergedGraph`、`batchMergedGraphs`、`continueChain`、`chapters` 这些大数据字段使用 **gzip 压缩**（通过 Hive 的 `compression` 选项）

### Step 5: 初始化改造

在 `main.dart` 的 `runApp` 之前：
```dart
await Hive.initFlutter();
Hive.registerAdapter(ChapterAdapter());        // TypeId 10
Hive.registerAdapter(ContinueChapterAdapter()); // TypeId 11
await Hive.openBox('novel_data');
```

---

## 7. 风险评估

| 风险 | 等级 | 缓解措施 |
|------|------|---------|
| Hive 数据损坏导致崩溃 | 低 | 初始化时做 try-catch；损坏时清空并提示用户 |
| 首次启动大文件导入慢（ANR） | 中 | `loadNovelData` 异步执行；启动画面加载 |
| 压缩/解压CPU开销 | 低 | Hive 内置压缩，开销可忽略 |
| TypeAdapter 版本不兼容 | 低 | 预留 `typeId` 扩展空间；设计 `version` 字段 |
| 内存压力（大章节列表） | 中 | 按需加载：`loadChapters(range)` 或懒加载 |
| 从旧 SharedPreferences 迁移失败 | 低 | 双写兼容；降级兜底 |

---

## 8. 性能估算

| 数据 | 原始大小 | gzip 压缩后 | Hive 存储 |
|------|---------|-----------|---------|
| 100章 × 5万字/章 | ~50MB | ~5MB | ~5MB |
| 100个章节图谱 | ~20MB | ~3MB | ~3MB |
| 10个续写章节 | ~20MB | ~3MB | ~3MB |
| 1个合并图谱 | ~5MB | ~1MB | ~1MB |
| **合计** | **~100MB** | **~12MB** | **~12MB** |

> Hive 压缩后总存储约 12MB，完全可接受。

---

## 9. 关键设计决策

1. **不迁移已有 SharedPreferences**：API Key 等小数据保留在 SharedPreferences，避免迁移复杂度
2. **大数据压缩存储**：章节内容和图谱 JSON 使用 Hive gzip 压缩，节省存储 + 加速 IO
3. **状态变更 debounce**：避免每次 `notifyListeners` 都触发 Hive 写入；合并写入延迟 300ms
4. **懒加载 `sortedRegexList`**：`sortedRegexList` 和 `lastParsedText` 不在启动时加载，在 `parseChapters` 时按需恢复
5. **图谱以 String 存储**：`chapterGraphMap` 的 value 存 JSON string 而非原生 Map，简化 TypeAdapter 设计
