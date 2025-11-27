from typing import Optional
from qutebrowser.config.configfiles import ConfigAPI

config: Optional[ConfigAPI] = globals().get("config");
assert(config)

config.bind("J", "tab-prev")
config.bind("K", "tab-next")

config.set("colors.webpage.darkmode.enabled", True)

config.load_autoconfig(False)
