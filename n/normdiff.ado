*! $Id: personal/n/normdiff.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 06:28:18 (revision 0cc1679684a2 by user keith) $
*! Create a table to compare two groups, including normalized differences.
*
* For each variable, this program calculates Delta_X  and  T  from forumlas (3) and (4) of 
*
* Imbens & Wooldridge  (2009) "Recent Developments in the Econometrics of Program Evaluation."
*      Journal of Economic Literature.  March 2009, Volume XLVII, Number 1.
*
*! By Keith Kranker
*! $Date$


program define normdiff, eclass 

version 9

syntax varlist(min=1 numeric) [if] [in] ///
	, ///
	over(varname)   	///  Key option --> creates columns
	[ 				    ///  
	Difference			///  Add a column w/ difference between means (not-normalized)
	Tstat				///  Add a column w/ t-statistic for the null hypothesis of equal means
	Casewise			///  perform casewise deletion of observations
	n(string)           ///  Specify location of sample size: {below|over|total|off}
	Format(passthru) 	///  Specify format for display of tables (matrix saves all digits)
	]
	
// Selects observations using the "casewise" behavior based on the marksample
marksample touse 

quietly count if `touse'
local count_touse = r(N)

quietly count `if' `in' 
local count_ifin = r(N)

if "`casewise'"=="casewise" local if "if `touse'"
if "`if'" == "" local if_and "if"
else            local if_and "`if' & "

* Check that `over' is valid:  Must always ==0 or ==1 
cap assert ( `over' == 0 | `over' == 1) `if' `in' 
	if _rc !=0    	{
		noisily di as error "`over' must equal {0,1} `if' `in'"
		exit
		}

* Check that n(string) is valid
if "`n'"=="" local n "below" // defalt
cap assert ("`n'"=="below" | "`n'"=="over" |"`n'"=="total" |"`n'"=="off")
if _rc !=0    	{
		noisily di as error "option invalid: n(below|over|total|off)"
		exit
		}

* Dots to show somthing is happening for really large datasets.		
local varnum : word count `varlist'
if (( `varnum' > 10 | `count_touse' > 10000 ) & ( "`noisily'" != "noisily" )) local dots "dots" 
if "`dots'"=="dots" noisily di as text "Variables completed: " _c
	
local v=0
tempvar  temp
tempname table table_n table_diff table_tstat row_n

foreach y of local varlist {
    local ++v
	if "`dots'"=="dots" noisily di as res "..`v'" _c
		
	* Mean, sample varience, and sample size of y, over==0
	summ `y' `if_and' `over'==0 `in', meanonly
	local ybar_0 = r(mean)
	local y_n_0 = r(N)
	quietly gen  `temp' = (`y' - `ybar_0' )^2 `if_and' (`over'==0) `in'
	summ `temp' `if_and' (`over'==0) `in', meanonly
	local var_0 = r(sum) / ( `y_n_0' - 1 )
	drop `temp'
		
	* Mean, sample varience, and sample size of y, over==1
	summ `y' `if_and' `over'==1 `in', meanonly
	local ybar_1 = r(mean)
	local y_n_1 = r(N)
	quietly gen  `temp' = (`y' - `ybar_0' )^2 `if_and' (`over'==1) `in'
	summ `temp' `if_and' (`over'==1) `in', meanonly
	local var_1 = r(sum) / ( `y_n_1' - 1 )
	drop `temp' 	

	* Normalized Difference
	local y_diff_norm  = ( `ybar_1' - `ybar_0' ) / sqrt( `var_1' + `var_0')
 
	* Save results "`table'" matrix
	if ( `v'==1 )  mat `table' = (            `ybar_0' , `ybar_1' , `y_diff_norm' )
	else           mat `table' = ( `table' \  `ybar_0' , `ybar_1' , `y_diff_norm' )
 	if ( `v'==1 )  mat colname `table' = "Mean:`over'==0" "Mean:`over'==1" "Difference:Normalized"
		
	* Difference (not normalized)
	if "`difference'" == "difference"   {
		local y_diff = `ybar_1' - `ybar_0'
		if ( `v'==1 )  mat `table_diff' = (                `y_diff' )
		else           mat `table_diff' = ( `table_diff' \ `y_diff' )
		if ( `v'==1 )  mat colname `table_diff' = "Difference:Means"
	}

	* T-statistic on difference in means
	if "`tstat'" == "tstat"   {
		local y_tstat  = ( `ybar_1' - `ybar_0' ) / sqrt( ( `var_1' / `y_n_1' ) + ( `var_0' / `y_n_0' ) )
		if ( `v'==1 )  mat `table_tstat' = (                 `y_tstat' )
		else           mat `table_tstat' = ( `table_tstat' \ `y_tstat' )
		if ( `v'==1 )  mat colname `table_tstat' = "Difference:t-stat"
	}

	* Sample Sizes 
	local y_n =  `y_n_1' + `y_n_0'
	if ( `v'==1 ) mat `table_n' = (             `y_n_0' , `y_n_1' , `y_n' )
	else          mat `table_n' = ( `table_n' \ `y_n_0' , `y_n_1' , `y_n' )
	if ( `v'==1 ) mat colname `table_n' = "N:`over'==0" "N:`over'==1" "N:All"

}   // end loop thru varlist

* Add row labels 
foreach mat in `table' `table_n' `table_diff' `table_tstat'  {
	cap mat rowname `mat' = `varlist'  
	} 

* Total N for last row of table, warning if sample size is inconsistent.
capture {
	local n_11 = `table_n'[1,1]
	local n_21 = `table_n'[1,2]
	mat `row_n' = ( `n_11' , `n_21')
	mat rownames `row_n' = "N"
	local rows = rowsof( `table_n' )
	forvalues r=2/`rows' {
		local n_1r = `table_n'[`r',1]
		local n_2r = `table_n'[`r',2]
		assert ( `n_1r' == `n_11') & ( `n_2r' == `n_21')
	}
}	
if _rc !=0 {
	di as error "The number of observations with data in each row (created by -varlist-) is not uniform." 
		if ( "`n'" == "below" ) {
			di as error "The -n- option was changed from n(" as res "below" as error ") to n(" as res "over" as error ")."
			local n "over"
			}
}
	
* Add other statistics and sample sizes.	
if ("`difference'" == "difference")  	 mat `table' = ( `table' , `table_diff' )
if ("`tstat'" == "tstat")            	 mat `table' = ( `table' , `table_tstat' )
if      "`n'"=="over" 	         		 mat `table' = ( `table' , `table_n'[....,1..2])
else if "`n'"=="total"                   mat `table' = ( `table' , `table_n'[....,3])
else if "`n'"=="below" 					 mat `table' = ( `table' \ `row_n' , ( .z * `table'[1,3...] ) )

// post results to ereturn
ereturn clear
ereturn matrix    table      = `table'
ereturn matrix    _n         = `table_n' 

// display before e(table)
mat list e(table)               , nodotz `format' noheader
		
end
