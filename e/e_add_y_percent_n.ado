*! $Id: personal/e/e_add_y_percent_N.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Add fraction of e(depvar)==0 to ereturn after a regression

*! By Keith Kranker
*! $Date$

program define e_add_y_percent_N, eclass
syntax [, Noisily EQuals(real 0)]
  di "Calculate share of observations where (`e(depvar)' == `equals')  if e(sample) "
  qui {
	if "`e(prefix)'" == "svy" {
		tempname regress_before y_mean_mat
		estimates store `regress_before'
		tempvar temp
		gen `temp' = (`e(depvar)' == `equals')
		`noisily' svy: mean `temp' if e(sample) 
		matrix y_pct_eq_n = e(b)
		local  y_pct_eq_n = y_pct_eq_n[1,1]
		estimates restore `regress_before', drop
		ereturn scalar y_pct_eq_n = `y_pct_eq_n'
		}
	else {
		`noisily' count if (`e(depvar)' == `equals') & e(sample) 
		ereturn scalar y_pct_eq_n =  round( r(N) / e(N) * 100 , .1)
	}
  }
  	di as txt "e(y_pct_eq_n) = " as res e(y_pct_eq_n)
end 

