*! $Id: personal/p/predlog2.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Duan smearing & heteroscedastic smearing retransformation
*
* Note: This is an update of the program -predlog- by Richard Goldstein (STB:  STB-29 sg48)
*
*! By Keith Kranker
*! $Date$

program define predlog2  , eclass
	
version 9.0
syntax  [if] [in] , [ Naive(name)  Duan(name) Heteroscedastic(name) NOISily QUADratic Xvars(varlist) Fpredict Save(name) ] 
tempname OLS_est
_estimates hold `OLS_est', copy

quietly {	
	tempvar YHATRAW RESIDUAL DUAN_SMEAR RESIDUAL_SQR  RESIDUAL_H tempres

	if "`fpredict'" == "fpredict"  {  // If specify "all" option
		marksample touse
		}
	else {  // The default case, use e(sample) from prior regression
		tempvar touse
		gen `touse' = e(sample)
		}

	if e(cmd) == "regress"  {
		predict `YHATRAW'  , xb
		predict `RESIDUAL' , residuals
		}
	else if e(cmd) == "xtreg"  {
		// Following -xtreg-.  The predicted component includes fixed effect; the residual is only the idiosyncratic component"
		predict `YHATRAW'  , xbu
			tempvar YHATRAW2
			predict `YHATRAW2'  , xb
			replace `YHATRAW' = `YHATRAW2' if `YHATRAW' == .		
		predict `RESIDUAL' , e
		}
	else {
		di as error "-predlog2- is not designed for regression commands other than regress and xtreg."
		error 20742
	}


	* "Naive" estimates - assuming error term (e)  is normally distributed, just use varience estimate. rmse is coming from regression
	* E(Y|X) = exp(xb + .5 (sigma_e)^2)
	if "`naive'"!="" {
		`noisily' di as txt "gen `naive':" 
		`noisily' gen double `naive'  = exp( `YHATRAW' +  .5 * e(rmse)^2 ) if `touse'
		
		if length("`save'") gen `save' = exp( .5 * e(rmse)^2 )  if `touse'
	}


	* Estimates using Duan's Smearing Factor - assuming error term (e) is not normally distributed, but is i.i.d. or has exp(e) has constant mean/varience
	* E(Y|X) = S exp(xb)    where S = E(exp(e)) = mean(exp(e_hat))
	if "`duan'"!="" | ( "`heteroscedastic'"=="" & "`naive'"=="" ) {
		
		gen double `DUAN_SMEAR' = exp( `RESIDUAL' )  if `touse'
		summ `DUAN_SMEAR' if e(sample), meanonly   // use IN-SAMPLE residuals to choose Duan smearing factor
		local smearfactor = r(mean)
		noisily   di as txt "Duan Smearing Factor: " as res "`smearfactor'" _n
	   
		if "`duan'"=="" {
			local duan y_hat_smear 
			noisily di as text "No output variable name was requested. Predicted values will be saved as "  as res "`duan'"  as text "."
			confirm new variable `duan'
		 }

		`noisily' di _n as txt "gen `duan':" 
		`noisily' gen double `duan'  = exp( `YHATRAW' ) * `smearfactor'   if `touse'
		if length("`save'") gen `save' = `smearfactor'  if `touse'
	}


	* "Heteroscedastic" smearing estimates - assume variance function is function of X ( "linear" function of X by default; allows quadratic option)
	* E(exp(e)) = f(x)  implies 
	* E(y|x) = f(x) exp(xb)  , which is equivalent to
	* ln(E(y|x)) = xb + ln(f(x))
	* ln(E(y|x)) = xb + 0.5 sigma_e^2 (x) in the log-normal case
	if "`heteroscedastic'"!="" {
		if "`xvars'" != "" {
			* Xvars(varlist) option
			if "`quadratic'" == "" local H_XVARS "`xvars'"
			else {
				di as error "You cannot specify both the -xvars- and the -quadratic- options.  Choose one or the other."
				error 20742
				}
			}
		else {
			local H_XVARS : colfullnames e(b)
			local H_XVARS = subinstr( "`H_XVARS'", "_cons", " ",1) 
			if "`quadratic'" == "quadratic" {
			  * QUADratic option
			  foreach X in `H_XVARS' {
				tempvar `X'_2
				gen ``X'_2' = `X'^2
				local H_XVARS "`H_XVARS' ``X'_2'"
				local H_XVARS_EXP "`H_XVARS_EXP' (``X'_2' = `X'^2),"
				}  // end loop
			  } // end creation of X variables
		}  
		
		if "`H_XVARS_EXP'"=="" local H_XVARS_EXP `H_XVARS'
		`noisily' di "X Variables for Hetero adjustment: `H_XVARS_EXP'"

		gen double `RESIDUAL_SQR' = `RESIDUAL'^2 
		`noisily' reg `RESIDUAL_SQR' `H_XVARS'  if e(sample)  // use IN-SAMPLE residuals for smearing factor
		predict double `RESIDUAL_H' 
						
		`noisily' di as txt  "gen `heteroscedastic':" 
		`noisily' gen double `heteroscedastic'  = exp(  `YHATRAW' + 0.5 * `RESIDUAL_H'  )  if `touse'
			
		if length("`save'") gen `save' = exp(  0.5 * `RESIDUAL_H'  ) if `touse'
		
	}
} // end quiet section

if "`noisily'"!=""  {
	di "Summary of predlog2 variables: "
	summ `e(depvar)' `duan' `exp' `naive' `heteroscedastic'
}

_estimates unhold `OLS_est'

end 
