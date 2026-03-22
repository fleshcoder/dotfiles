# Neovim Cheatsheet

> Leader 鍵 = `空白鍵 (Space)`
> 主題：kanagawa-dragon ｜ 插件管理：lazy.nvim

---

## 一、全域自訂快捷鍵

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `jj` | Insert | 退出 Insert 模式（等同 `Esc`） |
| `Esc` | Normal | 清除搜尋高亮 |
| `Esc Esc` | Terminal | 退出終端模式 |
| `<leader>q` | Normal | 開啟診斷 Quickfix 列表 |

---

## 二、視窗 / Tmux 導航 (vim-tmux-navigator)

在 Neovim 視窗與 Tmux 面板之間無縫切換。

| 快捷鍵 | 說明 |
|--------|------|
| `Ctrl+h` | 導航至左方視窗 / Tmux pane |
| `Ctrl+j` | 導航至下方視窗 / Tmux pane |
| `Ctrl+k` | 導航至上方視窗 / Tmux pane |
| `Ctrl+l` | 導航至右方視窗 / Tmux pane |
| `Ctrl+\` | 導航至前一個視窗 / Tmux pane |

---

## 三、Telescope — 模糊搜尋

在 Telescope 視窗內，按 `?`（Normal）或 `Ctrl+/`（Insert）可查看所有 Telescope 內部快捷鍵。

### 搜尋指令

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>sf` | 搜尋檔案 |
| `<leader>sg` | Live Grep（全專案文字搜尋） |
| `<leader>sw` | 搜尋游標下的單字 |
| `<leader>sh` | 搜尋 Help 文件 |
| `<leader>sk` | 搜尋所有快捷鍵 |
| `<leader>ss` | 搜尋 Telescope 內建 picker |
| `<leader>sd` | 搜尋診斷訊息 |
| `<leader>sr` | 恢復上一次搜尋結果 |
| `<leader>s.` | 搜尋最近開啟的檔案 |
| `<leader>s/` | 在已開啟的檔案中 Live Grep |
| `<leader>sn` | 搜尋 Neovim 設定檔 |
| `<leader>/` | 在目前 Buffer 內模糊搜尋 |
| `<leader><leader>` | 搜尋已開啟的 Buffer |

### Git 相關（透過 Telescope）

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>gc` | 瀏覽 Git Commits |
| `<leader>gs` | 瀏覽 Git Status |
| `<leader>gb` | 瀏覽 Git Branches |

---

## 四、Neo-tree — 檔案總管

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `<leader>e` | Normal | 開關 Neo-tree 側邊欄 |
| `<leader>E` | Normal | 在 Neo-tree 中定位目前檔案 |
| `<leader>ge` | Normal | 浮動視窗顯示 Git Status |

### Neo-tree 視窗內操作

| 按鍵 | 說明 |
|------|------|
| `Enter` / `l` | 開啟檔案 / 展開目錄 |
| `h` | 收合目錄 |
| `Space` | 展開 / 收合節點 |
| `v` | 垂直分割開啟 |
| `s` | 水平分割開啟 |
| `t` | 新 Tab 開啟 |
| `P` | 浮動預覽 |
| `a` | 新增檔案 |
| `A` | 新增目錄 |
| `d` | 刪除 |
| `r` | 重新命名 |
| `y` | 複製到剪貼簿 |
| `x` | 剪下到剪貼簿 |
| `p` | 從剪貼簿貼上 |
| `c` | 複製檔案 |
| `m` | 移動檔案 |
| `R` | 重新整理 |
| `H` | 顯示 / 隱藏隱藏檔 |
| `/` | 模糊搜尋 |
| `Backspace` | 回到上層目錄 |
| `.` | 設定此目錄為根目錄 |
| `q` | 關閉 Neo-tree |
| `?` | 顯示說明 |

---

## 五、LSP — 語言伺服器

已啟用的 LSP：gopls、ts_ls、volar、eslint、lua_ls（Java 由 nvim-java 另外管理）。

以下快捷鍵在 LSP 連接的 Buffer 中有效：

### 跳轉 (Goto)

| 快捷鍵 | 說明 |
|--------|------|
| `grd` | 跳至定義 (Definition) |
| `grD` | 跳至宣告 (Declaration) |
| `grr` | 列出參考 (References) |
| `gri` | 跳至實作 (Implementation) |
| `grt` | 跳至型別定義 (Type Definition) |
| `gO` | 列出目前文件的 Symbols |
| `gW` | 列出工作區的 Symbols |

### 重構 / 操作

| 快捷鍵 | 說明 |
|--------|------|
| `grn` | 重新命名 (Rename) |
| `gra` | 程式碼動作 (Code Action)，支援 Normal 與 Visual 模式 |

### 其他

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>th` | 切換 Inlay Hints 顯示 |
| `Ctrl+t` | 跳回（從定義跳回原位置） |

---

## 六、自動補全 (blink.cmp)

來源：LSP、Path、Snippets、Buffer。輸入時自動觸發，有 ghost text 預覽。

| 快捷鍵 | 說明 |
|--------|------|
| `Tab` | 選擇下一個補全項 / Snippet 下一個位置 |
| `Shift+Tab` | 選擇上一個補全項 / Snippet 上一個位置 |
| `Enter` | 確認選取 |
| `Ctrl+e` | 取消補全 |
| `Ctrl+Space` | 手動觸發補全 / 切換文件顯示 |
| `Ctrl+b` | 文件視窗向上捲動 |
| `Ctrl+f` | 文件視窗向下捲動 |

---

## 七、格式化 (conform.nvim)

存檔時自動格式化。格式化工具：Lua → stylua、Go → goimports + gofumpt、JS/TS/Vue/Web → prettierd。

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `<leader>f` | Normal / Visual | 手動格式化目前 Buffer 或選取範圍 |

---

## 八、Git Signs (gitsigns.nvim)

符號欄顯示：`+` 新增、`~` 修改、`_` 刪除。

### Hunk 跳躍

| 快捷鍵 | 說明 |
|--------|------|
| `]h` | 下一個 Hunk |
| `[h` | 上一個 Hunk |

### Hunk 操作

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `<leader>hs` | Normal / Visual | Stage Hunk |
| `<leader>hr` | Normal / Visual | Reset Hunk |
| `<leader>hS` | Normal | Stage 整個 Buffer |
| `<leader>hR` | Normal | Reset 整個 Buffer |
| `<leader>hu` | Normal | 撤銷 Stage Hunk |
| `<leader>hp` | Normal | 預覽 Hunk |
| `<leader>hx` | Normal | 切換顯示已刪除的行 |
| `<leader>hw` | Normal | 切換 Word Diff |

### Blame / Diff

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>hb` | 顯示目前行的完整 Blame |
| `<leader>hB` | 切換行尾 Blame 顯示 |
| `<leader>hd` | Diff 目前檔案（與 index 比較） |
| `<leader>hD` | Diff 目前檔案（與上一個 commit 比較） |

### Text Object

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `ih` | Operator / Visual | 選取整個 Hunk |

---

## 九、Trouble — 診斷面板

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>xx` | 切換全專案診斷面板 |
| `<leader>xX` | 切換目前 Buffer 診斷面板 |
| `<leader>xs` | 切換 Symbols 面板 |
| `<leader>xl` | 切換 LSP 面板（右側） |
| `<leader>xL` | 切換 Location List |
| `<leader>xq` | 切換 Quickfix List |

---

## 十、Harpoon — 快速跳轉釘選檔案

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>ha` | 將目前檔案加入 Harpoon 清單 |
| `<leader>hh` | 開啟 Harpoon 選單 |
| `Ctrl+1` | 跳至 Harpoon 第 1 個檔案 |
| `Ctrl+2` | 跳至 Harpoon 第 2 個檔案 |
| `Ctrl+3` | 跳至 Harpoon 第 3 個檔案 |
| `Ctrl+4` | 跳至 Harpoon 第 4 個檔案 |

---

## 十一、nvim-surround — 括號 / 引號包覆

| 操作 | 說明 | 範例 |
|------|------|------|
| `ys{motion}{char}` | 為 motion 範圍加上包覆 | `ysiw"` → 為單字加雙引號 |
| `ds{char}` | 刪除包覆 | `ds"` → 刪除雙引號 |
| `cs{old}{new}` | 替換包覆 | `cs"'` → 雙引號換單引號 |
| `S{char}` | Visual 模式下為選取範圍加包覆 | 選取後按 `S(` |

---

## 十二、mini.nvim 工具集

### mini.comment — 快速註解

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `gcc` | Normal | 註解 / 取消註解目前行 |
| `gc{motion}` | Normal | 註解 motion 範圍（如 `gcip` 註解整段） |
| `gc` | Visual | 註解 / 取消註解選取範圍 |

### mini.ai — 增強 Text Objects

| Text Object | 說明 |
|-------------|------|
| `af` / `if` | 整個 function / function 內部 |
| `ac` / `ic` | 整個 class / class 內部 |
| `a"` / `i"` | 含引號的字串 / 引號內的字串 |
| `an(` / `in(` | 下一個括號（不需游標在內） |

### mini.pairs — 自動括號

輸入 `(`、`{`、`"`、`'` 等會自動補上對應的右括號。在已有的右括號上輸入會直接跳過。

---

## 十三、vim-illuminate — 相同字詞高亮與跳躍

| 快捷鍵 | 說明 |
|--------|------|
| `]]` | 跳至下一個相同字詞 |
| `[[` | 跳至上一個相同字詞 |

---

## 十四、Java 專用 (nvim-java)

以下快捷鍵僅在 Java 檔案中有效。

### 重構

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>jv` | 提取變數 (Extract Variable) |
| `<leader>jV` | 提取變數 — 所有出現處 |
| `<leader>jc` | 提取常數 (Extract Constant) |
| `<leader>jm` | 提取方法 (Extract Method) |
| `<leader>jf` | 提取欄位 (Extract Field) |

### 測試

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>jt` | 執行目前方法的測試 |
| `<leader>jT` | 執行目前類別的測試 |
| `<leader>jta` | 執行所有測試 |
| `<leader>jtv` | 查看上一次測試報告 |

### 除錯

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>jdt` | Debug 目前方法的測試 |
| `<leader>jdT` | Debug 目前類別的測試 |

### 執行 / 其他

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>jr` | 執行 Main |
| `<leader>jx` | 停止 Main |
| `<leader>jl` | 切換 Log 顯示 |
| `<leader>jp` | 開啟 Profiles UI |
| `<leader>js` | 切換 JDK Runtime |

---

## 十五、程式碼折疊 (Treesitter)

使用 Treesitter 表達式進行折疊，預設全部展開。

| 快捷鍵 | 說明 |
|--------|------|
| `zc` | 折疊目前區塊 |
| `zo` | 展開目前區塊 |
| `za` | 切換折疊 / 展開 |
| `zM` | 折疊全部 |
| `zR` | 展開全部 |

---

## 十六、Which-Key 分組說明

按下 `<leader>` 後等待 500ms，會彈出 Which-Key 提示面板，顯示所有可用的後續按鍵。

| 前綴 | 分組 |
|------|------|
| `<leader>s` | 搜尋 (Search) |
| `<leader>h` | Git Hunk |
| `<leader>g` | Git |
| `<leader>d` | DAP Debug |
| `<leader>j` | Java |
| `<leader>jt` | Java 測試 |
| `<leader>jd` | Java 除錯 |
| `<leader>x` | Trouble / 診斷 |
| `<leader>f` | 格式化 |
| `<leader>e` | 檔案總管 |
| `g` | 跳轉 (Goto) |
| `z` | 折疊 (Fold) |
| `]` | 下一個 (Next) |
| `[` | 上一個 (Prev) |

---

## 十七、基本設定摘要

| 設定 | 值 | 說明 |
|------|-----|------|
| 行號 | 相對行號 | `number` + `relativenumber` |
| 剪貼簿 | 系統同步 | `unnamedplus` |
| Tab 寬度 | 2 空格 | `tabstop=2`, `shiftwidth=2` |
| 搜尋 | 智慧大小寫 | `ignorecase` + `smartcase` |
| 視窗分割 | 右方 / 下方 | `splitright` + `splitbelow` |
| 游標行 | 高亮 | `cursorline = true` |
| 捲動邊距 | 10 行 | `scrolloff = 10` |
| 不可見字元 | 顯示 | Tab → `» `, 尾空格 → `·` |
