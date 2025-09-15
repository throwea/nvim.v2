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
	},
}
