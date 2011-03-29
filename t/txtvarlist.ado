*! $Id: personal/t/txtvarlist.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/28 23:50:32 (revision ab479be1b999 by user keith) $
*! Export a varlist to a text file.
*
*! By Keith Kranker
*! $Date$
*! 
*! csvvars.ado

program define txtvarlist, eclass 

version 9.2 
syntax [varlist] [using] ///
	[, ///
		LABels /// export labels too (one line per row)
		noquotes /// don't quotes around variable labels 
		csv /// parse(",") labels, and quotes
		Handle(name) Replace noAppend ///  output file
		Global(name) Local(name) Prefix(string asis) Suffix(string asis) /// text before/after varlist
		parse(string asis) VARPrefix(string) VARSuffix(string) /// text before/after/between variables
	]  

	* Open file for writing 
	if strlen("`handle'") {
		* Case with handle declared --> just check for a "using" file too
		if strlen("`using'")!=0 {
			di as err "You cannot specify both the -using- and -handle- options at the same time."
			exit
		}
	}
	else if strlen("`using'")!=0 {
		* Case with a filename " "
		tempname handle 
		if (strlen("`append'")==0 & strlen("`replace'")==0) local append "append" // "Append" by default 
		file open `handle' `using' , write text `append' `replace'
	}
	else {
		* No filename
		noisily di as err "You must declare either the -using- or -handle- option."
		exit
	}
	
	if !missing("`labels'") & (!missing("`global'") | !missing("`local'")) {
		di as error "-labels- is not allowed with -global-/-local-"
		error 198
	}
	
	
	* no labels --> Parsing character is a space by default
	* w/ labels --> Parsing character is a _tab by default
	if !missing("`csv'") {
		if (!missing(`"`parse'"') | !missing(`"`quotes'"')) di as error "-csv- option overrides -parse(`parse')- and turns off noquotes"
		local parse `"",""'
		local quotes ""
		local labels "labels"
	}
	else if missing(`"`parse'"') {
		if !missing("`labels'") local parse `" _tab "'
		else                    local parse `"" ""'
	}
		
	if  (strlen("`global'") | strlen("`local'")) {
		* Global & Local options
		if  strlen("`global'") {
			file write `handle' "global `global' "
			foreach var of local varlist {
				file write `handle' "`varprefix'`var'`varsuffix'"    // write variable with prefix+varname+suffix
				if strlen("`ferest()'") file write `handle' `parse'  // write parsing character if more variables
			}
			file write `handle' _n
		}
		if  strlen("`local'") {
			file write `handle' "local  `local' " 
			foreach var of local varlist {
				file write `handle' "`varprefix'`var'`varsuffix'"    // write variable with prefix+varname+suffix
				if strlen("`ferest()'") file write `handle' `parse'  // write parsing character if more variables
			}
			file write `handle' _n
		}
		if (strlen(`"`prefix'"') | strlen(`"`suffix'"')) di as err "Warning: The prefix() and suffix() options were ignored."
	}
	else {
		* Otherwise, output Prefix/Suffix and Variable list
		if  strlen(`"`prefix'"') {
			file write `handle' `prefix'
		}
		foreach var of local varlist {
			file write `handle' "`varprefix'`var'`varsuffix'"    // write variable with prefix+varname+suffix
			if !missing("`ferest()'") file write `handle' `parse'  // write parsing character if more variables
			if !missing("`labels'") {
				if missing("`quotes'") file write `handle' `""`:var lab `var''""' _newline // write variable label then new line
				else                   file write `handle' `"`:var lab `var''"' _newline 
			}
		}
		if  strlen(`"`suffix'"')	{
			file write `handle' `suffix'
		}
		file write `handle' _n
	}

	* Close file
	if strlen("`using'") {
		// if USING option, close the file  and provide links to output
		file close `handle'
		gettoken ucmd filename : using 
		local         filename `filename'

		di as txt "Include file: {space 4}" `"{stata `"include "`filename'""'}"'
		if strlen("`global'") | strlen("`local'") {
			di as txt "Run file: {space 8}"      `"{stata `"do "`filename'""'}"'
			
		}		
		else {
			di as txt "Open output file: " `"{stata `"shellout using "`filename'""'}"'
			di as txt "View output file: " `"{view `""`filename'""':view "`filename'"}"'
		}
	}
	else {
		// HANDLE option leaves the file open with a short note
		di as txt "Matrix written to file handle: " as res "`handle'"
	}	
	
end

