-- For finding things 🔭
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fs",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").git_files({ use_file_path = true })
			end,
			desc = "Find Files in Git",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Find Nvim Help Docs",
		},
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({ cwd = "~/.config" })
			end,
			desc = "Find Files in my .config Dir",
		},
		{
			"<leader>fn",
			function()
				require("telescope.builtin").find_files({ cwd = "~/Notes" })
			end,
			desc = "Find Files in my Notes Dir",
		},
		{
			"<leader>fC",
			function()
				require("telescope.builtin").find_files({ cwd = "~/Code" })
			end,
			desc = "Find Files in my Code Dir",
		},
		{
			"<leader>f/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end,
			desc = "Find Line in Current Buffer",
		},
		{
			"<leader>fo",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "Find File in my File History",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find Buffer in open Buffers",
		},
	},
}
