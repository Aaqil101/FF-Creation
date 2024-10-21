/************************************************************************
 * @description User input box for file names
 * @file FileManager.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/FF-Creation/blob/master/Lib/FileManager.ahk)
 * @created 2024-10-20
 * @version 2.5.0
 **************************************************************************/

#Include CursorHandler.ahk
#Include CustomMsgbox.ahk

WINDOW_WIDTH := 250
WINDOW_HEIGHT := 280
FF_CREATION := A_ScriptDir "\Lib\Icons\FF_Creation.png"
FF_ERROR := A_ScriptDir "\Lib\Icons\FF_Error.png"

; Add Color Scheme
CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")

; Prompt the user to enter a name for the files
class FileManager {
    static fileName := ""
    static hasPrompted := false
    static fileNames := Map()  ; Store different filenames for different paths

    /**
     * Gets a filename from user input for a specific path
     * @param string path - The path to get filename for
     * @param bool forceNew - If true, forces a new input regardless of existing filename
     * @return bool - Returns true if filename was set, false if cancelled
     */
    static GetFileName(path := "", forceNew := false) {
        ; If no path specified and we have a default filename, use that
        if (path == "" && !forceNew && this.fileName != "") {
            return true
        }

        ; If we have a cached filename for this path and don't want to force new, return it
        if (path != "" && !forceNew && this.fileNames.Has(path)) {
            this.fileName := this.fileNames[path]
            return true
        }

        ; Show input box
        fileName := InputBox("Please enter a File Name.", "File Name", "y720 w250 h100")
        
        if (fileName.Result = "Cancel") {
            TraySetIcon(FF_ERROR)
            msg := CustomMsgBox()
            msg.SetText("Operation cancelled", "File Name Input Cancelled.")
            msg.SetPosition(WINDOW_WIDTH + 240, WINDOW_HEIGHT + 118)
            msg.SetColorScheme("Error")
            msg.SetOptions("ToolWindow", "AlwaysOnTop")
            msg.SetCloseTimer(1)
            msg.Show()
            TraySetIcon(FF_CREATION)
            return false
        }
        
        this.fileName := fileName.Value
        if (path != "") {
            this.fileNames[path] := fileName.Value
        }
        this.hasPrompted := true
        
        return true
    }

    /**
     * Gets the filename for a specific path
     * @param string path - The path to get filename for
     * @return string - Returns the filename for the path, or the default filename
     */
    static GetCurrentFileName(path := "") {
        if (path != "" && this.fileNames.Has(path)) {
            return this.fileNames[path]
        }
        return this.fileName
    }

    /**
     * Resets all filenames and prompt status
     */
    static Reset() {
        this.fileName := ""
        this.hasPrompted := false
        this.fileNames := Map()
    }
}