/*
Shared functions for:

qvd.ahk
description_viewer.ahk
*/

Description_Parse(in)
	{
	 Global SourceFiles
	 OldSourceFiles:=SourceFiles
	 SourceFiles:={}
	 SourceFilesList:=""
	 FileRead, SourceDescription, %in%
	 If ErrorLevel
		{
		 Description_ErrorMessage(in)
		 SourceFiles:=OldSourceFiles ; so we can rebuild the same listbox/edit contents after dropping invalid descript.ion file/path
		 Return "Error"
		 Exit
		}
	 Loop, parse, SourceDescription, `n, `r
		{
		 If (Trim(A_LoopField) = "")
			continue
		 SourceFiles.Push(Description_GetFileComment(A_LoopField))
		 SourceFilesIndex[SourceFiles[A_Index].FileName]:=A_Index
		 SourceFilesList .= SourceFiles[A_Index].FileName "|"
		}
	 GuiControl, ,FileID, % "|" SourceFilesList
	 GuiControl, ,Edit1, % StrReplace(SourceFiles[1].comment,"\n","`n")
	 GuiControl, , Static1, % SourceFiles.Length() " file(s) with comments."
	 SplitPath, in, , OutDir
	 Return OutDir "\"
	}

Description_GetPath(path)
	{
	 Error:=0
	 If (FileExist(path) = "D")
		path:=path "\descript.ion"
	 SplitPath, path, OutFileName, OutDir
	 If (OutFileName <> "descript.ion") 
		path:=OutDir "\descript.ion"
	 If !FileExist(path)
		Error:=1
	 If Error
		{
		 Description_ErrorMessage(path)
		 Return
		}
	 Return path
	}

Description_GetFileComment(line)
	{
	 static q:=""""
	 if (SubStr(line,1,1) = q)
		{
		 FileName:=Trim(SubStr(line,1,InStr(line,q,,2)),q)
		 Comment:=Trim(SubStr(line,InStr(line,q,,2)),q " ")
		}
	 else
		{
		 FileName:=Trim(SubStr(line,1,InStr(line," ")))
		 Comment:=SubStr(line,InStr(line," ")+1)
		}
	 obj:=[]

	 if InStr(Comment,Chr(4)) ; we need to remove EOT (Chr(4) and Â)
		{
		 Comment:=SubStr(Comment,1,StrLen(Comment)-2)
		}

	 obj["FileName"]:=FileName
	 obj["Comment"]:=Comment
	 Return obj
	}

; Error message for both apps, QVD uses ExitApp
Description_ErrorMessage(path)
	{
	 global AppTitle,folder
	 if !path
		{
		 folder:=""
		 Return
		}
	 MsgBox, 16, %AppTitle% - Error, Not Found or Read Error:`n%path%
	 If (AppTitle = "descript.ion Viewer (standalone)")
		{
		 folder:=""
		 Sleep 500
		 Return
		}
	 else 	
		ExitApp
	 Sleep 100
	}

#include %A_ScriptDir%\lib\Description.ahk
