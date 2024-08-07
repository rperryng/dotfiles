local wezterm = require('wezterm')
local config = {}

config.color_scheme = 'GruvboxDarkHard'

config.font = wezterm.font('MesloLGM Nerd Font Mono')
-- config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Bold' })

config.enable_tab_bar = false
config.enable_scroll_bar = false

config.window_decorations = 'RESIZE'
config.window_background_image = '/Users/rperryng/Downloads/2vfplourrmn81.png'
config.window_background_opacity = 1.0
config.window_background_image_hsb = {
  brightness = 0.015,
  hue = 1.0,
  saturation = 0.2,
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
