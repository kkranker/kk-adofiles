*! $Id: personal/e/e_countif.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Add N positive to ereturn after a regression

// program performs 
//         count if `varname' & e(sample)
// 
// The result is returned into e(N_`varname')
// By default, if `varname' isn't provided, it tries to use a variable named "tag".

// example: 
// . egen tag = tag(id)
// . xtreg y x , i(id)
// . e_countif 
// . outreg2 , e(N N_tag)
// (N would have the number of rows, and N_tag would be the number of unique id's)
*!
*! By Keith Kranker
*! $Date$

program define e_countif, eclass
  version 9.2 
  syntax [varlist(default=none max=1 numeric)]
  if "`varlist'" == "" local varlist tag
  qui count if `varlist' & e(sample)
  local N_`varlist' = r(N)
  di as txt "There are " as res `N_`varlist'' as txt " observations in the previous estimation where" as res " if `varlist'" as txt " is true."
  ereturn scalar N_`varlist'=`N_`varlist''
  di as txt "e(N_`varlist') = " as res e(N_`varlist')
end
