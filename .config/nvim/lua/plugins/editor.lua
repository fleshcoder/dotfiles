return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Trouble Diagnostics",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Trouble Buffer Diagnostics",
			},
			{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble Symbols" },
			{ "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble LSP" },
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Trouble Location List",
			},
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quickfix" },
		},
		opts = {
			modes = {
				diagnostics = {
					auto_close = true, -- 沒有 diagnostics 時自動關閉
				},
			},
		},
	},
	-- ───── nvim-surround：括號引號包覆 ─────
	{
		"kylechui/nvim-surround",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			-- ───── mini.comment：快速註解 ─────
			-- gcc  註解目前行
			-- gc   + motion（gcip 註解整段）
			-- gc   visual mode 下註解選取範圍
			require("mini.comment").setup()

			-- ───── mini.ai：增強 text objects ─────
			-- 原本的 va( vip 等，加上更多：
			-- vaf  整個 function
			-- vac  整個 class
			-- va"  含引號的字串
			-- van( 選下一個 ( 的內容（不需要游標在裡面）
			require("mini.ai").setup({ n_lines = 500 })

			-- ───── mini.pairs：自動補全括號 ─────
			-- 輸入 ( 自動補 )
			-- 輸入 { 自動補 }
			-- 輸入 " 自動補 "
			-- 在已有的 ) 上按 ) 會直接跳過不重複輸入
			require("mini.pairs").setup()
		end,
	},
}
