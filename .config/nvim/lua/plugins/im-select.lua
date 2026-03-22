return {
	{
		"keaising/im-select.nvim",
		event = "VeryLazy",
		config = function()
			require("im_select").setup({
				-- Normal mode 時自動切回英文
				default_im_select = "com.apple.keylayout.ABC",
				default_command = "macism",
				-- 進入 Insert mode 時自動還原上次的輸入法
				set_previous_events = { "InsertEnter" },
			})
		end,
	},
}
