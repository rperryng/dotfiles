#Requires AutoHotkey v2.0

; Logging functionality
global LogFile := A_ScriptDir "\recursive-binder.log"
Log(message) {
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    FileAppend(timestamp " - " message "`n", LogFile)
}

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
    Log("IsAlphabetic called with key: " key)
    keyCode := Ord(key)
    return (keyCode >= Ord("a") && keyCode <= Ord("z")) || (keyCode >= Ord("A") && keyCode <= Ord("Z"))
}

; Helper function to normalize key to lowercase
NormalizeKey(key) {
    Log("NormalizeKey called with key: " key)
    return StrLower(key)
}

; Function to add a sequence binding
AddSequence(leaderKey, sequence, action) {
    Log("Adding sequence: " sequence " for leader: " leaderKey)
    if !RecursiveBinder.sequences.Has(leaderKey) {
        RecursiveBinder.sequences.Set(leaderKey, Map())
    }
    RecursiveBinder.sequences.Get(leaderKey).Set(sequence, action)
}

; Function to handle key press events
HandleKeyPress(key) {
    Log("HandleKeyPress called with key: " key)
    Log("RecursiveBinder.isActive: " RecursiveBinder.isActive)
    Log("RecursiveBinder.currentLeader: " RecursiveBinder.currentLeader)

    if !RecursiveBinder.isActive {
        Log("Binder not active, returning false")
        return false
    }

    if !IsAlphabetic(key) {
        Log("Key not alphabetic, returning false")
        return false
    }

    normalizedKey := NormalizeKey(key)
    RecursiveBinder.currentSequence .= normalizedKey
    Log("Current sequence updated to: " RecursiveBinder.currentSequence)

    ; Check if we have a matching sequence for the current leader
    leaderSequences := RecursiveBinder.sequences.Get(RecursiveBinder.currentLeader)
    if leaderSequences.Has(RecursiveBinder.currentSequence) {
        Log("Found matching sequence: " RecursiveBinder.currentSequence)
        action := leaderSequences.Get(RecursiveBinder.currentSequence)
        action()
        ResetBinder()
        return true
    }

    ; Check if we've exceeded max sequence length
    if StrLen(RecursiveBinder.currentSequence) >= RecursiveBinder.maxSequenceLength {
        Log("Max sequence length reached, resetting")
        ResetBinder()
    }

    return true
}

; Function to reset the binder state
ResetBinder() {
    Log("Resetting binder state")
    RecursiveBinder.isActive := false
    RecursiveBinder.currentSequence := ""
    RecursiveBinder.currentLeader := ""
}

; Function to start sequence capture
StartSequence(leaderKey) {
    Log("Starting sequence capture with leader: " leaderKey)
    RecursiveBinder.isActive := true
    RecursiveBinder.currentSequence := ""
    RecursiveBinder.currentLeader := leaderKey
}

; Function to create a hotkey handler for a specific key
CreateKeyHandler(key) {
    Log("Creating handler for key: " key)
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
    if FileExist(LogFile) {
        FileDelete(LogFile)
    }

    ; Define hotkeys for all alphabetic keys
    Log("Setting up alphabetic key hotkeys")
    for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] {
        Log("Setting up hotkey for: " key)
        handler := CreateKeyHandler(key)
        HotIf IsSequenceActive
        Hotkey(key, handler)
    }

    ; ESC key to cancel sequence
    Log("Setting up ESC hotkey")
    HotIf IsSequenceActive
    Hotkey("Escape", (*) => ResetBinder())

    Log("Recursive binder initialization complete")
}

; Function to set up a recursive binding with a leader key
RecursiveBind(leaderKey, sequence, action) {
    Log("Setting up recursive binding for leader: " leaderKey)

    ; Create a handler for this specific leader key
    leaderHandler := (*) => StartSequence(leaderKey)

    ; Set up the hotkey for this leader
    Log("Setting up leader key hotkey: " leaderKey)
    HotIf IsSequenceInactive
    Hotkey(leaderKey, leaderHandler)

    ; Add the sequence binding
    AddSequence(leaderKey, sequence, action)
}
