#Requires Autohotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance Force ;Only launch anstance of thi5 scrxpt.
Persistent ;Will keep it running

; Set the default mouse speed to 0
; This will make the mouse move instantly to its destination
; without any acceleration or deceleration
SetDefaultMouseSpeed 0

/*
* Include the GuiEnhancerKit library, which provides a set of functions to enhance the look and feel of AutoHotkey GUIs.
* For more information, see https://github.com/nperovic/GuiEnhancerKit

* Include the ColorButton library, which allows you to create custom buttons.
* For more information, see https://github.com/nperovic/ColorButton.ahk

* Include the PicSwitch library, which allows you to create custom checkboxes using images and icons.
* For more information, see https://www.autohotkey.com/boards/viewtopic.php?t=123831#:~:text=Viewed%201370%20times-,PicSwitch.ahk,-Code%3A%20Select
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\PicSwitch.ahk
#Include Lib\CustomMsgbox.ahk
#Include Lib\CursorHandler.ahk

WINDOW_WIDTH  := 250
WINDOW_HEIGHT := 280
CS_MSGBOX     := A_ScriptDir "\Icon\CS_Msgbox.png"
FF_CREATION   := A_ScriptDir "\Icon\FF_Creation.png"
FF_ERROR01    := A_ScriptDir "\Icon\FF_Error01.png"
FF_STOP01     := A_ScriptDir "\Icon\FF_Stop01.png"
FF_INFO       := A_ScriptDir "\Icon\FF_Info.png"
FF_QUESTION   := A_ScriptDir "\Icon\FF_Question.png"

TraySetIcon (FF_CREATION)

; Define the folder names and their default states
folders := [
    {name: "a_blend", default: true},
    {name: "b_ref", default: true},
    {name: "c_previs", default: true},
    {name: "d_postproc", default: false},
    {name: "d_martiniShot", default: false},
    {name: "e_videdit", default: false},
    {name: "e_martiniShot", default: false},
    {name: "f_finalTouch", default: false},
    {name: "g_martiniShot", default: false}
]

; Create a GUI for folder selection
bFiles := GuiExt(, "F&F Creation")
bFiles.SetFont("s10 Bold cwhite", "JetBrains Mono")
bFiles.SetDarkTitle()
bFiles.SetDarkMenu()
bFiles.AddText("x10 y5 w280", "Select The Folders To Create:")
bFiles.OnEvent("Close", (*) => ExitApp())

; Set the background color of the GUI window
bFiles.BackColor := "313131"

; Add checkboxes for each folder
for index, folder in folders {
    /* m := Map()
    m["Value0DisabledIcon"]:=m["Value1DisabledIcon"]:="Icon\SW_Value0DisabledIcon.png"
    m["Value1Icon"] := "Icon\SW_Value1Icon.png"
    m["Value0Icon"] := "Icon\SW_Value0Icon.png" */

    m := Map()
    m["SWidth"] := 20
    m["SHeight"] := 20
    m["Value0DisabledIcon"] := m["Value1DisabledIcon"] := "Icon\CB_Value0DisabledIcon.png"
    m["Value1Icon"] := "Icon\CB_Value1Icon.png"
    m["Value0Icon"] := "Icon\CB_Value0Icon.png"

    /*
    ! Depracated method, do not use
    ; Determine if the checkbox should be checked by default
    !checked := folder.default ? "Checked" : ""
    
    ; Build the options string for AddPicSwitch, including 'checked' if necessary
    !options := "x9.5 y" (18 + (index-1)*22) " w280 vFolder" index " " checked
    
    ; Call AddPicSwitch with the options string and the Map object
    !bFiles.AddPicSwitch(options, folder.name,, m)
    !bFiles.AddPicSwitch("x9.5 y" (18 + (index-1)*22) " w280 vFolder" index " " checked, folder.name,,m)
    */

    ; Set iValue to 1 if folder.default is true, otherwise 0
    checked := folder.default ? 1 : 0

    ; Add a switch button to the GUI for each folder in the folder list
    ; The switch button is positioned at x=9.5, y=18+(index-1)*22, and has a width of 280
    ; The text on the button is the name of the folder
    ; The initial state of the button is set to the value of the "checked" variable
    ; The style of the button is set to the style defined in the "m" variable
    bFiles.AddPicSwitch("x9.5 y" (22 + (index - 1) * 22) " w280 vFolder" index, folder.name, checked, m)
}

; Add a button to create selected folders
button1 := bFiles.AddButton("x10 y" (45 + folders.Length * 20) " w100", "One Directory")
button1.SetColor("008080", "FBFADA", 0, 0, 9)
button1.OnEvent("Click", CreateInSelectedFolders.Bind("Normal"))

button2 := bFiles.AddButton("x+10 y" (45 + folders.Length * 20) " w100", "Multiple Directories")
button2.SetColor("80001c", "FBFADA", 0, 0, 9)
button2.OnEvent("Click", CreateInCustomPaths.Bind("Normal"))

; Show the GUI
bFiles.Show("x0 y0 w" window_width " h" window_height " Center")

; Calculate the "center" position
; Move the mouse to the "center" of the wcGui window
MouseMove(
    WINDOW_WIDTH / 2,
    WINDOW_HEIGHT / 2
)

/*
* The following code block is from a youtube video (https://www.youtube.com/watch?v=jn83VAU3tBw) but the code in tha video is for autohotkey v1 and I am using v2 in here so, I used AHK-v2-script-converter (https://github.com/mmikeww/AHK-v2-script-converter) by mmikeww and changed some of codes myself now it works :) 👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼👇🏼
*/

/*
! Deprecated method, do not use
! ; IDC constants for LoadCursor (WinAPI)
! ; These constants can be used to load the following cursors:
! IDC_APPSTARTING := 32650   ; IDC_APPSTARTING - App Starting
! IDC_ARROW := 32512          ; IDC_ARROW - Arrow
! IDC_CROSS := 32515          ; IDC_CROSS - Cross
! IDC_HAND := 32649           ; IDC_HAND - Hand
! IDC_HELP := 32651           ; IDC_HELP - Help
! IDC_IBEAM := 32513          ; IDC_IBEAM - I Beam
! IDC_NO := 32648             ; IDC_NO - Slashed Circle
! IDC_SIZEALL := 32646        ; IDC_SIZEALL - Four-pointed star (resize in all directions)
! IDC_SIZENESW := 32643       ; IDC_SIZENESW - Double arrow pointing NE and SW
! IDC_SIZENS := 32645         ; IDC_SIZENS - Double arrow pointing N and S
! IDC_SIZENWSE := 32642       ; IDC_SIZENWSE - Double arrow pointing NW and SE
! IDC_SIZEWE := 32644         ; IDC_SIZEWE - Double arrow pointing W and E
! IDC_UPARROW := 32516        ; IDC_UPARROW - Up arrow
! IDC_WAIT := 32514           ; IDC_WAIT - Hourglass
! 
! ; Load the "hand" cursor from the system resources
! ; This cursor is used to indicate that a button is clickable
! ; The first parameter is NULL, which tells the function to load the cursor
! ; from the system resources. The second parameter is the ID of the cursor
! ; to load, which is IDC_HAND. The third parameter is ignored.
! BCursor := DllCall(
!     "LoadCursor", "UInt", NULL := 0, "Int", IDC_HAND, "UInt"
! )
! 
! ; Load the "hand" cursor from the system resources
! ; This cursor is used to indicate that a link is clickable
! ; The first parameter is NULL, which tells the function to load the cursor
! ; from the system resources. The second parameter is the ID of the cursor
! ; to load, which is IDC_HAND. The third parameter is ignored.
! LVCursor := DllCall(
!     "LoadCursor", "UInt", NULL := 0, "Int", IDC_HAND, "UInt"
! )
! 
! ; Set the cursor when hovering over certain buttons
! OnMessage(0x200, WM_MOUSEMOVE)
! WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
!     global BCursor
!     global LVCursor
!     MouseGetPos(, , , &ctrl)
! 
!     ; Set the cursor to 'BCursor' when hovering over Buttons
!     if (ctrl == "Button1")
!         DllCall("SetCursor", "UInt", BCursor)
!     if (ctrl == "Button2")
!         DllCall("SetCursor", "UInt", BCursor)
! }
*/

/*
👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼👆🏼
*/

; Create in selected folders
CreateInSelectedFolders(*) {
    selectedFolders := []
    createPureRef := false

    ; Collect selected folders
    for index, folder in folders {
        if (bFiles["Folder" index].Value)
        {
            selectedFolders.Push(folder.name)
            if (folder.name == "b_ref")
                createPureRef := true
        }
    }

    if (selectedFolders.Length == 0) {
        MsgBox("Please select at least one folder to create.", "Select Folders", "T1 16")
        return
    }

    ; Ask the user where to create the folders
    selectedPath := FileSelect("DM", A_Desktop, "Select where to create the folders")

    if (selectedPath != "") {
        createdFolders := []
        errors := []

        for folder in selectedFolders {
            fullPath := selectedPath "\" folder

            try {
                DirCreate(fullPath)
                createdFolders.Push(fullPath)
            }
            catch as err {
                errors.Push("Error creating " folder ": " err.Message)
            }
        }

        ; Create PureRef file if b_ref was selected
        if (createPureRef) {
            CreatePureRefFile(selectedPath "\b_ref")
        }

        ; Prepare result message
        resultMsg := "Results:`n`n"
        if (createdFolders.Length > 0)
            resultMsg .= "Created folders:`n" StrJoin(createdFolders, "`n") "`n`n"
        if (errors.Length > 0)
            resultMsg .= "Errors:`n" StrJoin(errors, "`n")

        MsgBox(resultMsg, "Created F&F", "T0.5 64")

        ; Terminate the script
        ExitApp()
    }
    else {
        MsgBox("Folder creation cancelled.", "Operation Cancelled", "T0.5 16")
        ExitApp()
    }

    ; Destroy the bFiles object to free up any resources it may have allocated.
    bFiles.Destroy()
}

; Create in custom paths
CreateInCustomPaths(*) {

    customPaths := InputBox("Enter directory paths:", "Custom Paths", "y270 w600 h90").Value

    selectedFolders := []
    createPureRef := false

    ; Collect selected folders
    for index, folder in folders {
        if (bFiles["Folder" index].Value)
        {
            selectedFolders.Push(folder.name)
            if (folder.name == "b_ref")
                createPureRef := true
        }
    }

    if (selectedFolders.Length == 0) {
        TraySetIcon (FF_ERROR01)
        CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")
        msg := CustomMsgBox()
        msg.SetText("selectedFolders.Length", "Please select at least one folder to create.")
        msg.SetPosition(window_width + 240, window_height + 118)
        msg.SetColorScheme("Error")
        msg.SetOptions("ToolWindow", "AlwaysOnTop")
        msg.SetCloseTimer(1)
        msg.Show()
        bFiles.Destroy()
        TraySetIcon (FF_CREATION)
        ; MsgBox("Please select at least one folder to create.", "Select Folders", "T0.5 16")
        return
    }

    ; Get custom paths from the Edit control
    customPaths := StrSplit(customPaths, ",")

    if (customPaths.Length == 0) {
        TraySetIcon (FF_STOP01)
        CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")
        msg := CustomMsgBox()
        msg.SetText("customPaths.Length", "Please enter at least one path.")
        msg.SetPosition(window_width + 240, window_height + 118)
        msg.SetColorScheme("Error")
        msg.SetOptions("ToolWindow", "AlwaysOnTop")
        msg.SetCloseTimer(1)
        msg.Show()
        bFiles.Destroy()
        ; MsgBox("Please enter at least one path.", "Enter Paths", "T0.5 16")
        TraySetIcon (FF_CREATION)
        return
    }

    createdFolders := []
    errors := []

    for path in customPaths {
        path := Trim(path)
        if (path != "") {
            for folder in selectedFolders {
                fullPath := path "\" folder

                try {
                    DirCreate(fullPath)
                    createdFolders.Push(fullPath)

                    ; Create PureRef file if b_ref was selected
                    if (folder == "b_ref" && createPureRef) {
                        CreatePureRefFile(fullPath)
                    }
                }
                catch as err {
                    errors.Push("Error creating " fullPath ": " err.Message)
                }
            }
        }
    }

    ; Prepare result message
    resultMsg := "Results:`n`n"
    if (createdFolders.Length > 0)
        resultMsg .= "Created folders:`n" StrJoin(createdFolders, "`n") "`n`n"
    if (errors.Length > 0)
        resultMsg .= "Errors:`n" StrJoin(errors, "`n")

    MsgBox(resultMsg, "Created F&F", "T0.5 64")

    ; Terminate the script
    ExitApp()
}

CreatePureRefFile(dirPath) {
    ; Prompt the user to enter a name for the PureRef reference file
    refName := InputBox("Please enter a PureRef Name.", "Reference File Name", "y720 w250 h100")
    if refName.Result = "Cancel" {
        MsgBox("PureRef file creation canceled.", "Canceled", "T0.25 16")
        return
    }

    ; Construct the full path of the file to be created
    filePath := dirPath "\" refName.Value "Scene.pur"

    ; Use FileAppend to create the file
    try {
        FileAppend("", filePath)
        MsgBox("File created: " filePath, "Success", "T1 64")
    }
    catch as err {
        MsgBox("Error creating PureRef file: " err.Message, "Error", "T1 48 y720")
    }
}

StrJoin(arr, sep) {
    result := ""
    for index, element in arr {
        if (index > 1)
            result .= sep
        result .= element
    }
    return result
}