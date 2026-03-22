return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		indent = {
			char = "│", -- 縮排線字元
			tab_char = "│",
		},
		scope = {
			enabled = true, -- 高亮目前所在的縮排範圍
			show_start = true,
			show_end = false,
		},
		exclude = {
			filetypes = {
				"help",
				"neo-tree",
				"lazy",
				"mason",
				"dashboard",
				"trouble",
				"markdown",
			},
		},
	},
}
