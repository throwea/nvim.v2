return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{
				"github/copilot.vim",
				cmd = "Copilot",
				event = "InsertEnter",
				init = function()
					vim.g.copilot_proxy = "https://proxy.wal-mart.com:9080"
				end
			},
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			-- See Configuration section for options
		},
		keys = {
			{ "<leader>zc", "<cmd>CopilotChat<cr>",        mode = "n", desc = "Open Copilot Chat" },
			{ "<leader>ze", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain Code" },
			{ "<leader>zr", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Review Code" },
			{ "<leader>zf", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Fix Code issues" },
			{ "<leader>zo", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Optimize Code" },
			{ "<leader>zd", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Generate Docs" },
			{ "<leader>zt", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Generate Tests" },
			{ "<leader>zm", "<cmd>CopilotChatExplain<cr>", mode = "n", desc = "Generate Commit Message" },
			{ "<leader>zs", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Generate Commit for Selection" },
		},
	},
}
