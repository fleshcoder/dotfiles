return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts = {
		-- ───── Keymap ─────
		keymap = {
			preset = "default",
			-- 跟 JetBrains 類似的操作習慣
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-e>"] = { "cancel" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-b>"] = { "scroll_documentation_up" },
			["<C-f>"] = { "scroll_documentation_down" },
		},
		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},
		-- ───── Completion ─────
		completion = {
			trigger = {
				prefetch_on_insert = true,
				show_on_keyword = true,
				show_on_trigger_character = true,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
			accept = {
				auto_brackets = {
					enabled = true,
					-- tsx/jsx/vue 不自動加括號，避免衝突
					kind_resolution = {
						blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
					},
				},
			},
			menu = {
				border = "rounded",
				draw = {
					-- 顯示 icon、label、來源名稱
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
				},
			},
			documentation = {
				auto_show = true, -- 自動顯示文件視窗
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
				},
			},
			ghost_text = {
				enabled = true, -- 像 Copilot 那樣的灰色預覽
			},
		},

		-- ───── Signature Help ─────
		signature = {
			enabled = true, -- 顯示函式簽名
			window = {
				border = "rounded",
			},
		},

		-- ───── Sources ─────
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- ───── Fuzzy ─────
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			frecency = {
				enabled = true, -- 取代舊的 use_frecency = true
			},
			use_proximity = true, -- 附近出現過的優先
		},
	},
}
