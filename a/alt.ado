*! $Id: personal/a/alt.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! alter (demean, normalize, and scale) vaiables. 

* This probrams ALTers variables in varlist.  available sub-commands are
*	alt demean:       X2 = X1-mean(X1)                     subract mean(varname) from varname
*	alt standardize:  X2 = ( X1-mean(X1) ) / sd(S1)        normalize to mean=0, std.dev.=1
*	alt scale:        X2 = (X1-min(X1))/(max(X1)-min(X1))  rescale to range [0,1]
*
*!
*! By Keith Kranker
*! $Date$

program define alt, byable(onecall) sortpreserve
	gettoken subcmd 0 : 0
	if inlist( "`subcmd'","dem","deme","demea","demean")  {
		if _by()  by  `_byvars' : alt_demean `0'
		else                      alt_demean `0'
	}
	else if inlist( "`subcmd'","stand","standa","standar","standard","standardi","standardiz","standardize","normalize") {
		if _by()  by  `_byvars' : alt_norm `0'
		else                      alt_norm `0'
	}
	else if inlist( "`subcmd'","sc","sca","scal","scale") {
		if _by()  by  `_byvars' : alt_scale `0'
		else                      alt_scale `0'
	}
	else error 199
end

program define alt_demean, byable(onecall) sortpreserve
	version 9.2
	syntax varlist(numeric) [if] [in] [ ,   ///
		 /* Variable names */ PREfix(string) SUFfix(string) Generate(namelist) Replace ///
		 /* Labels         */ noLabel Addtolabel(string) ///
		 /* Casewise       */ Casewise ]

	// Mark Sample
	if "`casewise'"=="" marksample touse, novarlist
	else                marksample touse
	sort `touse' `_byvars' 
	  
	tempvar temp0 temp1

	if length( "`Addtolabel'") & length( "`label'") {
		di "You cannot choose both the -addtolabel- and -nolabel- options."
		error 198
		}
	if _by() & length("`replace'") & (length("`in'") | length("`if'")) {
		di as error "This combination of -if-, -in-, -by-, and -replace- is allowed together."
		error 198
		}
	if (length("`prefix'") > 0) + (length("`suffix'") >0) + (length("`replace'") >0) + (length("`generate'") >0) != 1  {
		di as error "You must specify one variable name option."
		error 198
		}
	   
	// Make sure destination variable name   
	local count = 0
	foreach var of local varlist {
		
		// variable name
		if length( "`replace'") {
			local newvar `var'
			}
		else if length( "`generate'") {
			local count = `count' + 1 
			local newvar : word `count' of "`generate'"
			qui : gen `newvar' = .
			}
		else if length( "`prefix'")	{
			local newvar `prefix'`var'
			qui : gen `newvar' = .
			}
		else if length( "`suffix'")	{
			local newvar `var'`suffix'
			qui : gen `newvar' = .
			}		
		else {
			di as error "You must choose one of these options: -prefix- -suffix- -generate- or -replace-"
			error 198
			}
			
		// labels
		if length( "`Addtolabel'" ) {
				local lab : var label `var'
				label var `newvar' `"`lab' `addtolabel'"'  // label may have "
				}
		else if length( "`label'" )==0 {
				local lab : var label `var'
				if length("`replace'") {
					if length("`lab'") label var `newvar' "`lab', de-meaned"
					else               label var `newvar' "`var' - mean(`var')"
					}
				else                   label var `newvar' "`var' - mean(`var')"
				}

		by `touse' `_byvars' : egen `temp0' = mean( `var' ) if `touse'
		replace `newvar' = `var' - `temp0' if `touse'
		drop `temp0'

	}  // close loop through varlist
end

// note: This is just the alt_demean program, with changes to variable labels and last 3 or 4 lines
program define alt_norm, byable(onecall) sortpreserve
	version 9.2
	syntax varlist(numeric) [if] [in] [ ,   ///
		 /* Variable names */ PREfix(string) SUFfix(string) Generate(namelist) Replace ///
		 /* Labels         */ noLabel Addtolabel(string) ///
		 /* Casewise       */ Casewise ]

	// Mark Sample
	if "`casewise'"=="" marksample touse, novarlist
	else                marksample touse
	sort `touse' `_byvars' 
	  
	tempvar temp0 temp1

	if length( "`Addtolabel'") & length( "`label'") {
		di "You cannot choose both the -addtolabel- and -nolabel- options."
		error 198
		}
	if _by() & length("`replace'") & (length("`in'") | length("`if'")) {
		di as error "This combination of -if-, -in-, -by-, and -replace- is allowed together."
		error 198
		}
	if (length("`prefix'") > 0) + (length("`suffix'") >0) + (length("`replace'") >0) + (length("`generate'") >0) != 1  {
		di as error "You must specify one variable name option."
		error 198
		}
	   
	// Make sure destination variable name   
	local count = 0
	foreach var of local varlist {
		
		// variable name
		if length( "`replace'") {
			local newvar `var'
			}
		else if length( "`generate'") {
			local count = `count' + 1 
			local newvar : word `count' of "`generate'"
			qui : gen `newvar' = .
			}
		else if length( "`prefix'")	{
			local newvar `prefix'`var'
			qui : gen `newvar' = .
			}
		else if length( "`suffix'")	{
			local newvar `var'`suffix'
			qui : gen `newvar' = .
			}		
		else {
			di as error "You must choose one of these options: -prefix- -suffix- -generate- or -replace-"
			error 198
			}
			
		// labels
		if length( "`Addtolabel'" ) {
				local lab : var label `var'
				label var `newvar' `"`lab' `addtolabel'"'  // label may have "
				}
		else if length( "`label'" )==0 {
				local lab : var label `var'
				if length("`replace'") {
					if length("`lab'") label var `newvar' "`lab', with mean=0 and stddev=1"
					else               label var `newvar' "`var' with mean=0 and stddev=1"
					}
				else                   label var `newvar' "`var' with mean=0 and stddev=1"
				}

		by `touse' `_byvars' : egen `temp0' = mean( `var' ) if `touse'
		by `touse' `_byvars' : egen `temp1' = sd( `var' ) if `touse'
		replace `newvar' = ( `var' - `temp0') / `temp1' if `touse'
		drop `temp0' `temp1'
		
	}  // close loop through varlist
end

// note: This is just the alt_demean program, with changes to variable labels and last 3 or 4 lines
program define alt_scale, byable(onecall) sortpreserve
	version 9.2
	syntax varlist(numeric) [if] [in] [ ,   ///
		 /* Variable names */ PREfix(string) SUFfix(string) Generate(namelist) Replace ///
		 /* Labels         */ noLabel Addtolabel(string) ///
		 /* Casewise       */ Casewise ]

	// Mark Sample
	if "`casewise'"=="" marksample touse, novarlist
	else                marksample touse
	sort `touse' `_byvars' 
	  
	tempvar temp0 temp1

	if length( "`Addtolabel'") & length( "`label'") {
		di "You cannot choose both the -addtolabel- and -nolabel- options."
		error 198
		}
	if _by() & length("`replace'") & (length("`in'") | length("`if'")) {
		di as error "This combination of -if-, -in-, -by-, and -replace- is allowed together."
		error 198
		}
	if (length("`prefix'") > 0) + (length("`suffix'") >0) + (length("`replace'") >0) + (length("`generate'") >0) != 1  {
		di as error "You must specify one variable name option."
		error 198
		}
	   
	// Make sure destination variable name   
	local count = 0
	foreach var of local varlist {
		
		// variable name
		if length( "`replace'") {
			local newvar `var'
			}
		else if length( "`generate'") {
			local count = `count' + 1 
			local newvar : word `count' of "`generate'"
			qui : gen `newvar' = .
			}
		else if length( "`prefix'")	{
			local newvar `prefix'`var'
			qui : gen `newvar' = .
			}
		else if length( "`suffix'")	{
			local newvar `var'`suffix'
			qui : gen `newvar' = .
			}		
		else {
			di as error "You must choose one of these options: -prefix- -suffix- -generate- or -replace-"
			error 198
			}
			
		// labels
		if length( "`Addtolabel'" ) {
				local lab : var label `var'
				label var `newvar' `"`lab' `addtolabel'"'  // label may have "
				}
		else if length( "`label'" )==0 {
				local lab : var label `var'
				if length("`replace'") {
					if length("`lab'") label var `newvar' "`lab', scaled to [0,1]"
					else               label var `newvar' "`var', scaled to [0,1]"
					}
				else                   label var `newvar' "`var', scaled to [0,1]"
				}
		
		by `touse' `_byvars' : egen `temp0' = min( `var' ) if `touse'
		by `touse' `_byvars' : egen `temp1' = max( `var' ) if `touse'
		replace `newvar' = ( `var' - `temp0') / ( `temp1' - `temp0') if `touse'
		drop `temp0' `temp1'
		
	}  // close loop through varlist
end
