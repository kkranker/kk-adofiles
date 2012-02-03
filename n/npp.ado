*! $Id: personal/n/npp.ado, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $
*! Open something in Notepad++
*
*! By Keith Kranker
*! $Date$

program define npp
	version 9
	cap winexec "C:\Program Files (x86)\Notepad++\notepad++.exe"   `0'
	cap winexec "C:\Program Files\Notepad++\notepad++.exe" `0'
end
