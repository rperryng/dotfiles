#Requires AutoHotkey v2.0
#Include logger.ahk

; Create a logger instance for this file
global l := Logger("recursive-binder")

; Global variables for the recursive binder
global RecursiveBinder := {
    isActive: false,          ; Whether we're currently capturing a sequence
    currentSequence: "",      ; The current sequence being built
    currentLeader: "",        ; The current leader key being used
    sequences: Map(),         ; Map of leader keys to their sequence maps
    maxSequenceLength: 3      ; Maximum length of a sequence (including leader)
}

; Helper function to check if a key is alphabetic
IsAlphabetic(key) {
    l.Debug("IsAlphabetic called with key: " key)
    keyCode := Ord(key)
    return (keyCode >= Ord("a") && keyCode <= Ord("z")) || (keyCode >= Ord("A") && keyCode <= Ord("Z"))
}

; Helper function to normalize key to lowercase
NormalizeKey(key) {
    l.Debug("NormalizeKey called with key: " key)
    return StrLower(key)
}

; Function to add a sequence binding
AddSequence(leaderKey, sequence, action) {
    l.Debug("Adding sequence: " sequence " for leader: " leaderKey)
    if !RecursiveBinder.sequences.Has(leaderKey) {
        RecursiveBinder.sequences.Set(leaderKey, Map())
    }
    RecursiveBinder.sequences.Get(leaderKey).Set(sequence, action)
}

; Function to handle key press events
HandleKeyPress(key) {
    l.Debug("HandleKeyPress called with key: " key)
    l.Debug("RecursiveBinder.isActive: " RecursiveBinder.isActive)
    l.Debug("RecursiveBinder.currentLeader: " RecursiveBinder.currentLeader)

    if !RecursiveBinder.isActive {
        l.Debug("Binder not active, returning false")
        return false
    }

    if !IsAlphabetic(key) {
        l.Debug("Key not alphabetic, returning false")
        return false
    }

    normalizedKey := NormalizeKey(key)
    RecursiveBinder.currentSequence .= normalizedKey
    l.Debug("Current sequence updated to: " RecursiveBinder.currentSequence)

    ; Check if we have a matching sequence for the current leader
    leaderSequences := RecursiveBinder.sequences.Get(RecursiveBinder.currentLeader)
    if leaderSequences.Has(RecursiveBinder.currentSequence) {
        l.Debug("Found matching sequence: " RecursiveBinder.currentSequence)
        action := leaderSequences.Get(RecursiveBinder.currentSequence)
        action()
        ResetBinder()
        return true
    }

    ; Check if we've exceeded max sequence length
    if StrLen(RecursiveBinder.currentSequence) >= RecursiveBinder.maxSequenceLength {
        l.Debug("Max sequence length reached, resetting")
        ResetBinder()
    }

    return true
}

; Function to reset the binder state
ResetBinder() {
    l.Debug("Resetting binder state")
    RecursiveBinder.isActive := false
    RecursiveBinder.currentSequence := ""
    RecursiveBinder.currentLeader := ""
}

; Function to start sequence capture
StartSequence(leaderKey) {
    l.Debug("Starting sequence capture with leader: " leaderKey)
    ; If we're already in a sequence, just reset the current sequence
    if RecursiveBinder.isActive {
        RecursiveBinder.currentSequence := ""
        RecursiveBinder.currentLeader := leaderKey
        l.Debug("Reset existing sequence and updated leader to: " leaderKey)
    } else {
        RecursiveBinder.isActive := true
        RecursiveBinder.currentSequence := ""
        RecursiveBinder.currentLeader := leaderKey
        l.Debug("Started new sequence with leader: " leaderKey)
    }
}

; Function to create a hotkey handler for a specific key
CreateKeyHandler(key) {
    l.Debug("Creating handler for key: " key)
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
    ; Clear log file on script start

    ; Define hotkeys for all alphabetic keys
    l.Info("Setting up alphabetic key hotkeys")
    for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] {
        l.Debug("Setting up hotkey for: " key)
        handler := CreateKeyHandler(key)
        HotIf IsSequenceActive
        Hotkey(key, handler)
    }

    ; ESC key to cancel sequence
    l.Debug("Setting up ESC hotkey")
    HotIf IsSequenceActive
    Hotkey("Escape", (*) => ResetBinder())

    l.Info("Recursive binder initialization complete")
}

; Function to set up a recursive binding with a leader key
RecursiveBind(leaderKey, sequence, action) {
    l.Info("Setting up recursive binding for leader: " leaderKey)

    ; Create a handler for this specific leader key
    leaderHandler := (*) => StartSequence(leaderKey)

    ; Set up the hotkey for this leader - now always active
    l.Debug("Setting up leader key hotkey: " leaderKey)
    HotIf
    Hotkey(leaderKey, leaderHandler)

    ; Add the sequence binding
    AddSequence(leaderKey, sequence, action)
}
