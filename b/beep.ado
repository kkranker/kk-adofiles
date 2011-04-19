*! $Id: personal/b/beep.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Send a "beep" to your computer speakers (Windows only)
*!
*! By Keith Kranker
*! $Date$

program define beep
   !rundll32 user32.dll,MessageBeep MB_ICONQUESTION
end 
