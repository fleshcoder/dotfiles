-- 基本設定
vim.g.have_nerd_font = true -- 啟用 Nerd Font 字型支援（用於顯示圖示）

-- 行號設定
vim.o.number = true -- 關閉絕對行號顯示
vim.o.relativenumber = true -- 啟用相對行號（顯示相對於當前行的行數）

-- 剪貼簿設定
vim.schedule(function()
	vim.o.clipboard = "unnamedplus" -- 與系統剪貼簿同步
end)

-- 縮排和檔案設定
vim.o.breakindent = true -- 自動換行時保持縮排
vim.o.undofile = true -- 啟用持久化復原檔案（重新開啟檔案後仍可復原）

-- 搜尋設定
vim.o.ignorecase = true -- 搜尋時忽略大小寫
vim.o.smartcase = true -- 搜尋包含大寫字母時區分大小寫

-- 介面設定
vim.o.signcolumn = "yes" -- 始終顯示符號欄（用於顯示錯誤、警告等）
vim.o.updatetime = 250 -- 更新時間間隔（毫秒）
vim.o.timeoutlen = 300 -- 按鍵組合等待時間（毫秒）

-- 視窗分割設定
vim.o.splitright = true -- 垂直分割視窗時在右側開啟
vim.o.splitbelow = true -- 水平分割視窗時在下方開啟

-- 顯示設定
vim.o.list = true -- 顯示不可見字元
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- 設定不可見字元的顯示方式
vim.o.inccommand = "split" -- 搜尋替換時即時預覽（在分割視窗中顯示）
vim.o.cursorline = true -- 高亮顯示游標所在行
vim.o.scrolloff = 10 -- 游標距離視窗邊緣保持至少10行
vim.o.confirm = true -- 執行危險操作時要求確認

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

-- 用 Treesitter 做程式碼折疊
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false -- 預設展開，不自動折疊
vim.o.foldlevel = 99 -- 需要手動按 zc 才會折疊
