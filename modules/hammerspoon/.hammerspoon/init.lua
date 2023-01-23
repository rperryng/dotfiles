-- Load the spoon install manager
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

-- Global hyper key
local hyper = { 'ctrl', 'alt', 'shift', 'cmd' }
local meh = { 'ctrl', 'alt', 'shift' }

-- Window manager
spoon.SpoonInstall:andUse('MiroWindowsManager', {
  -- disable = true,
  config = {
    GRID = windowGrid,
  },
  hotkeys = {
    up = { movekey, 'up' },
    right = { movekey, 'right' },
    down = { movekey, 'down' },
    left = { movekey, 'left' },
    fullscreen = { movekey, 'f' },
  },
})

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

-- Application hotkeys
hs.hotkey.bind(hyper, '1', utils.launchById('com.1password.1password'))
