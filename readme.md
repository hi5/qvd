# QuickView descript.ion viewer (QVD)

'Faux' [Total Commander Lister](https://www.ghisler.ch/wiki/index.php/Lister) plugin to view file comments stored in descript.ion files.  
(mimicking QuickView by overlaying edit control on the target panel)

It can be used in combination with QuickView: when QuickView is activated, the bottom half the panel is reserved for QVD.  
This can can be disable (setting QuickViewOff)

## Start

Setup a [button](https://www.ghisler.ch/wiki/index.php?title=Buttonbar), 
start menu or [usercmd entry](https://www.ghisler.ch/wiki/index.php?title=User-defined_command) (allows you to assign a [shortcut](https://www.ghisler.ch/wiki/index.php?title=Options#Misc.))
in TC to start the script while TC is running.  
Alternatively setup a [#IfWinActive](https://www.autohotkey.com/docs/commands/_IfWinActive.htm) AutoHotkey [hotkey](https://www.autohotkey.com/docs/Hotkeys.htm) to start QVD.

If the TC source directory does not contain a descript.ion file, QVD will display a warning and exit.

## Exit

QVD exits when:

* <kbd>TAB</kbd> or <kbd>Esc</kbd> are pressed
* Switching directories
* Tray menu: Right click, Exit

## Settings

Starting QVD for the first time will create a settings file (qvd.ini) in the Scripts directory.  
Edit manually (in notepad.exe or preferred text editor) to change settings.

**Keys:**

```ini
; Only set if it is not the TC ^q (ctrl+q)
; ^ = ctrl, + = shift, ! = alt, # = winkey.
QuickViewHotkey=
; QuickViewOff: to disable QuickView + half size set to 1 
QuickViewOff=

; name of font e.g. Segui, Arial, MS sans serif
Font=
; size in points e.g. 12
FontSize=

; color values in HTML RGB format or one of the available keywords:
; Aqua, Black, Blue, Fuchsia, Gray, Green, Lime, Maroon
; Navy, Olive, Purple, Red, Silver, Teal, White, Yellow
; (default black and white)
ForegroundColor=
BackgroundColor=
```

## Notes

Does not take into account:

* Custom panel widths in combination with QuickView - overlay will have incorrect dimensions in such cases
* Moving TC window once QVD is activated (GUI remains at start position)
* Update file comments if edited while QVD is active (restart required)
* TC's QuickView being active BEFORE starting QVD - it won't be able to set the view to half the height of the panel.

### Screenshots:

* Multiline file comment: https://github.com/hi5/_resources/blob/master/qvdmultilline.png
* Multiline file comment with QuickView: https://github.com/hi5/_resources/blob/master/qvdmultilline_qv.png


# Descript.ion Viewer (DV) - standalone

A standalone descript.ion files viewer using two panels (file list (left), file comment (right)).

To view a descript.ion file, start script and:

* Drag & Drop a folder on the GUI
* Drag & Drop a file on the GUI - it doesn't have to be a descript.ion file as it will look for a descript.ion file in the folder of the dropped file.
* or start with a folder as argument:  

> description_viewer.ahk c:\path\to\folder\

If a descript.ion file can not be found or read, QVD will display a warning message.

It will show all files listed in the descript.ion file. Use "File(s) Exist" checkbox to check which file(s) actually exist.  
An asterisk `*` infront of the file name indicates it is not present.

Use the mouse or <kbd>Up</kbd> and <kbd>Down</kbd> keys to browse the file list (left). <kbd>Esc</kbd> to close.

### Screenshot:

* descript.ion Viewer (standalone): https://github.com/hi5/_resources/blob/master/description_viewer.png

### Credits

* [Class_CtlColors.ahk](https://github.com/AHK-just-me/Class_CtlColors/tree/master/Sources) by just me
* [ListboxActions.ahk](https://www.autohotkey.com/board/topic/7471-list-of-filenames-selected-in-panel-of-total-commander/) by Crash&Burn

### License 

MIT License - Copyright (c) https://github.com/hi5
