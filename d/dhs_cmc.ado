*! $Id: personal/d/dhs_cmc.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Interpret a DHS variable that is a "Country Month Code" 
*! generates variables with year, month, or month/quarter time formats
*!
*! By Keith Kranker
*! $Date$

program define dhs_cmc

syntax varlist(numeric) [if] [in], [Month Quarter Only] 

marksample touse

di as txt "Program converts a DHS's Country Month Code (CMC) into these variables:" _n ///
	"Variable" _column(20) "Month"  _column(40) "Year"  _column(60) "Month/Year" _column(80) "Quarter/Year"  _c

foreach cmc of local varlist {
  qui {
	tempvar `cmc'_YY `cmc'_YYYY `cmc'_MM
	local templabel : var label `cmc'
	local templabel = subinword("`templabel'","(cmc)","",1)
	
	gen int ``cmc'_YY' = .
	gen int ``cmc'_YYYY' = .
	gen int ``cmc'_MM' = .
	 
	replace ``cmc'_YY'   = int((`cmc'- 1)/ 12)       if `touse' & `cmc' < 1201 
	replace ``cmc'_YYYY' = ``cmc'_YY' + 1900         if `touse' & `cmc' < 1201 
	replace ``cmc'_MM'   = `cmc' - (``cmc'_YY' * 12) if `touse' & `cmc' < 1201 
	
	replace ``cmc'_YYYY' = int((`cmc'- 1) / 12)+1900      if `touse' & `cmc' >= 1201 & `cmc' <. 
	replace ``cmc'_MM'   = `cmc' - ((``cmc'_YYYY'-1900) * 12) if `touse' & `cmc' >= 1201 & `cmc' <. 
	
	move ``cmc'_MM'   `cmc'
	move ``cmc'_YYYY' `cmc'
	move `cmc'      ``cmc'_MM'
	
	if length("`month'") {
		gen int   `cmc'_month = ym(``cmc'_YYYY',``cmc'_MM') if `touse'
		format `cmc'_month %tmN/CY
		move `cmc'_month ``cmc'_YYYY' 
		move ``cmc'_YYYY'  `cmc'_month
		label var `cmc'_month "`templabel'(m/y)"
		assert `cmc'_month !=. if `cmc' & `touse'
		}
	if length("`quarter'") {
		gen int   `cmc'_qtr = qofd(dofm(ym(``cmc'_YYYY',``cmc'_MM'))) if `touse'
		format `cmc'_qtr %tmCY:q
		move `cmc'_qtr   ``cmc'_YYYY' 
		move ``cmc'_YYYY'  `cmc'_qtr
		label var `cmc'_qtr "`templabel'(y:q)"
		assert `cmc'_qtr !=. if `cmc' & `touse'
		}
	if length("`only'") {
		drop ``cmc'_MM' ``cmc'_YYYY'
		}

	noisily di as txt _n "`cmc'" _c
	if length("`only'")==0 {
		rename ``cmc'_MM'   `cmc'_MM
		rename ``cmc'_YYYY' `cmc'_YYYY
		label var `cmc'_YYYY "`templabel'(year)"
		label var `cmc'_MM   "`templabel'(month)"
		noisily di as res  _column(20)  abbrev("`cmc'_MM",19)  _column(40) abbrev("`cmc'_YYYY",19)  _c
		}
	if length("`month'")   {
		noisily di as res _column(60) abbrev("`cmc'_month",19)  _c	
		}
	if length("`quarter'") {
		noisily di as res _column(80) abbrev("`cmc'_qtr",19) 	
		}
	di " "		
  }
}

end
