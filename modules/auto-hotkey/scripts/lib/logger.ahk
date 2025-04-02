#Requires AutoHotkey v2.0

global LoggerInitialized := false
if (!LoggerInitialized) {
    if (FileExist("logs.txt")) {
        FileDelete("logs.txt")
    }
    LoggerInitialized := true
}

class Logger {
    static defaultLogFile := "logs.txt"
    static isDebug := true  ; Set to false to disable logging

    ; Instance properties
    context := ""
    logFile := ""

    ; Constructor
    __New(context, logFile := "") {
        this.context := context
        this.logFile := logFile ? logFile : Logger.defaultLogFile
    }

    ; Instance methods
    Log(message) {
        if (!Logger.isDebug)
            return

        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        logMessage := Format("[{1}] [{2}] {3}", timestamp, this.context, message)

        ; Write to file
        try {
            FileAppend(logMessage "`n", this.logFile)
        }

        ; Also show in debug window if enabled
        if (Logger.isDebug)
            OutputDebug(logMessage "`n")
    }

    Debug(message) {
        this.Log("[DEBUG] " message)
    }

    Info(message) {
        this.Log("[INFO] " message)
    }

    Error(message) {
        this.Log("[ERROR] " message)
    }

    ; Static methods
    static SetDebug(enabled) {
        Logger.isDebug := enabled
    }

    static SetDefaultLogFile(path) {
        Logger.defaultLogFile := path
    }

    ; Static convenience methods for quick logging without creating an instance
    static Log(message) {
        if (!Logger.isDebug)
            return

        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        logMessage := Format("[{1}] {2}", timestamp, message)

        try {
            FileAppend(logMessage "`n", Logger.defaultLogFile)
        }

        if (Logger.isDebug)
            OutputDebug(logMessage "`n")
    }

    static Debug(message) {
        Logger.Log("[DEBUG] " message)
    }

    static Info(message) {
        Logger.Log("[INFO] " message)
    }

    static Error(message) {
        Logger.Log("[ERROR] " message)
    }
}
