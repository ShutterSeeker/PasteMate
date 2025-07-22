#Requires AutoHotkey v2.0
#SingleInstance Force

; bind !0–!9 to keys 0–9
!0:: HandleHotkey(0)
!1:: HandleHotkey(1)
!2:: HandleHotkey(2)
!3:: HandleHotkey(3)
!4:: HandleHotkey(4)
!5:: HandleHotkey(5)
!6:: HandleHotkey(6)
!7:: HandleHotkey(7)
!8:: HandleHotkey(8)
!9:: HandleHotkey(9)

; bind XButton1/2 to keys 10/11
XButton1:: HandleHotkey(10)
XButton2:: HandleHotkey(11)

; if SQL server management studio is active, F1 wil right click and send S, S, Enter, A, Enter
#HotIf WinActive("ahk_exe ssms.exe")
~MButton:: {
    Click("Right")
    Sleep(100)
    Send("s") ; Right click, then S for "Script as"
    Sleep(100)
    Send("s") ; Then S for "CREATE TO"
    Sleep(100)
    Send("{Enter}") ; Then Enter
    Sleep(100)
    Send("a") ; Then A for "New Query"
    Sleep(100)
    Send("{Enter}") ; Then Enter
}

; —————— Generic handler for !0–!9 and XButton1/2
HandleHotkey(key) {
    cfgFile := A_ScriptDir "\config.txt"
    if !FileExist(cfgFile) {
        MsgBox("File not found: " cfgFile)
        return
    }
    full := FileRead(cfgFile)
    if Trim(full) = "" {
        MsgBox("Failed to read: " cfgFile)
        return
    }

    startTag := "[" key "]"
    endTag   := "[/" key "]"
    s := InStr(full, startTag)
    e := InStr(full, endTag)
    if !(s && e && e > s) {
        MsgBox("Entry for [" key "] not found in " cfgFile)
        return
    }

    content := SubStr(full, s + StrLen(startTag), e - s - StrLen(startTag))
    ; — replace placeholders
    today := FormatTime(, "MM/dd/yyyy")
    content := StrReplace(content, "[[TODAY]]", today)

    clipFlag := InStr(content, "[[CLIPBOARD]]")

    newWin := InStr(content, "[[NEWWIN]]")
    content := StrReplace(content, "[[NEWWIN]]", "")

    linkFlag := InStr(content, "[[LINK]]")
    content  := StrReplace(content, "[[LINK]]", "")

    content := Trim(content, "`r`n")
    if (content = "") {
        hkName := (key = 10) ? "XButton1"
               : (key = 11) ? "XButton2"
               : "!" key
    
        Hotkey(hkName, "Off")
    
        try {
            if (key = 10) {
                Send("{XButton1}")
            } else if (key = 11) {
                Send("{XButton2}")
            } else {
                Send("!{" key "}")
            }
        }
        finally {
            Hotkey(hkName, "On")
        }
        return
    }    

    if linkFlag {
        Run(content)
        return
    }

    origClip := ClipboardAll()
    if clipFlag {
        Send("^c")
        ClipWait(1)
        Sleep(100)
        clipText := A_Clipboard
        content := StrReplace(content, "[[CLIPBOARD]]", clipText)
        Sleep(100)
    }

    if newWin {
        Send("^n")
        Sleep(1500)
    }

    Sleep(100)
    A_Clipboard := content
    ClipWait(1)
    Send("^v")
    Sleep(100)

    A_Clipboard := origClip
}