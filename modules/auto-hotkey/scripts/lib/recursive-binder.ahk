#Requires AutoHotkey v2.0
#Include logger.ahk

; Get a logger instance for this file
recursiveBinderLogger := Logger.GetLogger("recursive-binder")

; Global variables for the recursive binder
global RecursiveBinder := {
    isActive: false,          ; Whether we're currently capturing a sequence
    currentSequence: "",      ; The current sequence being built
    currentLeader: "",        ; The current leader key being used
    sequences: Map(),         ; Map of leader keys to their sequence maps
    maxSequenceLength: 3,     ; Maximum length of a sequence (including leader)
    popupGui: "",            ; GUI object for showing available keys
    popupText: ""            ; Text control for the popup
}

; Helper function to check if a key is alphabetic
IsAlphabetic(key) {
    recursiveBinderLogger.Debug("IsAlphabetic called with key: " key)
    keyCode := Ord(key)
    return (keyCode >= Ord("a") && keyCode <= Ord("z")) || (keyCode >= Ord("A") && keyCode <= Ord("Z"))
}

; Helper function to normalize key to lowercase
NormalizeKey(key) {
    recursiveBinderLogger.Debug("NormalizeKey called with key: " key)
    return StrLower(key)
}

; Function to create and show the popup window
ShowAvailableKeys(availableKeys) {
    recursiveBinderLogger.Debug("Showing available keys: " availableKeys)

    ; Create GUI if it doesn't exist
    if !RecursiveBinder.popupGui {
        RecursiveBinder.popupGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
        RecursiveBinder.popupGui.BackColor := "000000"
        RecursiveBinder.popupGui.SetFont("s12", "Consolas")
        RecursiveBinder.popupText := RecursiveBinder.popupGui.Add("Text", "x10 y5 w180 h20 Center cFFFFFF", "")
    }

    ; Update text and show window
    RecursiveBinder.popupText.Value := availableKeys
    RecursiveBinder.popupGui.Show("w200 h30 NoActivate")

    ; Position window at bottom of screen
    screenWidth := A_ScreenWidth
    RecursiveBinder.popupGui.Move(screenWidth/2 - 100, A_ScreenHeight - 100)
}

; Function to hide the popup window
HideAvailableKeys() {
    recursiveBinderLogger.Debug("Hiding available keys popup")
    if RecursiveBinder.popupGui {
        RecursiveBinder.popupGui.Hide()
    }
}

; Function to get available next keys for current sequence
GetAvailableNextKeys() {
    if !RecursiveBinder.isActive || !RecursiveBinder.currentLeader {
        return ""
    }

    leaderSequences := RecursiveBinder.sequences.Get(RecursiveBinder.currentLeader)
    if !leaderSequences {
        return ""
    }

    availableKeys := ""
    for sequence, _ in leaderSequences {
        if SubStr(sequence, 1, StrLen(RecursiveBinder.currentSequence)) = RecursiveBinder.currentSequence {
            nextKey := SubStr(sequence, StrLen(RecursiveBinder.currentSequence) + 1, 1)
            if nextKey {
                availableKeys .= nextKey " "
            }
        }
    }

    return Trim(availableKeys)
}

; Function to add a sequence binding
AddSequence(leaderKey, sequence, action) {
    recursiveBinderLogger.Debug("Adding sequence: " sequence " for leader: " leaderKey)
    if !RecursiveBinder.sequences.Has(leaderKey) {
        RecursiveBinder.sequences.Set(leaderKey, Map())
    }
    RecursiveBinder.sequences.Get(leaderKey).Set(sequence, action)
}

; Function to handle key press events
HandleKeyPress(key) {
    recursiveBinderLogger.Debug("HandleKeyPress called with key: " key)
    recursiveBinderLogger.Debug("RecursiveBinder.isActive: " RecursiveBinder.isActive)
    recursiveBinderLogger.Debug("RecursiveBinder.currentLeader: " RecursiveBinder.currentLeader)

    if !RecursiveBinder.isActive {
        recursiveBinderLogger.Debug("Binder not active, returning false")
        return false
    }

    if !IsAlphabetic(key) {
        recursiveBinderLogger.Debug("Key not alphabetic, returning false")
        return false
    }

    normalizedKey := NormalizeKey(key)
    RecursiveBinder.currentSequence .= normalizedKey
    recursiveBinderLogger.Debug("Current sequence updated to: " RecursiveBinder.currentSequence)

    ; Update available keys display
    availableKeys := GetAvailableNextKeys()
    if availableKeys {
        ShowAvailableKeys(availableKeys)
    } else {
        HideAvailableKeys()
    }

    ; Check if we have a matching sequence for the current leader
    leaderSequences := RecursiveBinder.sequences.Get(RecursiveBinder.currentLeader)
    if leaderSequences.Has(RecursiveBinder.currentSequence) {
        recursiveBinderLogger.Debug("Found matching sequence: " RecursiveBinder.currentSequence)
        action := leaderSequences.Get(RecursiveBinder.currentSequence)
        action()
        ResetBinder()
        return true
    }

    ; Check if we've exceeded max sequence length
    if StrLen(RecursiveBinder.currentSequence) >= RecursiveBinder.maxSequenceLength {
        recursiveBinderLogger.Debug("Max sequence length reached, resetting")
        ResetBinder()
    }

    return true
}

; Function to reset the binder state
ResetBinder() {
    recursiveBinderLogger.Debug("Resetting binder state")
    RecursiveBinder.isActive := false
    RecursiveBinder.currentSequence := ""
    RecursiveBinder.currentLeader := ""
    HideAvailableKeys()
}

; Function to start sequence capture
StartSequence(leaderKey) {
    recursiveBinderLogger.Debug("Starting sequence capture with leader: " leaderKey)
    ; If we're already in a sequence, just reset the current sequence
    if RecursiveBinder.isActive {
        RecursiveBinder.currentSequence := ""
        RecursiveBinder.currentLeader := leaderKey
        recursiveBinderLogger.Debug("Reset existing sequence and updated leader to: " leaderKey)
    } else {
        RecursiveBinder.isActive := true
        RecursiveBinder.currentSequence := ""
        RecursiveBinder.currentLeader := leaderKey
        recursiveBinderLogger.Debug("Started new sequence with leader: " leaderKey)
    }

    ; Show initial available keys
    availableKeys := GetAvailableNextKeys()
    if availableKeys {
        ShowAvailableKeys(availableKeys)
    }
}

; Function to create a hotkey handler for a specific key
CreateKeyHandler(key) {
    recursiveBinderLogger.Debug("Creating handler for key: " key)
    return (*) => HandleKeyPress(key)
}

; Function to check if sequence mode is active
IsSequenceActive(*) {
    return RecursiveBinder.isActive
}

; Function to check if sequence mode is inactive
IsSequenceInactive(*) {
    return !RecursiveBinder.isActive
}

; Function to initialize the recursive binder
InitRecursiveBinder() {
    ; Define hotkeys for all alphabetic keys
    recursiveBinderLogger.Info("Setting up alphabetic key hotkeys")
    for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] {
        recursiveBinderLogger.Debug("Setting up hotkey for: " key)
        handler := CreateKeyHandler(key)
        HotIf IsSequenceActive
        Hotkey(key, handler)
    }

    ; ESC key to cancel sequence
    recursiveBinderLogger.Debug("Setting up ESC hotkey")
    HotIf IsSequenceActive
    Hotkey("Escape", (*) => ResetBinder())

    recursiveBinderLogger.Info("Recursive binder initialization complete")
}

; Function to set up a recursive binding with a leader key
RecursiveBind(leaderKey, sequence, action) {
    recursiveBinderLogger.Info("Setting up recursive binding for leader: " leaderKey)

    ; Create a handler for this specific leader key
    leaderHandler := (*) => StartSequence(leaderKey)

    ; Set up the hotkey for this leader - now always active
    recursiveBinderLogger.Debug("Setting up leader key hotkey: " leaderKey)
    HotIf
    Hotkey(leaderKey, leaderHandler)

    ; Add the sequence binding
    AddSequence(leaderKey, sequence, action)
}
