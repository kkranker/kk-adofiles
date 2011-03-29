*! $Id: personal/e/exceldesc.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Export summary statistics to Microsoft Excel
*
* Note: Requires a template excel file, exceldesc.xls, to be installed in the same folder as this .ado file
*
*! By Keith Kranker
*! $Date$

program define exceldesc, rclass
qui {
	version 9.2
	syntax [varlist] [if] [in] [, Table Noisily FILE(string)]
	
	local old_linesize = c(linesize)
	set linesize 255
	
	cap file close myfile
		
	if `"`file'"' == "" {
		findfile exceldesc.ado
		local file_loc_name = subinstr((substr(r(fn),1,(length(r(fn))-4))),"/","\",100)
		`noisily' di as txt `"Output written to `file_loc_name'_current.txt "' 
		file open myfile using `"`file_loc_name'_current.txt"', write text replace
		}
	else {
		local file_loc_name = `"`file'"'
		`noisily' di as txt `"Output written to `file_loc_name'"' 
		file open myfile using `"`file_loc_name'"', write text replace
	}
	
	file write myfile `"|`c(filename)'"' _n 
	file write myfile `"|`c(current_date)', `c(current_time)'"' _n 
	file write myfile _n  
	local gc = 0
	
	`noisily' di `" |Variable|Obs.|Unique|Mean|Std. Dev.|Min.|Max.|Description"'   
	file write myfile `" |Variable|Obs.|Unique|Mean|Std. Dev.|Min.|Max.|Description"' _n   

	foreach i of varlist `varlist' {

	  	local l`i' : variable label `i'
		local gc = `gc'+1
		
		return local varname "`i'"
		return local desc    "`l`i''"
		
		tab `i' `if' `in'
		
		local unique = r(r)
		local tab_N = r(N)
		
		sum `i' `if' `in'
		
		if r(N)==0 	local my_n = `tab_N'
		else local my_n = r(N)
		
		`noisily' di      "`gc'|`i'|`my_n'|`unique'|" r(mean)  "|" r(sd)  "|"  r(min)  "|"  r(max)  "| `l`i'' "
		local output     `"`gc'|`i'|`my_n'|`unique'|`r(mean)'|`r(sd)'|`r(min)'|`r(max)'|"'
		local output_lab `"`l`i''"'
		file write myfile  `"`output'"'
		file write myfile  `"`output_lab'"'
		file write myfile  _n  	
	
	} // close loop through variables

	file close myfile
}  // close quite 

if `"`table'"' == "table" {
	sum `varlist'
	codebook `varlist', c
	}

if `"`file'"' == "" { 
	local cl `"{stata "shellout using `file_loc_name'.xls":`file_loc_name'.xls}"'
	di as txt `"View Excel File: `cl' "'
	}
else {
	local cl `"{view `""`file_loc_name'""':`file_loc_name'}"'
	di as txt `"View output file: `cl' "'
	local cl `"{stata `"shellout using "`file_loc_name'""':`file_loc_name'}"'
	di as txt `"Open output file: `cl' "'
}	

set linesize `old_linesize'

end
	
exit

	
