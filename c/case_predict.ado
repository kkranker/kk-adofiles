*! $Id: personal/c/case_predict.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 06:28:18 (revision 0cc1679684a2 by user keith) $
*! After a regression, predict with X1=0, X1=1, then calculate the difference
* 
* This was like predict_toggle.  Now it's a wrapper for
* backward compatability


program define case_predict, eclass
	version 9                        
	syntax varname [if] [in] [pweight], [ prefix(string)]  
	
	di "This program now just calls predict_toggle"
	estimates store existing_est
	
	if missing("`weight'") local wtexp ""
	else                   local wtexp "[`weight' `exp']"

	// call predict_toggle
	predict_toggle `varlist' `if' `in' `wtexp'
	
	// save output with old case_predict names
	clonevar `prefix'y_hat         = _yhat_`varlist'
	clonevar `prefix'y_x0_hat      = _yhat_u_`varlist'
	clonevar `prefix'y_x1_hat      = _yhat_t_`varlist'
	clonevar `prefix'y_x_hat_delta = _te_`varlist'
	
	qui summ `prefix'y_x_hat_delta , meanonly
	local case_predict = r(mean) 
	di _n
	mac list _case_predict
	
	qui estimates restore existing_est
	ereturn local case_predict = `case_predict'

end
