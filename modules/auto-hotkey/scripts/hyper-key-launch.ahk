#Requires AutoHotkey v2.0
#SingleInstance Force

^+!#s::launch_and_focus("C:\Users\%A_UserName%\AppData\Roaming\Spotify\Spotify.exe")
^+!#f::launch_and_focus("C:\Program Files\Mozilla Firefox\firefox.exe")
^+!#g::launch_and_focus("C:\Program Files\Godot\Godot_v4.4-stable_mono_win64\Godot_v4.4-stable_mono_win64.exe")
^+!#x::launch_and_focus("C:\Users\%A_UserName%\AppData\Local\Programs\cursor\Cursor.exe")
^+!#v::launch_and_focus("C:\Users\%A_UserName%\AppData\Local\Programs\Microsoft VS Code\Code.exe")
^+!#t::launch_and_focus("C:\Users\%A_UserName%\AppData\Roaming\Telegram Desktop\Telegram.exe")

^+!#r::Reload()

; no-ops
^+!#Esc::return

; disable builtin windows office / linkedin shortcuts
^+!#w::return
^+!#y::return
^+!#o::return
^+!#p::return
^+!#d::return
^+!#l::return
^+!#n::return
; ^+!#t::return
; ^+!#x::return

; Generic function to launch and focus an application
launch_and_focus(path, exe := "", window_identifier := "") {
    ; Extract exe name from path if not provided
    if (exe == "") {
        SplitPath(path, &exe)
    }
    
    ; Use default window identifier if not provided
    if (window_identifier == "") {
        window_identifier := "ahk_exe " . exe
    }
    
    ; checks if an app is already running
    process_exists := ProcessExist(exe)
    
    if !process_exists {
        ; IF NOT open and focus it.
        Run(path)
        WinWait(window_identifier)
    }
    ; bring it to the front and in focus
    WinActivate(window_identifier)
}

; switcher
#`::Windows(+1)
#+`::Windows(-1)

; cycle through windows that belong to the currently focused app.
Windows(Direction) {
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
