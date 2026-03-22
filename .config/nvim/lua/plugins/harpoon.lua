return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			local map = vim.keymap.set

			-- 新增目前檔案到 harpoon 清單
			map("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "Harpoon Add" })
			-- 開啟 harpoon 選單
			map("n", "<leader>hh", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon Menu" })

			-- 直接跳到第 1-4 個釘選的檔案
			map("n", "<C-1>", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon File 1" })
			map("n", "<C-2>", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon File 2" })
			map("n", "<C-3>", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon File 3" })
			map("n", "<C-4>", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon File 4" })
		end,
	},
}
