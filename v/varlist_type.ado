*! $Id: personal/v/varlist_type.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Separate a varlist into macros containing of string/binary/continuous variables
*
*! By Keith Kranker
*! $Date$

program define varlist_type, rclass
  version 9.2
  syntax varlist [if] [in]
  return clear
  tempname s b c
  foreach v of local varlist {
    capture confirm numeric variable `v' 
    if !_rc {
      capture assert inlist(`v',0,1) `if' `in'
      if _rc==0 local `b' ``b'' `v'
      else      local `c' ``c'' `v'
    }
	else local `s' ``s'' `v'
    mac shift
    }
  return local string ``s''
  return local binary ``b''
  return local contin ``c''
  di as txt "Variable list sorted into " in smcl "{stata return list:r(string)}" as txt ", " in smcl "{stata return list:r(binary)}" as txt ", and " in smcl "{stata return list :r(contin)}" as txt "."
  di 
end
