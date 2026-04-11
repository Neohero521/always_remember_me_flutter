# Always Remember Me v2.0 PRD

> 基于 v1.0 基线代码审查，聚焦 P0/P1 迭代需求

---

## 功能列表

| ID | 功能 | 优先级 | 验收标准 |
|----|------|--------|---------|
| F1 | 书架章节丢失 Bug 修复 | P0 | 切换书籍后返回，章节列表/图谱/续写链条完整恢复 |
| F2 | 魔改章节图谱更新按钮 | P0 | 章节详情页有"更新图谱"按钮，点击触发 `updateModifiedChapterGraph()` |
| F3 | 一键批量续写 | P0 | 选择起始章节后自动续写后续所有章节，进度UI可见，完成后自动更新图谱 |
| F4 | 阅读器滚动位置持久化 | P1 | 退出阅读器后重启，同章节恢复相同滚动位置 |
| F5 | 图谱合规性校验按钮 | P1 | 章节管理页有校验按钮，点击对所有章节图谱做合规性检查并展示结果 |

---

## 详细功能定义

### F1: 书架章节丢失 Bug 修复

- **需求描述**：修复 `selectBook` / Hive 持久化链路问题，确保切换书籍后返回时，章节列表、图谱、续写链条数据完整恢复，不丢失。
- **用户场景**：用户导入小说 A，生成图谱，续写了几个章节 → 切换到书架看其他书 → 切回小说 A → 发现章节丢失或图谱空白，必须重新导入。
- **核心交互流程**：
  1. 用户在书架点击书籍 A → `selectBook(A)` 被调用
  2. 系统保存当前书数据 → 加载书籍 A 数据 → 渲染
  3. 用户切到其他书 → 再切回书籍 A
  4. **预期**：章节列表 + 图谱 + 续写链条与离开前完全一致
  5. **根因分析（代码层面）**：`selectBook` 中 `_loadBookData` 在 bookId 未在 Hive 中存在时返回 `false`，但调用方未正确处理；同一本书切换时 `prevBookId` 逻辑存在边界情况
- **验收标准**：
  - [ ] 导入小说并生成部分图谱后，切换到其他书再切回，图谱数据不丢失
  - [ ] 续写链条存在时，切换书籍再切回，链条数据完整
  - [ ] 冷启动（杀进程）后重新打开，自动恢复上次阅读的书籍和章节
  - [ ] Hive 中 `NovelPersistData` 的各字段（chapters/chapterGraphMap/continueChain/mergedGraph）均被正确序列化和反序列化

---

### F2: 魔改章节图谱更新按钮

- **需求描述**：在章节详情页或章节编辑入口，添加"更新图谱"按钮，调用已实现的 `updateModifiedChapterGraph(chapterId, modifiedContent)` 方法，允许用户修改章节内容后一键刷新图谱。
- **用户场景**：用户在 WriteScreen 魔改了某个章节的内容 → 需要同步更新该章节对应的知识图谱 → 当前没有UI入口，必须去 ChaptersScreen 手动重新生成。
- **核心交互流程**：
  1. 用户在 WriteScreen 修改章节内容并保存
  2. 章节详情弹窗或 WriteScreen 底部出现"更新图谱"按钮
  3. 点击 → 显示生成进度 → 完成 → toast 提示"图谱已更新"
  4. 若图谱生成失败，显示错误原因
- **验收标准**：
  - [ ] WriteScreen 或章节详情弹窗中存在"更新图谱"按钮
  - [ ] 点击后触发 `updateModifiedChapterGraph()`，传入当前章节 ID 和用户修改后的内容
  - [ ] 进度状态正确展示（loading/成功/失败）
  - [ ] 成功后 `_chapterGraphMap` 中对应章节图谱已更新

---

### F3: 一键批量续写

- **需求描述**：包装循环调用续写逻辑 + 进度 UI，支持从指定起始章节开始，自动续写后续所有章节，每章完成后自动更新图谱，用户可随时停止。
- **用户场景**：用户已完成前 10 章，想要一口气把第 11-30 章全部续写完 → 点击"批量续写"→ 选择起始章节（第 11 章）→ 系统自动逐章续写，实时显示进度（第 11/30...）→ 每章完成后自动生成/更新图谱 → 用户可中途停止。
- **核心交互流程**：
  1. HomeScreen 或 WriteScreen 新增"批量续写"入口按钮
  2. 用户点击 → 弹出章节选择器（只能选原始章节，不能选续写链条中的章节）
  3. 选择起始章节后，确认
  4. 系统开始续写第一章节（复用现有 `generateWrite` 逻辑）
  5. 续写完成后，自动调用 `updateGraphWithContinueContent()` 更新图谱
  6. 进入下一章节重复，直到全部完成或用户点击"停止"
  7. 全部完成后显示总结（成功N章/失败N章）
- **进度 UI 设计**：
  - 模态对话框或全屏覆盖层
  - 显示：当前章节 / 总章节、章节标题、续写进度条、当前操作（续写中/生成图谱中/空闲）
  - 停止按钮（取消后保留已成功章节的结果）
- **验收标准**：
  - [ ] 批量续写从用户选择的起始章节开始，自动向后续写所有后续原始章节
  - [ ] 每章续写完成后自动更新该章图谱（若 `autoUpdateGraphAfterWrite` 开启）
  - [ ] 进度 UI 实时显示当前章节序号/总数十、当前操作状态
  - [ ] 支持中途停止，停止后已完成的章节结果保留
  - [ ] 全部完成后有总结提示
  - [ ] 续写失败（防空回/质量不合格）自动重试，3次后仍失败则跳过并记录

---

### F4: 阅读器滚动位置持久化

- **需求描述**：当前 ReaderScreen 使用 `PageView` + `PageController` 以章节为粒度翻页，但每个章节内部的滚动位置（ScrollController position）未保存。用户在某章节内滚动到中间位置后退出，重启后仍回到章节开头。
- **用户场景**：用户阅读第 5 章，滑到中间某个位置（70% 处）→ 退出阅读器 → 再次打开 → 系统恢复到了第 5 章但从头开始，需要重新滑动到之前的位置。
- **核心交互流程**：
  1. 阅读器中，用户在章节内滚动
  2. 系统记录 `Map<chapterId, scrollOffset>`（scrollOffset 为 0.0~1.0 的相对位置）
  3. 退出阅读器时（`dispose` 或按返回键）将位置写入持久化存储
  4. 下次进入同一章节时，用保存的 scrollOffset 恢复滚动位置
  5. 翻到下一章时，offset 重置为 0（从头开始）
- **技术方案**：
  - 每个章节的 `ScrollController` 在 `initState` 时根据保存的 offset 计算 `jumpTo(offset * maxScrollExtent)`
  - 持久化 key 格式：`reader_scroll_{bookId}_{chapterId}`，value 为 0.0~1.0 的 double
  - 或合并到 `SharedPreferences` 的 reader 状态中
- **验收标准**：
  - [ ] 用户在章节内滚动到任意位置后退出阅读器
  - [ ] 重新打开同一章节，自动恢复到之前的滚动位置（误差 ≤ 1 行）
  - [ ] 切换到其他章节后回到原章节，位置保持
  - [ ] 字号调节不影响已保存的相对滚动位置

---

### F5: 图谱合规性校验按钮

- **需求描述**：在 ChaptersScreen 的菜单或工具栏添加"图谱合规性校验"按钮，点击后对当前书籍的所有章节图谱执行 `validateGraphCompliance()` 批量校验，并展示汇总结果（哪些通过/哪些字段缺失/哪些字数不足）。
- **用户场景**：用户批量生成了全部图谱，想要检查是否有图谱不完整或不合格（字段缺失/字数<1200/自洽得分低）→ 当前只能逐章点开查看 → 没有一键校验入口。
- **核心交互流程**：
  1. 用户在 ChaptersScreen 点击菜单 → 选择"图谱合规性校验"
  2. 系统遍历 `_chapterGraphMap` 中所有图谱，逐个调用校验逻辑
  3. 显示进度：`正在校验第 X / N 章图谱...`
  4. 完成后弹出汇总结果对话框：
     - 通过数 / 不合格数
     - 不合格章节列表 + 不合格原因（缺字段/字数不足/自洽得分低）
  5. 用户可点击某章节直接跳转到该章节详情
- **校验规则（参照 `validateChapterGraphStatus`）**：
  - 8个必填字段完整性
  - 章节内容字数 ≥ 1200
  - 自洽得分 ≥ 阈值（可配置，默认 60）
- **验收标准**：
  - [ ] ChaptersScreen 的菜单/PopupMenu 中有"图谱合规性校验"入口
  - [ ] 点击后正确调用 `validateGraphCompliance()` 并显示进度
  - [ ] 完成后展示通过/不通过的汇总统计
  - [ ] 不合格章节显示具体原因（缺字段名称/字数实际值/自洽得分）
  - [ ] 支持点击不合格章节跳转查看详情

---

## 技术实现备注

### 批量续写循环包装

```dart
// 伪代码结构
Future<void> batchContinueWrite(int startChapterId) async {
  final startIdx = chapters.indexWhere((c) => c.id == startChapterId);
  final originalChapters = chapters.where((c) => c.isOriginal).toList();
  
  for (var i = startIdx; i < originalChapters.length; i++) {
    if (_stopBatchWrite) break;
    
    final chapter = originalChapters[i];
    _batchWriteState = '续写第 ${i+1}/${total} 章: ${chapter.title}';
    notifyListeners();
    
    // 续写
    final result = await generateWrite(chapter.id);
    if (result == null) continue; // 防空回已内部重试
    
    // 自动更新图谱
    if (autoUpdateGraphAfterWrite) {
      _batchWriteState = '更新图谱...';
      await updateGraphWithContinueContent(chapter.id, result);
    }
  }
  
  _batchWriteState = '批量续写完成';
}
```

### 滚动位置持久化 Key

```
reader_scroll_{bookId}_{chapterId} → double (0.0 ~ 1.0)
```

读取：在 `ReaderScreen.initState` 中根据当前 `bookId + chapterId` 读取并 apply
写入：在 `dispose` 或 `WillPopScope` 中写入 `SharedPreferences`

---

*本 PRD 由产品需求 Agent 输出，基于 `novel_provider.dart` / `reader_screen.dart` / `chapters_screen.dart` 源码分析*
