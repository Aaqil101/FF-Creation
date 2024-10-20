/************************************************************************
 * @description User input box for file names
 * @file FileManager.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/FF-Creation/blob/master/Lib/FileManager.ahk)
 * @created 2024-10-20
 * @version 1.0.0
 **************************************************************************/

/*
* Include the CursorHandler library, which allows you to handle cursors.
* For more information, see https://www.youtube.com/watch?v=jn83VAU3tBw

* Include the CustomMsgbox library, which allows you to create custom message boxes.
* For more information, see https://github.com/Aaqil101/Custom-Libraries/tree/master/Custom%20Msgbox
*/

#Include CursorHandler.ahk
#Include CustomMsgbox.ahk

WINDOW_WIDTH        :=  250
WINDOW_HEIGHT       :=  280
FF_CREATION         :=  A_ScriptDir "\Lib\Icons\FF_Creation.png"
FF_ERROR            :=  A_ScriptDir "\Lib\Icons\FF_Error.png"

; Add Color Scheme
CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")

; Prompt the user to enter a name for the files
class FileManager {
    /**
     * @var string fileName - Stores the file name entered by the user.
     */
    static fileName := ""

    /**
     * Prompts the user to enter a file name if not already set or if forced by the caller.
     * @param bool forceInput - If true, the input prompt will be shown regardless of the current fileName state.
     * @return bool - Returns true if the file name is successfully set, false if the operation is cancelled.
     */
    static GetFileName(forceInput := false) {
        if (forceInput or this.fileName = "") {
            ; Prompt user for a file name
            fileName := InputBox("Please enter a File Name.", "File Name", "y720 w250 h100")
            if fileName.Result = "Cancel" {
                ; Handle cancellation by showing a custom message box
                TraySetIcon (FF_ERROR)
                msg := CustomMsgBox()
                msg.SetText("Operation cancelled", "File Name Input Cancelled.")
                msg.SetPosition(window_width + 240, window_height + 118)
                msg.SetColorScheme("Error")
                msg.SetOptions("ToolWindow", "AlwaysOnTop")
                msg.SetCloseTimer(1)
                msg.Show()
                TraySetIcon (FF_CREATION)
                return false
            }
            ; Set the file name
            this.fileName := fileName.Value
        }
        return true
    }

    /**
     * Clears the stored file name.
     */
    static ClearFileName() {
        this.fileName := ""
    }
}