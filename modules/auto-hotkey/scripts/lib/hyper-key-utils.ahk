#Requires AutoHotkey v2.0

#Include recursive-binder.ahk
#include "collections.ahk"
#Include logger.ahk

class HyperKeyUtils {
    static CreateNoOpMappings() {
        ; Read init.ahk to find existing hyper key mappings
        initContent := FileRead("init.ahk")
        existingHyperKeys := []

        ; Find all hyper key mappings in init.ahk
        loop parse initContent, "`n", "`r" {
            if (RegExMatch(A_LoopField, "^[\+\^#!]{4}([a-z])", &match)) {
                Logger.Info("Found hyper key mapping in line: " A_LoopField)
                existingHyperKeys.Push(match[1])
            }
        }

        for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
            "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] {
            ; check if this key is already bound as a leader key
            leaderKeyCandidate := Format("^+!#{1}", key)
            isAlreadyBound := false

            ; Check for leader keys in the recursive binder
            for leaderKey, _ in RecursiveBinder.sequences {
                if (leaderKey == leaderKeyCandidate) {
                    Logger.Info("Leader key " leaderKeyCandidate " already exists, skipping")
                    isAlreadyBound := true
                    break
                }
            }

            ; Check for existing hyper key mappings from init.ahk
            if (!isAlreadyBound) {
                if (IsItemInList(key, existingHyperKeys)) {
                    Logger.Info("Hyper key " leaderKeyCandidate " already exists in init.ahk, skipping")
                    isAlreadyBound := true
                    continue
                }
            }

            if (!isAlreadyBound) {
                Logger.Info("Creating no-op mapping for " leaderKeyCandidate)
                Hotkey(leaderKeyCandidate, (*) => {})
            }
        }
    }
}
