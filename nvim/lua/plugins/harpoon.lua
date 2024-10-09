-- For navigating to frequented buffers quickly
---@type LazySpec
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>a", function() require('harpoon'):list():add() end,                                    desc = "Add To Harpoon List" },
		{ "<C-e>",     function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = "Open Harpoon List" },
		{ "<A-a>",     function() require('harpoon'):list():select(1) end,                                desc = "Go to Mark 1" },
		{ "<A-s>",     function() require('harpoon'):list():select(2) end,                                desc = "Go to Mark 2" },
		{ "<A-d>",     function() require('harpoon'):list():select(3) end,                                desc = "Go to Mark 3" },
		{ "<A-f>",     function() require('harpoon'):list():select(4) end,                                desc = "Go to Mark 4" },
		{ "<A-g>",     function() require('harpoon'):list():select(4) end,                                desc = "Go to Mark 4" },
	}
}
