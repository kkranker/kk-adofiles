*! .update-stata-folder.do
*! Publish Keith's stata files to http://code.google.com/p/kk-adofiles/

cap program drop pub2web
include "C:\Ado\personal\p\pub2web.ado"

cd "C:\Projects\code.google.com\kk-adofiles\"

pub2web pub2web, replace ///
	author( "Keith Kranker") ///
	intro( "Programs by Keith Kranker, Ph.D. Candidate, Department of Economics, University of Maryland")

view net from "`c(pwd)'"
