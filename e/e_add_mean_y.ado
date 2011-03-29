*! $Id: personal/e/e_add_mean_y.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Add mean of e(depvar) to ereturn after a regression
*!
*! By Keith Kranker
*! $Date$

* example: 
*  . regress y x1 x2
*  . e_add_mean_y
*  . outreg2


program define e_add_mean_y, eclass
  di as txt "Calculate mean of the dependent variable: " as res "`e(depvar)': `: var lab `e(depvar)''  if e(sample) "
  quietly {
	if "`e(prefix)'" == "svy" {
		tempname regress_before y_mean_mat
		estimates store `regress_before'
		svy:  mean `e(depvar)' if e(sample) 
		matrix `y_mean_mat' = e(b)
		local  y_mean = `y_mean_mat'[1,1]
		estimates restore `regress_before', drop
		}
	else {
		summ `e(depvar)'  if e(sample) , meanonly
		local y_mean = r(mean)
	}
	ereturn scalar y_mean = `y_mean'
  }
  di as txt "e(y_mean) = " as res e(y_mean)
end 
