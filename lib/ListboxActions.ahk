; Listbox Actions [suitable for Total Commander]
; Crash&Burn @ https://www.autohotkey.com/board/topic/7471-list-of-filenames-selected-in-panel-of-total-commander/
; Posted 05 October 2010

QueryActiveWinID(byRef aWin, winText="", excludeTitle="", excludeText="")
	{
	 if ((aWin || aWin:="A") && (aWin <> "A") && (subStr(aWin,1,4) <> "ahk_"))
		aWin:=((RegExMatch(subStr(aWin,1,1), "\d") && !InStr(aWin, " ")) ? "ahk_class " aWin : "ahk_id " aWin)
	 ;MsgBox, QAWID: %aWin%
	 Return aWin:=WinActive( aWin, winText, excludeTitle, excludeText )
	}

QueryFocusedCtrlID(byRef aControl, byRef aWin="", winText="", excludeTitle="", excludeText="")
	{
	 if (!aWin)
		QueryActiveWinID(aWin, winText, excludeTitle, excludeText)
	 if (!aControl)
		ControlGetFocus, aControl, ahk_id %aWin%, %winText%, %excludeTitle%, %excludeText%
	 ;MsgBox, QFC: %aControl%`naWin:%aWin%
	 ControlGet, aControl, HWND,, %aControl%, ahk_id %aWin%
	 Return aControl
	}

QueryMouseGetPosID(byRef aControl, byRef aCName="", byRef aWin="", byRef x="", byRef y="")
	{
	 MouseGetPos, x, y, aWin, aControl, 3
	 MouseGetPos,,,, aCName, 1
	 Return aControl
	}

LB_FindCursorPos(byRef cID)
	{
	 LB_GETCURSEL = 0x188
	 NULL = 0x0
	 SendMessage, LB_GETCURSEL, NULL, NULL,, ahk_id %cID%
	 ;MsgBox, EL: %ErrorLevel%
	 Return (ErrorLevel <> "FAIL" ? ErrorLevel + 1 : 0)
	}

LB_CountAllItems(cID)
	{
	 LB_GETCOUNT = 0x18B
	 NULL = 0x0
	 SendMessage, LB_GETCOUNT, NULL, NULL,, ahk_id %cID%
	 Return (ErrorLevel <> "FAIL" ? ErrorLevel : 0)
	}

LB_CountSelected(cID)
	{
	 LB_GETSELCOUNT = 0x190
	 NULL = 0x0
	 SendMessage LB_GETSELCOUNT, NULL, NULL,, ahk_id %cID%
	 Return (ErrorLevel <> "FAIL" ? ErrorLevel : 0)
	}

LB_QListSelected(cID, count="")
	{
	 LB_GETSELITEMS = 0x191
	 if (count=="" && !(count:=LB_CountSelected( cID )))
		return 0
	 VarSetCapacity(selectedList, count * 4, 0 )
	 SendMessage, LB_GETSELITEMS, %count%, &selectedList,, ahk_id %cID%
	 Return selectedList
	}

LB_QueryText(cID, cPos)
	{
	 LB_GETTEXT = 0x189
	 VarSetCapacity(text,4096+256) ; max length file comment (TC documentation) + assumed max length filename itself
	 SendMessage, LB_GETTEXT, % cPos - 1, &text,, ahk_id %cID%
	 Return text
	}

