local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'ctop',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'gf.c.googlers.com',
    -- The username to use on the remote host
    username = 'gabrielford',
  },
}

config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.adjust_window_size_when_changing_font_size = true

-- and finally, return the configuration to wezterm
return config
