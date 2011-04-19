*! $Id: personal/n/npp.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Open something in Notepad++
*
*! By Keith Kranker
*! $Date$

program define npp
	version 9
	syntax [anything]
	winexec "C:\Program Files (x86)\Notepad++\notepad++.exe" `anything'
end
