vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Use Packer
	use 'wbthomason/packer.nvim'
	-- Use Telescope For Fuzzy Finding (:
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	-- Set Theme (Choosing flavor in catppuccin.lua)
	use { "catppuccin/nvim", as = "catppuccin"}
end)
