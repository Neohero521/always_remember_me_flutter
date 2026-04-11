# Always Remember Me v3.0 架构设计

## 一、现状分析

### 1.1 当前 5-Tab 结构

`main.dart` 的 `MainShell` 实际只有 3 个 Tab（书架/续写/章节），HomeScreen 在代码中但从未被使用——是一个被遗忘的 554 行大页面。

**实际 5-Tab 对应 Screen（推测）：**
```
Tab0: BookshelfScreen  → 书架
Tab1: WriteScreen      → 续写核心
Tab2: ChaptersScreen   → 章节管理
Tab3: (推测) HomeScreen → 仪表盘/快捷入口
Tab4: (推测) Settings   → 设置
```

### 1.2 各 Screen 职责

| Screen | 行数 | 职责 |
|---|---|---|
| `HomeScreen` | 554 | 状态卡片、快捷入口（续写/图谱/导入/导出/链条）、对话框 |
| `WriteScreen` | ~1000 | 基准章节选择、续写生成、质量评估、链条续写 |
| `BookshelfScreen` | ~1000 | 书架 CRUD、书籍切换 |
| `ChaptersScreen` | ~700 | 章节列表、图谱生成、合规校验 |
| `ImportScreen` | — | TXT 导入 |
| `ReaderScreen` | — | 阅读器 |
| `GraphViewerScreen` | — | 图谱可视化 |
| `SettingsScreen` | — | API 配置 |

### 1.3 核心问题

1. **HomeScreen 未被使用**——内容（状态卡片、快捷操作）实际有价值但被闲置
2. **5-Tab 结构过碎**——用户需要在多个 Tab 间跳转才能完成"续写一本书"这个完整流程
3. **HomeScreen 的 QuickAction 本质是 WriteScreen 的前置入口**——应该整合
4. **Drawer 缺失**——目前只有 BottomNav，缺少全局导航抽屉

---

## 二、重构目标

**从 5-Tab → 单Tab（WriteScreen） + Drawer 侧边栏导航**

- WriteScreen 成为唯一主屏（因为它是核心功能）
- Drawer 承载：书架、章节管理、首页仪表盘、设置、图谱、导入
- BottomNav 移除或简化为 WriteScreen 内的子 Tab

---

## 三、新目录结构

```
lib/
├── main.dart                          # 启动 + App 根节点
├── app/
│   ├── app_shell.dart                 # 单Tab外壳：Scaffold + Drawer
│   ├── drawer_menu.dart                # Drawer 菜单定义
│   └── router.dart                    # 路由配置（go_router 或手动 Navigator）
│
├── screens/
│   ├── write/
│   │   ├── write_screen.dart          # 主屏：续写（整合原 HomeScreen 快捷入口）
│   │   ├── write_tab.dart             # 续写 Tab（基准章节选择 + 生成）
│   │   ├── chain_tab.dart             # 续写链条 Tab
│   │   ├── graph_status_tab.dart      # 图谱状态 Tab
│   │   └── widgets/
│   │       ├── chapter_selector.dart  # 章节选择器
│   │       ├── precheck_drawer.dart   # 前置校验抽屉
│   │       └── quality_result_card.dart
│   │
│   ├── bookshelf/
│   │   └── bookshelf_screen.dart
│   │
│   ├── chapters/
│   │   └── chapters_screen.dart
│   │
│   ├── reader/
│   │   └── reader_screen.dart
│   │
│   ├── graph/
│   │   └── graph_viewer_screen.dart
│   │
│   ├── import/
│   │   └── import_screen.dart
│   │
│   └── settings/
│       └── settings_screen.dart
│
├── providers/
│   ├── novel_provider.dart             # 现有 provider（不变）
│   └── (可选拆分，见 §五）
│
├── models/
│   └── ...                             # 不变
│
├── services/
│   └── ...                             # 不变
│
└── theme/
    └── game_console_theme.dart         # 不变
```

---

## 四、路由方案

### 4.1 方案选择：手写 Navigator（轻量）

当前 App 使用 `MaterialApp routes:` + `Navigator.pushNamed`，迁移成本最低。

### 4.2 路由定义

```dart
// app/router.dart
static const home      = '/';           // WriteScreen（主屏）
static const bookshelf = '/bookshelf';  // 书架
static const chapters  = '/chapters';   // 章节管理
static const reader    = '/reader';      // 阅读器
static const graph     = '/graph';       // 图谱查看器
static const import    = '/import';      // 导入
static const settings  = '/settings';   // 设置

// main.dart
routes: {
  '/':           (_) => const AppShell(),         // WriteScreen 作为默认页
  '/bookshelf':  (_) => const BookshelfScreen(),
  '/chapters':   (_) => const ChaptersScreen(),
  '/reader':     (_) => const ReaderScreen(),
  '/graph':      (_) => const GraphViewerScreen(),
  '/import':     (_) => const ImportScreen(),
  '/settings':   (_) => const SettingsScreen(),
}
```

### 4.3 Drawer 导航

```dart
// app/drawer_menu.dart
Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          // 头像/书名区
          _buildHeader(context),
          const Divider(),
          // 主导航
          _DrawerItem(icon: '✍️', label: '续写', route: '/'),
          _DrawerItem(icon: '📚', label: '书架', route: '/bookshelf'),
          _DrawerItem(icon: '📖', label: '章节管理', route: '/chapters'),
          const Divider(),
          _DrawerItem(icon: '📊', label: '图谱总览', route: '/graph'),
          _DrawerItem(icon: '📥', label: '导入小说', route: '/import'),
          _DrawerItem(icon: '⚙️', label: '设置', route: '/settings'),
        ],
      ),
    ),
  );
}
```

### 4.4 Drawer 如何调用不同 Screen

每个 `_DrawerItem.onTap` 调用 `Navigator.pushNamed(route)` 或直接 `push`，Drawer's `Scaffold.of(context).openEndDrawer()` 在跳转到新页面后自动关闭 Drawer。

---

## 五、状态管理方案

### 5.1 NovelProvider 够用吗？

**答案：基本够用，但需要拆分。**

当前 `NovelProvider` 已经是一个**超大型单 Provider**（约 600 行），包含了：
- API 配置
- 书架状态
- 章节状态
- 图谱状态
- 续写状态
- 阅读器状态

### 5.2 推荐：保留单 Provider + 拆分通知

考虑到：
1. 状态高度耦合（章节/图谱/续写相互依赖）
2. 拆分多个 Provider 会增加大量 `context.read<SubProvider>()` 改造成本
3. 当前单 Provider 性能问题不大（Hive 防抖写入已优化）

**建议方案：保留 `NovelProvider`，但按职责分组为多个 ChangeNotifier 内部类**

```dart
// providers/novel_provider.dart

class NovelProvider extends ChangeNotifier {
  // === 配置（Config）===
  late final ConfigNotifier config;   // API配置、写作字数等
  
  // === 书架（Bookshelf）===
  late final BookshelfNotifier bookshelf;  // 书架 CRUD
  
  // === 章节（Chapters）===
  late final ChapterNotifier chapters;     // 章节解析、基准选择
  
  // === 图谱（Graph）===
  late final GraphNotifier graph;           // 图谱生成/合并
  
  // === 续写（Write）===
  late final WriteNotifier write;           // 续写生成、链条
  
  // === 阅读器（Reader）===
  late final ReaderNotifier reader;         // 字号、当前章节
}
```

每个内部类继承 `GeneratedNotifier`（封装 `notifyListeners()`），外部通过 `provider.config.xxx` 访问。

> **注意**：这个拆分是内部重构，对外 API（getter/setter）保持兼容，无需修改 Screen 代码。

### 5.3 不拆分出去的独立 Provider

| Provider | 原因 |
|---|---|
| `ThemeProvider` | 不需要，无复杂主题切换 |
| `NotificationProvider` | 不需要，SnackBar 直接用 |
| `AppNavigationProvider` | 不需要，路由直接用 `Navigator` |

---

## 六、WriteScreen 整合方案（核心）

### 6.1 HomeScreen 功能整合到 WriteScreen

原 `HomeScreen` 的内容按类型拆分：

| 原 HomeScreen 内容 | 目标位置 |
|---|---|
| `_StatusCard`（章节/图谱统计） | WriteScreen 顶部 AppBar 下方折叠区 |
| `_QuickActionCard`（一键续写） | WriteScreen 主按钮区 |
| `_QuickActionCard`（生成图谱） | Drawer → 章节管理页面 或 WriteScreen 图谱 Tab |
| `_QuickActionCard`（合并图谱） | Drawer → 章节管理页面 |
| `_QuickActionCard`（续写链条） | WriteScreen 的 Chain Tab |
| `_QuickActionCard`（导入/导出图谱） | Drawer → 对应页面 |
| 空状态提示（无小说） | WriteScreen 空状态 → 引导去书架/导入 |

### 6.2 WriteScreen 内部分 Tab（替代原 BottomNav）

```dart
// WriteScreen 内部分 Tab（使用 TabBar）
TabBar:
  [续写] [链条] [图谱状态]

// WriteScreen 整体结构
Scaffold(
  appBar: AppBar(title: '✍️ AI 续写', ...),
  drawer: AppDrawer(),
  body: Column(
    children: [
      // 状态栏（整合自 HomeScreen._StatusCard）
      _QuickStatusBar(),
      // TabBarView
      Expanded(child: TabBarView(children: [
        WriteTab(),      // 续写
        ChainTab(),      // 续写链条
        GraphStatusTab() // 图谱状态
      ]))
    ]
  )
)
```

### 6.3 Drawer 作为全局导航中心

```
┌─────────────────────────────────┐
│  Always Remember Me             │
│  ══════════════════             │
│  📖 当前：《小说名》            │
│     第 N 章 / 共 M 章           │
├─────────────────────────────────┤
│  ✍️ 续写            ← 主屏      │
│  📚 书架                        │
│  📖 章节管理                    │
├─────────────────────────────────┤
│  📊 图谱总览                    │
│  📥 导入小说                    │
│  ⚙️ 设置                       │
└─────────────────────────────────┘
```

---

## 七、AppShell（Scaffold 根节点）

```dart
// app/app_shell.dart
class AppShell extends StatelessWidget {
  final Widget child;
  final String title;
  final Color? appBarColor;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
    this.appBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: appBarColor ?? CutePixelColors.bg2,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon('☰'),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}
```

每个 Screen 用 `AppShell` 包裹，`/routes` 中的 builder 直接返回带 `AppShell` 的 Screen。

---

## 八、迁移步骤（实施计划）

### Phase 1: 搭建骨架
1. 创建 `app/` 目录，写 `app_shell.dart`、`drawer_menu.dart`、`router.dart`
2. 修改 `main.dart`：`MainShell` → `MaterialApp routes: '/' → AppShell(WriteScreen)`
3. 验证 Drawer 正常打开，路由跳转正常

### Phase 2: WriteScreen 重构
1. 在 `WriteScreen` 顶部添加 `_QuickStatusBar`（整合自 HomeScreen._StatusCard）
2. 添加内部 `TabBar`（续写/链条/图谱）
3. 迁移 `HomeScreen._QuickActionCard` 中与续写相关的入口到 WriteTab
4. 删除 `HomeScreen` 引用

### Phase 3: 抽屉完成
1. 完成 `AppDrawer` 所有菜单项
2. 确保每个菜单正确路由到对应 Screen
3. 书架、章节管理 Screen 不变，验证功能正常

### Phase 4: 清理
1. 删除 `main.dart` 中未使用的 `MainShell`、`_CuteNavItem`
2. 删除 `DefaultTabController`（不再需要 5-Tab）
3. 删除不再引用的 Screen 文件（HomeScreen 整个文件）

### Phase 5: Provider 重构（可选）
1. 将 `NovelProvider` 内部按 `ConfigNotifier/BookshelfNotifier/ChapterNotifier/GraphNotifier/WriteNotifier` 分组
2. 对外 API 不变，内部实现隔离

---

## 九、关键设计决策

| 决策 | 选择 | 理由 |
|---|---|---|
| 路由方案 | 保持手写 `Navigator` | 轻量，迁移成本最低，无需引入 go_router |
| Drawer vs BottomSheet | Drawer | 全局导航需要，不占用内容区 |
| WriteScreen 内 Tab vs 新建 Screen | WriteScreen 内 Tab | 续写/链条/图谱状态是同一功能域，不需要独立路由 |
| Provider 拆分粒度 | 不拆分（内部分组） | 状态高度耦合，Screen 代码无需改动 |
| BottomNav 移除 | 移除 | Drawer 完全替代，且减少用户认知负担 |

---

## 十、风险与注意事项

1. **`DefaultTabController` 移除后**，原 `HomeScreen._scrollToWriteTab()` 用 `DefaultTabController.of(context).animateTo(3)` 跳转的方式失效。需要改为路由跳转 `Navigator.pushNamed('/')`。
2. **`_persistTimer` 防抖**依赖 Provider 实例存在，拆分内部类后仍需确保 `_schedulePersist()` 在同一入口调用。
3. **书架切换时**需要确认 Drawer 当前书籍信息能正确刷新（NovelProvider notifyListeners 后 Drawer 会自动 rebuild）。
4. **WriteScreen 空状态**需要处理：无小说时显示引导去书架/导入，而不是报错。
