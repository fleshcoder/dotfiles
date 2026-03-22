return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- 只在編輯 Lua 檔案時載入
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"Bilal2453/luvit-meta",
		lazy = true, -- vim.uv 的型別定義
	},
}
