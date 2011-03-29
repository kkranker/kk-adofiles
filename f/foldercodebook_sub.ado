*! $Id: personal/f/foldercodebook_sub.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Automatic codebook creation for folder & subfolders
*!
*! By Keith Kranker
*! $Date$


program define foldercodebook_sub
	version 8.2
	
	local orig_folder `"`c(pwd)'"'
	
	cap log close logfoldercodebook_sub
	log using "! Codebook of dta files in folder and subfolders.txt" , replace text name(logfoldercodebook_sub)

	di _n as text "* * * * * * * * * " _n "*               *" _n "*  FOLDER LIST  *" _n "*               *" _n "* * * * * * * * * " _n 
	
	folders
	
	local folderlist `" `r(folders)' "'

	di as text "The program -foldercodebook- will be run for the following folders: " _n 
	di 	`"`orig_folder'"'
	if "`folderlist'" != "" {
		foreach i of local folderlist {
			di 	`"`orig_folder'\\`i'"'
		}
	}

	local boxlength = length("`c(pwd)'") + 4
	di _n _n _n as text "*" _dup( `boxlength') "*" "*" _n "*" _dup( `boxlength') " " "*" _n `"*  `c(pwd)'  *"' _n "*" _dup( `boxlength') " " "*" _n "*" _dup( `boxlength') "*" "*"

	foldercodebook, fast 
	

	if "`folderlist'" != "" {
		foreach i of local folderlist {
			qui cd 	`"`orig_folder'\\`i'"'

			local boxlength = length("`c(pwd)'") + 4
			di _n _n _n as text "*" _dup( `boxlength') "*" "*" _n "*" _dup( `boxlength') " " "*" _n `"*  `c(pwd)'  *"' _n "*" _dup( `boxlength') " " "*" _n "*" _dup( `boxlength') "*" "*"

			foldercodebook, fast 
		}
	}
	qui cd 	`"`orig_folder'"'
	
	log close logfoldercodebook_sub
	view "! Codebook of dta files in folder and subfolders.txt"

end
