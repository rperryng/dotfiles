-- Fix entrypoint
hs.configdir = os.getenv('HOME') .. '/.config/hammerspoon'

-- Load the spoon install manager
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

-- Global hyper key
local hyper = {'ctrl', 'alt', 'shift', 'cmd'}
local meh = {'ctrl', 'alt', 'shift'}

-- Reload configuration hotkey
spoon.SpoonInstall:andUse('ReloadConfiguration', {
  watch_paths = os.getenv('HOME') .. '/.config/hammerspoon/',
  hotkeys = {
    reloadConfiguration = {hyper, 'r'}
  },
  start = true
})

-- Curried function utils
local function launchById(id)
  return function()
    hs.application.launchOrFocusByBundleID(id)
  end
end
local function openWithFinder(path)
  return function()
    os.execute('open ' .. path)
    hs.application.launchOrFocus('Finder')
  end
end

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
  [singleKey('1', '1Password')] = launchById('com.1password.1password'),
  [singleKey('f', 'Firefox')] = launchById('org.mozilla.firefoxdeveloperedition'),
  [singleKey('s', 'Spotify')] = launchById('com.spotify.client'),
  [singleKey('t', 'Terminal')] = launchById('com.mitchellh.ghostty'),
  [singleKey('c', 'Slack')] = launchById('com.tinyspeck.slackmacgap'),
  [singleKey('m', 'Telegram')] = launchById('com.tdesktop.Telegram'),
  [singleKey('n', 'Notion')] = launchById('notion.id'),
  [singleKey('e', 'Finder')] = launchById('com.apple.finder'),
  [singleKey('p', 'Tuple')] = launchById('app.tuple.app'),
  [singleKey('g', 'Godot')] = launchById('org.godotengine.godot'),
  [singleKey('x', 'Cursor')] = launchById('com.todesktop.230313mzl4w4u92'),
  [singleKey('v', 'VSCode')] = launchById('com.microsoft.VSCode'),
  [singleKey('h', 'Google Meet')] = openWithFinder('~/Applications/Chrome Apps.localized/Google Meet.app')
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
