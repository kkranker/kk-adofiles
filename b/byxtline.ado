*! $Id: personal/b/byxtline.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/08 00:41:04 (revision 6151a8eae547 by user keith) $
*! Wrapper for "xtline,overlay" that enables the by: prefix.  

* This program exists because you aren't allowed to execute 
* 	by var : xtline .....
* This is a workaround.  There's a problem with the legends, but it's a first attempt.
* 
* Example: 
* bys country : byxtline mortality_rate , i(age) t(t) legend(off)
*
*! By Keith Kranker
*! $Date$

cap program drop byxtline
program define byxtline, byable(onecall) sortpreserve
version 9
syntax varname [if] [in] , ///
	[ ///
	/// graph combine options
        COLFirst Rows(passthru) Cols(passthru) HOLes(passthru) iscale(passthru) altshrink imargin(passthru) ///
        YCOMmon XCOMmon ///
        commonscheme  scheme(passthru) ///
		TItle(passthru) SUBtitle(passthru) note(passthru) CAPtion(passthru) ///
		YSIZe(passthru) XSIZe(passthru) GRAPHRegion(passthru) PLOTRegion(passthru) ///
        nodraw name(passthru) saving(passthru) ///
	/// xtline options (overlay) is always on
		*     /// all other options passed to xtline ... , overlay                                                                           ///
	 ]  
	 
marksample touse
tempvar index

if !_by() {
	di as error "by variable: not specified"
	exit 
	}

egen `index' = group( `_byvars' ), missing label
summ `_byindex' , meanonly
local min = r(min)
local max = r(max)

di as txt "Creating graphs for " _c
forvalues c = `min'/`max' {
	local clab : label ( `index' ) `c'
	tempname g`c'
	di "`clab', " _c
	xtline `varlist' if (`touse' & `index'==`c') , `options' overlay name( `g`c'' ) nodraw title( "`clab'") 
	local graphlist `graphlist' `g`c''
}

graph combine `graphlist', `colfirst' `rows' `cols' `holes' `iscale' `altshrink' `imargin' `ycommon' `xcommon' `commonscheme' `scheme' `title' `subtitle' `note' `caption' `ysize' `xsize' `graphregion' `plotregion' `nodraw' `name' `saving'  

end


