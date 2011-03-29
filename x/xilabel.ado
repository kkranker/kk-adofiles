*! $Id: personal/x/xilabel.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Quickly "clean up" variable labels for variables created by the [xi : ] command.

* Example: Say you used -xi- to create dummies for "race" (variable 
* label "Race or Ethnicity"), where there is a value label for "2" (Black) 
* and the new variable from xi: is  _racrace_2  with label race==2
*
* .........COMMAND.....................................NEW.LABEL..............
* . xilabel _racrace_2                       "Black"
* . xilabel _racrace_2, is                   "Race or Ethnicity is Black"
* . xilabel _racrace_2, colon                "Race or Ethnicity: Black"
* . xilabel _racrace_2, equals               "Race or Ethnicity=Black"
* . xilabel _racrace_2, pre("Category - ")   "Category - Black"
* . xilabel _racrace_2, is pre("i's ")       "i's Race or Ethnicity is Black"
*
* Recommended: use this command if "xi" input variable has BOTH a variable label and value label.
* This program does not work with interaction terms.  
*
*! By Keith Kranker
*! $Date$


program define xilabel 

syntax varlist [, Is Equals Colon Other(string) PRefix(string) POst(string)]

foreach v of local varlist {
  if (length("`is'")>0) + (length("`equals'")>0) + (length("`colon'")>0) + (length("`other'")>0) > 1 {
    di as error "Choose one of these: `is' `equals' `colon' `other'"
    error 101
  }
  if 0==regexm( "`:var lab `v''", "^(.*)==(.*)$") {
    di as error `"Label for `v' (`:var lab `v'') not in the form "varname==value""'
    continue
  }
  else {
    local xivar = regexs(1) 
    local xival = regexs(2) 
	
    if length("`: label (`xivar') `xival' ,  strict'")      label var `v' "`: label (`xivar') `xival' ,  strict'"
    else                                                    label var `v' "`xival'"
	
    if length("`is'") & length("`: var label `xivar''")     label var `v' "`: var label `xivar'' is `: var label `v''"
    if length("`equals'") & length("`: var label `xivar''") label var `v' "`: var label `xivar'' = `: var label `v''"
    if length("`colon'") & length("`: var label `xivar''")  label var `v' "`: var label `xivar'': `: var label `v''"
    if length("`other'") & length("`: var label `xivar''")  label var `v' "`: var label `xivar''`other'`: var label `v''"
	
    label var `v' "`prefix'`: var label `v''`post'"
  }
}

end
