# 安全审计报告 - Always Remember Me v3.0

**项目路径**: `/home/kaku5/.openclaw/workspace/always_remember_me_flutter/`
**审计时间**: 2026-04-11
**Flutter SDK**: >=3.0.0 <4.0.0

---

## 1. API Key 安全

### 1.1 API Key 存储 ✅
- **结论**: 通过 ✅
- `NovelProvider` 使用 `FlutterSecureStorage` 存储敏感配置：
  ```dart
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  ```
- 写入位置：`_saveSettings()` 中 `apiBaseUrl`、`apiKey`、`selectedModel` 均写入 `flutter_secure_storage`
- 读取位置：`_loadSettings()` 中从 `flutter_secure_storage` 读取

### 1.2 硬编码泄露检查 ✅
- **结论**: 未发现硬编码
- 全局检索 `lib/` 目录，未发现 `sk-`、`sk_`、明文密钥等硬编码
- `app_settings.dart` 中有 `apiKey` 字段定义，但仅为模型结构，无实际硬编码值

### 1.3 迁移兼容 ✅
- 代码包含从旧版 `SharedPreferences` 迁移 API Key 的逻辑，迁移后立即删除旧数据
- 迁移完成后立即调用 `_saveSettings()` 保存到新位置

---

## 2. JSON 导入导出安全

### 2.1 图谱 JSON 导入 ⚠️ 存在风险
- **结论**: 有隐患
- `importChapterGraphsJson()` 函数直接对输入字符串执行 `json.decode()`，无大小限制：
  ```dart
  void importChapterGraphsJson(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
  ```
- **风险点**:
  - 恶意构造的超大 JSON 可导致内存耗尽（DoS）
  - 建议：导入前校验 JSON 字符串大小（如限制 ≤10MB）
  - 建议：使用 `dart:convert` 的 `JsonDecoder.withReviver` 限制深度

### 2.2 小说内容解析 ⚠️ 存在风险
- **结论**: 有隐患
- 章节文本解析（`ChapterService.splitByRegex`）使用用户输入的自定义正则，无长度/复杂度限制
- **风险点**: 正则表达式 ReDoS（正则表达式拒绝服务）攻击，例如 `^(a+)+$` 类型的恶意正则可导致指数级回溯
- 建议：对用户输入的自定义正则进行复杂度检测或限制

### 2.3 XSS 注入（Flutter 层面）✅
- Flutter 的 `Text`/`SelectableText` Widget 默认对所有文本做转义处理，不解析 HTML
- 图谱展示使用 `SelectableText`，不涉及危险 Widget（如 `Html` 库），XSS 风险低
- **注意**：目前没有对小说文本内容做 HTML 过滤（Flutter 默认已防护，但若将来引入 WebView 或 Html Widget 需重新评估）

---

## 3. 网络安全

### 3.1 HTTPS ✅
- **结论**: 默认安全
- `NovelApiService` 使用 `http` 包，`_buildUrl()` 拼接 `/v1/chat/completions`
- 设置界面默认提示 `https://api.openai.com/v1`
- ⚠️ **警告**: API 地址字段可手动输入 `http://`，无强制 HTTPS 校验。建议在保存配置时校验 URL 以 `https://` 开头，非 https 时给出安全提示

### 3.2 请求频率限制 ❌
- **结论**: 未实现
- `generateGraphsForAllChapters()` 批量生成图谱时，章节间仅 `delay(1000ms)`，无全局限速
- `batchMergeGraphs()` 每批间仅 `delay(1500ms)`
- 建议：添加请求计数器，对高频请求进行惩罚性延迟

---

## 4. 本地存储安全

### 4.1 Hive 数据 ✅
- **结论**: 非敏感数据，可接受
- Hive 存储：章节内容、图谱 JSON、续写链等小说数据
- 建议：Hive 数据未加密（`encryptedSharedPreferences` 仅用于 Android 凭证，不加密 Hive 盒）
- **评估**: 小说章节/图谱属于非敏感用户创作内容，不加密可接受

### 4.2 SharedPreferences ✅
- **结论**: 无敏感数据
- 存储内容：`readerFontSize`、`currentChapterId`、`last_book_id`
- 均为 UI 状态，无敏感信息

---

## 5. 其他安全

### 5.1 恶意代码检测 ❌
- **结论**: 未实现
- 无代码签名校验、无 APK 完整性检测
- Flutter 应用层面常规风险

### 5.2 权限请求 ✅
- **结论**: 仅申请必要权限
- Android `AndroidManifest.xml` 仅声明：
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```
- 无多余权限（无相机、存储、位置、联系人等）

### 5.3 文件导入限制 ✅
- `FilePicker` 仅允许 `.txt` 文件导入：
  ```dart
  allowedExtensions: ['txt'],
  ```
- 有效防止了可执行文件误导入

### 5.4 用户输入校验 ⚠️
- 自定义正则输入无校验
- API URL 输入无格式校验（可输入非 URL 字符串）

---

## 安全问题汇总

| # | 风险等级 | 类别 | 问题描述 | 建议 |
|---|---------|------|---------|------|
| 1 | ⚠️ 中 | 数据导入 | 图谱 JSON 导入无大小限制，可能导致 DoS | 限制 JSON ≤10MB，添加深度限制 |
| 2 | ⚠️ 中 | 解析安全 | 用户自定义正则无复杂度限制，存在 ReDoS 风险 | 添加正则复杂度/长度检测 |
| 3 | ⚠️ 低 | 网络安全 | API 地址可配置为 http://，无强制 HTTPS 提示 | 保存时提示非 HTTPS 风险 |
| 4 | ⚠️ 低 | 网络安全 | 批量图谱生成无全局请求频率限制 | 添加令牌桶或滑动窗口限速 |
| 5 | ⚠️ 低 | 输入校验 | 自定义正则和 API URL 无格式校验 | 添加输入格式校验 |

---

## 总体安全评估

| 维度 | 评分 | 说明 |
|------|------|------|
| API Key 安全 | ⭐⭐⭐⭐⭐ | FlutterSecureStorage + encryptedSharedPreferences，存储安全 |
| 网络安全 | ⭐⭐⭐⭐ | 默认 HTTPS，建议增加 http:// 警告 |
| 数据导入安全 | ⭐⭐⭐ | JSON 解析无大小限制，中等风险 |
| 本地存储安全 | ⭐⭐⭐⭐ | Hive 用于非敏感小说数据，可接受 |
| 权限控制 | ⭐⭐⭐⭐⭐ | 仅 INTERNET 权限，最小权限原则 |

**总体评价**: 应用基础安全实践良好，API Key 存储规范，权限最小化。**主要风险点**集中在 JSON 导入的无限制解析和自定义正则的 ReDoS 可能性，建议优先修复。
