#NoEnv
#SingleInstance Force
#UseHook
#InstallKeybdHook
SendMode Input

; Disable Windows 10 Office Bindings
#^!+W::
return

; #^!+T::
; return

#^!+Y::
return

#^!+O::
return

#^!+P::
return

#^!+D::
return

#^!+L::
return

#^!+X::
return

#^!+N::
return

#^!+Space::
return

; Hyper key bindings to launch applications
!+^#T::
if WinExist("ahk_exe WindowsTerminal.exe")
    WinActivate ; Use the window found by WinExist.
else
    Run, "wt.exe", "C:\Users\ryanp\AppData\Local\Microsoft\WindowsApps\"
return
