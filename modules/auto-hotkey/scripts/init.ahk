#Requires AutoHotkey v2.0
#SingleInstance Force

; Include the recursive binder library
#Include lib/recursive-binder.ahk
#Include lib/window-utils.ahk
#Include lib/hyper-key-utils.ahk

; Initialize the recursive binder
InitRecursiveBinder()

; Mask the windows key to disable the start menu
; This workaround still allows the windows key to be used for other mappings.
~LWin:: Send("{Blind}{vk08}")

; Launch Flow Launcher with Windows+Space
#Space:: Run Format("C:\Users\{1}\AppData\Local\FlowLauncher\Flow.Launcher.exe", A_UserName)

; osx "cmd-`" style window switching
#`:: CycleAppWindows(1)
#+`:: CycleAppWindows(-1)

; Sequence-based mappings (vim-style)
RecursiveBind("^+!#t", [
  { key: "a", label: "test (a)", mappings: [
    { key: "n", label: "notepad", callback: () => Run("notepad.exe") },
    { key: "c", label: "calculator", callback: () => Run("calculator.exe") },
  ]},
])

RecursiveBind("^+!#w", [
    { key: "e", label: "explorer", callback: () => LaunchAndFocus("C:\Windows\explorer.exe", "explorer.exe", "ahk_class CabinetWClass") },
    { key: "f", label: "firefox", callback: () => LaunchAndFocus("C:\Program Files\Mozilla Firefox\firefox.exe") },
    { key: "g", label: "godot", callback: () => LaunchAndFocus("C:\Program Files\Godot\Godot_v4.4-stable_mono_win64\Godot_v4.4-stable_mono_win64.exe") },
    { key: "m", label: "telegram", callback: () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Roaming\Telegram Desktop\Telegram.exe", A_UserName)) },
    { key: "p", label: "1password", callback: () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\1Password\app\8\1Password.exe", A_UserName)) },
    { key: "s", label: "spotify", callback: () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Roaming\Spotify\Spotify.exe", A_UserName)) },
    { key: "t", label: "terminal", callback: () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\Microsoft\WindowsApps\WindowsTerminal.exe", A_UserName)) },
    { key: "v", label: "vscode", callback: () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\Programs\Microsoft VS Code\Code.exe", A_UserName)) },
    { key: "x", label: "cursor", callback: () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\Programs\cursor\Cursor.exe", A_UserName)) },
    { key: "z", label: "steam", callback: () => LaunchAndFocus("C:\Program Files (x86)\Steam\steam.exe") }
])

; Remap Windows+Tab to Alt+Tab
#Tab:: {
  Send("{Alt down}{Tab}")
  KeyWait("LWin")
  Send("{Alt up}")
}

; Remap Shift-Windows-Tab to Alt-Shift-Tab
#+Tab:: {
  Send("{Alt down}{Shift down}{Tab}")
  KeyWait("LWin")
  Send("{Alt up}")
}

; reload config
^#+!r:: Reload()

; Create no-op mappings for unused hyper key combinations
HyperKeyUtils.CreateNoOpMappings()
