-- Fix entrypoint
hs.configdir = os.getenv('HOME') .. '/.config/hammerspoon'

-- Global hyper key
local hyper = {'ctrl', 'alt', 'shift', 'cmd'}
local meh = {'ctrl', 'alt', 'shift'}

-- Load utility modules
local app_utils = require('lib.app-utils')

-- Load the spoon install manager
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

-- Reload configuration hotkey
spoon.SpoonInstall:andUse('ReloadConfiguration', {
  watch_paths = os.getenv('HOME') .. '/.config/hammerspoon/',
  hotkeys = {
    reloadConfiguration = {hyper, 'r'}
  },
  start = true
})

-- Leader key binding
spoon.SpoonInstall:andUse('RecursiveBinder')
spoon.RecursiveBinder.escapeKey = {{}, 'escape'}
spoon.RecursiveBinder.helperFormat = {
  atScreenEdge = 2,
  strokeColor = {
    white = 0,
    alpha = 2
  },
  textFont = 'Courier',
  textSize = 16
}
local singleKey = spoon.RecursiveBinder.singleKey
local keyMap = {
  [singleKey('1', '1Password')] = app_utils.launchById('com.1password.1password'),
  [singleKey('f', 'Firefox')] = app_utils.launchById('org.mozilla.firefoxdeveloperedition'),
  [singleKey('s', 'Spotify')] = app_utils.launchById('com.spotify.client'),
  [singleKey('t', 'Terminal')] = app_utils.launchById('com.mitchellh.ghostty'),
  [singleKey('c', 'Slack')] = app_utils.launchById('com.tinyspeck.slackmacgap'),
  [singleKey('m', 'Telegram')] = app_utils.launchById('com.tdesktop.Telegram'),
  [singleKey('n', 'Notion')] = app_utils.launchById('notion.id'),
  [singleKey('e', 'Finder')] = app_utils.launchById('com.apple.finder'),
  [singleKey('p', 'Tuple')] = app_utils.launchById('app.tuple.app'),
  [singleKey('g', 'Godot')] = app_utils.launchById('org.godotengine.godot'),
  [singleKey('x', 'Cursor')] = app_utils.launchById('com.todesktop.230313mzl4w4u92'),
  [singleKey('v', 'VSCode')] = app_utils.launchById('com.microsoft.VSCode'),
  [singleKey('h', 'Google Meet')] = app_utils.launchByPath('/Applications/Google Meet.app')
}
hs.hotkey.bind(hyper, 'w', spoon.RecursiveBinder.recursiveBind(keyMap, 'App Switcher'))

-- Notification that config was loaded
spoon.SpoonInstall:andUse('FadeLogo', {
  config = {
    image_size = hs.geometry.size({
      w = 75,
      h = 75
    }),
    run_time = 0.5,
    zoom = false
  },
  start = true
})
