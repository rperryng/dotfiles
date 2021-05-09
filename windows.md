# Windows Setup

WSL 2 in Windows is finally performant enough to use without pulling my hair out
Getting a nice development experience is still a lot of manual work though:

1. [Install WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
2. Enable virtualization - For my MOBO:
  a. Advanced Settings
  b. Overcloking section
  c. CPU features
  d. SVM mode on
3. add [`win32yank.exe`](https://github.com/equalsraf/win32yank) to $PATH
4. Install VcrXsrv, when running it ensure "disable access control" is checked. As a convenience, create a new shortcut and paste the following as the target: `"C:\Program Files\VcXsrv\vcxsrv.exe" :0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl -dpi auto`
5. (?) Install `sudo apt-get install gnome-terminal`
6. (?) `sudo apt-get install dbus-x11`
7. [Launch Gnome Terminal](#launching-gnome-terminal)
8. [Create a shortcut to launch
   gnome-terminal](#vbs-script-to-open-gnome-terminal)

#### Launching Gnome-Terminal
Starting with WSL 2, the host IP for the X11 server needs to be determined
programmatically.  I also had to start using `dbus-launch` to open
`gnome-terminal` rather than launching `gnome-terminal` directly:

```bash
DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0 dbus-launch gnome-terminal
```

#### Launch from TaskBar
First, wrap it in a `.vbs` script:

```vbs
args = "-c" & " -l " & """DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0 dbus-launch gnome-terminal"""
WScript.CreateObject("Shell.Application").ShellExecute "bash", args, "", "open", 0
```

VBS scripts can't be pinned to the taskbar (nor can their shortcuts), but
`wscript.exe` can.  Make a shortcut that invokes the VBS script via `wscript`:

```
C:\Windows\System32\wscript.exe "<PATH_TO_VBS_SCRIPT>"
```
