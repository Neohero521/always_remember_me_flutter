# Always Remember Me v3.0 UI 设计规范

> 基于「单 Tab + Drawer」方案，详细定义 WriteScreen 首页、Drawer 导航、页面整合策略及样式系统。

---

## 1. WriteScreen（新首页）布局

### 1.1 整体结构

```
┌──────────────────────────────────────────────────────┐
│  AppBar: [☰] 《书名》           [📖 阅读] [⋮ 设置]   │  ← 固定顶部
├──────────────────────────────────────────────────────┤
│                                                      │
│  ┌─ 状态概览卡片 ─────────────────────────────────┐  │
│  │ [📖 12章] [🌲 8图谱] [✍️ 3续写] [✅已合并]    │  │  ← 可折叠
│  └───────────────────────────────────────────────┘  │
│                                                      │
│  ┌─ 快捷操作区 ───────────────────────────────────┐  │
│  │      [📥 导入小说]        [🚀 一键续写]         │  │
│  │            [🌲 生成图谱]    [📊 全局图谱]        │  │
│  └───────────────────────────────────────────────┘  │
│                                                      │
│  ┌─ 续写面板 ─────────────────────────────────────┐  │
│  │                                              │  │
│  │  续写基准章节                                 │  │
│  │  ┌──────────────────────────┐ [▼ 选择章节]   │  │
│  │  │ 第3章 夜色降临              │               │  │
│  │  └──────────────────────────┘               │  │
│  │  ━━━ ✅ 该章节已有知识图谱                     │  │
│  │                                              │  │
│  │  基准内容（可编辑）                           │  │
│  │  ┌───────────────────────────────────────┐  │  │
│  │  │ （章节内容，支持编辑后重新续写）        │  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │                                              │  │
│  │  前置校验                                    │  │
│  │  ┌─ 人设红线 ────────────────────────────┐  │  │
│  │  │ ⚠️ 第5章出现的"神秘黑衣人"可能是反派伏笔│  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │  ┌─ 伏笔引用 ────────────────────────────┐  │  │
│  │  │ 🔗 第2章埋下的"蓝色宝石"线索           │  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │                                              │  │
│  │  ┌─ 续写预览 ────────────────────────────┐  │  │
│  │  │ （续写结果在此显示，支持滚动）         │  │  │
│  │  │                            [📋复制][🗑️]│  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │                                              │  │
│  │  质量评估                                    │  │
│  │  ┌───────────────────────────────────────┐  │  │
│  │  │ 综合评分: 85/100                       │  │  │
│  │  │ ✓ 人物一致性  ⑧ 伏笔连贯性  ⑧ 文风一致│  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │                                              │  │
│  │      [🚀 开始续写]          [⏹ 停止]         │  │
│  │                                              │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  ┌─ 续写链条 ─────────────────────────────────────┐  │
│  │  ✍️ 续写链条 (3)              [清空全部]       │  │
│  │  ┌─────────────────────────────────────────┐  │  │
│  │  │ 🔗 续写#1 · 1200字 · 2026-04-11         │  │  │
│  │  │    基于"第3章 夜色降临"                 │  │  │
│  │  │    [→基于此继续] [📋复制] [🗑️删除]     │  │  │
│  │  ├─────────────────────────────────────────┤  │  │
│  │  │ 🔗 续写#2 · 980字 · 2026-04-11          │  │  │
│  │  │    基于"续写#1"                        │  │  │
│  │  │    [→基于此继续] [📋复制] [🗑️删除]     │  │  │
│  │  └─────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### 1.2 AppBar 设计

| 元素 | 位置 | 行为 |
|------|------|------|
| ☰ 菜单按钮 | AppBar 最左侧 | 点击打开 Drawer |
| 书名 | 居中，左侧留出菜单按钮空间 | 当前选中书籍名，无书时显示"请选择书籍" |
| 📖 阅读按钮 | AppBar 右侧第一个 | 点击打开 ReaderScreen（全屏） |
| ⋮ 设置按钮 | AppBar 最右侧 | 弹出 OverflowMenu（设置、关于） |

**AppBar 样式：**
- 高度：56dp（标准 Material）
- 背景色：`PrimaryColor`（主题蓝 #4A90D9）
- 书名文字：白色，16sp，Medium
- 图标按钮：白色，24dp

### 1.3 状态概览卡片

**位置：** AppBar 下方
**边距：** 水平 16dp，垂直 8dp
**圆角：** 12dp
**背景色：** 白色或浅灰（`surface`）

**内容布局：** 水平排列，均匀分布

| 标签 | 图标 | 示例 | 点击行为 |
|------|------|------|----------|
| 章节数 | 📖 | 12章 | 打开章节选择下拉框 |
| 图谱数 | 🌲 | 8图谱/共12章 | 打开章节管理（Drawer入口） |
| 续写数 | ✍️ | 3续写 | 滚动到续写链条区 |
| 合并状态 | ✅/⏳ | ✅已合并/⏳未合并 | 打开全局图谱 |

**无书籍时：** 显示空状态"还没有书籍，请从书架导入"

### 1.4 快捷操作区

**布局：** 2×2 网格 或 2列一行一个

| 按钮 | 图标 | 颜色 | 作用 |
|------|------|------|------|
| 导入小说 | 📥 | Primary | 打开文件选择器，导入 TXT |
| 一键续写 | 🚀 | Accent/Orange | 批量续写流程（选起始章节 → 自动续写后续所有章节） |
| 生成图谱 | 🌲 | Green | 批量图谱生成流程 |
| 全局图谱 | 📊 | Purple | 打开全局图谱查看器 |

**按钮样式：**
- 形状：圆角矩形，12dp
- 高度：48dp
- 文字：14sp，Medium
- 图标：20dp，左侧

### 1.5 续写面板（核心）

#### 1.5.1 基准章节选择

**组件：** 下拉选择框（DropdownButton）
**样式：** 全宽，48dp 高，边框 1dp `#E0E0E0`，圆角 8dp
**显示：** 章节序号 + 章节名（截断显示）
**右侧标记：**
- ✅ 绿色小字：该章节已有图谱
- ⚠️ 橙色小字：该章节暂无图谱

#### 1.5.2 基准内容（可编辑）

**组件：** TextField + expand
**最大高度：** 200dp（超出可滚动）
**样式：** 边框 `#E0E0E0`，圆角 8dp，内边距 12dp
**功能：**
- 默认填充选中章节的原文
- 用户可编辑修改后重新续写
- 右侧浮动：[🔄 重置] 按钮恢复原文

#### 1.5.3 前置校验区

**展开/折叠：** 默认折叠，用户可展开查看
**标题：** "📋 前置校验" + 展开箭头

**两个子区块（垂直排列）：**

| 区块 | 图标 | 背景色 |
|------|------|--------|
| 人设红线 | ⚠️ | 浅红 `#FFEBEE` |
| 伏笔引用 | 🔗 | 浅蓝 `#E3F2FD` |

每个区块：
- 标题行 + 展开/折叠
- 折叠时只显示标题和计数（如"3条伏笔"）
- 展开时显示具体伏笔列表

#### 1.5.4 续写预览区

**初始状态：** 空，显示引导文字"选择章节后点击「开始续写」"
**加载状态：** 居中 CircularProgressIndicator + "AI 正在续写中..."
**结果状态：**
- 可滚动文本区，显示续写内容
- 右上角浮动按钮：[📋复制] [🗑️删除]

#### 1.5.5 质量评估卡

**显示条件：** 续写完成后显示
**布局：**
```
综合评分: 85/100
✓ 人物一致性  ⑧ 伏笔连贯性  ⑧ 文风一致
```
评分圆环：彩色圆环，数字居中

#### 1.5.6 操作按钮

**布局：** 底部，一行两个

| 按钮 | 文字 | 宽度占比 | 状态 |
|------|------|----------|------|
| 主按钮 | 🚀 开始续写 | 70% | 正常/加载中/禁用 |
| 次按钮 | ⏹ 停止 | 30% | 仅在续写中可点击 |

### 1.6 续写链条列表

**标题行：** "✍️ 续写链条 (N)" + [清空] 按钮（右侧）
**清空按钮样式：** 文字按钮，红色

**列表项（续写卡片）：**
- 左侧：🔗 图标
- 中间：续写序号 + 字数估算 + 时间
- 次行：基于哪个章节/续写
- 右侧按钮组：[→基于此继续] [📋复制] [🗑️删除]

**卡片样式：**
- 白色背景，圆角 8dp
- 内边距 12dp
- 卡片间距 8dp
- 分割线：1dp `#F0F0F0`

---

## 2. Drawer 菜单设计

### 2.1 Drawer 整体样式

**宽度：** 280dp（固定）
**高度：** 全屏
**背景色：** 白色

**Header 区域：**
- 高度：160dp（含底部）
- 背景：渐变 PrimaryColor → 深蓝
- 内容：App Logo/图标 + App 名称 + 当前书籍名
- 内边距：16dp

```
┌──────────────────────────┐
│                          │  ← 渐变背景
│   🐋                     │
│   Always Remember Me     │
│                          │
│   当前: 《修仙之途》        │  ← 当前书籍名
│   [点击切换书籍]           │  ← 可点击区域
└──────────────────────────┘
```

### 2.2 菜单项列表

| 序号 | 图标 | 标题 | 副标题/说明 | 右侧箭头 |
|------|------|------|-------------|----------|
| 1 | 📚 | 我的书架 | 3本书 | → |
| 2 | 📖 | 章节管理 | 12章节 | → |
| 3 | 🌲 | 全局图谱 | 查看/导出/导入 | → |
| 4 | ⚙️ | 设置 | 续写参数、主题 | → |

**菜单项样式：**
- 高度：56dp
- 图标：24dp，颜色 `#757575`
- 标题：16sp，`#212121`
- 副标题：12sp，`#757575`（可选）
- 分割线：底部 1dp `#EEEEEE`
- 按压效果：涟漪色 `#E0E0E0`

### 2.3 底部信息

```
┌──────────────────────────┐
│  版本 3.0.0             │
└──────────────────────────┘
```

---

## 3. 其他页面整合方案

### 3.1 书架 Screen（BookshelfScreen）

**方案：合并到 Drawer**
- **原因：** 书架是"辅助功能"，选书后才进入续写核心
- **入口：** Drawer 第一项"📚 我的书架"
- **跳转：** 全屏新页面或覆盖层（Hero 动画可选）
- **功能保留：** 书籍列表、导入、删除、切书
- **功能移除：** 续写入口、快捷操作（已整合到首页）

**交互设计：**
- 网格布局：每行 2 本书
- 书籍卡片：封面 + 书名 + 进度条
- FAB：导入新书（右下角）

### 3.2 章节管理 Screen（ChaptersScreen）

**方案：合并到 Drawer**
- **入口：** Drawer 第二项"📖 章节管理"
- **跳转：** 全屏新页面
- **功能保留：** 章节列表、图谱生成、批量操作
- **功能精简：** 移除和 WriteScreen 重复的续写入口

**页面布局：**
```
┌──────────────────────────────────┐
│ AppBar: [←] 章节管理      [批量▼] │
├──────────────────────────────────┤
│ 全选 | 已生成(8) | 未生成(4)      │  ← 筛选标签
├──────────────────────────────────┤
│ ┌──────────────────────────────┐ │
│ │ ☑️ 第1章 破茧          [🌲]  │ │  ← 图标表示已生成
│ ├──────────────────────────────┤ │
│ │ ☐️ 第2章 修行          [🌲]  │ │
│ ├──────────────────────────────┤ │
│ │ ☐️ 第3章 夜色降临       [❌]  │ │  ← 暂无图谱
│ └──────────────────────────────┘ │
├──────────────────────────────────┤
│        [🌲 批量生成图谱]          │
└──────────────────────────────────┘
```

### 3.3 全局图谱 Screen

**方案：独立页面，从 Drawer 入口**
- **入口：** Drawer 第三项"🌲 全局图谱"
- **跳转：** 全屏新页面
- **功能：** 全局图谱查看、合并进度、导出、导入

**页面布局：**
```
┌──────────────────────────────────┐
│ AppBar: [←] 全局图谱              │
├──────────────────────────────────┤
│  ┌────────────────────────────┐  │
│  │     力导向图谱可视化区域     │  │
│  │     (D3.js / 自定义 Canvas) │  │
│  └────────────────────────────┘  │
├──────────────────────────────────┤
│  节点类型筛选: [人物] [地点] [事件] │
├──────────────────────────────────┤
│  [📤 导出JSON]  [📥 导入JSON]     │
│        [🔄 重新合并]              │
└──────────────────────────────────┘
```

### 3.4 阅读器 Screen（ReaderScreen）

**方案：全屏覆盖**
- **入口：** AppBar 右侧 📖 按钮，或状态卡片"章节数"点击
- **交互：** 全屏，无 Drawer，无底部导航
- **返回：** 左上角返回按钮 或 下滑手势
- **功能保留：** 章节跳转、字体大小、夜间模式、阅读进度自动保存

**页面布局：**
```
┌──────────────────────────────────┐
│ [←] 第3章 夜色降临        [≡ 目录] │
├──────────────────────────────────┤
│                                  │
│    （正文内容，沉浸式阅读）        │
│                                  │
│    字体：思源宋体/系统默认         │
│    行高：1.8                      │
│    背景：米白/夜间黑              │
│                                  │
├──────────────────────────────────┤
│   [◀ 上一章]    3/12    [下一章 ▶] │
└──────────────────────────────────┘
```

### 3.5 设置 Screen

**方案：PopupMenu → 全屏页面**
- **入口：** AppBar ⋮ 溢出菜单 → "设置"
- **跳转：** 全屏新页面

**设置项分组：**
```
┌──────────────────────────────────┐
│ AppBar: [←] 设置                  │
├──────────────────────────────────┤
│  📝 续写参数                      │
│    · 模型选择                     │
│    · Temperature                  │
│    · 最大Token数                  │
│    · 续写长度                     │
├──────────────────────────────────┤
│  🎨 外观                          │
│    · 主题（浅色/深色/跟随系统）     │
│    · 字体大小                     │
├──────────────────────────────────┤
│  📦 数据管理                      │
│    · 导出全部数据                  │
│    · 导入数据                     │
│    · 清除所有数据                  │
└──────────────────────────────────┘
```

---

## 4. 样式规范

### 4.1 配色方案

```dart
// 主色系
primaryColor:        #4A90D9   // 品牌蓝（AppBar、按钮）
primaryColorDark:    #2C5F8A   // 深蓝（Drawer 渐变尾部）
primaryColorLight:   #7BB3E8   // 浅蓝（hover/选中态）

// 强调色
accentColor:         #FF7043   // 橙色（快捷操作"一键续写"）
successColor:        #66BB6A   // 绿色（已完成状态）
warningColor:       #FFA726   // 橙色（警告）
errorColor:         #EF5350   // 红色（错误、删除）

// 中性色
backgroundColor:    #F5F5F5   // 页面背景
surfaceColor:        #FFFFFF   // 卡片背景
dividerColor:       #E0E0E0   // 分割线
textPrimary:        #212121   // 主文字
textSecondary:      #757575   // 次文字
textHint:           #BDBDBD   // 提示文字

// 图谱状态色
graphNodeCharacter: #5C6BC0   // 人物节点（靛蓝）
graphNodeLocation: #26A69A   // 地点节点（青绿）
graphNodeEvent:    #EF5350   // 事件节点（红）
graphNodeItem:     #FFA726   // 物品节点（橙）
graphEdge:         #90A4AE   // 图谱连线（灰蓝）
```

### 4.2 字体规范

```dart
// 字体族
fontFamilyChinese: 'Noto Sans CJK SC'  // 中文
fontFamilyMono:    'Roboto Mono'       // 代码/JSON

// 字号层级
headlineLarge:   24sp   // 页面大标题
headlineMedium:  20sp   // 卡片标题
titleLarge:      18sp   // 区块标题
titleMedium:     16sp   // 按钮文字、菜单项
bodyLarge:       16sp   // 正文内容（阅读器）
bodyMedium:      14sp   // 正文（卡片内）
bodySmall:       12sp   // 副标题、说明
labelLarge:      14sp   // 标签
labelSmall:      11sp   // 小标签、角标

// 字重
fontWeightRegular:   400
fontWeightMedium:    500
fontWeightSemiBold:  600
fontWeightBold:      700
```

### 4.3 间距规范（8pt Grid）

```dart
// 页面级
pagePaddingHorizontal: 16.0   // 页面左右边距
pagePaddingVertical:   12.0   // 页面上下边距

// 卡片级
cardPadding:           16.0   // 卡片内边距
cardMargin:             8.0   // 卡片外边距
cardBorderRadius:      12.0   // 卡片圆角

// 元素级
itemSpacingSmall:        4.0   // 紧凑元素间距
itemSpacingMedium:       8.0   // 标准元素间距
itemSpacingLarge:       16.0   // 大区块间距
iconTextSpacing:        8.0   // 图标与文字间距

// 按钮
buttonHeight:          48.0   // 按钮高度
buttonBorderRadius:    12.0   // 按钮圆角
buttonPaddingH:        16.0   // 按钮水平内边距

// 输入框
inputBorderRadius:      8.0
inputBorderWidth:      1.0
inputHeight:           48.0
```

### 4.4 组件规范

#### 4.4.1 按钮

| 类型 | 样式 | 使用场景 |
|------|------|----------|
| PrimaryButton | 填充 Primary 色，白色文字，圆角12dp | 主操作（开始续写） |
| SecondaryButton | 边框 Primary 色，Primary 文字，圆角12dp | 次操作（停止、取消） |
| TextButton | 无边框，Primary 文字 | 辅助操作（清空、复制） |
| DangerButton | 填充 Error 色，白色文字 | 危险操作（删除、清空） |
| IconButton | 圆形/方形，图标居中 | 工具栏操作 |

**按钮状态：**
- Default：正常可点击
- Pressed：90% opacity
- Disabled：40% opacity，无触感反馈
- Loading：显示 CircularProgressIndicator，文字替换为"处理中..."

#### 4.4.2 卡片

```dart
Card(
  elevation: 1.0,           // 轻微阴影
  borderRadius: 12.0,       // 圆角
  color: surfaceColor,      // 白色
  margin: EdgeInsets.all(8.0),
)
```

**阴影规范：**
```dart
shadowColor: Colors.black.withOpacity(0.08)
blurRadius: 4.0
offset: Offset(0, 2)
```

#### 4.4.3 输入框

```dart
TextField(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: dividerColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: primaryColor, width: 2.0),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
)
```

#### 4.4.4 下拉选择框

```dart
DropdownButtonFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  ),
  icon: Icon(Icons.arrow_drop_down),
)
```

#### 4.4.5 列表项

```dart
ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
  leading: Icon(icon, size: 24),
  title: Text(title, style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium)),
  subtitle: sub != null ? Text(sub, style: TextStyle(fontSize: 12, color: textSecondary)) : null,
  trailing: Icon(Icons.chevron_right, color: textSecondary),
  onTap: onTap,
)
```

#### 4.4.6 进度指示器

| 场景 | 组件 | 参数 |
|------|------|------|
| 页面加载 | CircularProgressIndicator | color: primaryColor |
| 图谱生成中 | LinearProgressIndicator + 百分比 | color: successColor |
| 批量续写 | AlertDialog + LinearProgressIndicator + "已处理/总数" | - |
| 合并图谱 | AlertDialog + LinearProgressIndicator | - |

#### 4.4.7 空状态

**组件：** Center + Column
**结构：** 图标（48dp/灰色）+ 标题（16sp/Primary）+ 副标题（14sp/Secondary）+ 操作按钮（可选）

```dart
EmptyState(
  icon: Icons.inbox_outlined,      // 48dp, color: textHint
  title: '还没有书籍',               // 16sp, fontWeightMedium, textPrimary
  subtitle: '点击下方按钮导入小说',   // 14sp, textSecondary
  action: PrimaryButton(           // 可选
    label: '📥 导入小说',
    onPressed: onImport,
  ),
)
```

#### 4.4.8 对话框

```dart
AlertDialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  title: Text(title, style: headlineMedium),
  content: Text(content, style: bodyMedium),
  actions: [
    TextButton('取消', onPressed: onCancel),
    PrimaryButton('确认', onPressed: onConfirm),
  ],
)
```

---

## 5. 页面路由结构

```
/                       → WriteScreen (首页)
/reader                  → ReaderScreen (阅读器)
/reader?chapter=3        → ReaderScreen (跳转指定章节)
/bookshelf               → BookshelfScreen (书架)
/chapters                → ChaptersScreen (章节管理)
/graph                   → GlobalGraphScreen (全局图谱)
/settings                → SettingsScreen (设置)
```

**导航实现：** `Navigator.pushNamed()` 或 GoRouter

---

## 6. 关键组件清单

| 组件名 | 说明 | 所在文件 |
|--------|------|----------|
| WriteScreen | 首页/续写核心 | write_screen.dart |
| AppDrawer | Drawer 侧边栏 | app_drawer.dart |
| StatusOverviewCard | 状态概览卡片 | widgets/status_card.dart |
| QuickActionsGrid | 快捷操作网格 | widgets/quick_actions.dart |
| ChapterDropdown | 章节选择下拉框 | widgets/chapter_dropdown.dart |
| ContinuationPreview | 续写预览区 | widgets/continuation_preview.dart |
| QualityScoreCard | 质量评估卡 | widgets/quality_score.dart |
| ContinuationChainList | 续写链条列表 | widgets/chain_list.dart |
| ContinuationChainItem | 续写链条单项 | widgets/chain_item.dart |
| ValidationSection | 前置校验区 | widgets/validation_section.dart |
| EmptyState | 空状态组件 | widgets/empty_state.dart |
| ReaderScreen | 阅读器 | reader_screen.dart |
| BookshelfScreen | 书架 | bookshelf_screen.dart |
| ChaptersScreen | 章节管理 | chapters_screen.dart |
| GlobalGraphScreen | 全局图谱 | global_graph_screen.dart |
| SettingsScreen | 设置 | settings_screen.dart |

---

## 7. 动效规范

| 动效 | 时长 | 曲线 | 使用场景 |
|------|------|------|----------|
| 页面跳转 | 300ms | easeInOut | Screen 切换 |
| Drawer 开合 | 250ms | easeOut | Drawer 滑入滑出 |
| 卡片展开 | 200ms | easeIn | 校验区展开 |
| 按钮反馈 | 100ms | easeIn | 按钮点击涟漪 |
| 加载动画 | - | linear | 续写/图谱生成中 |
| FAB 出现 | 200ms | easeOut | FAB 显示 |
| 列表项删除 | 300ms | easeInOut | 续写链条删除（滑出） |

---

*UI 设计规范 v3.0*
*基于 Always Remember Me 单 Tab + Drawer 方案*
*生成日期: 2026-04-11*
