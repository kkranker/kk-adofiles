*! $Id: personal/d/dropstringvars.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Drop all string variables in a varlist
*
* Note: Requires a template excel file, exceldesc.xls, to be installed in the same folder as this .ado file
*
*! By Keith Kranker
*! $Date$

program define dropstringvars
  qui {
	version 9.2
	syntax [varlist] 
	
	noisily di as txt "Dropped variables: "	
	local dropstringvars_count = 0
	foreach i of varlist `varlist' {
		local dropstringvars_temp_type :  type  `i' 
		if regexm("`dropstringvars_temp_type'", "^[s][t][r]") == 1 {
			drop `i'
			local dropstringvars_count = 1 + `dropstringvars_count'
			noisily di as res `"  `i' "'
			} // end if statement
	}  // close loop through variables
	
	noisily di as txt "`dropstringvars_count' variables were dropped."
	if `dropstringvars_count' == 0 {
		noisily di as txt `"Use {stata "desc `varlist'":describe} to check if your {it:varlist} included string variables"'
		}
  }  // close quite section
end
	
