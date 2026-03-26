按照Conventional Commits規範生成常規提交消息並自動創建提交。

## 步驟：
1. 使用 git status 和 git diff --staged 分析當前的 git 更改
2. 確認是否要拆分為多個提交
2. 確定適當的提交類型（feat、fix、docs、style、refactor、test、chore 等）
3. 確定範圍（如果適用）（受影響的元件、模組或區域）
4. 用祈使語氣寫一個簡潔的描述 （50 個字元或更少）
5. 如果更改很複雜，請添加詳細的正文（換行為 72 個字元）
6. 包括中斷性變更頁腳（如果適用）
7. 格式為： type（scope）： description
8. 使用生成的消息創建提交

## 拆分提交準則

- 不同的關注點 ：對代碼庫的不相關部分的更改
- 不同類型的更改 ：混合功能、修復、重構等。
- 檔案模式 ：對不同類型檔案的變更（例如，原始程式碼與文件）
- 邏輯分組 ：更易於理解或單獨查看的更改
- 大小 ：非常大的變化，如果分解會更清晰

## 格式範例：
feat(auth): add OAuth2 login support
fix(api): resolve null pointer in user endpoint
docs: update installation instructions
chore(deps): bump lodash to 4.17.21

## 注意事項 
- 根據更改生成最合適的提交消息並自動提交
- 如果更改涉及多個關注點，請將它們拆分為單獨的提交
- 每個提交都應包含用於單一目的的相關更改
- 確保代碼已檢查、正確構建並更新文檔
- 重要: 提交的訊息請使用繁體中文且符合台灣用語習慣，並避免留下相關 AI 產生記錄


