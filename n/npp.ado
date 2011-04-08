*! $Id: personal/n/npp.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/07 00:05:20 (revision 64e69572e3d4 by user keith) $
*! Open something in Notepad++
*
*! By Keith Kranker
*! $Date$

program define npp
	version 9
	syntax [anything]
	winexec "C:\Program Files (x86)\Notepad++\notepad++.exe" `anything'
end
