-- For navigating to frequented buffers quickly
---@type LazySpec
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>a",
			function()
				require("harpoon"):list():add()
			end,
			desc = "Add To Harpoon List",
		},
		{
			"<C-e>",
			function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end,
			desc = "Open Harpoon List",
		},
		{
			"<C-h>a",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Go to Mark 1",
		},
		{
			"<C-h>s",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Go to Mark 2",
		},
		{
			"<C-h>d",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Go to Mark 3",
		},
		{
			"<C-h>f",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Go to Mark 4",
		},
		{
			"<C-h>g",
			function()
				require("harpoon"):list():select(5)
			end,
			desc = "Go to Mark 4",
		},
	},
}
