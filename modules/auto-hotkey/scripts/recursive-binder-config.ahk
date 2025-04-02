#Requires AutoHotkey v2.0
#SingleInstance

; Include the recursive binder library
#Include recursive-binder-lib.ahk

; Initialize the recursive binder
InitRecursiveBinder()

; All sequences begin with the leader key (win+alt+shift+ctrl+w)
AddSequence("wa", () => Run("notepad.exe"))
AddSequence("wb", () => Run("firefox.exe"))
AddSequence("y", () => Run("calc.exe"))
