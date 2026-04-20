For switching between wallust and wallrust, you are mostly concerned with the following files:

1. waypaper/config.ini - change the post_config field from using wallust (i.e. `post_command = wallust run "$wallpaper"`) to wallrust (`post_command = wallrust "$wallpaper" -v`), or vice versa
   Note: It's important that you close waypaper before you do this, because if you have waypaper open _before_ you save your configurations, your saved configurations will be overwritten with the old one.
2. For wayle you don't really need to do much since you're mostly overwriting colors.toml
3. For rio, you change the rio/config.toml's theme field, from "wallust" to "wallrust", or vice versa
