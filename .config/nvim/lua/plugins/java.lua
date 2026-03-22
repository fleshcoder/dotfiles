return {
	{
		"nvim-java/nvim-java",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"mfussenegger/nvim-dap",
		},
		ft = { "java" }, -- 只在開 Java 檔案時才載入
		config = function()
			require("java").setup({
				jdk = {
					auto_install = true,
					version = "17",
				},
				spring_boot_tools = { enable = true },
			})

			vim.lsp.enable("jdtls")

			-- Java 專用 keymaps，只在 Java 檔案內有效
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = true, desc = "Java: " .. desc })
					end

					-- Refactor
					map("<leader>jv", "<cmd>lua require('java').refactor.extract_variable()<cr>", "Extract Variable")
					map(
						"<leader>jV",
						"<cmd>lua require('java').refactor.extract_variable_all_occurrence()<cr>",
						"Extract Variable (All)"
					)
					map("<leader>jc", "<cmd>lua require('java').refactor.extract_constant()<cr>", "Extract Constant")
					map("<leader>jm", "<cmd>lua require('java').refactor.extract_method()<cr>", "Extract Method")
					map("<leader>jf", "<cmd>lua require('java').refactor.extract_field()<cr>", "Extract Field")

					-- Test
					map("<leader>jt", "<cmd>JavaTestRunCurrentMethod<cr>", "Test Method")
					map("<leader>jT", "<cmd>JavaTestRunCurrentClass<cr>", "Test Class")
					map("<leader>jta", "<cmd>JavaTestRunAllTests<cr>", "Test All")
					map("<leader>jtv", "<cmd>JavaTestViewLastReport<cr>", "View Test Report")

					-- Debug
					map("<leader>jdt", "<cmd>JavaTestDebugCurrentMethod<cr>", "Debug Test Method")
					map("<leader>jdT", "<cmd>JavaTestDebugCurrentClass<cr>", "Debug Test Class")

					-- Runner
					map("<leader>jr", "<cmd>JavaRunnerRunMain<cr>", "Run Main")
					map("<leader>jx", "<cmd>JavaRunnerStopMain<cr>", "Stop Main")
					map("<leader>jl", "<cmd>JavaRunnerToggleLogs<cr>", "Toggle Logs")

					-- Misc
					map("<leader>jp", "<cmd>JavaProfile<cr>", "Profiles UI")
					map("<leader>js", "<cmd>JavaSettingsChangeRuntime<cr>", "Change JDK Runtime")
				end,
			})
		end,
	},
}
