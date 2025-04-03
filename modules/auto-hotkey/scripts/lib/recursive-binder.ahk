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
    maxSequenceLength: 10,    ; Maximum length of a sequence (including leader)
    popupGui: "",            ; GUI object for showing available keys
    popupText: "",           ; Text control for the popup
    labels: Map()            ; Map to store labels for each key in sequences
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

    ; Add consistent spacing between labels
    availableKeys := RegExReplace(availableKeys, "\) ", ")    ")

    ; Destroy existing GUI if it exists
    if RecursiveBinder.popupGui {
        RecursiveBinder.popupGui.Destroy()
    }

    ; Define padding (same for all sides)
    padding := 15

    ; Create new GUI
    RecursiveBinder.popupGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    RecursiveBinder.popupGui.BackColor := "000000"
    RecursiveBinder.popupGui.SetFont("s12", "Consolas")

    ; Add text control with consistent padding
    RecursiveBinder.popupText := RecursiveBinder.popupGui.AddText("x" padding " y" padding " c0xFFFFFF", availableKeys)

    ; Get text size (returns x, y, width, height)
    x := 0, y := 0, w := 0, h := 0
    RecursiveBinder.popupText.GetPos(&x, &y, &w, &h)
    width := w + (padding * 2)  ; Add padding for both left and right
    height := h + (padding * 2)  ; Add padding for both top and bottom

    ; Create region for rounded corners
    hRegion := DllCall("CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", width, "Int", height, "Int", 10, "Int", 10)
    DllCall("SetWindowRgn", "Ptr", RecursiveBinder.popupGui.Hwnd, "Ptr", hRegion, "Int", true)

    ; Show GUI with calculated size
    RecursiveBinder.popupGui.Show("w" width " h" height " NoActivate")

    ; Position window at bottom center of screen
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    xPos := (screenWidth - width) / 2
    yPos := screenHeight - height - 100  ; 100 pixels from bottom

    ; Ensure the window stays within screen bounds
    xPos := Max(0, Min(xPos, screenWidth - width))

    RecursiveBinder.popupGui.Move(xPos, yPos)
}

; Function to hide the popup window
HideAvailableKeys() {
    recursiveBinderLogger.Debug("Hiding available keys popup")
    if RecursiveBinder.popupGui {
        RecursiveBinder.popupGui.Destroy()
        RecursiveBinder.popupGui := ""
        RecursiveBinder.popupText := ""
    }
}

; Function to get available next keys for current sequence
GetAvailableNextKeys() {
    recursiveBinderLogger.Debug("Getting available next keys")
    recursiveBinderLogger.Debug("Current sequence: " RecursiveBinder.currentSequence)
    recursiveBinderLogger.Debug("Current leader: " RecursiveBinder.currentLeader)

    if !RecursiveBinder.isActive || !RecursiveBinder.currentLeader {
        return ""
    }

    leaderSequences := RecursiveBinder.sequences.Get(RecursiveBinder.currentLeader)
    if !leaderSequences {
        return ""
    }

    ; Create a map to store unique next keys and their labels
    nextKeys := Map()

    ; First, find all possible next keys from the sequences
    currentSeqLen := StrLen(RecursiveBinder.currentSequence)
    for sequence, _ in leaderSequences {
        recursiveBinderLogger.Debug("Checking sequence: " sequence)

        ; Only look at sequences that start with our current sequence
        if SubStr(sequence, 1, currentSeqLen) = RecursiveBinder.currentSequence {
            ; Get the next key in the sequence (if any)
            if StrLen(sequence) > currentSeqLen {
                nextKey := SubStr(sequence, currentSeqLen + 1, 1)
                recursiveBinderLogger.Debug("Found next key: " nextKey)

                ; Only add if we haven't seen this key before
                if nextKey && !nextKeys.Has(nextKey) {
                    ; Get the label for this key's sequence
                    fullSeq := RecursiveBinder.currentSequence nextKey
                    label := RecursiveBinder.labels.Get(fullSeq, "")
                    recursiveBinderLogger.Debug("Label for " fullSeq ": " label)
                    nextKeys[nextKey] := label
                }
            }
        }
    }

    ; Build the display string with each key only once and more spacing
    availableKeys := ""
    for key, label in nextKeys {
        if label
            availableKeys .= key "(" label ") "  ; The ShowAvailableKeys function will add more spacing between labels
    }

    recursiveBinderLogger.Debug("Available keys: " availableKeys)
    return Trim(availableKeys)
}

; Function to add a sequence binding
AddSequence(leaderKey, sequence, action, label := "") {
    recursiveBinderLogger.Debug("Adding sequence: " sequence " for leader: " leaderKey)
    if !RecursiveBinder.sequences.Has(leaderKey) {
        RecursiveBinder.sequences.Set(leaderKey, Map())
    }
    RecursiveBinder.sequences.Get(leaderKey).Set(sequence, action)
    if label {
        RecursiveBinder.labels.Set(sequence, label)
    }
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

        ; Check if there are any longer sequences that start with the current sequence
        hasLongerSequences := false
        for sequence, _ in leaderSequences {
            if SubStr(sequence, 1, StrLen(RecursiveBinder.currentSequence)) = RecursiveBinder.currentSequence
               && StrLen(sequence) > StrLen(RecursiveBinder.currentSequence) {
                hasLongerSequences := true
                break
            }
        }

        ; Only execute and reset if this is a leaf node (no longer sequences)
        if !hasLongerSequences {
            action()
            ResetBinder()
            return true
        }
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
RecursiveBind(leaderKey, mappings) {
    recursiveBinderLogger.Info("Setting up recursive binding for leader: " leaderKey)

    ; Create a handler for this specific leader key
    leaderHandler := (*) => StartSequence(leaderKey)

    ; Set up the hotkey for this leader - now always active
    recursiveBinderLogger.Debug("Setting up leader key hotkey: " leaderKey)
    HotIf
    Hotkey(leaderKey, leaderHandler)

    ; Process the mappings recursively
    ProcessMappings(leaderKey, "", mappings)
}

; Helper function to process mappings recursively
ProcessMappings(leaderKey, currentSequence, mappings) {
    recursiveBinderLogger.Debug("Processing mappings for leader: " leaderKey " with current sequence: " currentSequence)

    for mapping in mappings {
        key := mapping.key
        label := mapping.label
        newSequence := currentSequence key

        recursiveBinderLogger.Debug("Processing key: " key " with label: " label)
        recursiveBinderLogger.Debug("New sequence: " newSequence)

        ; Store label for this node in the sequence tree
        if label {
            recursiveBinderLogger.Debug("Storing label for sequence: " newSequence " = " label)
            RecursiveBinder.labels.Set(newSequence, label)
        }

        if HasProp(mapping, "callback") {
            ; This is a leaf node with a callback
            recursiveBinderLogger.Debug("Adding leaf sequence: " newSequence)
            AddSequence(leaderKey, newSequence, mapping.callback)
        } else if HasProp(mapping, "mappings") {
            ; This is a node with nested mappings
            recursiveBinderLogger.Debug("Processing nested mappings for sequence: " newSequence)

            ; Store this as a valid sequence even though it's not a leaf
            AddSequence(leaderKey, newSequence, () => "")

            ProcessMappings(leaderKey, newSequence, mapping.mappings)
        }
    }
}
