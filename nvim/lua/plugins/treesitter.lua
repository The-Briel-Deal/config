-- Install Treesitter for Syntax Highlighting
return {
	'nvim-treesitter/nvim-treesitter',
	event = "BufEnter",
	run = ':TSUpdate',
	opt = {
		-- A list of parser names, or "all" (the five listed parsers should always be installed)
		ensure_installed = { "python", "javascript", "typescript", "cpp", "c", "lua", "vim", "vimdoc", "query", "bash" },

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = true,

		-- Automatically install missing parsers when entering buffer, uses TS CLI.
		auto_install = true,

		-- Enable Syntax Highlighting Based on Treesitter.
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},

		-- Enable indentation.
		indent = {
			enable = true
		}
	}


}
