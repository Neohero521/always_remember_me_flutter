# 安全审计报告 - Always Remember Me v5.0

**项目路径**: `/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`
**审计时间**: 2026-04-11
**Flutter SDK**: >=3.0.0 <4.0.0
**版本**: v5.0 Phase4.1 (BookshelfScreen + ReaderScreen UI重构)

---

## 1. API Key 安全

### 1.1 API Key 存储 ✅
- **结论**: 通过（与 v3.0 相同）
- `NovelProvider` 使用 `FlutterSecureStorage` + `AndroidOptions(encryptedSharedPreferences: true)`
- `apiBaseUrl`、`apiKey`、`selectedModel` 均写入 secure storage
- 从 secure storage 读取，迁移逻辑保留（从旧版 SharedPreferences 迁移后立即清理）

### 1.2 硬编码泄露检查 ✅
- **结论**: 未发现硬编码
- 全局检索 `lib/`，未发现 `sk-`、`sk_`、明文密钥等硬编码
- `app_settings.dart` 仅为模型结构，无实际值

### 1.3 遗留依赖 ⚠️
- `pubspec.yaml` 中声明了 `dio: ^5.8.0`，但代码中**实际未使用** Dio
- `NovelApiService` 和 `SettingsScreen` 均使用 `http` 包
- **风险**: 遗留依赖增加 APK 体积，建议移除未使用的 Dio

---

## 2. JSON 导入导出安全

### 2.1 图谱 JSON 导入 ⚠️ 存在风险（与 v3.0 相同，未修复）
- **结论**: 有隐患
- `NovelProvider.importChapterGraphsJson()` 直接对输入字符串执行 `json.decode()`，无大小限制
- `GraphImportExportScreen._validateJson()` 仅做格式预校验（检查是否以 `{` 或 `[` 开头），不校验大小
- **风险**: 恶意构造的超大 JSON 可导致内存耗尽（DoS）
- **修复建议**: 导入前校验 JSON 字符串大小 ≤10MB，添加深度限制

### 2.2 图谱导出 ⚠️ 新增问题
- **结论**: 有 bug，影响功能而非安全
- `GraphNotifier.exportJson()` 使用 `graph.toString()` 而非 `json.encode()`
- 导出 JSON 格式损坏，实际导出的是 Dart 对象的 `toString()` 表示而非合法 JSON
- **修复建议**: 改用 `const JsonEncoder.withIndent('  ').convert(exportData)`

### 2.3 正则解析 ReDoS ⚠️ 存在风险（与 v3.0 相同，未修复）
- **结论**: 有隐患
- `ChapterService.splitByRegex()` 直接将用户输入的自定义正则传入 `RegExp()` 构造器
- `getSortedRegexList()` 对预设正则列表逐一执行 `RegExp()`，用户自定义正则无任何复杂度限制
- **风险**: 恶意正则可导致指数级回溯（ReDoS），如 `^(a+)+$`
- **修复建议**: 添加正则复杂度/长度检测，限制最大匹配次数

### 2.4 XSS 注入（Flutter 层面）✅
- Flutter 的 `Text`/`SelectableText` Widget 默认转义，不解析 HTML
- ReaderScreen、BookshelfScreen 均无危险 Widget（如 `Html`、WebView）
- 图谱展示使用 `SelectableText`，XSS 风险低

---

## 3. 网络安全

### 3.1 HTTPS ⚠️ 低风险（与 v3.0 相同）
- `NovelApiService` 使用 `http` 包（`package:http/http.dart`）
- `_buildUrl()` 拼接 `/v1/chat/completions`，但**不校验 URL 协议**
- API 地址字段可手动输入 `http://`，无强制 HTTPS 提示
- `SettingsScreen._fetchModels()` 调用模型列表接口，同样使用 `http.get()`
- **修复建议**: 保存配置时校验 URL 以 `https://` 开头，非 https 时弹出安全警告

### 3.2 HTTP 客户端安全 ⚠️ 中等风险（新增）
- **结论**: 使用 `http` 包而非 Dio
- `http` 包不支持拦截器，无法统一添加超时、证书校验、重试策略
- `NovelApiService` 在单个方法内自行处理 90s 超时（`.timeout()`）和重试（循环 3 次）
- `SettingsScreen._fetchModels()` 使用 30s 超时
- **评估**: 功能上可接受，但缺少统一拦截器带来的审计盲区
- **建议**: 考虑迁移到 Dio 以获得统一的网络层安全管控

### 3.3 请求频率限制 ❌（与 v3.0 相同，未改进）
- **结论**: 未实现
- `generateGraphsForAllChapters()` 章节间固定延迟 1000ms
- `batchMergeGraphs()` 每批间固定延迟 1500ms
- 建议：添加令牌桶或滑动窗口限速

---

## 4. 本地存储安全

### 4.1 Hive 数据 ✅
- **结论**: 非敏感数据，可接受（与 v3.0 相同）
- Hive 存储：章节内容、图谱 JSON、续写链等小说数据
- **注意**: Hive 盒**未加密**（`encryptedSharedPreferences` 仅用于 Android 凭证存储，不加密 Hive）
- **评估**: 小说内容属于用户创作数据，不加密可接受

### 4.2 SharedPreferences ✅
- **结论**: 无敏感数据（与 v3.0 相同）
- 存储内容：`readerFontSize`、`currentChapterId`、`last_book_id`、阅读滚动位置
- 均为 UI 状态，无敏感信息

### 4.3 阅读进度存储 ✅
- ReaderScreen v5.0 将滚动位置以 `reader_scroll_{bookId}_{chapterId}` 为 key 存入 SharedPreferences
- 仅存储 0-1 的浮点数 fraction，无敏感信息

---

## 5. 权限控制

### 5.1 Android 权限 ✅
- **结论**: 仅申请必要权限（与 v3.0 相同）
- `AndroidManifest.xml` 仅声明：
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```
- 无相机、存储、位置、联系人等多余权限

### 5.2 FilePicker ✅
- `ImportScreen` 使用 `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt'])`
- 有效防止可执行文件误导入

---

## 6. 续写内容安全

### 6.1 prompt 注入风险 ⚠️ 低风险（新增观察项）
- `generateWrite()` 将用户修改的章节内容（`modifiedContent`）拼入 `systemPrompt`
- 用户可通过修改章节内容间接影响 AI prompt
- **评估**: 对 AI 续写应用来说这是预期行为，不构成安全漏洞（用户自有数据）

### 6.2 破限规则常量 ⚠️ 需关注
- `breakLimitPrompt` 硬编码在源码中，提示 AI "禁止输出任何与小说正文无关的解释"
- 这些规则在客户端可见但不影响服务端行为

---

## 7. 新增/变更代码审计（v5.0 重点）

### 7.1 BookshelfScreen v5.0 ✅
- 删除操作有 `showConfirmDialog` 确认，防止误删
- 加载状态有 UI 反馈（`_loadingBookId` 状态管理）
- 无安全相关问题

### 7.2 ReaderScreen v5.0 ✅
- 阅读滚动位置存储使用 fraction（0-1 浮点数），非直接像素值
- 不涉及网络请求
- 无 XSS 风险（纯 Text Widget）
- 无安全相关问题

### 7.3 GraphNotifier ✅
- 状态管理独立于 NovelProvider，设计合理
- `importGraphs()` 直接将 Map 转为 GraphMap，无恶意构造检测（同 2.1 问题）
- `exportJson()` bug：使用 `toString()` 而非 JSON 编码（影响功能，不影响安全）

### 7.4 WriteSettingsScreen ✅
- 纯本地 UI 设置，无网络操作
- `_saveSettings()` 仅更新 `NovelProvider` 配置

---

## 安全问题汇总

| # | 风险等级 | 类别 | 问题描述 | 状态 | 建议 |
|---|---------|------|---------|------|------|
| 1 | ⚠️ 中 | 数据导入 | 图谱 JSON 导入无大小限制，可导致 DoS | 未修复（v3.0 遗留） | 限制 JSON ≤10MB，添加深度限制 |
| 2 | ⚠️ 中 | 正则解析 | 用户自定义正则无复杂度限制，存在 ReDoS 风险 | 未修复（v3.0 遗留） | 添加正则复杂度检测，限制最大匹配次数 |
| 3 | ⚠️ 低 | 网络安全 | API 地址可配置为 http://，无强制 HTTPS 提示 | 未修复（v3.0 遗留） | 保存时校验 https://，提示非 HTTPS 风险 |
| 4 | ⚠️ 低 | 网络安全 | 批量图谱生成无全局请求频率限制 | 未修复（v3.0 遗留） | 添加令牌桶或滑动窗口限速 |
| 5 | ⚠️ 低 | 网络安全 | 使用 `http` 包无统一拦截器 | 新增观察项 | 考虑迁移 Dio 以获得统一网络层管控 |
| 6 | ⚠️ 低 | 输入校验 | 自定义正则和 API URL 无格式校验 | 未修复（v3.0 遗留） | 添加输入格式校验 |
| 7 | 🐛 功能 | 图谱导出 | `GraphNotifier.exportJson()` 使用 `toString()` 而非 `json.encode()` | v5.0 新增 | 改用 `const JsonEncoder.withIndent('  ').convert()` |
| 8 | ℹ️ 体积 | 依赖管理 | `dio` 在 pubspec.yaml 中声明但未使用 | v5.0 新增 | 移除未使用的 Dio 依赖以减小 APK 体积 |

---

## 总体安全评估

| 维度 | 评分 | 说明 |
|------|------|------|
| API Key 安全 | ⭐⭐⭐⭐⭐ | FlutterSecureStorage + encryptedSharedPreferences，存储规范 |
| 网络安全 | ⭐⭐⭐⭐ | 默认 HTTPS（用户配置），http 包功能够用但欠统一 |
| 数据导入安全 | ⭐⭐⭐ | JSON 解析无大小限制，中等风险（v3.0 遗留未修复）|
| 本地存储安全 | ⭐⭐⭐⭐ | Hive 用于非敏感小说数据，可接受 |
| 权限控制 | ⭐⭐⭐⭐⭐ | 仅 INTERNET 权限，最小权限原则 |
| v5.0 UI 安全 | ⭐⭐⭐⭐⭐ | Bookshelf/Reader 无安全相关问题 |
| 依赖管理 | ⭐⭐⭐ | 存在未使用的 Dio 依赖 |

**总体评价**: v5.0 在 UI 重构层面无引入新安全问题。API Key 存储保持规范，权限最小化原则依然良好。**核心风险点仍集中在 JSON 导入无限制解析（DoS）和自定义正则 ReDoS**，建议优先处理这两项遗留问题。

**v5.0 变更评估**: BookshelfScreen 和 ReaderScreen 的重构不涉及安全相关逻辑，新增功能（图谱导出 bug 仅影响功能）未引入新的安全漏洞。
