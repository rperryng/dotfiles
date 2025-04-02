#Requires AutoHotkey v2.0
#SingleInstance Force

; Include the recursive binder library
#Include lib/recursive-binder.ahk
#Include lib/window-utils.ahk

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
RecursiveBind("^+!#d", "c", () => Run("notepad.exe"))
RecursiveBind("^+!#w", "e", () => LaunchAndFocus("C:\Windows\explorer.exe", "explorer.exe", "ahk_class CabinetWClass"))
RecursiveBind("^+!#w", "f", () => LaunchAndFocus("C:\Program Files\Mozilla Firefox\firefox.exe"))
RecursiveBind("^+!#w", "g", () => LaunchAndFocus("C:\Program Files\Godot\Godot_v4.4-stable_mono_win64\Godot_v4.4-stable_mono_win64.exe"))
RecursiveBind("^+!#w", "m", () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Roaming\Telegram Desktop\Telegram.exe", A_UserName)))
RecursiveBind("^+!#w", "p", () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\1Password\app\8\1Password.exe", A_UserName)))
RecursiveBind("^+!#w", "s", () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Roaming\Spotify\Spotify.exe", A_UserName)))
RecursiveBind("^+!#w", "t", () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\Microsoft\WindowsApps\WindowsTerminal.exe", A_UserName)))
RecursiveBind("^+!#w", "v", () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\Programs\Microsoft VS Code\Code.exe", A_UserName)))
RecursiveBind("^+!#w", "x", () => LaunchAndFocus(Format("C:\Users\{1}\AppData\Local\Programs\cursor\Cursor.exe", A_UserName)))
RecursiveBind("^+!#w", "z", () => LaunchAndFocus("C:\Program Files (x86)\Steam\steam.exe"))

; reload config
#+!r:: Reload()

; iterate through sequences and log them
for leaderKey, sequences in RecursiveBinder.sequences {
    Logger.Info("Leader key: " leaderKey)
    for sequence, action in sequences {
        Logger.Info("Sequence: " sequence)
    }
}

; setup hyper key mappings for all letters to avoid microsoft's default mappings
for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] {
    ; check if this key is already bound as a leader key
    leaderKeyCandidate := Format("^+!#{1}", key)
    isLeaderKey := false
    for leaderKey, _ in RecursiveBinder.sequences {
        if (leaderKey == leaderKeyCandidate) {
            Logger.Info("Leader key " leaderKeyCandidate " already exists, skipping")
            isLeaderKey := true
            break
        }
    }

    if (!isLeaderKey) {
        Logger.Info("Mapping " leaderKeyCandidate " to no-op")
        ; block the key with a dummy function
        Hotkey(leaderKeyCandidate, (*) => {})
    }
}
