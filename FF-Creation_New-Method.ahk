/************************************************************************
 * @description Highly configurable message box.
 * @license GPL-3.0
 * @file FF-Creation.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/FF-Creation)
 * @created 2024-10-20
 * @version 1.0.0
 * @copyright 2024 Aaqil Ilyas
 **************************************************************************/

#Include <GuiEnhancerKit>

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

* Include the FF_ColorSchemes library, which allows you to create custom color schemes.
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\PicSwitch.ahk
#Include Lib\CursorHandler.ahk
#Include Lib\CustomMsgbox.ahk
#Include Lib\FileManager.ahk
#Include Lib\FF_ColorSchemes.ahk

WINDOW_WIDTH := 
WINDOW_HEIGHT := 
SuccessTimer := 0.5
ErrorTimer := 1
FF_CREATION := A_ScriptDir "\Lib\Icons\FF_Creation.png"
FF_ERROR := A_ScriptDir "\Lib\Icons\FF_Error.png"
FF_INFO := A_ScriptDir "\Lib\Icons\FF_Info.png"
FF_QUESTION := A_ScriptDir "\Lib\Icons\FF_Question.png"
POST_PROCESSING := A_ScriptDir "\Lib\Sources\post-processing.blend"
REFERENCE_FILE := A_ScriptDir "\Lib\Sources\NewScene.pur"
BLEND_FILE := A_ScriptDir "\Lib\Sources\NewBlenderProjects.blend"

; Set the title for the tray menu
A_IconTip := "FF-Creation"

; Set the icon for the tray menu
TraySetIcon(FF_CREATION)

ffcreation := GuiExt("AlwaysOnTop -Caption")

ffcreation.BackColor := "535353"

; Add ESC key handling
ffcreation.OnEvent("Escape", (*) => ffcreation.Destroy())

ffcreation.Show("h300 w350 center")