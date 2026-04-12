# Always Remember Me Flutter 项目计划

> 基于 PRD_v4.md + ITERATION_PLAN_v5.md + TEST_REPORT_v5.md 制定
> 制定日期：2026-04-12

---

## 一、项目概述

**项目名称**：Always Remember Me（小说续写工具 App）
**Flutter 项目路径**：`/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`
**APK 路径**：`/mnt/c/Users/kaku5/Desktop/always_remember_me.apk`

### 当前版本：v4.0（线上）+ v5.0-alpha（架构重构中）

---

## 二、当前项目状态

| 维度 | 状态 |
|------|------|
| 产品需求 | PRD v4.0 已完成 |
| 架构重构 | v5.0 ITERATION_PLAN 已制定，部分落地（features/ 目录存在） |
| 测试覆盖 | TEST_REPORT v5.0 已生成，49 项测试全部标记 [TODO] |
| Bug 修复 | 书架章节缓存 Bug（import 互串）待彻底修复 |
| Flutter SDK | Windows 本地，WSL2 无法直接 build |

### 2.1 当前架构（旧）

```
lib/
├── main.dart
├── providers/novel_provider.dart   # ~1000行，单文件全状态
├── services/
│   ├── storage_service.dart          # Hive 存储
│   ├── chapter_service.dart
│   └── novel_api_service.dart        # AI 续写 API
├── screens/                          # 旧 UI（待废弃）
│   ├── bookshelf/                    # 书架
│   ├── import/                       # 导入
│   ├── chapters/                     # 章节管理
│   ├── reader/                       # 阅读器
│   ├── write/                        # 续写
│   ├── graph/                        # 图谱
│   └── settings_screen.dart
├── models/
│   ├── novel_book.dart
│   ├── chapter.dart
│   └── knowledge_graph.dart
└── widgets/
```

### 2.2 目标架构（v5.0）

```
lib/
├── main.dart
├── app/                              # 应用级配置
│   ├── app.dart
│   ├── router/app_router.dart        # GoRouter 路由
│   └── theme/colors.dart             # 统一色彩系统
├── core/                             # 核心基础设施
│   ├── database/                     # Drift（未来替代 Hive）
│   ├── network/                      # HTTP 封装
│   ├── utils/
│   └── exceptions/
├── features/                          # 功能模块（各自独立三层架构）
│   ├── bookshelf/                    # ✅ 部分落地
│   ├── reader/                       # ✅ 部分落地
│   ├── writing/                      # 续写
│   ├── graph/                        # 图谱
│   └── chapter_management/           # 章节管理
└── common_ui/                        # 跨功能 UI 组件
```

---

## 三、待完成任务清单

### 3.1 🚨 P0 - 紧急（阻塞测试验收）

#### Bug修复：导入小说章节数据串书问题

**问题描述**：导入第一本小说后再导入第二本，导入界面显示的是第一本小说的章节。

**根因分析**（已确认）：
- `importBook` 中防抖定时器把旧书数据写到新书 Hive key
- `selectBook` 的 `early return` 跳过 `_loadBookData`，导致章节复用
- `_lastImportCacheKey` 判断逻辑未隔离 `bookId`

**已应用的修复**：
- Fix 1：storage_service.dart 增加 `rawChapters != null` 兜底
- Fix 2：novel_provider.dart 拆分 try-catch
- Fix 3：importBook 二次保存失败抛出 StateError
- Fix 4：selectBook 移除 early return 条件
- Fix 5（commit 538e9c8）：`_lastImportCacheKey = '$bookId|$novelText'`，混入 bookId 区分缓存

**验证方法**：清除应用数据 → 导入 book1 → 导入 book2 → 确认导入界面显示 book2 章节

---

### 3.2 📋 测试验收（P0）

**来源**：TEST_REPORT_v5.md，49 项手动测试全部标记 [TODO]

| 模块 | 测试项数 | 关键测试 |
|------|----------|----------|
| 书架 v5.0 | 13 项 | 空状态 UI、书籍切换、QuickActionsBar、删除确认 |
| 阅读器 v5.0 | 11 项 | 4 主题切换、字号调节、滚动位置持久化 |
| 导入 v4.0 | 7 项 | 导入流程、章节解析、书名重复检测 |
| 章节管理 | 5 项 | 批量删除、图谱生成状态 |
| 续写 | 10 项 | 前置校验、质量评估、批量续写、链条管理 |
| 图谱 | 8 项 | 单章/批量/全量合并、导入导出 |
| 设置 | 5 项 | API 配置持久化、重启验证 |

**行动计划**：
1. 先修复 Bug 并 build 新 APK
2. 哥哥在真机安装测试
3. 逐模块验收，bug 即时修复

---

### 3.3 🔧 v5.0 架构重构（P1，按 ITERATION_PLAN_v5.md）

#### Phase 1.1：目录结构（当前部分完成）
- ✅ features/bookshelf/presentation/screens/ 已创建
- ✅ features/reader/presentation/screens/ 已创建
- ❌ 旧 screens/ 目录尚未删除
- ❌ features/writing/graph/chapter_management 尚未拆分

**Action**：清理旧 screens/ 目录中的已迁移页面

#### Phase 1.2：状态管理 Provider → Riverpod
- 目标：`NovelProvider` 拆分为各 feature 的 Riverpod Provider
- 优先级：configProvider → bookshelfProvider → chapterProvider → graphProvider → writingProvider

#### Phase 2：数据库 Hive → Drift
- Drift schema 已设计但未实施
- 数据迁移脚本待开发

#### Phase 3：核心功能 UseCase 提取
- 书架：CRUD usecase
- 章节：ParseChapterUseCase、SplitByWordCountUseCase
- 续写：GenerateWriteUseCase、RunPrecheckUseCase
- 图谱：GenerateSingleGraphUseCase、MergeGraphsUseCase

#### Phase 4：UI/UX 重构
- 按 PRD_v4.md 的 v4.0 UI 方案执行
- BottomNav 3Tab + Drawer 侧边栏

#### Phase 5：测试与部署
- 单元测试（UseCase）
- 集成测试（CRUD 流程）
- 版本号升至 v5.0.0

---

## 四、迭代里程碑

### Milestone 1：Bug 修复 + 测试验收（1-3天）
- [ ] 导入串书 Bug 完全修复
- [ ] 49 项测试验收通过
- [ ] APK build 并交付哥哥安装

### Milestone 2：v5.0 Phase 1 完成（1-2周）
- [ ] 全部 5 个 feature 迁移到 features/ 目录
- [ ] Riverpod Provider 完整覆盖
- [ ] 旧 NovelProvider 标记废弃

### Milestone 3：v5.0 Phase 2 完成（1-1.5周）
- [ ] Drift 数据库落地
- [ ] Hive → Drift 数据迁移脚本
- [ ] 迁移后数据完整性验证

### Milestone 4：v5.0 Phase 3-4 完成（3-5周）
- [ ] 全部 UseCase 提取并测试
- [ ] AI 服务抽象层（多模型支持）
- [ ] UI/UX 按 PRD 重构
- [ ] common_ui 组件库完善

### Milestone 5：v5.0 正式发布（1周）
- [ ] 全部测试用例执行
- [ ] APK/AAB 签名打包
- [ ] README/应用商店材料更新

---

## 五、技术债务清单

| # | 问题 | 优先级 | 备注 |
|---|------|--------|------|
| 1 | `NovelProvider` 单文件 ~1000行，过度耦合 | P1 | Phase 1.2 Riverpod 拆分 |
| 2 | Hive 数据迁移到 Drift | P2 | Phase 2 |
| 3 | 旧 screens/ 目录残留 | P2 | Phase 1.1 清理 |
| 4 | 版本号显示不统一（v1.0.0 vs v3.0.0） | P3 | 设置页显示问题 |
| 5 | 图谱可视化依赖手写 Canvas | P3 | 可引入 graphview 库 |
| 6 | WSL2 无法直接 build Flutter APK | 已知限制 | 需 Windows 本地构建 |

---

## 六、Git 工作流

**Commit 规范**：
- `fix: [模块] 描述` — Bug 修复
- `feat: [模块] 描述` — 新功能
- `refactor: [模块] 描述` — 重构
- `test: [模块] 描述` — 测试用例

**推送注意**：WSL2 → GitHub 网络不稳定，建议手动在 Windows 端 APKPac + 稍后重试 push，或配置代理。

---

*本计划基于 PRD_v4.md、ITERATION_PLAN_v5.md、TEST_REPORT_v5.md 制定*
*项目负责人：project-lead agent · 制定时间：2026-04-12*
