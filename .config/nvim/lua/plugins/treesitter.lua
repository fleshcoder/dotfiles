return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- ← 新版
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"lua",
				"vim",
				"vimdoc",
				"go",
				"gomod",
				"gosum",
				"javascript",
				"typescript",
				"jsx",
				"tsx",
				"vue",
				"java",
				"html",
				"css",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"bash",
				"gitignore",
				"sql",
			})

			vim.api.nvim_create_autocmd("FileType", {
				-- 明確列出要啟用 treesitter 的 filetype
				pattern = {
					"lua",
					"vim",
					"go",
					"gomod",
					"gosum",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"vue",
					"java",
					"html",
					"css",
					"json",
					"yaml",
					"markdown",
					"bash",
				},
				callback = function(args)
					vim.treesitter.start()
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
