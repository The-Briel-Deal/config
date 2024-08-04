-- Zen Mode is a plugin to fullscreen one buffer to remove distractions
return {
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>zm", function() require("zen-mode").toggle({ window = { width = .75 } }) end },
	},
}
