# Always Remember Me v5.0 详细架构设计文档

> 本文档是 v5.0 架构的详细实现规范，基于 `ARCHITECTURE_v5.md` 和 `ITERATION_PLAN_v5.md`
> 代码路径：`/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`

---

## 一、详细目录结构

```
lib/
├── main.dart                                    # 应用入口
│                                               # 职责：初始化 Drift 数据库 + Riverpod ProviderScope
│
├── app/                                         # 应用级配置（与业务无关）
│   ├── app.dart                                 # MaterialApp 配置，ProviderScope 包装
│   ├── router/
│   │   └── app_router.dart                      # GoRouter 配置，路由守卫
│   └── theme/
│       ├── app_theme.dart                       # 亮/暗模式主题定义
│       ├── colors.dart                          # 颜色常量（从 v4 整合）
│       └── text_styles.dart                     # 文本样式常量
│
├── core/                                        # 核心基础设施（无功能特性依赖）
│   │
│   ├── di/                                      # 依赖注入
│   │   ├── di.dart                              # GetIt 容器初始化入口
│   │   │                                        # 职责：registerSingleton/registerFactory
│   │   │                                        # 依赖顺序：Database → DataSources → Repositories → UseCases → Providers
│   │   └── providers.dart                       # 所有 Riverpod Provider 注册点
│   │                                              # 包含：databaseProvider, httpClientProvider, aiModelProvider
│   │
│   ├── database/                                # Drift 数据库
│   │   ├── app_database.dart                    # $AppDatabase extends QueryExecutor
│   │   ├── app_database.g.dart                  # 编译生成（build_runner）
│   │   ├── daos/
│   │   │   ├── novel_dao.dart                   # Novels 表 DAO
│   │   │   ├── chapter_dao.dart                 # Chapters 表 DAO
│   │   │   ├── graph_dao.dart                    # ChapterGraphs + MergedGraphs DAO
│   │   │   ├── continue_chapter_dao.dart         # ContinueChapters DAO
│   │   │   └── settings_dao.dart                  # AppSettings DAO
│   │   └── tables/
│   │       ├── novels.dart                       # Novels 表定义
│   │       ├── chapters.dart                      # Chapters 表定义
│   │       ├── chapter_graphs.dart                # ChapterGraphs 表定义
│   │       ├── merged_graphs.dart                  # MergedGraphs 表定义
│   │       ├── continue_chapters.dart             # ContinueChapters 表定义
│   │       └── app_settings.dart                  # AppSettings 表定义
│   │
│   ├── network/                                  # HTTP 客户端封装
│   │   ├── http_client.dart                       # Dio 实例封装，统一超时/拦截器/错误处理
│   │   ├── api_endpoints.dart                    # API 端点常量（OpenAI/Gemini 等）
│   │   └── api_interceptors.dart                 # 统一拦截器（日志/Token/重试）
│   │
│   ├── utils/                                    # 通用工具（无外部依赖）
│   │   ├── uuid_generator.dart                   # UUID v4 生成（基于 crypto 或 nanoid）
│   │   ├── text_chunker.dart                     # 大文本分块（用于 Isolate 计算）
│   │   ├── date_formatter.dart                   # 日期格式化（yyyy-MM-dd / HH:mm）
│   │   └── result.dart                            # Result<E, T> 联合类型（替代异常直接返回）
│   │
│   └── exceptions/                               # 统一异常体系
│       ├── app_exception.dart                    # AppException 基类（抽象）
│       ├── network_exception.dart                 # 网络异常（超时/断开/404/500）
│       ├── database_exception.dart                 # 数据库异常（读写失败/约束违反）
│       ├── ai_service_exception.dart               # AI 服务异常（限流/模型错误/超时）
│       └── validation_exception.dart               # 校验异常（参数非法/格式错误）
│
├── features/                                    # 功能模块（各自独立的三层架构）
│   │
│   ├── bookshelf/                               # 书架模块
│   │   ├── domain/                              # 领域层（纯 Dart，无 Flutter 依赖）
│   │   │   ├── models/
│   │   │   │   └── novel_book.dart              # 小说书架实体
│   │   │   │       # 字段：id, title, author, cover, introduction,
│   │   │   │       #        chapterCount, readProgress, lastReadChapterId,
│   │   │   │       #        lastReadAt, createdAt
│   │   │   │       # 工具：Freezed @freezed，copyWith, ==, hashCode, toJson, fromJson
│   │   │   │   └── novel_book.freezed.dart       # 编译生成
│   │   │   │   └── novel_book.g.dart             # JSON 序列化生成
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── i_bookshelf_repository.dart  # 书架仓库接口（抽象）
│   │   │   │       # 方法：
│   │   │   │       #   Future<List<NovelBook>> getAllNovels();
│   │   │   │       #   Future<NovelBook?> getNovelById(String id);
│   │   │   │       #   Future<void> insertNovel(NovelBook novel);
│   │   │   │       #   Future<void> updateNovel(NovelBook novel);
│   │   │   │       #   Future<void> deleteNovel(String id);
│   │   │   │       #   Stream<List<NovelBook>> watchAllNovels();  // 响应式
│   │   │   │       #   Future<void> updateReadProgress(String id, double progress);
│   │   │   │       #   Future<void> selectNovel(String id);
│   │   │   │       #   Future<String?> getSelectedNovelId();
│   │   │   │       #
│   │   │   │       # 依赖规则：此接口属于 domain 层，data 层实现
│   │   │   │       # 命名规则：I 前缀 = 接口（Flutter 惯例）
│   │   │   │
│   │   │   └── usecases/
│   │   │       ├── get_bookshelf_usecase.dart    # 获取书架列表
│   │   │       │   # 输入：void
│   │   │       │   # 输出：Result<List<NovelBook>>
│   │   │       │   # 依赖：INovelRepository.getAllNovels()
│   │   │       │   #
│   │   │       ├── add_book_usecase.dart          # 添加书籍到书架
│   │   │       │   # 输入：ImportResult（外部导入结果）
│   │   │       │   # 输出：Result<NovelBook>
│   │   │       │   # 依赖：INovelRepository.insertNovel()
│   │   │       │   #
│   │   │       ├── select_book_usecase.dart       # 选中书籍（切换当前操作对象）
│   │   │       │   # 输入：String novelId
│   │   │       │   # 输出：Result<NovelBook>
│   │   │       │   # 依赖：INovelRepository.selectNovel()
│   │   │       │   #
│   │   │       └── delete_book_usecase.dart       # 删除书籍
│   │   │           # 输入：String novelId
│   │   │           # 输出：Result<void>
│   │   │           # 依赖：INovelRepository.deleteNovel()
│   │   │
│   │   ├── data/                                # 数据层
│   │   │   ├── models/
│   │   │   │   └── novel_book_dto.dart          # DTO（Drift 行映射）
│   │   │   │       # 与 NovelBook 的区别：Drift 行格式，toCompanion/toModel 转换
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── bookshelf_repository_impl.dart  # IBookshelfRepository 实现
│   │   │   │       # 依赖：NovelDao, AppDatabase
│   │   │   │       # 实现：数据转换 Drift ↔ Domain Model
│   │   │   │       # 注意：异常统一包装为 DatabaseException
│   │   │   │       #
│   │   │   └── datasources/
│   │   │       └── local_bookshelf_datasource.dart  # 本地数据源（Drift DAO 封装）
│   │   │           # 职责：直接操作 Drift DAO
│   │   │           # 命名：LocalXxxDataSource = 本地持久化
│   │   │
│   │   └── presentation/                        # 表示层
│   │       ├── providers/
│   │       │   └── bookshelf_provider.dart       # Riverpod Provider 定义
│   │       │       # StateNotifierProvider<BookshelfNotifier, BookshelfState>
│   │       │       #
│   │       │       # BookshelfState（Freezed）：
│   │       │       #   - novels: List<NovelBook>
│   │       │       #   - selectedNovelId: String?
│   │       │       #   - isLoading: bool
│   │       │       #   - error: AppException?
│   │       │       #
│   │       │       # BookshelfNotifier（StateNotifier）：
│   │       │       #   - loadNovels(): 初始化加载
│   │       │       #   - addNovel(ImportResult): 添加书籍
│   │       │       #   - selectNovel(String id): 选中书籍
│   │       │       #   - deleteNovel(String id): 删除书籍
│   │       │       #   - updateProgress(String id, double progress): 更新进度
│   │       │       #
│   │       │       # 状态复用策略：
│   │       │       #   - isLoading: 贯穿所有异步操作
│   │       │       #   - error: tryCatch 捕获，置入 state
│   │       │       #   - selectedNovelId: 独立状态，不与其他状态耦合
│   │       │       #
│   │       │       # Stream 响应式：
│   │       │       #   - ref.watch(novelDao.watchAllNovels().future) 驱动自动 rebuild
│   │       │       #
│   │       │   └── bookshelf_provider.g.dart     # 编译生成（riverpod_generator）
│   │       │
│   │       ├── screens/
│   │       │   └── bookshelf_screen.dart         # 书架主界面
│   │       │       # Widget 职责：
│   │       │       #   - GridView.builder 展示书籍卡片
│   │       │       #   - ref.watch(bookshelfProvider) 监听状态
│   │       │       #   - ref.read(bookshelfProvider.notifier) 调用方法
│   │       │       #   - EmptyStateView 无书籍时
│   │       │       #   - LoadingIndicator 加载中
│   │       │       #   - ErrorView 错误展示
│   │       │       #
│   │       └── widgets/
│   │           ├── book_card.dart                 # 书籍卡片组件
│   │           │   # 字段：封面、标题、作者、章节数、阅读进度
│   │           │   # 交互：点击选中，长按弹出菜单（删除/信息）
│   │           │   #
│   │           └── book_list_tile.dart            # 书籍列表项组件
│   │               # 用于小屏幕/紧凑列表场景
│   │
│   ├── chapter_management/                       # 章节管理模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── chapter.dart                  # 章节实体
│   │   │   │       # 字段：id, novelId, number, title, content,
│   │   │   │       #        hasGraph, wordCount, createdAt
│   │   │   │       # 工具：Freezed
│   │   │   │       # 特殊：content 为大文本，Drift TEXT 类型
│   │   │   │       # 特殊：wordCount = content.runes.length（中日韩字符也算1字）
│   │   │   │       # 计算属性：isEmpty, preview（前三行）
│   │   │   │   └── chapter.freezed.dart
│   │   │   │   └── chapter.g.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── i_chapter_repository.dart     # 章节仓库接口
│   │   │   │       # 方法：
│   │   │   │       #   Future<List<Chapter>> getChaptersByNovelId(String novelId);
│   │   │   │       #   Future<Chapter?> getChapterById(String id);
│   │   │   │       #   Future<void> insertChapter(Chapter chapter);
│   │   │   │       #   Future<void> insertChapters(List<Chapter> chapters);
│   │   │   │       #   Future<void> updateChapter(Chapter chapter);
│   │   │   │       #   Future<void> deleteChapter(String id);
│   │   │   │       #   Future<void> deleteChaptersByNovelId(String novelId);
│   │   │   │       #   Stream<List<Chapter>> watchChaptersByNovelId(String novelId);
│   │   │   │       #   Future<void> markChapterHasGraph(String id, bool hasGraph);
│   │   │   │       #
│   │   │   │   # 注意：deleteChaptersByNovelId 需要级联删除图谱
│   │   │   │       # 由 DAO 层 onDelete: KeyAction.cascade 自动处理
│   │   │   │       #
│   │   │   └── usecases/
│   │   │       ├── parse_chapters_usecase.dart    # 文本解析为章节列表
│   │   │       │   # 输入：String rawText, ParseOptions? options
│   │   │       │   # ParseOptions：regex?, minWordCount?, maxWordCount?
│   │   │       │   # 输出：Result<List<ChapterEntity>>（Domain Model，非 DB Entity）
│   │   │       │   # 算法：
│   │   │       │   #   1. 按 regex 分割章节
│   │   │       │   #   2. 过滤空章节（字数 < minWordCount）
│   │   │       │   #   3. 编号 + 标题提取
│   │   │       │   #   4. 计算 wordCount
│   │   │       │   # 放在 Isolate 中执行（compute）
│   │   │       │   # 依赖：无（纯算法）
│   │   │       │   #
│   │   │       ├── split_by_word_count_usecase.dart  # 按字数强制分章
│   │   │       │   # 输入：String text, int wordCountPerChapter
│   │   │       │   # 输出：Result<List<ChapterEntity>>
│   │   │       │   # 算法：固定字数切分，最后一章不满也保留
│   │   │       │   #
│   │   │       ├── import_novel_usecase.dart      # 导入小说（解析 + 存储）
│   │   │       │   # 输入：String novelTitle, String rawText, String? author
│   │   │       │   # 输出：Result<ImportResult>
│   │   │       │   # ImportResult：novel（NovelBook）, chapters（List<Chapter>）
│   │   │       │   # 流程：
│   │   │       │   #   1. ParseChaptersUseCase 解析
│   │   │       │   #   2. 生成 novelId（uuid）
│   │   │       │   #   3. 绑定 chapter.novelId
│   │   │       │   #   4. INovelRepository.insertNovel()
│   │   │       │   #   5. IChapterRepository.insertChapters()
│   │   │       │   # 原子性：失败回滚（手动 try rollback 或事务）
│   │   │       │   #
│   │   │       ├── get_chapters_usecase.dart      # 获取章节列表
│   │   │       │   # 输入：String novelId
│   │   │       │   # 输出：Result<List<Chapter>>
│   │   │       │   #
│   │   │       └── delete_chapters_usecase.dart   # 删除章节
│   │   │           # 输入：List<String> chapterIds
│   │   │           # 输出：Result<void>
│   │   │           # 依赖：IChapterRepository.deleteChapter()（批量）
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── chapter_dto.dart              # Drift DTO
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── chapter_repository_impl.dart
│   │   │   │       # 依赖：ChapterDao
│   │   │   │       # 实现细节：
│   │   │   │       #   - watchChaptersByNovelId → StreamProvider
│   │   │   │       #   - insertChapters 批量插入优化
│   │   │   │       #   - deleteChapters 批量删除
│   │   │   │       #
│   │   │   └── datasources/
│   │   │       └── local_chapter_datasource.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── chapter_provider.dart
│   │       │       # StateNotifierProvider<ChapterNotifier, ChapterState>
│   │       │       #
│   │       │       # ChapterState（Freezed）：
│   │       │       #   - chapters: List<Chapter>
│   │       │       #   - selectedChapterId: String?
│   │       │       #   - parsePreview: List<Chapter>?（导入预览）
│   │       │       #   - isLoading: bool
│   │       │       #   - isParsing: bool（解析中，防重复点击）
│   │       │       #   - error: AppException?
│   │       │       #
│   │       │       # ChapterNotifier：
│   │       │       #   - loadChapters(String novelId)
│   │       │       #   - parseImport(String text): 预览解析
│   │       │       #   - confirmImport(ImportResult): 确认导入
│   │       │       #   - selectChapter(String? id)
│   │       │       #   - deleteChapters(List<String> ids)
│   │       │       #
│   │       ├── screens/
│   │       │   ├── chapters_screen.dart          # 章节列表主界面
│   │       │   │   # Widget：
│   │       │   │   #   - ListView.builder 章节列表
│   │       │   │   #   - 批量选择 Checkbox
│   │       │   │   #   - FAB 新建/导入入口
│   │       │   │   #
│   │       │   └── import_screen.dart             # 导入界面
│   │       │       # Widget：
│   │       │   │   #   - FilePicker 文本选择
│   │       │   │   #   - 预览分章结果（parsePreview）
│   │       │   │   #   - 确认/取消按钮
│   │       │       #
│   │       └── widgets/
│   │           ├── chapter_list_item.dart        # 章节列表项
│   │           │   # 字段：序号、标题、字数、是否有图谱图标
│   │           │   # 交互：点击跳转 Reader，长按多选
│   │           │   #
│   │           └── chapter_parser_preview.dart   # 解析预览卡片
│   │               # 展示解析后的章节列表（预览用）
│   │
│   ├── reader/                                    # 阅读器模块
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── update_reading_progress_usecase.dart
│   │   │           # 输入：String chapterId, double progress
│   │   │           # 输出：Result<void>
│   │   │           # 依赖：INovelRepository.updateReadProgress()
│   │   │
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── settings_datasource.dart       # 阅读器设置（字号/背景/进度）
│   │   │           # 使用：SharedPreferences 或 AppSettings 表
│   │   │           # 字段：fontSize, lineHeight, backgroundColor, themeMode
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── reader_provider.dart
│   │       │       # StateNotifierProvider<ReaderNotifier, ReaderState>
│   │       │       #
│   │       │       # ReaderState（Freezed）：
│   │       │       #   - chapter: Chapter?
│   │       │       #   - fontSize: double（默认 16）
│   │       │       #   - lineHeight: double（默认 1.6）
│   │       │       #   - backgroundColor: Color
│   │       │       #   - scrollProgress: double（0.0-1.0）
│   │       │       #   - error: AppException?
│   │       │       #
│   │       │       # ReaderNotifier：
│   │       │       #   - loadChapter(String id)
│   │       │       #   - setFontSize(double size)
│   │       │       #   - setLineHeight(double height)
│   │       │       #   - setBackgroundColor(Color color)
│   │       │       #   - updateScrollProgress(double progress)
│   │       │       #
│   │       ├── screens/
│   │       │   └── reader_screen.dart             # 阅读器主界面
│   │       │       # Widget：
│   │       │       #   - ScrollView 章节内容
│   │       │       #   - 顶部 AppBar（标题 + 设置按钮）
│   │       │       #   - 底部进度条
│   │       │       #   - 设置面板（字号/背景/亮度）
│   │       │       #   - ref.watch 自动监听状态
│   │       │       #
│   │       └── widgets/
│   │           └── reader_text_view.dart           # 阅读文本组件
│   │               # 样式：fontSize, lineHeight, textAlign
│   │               # 特性：长按选中文本（复制/搜索）
│   │
│   ├── graph/                                     # 图谱模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── chapter_graph.dart             # 图谱实体
│   │   │   │       # 字段：id, chapterId, novelId, type, data（JSON）,
│   │   │   │       #        createdAt
│   │   │   │       # type: characterRelationship | eventChain | worldSetting
│   │   │   │       # data: Map<String, dynamic>（JSON，可存储任意图谱结构）
│   │   │   │       # 工具：Freezed + custom JSON converter
│   │   │   │       # 计算属性：nodeCount, edgeCount（从 data 解析）
│   │   │   │   └── chapter_graph.freezed.dart
│   │   │   │       # 注意：Freezed 不支持 dynamic JSON，
│   │   │   │       # 方案：@JsonSerializable(explicitToJson: true) 手动处理
│   │   │   │       #
│   │   │   ├── repositories/
│   │   │   │   └── i_graph_repository.dart        # 图谱仓库接口
│   │   │   │       # 方法：
│   │   │   │       #   Future<List<ChapterGraph>> getGraphsByNovelId(String novelId);
│   │   │   │       #   Future<ChapterGraph?> getGraphByChapterId(String chapterId);
│   │   │   │       #   Future<void> insertGraph(ChapterGraph graph);
│   │   │   │       #   Future<void> upsertGraph(ChapterGraph graph);  // 覆盖
│   │   │   │       #   Future<void> deleteGraph(String id);
│   │   │   │       #   Future<void> deleteGraphsByChapterId(String chapterId);
│   │   │   │       #   Future<List<ChapterGraph>> getMergedGraphsByNovelId(String novelId, {int? batchNumber});
│   │   │   │       #   Future<void> saveMergedGraph(String novelId, ChapterGraph graph, {int? batchNumber});
│   │   │   │       #
│   │   │   │   # mergedGraphs 表设计：novelId + batchNumber 唯一
│   │   │   │       # batchNumber = null 表示全量合并结果
│   │   │   │       # batchNumber = 1/2/3... 表示分批合并中间结果
│   │   │   │       #
│   │   │   └── usecases/
│   │   │       ├── generate_single_graph_usecase.dart  # 单章节图谱生成
│   │   │       │   # 输入：Chapter chapter
│   │   │       │   # 输出：Result<ChapterGraph>
│   │   │       │   # 流程：
│   │   │       │   #   1. IAIRepository.generateSingleChapterGraph(chapter)
│   │   │       │   #   2. IGraphRepository.upsertGraph(result)
│   │   │       │   #   3. IChapterRepository.markChapterHasGraph(id, true)
│   │   │       │   #
│   │   │       ├── generate_all_graphs_usecase.dart    # 全量图谱生成（批量）
│   │   │       │   # 输入：List<Chapter> chapters, void Function(int current, int total) onProgress
│   │   │       │   # 输出：Result<void>
│   │   │       │   # 流程：
│   │   │       │   #   1. for 循环，每章调用 GenerateSingleGraphUseCase
│   │   │       │   #   2. 每章间隔 1000ms（防 API 限流）
│   │   │       │   #   3. onProgress(i + 1, total) 报告进度
│   │   │       │   #   4. 异常不中断流程，记录失败的 chapterId
│   │   │       │   #   5. 返回失败列表
│   │   │       │   #
│   │   │       ├── batch_merge_graphs_usecase.dart     # 分批合并
│   │   │       │   # 输入：List<ChapterGraph> graphs, int batchNumber, int totalBatches
│   │   │       │   # 输出：Result<ChapterGraph>
│   │   │       │   # 流程：
│   │   │       │   #   1. 提取 graph.data JSON 列表
│   │   │       │   #   2. IAIRepository.batchMergeGraphs(graphList, batchNumber, totalBatches)
│   │   │       │   #   3. IGraphRepository.saveMergedGraph(novelId, result, batchNumber)
│   │   │       │   #
│   │   │       ├── merge_all_graphs_usecase.dart       # 全量合并（分批结果再合并）
│   │   │       │   # 输入：List<ChapterGraph> batchMergedGraphs
│   │   │       │   # 输出：Result<ChapterGraph>
│   │   │       │   # 流程：
│   │   │       │   #   1. 提取 batchMergedGraphs[i].data JSON 列表
│   │   │       │   #   2. IAIRepository.mergeAllGraphs(allGraphs)
│   │   │       │   #   3. IGraphRepository.saveMergedGraph(novelId, result, batchNumber: null)
│   │   │       │   #
│   │   │       ├── export_graphs_usecase.dart          # 导出图谱
│   │   │       │   # 输入：String novelId, ExportFormat format
│   │   │       │   # format: json | png | svg
│   │   │       │   # 输出：Result<String>（文件路径/JSON字符串）
│   │   │       │   # 依赖：IMergedGraphRepository.getMergedGraph(novelId)
│   │   │       │   #
│   │   │       └── import_graphs_usecase.dart           # 导入图谱
│   │   │           # 输入：String jsonString, String novelId
│   │   │           # 输出：Result<ChapterGraph>
│   │   │           # 依赖：IGraphRepository.saveMergedGraph()
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── chapter_graph_dto.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── graph_repository_impl.dart
│   │   │   │       # 依赖：GraphDao
│   │   │   │       # 实现：upsertGraph → INSERT OR REPLACE
│   │   │   │       # 实现：saveMergedGraph → batchNumber 条件覆盖
│   │   │   │       #
│   │   │   └── datasources/
│   │   │       ├── local_graph_datasource.dart  # Drift GraphDao 封装
│   │   │       └── remote_ai_datasource.dart     # AI API 调用
│   │   │           # 依赖：HttpClient
│   │   │           # 实现：AIModel 接口（OpenAI/Gemini/本地模型）
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── graph_provider.dart
│   │       │       # StateNotifierProvider<GraphNotifier, GraphState>
│   │       │       #
│   │       │       # GraphState（Freezed）：
│   │       │       #   - chapterGraphMap: Map<String, ChapterGraph>（chapterId → graph）
│   │       │       #   - mergedGraph: ChapterGraph?（全量合并结果）
│   │       │       #   - batchMergedGraphs: List<ChapterGraph>（分批合并结果）
│   │       │       #   - isGenerating: bool
│   │       │       #   - isMerging: bool
│   │       │       #   - stopFlag: bool（用户停止）
│   │       │       #   - progressText: String?（"3/50"）
│   │       │       #   - complianceResult: GraphComplianceResult?
│   │       │       #   - error: AppException?
│   │       │       #
│   │       │       # GraphNotifier：
│   │       │       #   - loadGraphs(String novelId)
│   │       │       #   - generateAll(List<Chapter> chapters)
│   │       │       #   - generateSingle(Chapter chapter)
│   │       │       #   - batchMerge(int batchNumber, int totalBatches)
│   │       │       #   - mergeAll()
│   │       │       #   - stop()
│   │       │       #   - exportGraphs(ExportFormat format)
│   │       │       #
│   │       ├── screens/
│   │       │   └── graph_viewer_screen.dart        # 图谱可视化主界面
│   │       │       # Widget：
│   │       │       #   - GraphViewer（通用图谱组件）
│   │       │       #   - TabBar（单章/批量/全量切换）
│   │       │       #   - 操作栏（生成/合并/导出）
│   │       │       #   - 进度显示（progressText）
│   │       │       #   - Stop 按钮（stopFlag 控制）
│   │       │       #
│   │       └── widgets/
│   │           └── graph_node_widget.dart          # 图谱节点组件
│   │               # 基于 graphview 库
│   │
│   ├── writing/                                   # 续写模块
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── continue_chapter.dart          # 续写章节实体
│   │   │   │   │   # 字段：id(autoIncrement), novelId, title, content,
│   │   │   │   │   #        baseChapterId, createdAt
│   │   │   │   │   # 用途：存储用户确认采纳的续写结果
│   │   │   │   │   #
│   │   │   │   ├── precheck_result.dart           # 前置校验结果
│   │   │   │   │   # 字段：isCompliant（bool）, violations（List<String>）,
│   │   │   │   │   #        suggestions（List<String>）, preGraph（Map）
│   │   │   │   │   # 用途：续写前的合规性检查
│   │   │   │   │   #
│   │   │   │   ├── quality_result.dart            # 质量评估结果
│   │   │   │   │   # 字段：overallScore（double 0-100）,
│   │   │   │   │   #        coherenceScore, styleScore, creativityScore,
│   │   │   │   │   #        feedback（List<String>）
│   │   │   │   │   # 用途：续写完成后的质量评估
│   │   │   │   │   #
│   │   │   │   └── continue_chain.dart            # 续写链条（内存模型）
│   │   │   │       # 字段：baseChapterId, generations: List<GenerationNode>
│   │   │   │       # GenerationNode: chapterId, content, createdAt
│   │   │   │       # 用途：串联多次续写的上下文
│   │   │   │       # 注意：持久化存储在 ContinueChapters 表
│   │   │   │       #
│   │   │   ├── repositories/
│   │   │   │   └── i_writing_repository.dart       # 续写仓库接口
│   │   │   │       # 方法：
│   │   │   │       #   // 续写历史
│   │   │   │       #   Future<List<ContinueChapter>> getContinueChapters(String novelId);
│   │   │   │       #   Future<void> saveContinueChapter(ContinueChapter cc);
│   │   │   │       #   Future<void> deleteContinueChapter(int id);
│   │   │   │       #   // AI 能力（委托给 IAIRepository）
│   │   │   │       #   Future<String> generateContinuation({
│   │   │   │       #     required String systemPrompt,
│   │   │   │       #     required String userPrompt,
│   │   │   │       #     required int targetWordCount,
│   │   │   │       #   });
│   │   │   │       #   Future<PrecheckResult> precheckContinuation({
│   │   │   │       #     required int baseChapterId,
│   │   │   │       #     required List<Map<String, dynamic>> preGraphList,
│   │   │   │       #     String? modifiedChapterContent,
│   │   │   │       #   });
│   │   │   │       #   Future<QualityResult> evaluateQuality({
│   │   │   │       #     required String continueContent,
│   │   │   │       #     required Map<String, dynamic> precheckResult,
│   │   │   │       #     required Map<String, dynamic> baseGraph,
│   │   │   │       #     required String baseChapterContent,
│   │   │   │       #     required int targetWordCount,
│   │   │   │       #   });
│   │   │   │       #
│   │   │   └── usecases/
│   │   │       ├── run_precheck_usecase.dart       # 前置校验
│   │   │       │   # 输入：int baseChapterId, String? modifiedContent
│   │   │       │   # 输出：Result<PrecheckResult>
│   │   │       │   # 流程：
│   │   │       │   #   1. 获取 baseChapter 内容
│   │   │       │   #   2. 获取 preGraphList（图谱列表，转 Map）
│   │   │       │   #   3. IAIRepository.precheckContinuation(...)
│   │   │       │   #   4. 返回 PrecheckResult
│   │   │       │   #
│   │   │       ├── generate_write_usecase.dart     # 续写生成
│   │   │       │   # 输入：String baseContent, String novelId, int targetWordCount,
│   │   │       │   #        PrecheckResult? precheckResult, bool enableQualityCheck
│   │   │       │   # 输出：Result<GenerationOutput>
│   │   │       │   # GenerationOutput: content, qualityReport?
│   │   │       │   # 流程：
│   │   │       │   #   1. 构建 systemPrompt（包含图谱上下文）
│   │   │       │   #   2. 构建 userPrompt（包含 baseContent + 目标字数）
│   │   │       │   #   3. IAIRepository.generateContinuation(...)
│   │   │       │   #   4. 如果 enableQualityCheck：调用 evaluateQuality
│   │   │       │   #   5. 返回 GenerationOutput
│   │   │       │   #
│   │   │       ├── continue_from_chain_usecase.dart  # 从链条续写
│   │   │       │   # 输入：ContinueChain chain, int targetWordCount
│   │   │       │   # 输出：Result<String>（新续写内容）
│   │   │       │   # 流程：
│   │   │       │   #   1. 拼接 chain.generations 所有内容
│   │   │       │   #   2. 作为新的 baseContent
│   │   │       │   #   3. 调用 GenerateWriteUseCase
│   │   │       │   #
│   │   │       ├── evaluate_quality_usecase.dart    # 质量评估
│   │   │       │   # 输入：String continueContent, PrecheckResult precheck,
│   │   │       │   #        ChapterGraph mergedGraph, Chapter baseChapter, int targetWordCount
│   │   │       │   # 输出：Result<QualityResult>
│   │   │       │   # 依赖：IAIRepository.evaluateQuality()
│   │   │       │   #
│   │   │       └── update_continue_graph_usecase.dart  # 更新续写图谱
│   │   │           # 输入：int continueChapterId
│   │   │           # 输出：Result<void>
│   │   │           # 用途：将采纳的续写章节纳入图谱体系
│   │   │           # 依赖：IGraphRepository.upsertGraph()
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── continue_chapter_dto.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── writing_repository_impl.dart
│   │   │   │       # 依赖：ContinueChapterDao, IAIRepository
│   │   │   │       # 实现：saveContinueChapter 存储采纳结果
│   │   │   │       # 实现：AI 方法委托给 RemoteAIDataSource
│   │   │   │       #
│   │   │   └── datasources/
│   │   │       └── remote_ai_datasource.dart         # AI API 调用实现
│   │   │           # 实现 AIModel 接口
│   │   │           # 依赖：HttpClient, API 配置
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── writing_provider.dart
│   │       │       # StateNotifierProvider<WritingNotifier, WritingState>
│   │       │       #
│   │       │       # WritingState（Freezed）：
│   │       │       #   - currentContent: String?（当前编辑内容）
│   │       │       #   - continueChain: ContinueChain?（续写链条）
│   │       │       #   - history: List<ContinueChapter>（历史续写）
│   │       │       #   - precheckResult: PrecheckResult?
│   │       │       #   - qualityResult: QualityResult?
│   │       │       #   - isGenerating: bool
│   │       │       #   - isCheckingPrecheck: bool
│   │       │       #   - isEvaluatingQuality: bool
│   │       │       #   - error: AppException?
│   │       │       #
│   │       │       # WritingNotifier：
│   │       │       #   - loadHistory(String novelId)
│   │       │       #   - runPrecheck(int baseChapterId, {String? modified})
│   │       │       #   - generate(WriteParams params)
│   │       │       #   - continueFromChain(ContinueChain chain, int wordCount)
│   │       │       #   - evaluateQuality(String content)
│   │       │       #   - adoptGeneration(String content, int baseChapterId)
│   │       │       #   - clearCurrent()
│   │       │       #
│   │       ├── screens/
│   │       │   ├── write_screen.dart                 # 续写主界面
│   │       │   │   # Widget：
│   │       │   │   #   - WritePreview（当前续写内容展示）
│   │       │   │   #   - ContinueChainView（链条视图）
│   │       │   │   #   - PrecheckPanel（前置校验结果）
│   │       │   │   #   - QualityReportCard（质量报告）
│   │       │   │   #   - 操作栏（生成/采纳/放弃）
│   │       │   │   #   - 参数设置（字数、AI模型选择）
│   │       │   │   #
│   │       │   └── write_settings_screen.dart        # 续写参数设置
│   │       │       # Widget：
│   │       │   │   #   - 目标字数滑块
│   │       │   │   #   - AI 模型选择下拉
│   │       │   │   #   - 前置校验开关
│   │       │   │   #   - 质量评估开关
│   │       │   │   #
│   │       └── widgets/
│   │           ├── write_preview.dart                # 续写内容预览
│   │           │   # 展示：续写文本 + diff 标记（相对原文变化）
│   │           │   #
│   │           ├── continue_chain_view.dart          # 续写链条视图
│   │           │   # 展示：线性链条（base → gen1 → gen2 → ...）
│   │           │   # 交互：点击节点查看详情
│   │           │   #
│   │           └── quality_report_card.dart          # 质量报告卡片
│   │               # 展示：各维度评分 + 总体评分
│   │               # 交互：采纳/重新生成
│   │
│   └── settings/                                    # 设置模块
│       ├── domain/
│       │   ├── models/
│       │   │   └── app_config.dart                  # 应用配置实体
│       │   │       # 字段：aiModel（枚举）, apiKey, apiBaseUrl,
│       │   │       #        defaultWordCount, enablePrecheck, enableQualityCheck,
│       │   │       #        themeMode
│       │   │       # AI 模型枚举：openai / gemini / local
│       │   │       #
│       │   │   └── ai_model.dart                    # AI 模型枚举定义
│       │   │       # enum AIModel { openai, gemini, local }
│       │   │       #
│       │   └── usecases/
│       │       ├── get_config_usecase.dart
│       │       │   # 输出：Result<AppConfig>
│       │       │   # 依赖：ISettingsRepository.getConfig()
│       │       │   #
│       │       └── update_config_usecase.dart
│       │           # 输入：AppConfig config
│       │           # 输出：Result<void>
│       │           # 依赖：ISettingsRepository.saveConfig()
│       │
│       ├── data/
│       │   ├── repositories/
│       │   │   └── config_repository_impl.dart
│       │   │       # 依赖：SecureConfigDataSource（flutter_secure_storage）
│       │   │       # + SettingsDao（AppSettings 表）
│       │   │       # 实现策略：
│       │   │       #   - apiKey 等敏感信息存 SecureStorage
│       │   │       #   - 非敏感配置存 Drift AppSettings 表
│       │   │       #
│       │   └── datasources/
│       │       └── secure_config_datasource.dart     # 敏感配置存储
│       │           # 使用 flutter_secure_storage
│       │           # 字段：apiKey, apiSecret
│       │
│       └── presentation/
│           ├── providers/
│           │   └── config_provider.dart
│           │       # StateNotifierProvider<ConfigNotifier, AppConfig>
│           │       #
│           │       # ConfigNotifier：
│           │       │   - loadConfig()
│           │       │   - updateConfig(AppConfig config)
│           │       │   - updateApiKey(String key)
│           │       │   - switchAIModel(AIModel model)
│           │       │
│           │       # 注意：ConfigNotifier 变更后，
│           │       #        需要通知 aiModelProvider 重建
│           │       #        ref.invalidate(aiModelProvider)
│           │       #
│           └── screens/
│               └── settings_screen.dart             # 设置界面
│                   # Widget：
│                   #   - ListTile 分组设置
│                   #   - API Key 输入（密码框）
│                   #   - 模型选择（Radio/Switch）
│                   #   - 字数默认值
│                   #   - 主题切换
│                   #
│
└── common_ui/                                      # 跨功能复用 UI 组件
    ├── widgets/
    │   ├── loading_indicator.dart                   # 通用加载指示器
    │   │   # 参数：String? message（可选提示文本）
    │   │   # 样式：CupertinoActivityIndicator 或 CircularProgressIndicator
    │   │   #
    │   ├── error_view.dart                          # 错误展示组件
    │   │   # 参数：AppException error, VoidCallback? onRetry
    │   │   # 展示：错误图标 + message + 可选重试按钮
    │   │   # 交互：onRetry 回调
    │   │   #
    │   ├── empty_state_view.dart                    # 空状态占位
    │   │   # 参数：IconData icon, String title, String? subtitle, Widget? action
    │   │   # 用途：列表为空时展示
    │   │   #
    │   ├── confirm_dialog.dart                      # 确认对话框
    │   │   # 参数：String title, String message, VoidCallback onConfirm
    │   │   # 展示：AlertDialog / showDialog
    │   │   # 交互：确认/取消按钮
    │   │   #
    │   ├── status_badge.dart                        # 状态徽章
    │   │   # 参数：String label, BadgeStatus status
    │   │   # status: loading | success | error | warning
    │   │   # 样式：不同颜色背景 + 文字
    │   │   #
    │   ├── section_header.dart                     # 分组标题
    │   │   # 参数：String title, Widget? trailing
    │   │   # 用途：ListView 分组标题
    │   │   #
    │   ├── app_scaffold.dart                       # 通用脚手架
    │   │   # 参数：AppBar? appBar, Widget body, Widget? floatingActionButton
    │   │   # 用途：减少重复 scaffold 配置
    │   │   #
    │   ├── graph_viewer.dart                        # 通用图谱可视化组件
    │   │   # 参数：ChapterGraph graph, GraphViewConfig? config
    │   │   # 依赖：graphview 包
    │   │   # 功能：缩放/平移/节点点击
    │   │   #
    │   └── async_value_builder.dart                 # Riverpod AsyncValue builder
    │       # 参数：AsyncValue<T> value, Widget Function(T data) data,
    │       #        Widget Function(Object error, StackTrace)? error,
    │       #        Widget Function()? loading
    │       # 用途：统一处理 FutureProvider/StreamProvider 的 UI
    │       # 类似：flutter_hooks 的 HookBuilder
    │       #
    └── styles/
        ├── colors.dart                             # 颜色常量
        │   # 从 v4_colors.dart 整合
        │   # 包含：primaryColor, accentColor, backgroundColor, errorColor
        │   #
        ├── text_styles.dart                         # 文本样式常量
        │   # 包含：headingStyle, bodyStyle, captionStyle
        │   # 使用：TextTheme.of(context).copyWith(...)
        │   #
        └── spacing.dart                             # 间距常量
            # 包含：paddingXS, paddingS, paddingM, paddingL, paddingXL
            # 包含：marginXS, marginS, marginM, marginL, marginXL
            # 用途：统一间距，减少 magic number
```

---

## 二、数据模型（Freezed 风格）

### 2.1 NovelBook（书架实体）

```dart
// lib/features/bookshelf/domain/models/novel_book.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel_book.freezed.dart';
part 'novel_book.g.dart';

@freezed
class NovelBook with _$NovelBook {
  const factory NovelBook({
    required String id,
    required String title,
    @Default('') String author,
    String? cover,
    String? introduction,
    @Default(0) int chapterCount,
    @Default(0.0) double readProgress,
    String? lastReadChapterId,
    DateTime? lastReadAt,
    required DateTime createdAt,
  }) = _NovelBook;

  factory NovelBook.fromJson(Map<String, dynamic> json) =>
      _$NovelBookFromJson(json);
}
```

### 2.2 Chapter（章节实体）

```dart
// lib/features/chapter_management/domain/models/chapter.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
class Chapter with _$Chapter {
  const Chapter._(); // 私有构造器，允许添加计算属性

  const factory Chapter({
    required String id,
    required String novelId,
    required int number,
    required String title,
    @Default('') String content,
    @Default(false) bool hasGraph,
    @Default(0) int wordCount,
    required DateTime createdAt,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  // 计算属性
  bool get isEmpty => content.trim().isEmpty;

  String get preview {
    final lines = content.split('\n').where((l) => l.trim().isNotEmpty).take(3);
    return lines.join('\n');
  }
}
```

### 2.3 ChapterGraph（图谱实体）

```dart
// lib/features/graph/domain/models/chapter_graph.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_graph.freezed.dart';
part 'chapter_graph.g.dart';

enum GraphType {
  characterRelationship,
  eventChain,
  worldSetting,
}

@freezed
class ChapterGraph with _$ChapterGraph {
  const ChapterGraph._();

  const factory ChapterGraph({
    required String id,
    required String chapterId,
    required String novelId,
    @Default(GraphType.characterRelationship) GraphType type,
    required Map<String, dynamic> data,  // JSON 图谱数据
    required DateTime createdAt,
  }) = _ChapterGraph;

  factory ChapterGraph.fromJson(Map<String, dynamic> json) =>
      _$ChapterGraphFromJson(json);

  // 计算属性：从 data 解析节点/边数量
  int get nodeCount => (data['nodes'] as List?)?.length ?? 0;
  int get edgeCount => (data['edges'] as List?)?.length ?? 0;
}
```

### 2.4 ContinueChapter（续写章节实体）

```dart
// lib/features/writing/domain/models/continue_chapter.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'continue_chapter.freezed.dart';
part 'continue_chapter.g.dart';

@freezed
class ContinueChapter with _$ContinueChapter {
  const factory ContinueChapter({
    int? id,                        // autoIncrement，null 表示未存储
    required String novelId,
    required String title,
    required String content,
    required String baseChapterId,
    required DateTime createdAt,
  }) = _ContinueChapter;

  factory ContinueChapter.fromJson(Map<String, dynamic> json) =>
      _$ContinueChapterFromJson(json);
}
```

### 2.5 ContinueChain（续写链条）

```dart
// lib/features/writing/domain/models/continue_chain.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'continue_chain.freezed.dart';

@freezed
class ContinueChain with _$ContinueChain {
  const ContinueChain._();

  const factory ContinueChain({
    required String baseChapterId,
    @Default([]) List<GenerationNode> generations,
  }) = _ContinueChain;

  factory ContinueChain.fromJson(Map<String, dynamic> json) =>
      _$ContinueChainFromJson(json);

  // 追加新节点
  ContinueChain append(GenerationNode node) => copyWith(
        generations: [...generations, node],
      );

  // 获取最新内容
  String? get latestContent =>
      generations.isNotEmpty ? generations.last.content : null;
}

@freezed
class GenerationNode with _$GenerationNode {
  const factory GenerationNode({
    required String chapterId,  // 续写产生的 chapter ID
    required String content,
    required DateTime createdAt,
  }) = _GenerationNode;

  factory GenerationNode.fromJson(Map<String, dynamic> json) =>
      _$GenerationNodeFromJson(json);
}
```

### 2.6 PrecheckResult（前置校验结果）

```dart
// lib/features/writing/domain/models/precheck_result.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'precheck_result.freezed.dart';
part 'precheck_result.g.dart';

@freezed
class PrecheckResult with _$PrecheckResult {
  const factory PrecheckResult({
    required bool isCompliant,
    @Default([]) List<String> violations,
    @Default([]) List<String> suggestions,
    required Map<String, dynamic> preGraph,
  }) = _PrecheckResult;

  factory PrecheckResult.fromJson(Map<String, dynamic> json) =>
      _$PrecheckResultFromJson(json);
}
```

### 2.7 QualityResult（质量评估结果）

```dart
// lib/features/writing/domain/models/quality_result.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quality_result.freezed.dart';
part 'quality_result.g.dart';

@freezed
class QualityResult with _$QualityResult {
  const factory QualityResult({
    required double overallScore,       // 0-100
    required double coherenceScore,      // 连贯性
    required double styleScore,          // 文风一致性
    required double creativityScore,     // 创意性
    @Default([]) List<String> feedback,
  }) = _QualityResult;

  factory QualityResult.fromJson(Map<String, dynamic> json) =>
      _$QualityResultFromJson(json);
}
```

### 2.8 AppConfig（应用配置）

```dart
// lib/features/settings/domain/models/app_config.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

enum AIModel {
  openai,
  gemini,
  local,
}

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    @Default(AIModel.openai) AIModel aiModel,
    String? apiKey,
    String? apiBaseUrl,
    @Default(2000) int defaultWordCount,
    @Default(true) bool enablePrecheck,
    @Default(true) bool enableQualityCheck,
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
```

---

## 三、UseCase 详细设计

### 3.1 架构原则

- **UseCase 属于 Domain 层**：纯 Dart，无 Flutter 依赖
- **返回 `Result<T>`**：使用 `core/utils/result.dart` 的 Result 联合类型
- **依赖注入**：通过构造函数注入 Repository 接口
- **无状态**：每次调用独立，不保留状态

### 3.2 Result 类型定义

```dart
// lib/core/utils/result.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<E, T> with _$Result<E, T> {
  const factory Result.success(T data) = Success<E, T>;
  const factory Result.failure(E error) = Failure<E, T>;
}

typedef AppResult<T> = Result<AppException, T>;
```

### 3.3 UseCase 列表

| UseCase | 输入 | 输出 | 依赖 |
|---------|------|------|------|
| `GetBookshelfUseCase` | void | `AppResult<List<NovelBook>>` | `INovelRepository` |
| `AddBookUseCase` | `ImportResult` | `AppResult<NovelBook>` | `INovelRepository`, `IChapterRepository` |
| `SelectBookUseCase` | `String novelId` | `AppResult<NovelBook>` | `INovelRepository` |
| `DeleteBookUseCase` | `String novelId` | `AppResult<void>` | `INovelRepository` |
| `GetChaptersUseCase` | `String novelId` | `AppResult<List<Chapter>>` | `IChapterRepository` |
| `ParseChaptersUseCase` | `String text, ParseOptions?` | `AppResult<List<Chapter>>` | 无（纯算法） |
| `SplitByWordCountUseCase` | `String text, int wordCount` | `AppResult<List<Chapter>>` | 无（纯算法） |
| `ImportNovelUseCase` | `String title, String text, String? author` | `AppResult<ImportResult>` | `ParseChaptersUseCase`, `INovelRepository`, `IChapterRepository` |
| `DeleteChaptersUseCase` | `List<String> ids` | `AppResult<void>` | `IChapterRepository` |
| `GenerateSingleGraphUseCase` | `Chapter` | `AppResult<ChapterGraph>` | `IGraphRepository`, `IAIRepository` |
| `GenerateAllGraphsUseCase` | `List<Chapter>, ProgressCallback` | `AppResult<GraphGenerationResult>` | `GenerateSingleGraphUseCase` |
| `BatchMergeGraphsUseCase` | `List<ChapterGraph>, int batchNo, int total` | `AppResult<ChapterGraph>` | `IGraphRepository`, `IAIRepository` |
| `MergeAllGraphsUseCase` | `List<ChapterGraph>` | `AppResult<ChapterGraph>` | `IGraphRepository`, `IAIRepository` |
| `ExportGraphsUseCase` | `String novelId, ExportFormat` | `AppResult<String>` | `IGraphRepository` |
| `ImportGraphsUseCase` | `String json, String novelId` | `AppResult<ChapterGraph>` | `IGraphRepository` |
| `UpdateReadingProgressUseCase` | `String chapterId, double progress` | `AppResult<void>` | `INovelRepository` |
| `RunPrecheckUseCase` | `int baseChapterId, String? modified` | `AppResult<PrecheckResult>` | `IChapterRepository`, `IGraphRepository`, `IAIRepository` |
| `GenerateWriteUseCase` | `WriteParams` | `AppResult<GenerationOutput>` | `IAIRepository` |
| `ContinueFromChainUseCase` | `ContinueChain, int wordCount` | `AppResult<String>` | `GenerateWriteUseCase` |
| `EvaluateQualityUseCase` | `QualityEvalParams` | `AppResult<QualityResult>` | `IAIRepository` |
| `UpdateContinueGraphUseCase` | `int continueChapterId` | `AppResult<void>` | `IContinueChapterRepository`, `IGraphRepository` |
| `GetConfigUseCase` | void | `AppResult<AppConfig>` | `ISettingsRepository` |
| `UpdateConfigUseCase` | `AppConfig` | `AppResult<void>` | `ISettingsRepository` |

---

## 四、Repository 接口设计

### 4.1 INovelRepository

```dart
// lib/features/bookshelf/domain/repositories/i_novel_repository.dart

import '../models/novel_book.dart';

abstract class INovelRepository {
  /// 获取所有小说（书架）
  Future<List<NovelBook>> getAllNovels();

  /// 获取单个小说
  Future<NovelBook?> getNovelById(String id);

  /// 插入小说
  Future<void> insertNovel(NovelBook novel);

  /// 更新小说
  Future<void> updateNovel(NovelBook novel);

  /// 删除小说（级联删除章节和图谱）
  Future<void> deleteNovel(String id);

  /// 监听所有小说变化（响应式）
  Stream<List<NovelBook>> watchAllNovels();

  /// 更新阅读进度
  Future<void> updateReadProgress(String id, double progress);

  /// 选中小说（保存当前选中 ID）
  Future<void> selectNovel(String id);

  /// 获取当前选中小说 ID
  Future<String?> getSelectedNovelId();
}
```

### 4.2 IChapterRepository

```dart
// lib/features/chapter_management/domain/repositories/i_chapter_repository.dart

import '../models/chapter.dart';

abstract class IChapterRepository {
  /// 获取某小说的所有章节
  Future<List<Chapter>> getChaptersByNovelId(String novelId);

  /// 获取单个章节
  Future<Chapter?> getChapterById(String id);

  /// 插入章节
  Future<void> insertChapter(Chapter chapter);

  /// 批量插入章节
  Future<void> insertChapters(List<Chapter> chapters);

  /// 更新章节
  Future<void> updateChapter(Chapter chapter);

  /// 删除章节
  Future<void> deleteChapter(String id);

  /// 批量删除章节
  Future<void> deleteChapters(List<String> ids);

  /// 监听某小说的章节变化
  Stream<List<Chapter>> watchChaptersByNovelId(String novelId);

  /// 标记章节是否有图谱
  Future<void> markChapterHasGraph(String id, bool hasGraph);
}
```

### 4.3 IGraphRepository

```dart
// lib/features/graph/domain/repositories/i_graph_repository.dart

import '../models/chapter_graph.dart';

abstract class IGraphRepository {
  /// 获取某小说的所有图谱
  Future<List<ChapterGraph>> getGraphsByNovelId(String novelId);

  /// 获取某章节的图谱
  Future<ChapterGraph?> getGraphByChapterId(String chapterId);

  /// 插入图谱
  Future<void> insertGraph(ChapterGraph graph);

  /// 插入或覆盖图谱
  Future<void> upsertGraph(ChapterGraph graph);

  /// 删除图谱
  Future<void> deleteGraph(String id);

  /// 删除某章节的图谱
  Future<void> deleteGraphsByChapterId(String chapterId);

  /// 获取某小说的合并图谱
  Future<List<ChapterGraph>> getMergedGraphsByNovelId(String novelId, {int? batchNumber});

  /// 保存合并图谱
  Future<void> saveMergedGraph(String novelId, ChapterGraph graph, {int? batchNumber});
}
```

### 4.4 IAIRepository

```dart
// lib/features/writing/domain/repositories/i_ai_repository.dart

import '../../writing/domain/models/precheck_result.dart';
import '../../writing/domain/models/quality_result.dart';
import '../../graph/domain/models/chapter_graph.dart';

abstract class IAIRepository {
  /// 生成单章节图谱
  Future<ChapterGraph> generateSingleChapterGraph({
    required String chapterId,
    required String chapterTitle,
    required String chapterContent,
    bool isModified = false,
  });

  /// 批量合并图谱
  Future<ChapterGraph> batchMergeGraphs({
    required List<Map<String, dynamic>> graphList,
    required int batchNumber,
    required int totalBatches,
  });

  /// 全量合并图谱
  Future<ChapterGraph> mergeAllGraphs({
    required List<Map<String, dynamic>> graphList,
  });

  /// 生成续写内容
  Future<String> generateContinuation({
    required String systemPrompt,
    required String userPrompt,
    required int targetWordCount,
  });

  /// 前置校验
  Future<PrecheckResult> precheckContinuation({
    required int baseChapterId,
    required List<Map<String, dynamic>> preGraphList,
    String? modifiedChapterContent,
  });

  /// 质量评估
  Future<QualityResult> evaluateQuality({
    required String continueContent,
    required Map<String, dynamic> precheckResult,
    required Map<String, dynamic> baseGraph,
    required String baseChapterContent,
    required int targetWordCount,
  });
}
```

---

## 五、错误处理设计

### 5.1 异常体系

```
AppException（抽象基类）
  ├── NetworkException
  │       ├── ConnectionException      // 网络断开
  │       ├── TimeoutException         // 请求超时
  │       ├── HttpException            // HTTP 错误（4xx/5xx）
  │       └── DNSException            // DNS 解析失败
  │
  ├── DatabaseException
  │       ├── ReadException            // 读取失败
  │       ├── WriteException           // 写入失败
  │       ├── NotFoundException       // 记录不存在
  │       └── ConstraintException     // 约束违反（外键/唯一）
  │
  ├── AIServiceException
  │       ├── RateLimitException       // API 限流
  │       ├── ModelException          // 模型不支持/配置错误
  │       ├── QuotaException          // 额度不足
  │       └── GenerationException     // 生成失败
  │
  └── ValidationException
          ├── EmptyInputException     // 输入为空
          ├── InvalidFormatException  // 格式错误
          └── OutOfRangeException     // 超出范围
```

### 5.2 异常基类

```dart
// lib/core/exceptions/app_exception.dart

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;  // 原始异常，用于调试

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}
```

### 5.3 异常示例

```dart
// lib/core/exceptions/network_exception.dart

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ConnectionException extends NetworkException {
  const ConnectionException({super.originalError})
      : super(message: '网络连接失败，请检查网络设置');
}

class TimeoutException extends NetworkException {
  const TimeoutException({super.originalError})
      : super(message: '请求超时，请稍后重试');
}

class HttpException extends NetworkException {
  final int statusCode;

  const HttpException({
    required this.statusCode,
    required super.message,
    super.originalError,
  });
}
```

### 5.4 Result 与异常转换

```dart
// lib/core/utils/result.dart 扩展

extension ResultExtension<E extends AppException, T> on Result<E, T> {
  /// 将 Result 转为 async Throws 风格
  Future<T> getOrThrow() async {
    return when(
      success: (data) async => data,
      failure: (error) async => throw error,
    );
  }

  /// 转换错误类型
  Result<NewE, T> mapError<NewE extends AppException>(
    NewE Function(E error) mapper,
  ) {
    return when(
      success: (data) => Result.success(data),
      failure: (error) => Result.failure(mapper(error)),
    );
  }
}
```

### 5.5 异常处理流程

```dart
// Riverpod Notifier 中的异常处理模板

class GraphNotifier extends StateNotifier<GraphState> {
  // ... 构造函数注入 UseCase

  Future<void> generateAll(List<Chapter> chapters) async {
    state = state.copyWith(isGenerating: true, error: null);

    try {
      final result = await _generateAllGraphsUseCase.execute(
        chapters,
        onProgress: (current, total) {
          state = state.copyWith(
            progressText: '$current/$total',
          );
        },
      );

      result.fold(
        (error) {
          state = state.copyWith(
            isGenerating: false,
            error: error,
          );
        },
        (data) {
          state = state.copyWith(
            isGenerating: false,
            progressText: null,
            // 更新图谱 map
            chapterGraphMap: {
              ...state.chapterGraphMap,
              for (final g in data.successGraphs) g.chapterId: g,
            },
            failedChapterIds: data.failedChapterIds,
          );
        },
      );
    } catch (e, st) {
      // 未知异常兜底（理论上不会走到这里）
      state = state.copyWith(
        isGenerating: false,
        error: AppException(message: '未知错误: $e'),
      );
    }
  }
}
```

---

## 六、状态管理方案（Riverpod 3.0）

### 6.1 Provider 架构总览

```
core/di/providers.dart
  │
  ├── [Singleton] databaseProvider          → AppDatabase
  ├── [Singleton] httpClientProvider         → Dio
  ├── [Singleton] aiModelProvider             → AIModel（根据配置动态切换）
  │
  │── [Singleton] novelDaoProvider            → NovelDao
  ├── [Singleton] chapterDaoProvider          → ChapterDao
  ├── [Singleton] graphDaoProvider             → GraphDao
  ├── [Singleton] continueChapterDaoProvider  → ContinueChapterDao
  ├── [Singleton] settingsDaoProvider         → SettingsDao
  │
  │── [Factory] iNovelRepositoryProvider      → NovelRepositoryImpl
  ├── [Factory] iChapterRepositoryProvider     → ChapterRepositoryImpl
  ├── [Factory] iGraphRepositoryProvider       → GraphRepositoryImpl
  ├── [Factory] iWritingRepositoryProvider    → WritingRepositoryImpl
  ├── [Factory] iAIRepositoryProvider          → RemoteAIDataSource
  ├── [Factory] iSettingsRepositoryProvider    → ConfigRepositoryImpl
  │
  │── [Factory] getBookshelfUseCaseProvider    → GetBookshelfUseCase
  ├── [Factory] addBookUseCaseProvider         → AddBookUseCase
  ├── [Factory] parseChaptersUseCaseProvider   → ParseChaptersUseCase
  ├── [Factory] generateSingleGraphUseCaseProvider → GenerateSingleGraphUseCase
  ├── [Factory] generateAllGraphsUseCaseProvider  → GenerateAllGraphsUseCase
  ├── [Factory] mergeAllGraphsUseCaseProvider   → MergeAllGraphsUseCase
  ├── [Factory] runPrecheckUseCaseProvider      → RunPrecheckUseCase
  ├── [Factory] generateWriteUseCaseProvider    → GenerateWriteUseCase
  └── ...
```

### 6.2 Provider 定义示例

```dart
// lib/core/di/providers.dart

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized before use');
});

final httpClientProvider = Provider<Dio>((ref) {
  final config = ref.watch(configProvider);
  return Dio(BaseOptions(
    baseUrl: config.apiBaseUrl ?? 'https://api.openai.com',
    headers: {
      'Authorization': 'Bearer ${config.apiKey}',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
  ));
});

final aiModelProvider = Provider<AIModel>((ref) {
  final config = ref.watch(configProvider);
  switch (config.aiModel) {
    case AIModel.openai:
      return OpenAIModel(ref.watch(httpClientProvider));
    case AIModel.gemini:
      return GeminiModel(ref.watch(httpClientProvider));
    case AIModel.local:
      return LocalModelAdapter(ref.watch(httpClientProvider));
  }
});

// Repository Providers
final iNovelRepositoryProvider = Provider<INovelRepository>((ref) {
  return NovelRepositoryImpl(ref.watch(novelDaoProvider));
});

final iChapterRepositoryProvider = Provider<IChapterRepository>((ref) {
  return ChapterRepositoryImpl(ref.watch(chapterDaoProvider));
});

// UseCase Providers
final getBookshelfUseCaseProvider = Provider<GetBookshelfUseCase>((ref) {
  return GetBookshelfUseCase(ref.watch(iNovelRepositoryProvider));
});

final generateSingleGraphUseCaseProvider = Provider<GenerateSingleGraphUseCase>((ref) {
  return GenerateSingleGraphUseCase(
    ref.watch(iGraphRepositoryProvider),
    ref.watch(iChapterRepositoryProvider),
    ref.watch(iAIRepositoryProvider),
  );
});
```

### 6.3 StateNotifier 模式

```dart
// lib/features/graph/presentation/providers/graph_provider.dart

// State
@freezed
class GraphState with _$GraphState {
  const factory GraphState({
    @Default({}) Map<String, ChapterGraph> chapterGraphMap,
    ChapterGraph? mergedGraph,
    @Default([]) List<ChapterGraph> batchMergedGraphs,
    @Default(false) bool isGenerating,
    @Default(false) bool isMerging,
    @Default(false) bool stopFlag,
    String? progressText,
    @Default([]) List<String> failedChapterIds,
    AppException? error,
  }) = _GraphState;
}

// Notifier
class GraphNotifier extends StateNotifier<GraphState> {
  final GenerateSingleGraphUseCase _generateSingle;
  final GenerateAllGraphsUseCase _generateAll;
  final BatchMergeGraphsUseCase _batchMerge;
  final MergeAllGraphsUseCase _mergeAll;
  final IGraphRepository _repository;

  GraphNotifier({
    required GenerateSingleGraphUseCase generateSingle,
    required GenerateAllGraphsUseCase generateAll,
    required BatchMergeGraphsUseCase batchMerge,
    required MergeAllGraphsUseCase mergeAll,
    required IGraphRepository repository,
  })  : _generateSingle = generateSingle,
        _generateAll = generateAll,
        _batchMerge = batchMerge,
        _mergeAll = mergeAll,
        _repository = repository,
        super(const GraphState());

  Future<void> loadGraphs(String novelId) async {
    try {
      final graphs = await _repository.getGraphsByNovelId(novelId);
      state = state.copyWith(
        chapterGraphMap: {for (final g in graphs) g.chapterId: g},
      );
    } catch (e) {
      state = state.copyWith(error: DatabaseException(message: '加载图谱失败'));
    }
  }

  Future<void> generateAll(List<Chapter> chapters) async {
    state = state.copyWith(isGenerating: true, stopFlag: false, error: null);

    final result = await _generateAll.execute(
      chapters,
      onProgress: (current, total) {
        if (state.stopFlag) return;
        state = state.copyWith(progressText: '$current/$total');
      },
    );

    result.fold(
      (error) => state = state.copyWith(isGenerating: false, error: error),
      (data) => state = state.copyWith(
        isGenerating: false,
        progressText: null,
        chapterGraphMap: {
          ...state.chapterGraphMap,
          for (final g in data.successGraphs) g.chapterId: g,
        },
        failedChapterIds: data.failedChapterIds,
      ),
    );
  }

  Future<void> generateSingle(Chapter chapter) async {
    state = state.copyWith(isGenerating: true, error: null);

    final result = await _generateSingle.execute(chapter);

    result.fold(
      (error) => state = state.copyWith(isGenerating: false, error: error),
      (graph) => state = state.copyWith(
        isGenerating: false,
        chapterGraphMap: {...state.chapterGraphMap, chapter.id: graph},
      ),
    );
  }

  Future<void> batchMerge(int batchNumber, int totalBatches) async {
    state = state.copyWith(isMerging: true, error: null);

    final graphs = state.chapterGraphMap.values.toList();
    final result = await _batchMerge.execute(graphs, batchNumber, totalBatches);

    result.fold(
      (error) => state = state.copyWith(isMerging: false, error: error),
      (merged) => state = state.copyWith(
        isMerging: false,
        batchMergedGraphs: [...state.batchMergedGraphs, merged],
      ),
    );
  }

  Future<void> mergeAll() async {
    state = state.copyWith(isMerging: true, error: null);

    final result = await _mergeAll.execute(state.batchMergedGraphs);

    result.fold(
      (error) => state = state.copyWith(isMerging: false, error: error),
      (merged) => state = state.copyWith(
        isMerging: false,
        mergedGraph: merged,
      ),
    );
  }

  void stop() {
    state = state.copyWith(stopFlag: true);
  }
}

// Provider 定义
final graphProvider =
    StateNotifierProvider<GraphNotifier, GraphState>((ref) {
  return GraphNotifier(
    generateSingle: ref.watch(generateSingleGraphUseCaseProvider),
    generateAll: ref.watch(generateAllGraphsUseCaseProvider),
    batchMerge: ref.watch(batchMergeGraphsUseCaseProvider),
    mergeAll: ref.watch(mergeAllGraphsUseCaseProvider),
    repository: ref.watch(iGraphRepositoryProvider),
  );
});
```

### 6.4 FutureProvider + StreamProvider

```dart
// 书架监听（响应式更新）
final watchNovelsProvider = StreamProvider<List<NovelBook>>((ref) {
  final dao = ref.watch(novelDaoProvider);
  return dao.watchAllNovels();
});

// 章节监听
final watchChaptersProvider = StreamProvider.family<List<Chapter>, String>((ref, novelId) {
  final dao = ref.watch(chapterDaoProvider);
  return dao.watchChaptersByNovelId(novelId);
});

// 合并结果查询（只读缓存）
final mergedGraphProvider = FutureProvider.family<ChapterGraph?, (String, int?)>((ref, params) async {
  final (novelId, batchNumber) = params;
  final dao = ref.watch(graphDaoProvider);
  final graphs = await dao.getMergedGraphsByNovelId(novelId, batchNumber: batchNumber);
  return graphs.firstOrNull;
});
```

### 6.5 Riverpod 3.0 代码生成（可选）

```dart
// riverpod_annotation 使用示例（可选，建议项目稳定后启用）
// 需要：riverpod_generator + build_runner

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graph_provider.g.dart';

@riverpod
GraphNotifier graphNotifier(Ref ref) {
  return GraphNotifier(
    generateSingle: ref.watch(generateSingleGraphUseCaseProvider),
    // ...
  );
}

@riverpod
class GraphNotifierGen extends _$GraphNotifier {
  @override
  GraphState build() => const GraphState();

  Future<void> generateAll(List<Chapter> chapters) async { ... }
}
```

---

## 七、Drift 数据库详细设计

### 7.1 表定义

```dart
// lib/core/database/tables/novels.dart
class Novels extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().withDefault(const Constant(''))();
  TextColumn get cover => text().nullable()();
  TextColumn get introduction => text().nullable()();
  IntColumn get chapterCount => integer().withDefault(const Constant(0))();
  RealColumn get readProgress => real().withDefault(const Constant(0.0))();
  TextColumn get lastReadChapterId => text().nullable()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/database/tables/chapters.dart
class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get novelId => text().references(Novels, #id)();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  TextColumn get content => text()();  // TEXT 类型，无大小限制
  BoolColumn get hasGraph => boolean().withDefault(const Constant(false))();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/database/tables/chapter_graphs.dart
class ChapterGraphs extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  TextColumn get novelId => text()();
  TextColumn get type => text().withDefault(const Constant('characterRelationship'))();
  TextColumn get data => text()();  // JSON string
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/database/tables/merged_graphs.dart
class MergedGraphs extends Table {
  TextColumn get id => text()();
  TextColumn get novelId => text()();
  IntColumn get batchNumber => integer().nullable()();  // null = 全量合并
  TextColumn get data => text()();  // JSON string
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/database/tables/continue_chapters.dart
class ContinueChapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get novelId => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get baseChapterId => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// lib/core/database/tables/app_settings.dart
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
```

### 7.2 DAO 设计

```dart
// lib/core/database/daos/novel_dao.dart

@DriftAccessor(tables: [Novels])
class NovelDao extends DatabaseAccessor<AppDatabase> with _$NovelDaoMixin {
  NovelDao(super.db);

  Future<List<Novel>> getAllNovels() => select(novels).get();

  Stream<List<Novel>> watchAllNovels() => select(novels).watch();

  Future<Novel?> getNovelById(String id) =>
      (select(novels)..where((n) => n.id.equals(id))).getSingleOrNull();

  Future<void> insertNovel(Novel novel) => into(novels).insert(novel);

  Future<void> updateNovel(Novel novel) =>
      (update(novels)..where((n) => n.id.equals(novel.id))).write(novel);

  Future<void> deleteNovel(String id) =>
      (delete(novels)..where((n) => n.id.equals(id))).go();

  // 支持 cascade delete（Drift 自动处理）
}
```

### 7.3 数据库初始化

```dart
// lib/core/database/app_database.dart

@DriftDatabase(
  tables: [
    Novels,
    Chapters,
    ChapterGraphs,
    MergedGraphs,
    ContinueChapters,
    AppSettings,
  ],
  daos: [
    NovelDao,
    ChapterDao,
    GraphDao,
    ContinueChapterDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 后续版本升级处理
      },
    );
  }
}
```

---

## 八、AI 服务抽象

### 8.1 AIModel 接口

```dart
// lib/core/network/ai_model.dart

import '../../features/graph/domain/models/chapter_graph.dart';
import '../../features/writing/domain/models/precheck_result.dart';
import '../../features/writing/domain/models/quality_result.dart';

abstract class AIModel {
  /// 生成单章节图谱
  Future<ChapterGraph> generateSingleChapterGraph({
    required String chapterId,
    required String chapterTitle,
    required String chapterContent,
    bool isModified = false,
  });

  /// 批量合并图谱
  Future<ChapterGraph> batchMergeGraphs({
    required List<Map<String, dynamic>> graphList,
    required int batchNumber,
    required int totalBatches,
  });

  /// 全量合并图谱
  Future<ChapterGraph> mergeAllGraphs({
    required List<Map<String, dynamic>> graphList,
  });

  /// 生成续写内容
  Future<String> generateContinuation({
    required String systemPrompt,
    required String userPrompt,
    required int targetWordCount,
  });

  /// 前置校验
  Future<PrecheckResult> precheckContinuation({
    required int baseChapterId,
    required List<Map<String, dynamic>> preGraphList,
    String? modifiedChapterContent,
  });

  /// 质量评估
  Future<QualityResult> evaluateQuality({
    required String continueContent,
    required Map<String, dynamic> precheckResult,
    required Map<String, dynamic> baseGraph,
    required String baseChapterContent,
    required int targetWordCount,
  });
}
```

### 8.2 OpenAI 实现

```dart
// lib/features/writing/data/datasources/openai_model.dart

class OpenAIModel implements AIModel {
  final Dio _httpClient;

  OpenAIModel(this._httpClient);

  @override
  Future<ChapterGraph> generateSingleChapterGraph({
    required String chapterId,
    required String chapterTitle,
    required String chapterContent,
    bool isModified = false,
  }) async {
    final response = await _httpClient.post('/v1/chat/completions', data: {
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'system',
          'content': _GRAPH_SYSTEM_PROMPT,
        },
        {
          'role': 'user',
          'content': '章节标题：$chapterTitle\n\n章节内容：\n${chapterContent.substring(0, min(3000, chapterContent.length))}',
        },
      ],
      'temperature': 0.7,
    });

    final content = response.data['choices'][0]['message']['content'];
    final data = _parseGraphJson(content);

    return ChapterGraph(
      id: const Uuid().v4(),
      chapterId: chapterId,
      novelId: '',  // 由调用方填充
      data: data,
      createdAt: DateTime.now(),
    );
  }

  // ... 其他方法类似
}
```

---

## 九、迁移策略

### 9.1 v4 → v5 数据迁移

```dart
// lib/core/database/migration/hive_to_drift_migrator.dart

class HiveToDriftMigrator {
  final AppDatabase _drift;
  final HiveBox _hiveNovels;
  final HiveBox _hiveChapters;
  final HiveBox _hiveGraphs;

  Future<MigrationResult> migrate() async {
    // 1. 读取 Hive 数据
    final hiveNovels = _hiveNovels.values.cast<NovelBook>().toList();
    final hiveChapters = _hiveChapters.values.cast<Chapter>().toList();
    final hiveGraphs = _hiveGraphs.values.cast<ChapterGraph>().toList();

    // 2. 验证数据完整性
    int totalWordCount = 0;
    for (final chapter in hiveChapters) {
      totalWordCount += chapter.wordCount;
    }

    // 3. 写入 Drift（事务）
    await _drift.batch((batch) async {
      for (final novel in hiveNovels) {
        await _drift.novelDao.insertNovel(novel);
      }
      for (final chapter in hiveChapters) {
        await _drift.chapterDao.insertChapter(chapter);
      }
      for (final graph in hiveGraphs) {
        await _drift.graphDao.insertGraph(graph);
      }
    });

    // 4. 校验
    final driftChapters = await _drift.chapterDao.getAllChapters();
    if (driftChapters.length != hiveChapters.length) {
      throw MigrationException('章节数量不匹配');
    }

    return MigrationResult(
      novelsCount: hiveNovels.length,
      chaptersCount: hiveChapters.length,
      graphsCount: hiveGraphs.length,
      success: true,
    );
  }
}
```

### 9.2 迁移入口

```dart
// lib/main.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive（v4 数据读取）
  await Hive.initFlutter();

  // 初始化 Drift
  final drift = AppDatabase(LazyDatabase(() async {
    return NativeDatabase.memory();
  }));

  // 检查是否需要迁移
  final hiveExists = await Hive.boxExists('novels');
  if (hiveExists) {
    final migrator = HiveToDriftMigrator(
      drift,
      Hive.box('novels'),
      Hive.box('chapters'),
      Hive.box('graphs'),
    );
    await migrator.migrate();
  }

  // 启动 App
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(drift),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## 十、文件清单（完整目录）

以下是 v5.0 架构下所有文件的完整列表：

```
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router/
│   │   └── app_router.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       ├── text_styles.dart
│       └── spacing.dart
│
├── core/
│   ├── di/
│   │   ├── di.dart
│   │   └── providers.dart
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── app_database.g.dart
│   │   ├── daos/
│   │   │   ├── novel_dao.dart
│   │   │   ├── chapter_dao.dart
│   │   │   ├── graph_dao.dart
│   │   │   ├── continue_chapter_dao.dart
│   │   │   └── settings_dao.dart
│   │   ├── tables/
│   │   │   ├── novels.dart
│   │   │   ├── chapters.dart
│   │   │   ├── chapter_graphs.dart
│   │   │   ├── merged_graphs.dart
│   │   │   ├── continue_chapters.dart
│   │   │   └── app_settings.dart
│   │   └── migration/
│   │       └── hive_to_drift_migrator.dart
│   ├── network/
│   │   ├── http_client.dart
│   │   ├── api_endpoints.dart
│   │   ├── api_interceptors.dart
│   │   └── ai_model.dart
│   ├── utils/
│   │   ├── result.dart
│   │   ├── uuid_generator.dart
│   │   ├── text_chunker.dart
│   │   └── date_formatter.dart
│   └── exceptions/
│       ├── app_exception.dart
│       ├── network_exception.dart
│       ├── database_exception.dart
│       ├── ai_service_exception.dart
│       └── validation_exception.dart
│
├── features/
│   ├── bookshelf/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── novel_book.dart
│   │   │   │   ├── novel_book.freezed.dart
│   │   │   │   └── novel_book.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_novel_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_bookshelf_usecase.dart
│   │   │       ├── add_book_usecase.dart
│   │   │       ├── select_book_usecase.dart
│   │   │       └── delete_book_usecase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── novel_book_dto.dart
│   │   │   ├── repositories/
│   │   │   │   └── bookshelf_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── local_bookshelf_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── bookshelf_provider.dart
│   │       │   └── bookshelf_provider.g.dart
│   │       ├── screens/
│   │       │   └── bookshelf_screen.dart
│   │       └── widgets/
│   │           ├── book_card.dart
│   │           └── book_list_tile.dart
│   │
│   ├── chapter_management/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── chapter.dart
│   │   │   │   ├── chapter.freezed.dart
│   │   │   │   └── chapter.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_chapter_repository.dart
│   │   │   └── usecases/
│   │   │       ├── parse_chapters_usecase.dart
│   │   │       ├── split_by_word_count_usecase.dart
│   │   │       ├── import_novel_usecase.dart
│   │   │       ├── get_chapters_usecase.dart
│   │   │       └── delete_chapters_usecase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── chapter_dto.dart
│   │   │   ├── repositories/
│   │   │   │   └── chapter_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── local_chapter_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── chapter_provider.dart
│   │       │   └── chapter_provider.g.dart
│   │       ├── screens/
│   │       │   ├── chapters_screen.dart
│   │       │   └── import_screen.dart
│   │       └── widgets/
│   │           ├── chapter_list_item.dart
│   │           └── chapter_parser_preview.dart
│   │
│   ├── reader/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── update_reading_progress_usecase.dart
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── settings_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── reader_provider.dart
│   │       │   └── reader_provider.g.dart
│   │       ├── screens/
│   │       │   └── reader_screen.dart
│   │       └── widgets/
│   │           └── reader_text_view.dart
│   │
│   ├── graph/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── chapter_graph.dart
│   │   │   │   ├── chapter_graph.freezed.dart
│   │   │   │   └── chapter_graph.g.dart
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
│   │   │   ├── models/
│   │   │   │   └── chapter_graph_dto.dart
│   │   │   ├── repositories/
│   │   │   │   └── graph_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── local_graph_datasource.dart
│   │   │       └── remote_ai_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── graph_provider.dart
│   │       │   └── graph_provider.g.dart
│   │       ├── screens/
│   │       │   └── graph_viewer_screen.dart
│   │       └── widgets/
│   │           └── graph_node_widget.dart
│   │
│   ├── writing/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── continue_chapter.dart
│   │   │   │   ├── continue_chapter.freezed.dart
│   │   │   │   ├── continue_chapter.g.dart
│   │   │   │   ├── continue_chain.dart
│   │   │   │   ├── continue_chain.freezed.dart
│   │   │   │   ├── continue_chain.g.dart
│   │   │   │   ├── precheck_result.dart
│   │   │   │   ├── precheck_result.freezed.dart
│   │   │   │   ├── precheck_result.g.dart
│   │   │   │   ├── quality_result.dart
│   │   │   │   ├── quality_result.freezed.dart
│   │   │   │   └── quality_result.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_ai_repository.dart
│   │   │   └── usecases/
│   │   │       ├── run_precheck_usecase.dart
│   │   │       ├── generate_write_usecase.dart
│   │   │       ├── continue_from_chain_usecase.dart
│   │   │       ├── evaluate_quality_usecase.dart
│   │   │       └── update_continue_graph_usecase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── continue_chapter_dto.dart
│   │   │   ├── repositories/
│   │   │   │   └── writing_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── remote_ai_datasource.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── writing_provider.dart
│   │       │   └── writing_provider.g.dart
│   │       ├── screens/
│   │       │   ├── write_screen.dart
│   │       │   └── write_settings_screen.dart
│   │       └── widgets/
│   │           ├── write_preview.dart
│   │           ├── continue_chain_view.dart
│   │           └── quality_report_card.dart
│   │
│   └── settings/
│       ├── domain/
│       │   ├── models/
│       │   │   ├── app_config.dart
│       │   │   ├── app_config.freezed.dart
│       │   │   └── app_config.g.dart
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
│           │   ├── config_provider.dart
│           │   └── config_provider.g.dart
│           └── screens/
│               └── settings_screen.dart
│
└── common_ui/
    ├── widgets/
    │   ├── loading_indicator.dart
    │   ├── error_view.dart
    │   ├── empty_state_view.dart
    │   ├── confirm_dialog.dart
    │   ├── status_badge.dart
    │   ├── section_header.dart
    │   ├── app_scaffold.dart
    │   ├── graph_viewer.dart
    │   └── async_value_builder.dart
    └── styles/
        ├── colors.dart
        ├── text_styles.dart
        └── spacing.dart
```

**文件统计**：
- Dart 源文件：~120-150 个（不含生成文件）
- 生成的 Freezed/Drift 文件：~60-80 个
- **总计**：~180-230 个 Dart 文件

---

## 十一、技术栈依赖

```yaml
# pubspec.yaml v5.0 核心依赖

dependencies:
  flutter:
    sdk: flutter

  # 状态管理
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # 数据库
  drift: ^2.22.1
  sqlite3_flutter_libs: ^0.5.28
  path_provider: ^2.1.5
  path: ^1.9.1

  # 序列化
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # 网络
  dio: ^5.8.0
  flutter_secure_storage: ^9.2.4

  # 工具
  uuid: ^4.5.1
  intl: ^0.20.2
  collection: ^1.19.1
  equatable: ^2.0.7

  # UI
  go_router: ^14.8.1
  graphview: ^1.2.0
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.15
  freezed: ^2.5.8
  json_serializable: ^6.9.4
  riverpod_generator: ^2.6.5
  drift_dev: ^2.22.1
  mockito: ^5.4.5
  mocktail: ^1.0.4
```

---

_本文档为 v5.0 详细架构实现规范，需与 `ITERATION_PLAN_v5.md` 和 `ARCHITECTURE_v5.md` 配合使用。_
