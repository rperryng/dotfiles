#Requires AutoHotkey v2.0
#SingleInstance Force

; Disable Windows key opening Start menu with debounce protection
~LWin:: Send("{Blind}{vk08}")

; Remap Windows+Tab to Alt+Tab
#Tab:: {
  Send("{Alt down}{Tab}")
  KeyWait("LWin")
  Send("{Alt up}")
}

; Remap Shift-Windows-Tab to Alt-Shift-Tab
#+Tab:: {
  Send("{Alt down}{Shift down}{Tab}")
  KeyWait("LWin")
  Send("{Alt up}")
}

; Launch Flow Launcher with Windows+Space
#Space:: Run Format("C:\Users\{1}\AppData\Local\FlowLauncher\Flow.Launcher.exe", A_UserName)

; hyper-key shortcuts
; set a mapping for each key to avoid accidentally triggering the builtin windows shortcuts (microsoft office, linkedin, etc)
^+!#a:: return
^+!#b:: return
^+!#c:: return
^+!#d:: return
^+!#e:: launch_and_focus("C:\Windows\explorer.exe", "explorer.exe", "ahk_class CabinetWClass")  ; Explorer
^+!#f:: launch_and_focus("C:\Program Files\Mozilla Firefox\firefox.exe")  ; Firefox
^+!#g:: launch_and_focus("C:\Program Files\Godot\Godot_v4.4-stable_mono_win64\Godot_v4.4-stable_mono_win64.exe")  ; Godot
^+!#h:: return
^+!#i:: return
^+!#j:: return
^+!#k:: return
^+!#l:: return
^+!#m:: launch_and_focus(Format("C:\Users\{1}\AppData\Roaming\Telegram Desktop\Telegram.exe", A_UserName))  ; Telegram
^+!#n:: return
^+!#o:: return
^+!#p:: return
^+!#q:: return
^+!#r:: Reload()  ; Reload script
^+!#s:: launch_and_focus(Format("C:\Users\{1}\AppData\Roaming\Spotify\Spotify.exe", A_UserName))  ; Spotify
^+!#t:: launch_and_focus(Format("C:\Users\{1}\AppData\Local\Microsoft\WindowsApps\WindowsTerminal.exe", A_UserName))  ; Terminal
^+!#u:: return
^+!#v:: launch_and_focus(Format("C:\Users\{1}\AppData\Local\Programs\Microsoft VS Code\Code.exe", A_UserName))  ; VS Code
^+!#w:: return
^+!#x:: launch_and_focus(Format("C:\Users\{1}\AppData\Local\Programs\cursor\Cursor.exe", A_UserName))  ; Cursor
^+!#y:: return
^+!#z:: return

; explicit "cancel" mapping
^+!#Esc:: return

launch_and_focus(path, exe := "", window_identifier := "") {
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

; osx "cmd-`" style window switching
#`:: Windows(+1)
#+`:: Windows(-1)

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
