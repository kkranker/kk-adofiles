*! $Id: personal/p/predict_toggle_cum.ado, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $
*! Cumlative probabity for predict_toggle.

* This is command that can be used only afte predict_toggle  
* when the regression predicts the probability of an event.
* This command uses the i()/t() variables to identify a panel.
* The second command calculates a cumulative probability within each obs/time period.
* It then take the average of the last (cumulative) probability for each obs.

* oneminus calculates the cumulative (1-probability) instead.

* Note: Make sure you understand this program's actual code before
*       you use weights!  If weights are changing for each i, you will
*       need to force this program to use the right weight.
*       


/* BASIC EXAMPLE: 

set trace off
* set trace on
set mem 1g
set obs 10
gen id = _n
gen w = uniform()
expand 50
bys id: gen t=_n
gen x = uniform() < .25
gen x2 = uniform() > .9
gen z = uniform() -.5
gen y = .25 * x + z + .0001 * t + uniform() > 0

probit y x x2 z t [pw=w] 
predict_toggle x2 ,  pr codebook
predict_toggle_cum [pw=w], i(id) t(t) oneminus

browse id t _* 
*/
*
*! By Keith Kranker
*! $Date$

program define predict_toggle_cum, eclass sortpreserve
	version 10                        
	
	syntax [if] [in]        ///
		[fweight pweight aweight iweight], ///
	    i(varname)          /// id variable
	    t(varname numeric)  /// time variable   
	  [ MATName(name)       /// a matrix name to store the output in
		svy                 /// prefix "mean ___ " with "svy:" 		
		PREFix(string)      /// prefix new variables with this string.  Default is inherited from predict_toggle or "_"
	    ONEMinus            /// subtract from one before creating cumulative probability
		at(string)          /// program calculate means using "by i (t) : gen include = `at'", and then it calculates the "mean ... if include ..."
		                    /// by default, `at' == (_n==_N), the last observation in the panel, but this can be changed with this option.  For example, at(age==10)
		   *                /// other options passed to mean 
	  ]	                    
		

	estimates store existing_est
		
	marksample touse
	cap assert e(sample) == `touse'
	if _rc di as txt "Current sample is not identical to estimation sample for previous command. Consider using " as res `""if e(sample)""' as txt " to change this behavior."

	if missing("`weight'") local wtexp ""
	else                   local wtexp "[`weight' `exp']"
	
	if mi("`wtexp'") & mi("`svy'") & ( e(predict_toggle_weight) | e(predict_toggle_svy) )  {
		di as err "You need to specify a weight." 
		error 12345
	}
	else if !mi("`svy'") local svy "svy:"
		
	if !e(predict_toggle_replace) local replace=="noreplace"
	if mi("`prefix'")               local prefix = e(predict_toggle_prefix)

	cap assert e(predict_toggle)==1
	if _rc {
		di as error "predict_toggle_cum can only be run after predict_toggle."
		error 12345
		}
	cap assert e(predict_toggle_1)==1
	if _rc {
		di as error "You can only use one treatment variable or -arraytreatments- with the following options: predict_toggle_cum"
		error 12345
	}

	// drop variables if needed
	foreach cy in `prefix'cum_yhat `prefix'cum_yhat_u  `prefix'cum_yhat_T `prefix'cum_yhat_u_T  `prefix'cum_tet `prefix'cum_tet_T {
		cap confirm new var `cy', exact
		if _rc & "`replace'"!="noreplace" {
			drop `cy'
			local replaced_vars `replaced_vars' `cy'
		}
		local out_vars_final `out_vars_final' `cy'
	}
	
	// check that time is contiuous within observations
	cap bys `i' (`t') : assert `t'[_n-1]=`t'[_n] if `touse' & _n>1
	if _rc di as error "`t' does NOT increment by 1.  Check for gaps and use with caution!"

	// check that predicted robabilities in [0,1]
	cap assert inrange(`prefix'yhat,0,1) & inrange(`prefix'yhat_u,0,1) if `touse'
	if _rc di as error "yhat and/or yhat_u not between 0 and 1 (inclusive).  You will get missing values."
	
	// cumulative product yhat & yhat_u
	bys `i' (`t'): gen double `prefix'cum_yhat   = `prefix'yhat   if `touse' & inrange(`prefix'yhat,0,1)
	by  `i' (`t'): gen double `prefix'cum_yhat_u = `prefix'yhat_u if `touse' & inrange(`prefix'yhat_u,0,1)
	if mi("`oneminus'") {
		qui replace `prefix'cum_yhat   = 1- `prefix'cum_yhat
		qui replace `prefix'cum_yhat_u = 1- `prefix'cum_yhat_u
	}
	qui {
	  by  `i' (`t'): replace `prefix'cum_yhat   =  `prefix'cum_yhat[_n-1]   * `prefix'cum_yhat[_n]   if `touse' &  _n>1
	  by  `i' (`t'): replace `prefix'cum_yhat_u =  `prefix'cum_yhat_u[_n-1] * `prefix'cum_yhat_u[_n] if `touse' &  _n>1
	}
	gen `prefix'cum_tet = `prefix'cum_yhat - `prefix'cum_yhat_u
	label var  `prefix'cum_yhat   "Cumulative `:var lab `prefix'yhat'"
	label var  `prefix'cum_yhat_u "Cumulative `:var lab `prefix'yhat_u'"
	label var  `prefix'cum_tet    "Cumulative `:var lab `prefix'tet'"
	
	qui count if (mi(`prefix'cum_yhat) |  mi(`prefix'cum_yhat_u) ) & `touse'
	if r(N) > 0 di "Cumulative yhat or yhat_u could not be calculated for " as res r(N) as txt " observations."
		
	tempvar includeobs
	tempname vx_mean table
	
	if mi(`"`at'"') local at "_n==_N"
	qui by `i' (`t'): gen `includeobs' = `at'  if `touse'

	qui count if (mi(`prefix'cum_yhat) |  mi(`prefix'cum_yhat_u) ) & `touse' & `includeobs'
	if r(N) > 0 di "Cumulative yhat or yhat_u could not be calculated for " as res r(N) as txt " observations at  `at'."

	foreach vx of var `prefix'cum_yhat `prefix'cum_yhat_u `prefix'cum_tet {	
	
		qui clonevar `vx'_T   = `vx'  if  `includeobs' & `touse'
		label var  `vx'_T "At T_i, `:var lab `vx''" 

		// main call to mean ___ function for matrix cell
		quietly `svy' mean `vx'_T if `touse' `wtexp' , `options'

		// save output into matrix
		matrix `vx_mean' = e(b)
		mat colname  `vx_mean' = "`vx'_T "
		mat rowname  `vx_mean' = "mean"

		mat `table' = ( nullmat(`table') , `vx_mean' ) 
	
		// save average for ereturn (below) 
			tempname `vx'_T
			scalar  ``vx'_T' = `vx_mean'[1,1] 
			local e_scalars `e_scalars' `vx'_T
	}  // end loop thru outcome variables
	
	// add to pre-existing ereturn 
	qui estimates restore existing_est
	mat list `table', noheader

	if missing("`matname'") ereturn matrix predict_toggle `table' 
	else                    ereturn matrix `matname'      `table' 

	
	if !missing( "`out_vars_final'" ) noisily di as txt _n "New variables: "  as res `"{stata codebook `out_vars_final', compact:`out_vars_final'}"'

	if !missing("`e_scalars'") {
		noisily di as txt _n "New e() scalars: " as res "`e_scalars'" 
		foreach vx of local e_scalars {	
			if !regexm("`vx'","^yhat") ereturn scalar `vx' = ``vx''
		}
	}


end
