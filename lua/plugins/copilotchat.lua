return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{
				"github/copilot.vim",
				dependencies = { "giuxtaposition/blink-cmp-copilot" },
				cmd = "Copilot",
				event = "InsertEnter",
			},
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		init = function()
			-- Use your corporate proxy for ALL outbound HTTP(S).
			-- Most corporate proxies are plain HTTP on :9080 even for HTTPS tunneling.
			local proxy         = "http://proxy.wal-mart.com:9080"

			-- For the completions plugin (works already, but keep it)
			vim.g.copilot_proxy = proxy

			-- For CopilotChat (curl/plenary)
			vim.env.HTTP_PROXY  = proxy
			vim.env.HTTPS_PROXY = proxy
			vim.env.ALL_PROXY   = proxy

			-- If your org requires bypass for internal hosts, set NO_PROXY
			vim.env.NO_PROXY    = "localhost,127.0.0.1,.walmart.com,.wal-mart.com"

			-- If your company MITM’s TLS with a custom root CA, uncomment & point to it:
			-- vim.env.SSL_CERT_FILE = "/path/to/corp-root-ca.pem"
			-- vim.env.CURL_CA_BUNDLE = "/path/to/corp-root-ca.pem"
		end,
		opts = {
			-- Optional: pin model once models list works
			-- model = "gpt-4o",
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
