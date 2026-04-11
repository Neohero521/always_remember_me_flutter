# Always Remember Me v5.0 重构执行计划

> 基于架构文档：`基于你提出的小说续写App需求_1775914533069_1b2975.txt`
> 生成日期：2026-04-11

---

## 一、项目现状总结

| 项目 | 当前状态 | 目标状态 |
|------|----------|----------|
| Flutter版本 | 3.0+ (SDK约束 `<4.0.0`) | Flutter 3.42 |
| 状态管理 | Provider | Riverpod 3.0 |
| 本地存储 | Hive | Drift 2.12.0 |
| 架构模式 | 混合结构（无明确分层） | Clean Architecture + Feature-based |
| 目录结构 | 按类型组织（screens/providers/models） | 按功能模块组织 |

### 当前项目主要模块
- **小说导入**：`import_screen.dart` + `file_picker`
- **书架管理**：`bookshelf_screen.dart` + `storage_service.dart`
- **章节管理**：`chapters_screen.dart` + `chapter_service.dart`
- **阅读器**：`reader_screen.dart`
- **续写功能**：`write_screen.dart` + `novel_api_service.dart`
- **图谱功能**：`graph_viewer_screen.dart`
- **全局状态**：`novel_provider.dart`（单文件 ~1000行）

---

## 二、重构原则

1. **渐进式重构**：不追求一步到位，每次聚焦一个阶段目标
2. **功能优先**：重构过程中保持现有功能可用
3. **可回滚**：每个阶段完成后可独立运行、验证
4. **增量迁移**：新架构与旧代码共存，逐步替换

---

## 三、重构阶段计划

### Phase 1：架构重构（第1-2周）

**目标**：建立新的项目结构和状态管理基础设施

#### 1.1 目录结构迁移（3-5天）

**现有结构**：
```
lib/
├── main.dart
├── models/
│   ├── novel_book.dart
│   ├── chapter.dart
│   └── knowledge_graph.dart
├── providers/
│   └── novel_provider.dart   # 单文件包含所有状态
├── screens/
│   ├── bookshelf/
│   ├── import/
│   ├── chapters/
│   ├── reader/
│   ├── write/
│   ├── graph/
│   └── settings_screen.dart
├── services/
│   ├── storage_service.dart
│   ├── chapter_service.dart
│   └── novel_api_service.dart
├── app/
│   ├── app_shell.dart
│   ├── router.dart
│   └── drawer_menu.dart
└── theme/
```

**目标结构**（Clean Architecture + Feature-based）：
```
lib/
├── main.dart
├── app/                          # 应用级配置
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/                         # 核心基础设施（无功能依赖）
│   ├── di/                       # 依赖注入配置
│   ├── network/                  # HTTP 客户端封装
│   ├── database/                 # Drift 数据库初始化
│   │   └── database.dart
│   │   └── tables/
│   │       ├── novels.dart
│   │       ├── chapters.dart
│   │       └── chapter_graphs.dart
│   ├── utils/                    # 通用工具（UUID、JSON等）
│   └── exceptions/               # 统一异常处理
├── features/                     # 功能模块（各自独立的三层架构）
│   ├── bookshelf/
│   │   ├── domain/               # 领域层（业务实体、仓库接口、用例）
│   │   │   ├── models/           # NovelBook entity
│   │   │   ├── repositories/     # IBookshelfRepository 接口
│   │   │   └── usecases/
│   │   ├── data/                 # 数据层（仓库实现、数据源）
│   │   │   ├── repositories/     # BookshelfRepository 实现
│   │   │   └── datasources/      # LocalBookshelfDataSource
│   │   └── presentation/         # 表示层（Provider/Riverpod、Widgets）
│   │       ├── providers/        # Riverpod providers
│   │       ├── screens/
│   │       └── widgets/
│   ├── chapter_management/
│   │   ├── domain/
│   │   │   ├── models/           # Chapter entity
│   │   │   ├── repositories/     # IChapterRepository 接口
│   │   │   └── usecases/        # ParseChapterUseCase, SplitByWordCountUseCase
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   └── presentation/
│   │       ├── providers/        # ChapterNotifier (Riverpod)
│   │       ├── screens/
│   │       └── widgets/
│   ├── reader/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── writing/                   # 续写功能
│   │   ├── domain/
│   │   │   ├── models/          # ContinueChapter, PrecheckResult, QualityResult
│   │   │   ├── repositories/     # IWritingRepository 接口
│   │   │   └── usecases/        # GenerateWriteUseCase, RunPrecheckUseCase
│   │   ├── data/
│   │   │   ├── repositories/     # WritingRepository 实现
│   │   │   └── datasources/     # RemoteAIDataSource
│   │   └── presentation/
│   │       ├── providers/        # WritingNotifier (Riverpod)
│   │       ├── screens/
│   │       └── widgets/
│   └── graph/                     # 图谱功能
│       ├── domain/
│       │   ├── models/          # ChapterGraph entity
│       │   ├── repositories/    # IGraphRepository 接口
│       │   └── usecases/        # GenerateGraphUseCase, MergeGraphsUseCase
│       ├── data/
│       │   ├── repositories/
│       │   └── datasources/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
└── common_ui/                    # 跨功能复用 UI
    ├── widgets/
    │   ├── loading_indicator.dart
    │   ├── error_view.dart
    │   └── confirm_dialog.dart
    └── styles/
        └── app_theme.dart
```

**执行步骤**：
1. 创建新目录骨架（不删除旧文件）
2. 将 `core/utils`、`core/exceptions`、`core/di` 基础文件迁移/新建
3. 创建 `core/database` Drift schema 骨架（表结构，暂不迁移数据）
4. 按优先级迁移：`features/bookshelf` → `features/chapter_management` → `features/writing` → `features/graph` → `features/reader`
5. 旧文件标记为 deprecated（添加 `// TODO[v5]: 迁移后删除`），新代码全部走新架构

#### 1.2 状态管理迁移：Provider → Riverpod（5-7天）

**当前问题**：
- `NovelProvider` 单文件 ~1000行，包含所有状态和业务逻辑
- 状态与UI强耦合，难以测试
- Provider 的依赖注入能力弱

**Riverpod 3.0 迁移策略**：
```
迁移单位：按功能模块迁移，每次只迁移一个 feature 的状态
```

**迁移对照表**：

| 旧 Provider 状态 | 新 Riverpod 结构 |
|----------------|----------------|
| `NovelProvider._chapters` | `chapterProvider: StateNotifierProvider<ChapterNotifier, ChapterState>` |
| `NovelProvider._chapterGraphMap` | `graphProvider: StateNotifierProvider<GraphNotifier, GraphState>` |
| `NovelProvider._continueChain` | `writingProvider: StateNotifierProvider<WritingNotifier, WritingState>` |
| `NovelProvider._mergedGraph` | `mergedGraphProvider: FutureProvider` |
| `NovelProvider._bookshelf` | `bookshelfProvider: StateNotifierProvider<BookshelfNotifier, BookshelfState>` |
| `NovelProvider._apiConfig` | `configProvider: StateNotifierProvider<ConfigNotifier, AppConfig>` |
| `NovelProvider._isGeneratingGraph` | 内含于 `graphProvider` |
| `NovelProvider._isGeneratingWrite` | 内含于 `writingProvider` |

**具体执行**：
1. 安装依赖：`riverpod: ^3.0.0`（注意不是 `flutter_riverpod`，Riverpod 3.0 直接支持 Flutter）
2. 创建 `core/di/providers.dart`，集中管理所有 Provider 初始化
3. 按模块逐个迁移：
   - Phase 1.2.1：`configProvider`（最简单，无依赖）
   - Phase 1.2.2：`bookshelfProvider`
   - Phase 1.2.3：`chapterProvider`
   - Phase 1.2.4：`graphProvider`
   - Phase 1.2.5：`writingProvider`
4. 迁移完成后，旧 `NovelProvider` 保留为 thin wrapper（委托给新 Providers），逐步废弃
5. 使用 `riverpod_generator` + `freezed` 减少样板代码

#### Phase 1 交付物
- [ ] 新目录骨架创建完毕
- [ ] Drift 数据库 schema 定义完成
- [ ] 全部6个功能模块的 Riverpod Provider 就位
- [ ] 旧 `NovelProvider` 标记为 deprecated
- [ ] App 可在旧/新架构间切换验证功能完整性

---

### Phase 2：数据库重构（第2-3周）

**目标**：Hive → Drift，消除 Hive 依赖

#### 2.1 Drift Schema 设计

根据当前 Hive 数据模型，设计 Drift 表结构：

```dart
// novels 表
class Novels extends Table {
  TextColumn get id => text()(primaryKey)();
  TextColumn get title => text()();
  TextColumn get author => text().withDefault(const Constant(''))();
  TextColumn get cover => text().nullable()();
  TextColumn get introduction => text().nullable()();
  IntColumn get chapterCount => integer().withDefault(const Constant(0))();
  RealColumn get readProgress => real().withDefault(const Constant(0.0))();
  IntColumn get lastReadChapterId => integer().nullable()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// chapters 表
class Chapters extends Table {
  TextColumn get id => text()(primaryKey)();
  TextColumn get novelId => text().references(Novels, #id)();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  TextColumn get content => text()();  // TEXT 类型，大字段
  BoolColumn get hasGraph => boolean().withDefault(const Constant(false))();
  IntColumn get wordCount => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

// chapter_graphs 表（JSON 字符串存储）
class ChapterGraphs extends Table {
  TextColumn get id => text()(primaryKey)();
  TextColumn get chapterId => text()();
  TextColumn get novelId => text()();
  TextColumn get type => text().withDefault(const Constant('characterRelationship'))();
  TextColumn get data => text()();  // JSON string
  DateTimeColumn get createdAt => dateTime()();
}

// merged_graphs 表（全量/分批合并结果）
class MergedGraphs extends Table {
  TextColumn get id => text()(primaryKey)();
  TextColumn get novelId => text()();
  TextColumn get batchNumber => integer().nullable()();  // null = 全量合并
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// continue_chapters 表（续写链条）
class ContinueChapters extends Table {
  IntColumn get id => integer()(primaryKey).autoIncrement()();
  TextColumn get novelId => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get baseChapterId => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// app_settings 表（配置）
class AppSettings extends Table {
  TextColumn get key => text()(primaryKey)();
  TextColumn get value => text()();
}
```

#### 2.2 数据迁移策略

**原则：Hive 只读，Drift 写入，新架构完全弃用 Hive**

1. **首次启动迁移**（v5.0.0 安装/升级时）：
   - 检测 Hive 数据是否存在
   - 读取 Hive 数据，写入 Drift
   - 验证数据完整性后，保留 Hive 数据文件（备份，不删除）
   - 后续运行完全走 Drift

2. **数据完整性校验**：
   - 迁移后比对章节数量、字数总和、图谱数量
   - 任何不一致记录到日志，提示用户

#### 2.3 DAO/Repository 实现

- 每个功能模块的 Repository 接口在 `domain/` 层
- 实现类在 `data/`，通过依赖注入获取 Drift DAO
- 迁移期间的 backward compatibility 通过 `LegacyHiveDataSource` 临时类处理

#### Phase 2 交付物
- [ ] Drift schema 全部定义并生成代码
- [ ] 所有 Repository 实现切换到 Drift
- [ ] Hive → Drift 迁移脚本可执行
- [ ] 数据完整性校验通过
- [ ] Hive 依赖从 pubspec.yaml 移除

---

### Phase 3：核心功能模块重构（第3-5周）

**目标**：按功能模块逐步重构业务逻辑，从依赖最强的模块开始

#### 3.1 重构顺序

| 顺序 | 模块 | 工作量 | 依赖关系 |
|------|------|--------|----------|
| 1 | bookshelf（书架） | 小 | 无 |
| 2 | chapter_management（章节管理） | 中 | 依赖 bookshelf 的 domain models |
| 3 | reader（阅读器） | 小 | 依赖 chapter_management |
| 4 | writing（续写） | 大 | 依赖 chapter_management, graph, AI service |
| 5 | graph（图谱） | 大 | 依赖 chapter_management |

#### 3.2 UseCase 提取

每个模块的核心业务逻辑提取为 UseCase，便于测试和复用：

**chapter_management 模块**：
```dart
// ParseChapterUseCase - 章节解析
class ParseChapterUseCase {
  Result<List<Chapter>> execute(String text, {String? customRegex});
}

// SplitByWordCountUseCase - 按字数分章
class SplitByWordCountUseCase {
  Result<List<Chapter>> execute(String text, int wordCount);
}
```

**writing 模块**：
```dart
// GenerateWriteUseCase - 续写生成
class GenerateWriteUseCase {
  Future<Result<String>> execute({
    required String baseContent,
    required int baseChapterId,
    required int targetWordCount,
    Map<String, dynamic>? mergedGraph,
    bool enableQualityCheck,
  });
}

// RunPrecheckUseCase - 前置校验
class RunPrecheckUseCase {
  Future<Result<PrecheckResult>> execute(int baseChapterId, {String? modifiedContent});
}
```

**graph 模块**：
```dart
// GenerateSingleGraphUseCase - 单章节图谱生成
class GenerateSingleGraphUseCase {
  Future<Result<ChapterGraph>> execute(Chapter chapter);
}

// BatchMergeGraphsUseCase - 分批图谱合并
class BatchMergeGraphsUseCase {
  Future<Result<ChapterGraph>> execute(List<ChapterGraph> graphs, {int batchNumber, int totalBatches});
}

// MergeAllGraphsUseCase - 全量图谱合并
class MergeAllGraphsUseCase {
  Future<Result<ChapterGraph>> execute(List<ChapterGraph> graphs);
}
```

#### 3.3 AI 服务抽象

当前 AI 服务硬编码在 `NovelApiService` 中。重构后：
- 定义 `AIModel` 抽象接口
- 实现类：`OpenAIAdapter`、`GeminiAdapter`、`LocalModelAdapter`
- 使用 ` Riverpod` 的 `Provider<AiModel>` 支持运行时切换

```dart
abstract class AIModel {
  Future<ChapterGraph> generateSingleChapterGraph(...);
  Future<ChapterGraph> batchMergeGraphs(...);
  Future<String> generateContinuation({...});
  Future<PrecheckResult> precheckContinuation({...});
  Future<QualityResult> evaluateQuality({...});
}
```

#### Phase 3 交付物
- [ ] bookshelf 模块完整重构，UseCase 覆盖全部业务逻辑
- [ ] chapter_management 模块重构，章节解析逻辑全部抽离
- [ ] reader 模块重构
- [ ] graph 模块重构，图谱生成/合并逻辑抽离
- [ ] writing 模块重构，续写流程 UseCase 化
- [ ] AI 服务抽象层就绪，支持多模型切换

---

### Phase 4：UI/UX 重构（第5-7周）

**目标**：在新的架构基础上，按优先级重新构建 UI

#### 4.1 重构原则

1. **组件化优先**：通用组件先进入 `common_ui/`，页面再依赖组件
2. **状态驱动 UI**：UI 只负责展示，状态完全由 Riverpod 驱动
3. **响应式设计**：利用 Riverpod 的响应式特性，消除不必要的 `setState`
4. **动画与交互优化**：Flutter 3.42 Impeller 2.0 渲染优化

#### 4.2 页面重构优先级

| 优先级 | 页面 | 改动点 |
|--------|------|--------|
| P0 | BookshelfScreen | 书架列表，切换书籍 |
| P0 | ChaptersScreen | 章节列表，批量操作 |
| P0 | WriteScreen | 续写主界面 |
| P1 | ReaderScreen | 阅读器，优化滚动性能 |
| P1 | GraphViewerScreen | 图谱可视化 |
| P2 | ImportScreen | 导入界面 |
| P2 | SettingsScreen | 设置界面 |

#### 4.3 通用 UI 组件建设

优先构建以下通用组件（其他页面可复用）：
- `LoadingIndicator` - 加载状态
- `ErrorView` - 错误展示（带重试按钮）
- `EmptyStateView` - 空状态占位
- `ConfirmDialog` - 确认对话框
- `StatusBadge` - 状态徽章（生成中/成功/失败）
- `GraphViewer` - 图谱可视化组件（基于 `graphview` 库）

#### 4.4 主题/样式统一

- 将分散在 `v4_colors.dart`、`game_console_theme.dart` 中的主题整合
- 建立统一 `AppTheme`，支持亮/暗模式
- 使用 Flutter 3.42 的 `ColorScheme.fromSeed()` 保持色彩一致性

#### Phase 4 交付物
- [ ] `common_ui/` 组件库完善
- [ ] 全部页面完成 UI 重构
- [ ] 主题系统统一
- [ ] 亮/暗模式支持

---

### Phase 5：测试与部署（第7-8周）

#### 5.1 测试策略

**单元测试**（优先）：
- 每个 UseCase 的测试用例
- Repository Mock 测试
- Riverpod Provider 测试（使用 `mockito` + `riverpod_test`）

**集成测试**：
- 书架 CRUD 流程测试
- 章节解析 → 图谱生成 → 续写完整流程测试

**手动验收测试清单**：
- [ ] 书架：添加、切换、删除书籍
- [ ] 导入：文件选择、分章预览、分章结果
- [ ] 章节：列表展示、批量选择、删除
- [ ] 阅读：章节切换、字号调节、阅读进度
- [ ] 图谱：单章节生成、批量生成、全量合并、导出
- [ ] 续写：前置校验、生成、质量评估、链条管理
- [ ] 设置：API 配置保存、切换模型

#### 5.2 性能优化

- 使用 `ListView.builder` 优化长列表
- 图谱 JSON 大数据分段加载（Drift TEXT 字段懒加载）
- 续写/图谱生成使用 `Isolate` 避免 UI 阻塞
- Riverpod 状态访问优化（避免不必要的 rebuild）

#### 5.3 部署准备

- 更新 `pubspec.yaml` 版本为 `5.0.0`
- 生成 signed APK/AAB
- 应用商店材料更新（截图、描述）
- 更新 `README.md`（新架构说明）

---

## 四、风险评估

### 风险 1：Provider → Riverpod 迁移

| 风险 | 等级 | 缓解措施 |
|------|------|----------|
| 学习曲线陡峭，团队不熟悉 Riverpod 3.0 | 中 | Phase 1 专门安排学习时间；新旧并行开发 |
| 状态迁移过程中功能回退 | 高 | 保持旧 Provider 可用状态；每个子模块单独切换 |
| Riverpod 3.0 破坏性变更 | 低 | 锁定 minor 版本；充分测试后再升级 |

**应对**：Phase 1.2 中按模块逐个迁移，每完成一个模块立即验证功能完整性。

### 风险 2：Hive → Drift 数据迁移

| 风险 | 等级 | 缓解措施 |
|------|------|----------|
| 迁移过程中数据丢失 | 高 | 迁移前完整备份 Hive 文件；迁移后双重校验 |
| Drift 性能不如 Hive（小数据量） | 低 | Drift 基于 SQLite，高并发写入更优 |
| 迁移脚本复杂，调试困难 | 中 | 独立迁移工具，不影响主流程 |

**应对**：数据迁移作为独立模块，先在测试环境验证，再在真实数据上执行。

### 风险 3：功能回归

| 风险 | 等级 | 缓解措施 |
|------|------|----------|
| 续写质量下降（Prompt 变更） | 高 | 保留 AI 调用逻辑不变，仅改变封装层 |
| 图谱合并算法变化 | 中 | 逐阶段对比新旧实现的输出差异 |
| 状态持久化逻辑变更 | 中 | Phase 2 数据库迁移时完整测试持久化/恢复流程 |

**应对**：每个 Phase 完成后执行手动验收测试，发现问题立即回滚该阶段。

### 风险 4：进度风险

| 风险 | 等级 | 缓解措施 |
|------|------|----------|
| Phase 3（续写+图谱）工作量大，超出预期 | 高 | Phase 3 细分任务为多个 sprint；预留缓冲时间 |
| 哥哥时间紧张，无法及时验收 | 中 | 交付物按周拆分，每周小版本可演示 |

---

## 五、资源估算

| 阶段 | 预估工作量 | 关键依赖 |
|------|-----------|----------|
| Phase 1 | 1.5-2 周 | Flutter 3.42 升级、Riverpod 3.0 学习 |
| Phase 2 | 1-1.5 周 | Drift 学习、迁移工具开发 |
| Phase 3 | 2-3 周 | AI 模型接口对齐 |
| Phase 4 | 1.5-2 周 | Flutter 3.42 Impeller UI 优化 |
| Phase 5 | 1 周 | 测试框架搭建 |
| **总计** | **7-10 周** | - |

---

## 六、版本规划

| 版本 | 目标 | 包含 Phase |
|------|------|-----------|
| v5.0.0-alpha.1 | 目录结构 + Riverpod 骨架 | Phase 1.1 |
| v5.0.0-alpha.2 | Riverpod Provider 完整覆盖 | Phase 1.2 |
| v5.0.0-beta.1 | Drift 迁移完成 | Phase 2 |
| v5.0.0-beta.2 | 核心功能模块重构 | Phase 3 |
| v5.0.0-rc.1 | UI 重构完成 | Phase 4 |
| v5.0.0 | 发布版本 | Phase 5 |

---

## 七、附录

### A. 技术栈对照表

| 层级 | 当前 | 目标 |
|------|------|------|
| 框架 | Flutter 3.0+ | Flutter 3.42 |
| 状态管理 | Provider 6.1.1 | Riverpod 3.0 |
| 数据库 | Hive 2.2.3 + flutter_secure_storage | Drift 2.12.0 |
| 网络 | http 1.2.0 | http 1.2.0（保留）|
| 序列化 | json_serializable | freezed + json_serializable |
| 图谱可视化 | 手写 Canvas | graphview |
| 测试 | flutter_test | flutter_test + mockito |

### B. 关键文件对应关系

| 旧路径 | 新路径 |
|--------|--------|
| `providers/novel_provider.dart` | `features/*/presentation/providers/` (按模块拆分) |
| `services/storage_service.dart` | `core/database/` + `features/*/data/datasources/` |
| `services/chapter_service.dart` | `features/chapter_management/domain/usecases/` |
| `services/novel_api_service.dart` | `features/writing/data/datasources/` + `core/network/` |
| `models/novel_book.dart` | `features/bookshelf/domain/models/` |
| `models/chapter.dart` | `features/chapter_management/domain/models/` |
| `models/knowledge_graph.dart` | `features/graph/domain/models/` |
