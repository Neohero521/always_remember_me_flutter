# Always Remember Me v5.0 架构设计文档

> 基于参考架构：`基于你提出的小说续写App需求_1775914533069_1b2975.txt`
> 本文档描述适配当前项目（v4.0）的 v5.0 架构设计

---

## 一、架构概览

### 1.1 设计目标

- **Clean Architecture**：清晰的领域边界，业务逻辑与 UI 完全解耦
- **Feature-based 模块化**：每个功能独立可复用，编译时只构建变更模块
- **响应式状态管理**：Riverpod 3.0 驱动，数据流单向流动
- **类型安全**：Drift 数据库 + Freezed 实体，编译时检查
- **渐进式迁移**：v4.0 功能完整，v5.0 分阶段重构，不影响现有体验

### 1.2 核心架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                        │
│   ┌─────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│   │ Bookshelf   │  │ Chapter Mgmt  │  │  Writing / Graph     │  │
│   │ Screen      │  │ Screen       │  │  Screen              │  │
│   └──────┬──────┘  └──────┬───────┘  └──────────┬───────────┘  │
│          │                 │                      │               │
│   Riverpod Providers（状态 + 业务逻辑集成）                    │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                         Domain Layer                            │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │  Use Cases（纯业务逻辑，无 Flutter 依赖）                   │  │
│   │  ParseChapter │ GenerateGraph │ MergeGraphs │ GenerateWrite│  │
│   └──────────────────────────────────────────────────────────┘  │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│   │ NovelBook    │  │ Chapter      │  │ ChapterGraph      │   │
│   │ Entity       │  │ Entity       │  │ Entity            │   │
│   └──────────────┘  └──────────────┘  └──────────────────┘   │
│   Repository Interfaces（抽象，不引用具体实现）                   │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                          Data Layer                             │
│   Repository Implementations ←→ Data Sources                   │
│   ┌──────────────────┐  ┌────────────────┐  ┌──────────────┐   │
│   │ LocalDriftSource │  │ RemoteAISource │  │ SecureStore │   │
│   │ (Drift SQLite)   │  │ (HTTP OpenAI)  │  │ (FlutterSec)│   │
│   └──────────────────┘  └────────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                         Core Layer                              │
│   DI Container │ Network Client │ Database │ Utils │ Exceptions │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3 数据流向

```
用户操作
  ↓
UI Layer（Widget）读取 Riverpod Provider
  ↓
Provider 调用 UseCase（Domain Layer）
  ↓
UseCase 调用 Repository 接口
  ↓
Repository 实现调用 DataSource
  ↓
DataSource 操作 Drift DB / HTTP / SecureStorage
  ↓
数据流原路返回，Provider 更新状态，UI 自动 rebuild
```

---

## 二、目录结构

```
lib/
├── main.dart                        # 应用入口，初始化 Drift + Riverpod
│
├── app/                             # 应用级配置（与业务无关）
│   ├── app.dart                     # MaterialApp 配置，ProviderScope
│   ├── router/
│   │   └── app_router.dart          # GoRouter / auto_route 配置
│   └── theme/
│       └── app_theme.dart           # 统一主题（亮/暗模式）
│
├── core/                            # 核心基础设施（无功能特性依赖）
│   │
│   ├── di/                          # 依赖注入
│   │   ├── di.dart                  # GetIt 容器初始化入口
│   │   └── providers.dart           # 所有 Riverpod Provider 注册点
│   │
│   ├── database/                    # Drift 数据库
│   │   ├── database.dart             # $AppDatabase extends QueryExecutor
│   │   ├── database.g.dart           # 编译生成（build_runner）
│   │   └── tables/
│   │       ├── novels.dart
│   │       ├── chapters.dart
│   │       ├── chapter_graphs.dart
│   │       ├── merged_graphs.dart
│   │       ├── continue_chapters.dart
│   │       └── app_settings.dart
│   │
│   ├── network/                     # HTTP 客户端封装
│   │   ├── http_client.dart         # Dio 或 http 封装，统一错误处理
│   │   └── api_endpoints.dart       # API 端点常量
│   │
│   ├── utils/                       # 通用工具
│   │   ├── uuid_generator.dart      # UUID v4 生成
│   │   ├── text_chunker.dart         # 大文本分块工具
│   │   └── date_formatter.dart       # 日期格式化
│   │
│   └── exceptions/                  # 统一异常
│       ├── app_exception.dart       # 基础异常类
│       ├── network_exception.dart
│       ├── database_exception.dart
│       └── ai_service_exception.dart
│
├── features/                         # 功能模块（各自独立的三层架构）
│   │
│   ├── bookshelf/                   # 书架模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── novel_book.dart  # 小说书架实体（Freezed）
│   │   │   ├── repositories/
│   │   │   │   └── i_bookshelf_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_bookshelf_usecase.dart
│   │   │       ├── add_book_usecase.dart
│   │   │       ├── select_book_usecase.dart
│   │   │       └── delete_book_usecase.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── bookshelf_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── local_bookshelf_datasource.dart  # Drift DAO
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── bookshelf_provider.dart  # Riverpod StateNotifier
│   │       ├── screens/
│   │       │   └── bookshelf_screen.dart
│   │       └── widgets/
│   │           ├── book_card.dart
│   │           └── book_list_tile.dart
│   │
│   ├── chapter_management/          # 章节管理模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── chapter.dart     # 章节实体（Freezed）
│   │   │   ├── repositories/
│   │   │   │   └── i_chapter_repository.dart
│   │   │   └── usecases/
│   │   │       ├── parse_chapters_usecase.dart
│   │   │       ├── split_by_word_count_usecase.dart
│   │   │       ├── import_novel_usecase.dart
│   │   │       └── delete_chapters_usecase.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── chapter_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── local_chapter_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── chapter_provider.dart
│   │       ├── screens/
│   │       │   ├── chapters_screen.dart
│   │       │   └── import_screen.dart
│   │       └── widgets/
│   │           ├── chapter_list_item.dart
│   │           └── chapter_parser_preview.dart
│   │
│   ├── reader/                      # 阅读器模块
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── update_reading_progress_usecase.dart
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── settings_datasource.dart  # 字号、进度等配置
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── reader_provider.dart
│   │       ├── screens/
│   │       │   └── reader_screen.dart
│   │       └── widgets/
│   │           └── reader_text_view.dart
│   │
│   ├── graph/                       # 图谱模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── chapter_graph.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_graph_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_single_graph_usecase.dart
│   │   │       ├── generate_all_graphs_usecase.dart
│   │   │       ├── batch_merge_graphs_usecase.dart
│   │   │       ├── merge_all_graphs_usecase.dart
│   │   │       ├── export_graphs_usecase.dart
│   │   │       └── import_graphs_usecase.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── graph_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── local_graph_datasource.dart
│   │   │       └── remote_ai_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── graph_provider.dart
│   │       ├── screens/
│   │       │   └── graph_viewer_screen.dart
│   │       └── widgets/
│   │           └── graph_node_widget.dart
│   │
│   ├── writing/                     # 续写模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── continue_chapter.dart
│   │   │   │   ├── precheck_result.dart
│   │   │   │   └── quality_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_writing_repository.dart
│   │   │   └── usecases/
│   │   │       ├── run_precheck_usecase.dart
│   │   │       ├── generate_write_usecase.dart
│   │   │       ├── continue_from_chain_usecase.dart
│   │   │       ├── evaluate_quality_usecase.dart
│   │   │       └── update_continue_graph_usecase.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── writing_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── remote_ai_datasource.dart  # 调用 AI API
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── writing_provider.dart
│   │       ├── screens/
│   │       │   ├── write_screen.dart
│   │       │   └── write_settings_screen.dart
│   │       └── widgets/
│   │           ├── write_preview.dart
│   │           ├── continue_chain_view.dart
│   │           └── quality_report_card.dart
│   │
│   └── settings/                    # 设置模块
│       ├── domain/
│       │   ├── models/
│       │   │   └── app_config.dart
│       │   └── usecases/
│       │       ├── get_config_usecase.dart
│       │       └── update_config_usecase.dart
│       ├── data/
│       │   ├── repositories/
│       │   │   └── config_repository_impl.dart
│       │   └── datasources/
│       │       └── secure_config_datasource.dart
│       └── presentation/
│           ├── providers/
│           │   └── config_provider.dart
│           └── screens/
│               └── settings_screen.dart
│
└── common_ui/                       # 跨功能复用 UI 组件
    ├── widgets/
    │   ├── loading_indicator.dart
    │   ├── error_view.dart
    │   ├── empty_state_view.dart
    │   ├── confirm_dialog.dart
    │   ├── status_badge.dart
    │   ├── section_header.dart
    │   └── app_scaffold.dart
    └── styles/
        ├── colors.dart
        ├── text_styles.dart
        └── spacing.dart
```

---

## 三、核心模块详细设计

### 3.1 数据库设计（Drift 2.12.0）

#### 3.1.1 Schema 总览

```
Novels (1) ──────< Chapters (N) ──────< ChapterGraphs (N)
  │                                           │
  │                                           │
  └───< MergedGraphs (N)                      │
                                                  │
  └───< ContinueChapters (N)                    │（跨章节）
                                                  │
  └────────> ChapterGraphs (N)（合并来源）
```

#### 3.1.2 关键设计决策

1. **大字段存储**：`chapters.content`、`graphs.data` 使用 `TEXT` 类型，Drift 原生支持大文本，无需分段存储
2. **级联删除**：章节删除时，自动删除其图谱（`onDelete: KeyAction.cascade`）
3. **JSON 列**：图谱数据存储为 JSON 字符串，不做结构强约束（保证灵活性）
4. **迁移策略**：使用 Drift Migration Strategy，支持 schema 版本升级
5. **索引**：`novelId`、`createdAt`、`chapterId` 上建立索引，加速查询

### 3.2 状态管理（Riverpod 3.0）

#### 3.2.1 Provider 架构

```
全局 Providers（定义在 core/di/providers.dart）：
  ├── databaseProvider          # Drift AppDatabase 单例
  ├── httpClientProvider        # HTTP 客户端单例
  ├── aiModelProvider           # 当前 AI 模型（可切换）
  │
  └── Feature Providers（各 feature/presentation/providers/）：
        ├── bookshelfProvider   # BookshelfNotifier + BookshelfState
        ├── chapterProvider      # ChapterNotifier + ChapterState
        ├── graphProvider        # GraphNotifier + GraphState
        ├── writingProvider      # WritingNotifier + WritingState
        ├── readerProvider       # ReaderNotifier + ReaderState
        └── configProvider       # ConfigNotifier + AppConfig
```

#### 3.2.2 State 设计示例（Graph）

```dart
// State（不可变）
@freezed
class GraphState with _$GraphState {
  const factory GraphState({
    @Default({}) Map<int, ChapterGraph> chapterGraphMap,
    ChapterGraph? mergedGraph,
    @Default([]) List<ChapterGraph> batchMergedGraphs,
    @Default(false) bool isGenerating,
    @Default(false) bool stopFlag,
    String? progressText,
    GraphComplianceResult? complianceResult,
  }) = _GraphState;
}

// Notifier（状态变更逻辑）
class GraphNotifier extends StateNotifier<GraphState> {
  final GenerateAllGraphsUseCase _generateAll;
  final MergeAllGraphsUseCase _mergeAll;
  final GraphRepository _repository;

  GraphNotifier(this._generateAll, this._mergeAll, this._repository) : super(const GraphState());

  Future<void> generateAll(ChapterList chapters) async { ... }
  Future<void> mergeAll() async { ... }
  void stop() { state = state.copyWith(stopFlag: true); }
}
```

#### 3.2.3 Riverpod 3.0 关键特性使用

| 特性 | 用途 |
|------|------|
| `StateNotifierProvider` | 管理复杂状态（GraphState、ChapterState 等） |
| `FutureProvider` | 图谱列表查询、合并结果查询（只读） |
| `StreamProvider` | Drift 数据库变更监听（响应式 UI） |
| `Provider` | 工具类单例（Database、HttpClient） |
| `family` modifier | 带参数 Provider（如 `chapterProvider(bookId)`） |
| `ref.watch` | UI 层监听状态变更 |
| `ref.read` | UseCase 执行（一次性操作） |

### 3.3 AI 服务抽象

```dart
/// AI 模型接口（抽象）
abstract class AIModel {
  Future<ChapterGraph> generateSingleChapterGraph({
    required String chapterId,
    required String chapterTitle,
    required String chapterContent,
    bool isModified = false,
  });

  Future<ChapterGraph> batchMergeGraphs({
    required List<Map<String, dynamic>> graphList,
    required int batchNumber,
    required int totalBatches,
  });

  Future<ChapterGraph> mergeAllGraphs({
    required List<Map<String, dynamic>> graphList,
  });

  Future<String> generateContinuation({
    required String systemPrompt,
    required String userPrompt,
    required int targetWordCount,
  });

  Future<PrecheckResult> precheckContinuation({
    required int baseChapterId,
    required List<Map<String, dynamic>> preGraphList,
    String? modifiedChapterContent,
  });

  Future<QualityResult> evaluateQuality({
    required String continueContent,
    required Map<String, dynamic> precheckResult,
    required Map<String, dynamic> baseGraph,
    required String baseChapterContent,
    required int targetWordCount,
  });
}

/// 具体实现
class OpenAIModel implements AIModel { ... }
class GeminiModel implements AIModel { ... }
```

### 3.4 图谱生成与合并流程

```dart
// 完整流程（调用示例）

// 1. 单章节图谱生成
final graph = await generateSingleGraphUseCase(chapter);

// 2. 批量生成（for 循环，每章间隔 1s 防限流）
for (final chapter in chapters) {
  if (stopFlag) break;
  await generateSingleGraphUseCase(chapter);
  progress = '${i + 1}/${total}';
}

// 3. 分批合并（每批 50 个）
final batch1 = await batchMergeGraphsUseCase(graphList.sublist(0, 50));
final batch2 = await batchMergeGraphsUseCase(graphList.sublist(50, 100));

// 4. 全量合并
final merged = await mergeAllGraphsUseCase([batch1, batch2]);
```

---

## 四、技术选型说明

### 4.1 Riverpod 3.0 vs Provider

| 对比项 | Provider | Riverpod 3.0 |
|--------|----------|-------------|
| 依赖注入 | 弱，需要手动传递 | 内置，通过 Provider 层级解决 |
| 编译时安全 | 无 | `riverpod_annotation` 生成类型安全代码 |
| 代码生成 | 无 | `riverpod_generator` 减少样板 |
| 测试 | 需要 `ProviderContainer` | `ref` 可直接 Mock |
| 响应式 | `notifyListeners` | 内置流式响应，无需手动调用 |
| 生态 | 成熟，但维护频率下降 | 活跃，Flutter 官方推荐 |

### 4.2 Drift vs Hive

| 对比项 | Hive | Drift |
|--------|------|-------|
| 类型安全 | 无（运行时检查） | 编译时类型安全 |
| 查询能力 | 简单键值对 | SQL 查询、JOIN、聚合 |
| 迁移 | 手动版本管理 | 内置 Migration Strategy |
| 关系型支持 | 弱（需要手动维护关系） | 原生外键、级联删除 |
| 响应式 | 无 | `Stream` 响应式查询 |
| 性能 | 写性能优秀 | 读性能更优（SQLite 优化）|

### 4.3 Flutter 3.42 关键特性

| 特性 | 受益模块 |
|------|----------|
| Impeller 2.0 渲染引擎 | 全部 UI，尤其是 GraphViewer 的 Canvas 绘制 |
| AI DevTools | 开发阶段性能分析 |
| 改进的 WebAssembly | 未来 Web 版本扩展 |
| 稳定的桌面支持 | Windows/macOS/Linux 桌面版 |

---

## 五、模块间依赖关系

```
core/
  ├── di/          ← 所有 features 可依赖
  ├── database/    ← 所有 features 可依赖
  ├── network/     ← features/writing/data, features/graph/data
  ├── utils/       ← 所有 features 可依赖
  └── exceptions/  ← 所有 features 可依赖

features/
  ├── bookshelf   ← 只依赖 core/
  ├── settings    ← 只依赖 core/
  ├── chapter_mgmt ← 依赖 core/ + bookshelf/domain（共享 NovelBook entity）
  ├── reader       ← 依赖 core/ + chapter_mgmt/domain
  ├── graph        ← 依赖 core/ + chapter_mgmt/domain
  └── writing      ← 依赖 core/ + graph/domain + chapter_mgmt/domain

common_ui/         ← 被所有 features/presentation/widgets 依赖
```

**依赖规则**：
- `domain` 层不能依赖任何其他 feature 的 domain（防止循环依赖）
- 共享实体（如 `NovelBook`）放置在各自 domain 中，通过接口传递
- 跨 feature 通信通过 `core/di` 的全局 Provider 解决

---

## 六、错误处理策略

```
用户操作
    ↓
Riverpod Notifier.tryCatch
    ↓
UseCase.execute()
    ↓
Repository 调用 DataSource
    ↓
DataSource 捕获异常
    ↓
→ 网络异常 → NetworkException → 用户提示"网络不可用"
→ 数据库异常 → DatabaseException → 用户提示"数据保存失败"
→ AI服务异常 → AIServiceException → 用户提示"AI服务异常，请重试"
→ 业务异常 → AppException → 具体业务错误消息
    ↓
Riverpod State 更新 error 字段
    ↓
UI 读取 error 状态，显示 ErrorView
```

---

## 七、迁移兼容性

### 7.1 v4 → v5 数据迁移路径

```
v4.0 (Hive)
    │
    ├── 启动检测 Hive 数据是否存在
    │   ├── 是 → 执行迁移脚本 → 写入 Drift → 验证完整性 → 成功则继续
    │   └── 否 → 直接使用 Drift（空数据库）
    │
    └── v5.0 (Drift)
```

### 7.2 双轨运行策略（过渡期）

- Phase 1-2：旧 `NovelProvider` 仍可运行，但新 feature 走新架构
- Phase 3 后：旧 `NovelProvider` 废弃，新架构完全接管
- v5.0.0 正式版：移除所有 Hive 相关代码

---

## 八、性能优化策略

| 优化点 | 方案 |
|--------|------|
| 长列表滚动 | `ListView.builder` + 懒加载 |
| 大文本分章 | `compute()` 放到 Isolate 中执行 |
| 图谱生成 | 每章间隔 1s，避免 API 限流 |
| 图谱 JSON 存储 | Drift TEXT 类型，不限制大小 |
| UI 重建优化 | Riverpod `select` 精确监听字段 |
| 图片缓存 | `CachedNetworkImage` |
| 数据库查询 | 索引覆盖常用查询字段 |

---

## 九、测试架构

```
test/
├── unit/
│   ├── usecases/
│   │   ├── parse_chapters_usecase_test.dart
│   │   ├── generate_write_usecase_test.dart
│   │   └── merge_graphs_usecase_test.dart
│   └── repositories/
│       └── bookshelf_repository_test.dart
│
├── data/
│   └── datasources/
│       └── drift_datasource_test.dart
│
├── mock/
│   ├── mock_ai_model.dart
│   └── mock_datasource.dart
│
└── integration/
    ├── bookshelf_flow_test.dart
    └── write_flow_test.dart
```

**测试工具**：
- `flutter_test` - 单元/集成测试
- `mockito` - Mock 依赖
- `riverpod_test` / `mocktail` - Riverpod Provider 测试
- `drift` 内置测试支持 - 数据库测试

---

## 十、未来扩展预留

### 10.1 插件化架构（远期）

当前架构已为插件化预留空间：
- `extensions/` 目录（不在当前 scope，后续可扩展）
- 每个 feature 的 `domain/` 层通过接口隔离，便于替换实现

### 10.2 热更新预留

- 配置数据（API URL、模型选择）存储在 Drift，可通过云端配置热更新
- UI 布局数据可云端下发（需 WebAssembly 支持后实现）

### 10.3 多端同步

Drift 支持 `NativeDatabase`（移动端）和 `DriftWorker`（Web Worker），为未来多端数据同步预留接口：
```dart
abstract class SyncableRepository {
  Future<void> syncToCloud();
  Future<void> syncFromCloud();
  Stream<SyncStatus> watchSyncStatus();
}
```
