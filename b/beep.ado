*! $Id: personal/b/beep.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Send a "beep" to your computer speakers (Windows only)
*!
*! By Keith Kranker
*! $Date$

program define beep
   !rundll32 user32.dll,MessageBeep MB_ICONQUESTION
end 
