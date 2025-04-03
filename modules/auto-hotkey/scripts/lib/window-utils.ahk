#Requires AutoHotkey v2.0
#Include logger.ahk

; Create a logger instance for this file
windowUtilsLogger := Logger("window-utils")

; Focus an application, launching it if it's not already running
LaunchAndFocus(path, exe := "", window_identifier := "") {
    if (exe == "") {
        SplitPath(path, &exe)
    }

    if (window_identifier == "") {
        window_identifier := "ahk_exe " . exe
    }

    process_exists := ProcessExist(exe)

    if !process_exists {
        Run(path)
        WinWait(window_identifier)
    }
    WinActivate(window_identifier)
}

; cycle through windows that belong to the currently focused app.
CycleAppWindows(Direction) {
    static total := 0, hWnds := [], last := ""

    windowUtilsLogger.Debug("CycleAppWindows called with Direction: " Direction)
    windowUtilsLogger.Debug("Current static state - total: " total ", last: " last)

    a := WinExist("A")
    wClass := WinGetClass("A")
    exe := WinGetProcessName("A")

    windowUtilsLogger.Debug("Current window - handle: " a ", class: " wClass ", exe: " exe)

    if (exe != last) {
        windowUtilsLogger.Debug("Exe changed from " last " to " exe " - refreshing window list")
        last := exe
        hWnds := []
        DetectHiddenWindows(false)
        wList := WinGetList("ahk_exe " exe " ahk_class " wClass)
        for hWnd in wList {
            hWnds.Push(hWnd)
        }
        total := hWnds.Length
        windowUtilsLogger.Debug("Found " total " windows for this exe/class combination")
    }

    i := 1
    for index, hWnd in hWnds {
        if (a = hWnd) {
            i := index
            break
        }
    }

    windowUtilsLogger.Debug("Current window index: " i)

    i += Direction
    i := i > total ? 1 : i = 0 ? total : i
    windowUtilsLogger.Debug("Activating window at index: " i " (handle: " hWnds[i] ")")
    WinActivate("ahk_id " hWnds[i])
}
