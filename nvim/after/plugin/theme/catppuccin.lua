local catppuccin = require("catppuccin")

-- TODO: Figure out an easy way to toggle this.
catppuccin.setup(
-- Pure Black BG
	{
		flavour = "mocha",
		transparent_background = false,
		color_overrides = {
			mocha = {
				base = "#000000",
				mantle = "#000000",
				crust = "#000000"
			}
		}
	}
-- Macchiato, transparent background.
--	{
--		flavour = "macchiato",
--		transparent_background = true,
--	}
)
-- vim.cmd.colorscheme "catppuccin-mocha"
