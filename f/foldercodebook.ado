*! $Id: personal/f/foldercodebook.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Automatic codebook creation
*!
*! By Keith Kranker
*! $Date$

* Note: This file is based on code in Nicholas J. Cox's "fs" package.  

/*
 version 1.0  25apr2008
 version 1.1  15jul2008  Added  "notes"
 version 1.2  20aug2008  Reordered output; added foldercodebook_sub to the package
 version 1.3  25sep2008  Added veryfast option
 other versions under revision control
*/


return clear

program foldercodebook, rclass   
	version 8
	syntax [anything] [, Fast Veryfast FILE(string) noLABels]
	
	if `"`anything'"' == "" local anything *
	foreach f of local anything {
		if index("`f'", "/") | index("`f'", "\") ///
		 | index("`f'", ":") | inlist(substr("`f'", 1, 1), ".", "~") { 
			ParseSpec `f'
			local files : dir "`d'" files "`f'"
		}
		else local files : dir . files "`f'"
		local Files "`Files'`files' " 
	} 	

	if trim(`"`Files'"') != "" { 
			
		preserve
		cap log close logfoldercodebook
		
		if (`"`file'"' == "") local file "! Codebook of dta files in folder.txt"
		log using "`file'" , replace text name(logfoldercodebook)
		
		di _n as text "+---------------------+" _n "|                     |" _n "|  TABLE OF CONTENTS  |" _n "|                     |" _n "+---------------------+" 
		di _n _n as text "CODEBOOK OF DATABASE FILES (.dta) IN " as res "`c(pwd)'" as text "  " _n "Last Updated " as res "$S_DATE ($S_TIME)" _n _n as text "Files included in this codebook: " _n

		foreach f2 in `Files' {  
			if strpos("`f2'",".dta") == 0 continue
			dir "`f2'"
		}
		
		foreach f2 in `Files' {  
			if strpos("`f2'",".dta") == 0 continue
			local boxlength = length("`f2'") + 4
			di _n _n _n as text "+" _dup( `boxlength') "-" "+" _n "|" _dup( `boxlength') " " "|" _n `"|  `f2'  |"' _n "|" _dup( `boxlength') " " "|" _n "+" _dup( `boxlength') "-" "+"
			if ("`veryfast'" == "veryfast" ) {
				desc using "`f2'" 
				}
			else {
				if ("`fast'" == "fast" ) {
					
					describe, fullnames
					notes
					di _n "Simple Summary Statistics: "
					summarize
					}
				else {
					qui use "`f2'" , clear
					describe, short
					codebook, compact 
					notes
					}	
				if "`labels'" != "labels" {
					label list _all
					}
				}	
			}
		di _n _n _n 
		log close logfoldercodebook
		view "`file'"
		drop _all 
		return local files `"`Files'"' 
		
	}	
end 	


// Identical to the ParseSpec section of the code in "fs" by Nick Cox
program ParseSpec
	args f 

	// first we need to strip off directory or folder information 

	// if both "/" and "\" occur we want to know where the 
	// last occurrence is -- which will be the first in 
	// the reversed string 
	// if only one of "/" and "\" occurs, index() will 
	// return 0 in the other case 
	
	local where1 = index(reverse("`f'"), "/")
	local where2 = index(reverse("`f'"), "\") 
	if `where1' & `where2' local where = min(`where1', `where2') 
	else                   local where = max(`where1', `where2') 

	// map to position in original string and 
	// extract the directory or folder 
	local where = min(length("`f'"), 1 + length("`f'") - `where') 
	local d = substr("`f'", 1, `where') 

	// absolute references start with "/" or "\" or "." or "~" 
	// or contain ":"  
	local abs = inlist(substr("`f'", 1, 1), "/", "\", ".", "~") 
	local abs = `abs' | index("`f'", ":")
	
	// prefix relative references 
	if !`abs' local d "./`d'" 
	
	// fix references to root 
	else if "`d'" == "/" | "`d'" == "\" { 
		local pwd "`c(pwd)'" 
		local pwd : subinstr local pwd "\" "/", all 
		local d = substr("`pwd'", 1, index("`pwd'","/"))
	} 

	// absent filename list 
	if "`f'" == "`d'" local f "*"
	else              local f = substr("`f'", `= `where' + 1', .)

	//  return to caller
	c_local f "`f'"
	c_local d "`d'" 
end 
