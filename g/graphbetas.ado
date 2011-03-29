*! $Id: personal/g/graphbetas.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/28 23:57:36 (revision fe9ff91d4ae9 by user keith) $
*! Rudimentary program to graph beta coefficients after a regression (for example)

* (1) if you specify something for "find" it will only graph the beta cofficients for the 
*     variables where a regular expression search for "`find'" in the variable name returns "1".  
* (2) if find is not used, it will also clean up variable names beginning with an underscore:
*	  example: "_Ixxx_10" would be converted to "10"
* (3) any other options get passed to the twoway scatteri command

* You can specify a matrix besides e(b) (the default), but it must be a row vector
*!
*! By Keith Kranker
*! $Date$

* example: 
* . xi : reg y i.YEAR x 
* . graphbetas , find("_IY")   
* . graphbetas , find("eqn1:")        <-- equation name
* . graphbetas , find("eqn1:_I.*")    <-- .* is a wildcard 

program define graphbetas 

version 9.2
syntax [name], [ NOConstant Find(string) XTitle(passthru) YTitle(passthru) *]

tempname b eqnon
if !missing("`namelist'") {
	if `=rowsof(`namelist')' > 1 di "Only row 1 of `namelist' will be graphed."
	matrix `b' = `namelist'[1,....]
	}
else matrix `b' = e(b)
local cc = colsof(`b') 
local colnames : colfullnames `b'
local c=1
foreach j of local colnames {
	if ( !missing("`find'") & 0==regexm( "`j'", "`find'"))    continue  // skip beta because no match with find
	if ( !missing("`noconstant'") & regexm( "`j'", "_cons"))  continue  // skip beta for _cons when -noconstant- is on
	if regexm( "`j'", "(.*:)(.*)") {
		local j_eqn = regexs(1)  // split -j- into equantion/varible, leaving variable in -j-
		local j     = regexs(2)
		}
	else local j_eqn = ""
	cap confirm var `j'
	if !_rc {
		if ( missing("`find'") & regexm( "`j'", "^_.*_([0-9]+)$"))  local j_lab = regexs(1)  // try to clean up _xxxN labels
		else if !missing( "`:var lab `j''")                         local j_lab : var lab `j' // try to label
		else                                                        local j_lab "`j'"
	}
	else                                                            local j_lab "`j'"
	local all `" `all' `=`b'[1,`c']' `c' (4) "`j_eqn'`j_lab'" "'
	local ++c
}
if (missing(trim(`"`all'"')) & missing(`"`find'"')) di as error `"Nothing matched find(`find')."'
if missing(`"`xtitle'"') local xtitle `"xtitle("")"'
if missing(`"`ytitle'"') local ytitle `"ytitle("")"'
twoway scatteri `all' , yline(0) c(l) m(O) xlab(none) `xtitle' `ytitle' `options' 

end 
