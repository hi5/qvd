/*
Ini settings for qvd
*/

Ini_Setup() {
FileAppend, 
(join`r`n
[Settings]
; Only set if it is not the TC ^q (ctrl+q)
; ^ = ctrl, + = shift, ! = alt, # = winkey.
QuickViewHotkey=
; QuickViewOff: to disable QuickView + halfsize set to 1 
QuickViewOff=

; name of font e.g. Segui, Arial, MS sans serif
Font=
; size in points e.g. 12
FontSize=

`; color values in HTML RGB format or one of the available keywords:
`; Aqua, Black, Blue, Fuchsia, Gray, Green, Lime, Maroon
`; Navy, Olive, Purple, Red, Silver, Teal, White, Yellow
`; (default black and white)
ForegroundColor=
BackgroundColor=
), %A_ScriptDir%\qvd.ini, UTF-16
Sleep 200
}

Ini_Read()
	{
	 Global QuickViewHotkey,QuickViewOff,Font,FontSize,ForegroundColor,BackgroundColor
	
	 IniRead, OutputVarSection, %A_ScriptDir%\qvd.ini, settings
	 Loop, parse, OutputVarSection, `n, `r
		{
		 key:=Trim(StrSplit(A_LoopField,"=").1," `t")
		 value:=Trim(StrSplit(A_LoopField,"=").2," `t")
		 %key%:=value
		}
	}
