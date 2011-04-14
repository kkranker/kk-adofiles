*! $Id: personal/p/predict_toggle.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/14 15:10:16 (revision 32a3a406f989 by user keith) $
*! After a regression, predict with X1=0, X1=1, then calculate the difference

* This is a post-estimation command.  
* Suppose you have a dummy variable X. 
* The program will: 
* 1. calculate model prediction with X
* 2. calculate model prediction with X = 0
* 3. calculate model prediction with X = 1
* 4. calculate difference between 3/4
* 5. return X to original state

* arraytreatments option:
*   calculate treatment effect on treated:
*   where "untreated" is 0 for all variables in varlist
*   treatment is the "actual" treatment.  
*   I do not turn on treat=1 for the whole array
*
*! By Keith Kranker
*! $Date$

/* EXAMPLE: 
clear
set trace off
* set trace on
set obs 1000
gen x = uniform() < .25
gen x2 = uniform() > .9
gen z = uniform() -.5
gen y = .25 * x + z + uniform()

reg y x x2 z 
predict_toggle x , keep
predict_toggle x x2, keep
predict_toggle x x2, arraytreatments
*/

program define predict_toggle, eclass
	version 9                        
	syntax varlist [if] [in] [fweight pweight aweight iweight] ///
		[, ARraytreatments /// turn all varlist vars off for untreated; not one at a time
		   Quietly         ///
		   svy /// prefix "mean ___ " with "svy:"  survey is turned on automatically if regress used survey.
		   meanopts(string) /// options to pass to mean ___
		   Keep /// create a set of te_y variables for all varables (automatically on if only 1 variable)
		   PREFix(string) /// prefix te_* variables with this string
		   * /// other options passed to predict 
		]
	
	estimates store existing_est

	marksample touse 
	if missing("`weight'") local wtexp ""
	else                   local wtexp "[`weight' `exp']"
		
	cap assert e(sample) == `touse'
	if _rc di as txt "note: This program is making out-of-sample predictions.  Use " `""if e(sample)""' " to change this behavior."

	if missing("`svy'") & e(prefix)=="svy" {
		local svy "svy:"
	}
	if !missing("`svy'") {
		local svy "svy:"
		di as txt "note: survey weights from svyset will be used."
	}

	if missing("`svy'") & missing("`wtexp'") & !missing("`e(wtype)'") {
	    local wtexp "[`e(wtype)' `e(wexp)'] "
		di as txt "note: weights from previous regression will be used. " as res "`wtexp'"
	}

	if e(cmd)=="regress" di as txt "note: Expect ate=atet=ateu in a linear model"
	
	// confirm varlist in list of LHS variables
	local y = e(depvar)
	local x_all : colfullnames e(b)
	if !`: list varnames in x_all' 	{
		di as error "note: variable names in command must be independent variables in the previous regression."
		error 20742
	}
	
	local outvars yhat yhat_t yhat_u te tet teu 
	tempvar  Bckp `outvars' anytreat
	tempname vx_mean vx_table table

	qui predict double `yhat' if `touse', `options'
	label var          `yhat' "Predicted (y|X)"

	if missing("`arraytreatments'") {
	
		// default case -- calculate seperate treatment effect for each variable in varlist

		local vn=0
		foreach v of local varlist {
		  local ++vn
		  local abbrev = "_" + substr("`v'",1,`=c(namelen)-5')
		  assert inlist(`v',0,1,.) if `touse' // check that treatment is dummy variable
			
		  qui {
			clonevar `Bckp' = `v'

			replace `v' = 0 
			predict double `yhat_u' if `touse', `options'
			label var      `yhat_u' "Predicted (y|`v'=0) `: var lab `y''"

			replace `v' = 1 
			predict double `yhat_t' if `touse', `options'
			label var      `yhat_t' "Predicted (y|`v'=1) `: var lab `y''"

			replace `v' = `Bckp' // restore treatment variables
			
			gen double `te' = `yhat_t' - `yhat_u' if `touse'
			label var  `te' "Treatment Effect `: var lab `y''"
			
			gen double `tet' = `te' if `v'==1
			label var  `tet' "Treatment Effect on Treated `: var lab `y''"
			
			gen double `teu' = `te' if `v'==0
			label var  `teu' "Treatment Effect on Untreated `: var lab `y''"
			
			foreach vx of local outvars {	
				
				// main call to mean ___ function for matrix cell
				quietly `svy' mean ``vx'' if `touse' `wtexp' , `meanopts'
				
				// save output into matrix
				matrix `vx_mean' = e(b)
				if regexm("`vx'","^yhat") mat colname  `vx_mean' = "mean_`vx'"
				else                      mat colname  `vx_mean' = "a`vx'"
				mat rowname  `vx_mean' = "`v'"

				if   "`vx'"=="yhat" mat `vx_table' = ( `vx_mean') 
				else                mat `vx_table' = ( `vx_table' , `vx_mean') 

				// save a copy of variable if one treatement variable
				if (1==`: list sizeof varlist' | !missing("`keep'")) {
					if regexm("`vx'","^(yhat|te)") {
						cap confirm new var _`vx'`abbrev'
						if _rc {
							noisily di as txt "Replaced variable _`vx'`abbrev'"
							drop _`vx'`abbrev'
						}
						clonevar `prefix'_`vx'`abbrev' = ``vx''
					}
					if !regexm("`vx'","^yhat") {
						tempname a`vx'
						scalar  `a`vx'' = `vx_mean'[1,1]  // save for ereturn (below)
						local e_scalars `e_scalars' a`vx'
					}
				}
			}  // end loop thru outcome variables

			if `vn'==1  mat `table' = ( `vx_table' )
			else        mat `table' = ( `table' \ `vx_table' )

			qui estimates restore existing_est
			drop   `Bckp' `yhat_u'  `yhat_t' `te' `tet' `teu'  
			
		  } // end quiet
		} // end loop through varlist
				
	} // end default case
	else {

		// Arraytreatments case 
		local abbrev = ""
		
		foreach v of local varlist {
			tempvar B`v'
			assert inlist(`v',0,1,.) // check that treatment is dummy variable
			qui clonevar `B`v'' = `v' // save var
			qui replace `v' = 0 
		}
		qui predict double `yhat_u' if `touse', `options'
		label var          `yhat_u' "Predicted (y|`v'=0) `: var lab `y''"
	
		foreach v of local varlist {
			qui replace `v' = `B`v'' //  restore treatment variables
		}

		di as txt `""Treated" if max("' as res "`varlist'" as txt ")"
		qui egen `anytreat' = rowmax(`varlist')

		qui gen double `tet' = `yhat' - `yhat_u' if `touse' & `anytreat'==1
		label var      `tet' "Treatment Effect on Treated `: var lab `y''"

		foreach vx in yhat yhat_u tet {	
			
			// main call to mean ___ function for matrix cell
			quietly `svy' mean ``vx'' if `touse' `wtexp' , `meanopts'
			
			// save output into matrix
			matrix `vx_mean' = e(b)
			if regexm("`vx'","^yhat") mat colname  `vx_mean' = "mean_`vx'"
			else                      mat colname  `vx_mean' = "a`vx'"
			mat rowname  `vx_mean' = "`v'"

			if   "`vx'"=="yhat" mat `table' = ( `vx_mean' ) 
			else                mat `table' = ( `table' , `vx_mean' ) 
			
			// save a copy of variable if one treatement variable
				if regexm("`vx'","^yhat") {
					cap confirm new var _`vx'
					if _rc {
						noisily di as txt "Replaced variable _`vx'"
						drop _`vx'
					}
					clonevar `prefix'_`vx' = ``vx''
				}
				else {
					tempname a`vx'
					scalar  `a`vx'' = `vx_mean'[1,1]  // save for ereturn (below)
					local e_scalars `e_scalars' a`vx'
				}
			}  // end loop thru outcome variables
		qui estimates restore existing_est
		
		} // end Arraytreatments case
	return clear

	// add to pre-existing ereturn 
	qui estimates restore existing_est
	mat list `table', noheader
	
	ereturn matrix table `table' 
	
	noisily di "e_scalars: `e_scalars'"
	 if !missing("`e_scalars'") {
		foreach vx of local e_scalars {	
			noisily di `"save a`vx' = ``vx'' "'
			if !regexm("`vx'","^yhat") ereturn scalar `vx' = ``vx''
		}
	}

end 

