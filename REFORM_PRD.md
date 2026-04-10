# Always Remember Me Flutter — 重构 PRD v1.0

> 产品经理输出 · 基于现有代码审计 + 项目背景

---

## 一、项目概述

**项目名称：** Always Remember Me Flutter（小说续写辅助工具）

**项目性质：** Flutter Android App，将 SillyTavern Always_remember_me 扩展移植至移动端

**核心价值：** 让用户在手机上完成小说导入、AI 续写、知识图谱管理、阅读的一站式体验

**当前版本：** v1.0 APK（已发布），存在 UI/UX、功能 Bug、架构三重问题

**源码路径：** `/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`

---

## 二、现有 UI/UX 问题清单

| # | 问题 | 严重程度 |
|---|------|----------|
| 1 | 纯 Material Design，灰色蓝色调，毫无游戏感，整体 UI 像管理后台 | 高 |
| 2 | 5 个 Tab 太多太散：书架/首页/章节/续写/设置，首页和章节功能高度重叠 | 高 |
| 3 | HomeScreen 密密麻麻的 QuickActionCard 列表无层次区分，视觉疲劳 | 高 |
| 4 | 各页面 AppBar 颜色不统一（有的 deepPurple.shade50，有的无背景） | 中 |
| 5 | Card 样式杂乱：有的 elevation=1，有的无背景色，有的圆角14px | 中 |
| 6 | 空状态提示简陋（灰色图标+文字，没有引导性） | 中 |
| 7 | 设置页面有打字机主题但其他页面完全没有，一致性为零 | 中 |
| 8 | 底部 NavigationBar 是普通 Material 3 样式，与游戏风完全不搭 | 高 |
| 9 | 按钮、进度条、对话框全部是标准 Material 风格，无像素装饰 | 高 |
| 10 | 所有 Card 缺少像素边框装饰（应有 Border.all width:2-3px） | 中 |

---

## 三、功能 Bug 清单

| # | Bug | 位置 | 优先级 |
|---|-----|------|--------|
| 1 | `_pickFile` 里 `fileName` 被赋值两次（行51 和行54），第二次覆盖第一次，导致第二个赋值语句冗余且语义不清 | `import_screen.dart` 行51、54 | **P0** |
| 2 | `selectBook` 逻辑虽有修复但未充分测试，快速切换 Tab 时可能状态不一致 | `novel_provider.dart` / `bookshelf_screen.dart` | **P0** |
| 3 | 批量图谱生成是串行 `for` 循环，无队列/并发管理，生成失败无法 retry，中途无法暂停续生成 | `novel_provider.dart` `generateGraphsForAllChapters()` | **P0** |
| 4 | `isGeneratingGraph` 是 `bool`，批量生成中途无法精准报告"已成功 N 个，失败 M 个"，用户看不到实时进度详情 | `novel_provider.dart` / API service | **P0** |
| 5 | 书架页面点击某书后，`_loadBookData` 还没完成时用户快速切换 Tab 导致状态不一致（无 loading guard） | `bookshelf_screen.dart` | **P0** |
| 6 | 没有全局错误处理：API 失败时只 `debugPrint`，不显示友好错误 Snackbar/对话框，用户不知道失败原因 | 全局 | **P0** |
| 7 | 章节阅读器字号/进度持久化已有，但阅读器内没有"返回时自动保存进度"逻辑（离开时可能丢失） | `reader_screen.dart` | **P0** |
| 8 | 图谱合并是全量合并，没有增量合并优化（小说修改后需重新合并全部章节） | `novel_provider.dart` `mergeAllGraphs()` | P1 |
| 9 | `continueChain` 章节阅读支持缺失，ReaderScreen 只读原始 chapters | `reader_screen.dart` | P1 |
| 10 | 章节删除/重命名功能完全缺失，无法修正识别错误的章节 | 未实现 | P1 |

---

## 四、架构问题清单

| # | 问题 | 位置 | 优先级 |
|---|-----|------|--------|
| 1 | Provider 的 `_chapters` 是普通 `List` 不是 Observable，依赖 `notifyListeners` 手动驱动 UI，状态同步不可靠 | `novel_provider.dart` | **P0** |
| 2 | 没有统一的 loading/error/data 三分状态抽象（AsyncValue/Result wrapper），各 API 调用错误处理不一致 | 全局 services | **P0** |
| 3 | SharedPreferences 存 API 配置，Hive 存小说数据，混用但没有版本迁移机制，数据结构变更后可能丢数据 | `storage_service.dart` / `novel_provider.dart` | P1 |
| 4 | Provider 没有做状态不可变性保护，所有 setter 直接修改字段，容易产生意外副作用 | `novel_provider.dart` | P1 |
| 5 | 没有统一的超时/重试策略抽象，API service 内 Retry 逻辑硬编码 | `novel_api_service.dart` | P2 |
| 6 | Widget 层直接调用 Provider 方法，缺少 UseCase/Repository 抽象层，单测困难 | 全局 screens | P2 |

---

## 五、重构目标：像素可爱游戏风

### 5.1 视觉风格定义

**参考：** Game Boy / GBA SP 复古像素游戏 UI

目标用户情感：可爱、怀旧、有趣，让写小说像玩游戏一样轻松愉快。

---

## 六、Tab 导航重组方案

### 当前问题
5 个 Tab = 书架 / 首页 / 章节 / 续写 / 设置
- 首页（快捷操作）和章节（章节管理）高度重叠
- 书架和首页功能部分重叠（都能触发导入/阅读）
- Tab 过多导致切换成本高

### 推荐方案：精简为 3 个主屏

```
Tab 0: 📚 书架（Bookshelf）
  └─ 当前选中书的信息卡 + 快捷操作入口（导入/阅读/一键续写）
  └─ 书架列表（切换书籍）
  └─ 核心 QuickAction 整合进书架页面，不再有独立首页

Tab 1: ✍️ 续写工作台（Write Studio）
  └─ 左侧/顶部：章节列表（可折叠）
  └─ 主体：续写操作区（基准章节选择 + 续写 + 预览）
  └─ 图谱操作（生成/合并/查看）整合进工作台
  └─ 续写链条管理

Tab 2: ⚙️ 设置 / 图谱（Settings & Graph）
  └─ API 配置（Base URL / Key / 模型）
  └─ 全局图谱查看器
  └─ 导入/导出图谱
  └─ 字号/阅读器偏好
```

### 备选方案：精简为 2 个主屏（如果 UI 空间足够）

```
Tab 0: 📚 书架 + 快捷操作（整合）
Tab 1: ✍️ 续写工作台（章节管理 + 续写 + 图谱全部整合）
```

**推荐采用 3 Tab 方案**，保持各功能域清晰分离，避免单 Tab 过于拥挤。

---

## 七、像素游戏风配色详细规范

### 7.1 调色板（GBA/SP 风格）

```dart
// === 主背景 ===
static const Color bgPrimary    = Color(0xFF1a1c2c);  // 深蓝黑（主背景）
static const Color bgSecondary  = Color(0xFF333c57);  // 灰蓝（次级卡片/面板）
static const Color bgTertiary   = Color(0xFF262b44);  // 中等深度背景（输入框/凹陷区域）

// === 主色调 ===
static const Color blueMain     = Color(0xFF41a6f6);  // 像素蓝（主要按钮/链接）
static const Color blueLight    = Color(0xFF5fcde4);  // 浅蓝（hover/次要强调）
static const Color cyanBright   = Color(0xFF73eff7);  // 亮青（高亮/选中状态）

// === 强调色 ===
static const Color orange       = Color(0xFFf77622);  // 橙色（警告/重要操作）
static const Color red          = Color(0xFFff0044);  // 像素红（错误/危险）
static const Color redDark      = Color(0xFFb13f42);  // 暗红（深色错误/边框）

// === 文字色 ===
static const Color textPrimary  = Color(0xFFd4f0f8);  // 亮白（主要文字）
static const Color textSecondary= Color(0xFF94b0c2);  // 灰蓝白（次要文字/描述）

// === 语义色 ===
static const Color success      = Color(0xFF38b764);  // 像素绿
static const Color warning      = Color(0xFFf77622);  // 橙色（同 orange）
static const Color error       = Color(0xFFff0044);  // 像素红（同 red）

// === 边框/装饰 ===
static const Color borderLight  = Color(0xFF566c86);  // 像素边框（亮边）
static const Color borderDark   = Color(0xFF1a1c2c);  // 像素边框（暗边，3D 效果用）
static const Color shadowColor  = Color(0xFF0d0e14); // 阴影色（按钮凸起效果）
```

### 7.2 字体规范

```dart
// 像素风格字体（用于标题/菜单/按钮）
// 推荐：Google Fonts "Press Start 2P"（英文）+ "Noto Sans JP Black"（日文/中文备选）
// 
// 中文 Fallback：Noto Sans SC / 系统默认
// 英文 Fallback：monospace / Courier

// 使用方式：
// 标题/菜单：Press Start 2P, 10-14sp（像素字体字距大，慎用中文）
// 正文/描述：Noto Sans SC, 14-16sp（保证中文清晰可读）
// 代码/JSON：monospace, 12sp

// 注意：Press Start 2P 是英文字体，中文需 fallback 到 Noto Sans SC
// Flutter 字体叠加方案：
//   TextStyle(fontFamily: 'PressStart2P', fontFamilyFallback: ['NotoSansSC'])
```

### 7.3 图标规范

```dart
// 优先使用 emoji 作为像素风格图标：
// 📚 书架    ✍️ 续写    📖 阅读    🗺️ 图谱
// ⚙️ 设置    📥 导入    📤 导出    🔗 合并
// 🗑️ 删除    ✏️ 编辑    ▶️ 开始    ⏹️ 停止
// 📊 进度    ✅ 成功    ❌ 错误    ⚠️ 警告
// 🔄 刷新    💾 保存    📄 章节

// 次选：CupertinoIcons / Material Icons（但要去掉填充效果，使用 outlined 版本）
// 像素化处理：Icon size 使用 20-24px，不要使用 18px 以下的 icon
```

---

## 八、像素游戏风组件规范

### 8.1 像素边框 Card

```dart
// 像素边框 Card — 所有内容卡片统一使用
// 特征：Border.all(width: 2) + 阶梯角（ClipPath 或 BeveledRectangleBorder）
//       3D 凸起效果（亮边在左上，暗边在右下）

Container(
  decoration: BoxDecoration(
    color: bgSecondary,
    border: Border.all(color: borderLight, width: 2),
    // 像素凸起效果：左上亮、右下暗
    boxShadow: [
      BoxShadow(color: borderLight, offset: Offset(-2, -2)), // 亮边
      BoxShadow(color: shadowColor, offset: Offset(2, 2)),  // 暗边
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.zero, // 像素风格不用圆角，改用阶梯角
    child: // 内容
  ),
)

// 阶梯角实现（像素风格特征）：
class PixelBorder extends StatelessWidget {
  static const double stairSize = 4.0; // 阶梯大小
  ...
}

// 简化版（推荐先用这个）：直接用 Border + ClipRRect(radius: 0)
```

### 8.2 像素风格按钮

```dart
// 像素按钮 — 3D 凸起效果
// 默认：背景蓝色 + 亮边左上 + 暗边右下（凸起）
// 按下：背景深2px + 亮暗边互换（凹陷）

Container(
  decoration: BoxDecoration(
    color: blueMain,
    border: Border.all(color: borderLight, width: 2),
    boxShadow: [
      BoxShadow(color: borderLight, offset: Offset(-2, -2)),
      BoxShadow(color: shadowColor, offset: Offset(2, 2)),
    ],
  ),
  child: TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    onPressed: () {},
    child: Text(
      '开始续写',
      style: TextStyle(
        color: textPrimary,
        fontFamily: 'PressStart2P',
        fontFamilyFallback: ['NotoSansSC'],
        fontSize: 10,
      ),
    ),
  ),
)

// 禁用状态：背景变灰 bgSecondary，文字变 textSecondary
// 警告按钮：背景 orange
// 危险按钮：背景 red
```

### 8.3 像素风格输入框

```dart
TextField(
  style: TextStyle(color: textPrimary, fontSize: 14),
  cursorColor: cyanBright,
  decoration: InputDecoration(
    filled: true,
    fillColor: bgTertiary,
    contentPadding: EdgeInsets.all(12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.zero, // 像素风格不用圆角
      borderSide: BorderSide(color: borderLight, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: borderLight, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: cyanBright, width: 2),
    ),
    hintStyle: TextStyle(color: textSecondary),
  ),
)
```

### 8.4 像素风格进度条

```dart
// 像素方块进度条 — 用 Row of Container 实现
// 特征：每个进度格是正方形（8x8 or 10x10），充满的格用蓝色，未充满用深灰

Row(
  mainAxisSize: MainAxisSize.min,
  children: List.generate(10, (i) {
    final filled = i < (progress * 10).round();
    return Container(
      width: 8,
      height: 16,
      margin: EdgeInsets.only(right: 2),
      color: filled ? blueMain : bgTertiary,
      decoration: BoxDecoration(
        border: filled ? null : Border.all(color: borderDark, width: 1),
      ),
    );
  }),
)

// 配合文字进度显示：
// "已完成 3/10 章图谱生成"
```

### 8.5 像素风格对话框

```dart
// 像素对话框 — 3D 凸起边框 + 深色半透明遮罩
showDialog(
  context: context,
  builder: (ctx) => Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
        color: bgSecondary,
        border: Border.all(color: borderLight, width: 3),
        boxShadow: [
          BoxShadow(color: borderLight, offset: Offset(-3, -3)),
          BoxShadow(color: shadowColor, offset: Offset(3, 3)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题（像素字体）
          Text('⚠️ 确认', style: TextStyle(
            fontFamily: 'PressStart2P',
            fontFamilyFallback: ['NotoSansSC'],
            fontSize: 12,
            color: orange,
          )),
          SizedBox(height: 16),
          // 内容
          Text(...),
          SizedBox(height: 16),
          // 按钮行（像素按钮风格）
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _PixelButton(label: '取消', onPressed: () => Navigator.pop(ctx)),
              SizedBox(width: 12),
              _PixelButton(label: '确认', color: blueMain, onPressed: ...),
            ],
          ),
        ],
      ),
    ),
  ),
)
```

### 8.6 像素风格底部导航栏

```dart
// 游戏风格底部 Tab 栏
// 特征：每个 item 是竖排图标+文字（GBA 菜单风格）
//       当前选中用亮色+像素边框高亮
//       背景用 bgPrimary + 顶部亮边框

BottomNavigationBar(
  backgroundColor: bgPrimary,
  selectedItemColor: cyanBright,
  unselectedItemColor: textSecondary,
  type: BottomNavigationBarType.fixed,
  elevation: 0,
  selectedLabelStyle: TextStyle(
    fontFamily: 'PressStart2P',
    fontFamilyFallback: ['NotoSansSC'],
    fontSize: 8,
  ),
  unselectedLabelStyle: TextStyle(fontSize: 10),
  items: [
    BottomNavigationBarItem(
      icon: Text('📚', style: TextStyle(fontSize: 20)),
      label: '书架',
    ),
    BottomNavigationBarItem(
      icon: Text('✍️', style: TextStyle(fontSize: 20)),
      label: '续写',
    ),
    BottomNavigationBarItem(
      icon: Text('⚙️', style: TextStyle(fontSize: 20)),
      label: '设置',
    ),
  ],
)

// 选中 Tab 附加像素高亮：Container 包裹 icon + 底部像素条装饰
```

### 8.7 像素风格 Snackbar / Toast

```dart
// 像素 Toast — 顶部横条形式
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    backgroundColor: bgSecondary,
    content: Row(
      children: [
        Text('✅', style: TextStyle(fontSize: 16)),
        SizedBox(width: 8),
        Text('保存成功', style: TextStyle(color: textPrimary)),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    shape: Border(bottom: BorderSide(color: borderLight, width: 2)),
    duration: Duration(seconds: 2),
  ),
)
```

### 8.8 Tab 切换动画

```dart
// 页面切换用像素化过渡动画
// 替代默认的平滑滑动，用阶梯式切换或淡入淡出
// 特征：整屏内容替换，不使用 ViewPager 那种滑动感

AnimatedSwitcher(
  duration: Duration(milliseconds: 200),
  child: screens[currentIndex],
  transitionBuilder: (child, animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
)
```

### 8.9 像素风格滚动条

```dart
// 隐藏默认滚动条，使用像素化自定义滚动条
Scrollbar(
  thumbVisibility: true,
  thickness: 6,
  radius: Radius.zero, // 像素风格不用圆角
  child: ListView(...),
)

// Scrollbar 颜色：thumbColor = blueMain, bg = bgTertiary
```

### 8.10 像素风格 Checkbox / Radio / Switch

```dart
// Checkbox：用 emoji ✅ ❌ 代替原生，或自定义 Container 像素方块
// Radio：用像素圆点（Container + BoxDecoration shape: BoxShape.circle）
// Switch：用像素方块滑动（Container with 3D border）

// 推荐直接用 emoji Checkbox：
Container(
  width: 24,
  height: 24,
  decoration: BoxDecoration(
    color: checked ? success : bgTertiary,
    border: Border.all(color: borderLight, width: 2),
  ),
  child: checked ? Center(child: Text('✓', style: TextStyle(color: textPrimary, fontSize: 14))) : null,
)
```

---

## 九、功能优先级

### 🔴 P0 — 必须修复（阻断性问题）

| 优先级 | 功能点 | 说明 |
|--------|--------|------|
| P0 | Bug Fix: `import_screen.dart` `fileName` 双重赋值 | 删除冗余赋值语句 |
| P0 | Bug Fix: 书架状态不一致（`_loadBookData` 未完成时切换 Tab） | 增加 loading guard / async lock |
| P0 | Bug Fix: 全局错误处理（API 失败友好提示） | 统一 error wrapper，捕获并显示 Snackbar |
| P0 | Bug Fix: 阅读器"返回时自动保存进度" | 在 `WillPopScope` / `PopScope` 中保存 |
| P0 | 核心持久化：chapters / chapterGraphMap / continueChain / mergedGraph | 当前每次启动丢失，必须修复（参照原 PRD v2 P0） |
| P0 | 批量图谱生成进度可视化（成功 N / 失败 M） | `isGeneratingGraph` 从 bool 改为结构化状态 |
| P0 | 书架 + 续写核心流程稳定性 | 充分测试 selectBook / loadBookData / 续写全流程 |

### 🟠 P1 — 重要改进

| 优先级 | 功能点 | 说明 |
|--------|--------|------|
| P1 | UI 全局像素游戏风改造 | 配色 + 组件规范化（参照第八节规范） |
| P1 | Tab 导航精简（5 Tab → 3 Tab） | 重组方案见第六节 |
| P1 | 图谱批量生成队列化（失败 retry + 暂停继续） | 引入队列状态机 |
| P1 | 增量图谱合并 | 修改后只重新合并受影响章节 |
| P1 | 章节管理增强（删除/重命名） | 用户可修正识别错误 |
| P1 | ReaderScreen 支持 continueChain 阅读 | 续写章节可阅读 |
| P1 | 阅读进度精确保存（每章节 scrollTop） | 扩展 readProgress 结构 |

### 🟡 P2 — 架构优化（时间允许时）

| 优先级 | 功能点 | 说明 |
|--------|--------|------|
| P2 | Provider 状态不可变性（copyWith） | 减少意外副作用 |
| P2 | 统一 AsyncValue 三分状态抽象 | 引入 Result/AsyncValue 包装 |
| P2 | 数据存储版本迁移机制 | SharedPreferences + Hive 混用时的版本管理 |
| P2 | API Rate Limiting | 滑动窗口限流 |
| P2 | 多分支续写支持 | 完善 A/B/C 分支检测和存储 |
| P2 | 章节合并/手动调整边界 | 章节管理进阶功能 |

### 🟢 P3 — 体验优化

| 优先级 | 功能点 | 说明 |
|--------|--------|------|
| P3 | 空状态引导设计 | 有趣的像素风格空状态插画 |
| P3 | 护眼/暗色主题阅读器 | 增加暗色主题 |
| P3 | 抽屉/面板状态持久化 | 展开/折叠状态保存 |
| P3 | 分享到其他 App | Android Intent Share |

---

## 十、重构实施计划

### Phase 1：Bug 修复 + 核心稳定化（预计 1 周）

**目标：** 修完所有 P0 Bug，核心流程（导入→续写→阅读）稳定可用

**步骤：**

1. **修复 import_screen.dart fileName 双重赋值**（5 分钟）
   - 删除行54的冗余赋值

2. **全局错误处理抽象**（半天）
   - 在 `NovelApiService` 层统一捕获 API 异常
   - 抛出自定义 `ApiException`（区分 401/403/404/timeout/network）
   - 在 Provider 层统一显示友好 Snackbar
   - 不再只是 `debugPrint`

3. **书架状态一致性修复**（半天）
   - `selectBook()` 加 `async/await` + `Isolate` 或 `compute` 防阻塞
   - 或者加 ` _isLoadingBookData` flag，loading 期间禁止切换 Tab
   - `loadBookData` 完成后才更新 `currentBookId`

4. **阅读器自动保存进度**（1 小时）
   - 在 `PopScope`（Flutter 3.16+）或 `WillPopScope` 的 `didPop` 回调中调用 `provider.saveReaderState()`

5. **批量图谱进度结构化**（半天）
   - `isGeneratingGraph: bool` → `graphGenerationState: GraphGenState`
   - `GraphGenState` 包含：`status(idle/running/done/error)` + `successCount` + `failCount` + `totalCount` + `failedChapterIds[]`
   - UI 根据此状态显示"成功 3/10，失败 1"

6. **核心数据持久化**（1-2 天）
   - 方案：扩展 Hive box，章节内容 + 图谱 JSON + 续写链条
   - `NovelProvider._saveChapters()` / `_loadChapters()`
   - 章节内容大，需压缩存储（`gzip` 或直接存 Hive 二进制）
   - 书架数据（含当前选中书 ID）

**Phase 1 交付标准：**
- 导入一本小说 → 关闭 App → 重启 → 章节和图谱完整恢复
- API 失败 → 显示友好错误 Snackbar（不再是 debugPrint）
- 批量图谱生成 → 实时显示成功/失败数量
- 快速切换书架 Tab 不再崩溃或状态错乱

---

### Phase 2：UI 像素化改造（预计 1 周）

**目标：** 全局像素游戏风改造，3 Tab 导航

**步骤：**

1. **主题抽象**（半天）
   - 创建 `PixelTheme` / `PixelColors` 常量类（统一管理所有颜色）
   - `ThemeData` 自定义（字体/颜色/组件主题）
   - 全局替换所有硬编码颜色

2. **像素组件库建设**（1-2 天）
   - 创建 `pixel_card.dart`、`pixel_button.dart`、`pixel_text_field.dart` 等
   - 每个组件导出为独立 widget，方便 screens 层调用
   - 不需要一次性全部重构，可以逐 screen 改造

3. **Tab 导航重组**（1 天）
   - 5 Tab → 3 Tab（书架/续写/设置）
   - 新增 `WriteStudioScreen`（整合章节管理+续写+图谱操作）
   - `SettingsScreen` 整合图谱查看器入口

4. **逐 Screen 像素化改造**（2-3 天，按顺序）
   - BookshelfScreen（书架）
   - HomeScreen → 整合进 BookshelfScreen（删除独立首页）
   - WriteStudioScreen（新，写入 Tab）
   - SettingsScreen（设置 + 图谱查看）
   - ImportScreen（导入）
   - ReaderScreen（阅读器独立，不在 Tab 内）
   - GraphViewerScreen（图谱查看）

5. **验收检查**
   - 所有 Card 有像素边框
   - 所有按钮有 3D 凸起效果
   - 进度条是像素方块风格
   - Tab 栏是像素游戏风格
   - 空状态有引导设计

**Phase 2 交付标准：**
- 全局 UI 风格统一为像素游戏风
- 5 Tab → 3 Tab 导航流畅
- 所有主要页面完成像素化改造

---

### Phase 3：架构优化 + 功能增强（预计 0.5-1 周）

**目标：** 架构优化 + P1/P2 功能增强

**步骤：**

1. Provider 不可变性（`copyWith` 方法）
2. 统一 AsyncValue 三分状态抽象
3. 数据版本迁移机制
4. 图谱合并增量优化
5. 章节管理（删除/重命名）
6. 多分支续写
7. API Rate Limiting
8. 其他 P2 功能

**Phase 3 交付标准：**
- 架构清晰，单测可覆盖 Provider 核心逻辑
- 图谱合并支持增量更新
- 用户可管理章节（删除/重命名）

---

## 十一、风险评估

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|----------|
| Phase 1 持久化改造破坏现有数据 | 高 | 中 | 迁移脚本 + 冷启动测试 + 回滚方案 |
| 像素化 UI 改造影响现有功能 | 中 | 低 | 逐 Screen 改造，每改完测完再改下一个 |
| Tab 重组导致用户习惯改变 | 低 | 高 | 提供"经典模式"开关，暂时保留 5 Tab |
| 批量图谱队列化改动影响续写逻辑 | 高 | 低 | 只改 UI 状态层，不动 API service prompt 逻辑 |
| Flutter 3.x 升级导致 PopScope API 变更 | 低 | 中 | 指定 Flutter SDK 范围，不随意升级 |
| 压缩存储持久化导致性能问题 | 中 | 低 | lazy loading + 后台 isolate 写入 |

### 重要约束提醒

> ⚠️ **不要改动 `novel_api_service.dart` 的 prompt 逻辑**（那是核心，已调优）  
> ⚠️ **不要改动 `novel_provider.dart` 的数据模型字段**（那些是正确的）  
> ⚠️ **仅改动颜色/布局/组件样式，不改动业务逻辑**（Phase 2 UI 改造的原则）

---

## 十二、总结

本重构覆盖三类问题，按优先级排序：
- **P0（Bug/稳定性）**：7 项，Phase 1 处理
- **P1（UI/功能改进）**：7 项，Phase 2-3 处理  
- **P2（架构优化）**：5 项，Phase 3 处理

重构后目标：
- 核心流程（导入→图谱→续写→阅读）稳定可用
- 全局像素可爱游戏风 UI
- 3 Tab 导航清晰高效
- 持久化数据不丢失
- 架构可测试可维护

---

*本 PRD 由产品经理 Agent 输出，基于现有代码审计 + PRD v2 参考。*
