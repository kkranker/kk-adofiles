*! $Id: personal/f/foldergraphexport.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Automatic graph conversion of a n entire folder
*!
*! By Keith Kranker
*! $Date$

program define foldergraphexport, rclass   

version 9.2
syntax [anything(name=folder id="directory")] [, Find(string) as(namelist) nodrop Noisily scheme(passthru) undo *]

if length(`"`folder'"')    local folder `folder'
if length(`"`folder'"')==0 local folder "."
if regexm( trim(`"`folder'"'), "[\\]$" ) == 0 local folder `"`folder'\"'

if length("`as'")==0  local as "png"
if length("`find'")==0 local find "*.gph"
	
local files : dir "`folder'" files "`find'"

if length("`noisily'") {
	local c_pwd = c(pwd)
	qui cd `"`folder'"'
	di as input `"> . dir `find' "'
	dir `find'
	qui cd `"`c_pwd'"'
	}

if `"`files'"' == "" {
	di as error `"No files matching "`find'" in `folder'"'
	error 601
}
	
if "`undo'"=="undo" {
	foreach f in `files' {
		local filename = `"`folder'"' + `"`f'"'
		if regexm( `"`f'"', "[gG][pP][hH]$" ) == 0 {
			di as error "-undo- option requires that only are searching/finding .gph files"
			error 601
		}
		foreach ext in `as' {
			local filedest = subinstr(`"`filename'"',".gph",".`ext'",1)
			cap confirm file `"`filedest'"' 
			if !_rc {
				di as input `"> . erase `"`filedest'"'  "'
				erase `"`filedest'"'   
			}
		}
	}
}
else {
	local c = 0
	foreach f in `files' {
		local filename = `"`folder'"' + `"`f'"'
		local c = `c'+1
		tempname g`c'

		if regexm( `"`f'"', "[gG][pP][hH]$" ) == 0 di as input `"[`f']: "' as error "Program will attempt to use file even though an error is expected. (The file does not have a .gph file extension).  Try fixing any errors with the find() option."
		if length("`noisily'") di as input `"> . graph use    `"`filename'"' , `scheme'"'
		graph use `"`filename'"' , `scheme' name(`g`c'')
		foreach ext in `as' {
			local filedest = subinstr(`"`filename'"',".gph",".`ext'",1)
			if length("`noisily'") di as input `"> . graph export `"`filedest'"', `options' "'
			graph export `"`filedest'"', `options' name(`g`c'') 
		}
	if "`drop'"!="nodrop" graph drop `g`c''
	}
}

end
