return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		keys = {
			-- JetBrains 習慣：<leader>e 開關 Project 面板
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neo-tree Toggle" },
			-- 在目前檔案位置開啟
			{ "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Neo-tree Reveal" },
			-- Git status 視窗
			{ "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Neo-tree Git Status" },
		},
		opts = {
			close_if_last_window = true, -- 只剩 neo-tree 時自動關閉
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- 開啟檔案時不佔用這些視窗
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" },

			default_component_configs = {
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
					default = "*",
				},
				modified = {
					symbol = "● ",
				},
				git_status = {
					symbols = {
						added = "",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},

			window = {
				position = "left",
				width = 35,
				mappings = {
					["<space>"] = "toggle_node",
					["<cr>"] = "open",
					["l"] = "open", -- vim 風格，右鍵開啟
					["h"] = "close_node", -- vim 風格，左鍵關閉
					["v"] = "open_vsplit", -- 垂直分割開啟
					["s"] = "open_split", -- 水平分割開啟
					["t"] = "open_tabnew", -- 新 tab 開啟
					["P"] = { "toggle_preview", config = { use_float = true } },
					["a"] = { "add", config = { show_path = "relative" } },
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["H"] = "toggle_hidden", -- 顯示/隱藏隱藏檔
					["/"] = "fuzzy_finder",
					["<bs>"] = "navigate_up", -- 返回上層目錄
					["."] = "set_root", -- 設定此目錄為根目錄
				},
			},

			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = false, -- 顯示 .env 等隱藏檔
					hide_gitignored = false,
					hide_by_name = {
						"node_modules",
						".DS_Store",
					},
					never_show = {
						".DS_Store",
					},
				},
				follow_current_file = {
					enabled = true, -- 自動追蹤目前開啟的檔案
					leave_dirs_open = false,
				},
				group_empty_dirs = true, -- 空目錄合併顯示
				use_libuv_file_watcher = true, -- 自動偵測檔案變更，不需手動 refresh
				hijack_netrw_behavior = "open_default",
			},

			buffers = {
				follow_current_file = {
					enabled = true,
				},
			},

			git_status = {
				window = {
					position = "float",
				},
			},
		},
	},
}
