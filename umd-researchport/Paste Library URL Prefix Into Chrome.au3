#comments-start 
; ----------------------------------------------------------------------------
By Keith Kranker
Originally Created Feb8, 2008
Added chrome Mar29,2010

See README.txt

This program will paste the prefix "http://proxy-um.researchport.umd.edu/login?url=" 
into the begining of the URL address bar that is currently active in Firefox. 
This prefix is the library's login page for sites like Jstor.org
; ----------------------------------------------------------------------------
#comments-end

Opt("WinTitleMatchMode", 2)
Opt("SendKeyDelay", 1)

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