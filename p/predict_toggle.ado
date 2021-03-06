*! $Id: personal/p/predict_toggle.ado, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $
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

/* BASIC EXAMPLE: 
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

replace y = .25 if y<.25
tobit y x x2 z , ll
predict_toggle x , ystar(.25,.)           // these two specifications are identical
predict_toggle x , predict(ystar(.25,.))


Predict Toggle  was used before the margins command was added to Stata. 
The only thing it is needed any longer is the arraytreatments option (and predict_toggle_cum, below)

This code demonstrates that margins and predict_toggle are identical with one independent variable.

	// margins
	webuse margex
	logit outcome i1.treatment i.group age c.age#c.age
	estimates store hold
	margins , dydx(treatment) predict(pr) post
	estimates restore hold
	margins , dydx(treatment) predict(pr) over(treatment) post

	// margins results above are identical to predict_toggle results, except it gives standard errors from the delta-method
	qui logit outcome treatment i.group age c.age#c.age  // no i. before treatment
	predict_toggle treatment 

	// and margins can handle interaction terms too
	logit outcome i1.treatment##i.group i.group#c.age c.age#c.age 
	margins, dydx(treatment) over( treatment group ) post

*/

program define predict_toggle, eclass
	version 10                        
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
		   CODEBook         /// dsplay codebook, compact for new variables
		   PREDict(string)  /// other options passed to predict (similar to mfx syntax)
		   *                /// other options passed to predict 
		]
	
	estimates store existing_est
	
	marksample touse
	cap assert e(sample) == `touse'
	if _rc di as txt "Current sample is not identical to estimation sample for previous command. Consider using " as res `""if e(sample)""' as txt " to change this behavior."

	if missing("`weight'") local wtexp ""
	else                   local wtexp "[`weight' `exp']"

	if missing("`svy'") & !strpos("`e(prefix)'","svy") & missing("`wtexp'") & missing("`e(wtype)'") {
		di as txt `"No survey weights selected. All calculations are unweighted."'
		}
	else if !missing("`svy'") & !missing("`wtexp'") {
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
		di as err "predict_toggle not programmed for this case."  "Fix something in .ado file (at or about line 63)"
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

	predict double `yhat' if `touse', `predict' `options'
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
			predict double `yhat_u' if `touse', `predict' `options'
			label var      `yhat_u' "Predicted (y|`v'=0),`options' y=!`: var lab `y''"

			replace `v' = 1 
			predict double `yhat_t' if `touse', `predict' `options'
			label var      `yhat_t' "Predicted (y|`v'=1),`options' y=`: var lab `y''"

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
		
		predict double `yhat_u' if `touse', `predict' `options'
		label var          `yhat_u' "Predicted (y|all treatment variables=0) `options' `: var lab `y''"
	
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
	if !missing(`"`replaced_vars'"') noisily di as txt "The variables " as err "`replaced_vars'" as txt " were dropped/overwritten."

	// add to pre-existing ereturn 
	qui estimates restore existing_est
	mat list `table', noheader
	
	if missing("`matname'") ereturn matrix predict_toggle `table' 
	else                    ereturn matrix `matname'      `table' 

	if !missing( "`out_vars_final'" ) {
		if !missing("`codebook'") {
			noisily di as txt _n "New variables: "  as res "`out_vars_final'"	
			codebook `out_vars_final', compact
		}
		else if !missing( "`out_vars_final'" ) noisily di as txt _n "New variables: "  as res `"{stata codebook `out_vars_final', compact:`out_vars_final'}"'
	}

	if !missing("`e_scalars'") {
		noisily di as txt _n "New e() scalars: " as res "`e_scalars'" 
		foreach vx of local e_scalars {	
			if !regexm("`vx'","^yhat") ereturn scalar `vx' = ``vx''
		}
	}

	ereturn scalar predict_toggle = 1
	ereturn scalar predict_toggle_1 = !mi("`arraytreatments'") | 1==`: list sizeof varlist'
	ereturn scalar predict_toggle_replace = "`replace'"!="noreplace"
	ereturn local  predict_toggle_prefix  = "`prefix'"
	ereturn scalar predict_toggle_weight  = !missing(trim(`"`wtexp'"'))
	ereturn scalar predict_toggle_svy     = !missing(trim(`"`svy'"'))
end 

