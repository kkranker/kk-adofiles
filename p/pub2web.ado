*! $Id: personal/p/pub2web.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Turn a list of your .ado packages into a "usersite" website.

* Input a list of your .ado programs
* For each program "package_name"
* 1. create a package_name.pkg file for a stata usersite
* 2. search for files named package_name* (in PERSONSAL or another directory)
* 2. copy files to "using" directory
* 3. description for .pkg file comes from all lines at top of .ado file beginning with "//" or "*"
* 4. add files to a all.pkg package.
* Then, create a stata.toc "table of contents" file for a stata usersite w/ links to all the packages
*   
* required packages: fs 
*
* See {help usersite} for more info
*
* By Keith Kranker
* $Date: 2011/03/28 16:36:00 $

program define pub2web

syntax ///
	anything(name=pck_list)  /// list of packages
	[using/ ]  /// folder that will contain output files
		, Author(string) /// author's name
		[ ///
		From(string asis) /// folder containing packages. Default is c(sysdir_personal). Files should be in `from' or in `from'/x  (where x is the first letter in package's name)
		replace /// overwrite files
		noSUBfolders /// don't put files in subfolders.
		noCopy /// do not copy files/
		Intro(string) /// add an introduction to your stata.toc file
		Width(integer 80) /// max width of text files
		Cline(integer 2) /// comment line #__ of .ado file has title of package cline is first line printed into .pkg file
		maxintro(integer 40) /// max number of intro lines in .pkg file
		]  
	
local pwd = c(pwd) 
tempname toc all looppkg

// output dir
if missing("`using'") {
	local using = c(pwd)
	di as txt "No -using- folder. pub2web will use " as res `"using ""' c(pwd) `"""'
}
if regexm("`using'","(.*)(\\|\/)$") local using = regexs(1) // remove trailing slash

// input dir
if missing("`from'") {
	local from = c(sysdir_personal)
	di as txt "No from() option. pub2web will use " as res `"from(""' c(pwd) `")""'
}
di as input "| . cd " _c 
cd `"`from'"'

if "`using'"=="`from'" {
	di as error ""`using'"=="`from'". -nocopy- option was turned on.
	local copy = "nocopy"
}

// Start stata.toc file
file open `toc' using `"`using'/stata.toc"', write text `replace'

file write `toc' "v 3" _newline `"d Stata programs by `author'"' _newline 
while !missing(`"`intro'"') {
	file write `toc' "d " (substr(`"`intro'"',1,`width')) _newline
	local intro = substr(`"`intro'"',`width',.)
}
file write `toc'  "d" _newline "d Last updated: ${S_DATE}" _newline(2)

// Start all.pkg
file open  `all' using `"`using'/all.pkg"', write text `replace'
file write `all' "v 3" _newline `"d all. Bulk download all Stata program(s) by `author'"' _newline `"d Program(s) by `author'"' _newline "d Bulk download all Stata programs" _newline "d" _newline "d Last updated: ${S_DATE}" _newline(2)

file write `toc' `"p all Bulk download all Stata program(s) by `author'"' _newline

// loop thru packages
foreach pkg of local pck_list {
	di as txt _n "`pkg': " _
	mac drop _files _subfiles
	local p1 = substr("`pkg'",1,1)
	
	if "`pkg'"=="all" {
		di as error `"package named "all" skipped. That is because the program is creating an 'all.pkg' package file."'
		continue
	}
	
	qui fs `pkg'* 
	if !missing(r(files)) local files = r(files)
	
	if missing("`subfolders'") {
		qui fs `p1'/`pkg'*  
		foreach v in `r(files)'  {
			local subfiles `subfiles' `p1'/`v'
		}
		local files : list files | subfiles
	}
	local files : list clean files

	di _col(20) as res "`files'"

	if missing("`files'") {
		local problems `problems' `pkg'
		di as error "Files named `pkg'* not found --> skipped"
		continue
	}
	
	// register .pkg file in stata.toc
	file write `toc' _newline "p `pkg' "

	// start .pkg file	
	file open  `looppkg' using `"`using'/`pkg'.pkg"', write text `replace'	
	file write `looppkg' "v 3" _newline "d `pkg'." _newline "d" _newline
	
	local c_ado=0
	
	foreach f of local files {
	
		if missing("`subfolders'") & regexm("`f'","^(.*)(\\|\/)+(.*)$") {
			// file might be in subfolder 
			local subf = regexs(1) + "/"
			local filename = regexs(3)
			cap mkdir `"`using'/`subf'"',  public
		}
		else {
			local subf ""
			local filename "`f'"  // no subfolders
		}
		
		if regexm("`f'","\.(.*)$") local ext = regexs(1)
		else local ext ""

		if regexm(lower("`f'"),".*\.(ado|class|dct|dlg|do|log|hlp|key|out|raw|scheme|smcl|sthlp|style|txt)$") {
			local text "text"
		}
		else local text ""

		if missing("`copy'") {
			di as input `"| . copy "`f'" "`using'/`subf'`filename'" , public `replace' `text'"'
			copy "`f'" "`using'/`subf'`filename'" , public `replace' `text'
		}
		
		if regexm("`filename'","\.[aA][dD][oO]$") {
			local ++c_ado
			file open readado using "`using'/`subf'`filename'" , read
			local ll=0
			forvalues l=1/`maxintro' {
				file read readado line
				if `c_ado'>1 continue
				if `l'<`cline' & `cline'>1 continue 
				if regexm(`"`line'"',"program *define") continue, break
				if !regexm(`"`line'"',"^ *(\/+|\*)\!? ?:? ?(.*)\$? *$") continue  // line begining with "*" or "//", excluding the comment marks
				local thisline = trim(regexs(2))
				local wrap=1
				while !missing(`"`thisline'"') | `wrap'==1 {
					local ++wrap
					if `l'==`cline' file write `toc' `" `thisline'"'
					file write `looppkg' "d " (substr(`"`thisline'"',1,`width')) _newline
					local thisline = substr(`"`thisline'"',`width',.)
				}
			}
			file close readado
		}

		// add file to .pkg (and all.pkg)
		file write `looppkg'  "f `subf'`filename'" _newline
		file write `all'  "f `subf'`filename'" _newline
	
	} // end loop thru files for package

file write `looppkg' _newline "d" _newline `"d Program by `author'"' _newline
file write `looppkg' "* This package file created on ${S_DATE}" _newline
file write `looppkg' "* with Keith Kranker's package -pub2web-" _newline
file close `looppkg' 
file write `all' _newline
			  
} // end loop thru packages

di as input "| . cd " _c 
cd `"`pwd'"'

file write `all' "* This package file created on ${S_DATE}" _newline "* with Keith Kranker's package -pub2web-" _newline
file close `all'

file write `toc' _newline(2) "* This stata.toc file created on ${S_DATE}" _newline "* with Keith Kranker's package -pub2web-" _newline
file close `toc'

if !missing(`"`problems'"') di as err "No files for these packages: " _n as res _col(5) `"`problems'"'
	
end 
