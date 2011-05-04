; paste_library_prefix.au3
; by Keith Kranker
; 5/2/2011
;
#comments-start 
 This program provides an icon in my (Windows Vista) system tray: 
 Right-click this icon to paste the prefix "http://proxy-um.researchport.umd.edu/login?url=" 
 into the begining of the URL address bar that is currently active in Firefox or Chrome
 This prefix is the library's login page for sites like Jstor.org

 To compile this script, you need to download ModernMenu (Modern tray menu)
 from <http://www.autoitscript.com/wiki/UDF>  
 and unzip into <C:\Program Files\AutoIt3\Extras\ModernMenu>
#comments-end

#include <GUIConstants.au3>
#include <..\Extras\ModernMenu\ModernMenuRaw.au3>   
#NoTrayIcon


Opt("WinTitleMatchMode", 2)
Opt("SendKeyDelay", 1)


; *** Create the dialog ***
GUICreate("Paste UMD Library Prefix", 220, 160)
$Button_1 = GUICtrlCreateButton("Firefox", 10, 10, 200, 50)
$Button_2 = GUICtrlCreateButton("Chrome", 10, 70, 200, 50)
$Button_3 = GUICtrlCreateButton("Switch Chrome to Firefox", 10, 10, 200, 50)


; *** Create the tray icon ***
$nTrayIcon1		= _TrayIconCreate("Right-click this icon to paste the University of Maryland prefix into Firefox or Chrome",  _
	"C:\Projects\Scripts\paste_library_prefix.ico")
_TrayIconSetClick(-1, 16)
_TrayIconSetState() ; Show the tray icon



; *** Create the tray context menu ***
$nTrayMenu1		= _TrayCreateContextMenu() 

$Tray_1		= _TrayCreateItem("Firefox")   ; item 1
_TrayItemSetIcon($Tray_1, "C:\Program Files (x86)\Mozilla Firefox\firefox.exe")

$Tray_2		= _TrayCreateItem("Chrome")   ; item 2
_TrayItemSetIcon($Tray_2, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")

$Tray_3		= _TrayCreateItem("Switch Chrome to Firefox")   ; item 3
_TrayItemSetIcon($Tray_3, "C:\Projects\Scripts\paste_library_prefix_arrow.ico")

_TrayCreateItem("")                                   ; horizontal line
_TrayItemSetIcon(-1, "", 0)

$Tray_X		= _TrayCreateItem("Exit")             ; exit
_TrayItemSetIcon($Tray_X, "shell32.dll", -28)

; Main GUI Loop
While 1
	$Msg = GUIGetMsg()
	
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $Tray_X
			ExitLoop

		Case $Tray_1, $Button_1
			$BrowserWin =  "- Mozilla Firefox"
			; Verify that Firefox is open.  Switch to it if needed.  Otherwise, stop script.
			If WinExists($BrowserWin) Then
				WinActivate($BrowserWin)
				WinWaitActive($BrowserWin, "", 5)
				; Use ctrl-L/home to go to beginning of URL
				; Then paste in this prefix and hit enter.
				ClipPut("http://proxy-um.researchport.umd.edu/login?url=")
				Send("^l" & "{Home}" & "^v" & "{ENTER}")
			Else
				MsgBox(0, "", "Mozilla Firefox is not active")
				Exit
			EndIf

		Case $Tray_2, $Button_2
			$BrowserWin =  "- Google Chrome"
			; Verify that Crhome is open.  Switch to it if needed.  Otherwise, stop script.
			If WinExists($BrowserWin) Then
				WinActivate($BrowserWin)
				WinWaitActive($BrowserWin, "", 5)
				; Use ctrl-L/home to go to beginning of URL
				; Then past in this prefix and hit enter.
				ClipPut("http://proxy-um.researchport.umd.edu/login?url=http://")
				Send("^l" & "{Home}" & "^v" & "{ENTER}")
			Else
				MsgBox(0, "", "Google Chrome is not available")
				Exit
			EndIf		

		Case $Tray_3, $Button_3
			$BrowserWin1 =  "- Google Chrome"
			$BrowserWin2 =  "- Mozilla Firefox"
			; Verify that browsers #1/#2 are both open.  Otherwise, stop script.
			If WinExists($BrowserWin1) & WinExists($BrowserWin2) Then
				
				; Switch to browser #1
				WinActivate($BrowserWin1)
				WinWaitActive($BrowserWin1, "", 5)
				; Select URL & Copy
				Send("^l" & "^c")
				$url = ClipGet()
				; Add URL, with prefix, to clipboard
				ClipPut("http://proxy-um.researchport.umd.edu/login?url=" & $url )
				; Close tab in browser #1
				Send("^w" )
				MsgBox(0, "Clipboard contains:", ClipGet())
				; Switch to browser #2				
				WinActivate($BrowserWin2)
				WinWaitActive($BrowserWin2, "", 5)
				; Create new tab, go URL box, paste url & hit ENTER
				Send("^t" & "^l" & "^v" & "{ENTER}")

			Else
				MsgBox(0, "", "Google Chrome and/or Mozilla Firefox not available. Open both browsers.")
				Exit
			EndIf		

	EndSwitch
WEnd

Exit
