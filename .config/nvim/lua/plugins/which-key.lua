return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern", -- classic / modern / helix 三種風格
			delay = 500, -- 按下 leader 後多久彈出（ms）
			icons = {
				mappings = true,
				keys = {
					Up = " ",
					Down = " ",
					Left = " ",
					Right = " ",
					C = "󰘴 ",
					S = "󰘶 ",
					CR = "󰌑 ",
					Esc = "󱊷 ",
					Space = "󱁐 ",
					Tab = "󰌒 ",
				},
			},
			spec = {
				-- 定義 group 名稱，讓彈出視窗顯示更清楚的分類
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>d", group = "[D]AP Debug" },
				{ "<leader>h", group = "[H]unk (Git)" },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>j", group = "[J]ava" },
				{ "<leader>jt", group = "[J]ava [T]est" },
				{ "<leader>jd", group = "[J]ava [D]ebug" },
				{ "<leader>x", group = "Trouble / Diagnostics" },
				{ "<leader>f", group = "[F]ormat" },
				{ "<leader>e", group = "[E]xplorer" },
				{ "g", group = "Goto" },
				{ "z", group = "Fold" },
				{ "]", group = "Next" },
				{ "[", group = "Prev" },
			},
		},
	},
}
