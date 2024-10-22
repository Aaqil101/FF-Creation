/************************************************************************
 * @description Highly configurable message box.
 * @license GPL-3.0
 * @file FF-Creation.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/FF-Creation)
 * @created 2024-10-20
 * @version 2.5.0
 * @copyright 2024 Aaqil Ilyas
 **************************************************************************/

/*
* I created most of the script using (https://claude.ai) and I modified it.
*/

#Requires Autohotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance Force ;Only launch anstance of this script.
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

* Include the CursorHandler library, which allows you to handle cursors.
* For more information, see https://www.youtube.com/watch?v=jn83VAU3tBw

* Include the CustomMsgbox library, which allows you to create custom message boxes.
* For more information, see https://github.com/Aaqil101/Custom-Libraries/tree/master/Custom%20Msgbox

* Include the FileManager library, which allows you to create input boxes.
* For more information, see https://github.com/Aaqil101/FF-Creation/blob/master/Lib/FileManager.ahk
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\PicSwitch.ahk
#Include Lib\CursorHandler.ahk
#Include Lib\CustomMsgbox.ahk
#Include Lib\FileManager.ahk

WINDOW_WIDTH := 250
WINDOW_HEIGHT := 280
SuccessTimer := 0.5
ErrorTimer := 1
FF_CREATION := A_ScriptDir "\Lib\Icons\FF_Creation.png"
FF_ERROR := A_ScriptDir "\Lib\Icons\FF_Error.png"
FF_INFO := A_ScriptDir "\Lib\Icons\FF_Info.png"
FF_QUESTION := A_ScriptDir "\Lib\Icons\FF_Question.png"
POST_PROCESSING := A_ScriptDir "\Lib\Sources\post-processing.blend"
REFERENCE_FILE := A_ScriptDir "\Lib\Sources\NewScene.pur"
BLEND_FILE := A_ScriptDir "\Lib\Sources\NewBlenderProjects.blend"

; Add Color Scheme
CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")
CustomMsgBox.AddColorScheme("Success", "E8F5E9", "1B5E20", "4CAF50")

TraySetIcon (FF_CREATION)

; Define the folder names and their default states
folders := [
    { name: "a_blend", default: true },
    { name: "b_ref", default: true },
    { name: "c_previs", default: true },
    { name: "d_postproc", default: false },
    { name: "d_martiniShot", default: false },
    { name: "e_videdit", default: false },
    { name: "e_martiniShot", default: false },
    { name: "f_finalTouch", default: false },
    { name: "g_martiniShot", default: false }
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
    m["Value0DisabledIcon"]:=m["Value1DisabledIcon"]:="Lib\Icons\SW_Value0DisabledIcon.png"
    m["Value1Icon"] := "Lib\Icons\SW_Value1Icon.png"
    m["Value0Icon"] := "Lib\Icons\SW_Value0Icon.png" */

    m := Map()
    m["SWidth"] := 20
    m["SHeight"] := 20
    m["Value0DisabledIcon"] := m["Value1DisabledIcon"] := "Lib\Icons\CB_Value0DisabledIcon.png"
    m["Value1Icon"] := "Lib\Icons\CB_Value1Icon.png"
    m["Value0Icon"] := "Lib\Icons\CB_Value0Icon.png"

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

; Create in selected folders (single directory approach)
CreateInSelectedFolders(*) {
    selectedFolders := []
    createBlend := false
    createPureRef := false
    createpostproc := false

    ; Collect selected folders
    for index, folder in folders {
        if (bFiles["Folder" index].Value) {
            selectedFolders.Push(folder.name)
            if (folder.name == "a_blend")
                createBlend := true
            if (folder.name == "b_ref")
                createPureRef := true
            if (folder.name == "d_postproc")
                createpostproc := true
        }
    }

    ; Validate folder selection
    if (selectedFolders.Length == 0) {
        ShowError("selectedFolders.Length", "Please select at least one folder to create.", window_width + 240, window_height + 118)
        return
    }

    ; Only get filename if a_blend or b_ref is selected
    if (createBlend || createPureRef) {
        if !FileManager.GetFileName()
            return
    }

    ; Ask the user where to create the folders
    selectedPath := FileSelect("D", A_Desktop, "Select where to create the folders")

    if (selectedPath != "") {
        createdFolders := []
        errors := []

        ; Create folders and handle files
        for folder in selectedFolders {
            fullPath := selectedPath "\" folder

            try {
                DirCreate(fullPath)
                createdFolders.Push(fullPath)

                ; Create specific files based on folder type
                if (folder == "a_blend" && createBlend)
                    CreateNewBlendFile(fullPath, selectedPath)
                
                if (folder == "b_ref" && createPureRef)
                    CreatePureRefFile(fullPath, selectedPath)
                
                if (folder == "d_postproc" && createpostproc)
                    CreatePostProcessingFile(fullPath, selectedPath)
            }
            catch as err {
                errors.Push("Error creating " folder ": " err.Message)
            }
        }

        ; Prepare and show result message
        resultMsg := "Results:`n`n"
        if (createdFolders.Length > 0)
            resultMsg .= "Created folders:`n" StrJoin(createdFolders, "`n") "`n`n"
        if (errors.Length > 0)
            resultMsg .= "Errors:`n" StrJoin(errors, "`n")

        ShowResult("Created F&F", resultMsg, "Center", "Center")
        bFiles.Destroy()
        ExitApp()
    }
}

; Create in custom paths (multiple directory approach)
CreateInCustomPaths(*) {
    ; Reset FileManager at the start
    FileManager.Reset()

    selectedFolders := []
    createBlend := false
    createPureRef := false
    createpostproc := false
    createdFolders := []
    errors := []

    ; Collect selected folders
    for index, folder in folders {
        if (bFiles["Folder" index].Value) {
            selectedFolders.Push(folder.name)
            if (folder.name == "a_blend")
                createBlend := true
            if (folder.name == "b_ref")
                createPureRef := true
            if (folder.name == "d_postproc")
                createpostproc := true
        }
    }

    ; Validate folder selection
    if (selectedFolders.Length == 0) {
        ShowError("selectedFolders.Length", "Please select at least one folder to create.", window_width + 240, window_height + 118)
        return
    }

    ; Keep track of paths
    paths := []
    
    ; Continue asking for paths until user cancels
    while true {
        customPath := InputBox("Enter a directory path (Cancel to finish):", "Custom Path " paths.Length + 1, "y270 w600 h90")
        
        if (customPath.Result = "Cancel")
            break
            
        path := Trim(customPath.Value)
        if (path = "") {
            ShowError("EmptyPath", "Path cannot be empty.", window_width + 240, window_height + 118)
            continue
        }

        ; Only get filename if a_blend or b_ref is selected
        if (createBlend || createPureRef) {
            if !FileManager.GetFileName(path, true)  ; Force new filename input for each path
                continue
        }
        
        paths.Push(path)
        
        ; Create folders and files for this path
        for folder in selectedFolders {
            fullPath := path "\" folder

            try {
                DirCreate(fullPath)
                createdFolders.Push(fullPath)

                ; Create specific files based on folder type
                if (folder == "a_blend" && createBlend)
                    CreateNewBlendFile(fullPath, path)
                
                if (folder == "b_ref" && createPureRef)
                    CreatePureRefFile(fullPath, path)
                
                if (folder == "d_postproc" && createpostproc)
                    CreatePostProcessingFile(fullPath, path)
            }
            catch as err {
                errors.Push("Error creating " fullPath ": " err.Message)
            }
        }
    }

    ; Validate paths
    if (paths.Length == 0) {
        ShowError("NoPaths", "No paths were entered.", window_width + 240, window_height + 118)
        return
    }

    ; Prepare and show result message
    resultMsg := "Results:`n`n"
    if (createdFolders.Length > 0)
        resultMsg .= "Created folders:`n" StrJoin(createdFolders, "`n") "`n`n"
    if (errors.Length > 0)
        resultMsg .= "Errors:`n" StrJoin(errors, "`n")

    ShowResult("Created F&F", resultMsg, "Center", "Center")
    ExitApp()
}

; Create new blend file
CreateNewBlendFile(dirPath, basePath) {
    NBF_msgPositionY := window_height + 118
    NBF_msgPositionX := window_width + 240

    ; Create two subfolders
    DirCreate(dirPath "\assests")
    DirCreate(dirPath "\textures")

    if FileExist(BLEND_FILE) {
        try {
            FileCopy BLEND_FILE, dirPath "\" FileManager.GetCurrentFileName(basePath) ".blend"
            ShowResult("CreateNewBlendFile", "File created successfully!", NBF_msgPositionX, NBF_msgPositionY)
        } catch Error as err {
            ShowResult("CreateNewBlendFile", "Error copying file: " err.Message, NBF_msgPositionX, NBF_msgPositionY)
        }
    } else {
        ShowError("CreateNewBlendFile", "Source file doesn't exist!", NBF_msgPositionX, NBF_msgPositionY)
    }
}

; Create pure ref file
CreatePureRefFile(dirPath, basePath) {
    PRF_msgPositionX := window_width + 240
    PRF_msgPositionY := window_height + 118 + 92

    if FileExist(REFERENCE_FILE) {
        try {
            FileCopy REFERENCE_FILE, dirPath "\" FileManager.GetCurrentFileName(basePath) "Scene.pur"
            ShowResult("CreatePureRefFile", "File created successfully!", PRF_msgPositionX, PRF_msgPositionY)
        } catch Error as err {
            ShowError("CreatePureRefFile", "Error copying file: " err.Message, PRF_msgPositionX, PRF_msgPositionY)
        }
    } else {
        ShowError("CreatePureRefFile", "Source file doesn't exist!", PRF_msgPositionX, PRF_msgPositionY)
    }
}

; Create a post-processing blend file
CreatePostProcessingFile(dirPath, basePath) {
    PPF_msgPositionX := window_width + 240
    PPF_msgPositionY := window_height + 118 + 92 + 114

    ; Create a subfolder
    DirCreate(dirPath "\assests")

    if FileExist(POST_PROCESSING) {
        try {
            FileCopy POST_PROCESSING, dirPath
            ShowResult("CreatePostProcessingFile", "File created successfully!", PPF_msgPositionX, PPF_msgPositionY)
        } catch Error as err {
            ShowError("CreatePostProcessingFile", "Error copying file: " err.Message, PPF_msgPositionX, PPF_msgPositionY)
        }
    } else {
        ShowError("CreatePostProcessingFile", "Source file doesn't exist!", PPF_msgPositionX, PPF_msgPositionY)
    }
}

ShowError(title, message, msgX, msgY) {
    TraySetIcon (FF_ERROR)
    msg := CustomMsgBox()
    msg.SetText(title, message)
    msg.SetPosition(msgX, msgY)
    msg.SetColorScheme("Error")
    msg.SetOptions("ToolWindow", "AlwaysOnTop")
    msg.SetCloseTimer(ErrorTimer)
    msg.Show()
    TraySetIcon (FF_CREATION)
}

ShowResult(title, message, msgX, msgY) {
    TraySetIcon (FF_INFO)
    msg := CustomMsgBox()
    msg.SetText(title, message)
    msg.SetPosition(msgX, msgY)
    msg.SetColorScheme("Success")
    msg.SetOptions("ToolWindow", "AlwaysOnTop")
    msg.SetCloseTimer(SuccessTimer)
    msg.Show()
    TraySetIcon (FF_CREATION)
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