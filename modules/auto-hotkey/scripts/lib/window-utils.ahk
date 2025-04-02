#Requires AutoHotkey v2.0

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

    a := WinExist("A")
    wClass := WinGetClass("A")
    exe := WinGetProcessName("A")

    if (exe != last) {
        last := exe
        hWnds := []
        DetectHiddenWindows(false)
        wList := WinGetList("ahk_exe " exe " ahk_class " wClass)
        for hWnd in wList {
            hWnds.Push(hWnd)
        }
        total := hWnds.Length
    }

    i := 1
    for index, hWnd in hWnds {
        if (a = hWnd) {
            i := index
            break
        }
    }

    i += Direction
    i := i > total ? 1 : i = 0 ? total : i
    WinActivate("ahk_id " hWnds[i])
}
