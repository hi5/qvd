/*

Script      : Descript.ion viewer
Version     : v1.00
Author      : hi5
Last update : 10 July 2022
Purpose     : Standalone viewer of Descript.ion files using two panels (file list (left), file comment (right))
              Start scrip and Drag & Drop a folder on the GUI, or start with a folder as argument
              e.g. description_viewer.ahk c:\path\to\folder\
Source      : https://github.com/hi5/qvd

Background  : A DESCRIPT.ION file is used to store file descriptions or comments.
              This file is created as a hidden file in each subdirectory which has descriptions.
              more info https://web.archive.org/web/20160318122322/https://jpsoft.com/ascii/descfile.txt
              (Also used by Total Commander)

*/

#NoEnv
#SingleInstance, Off
SetBatchLines, -1
SetTitleMatchMode, 2

; <for compiled scripts>
;@Ahk2Exe-Let vn=1.00
;@Ahk2Exe-SetDescription Descript.ion viewer (standalone)
;@Ahk2Exe-SetCopyright MIT License - Copyright (c) https://github.com/hi5
; </for compiled scripts>

; <for compiled scripts>
IfNotExist, %A_ScriptDir%\res
	FileCreateDir, %A_ScriptDir%\res
FileInstall, res\ion.ico, %A_ScriptDir%\res\ion.ico
; </for compiled scripts>


; try to get Commander_Path, it will be empty if TC is not running (yet)
EnvGet, Commander_Path, Commander_Path

If (Commander_Path = "") ; try to read registry
	 RegRead Commander_Path, HKEY_CURRENT_USER, Software\Ghisler\Total Commander, InstallDir

Try
	Menu, Tray, Icon, res\ion.ico

AppTitle:="descript.ion Viewer (standalone)"

Gui +HwndDVGuiHwnd
Gui, Add, Listbox   , x3 y3 w300 h255 vFileID gClick AltSubmit, % SourceFilesList
Gui, Add, Edit      , xp+302 yp w500 h269 hwndED1, % SourceFiles[1].comment
If A_Args[1]
	folder:=Description_Parse(Description_GetPath(A_Args[1]))
else
	folder:=Description_Parse(Description_GetPath(Commander_Path "\descript.ion"))
Gui, Add, Checkbox  , x3 yp+255 vCheckFiles gCheckFilesAction, File(s) exist (* = missing)
Gui, Add, Text      , xp+150 yp, % SourceFiles.Length() " file(s) with comments."
Gui, Show, w807 h275, %AppTitle%
GuiTitle(folder)
Return

CheckFilesAction:
Gui, Submit, NoHide
SourceFilesList:=""
If (folder = "") or (folder = "Error")  ; we dropped file/folder which wasn't a descript.ion file or folder with a descript.ion file
	{
	 WinGetTitle, currentfolder, ahk_id %DVGuiHwnd%
	 currentfolder:=Trim(StrSplit(currentfolder,"[").2,"]")
	 SplitPath, currentfolder, , folder
	 currentfolder:=""
	 folder .= "\"
	}
If CheckFiles
	{
	 for k, v in SourceFiles
		{
		 If FileExist(folder SourceFiles[k].FileName)
			SourceFilesList .= SourceFiles[k].FileName "|"
		 else
			SourceFilesList .= "*" SourceFiles[k].FileName "|"
		}
	}
Else
	{
	 for k, v in SourceFiles
		SourceFilesList .= SourceFiles[k].FileName "|"
	}
GuiControl, ,FileID, % "|" SourceFilesList
Return

GuiDropFiles:
folder:=Description_Parse(Description_GetPath(A_GuiEvent))
GuiTitle(folder)
Return

Click:
Gui, Submit, NoHide
GuiControl, ,Edit1, % StrReplace(SourceFiles[FileID].comment,"\n","`n")
Return

GuiTitle(folder)
	{
	 Global DVGuiHwnd,AppTitle,CheckFiles
	 If (Folder = "Error")
		Return
	 WinSetTitle, ahk_id %DVGuiHwnd%, , %AppTitle% - [%folder%descript.ion] 
	 If CheckFiles
	 	Gosub, CheckFilesAction
	}

#IfWinActive descript.ion Viewer (standalone)
Esc::
GuiClose:
ExitApp
#IfWinActive
