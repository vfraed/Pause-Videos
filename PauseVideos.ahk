; Script to pause / play videos in Chrome. https://www.udemy.com/ https://www.youtube.com/ sites.
; added other shortcuts to control videos (jump forward and back in time, increase decrease playback speed, restart video)
; Code taken and combined from here https://stackoverflow.com/a/63238469 and https://www.reddit.com/r/AutoHotkey/comments/4c6h42/script_to_playpause_youtube_from_another_window/?utm_source=share&utm_medium=web2x&context=3
; added the DllCall from https://www.reddit.com/r/AutoHotkey/comments/lrkjuq/mousegetpos_and_mousemove_coordinates_not/?utm_source=share&utm_medium=web2x&context=3 to make MouseGetPos and MouseMove work with DPI settigs. 
; Not sure if need the MouseClick at currenttypingposition?
; Media_Play_Pause don't work with this ???
; added title checking to be able to send correct key to youtube and umdey.

;============================== Start Auto-Execution Section ==============================
SetCapsLockState, AlwaysOff ; Set CapsLock to Always Off
#Persistent ; Keeps script permanently running
#NoEnv ; Avoids checking empty variables to see if they are environment variables
#SingleInstance, Force ; Ensures that there is only a single instance of this script running
DetectHiddenWindows, On ;Determines whether invisible windows are "seen" by the script
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory Makes a script unconditionally use its own folder as its working directory
Menu, Tray, Icon, icons\icons8-video-64.png
SetTitleMatchMode, 2 ; sets title matching to search for "containing" isntead of "exact"
DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr") ;Set the DPI awareness for the current thread to the provided value.
; include the ACC library to get the caret location.
#Include <Acc>
#Requires AutoHotkey v1.1.33+ ; Needs AHK version 1.1.33

controlID := 0 ;sets controlID to 0 every time the script is reloaded
Return

;============================== Main Script ==============================

#If !WinActive("ahk_exe chrome.exe")

NumpadEnter:: ; Play / pause
    chromeSend("{space}") ; youtube is k or space & udemy is space
    ; chromeSend("{Media_Play_Pause}") ; don't work
return

NumpadAdd:: ; Go forward 5s
    chromeSend("{Right}") ; right arrow
return

NumpadSub:: ; Go back 5s
    chromeSend("{Left}") ; left arrow
return

NumpadDiv:: ; (<) Decrease playback rate
    WinGetTitle, ttitle, ahk_exe chrome.exe ; get the tab title playing to send the correct keys
    if ttitle contains youtube
    chromeSend("+,") ; youtube shift comma or <
    if ttitle contains udemy
    chromeSend("+{Left}") ; udemy shift left arrow
return
NumpadMult:: ; (>) Increase playback rate
    WinGetTitle, ttitle, ahk_exe chrome.exe ; get the tab title playing to send the correct keys
    if ttitle contains youtube
    chromeSend("+.") ; youtube shift period or >
    if ttitle contains udemy?
    chromeSend("+{Right}") ; udemy shit right arrow
return
Numpad0:: ; Restart video
    chromeSend("0") ; zero
return


chromeSend(keys)
{
    ;Acc method to capture caret X Y screen position in active window (vscode)
    Acc_Caret := Acc_ObjectFromWindow(WinExist("A"), OBJID_CARET := 0xFFFFFFF8)
    Caret_Location := Acc_Location(Acc_Caret)
    MouseGetPos, xx, yy, winaa ; THIS STORES CURRENT MOUSE POSITION, AND THE WINDOW ID (VISUAL STUDIO CODE WINDOW)
    ControlGet, controlN, Hwnd,,Chrome_RenderWidgetHostHWND1, Google Chrome
    ControlFocus,,ahk_id %controlN%
    ; Sleep, 50
    ControlSend, Chrome_RenderWidgetHostHWND1, %keys% , Google Chrome
    SetKeyDelay, 500 ; 500MS DELAY
    WinActivate, ahk_id %winaa% ; THIS ACTIVATES THE VISUAL STUDIO CODE WINDOW FROM THE WINAA VARIABLE WHERE WE PREVIOUSLY STORED THE WINDOW ID
    MouseClick, left, Caret_Location, 1 ; THIS CLICKS ON WHERE WE WERE TYPING BEFORE
    MouseMove, xx, yy ; THIS MOVES THE MOUSE TO WHERE IT WAS BEORE
}
return ; THIS RETURNS TO A WAIT STATE


#If
;============================== End Script ==============================
