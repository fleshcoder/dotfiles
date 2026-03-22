return {
	"RRethy/vim-illuminate",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		delay = 200,
		large_file_cutoff = 2000,
		large_file_overrides = {
			providers = { "lsp" },
		},
	},
	config = function(_, opts)
		require("illuminate").configure(opts)

		-- 在相同字詞之間跳躍
		vim.keymap.set("n", "]]", function()
			require("illuminate").goto_next_reference()
		end, { desc = "Next Reference" })
		vim.keymap.set("n", "[[", function()
			require("illuminate").goto_prev_reference()
		end, { desc = "Prev Reference" })
	end,
}
