-- Fix entrypoint
hs.configdir = os.getenv('HOME') .. '/.config/hammerspoon'

-- Load the spoon install manager
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

-- Global hyper ke
local hyper = { 'ctrl', 'alt', 'shift', 'cmd' }
local meh = { 'ctrl', 'alt', 'shift' }

-- Curried launch by app id
local function launchById(id)
  return function()
    hs.application.launchOrFocusByBundleID(id)
  end
end

local function openWithFinder(path)
  return function()
    os.execute('open '..path)
    hs.application.launchOrFocus('Finder')
  end
end

-- Reload config
spoon.SpoonInstall:andUse('ReloadConfiguration', {
  watch_paths = os.getenv('HOME') .. '/.config/hammerspoon/',
  hotkeys = {
    reloadConfiguration = { hyper, 'r' },
  },
  start = true,
})

-- Notification that config was loaded
spoon.SpoonInstall:andUse('FadeLogo', {
  config = {
    image_size = hs.geometry.size({w=75, h=75}),
    run_time = 0.5,
    zoom = false
  },
  start = true
})

spoon.SpoonInstall:andUse('RecursiveBinder');

-- Application hotkeys
hs.hotkey.bind(hyper, '1', launchById('com.1password.1password'))
hs.hotkey.bind(hyper, 'f', launchById('org.mozilla.firefoxdeveloperedition'))
hs.hotkey.bind(hyper, 's', launchById('com.spotify.client'))
hs.hotkey.bind(hyper, 't', launchById('com.mitchellh.ghostty'))
hs.hotkey.bind(hyper, 'c', launchById('com.tinyspeck.slackmacgap'))
hs.hotkey.bind(hyper, 'm', launchById('com.tdesktop.Telegram'))
hs.hotkey.bind(hyper, 'n', launchById('notion.id'))
hs.hotkey.bind(hyper, 'e', launchById('com.apple.finder'))
hs.hotkey.bind(hyper, 'p', launchById('app.tuple.app'))
hs.hotkey.bind(hyper, 'g', launchById('org.godotengine.godot'))
hs.hotkey.bind(hyper, 'x', launchById('com.todesktop.230313mzl4w4u92')) -- cursor
hs.hotkey.bind(hyper, 'v', launchById('com.microsoft.VSCode'))
hs.hotkey.bind(hyper, 'h', openWithFinder('~/Applications/Chrome Apps.localized/Google Meet.app'))
