vim.g.mapleader = " " -- 設定主要按鍵前綴為空白鍵
vim.g.maplocalleader = " " -- 設定區域按鍵前綴為空白鍵
-- 按鍵映射
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- 按 Esc 清除搜尋高亮
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" }) -- 開啟診斷錯誤列表
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- 連按兩次 Esc 退出終端模式
vim.keymap.set("i", "jj", "<Esc>") -- File Exploer
