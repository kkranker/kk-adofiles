*! $Id: personal/p/predict_toggle.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/05/17 21:56:30 (revision 9c84375d6ec8 by user keith) $
*! After a regression, predict with X1=0, X1=1, then calculate the difference

* This is a post-estimation command.  
* Suppose you have a dummy variable X. 
* The program will: 
* 1. calculate model prediction with X        (i.e., the -predict- command)
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

cap program drop predict_toggle
program define predict_toggle, eclass
	version 9                        
	syntax varlist [if] [in] [fweight pweight aweight iweight] ///
		[, ARraytreatments  /// turn all varlist vars off for untreated; not one at a time
		   svy              /// prefix "mean ___ " with "svy:"  (survey is turned on automatically if previous regression also used survey)
		   MEANOpts(string) /// options to pass to mean ___
		   Keep             /// create a set of te_y variables for all varables (automatically on if only 1 variable)
		   MATName(name)    /// a matrix name to store the output in
		   PREFix(string)   /// prefix te_* variables with this string.  Default is "_"
		   noREPlace        /// don't overwrite  _yhat variables (if they exist)
		   Quietly          /// display less output
		   NOIsily          /// display more output
		   *                /// other options passed to predict 
		]
	
	estimates store existing_est
		
	cap assert e(sample) == `touse'
	if _rc di as txt "making out-of-sample predictions.  Use " `""if e(sample)""' " to change this behavior."

	marksample touse 
	if missing("`weight'") local wtexp ""
	else                   local wtexp "[`weight' `exp']"

	if !missing("`svy'") & !missing("`wtexp'") {
		di as error `"You selected both "`svy'" and "`wtexp'". "' as txt `""`wtexp'"  will be ignored. "'
		local wtexp "" 
		local svy "svy: "
	}
	else if missing("`svy'") & missing("`wtexp'") & !missing("`e(wtype)'") {
		di as txt "weights from previous regression will be used. " as res "`wtexp'"
		local wtexp "[`e(wtype)' `e(wexp)'] "
	}
	else if !missing("`svy'") | ( missing("`svy'") & strpos("`e(prefix)'","svy") ) {
		di as txt "survey weights from svyset will be used."
		local svy "svy: "
	}
	else {
		di as err "predict_toggle not programmed for this case."  "Fix something (about line 75)"
		error 12345
	}

	if inlist(e(cmd),"regress","areg","xtreg","newey") di as txt "note: Expect ate=atet=ateu in a linear model"
	
	// confirm varlist in list of LHS variables
	local y = e(depvar)
	local x_all : colnames e(b)
	if !missing("`noisily'") mac list _y _varlist _x_all
	foreach v of local varlist {
		if !`: list v in x_all' {
			di as res "`v'" as error " will be removed from -varlist- (not an independent variable in previous regression)"
			local varlist : list varlist - v
		}
	}
	
	cap assert `: list sizeof varlist' > 0 
	if _rc {
		local errno = _rc 
		di as error "No variables in -varlist-."
		exit
	}
	
	if ( `: list sizeof varlist' == 1 & "`arraytreatments'"!="" ) {
		di as error "One variable in -varlist-.  Option -arraytreatments- will be ignored."
		local arraytreatments = ""
	}
	
	if missing("`prefix'") local prefix "_"
	
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
		  cap assert inlist(`v',0,1,.) if `touse' // check that treatment is dummy variable
		  if _rc {
		    di as error "`v' is not a dummy varible = 0/1."
		    error 198
		  }		
		
		  if 1==`: list sizeof varlist' local abbrev = ""
		  else                          local abbrev = "_" + subinstr(abbrev("`v'",`=c(namelen)-length("`prefix'")-8'),"~","_",.)  

		  qui {
			clonevar `Bckp' = `v'

			replace `v' = 0 
			predict double `yhat_u' if `touse', `options'
			label var      `yhat_u' "Predicted (y|`v'=0), y=!`: var lab `y''"

			replace `v' = 1 
			predict double `yhat_t' if `touse', `options'
			label var      `yhat_t' "Predicted (y|`v'=1), y=`: var lab `y''"

			replace `v' = `Bckp' // restore treatment variables
			
			gen double `te' = `yhat_t' - `yhat_u' if `touse'
			label var  `te' "Treatment Effect, y=`: var lab `y''"
			
			gen double `tet' = `te' if `v'==1
			label var  `tet' "Treatment Effect on Treated, y=`: var lab `y''"
			
			gen double `teu' = `te' if `v'==0
			label var  `teu' "Treatment Effect on Untreated, y=`: var lab `y''"
			
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

				// variables: save a copy of variable if one treatement variable  or if "Keep" option is on
				if (1==`: list sizeof varlist' | !missing("`keep'")) | ( `vn'==1 & "`vx'"=="yhat") {
					if "`vx'"=="yhat" local mkvar = "`prefix'`vx'"
					else              local mkvar = "`prefix'`vx'`abbrev'"
					cap confirm new var `mkvar', exact
					if _rc & "`replace'"!="noreplace" {
						drop `mkvar'
						local replaced_vars `replaced_vars' `mkvar'
						
					}
					clonevar `mkvar' = ``vx''
					local out_vars_final `out_vars_final' `mkvar'
				}
				// scalars
				if !regexm("`vx'","^yhat") {
					tempname a`vx'`abbrev'
					scalar  `a`vx'`abbrev'' = `vx_mean'[1,1]  // save for ereturn (below)
					local e_scalars `e_scalars' a`vx'`abbrev'
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
		
		foreach v of local varlist {
			tempvar B`v'
			cap assert inlist(`v',0,1,.) // check that treatment is dummy variable
			  if _rc {
				di as error "`v' is not a dummy varible = 0/1."
				error 198
			  }		
			qui clonevar `B`v'' = `v' // save var
			qui replace `v' = 0 
		}
		
		qui predict double `yhat_u' if `touse', `options'
		label var          `yhat_u' "Predicted (y|all treatment variables=0) `: var lab `y''"
	
		foreach v of local varlist {
			qui replace `v' = `B`v'' //  restore treatment variables
		}

		di as txt `""Treated" if max("' as res "`varlist'" as txt ")"
		qui egen `anytreat' = rowmax(`varlist')  if `touse'

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
		
			// save a copy of variables
			cap confirm new var `prefix'`vx', exact
			if _rc {
				drop `prefix'`vx'
				local replaced_vars `replaced_vars' `prefix'`vx'
			}
			clonevar `prefix'`vx' = ``vx''
			local out_vars_final `out_vars_final' `prefix'`vx'
			
			// save average te 
			if !regexm("`vx'","^yhat")  {
				tempname a`vx'
				scalar  `a`vx'' = `vx_mean'[1,1]  // save for ereturn (below)
				local e_scalars `e_scalars' a`vx'
			}
		}  // end loop thru outcome variables
		qui estimates restore existing_est
		
	} // end Arraytreatments case
	
	return clear
	noisily di as txt "predict_toggle: Replaced variables " as inp "`replaced_vars'"

	// add to pre-existing ereturn 
	qui estimates restore existing_est
	mat list `table', noheader
	
	if missing("`matname'") ereturn matrix predict_toggle `table' 
	else                    ereturn matrix `matname'      `table' 
	
	if !missing( "`out_vars_final'" ) {
		noisily di as txt _n "New variables:" 
		codebook `out_vars_final', compact
		}
	
	if !missing("`e_scalars'") {
		noisily di as txt _n "New e() scalars:" as res _col(18) "`e_scalars'"
		foreach vx of local e_scalars {	
			if !regexm("`vx'","^yhat") ereturn scalar `vx' = ``vx''
			di as txt "e(`vx')" _col(12) as res ``vx''
		}
	}

end 

