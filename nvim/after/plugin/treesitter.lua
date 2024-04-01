require'nvim-treesitter.configs'.setup {
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

-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Create AutoCMD to open all Folds on Buffer Open
vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"}, {
    command = "normal zR"
})

-- Create AutoCMD to set appropriate tab size
vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"},
    {
	callback = function() 
	    vim.bo.tabstop = 8
	    vim.bo.softtabstop = 4
	    vim.bo.shiftwidth = 4
	    vim.bo.expandtab = false
	end,
    }
)

-- Create AutoCMD to set files in ~/.config/zsh to bash
vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"},
    {
	pattern = "*/zsh/*",
	callback = function() 
	    vim.cmd("set filetype=bash")
	end,
    }
)

