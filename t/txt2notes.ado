*! $Id: personal/t/txt2notes.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! txt2notes reads in a text file and adds each line as "notes" for the dataset.
*
*! By Keith Kranker
*! $Date$

program define txt2notes, eclass 
	version 9.2 
	syntax [varname(default=none)] using 
	tempname readme	
	file open `readme' `using' , read
	file read `readme' line 
	noisily di as txt "+" _dup(110) "-" "+"
	while r(eof)==0 {
		noisily di as txt "|" as res `" `line' "'  _col(112) as txt "|"  
		if !missing(trim(`"`line'"')) notes `varlist' : `line'
		file read `readme' line
	}
	noisily di as txt "+" _dup(110) "-" "+"
	file close `readme'
end

