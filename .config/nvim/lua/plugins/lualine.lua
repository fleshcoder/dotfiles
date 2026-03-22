return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto", -- 自動配合 kanagawa
				globalstatus = true, -- 所有視窗共用一條 statusline（比較乾淨）
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "neo-tree", "lazy", "mason" },
				},
			},

			sections = {
				-- 左側
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end, -- 只顯示第一個字母：N/I/V
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1, -- 0 = 只檔名, 1 = 相對路徑, 2 = 絕對路徑
						symbols = {
							modified = "●",
							readonly = "",
							unnamed = "[No Name]",
						},
					},
				},

				-- 右側
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = "󰌵 ",
						},
					},
					{
						-- 顯示目前 LSP server 名稱
						function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if #clients == 0 then
								return ""
							end
							local names = {}
							for _, c in ipairs(clients) do
								table.insert(names, c.name)
							end
							return "󰒋 " .. table.concat(names, ", ")
						end,
					},
					{ "filetype", icon_only = false },
				},
				lualine_y = {
					{ "encoding" },
					{
						"fileformat",
						symbols = {
							unix = "LF",
							dos = "CRLF",
							mac = "CR",
						},
					},
				},
				lualine_z = {
					{ "location" }, -- 行號:欄號
					{ "progress" }, -- 百分比
				},
			},

			-- 非焦點視窗的 statusline（簡化版）
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			-- 不顯示 tabline（我們用 telescope buffers 管理）
			tabline = {},
			extensions = { "neo-tree", "lazy", "mason", "trouble" },
		},
	},
}
