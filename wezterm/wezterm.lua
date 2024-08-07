-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
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

-- and finally, return the configuration to wezterm
return config
