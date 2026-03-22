return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- 在 hunk 之間跳躍
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next [H]unk")

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev [H]unk")

				-- Hunk 操作
				map("n", "<leader>hs", gs.stage_hunk, "Git [H]unk [S]tage")
				map("n", "<leader>hr", gs.reset_hunk, "Git [H]unk [R]eset")
				map("n", "<leader>hS", gs.stage_buffer, "Git [H]unk Stage Buffer")
				map("n", "<leader>hR", gs.reset_buffer, "Git [H]unk Reset Buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk, "Git [H]unk [U]ndo Stage")
				map("n", "<leader>hp", gs.preview_hunk, "Git [H]unk [P]review")
				map("n", "<leader>hx", gs.toggle_deleted, "Git Toggle Deleted Lines")
				map("n", "<leader>hw", gs.toggle_word_diff, "Git Toggle Word Diff")
				-- Blame
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Git [H]unk [B]lame Line")
				map("n", "<leader>hB", gs.toggle_current_line_blame, "Git Toggle Line [B]lame")

				-- Diff
				map("n", "<leader>hd", gs.diffthis, "Git [H]unk [D]iff")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Git [H]unk Diff ~")

				-- Visual mode：對選取範圍 stage / reset
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Git [H]unk [S]tage (visual)")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Git [H]unk [R]eset (visual)")

				-- Text object：ih = inner hunk
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Git Hunk")
			end,
		},
	},
}
