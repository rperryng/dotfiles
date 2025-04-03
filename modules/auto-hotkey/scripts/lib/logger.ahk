#Requires AutoHotkey v2.0

; Global initialization flag
global LoggerInitialized := false

class Logger {
    static defaultLogFile := "logs.txt"
    static isDebug := true  ; Set to false to disable logging
    static loggers := Map() ; Registry of logger instances

    ; Instance properties
    context := ""
    logFile := ""

    __New(context, logFile := "") {
        if (Logger.loggers.Has(context)) {
            return Logger.loggers.Get(context)
        }

        this.context := context
        this.logFile := logFile ? logFile : Logger.defaultLogFile
        Logger.loggers.Set(context, this)
    }

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

    static SetDebug(enabled) {
        Logger.isDebug := enabled
    }

    static SetDefaultLogFile(path) {
        Logger.defaultLogFile := path
    }

    static GetLogger(context, logFile := "") {
        if (!Logger.loggers.Has(context)) {
            Logger.loggers.Set(context, Logger(context, logFile))
        }
        return Logger.loggers.Get(context)
    }

    static ClearLogFile() {
        if (FileExist(Logger.defaultLogFile)) {
            FileDelete(Logger.defaultLogFile)
        }
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

if (!LoggerInitialized) {
    Logger.ClearLogFile()
    LoggerInitialized := true
}
