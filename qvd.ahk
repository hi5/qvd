/*

Script      : qvd.ahk for Total Commander
Version     : v1.00
Author      : hi5
Last update : 10 July 2022
Purpose     : 'Faux' lister plugin to view file comments stored in descript.ion files
              (mimicking QuickView by overlaying edit control on the target panel)
Source      : https://github.com/hi5/qvd

*/

#SingleInstance, force
#HotkeyInterval 2000       ; This is the default value (milliseconds).
#MaxHotkeysPerInterval 200
#NoEnv
SetBatchLines, -1

; <for compiled scripts>
;@Ahk2Exe-Let vn=1.00
;@Ahk2Exe-SetDescription QuickView descript.ion viewer
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

AppTitle:="QuickView descript.ion viewer"

If !FileExist(A_ScriptDir "\qvd.ini")
	Ini_Setup()

Ini_Read()

; Set defaults
ForegroundColor:=ForegroundColor ? ForegroundColor : "Black" 
BackgroundColor:=BackgroundColor ? BackgroundColor : "White" 
QuickViewHotkey:=QuickViewHotkey ? QuickViewHotkey : "^q"

aWin:=QueryActiveWinID(aWin)

GroupAdd, TCQVDGroup, ahk_id %aWin%

Hotkey, IfWinActive, ahk_group TCQVDGroup
Hotkey, $%QuickViewHotkey%, QuickViewAction
Hotkey, IfWinActive

HalfSize:=0

If WinActive("ahk_exe TOTALCMD64.exe")
	sPath:="Window5"
Else If WinActive("ahk_exe TOTALCMD.exe")
	sPath:="TMyPanel3"

ControlGetText StartPath, %sPath%, ahk_group TCQVDGroup

Description_Parse(Description_GetPath(StrReplace(StartPath,">") "\descript.ion"))

cm_FocusSrc=4005 ; Focus on source file list
SendMessage 1075, %cm_FocusSrc%, 0, , ahk_group TCQVDGroup

ControlGetFocus, activePanel, ahk_group TCQVDGroup
activePanel:=(SubStr(activePanel, 0, 1) - 1) ? "TMylistBox1" : "TMylistBox2"

ControlGetPos, X, Y, Width, Height, %activePanel%, ahk_group TCQVDGroup
WinGetPos, XT, YT, , , ahk_group TCQVDGroup
X+=XT
Y+=YT
Width:=Round(Width/(A_ScreenDPI/96))
Height:=Round(Height/(A_ScreenDPI/96))
StartHeight:=Round(Height*(A_ScreenDPI/96))
HalfHeight:=Round((Height/2)*(A_ScreenDPI/96))
YStart:=Y
YHalf:=Y+HalfHeight
Gui, -Caption -Border +AlwaysOnTop +Toolwindow
If font
	Gui, font, , %Font%
If FontSize
	Gui, font, s%fontsize%
Gui, Add, Edit, hwndEditID x0 y0 w%Width% h%Height%, no comment
If ForegroundColor or BackgroundColor
	CtlColors.Attach(EditID, BackgroundColor, ForegroundColor)

Gui, Show, NA x%X% y%Y% w%Width% h%Height%, %AppTitle%
UpdateComment(GetFileName())
SetTimer, CheckActive, 200
Return

#IfWinActive, ahk_group TCQVDGroup
~Down::
~PgDn::
~Up::
~PgUp::
~End::
~Home::
~LButton::
~Ins::
;BlockInput, On
UpdateComment(GetFileName())
;BlockInput, Off
Return
#IfWinActive

#IfWinActive, ahk_group TCQVDGroup
~Tab::
~Esc::
GuiClose:
ExitApp
#IfWinActive

QuickViewAction:
;$^q::
If (QuickViewOff = 1)
	Return
HalfSize:=!HalfSize
If HalfSize
	{
	 Height:=HalfHeight
	 Y:=YHalf
	}
Else
	{
	 Height:=StartHeight
	 Y:=YStart
	}
WinMove, %AppTitle%, , %X%, %Y%, , %Height%
ControlMove, Edit1, , , , %Height%, %AppTitle%
cm_SrcQuickview=304 ; Source: Quick view panel
SendMessage 1075, %cm_SrcQuickview%, 0, , ahk_group TCQVDGroup
Return

GetFileName()
	{
	 Sleep 50
	 Critical, On
	 aControl:=QueryFocusedCtrlID(aControl)
	 cpos:=LB_FindCursorPos(aControl)
	 if !cpos ; unsure why but each 2nd time it is 0 (zero) so try again to make it work
		{
		 aControl:=QueryFocusedCtrlID(aControl)
		 cpos:=LB_FindCursorPos(aControl)
		}
	 File:=StrSplit(LB_QueryText(aControl, cpos),A_Tab).1
	 ;Tooltip, % cpos ">" File "<" ; debug
	 Critical, Off
	 Return File
	}

UpdateComment(in)
{
Global
found:=0
for k, v in SourceFiles
	if (v.filename = in)
	{
	 GuiControl, ,Edit1, % StrReplace(v.comment,"\n","`n")
	 found:=1
	 break
	}
if !Found
	GuiControl, ,Edit1,
}


CheckActive:
IfWinActive, %AppTitle% ; if we scroll in the edit control
	Return
IfWinNotActive, ahk_group TCQVDGroup
;	ExitApp
	{
	 IfWinExist, %AppTitle%
	 Gui, Hide
	}
Else
	{
	 IfWinNotExist, %AppTitle%
	 Gui, Show, NA
	}
ControlGetText CurrentPath, %sPath%, ahk_group TCQVDGroup
If (StartPath <> CurrentPath)
	ExitApp
Return

#include %A_ScriptDir%\lib\ListboxActions.ahk
#include %A_ScriptDir%\lib\Class_CtlColors.ahk
#include %A_ScriptDir%\lib\Description.ahk