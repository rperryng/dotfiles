#Requires AutoHotkey v2.0

#Include recursive-binder.ahk
#Include logger.ahk

class HyperKeyUtils {
    static CreateNoOpMappings() {
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
    }
}
