# Always Remember Me Flutter — PRD v2.0

> 项目总指挥输出 · 基于 `always_remember_me/` (JS) 与 `always_remember_me_flutter/` (Flutter) 源码深度审查

---

## 一、项目概述

**项目名称：** Always Remember Me Flutter（小说续写工具）

**项目性质：** 将 SillyTavern Always_remember_me 扩展完整移植到 Flutter 移动端

**核心价值：** 让用户在手机上完成小说导入、AI 续写、知识图谱管理、阅读的一站式体验

**当前版本：** v1.0（APK: `/mnt/c/Users/kaku5/Desktop/always_remember_me.apk`，104MB）

**源码路径：**
- JS 扩展：`/home/kaku5/.openclaw/workspace/always_remember_me/`
- Flutter App：`/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`

---

## 二、功能全景图（已✅ / 🔄 部分 / ❌ 未实现）

### 2.1 小说导入与解析

| 功能点 | 状态 | 说明 |
|--------|------|------|
| TXT 文件选择 | ✅ | FilePicker，已实现 |
| 自动匹配最优正则 | ✅ | 自动遍历11种预设正则，按章节数排序 |
| 自定义正则解析 | ✅ | 用户输入自定义正则 |
| 按字数拆分章节 | ✅ | `splitByWordCount`，1000-10000字可配置 |
| 章节预览 | ✅ | ImportScreen 预览前5章 |
| 循环切换正则 | ✅ | 再次点击切换下一个最优正则 |
| UTF-8 BOM 处理 | ✅ | `removeBOM()` |

### 2.2 章节管理

| 功能点 | 状态 | 说明 |
|--------|------|------|
| 章节列表展示 | ✅ | 序号 + 标题 + 字数 + 图谱状态 |
| 单章节图谱生成 | ✅ | 单个生成 + 批量生成 |
| 多选章节批量生成 | ✅ | 复选框选择 |
| 批量全部生成 | ✅ | `generateGraphsForAllChapters()` |
| 章节详情弹窗 | ✅ | 含内容预览 + 图谱查看 + 重新生成 |
| 章节图谱状态检验 | ✅ | `validateChapterGraphStatus()` |
| 章节删除/重命名 | ❌ | Flutter 中无此功能 |

### 2.3 知识图谱核心

| 功能点 | 状态 | 说明 |
|--------|------|------|
| 单章节图谱生成 | ✅ | `generateSingleChapterGraph()` |
| 单章节图谱 JSON Schema | ✅ | 8个必填字段，完整对齐 JS |
| 批量生成全部图谱 | ✅ | 逐章调用，有进度显示和停止 |
| 分批合并图谱 | ✅ | `batchMergeGraphs()` 每批50章 |
| 全量合并图谱 | ✅ | `mergeAllGraphs()` 优先用批次结果 |
| 合并图谱 JSON Schema | ✅ | 8个必填字段，完整对齐 JS |
| 图谱导入 | ✅ | JSON 粘贴导入，`importChapterGraphsJson()` |
| 图谱导出 | ✅ | `exportChapterGraphsJson()`，对话框显示 |
| 图谱合规性校验 | ✅ | 字段完整性 + 字数≥1200 + 自洽得分 |
| 魔改章节图谱更新 | ✅ | `updateModifiedChapterGraph()` |
| 续写章节图谱更新 | ✅ | `updateGraphWithContinueContent()` |
| 全局图谱查看器 | ✅ | GraphViewerScreen，8个字段折叠展示 |

### 2.4 续写核心

| 功能点 | 状态 | 说明 |
|--------|------|------|
| 基准章节续写（开始续写） | ✅ | `generateWrite()` |
| 基准章节选择 + 内容编辑 | ✅ | WriteScreen，可编辑基准章节内容 |
| 前置校验 | ✅ | `runPrecheck()` = 续写节点逆向分析 |
| 防空回检测 | ✅ | 空内容 + 拒绝关键词 |
| 破限提示词注入 | ✅ | `breakLimitPrompt` 注入 |
| 质量评估 | ✅ | 5维度：人设/设定合规/剧情衔接/文风/内容 |
| 质量不合格自动重写 | ✅ | 不合格时重新生成一次 |
| 从链条章节继续续写 | ✅ | `continueFromChain()` |
| 续写链条管理 | ✅ | 查看/复制/删除/继续续写 |
| 一键续写（HomeScreen 快捷入口） | ✅ | HomeScreen 卡片入口，切换到 Write Tab |
| 停止生成 | ✅ | `stopWrite()` |
| 续写预览 | ✅ | `writePreview` 显示 + 复制 |
| 自动续写后生成图谱 | ✅ | `autoUpdateGraphAfterWrite` 开关 |

### 2.5 阅读器

| 功能点 | 状态 | 说明 |
|--------|------|------|
| 章节列表导航 | ✅ | 模态抽屉，滑动条 |
| 上下章翻页 | ✅ | PageView + PageController |
| 字号调节 | ✅ | 12-28，状态持久化 |
| 进度保存 | ✅ | `currentChapterId` 持久化 |
| 原文内容阅读 | ✅ | 支持原始章节 |
| 续写章节阅读 | 🔄 | ReaderScreen 只读 chapters，不含 continueChain |
| 阅读器主题/护眼模式 | ❌ | 仅有米色纸背景 |

### 2.6 API 服务层（NovelApiService）

| 功能点 | 状态 | 说明 |
|--------|------|------|
| 多端点自动探测 | ✅ | 4种端点兜底 |
| Bearer Token 认证 | ✅ | 主流 OpenAI 兼容 |
| X-API-Key 认证 | ✅ | 部分 API 兼容 |
| 重试机制（3次） | ✅ | 温度递增 + 1200ms 延迟 |
| 防空回检测 | ✅ | 空内容 + 拒绝关键词 |
| 破限提示词注入 | ✅ | 纯正文模式 |
| JSON 模式强制 Schema | ✅ | 结构化输出模式 |
| 多分支内容分割 | 🔄 | `_splitContinuationContent()` 有简单实现 |
| API Rate Limiting | ❌ | JS 有 1分钟3次限制，Flutter 无此功能 |

### 2.7 设置与持久化

| 功能点 | 状态 | 说明 |
|--------|------|------|
| API Base URL 配置 | ✅ | |
| API Key 配置 | ✅ | 密码模式 |
| 模型列表获取 | ✅ | 自动探测 + 多认证方式 |
| 模型选择 | ✅ | |
| 续写字数配置 | ✅ | 默认2000 |
| 质量校验开关 | ✅ | `enableQualityCheck` |
| 自动生成图谱开关 | ✅ | `autoUpdateGraphAfterWrite` |
| **设置持久化** | 🔄 | `SharedPreferences` 仅保存 API 配置，reader 状态；**chapterList/chapterGraphMap/continueChain/mergedGraph 等核心状态未持久化** |
| 阅读器状态持久化 | 🔄 | `readerFontSize` 和 `currentChapterId` 已持久化，其他未 |
| 抽屉状态持久化 | ❌ | JS 有 `drawerState`，Flutter 无 |
| 悬浮球位置持久化 | ❌ | JS 有 `floatBallState`，Flutter 无 |
| 父级预设同步 | ❌ | JS 有 `enableAutoParentPreset`，Flutter 无此概念 |
| 发送模板配置 | ❌ | JS 有 `sendTemplate`，Flutter 无 |

### 2.8 辅助功能

| 功能点 | 状态 | 说明 |
|--------|------|------|
| 复制续写内容 | ✅ | Clipboard |
| 发送至对话框 | ❌ | JS 用 `sendas` 命令，Flutter 无 SillyTavern 环境 |
| 可移动悬浮球 | ❌ | JS 有 FloatBall，Flutter 无 |
| 多分支续写 | 🔄 | JS 支持多分支 A/B/C，Flutter 简单分割但不确定 |

---

## 三、核心功能详细说明

### 3.1 小说导入 → 解析 → 图谱 → 续写完整流程

```
用户导入TXT
    ↓
自动正则匹配最优解（11种预设）
    ↓
解析出章节列表
    ↓
批量生成知识图谱（逐章调用AI）
    ↓
分批合并（每50章）+ 全量合并
    ↓
选基准章节 + 编辑魔改内容
    ↓
前置校验（逆向分析人设红线/伏笔/矛盾）
    ↓
AI 续写（防空回 + 破限）
    ↓
质量评估（5维度，不合格重写）
    ↓
续写内容加入链条 + 自动生成续写图谱
    ↓
阅读器阅读 / 继续续写
```

### 3.2 防空回机制（JS vs Flutter 对齐）

JS 与 Flutter 均实现：
- `EMPTY_CONTENT_REGEX`：拦截全空白/全标点内容
- `rejectKeywords`：拒绝生成关键词列表（"不能""无法""违规"等）
- 短文本（<300字）命中关键词 → 触发重试
- 重试时温度递增 + 强制修正提示词

### 3.3 破限机制

JS 与 Flutter 均注入 `breakLimitPrompt`，强制：
- 禁止拒绝生成
- 纯正文输出（无标题/注释/markdown）
- 字数误差≤10%
- 逻辑自洽/文风统一

### 3.4 知识图谱 Schema（完整对齐）

单章节图谱 8 个必填字段：基础章节信息 / 人物信息 / 世界观设定 / 核心剧情线 / 文风特点 / 实体关系网络 / 变更与依赖信息 / 逆向分析洞察

合并图谱 8 个必填字段：全局基础信息 / 人物信息库 / 世界观设定库 / 全剧情时间线 / 全局文风标准 / 全量实体关系网络 / 反向依赖图谱 / 逆向分析与质量评估

---

## 四、待办功能（优先级排序）

### 🔴 P0 — 核心数据持久化（阻断性问题）

**问题描述：** `chapterList`、`chapterGraphMap`、`continueChain`、`mergedGraph`、`batchMergedGraphs` 等核心状态每次启动丢失，用户必须重新导入小说、重新生成全部图谱，体验极差。

**需要持久化的状态：**
```
- chapters[]
- chapterGraphMap{}
- continueChain[]
- continueIdCounter
- mergedGraph{}
- batchMergedGraphs[]
- selectedBaseChapterId
- writePreview
- precheckResult
- qualityResult
- qualityResultShow
- drawerState{}
- graphComplianceResult / graphCompliancePass
```

**方案：** 扩展 `SharedPreferences` 或使用 `sqflite`/`hive` 做结构化持久化。章节内容（字符串）较大，建议用 `hive` 或压缩存储。

---

### 🟠 P1 — 续写章节阅读（ReaderScreen 支持 continueChain）

**问题描述：** `ReaderScreen` 仅读取 `provider.chapters`（原始章节），无法阅读续写章节。`NovelReader` 在 JS 中完整支持原始章节+续写分支。

**方案：** ReaderScreen 增加 `isContinueChapter` 模式，读取 `continueChain` 数据，同时在底部导航指示当前章节类型。

---

### 🟠 P1 — 阅读器进度精确保存

**问题描述：** JS 版 `readerState` 保存每个章节的 `scrollTop` 阅读进度，Flutter 只保存 `currentChapterId`。

**方案：** 参照 JS 实现 `readProgress: {chapterType_chapterId: scrollTop}` 结构化保存。

---

### 🟡 P2 — API Rate Limiting

**问题描述：** JS 有 1分钟最多3次 API 调用的保护机制，Flutter 缺失，长时间连续生成可能触发 API 限流。

**方案：** 参照 JS `apiCallTimestamps` 滑动窗口实现。

---

### 🟡 P2 — 多分支续写支持

**问题描述：** JS 使用 `【续写分支】A/B/C` 分隔符支持多分支，Flutter 的 `_splitContinuationContent()` 有简单分割但功能较弱。

**方案：** 完善分支检测和展示，每分支单独存入 `continueChain`。

---

### 🟡 P2 — 章节管理增强

**缺失功能：**
- 章节删除（移除误解析的章节）
- 章节重命名（修正识别错误的标题）
- 章节合并（合并过短的章节）
- 手动调整章节边界

---

### 🟢 P3 — 抽屉/面板状态持久化

参照 JS `drawerState`，Flutter 的各展开面板状态（导入面板、图谱面板、续写面板）应持久化。

---

### 🟢 P3 — 发送至外部 App

JS 的 `sendas` 命令依赖 SillyTavern 上下文，Flutter 无此环境。可行替代方案：
- 复制到剪贴板（已有）
- 分享到其他 App（Android Intent Share）
- 保存为 TXT 文件

---

### 🟢 P3 — 护眼/暗色主题阅读器

当前仅有米色纸背景，可增加暗色主题选项。

---

## 五、技术约束

### 5.1 Flutter 版本要求
- minimum SDK: 21 (Android 5.0)
- target SDK: 34
- 使用 `provider` 进行状态管理

### 5.2 依赖关键包
```yaml
provider: ^6.x
shared_preferences: ^2.x
http: ^1.x
file_picker: ^6.x
```

### 5.3 API 兼容性
- OpenAI ChatML 格式（`/v1/chat/completions`）
- 需兼容任意 OpenAI 兼容接口（DeepSeek / Gemini / MiniMax 等）
- 支持 Bearer Token 和 X-API-Key 两种认证

### 5.4 性能约束
- 章节内容字符串大：需考虑压缩或分块存储
- 图谱 JSON 大：合并图谱可能达数百 KB，需分页展示
- AI 生成超时：90秒超时配置

### 5.5 对齐 JS 版本的关键常量

| 常量 | 值 |
|------|-----|
| `maxRetryTimes` | 3 |
| `EMPTY_CONTENT_REGEX` | `^[\s\p{P}]*$` (unicode) |
| `rejectKeywords` | 不能/无法/不符合/抱歉/对不起/无法提供/请调整/违规/敏感/不予生成 |
| `BREAK_LIMIT_PROMPT` | 5条强制规则（见源码） |
| `minWordCount` (图谱) | 1200字 |
| `defaultWriteWordCount` | 2000 |
| `batchSize` | 50章/批 |

---

## 六、测试要点

### 6.1 持久化回归测试
- **冷启动测试**：杀进程后重启，验证章节列表、图谱、续写链条是否恢复
- **数据一致性**：图谱数量与章节数量是否匹配

### 6.2 续写流程测试
- **防空回验证**：模拟 API 返回空内容 / 拒绝提示，验证自动重试
- **质量不合格重写**：mock 不合格质量评估，验证自动重写触发
- **停止按钮**：生成中途点击停止，验证状态重置
- **链条续写**：从链条第 N 章继续，验证上下文正确

### 6.3 图谱流程测试
- **分批合并中断**：分批合并中途停止，验证已有批次结果保留
- **合规性校验**：
  - 缺字段 → 校验不通过
  - 字数 < 1200 → 校验不通过
  - 完整图谱 → 校验通过
- **导入/导出闭环**：导出 JSON → 清空 → 导入 → 验证图谱完整恢复

### 6.4 阅读器测试
- **进度恢复**：阅读第3章后退出，重启验证是否恢复第3章
- **字号调节**：调节字号后重启，验证字号保持
- **续写章节导航**：续写链条有内容时，验证阅读器能切换到续写章节

### 6.5 API 鲁棒性测试
- **401/403**：验证错误提示正确
- **404**：验证友好提示
- **超时**：验证 90 秒超时处理
- **Rate Limit**：连续快速触发多个生成，验证行为符合预期

---

## 七、下一轮迭代计划

### 第一优先级：P0 持久化修复
> 这是**阻断性**问题，直接影响核心用户体验。

**预计工作量：** 中
**步骤：**
1. 设计持久化方案（推荐 `hive`，支持大对象 + 压缩）
2. 扩展 `NovelProvider._saveSettings()` / `_loadSettings()`
3. 覆盖所有核心状态字段
4. 编写自动化回归测试用例

### 第二优先级：P1 续写章节阅读支持
> 与 JS 版本的 `NovelReader` 完整功能对齐。

**预计工作量：** 小
**步骤：**
1. ReaderScreen 增加 `isContinueChapter` 模式
2. 续写章节与原始章节切换逻辑
3. 阅读进度精确保存扩展

### 第三优先级：P2 API Rate Limiting + 多分支续写
> 提升续写质量，减少无效 API 调用。

**预计工作量：** 小
**步骤：**
1. 参照 JS 实现滑动窗口限流
2. 完善多分支检测和存储

### 第四优先级：P2 章节管理增强
> 提升用户体验，减少重复劳动。

**预计工作量：** 中
**步骤：**
1. 删除/重命名/合并章节
2. 手动调整章节边界

---

*本 PRD 由项目总指挥 Agent 输出，基于 `index.js`（~1100行）+ `prompt-constants.js`（~400行）+ Flutter 全量 Dart 源码审查。*
*如需进一步细化某个模块的实现方案，请指定模块名称。*
