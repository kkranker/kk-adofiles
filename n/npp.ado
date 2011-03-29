*! $Id: personal/n/npp.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Open something in Notepad++
*
*! By Keith Kranker
*! $Date$


program define npp
	version 9
	syntax [anything]
	winexec C:\PROGRA~1\NOTEPA~1\NOTEPA~1.EXE `anything'
end
