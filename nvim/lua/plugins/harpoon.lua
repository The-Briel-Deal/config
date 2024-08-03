-- For navigating to frequented buffers quickly
---@type LazySpec
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>a", function() require('harpoon'):list():add() end,                                    desc = "Add To Harpoon List" },
		{ "<C-e>",     function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = "Open Harpoon List" },
		{ "<C-1>",     function() require('harpoon'):list():select(1) end,                                desc = "Go to Mark 1" },
		{ "<C-2>",     function() require('harpoon'):list():select(2) end,                                desc = "Go to Mark 2" },
		{ "<C-3>",     function() require('harpoon'):list():select(3) end,                                desc = "Go to Mark 3" },
		{ "<C-4>",     function() require('harpoon'):list():select(4) end,                                desc = "Go to Mark 4" },
		{ "<C-5>",     function() require('harpoon'):list():select(5) end,                                desc = "Go to Mark 5" },
		{ "<C-6>",     function() require('harpoon'):list():select(6) end,                                desc = "Go to Mark 6" },
		{ "<C-7>",     function() require('harpoon'):list():select(7) end,                                desc = "Go to Mark 7" },
		{ "<C-8>",     function() require('harpoon'):list():select(8) end,                                desc = "Go to Mark 8" },
		{ "<C-9>",     function() require('harpoon'):list():select(9) end,                                desc = "Go to Mark 9" },
		{ "<C-0>",     function() require('harpoon'):list():select(10) end,                               desc = "Go to Mark 10" },

	}
}
