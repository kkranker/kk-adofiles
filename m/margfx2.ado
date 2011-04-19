*! $Id: personal/m/margfx2.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Wrapper to add ereturn results to margfx.ado program's output (by Jonah B. Gelbach), 
*!
*! This function passes any arguments into margfx,
*! then returns its results into an estimates table
*! (so that it can be used by outreg, etc.)
*!
*! margfx2 was developed with Jonah's margfx.ado file (version 4.3 27Aug04).  
*! This program is required.  As of today, you can download it at http://gelbach.law.yale.edu/
*!
*! Wrapper by Keith Kranker
*! $Date$


program define margfx2, eclass
  version 9.2

  // run Jonah's program
  margfx `0'

  // convert Jonah's globals into ereturns
  // 1. 'ereturn post' appears to wipe out all of the S_E_* stuff.  So, I'm going  first save them under another name
  // 2. properly call ereturn post
  // 3. ereturn other scalars/locals

  tempvar sample
  tempname b V N Nsca props depvar
  mat `b' = e(b)
  mat `V' = e(V)
  local  `N' = e(N)
  scalar `Nsca' = e(N)
  gen `sample' = e(sample)
  local `depvar' = ${S_E_depv}
  local `props' "`=e(properties)'"

  local loop S_E_if S_E_in S_E_mod S_E_cmd S_E_depv S_E_bin S_E_con S_E_cvn S_E_vce S_E_ll S_E_mdf S_E_chi2 S_E_cn
  foreach g in `loop' {
    local mfxtemp_`g' `"${`g'}"'
  }

  ereturn post `b' `V', depname(`mfxtemp_S_E_depv') obs(``N'') esample(`sample') properties("``props''")
  // ereturn display
  
  foreach g in `loop' {
    local name = subinstr("`g'","S_E_","",1)
    if real(trim("`mfxtemp_`g''")) !=.  ereturn scalar `name' = real(trim("`mfxtemp_`g''"))
    else                                ereturn local  `name' = rtrim("`mfxtemp_`g''")
  }

  mac drop mfxtemp_* S_E_*

end
