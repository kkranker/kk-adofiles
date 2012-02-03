*! $Id: personal/m/memmax.ado, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $
*! Set memory to the maximum allowed by your operating system.

* Sets memory to the maximum level memory that is allowed by the operating system
* Default units are megabytes (m), but can also specify units(b|k|m|g)
* Progam assumes that the maximum memory possible is 2200 mb (~2.1 gb), but this can be overridden with end()
* Starts with the current memory allotment unless overriddent with start()
*!
*! By Keith Kranker
*! $Date$

program define memmax
	version 9.2
	syntax [anything] ///  an alternative to using the max() and units() option.  Must be entered in #[b|k|m|g] format ("1000m" "2g" etc.), like the set memory command.
		[, MIn(integer 0) MAx(integer 2200) Units(string) BUFfer(integer 25)]

	if regexm( `"`anything'"', "^([0-9]+)([bkmg]?)$" ) {
		if `max' != 2200  | !missing("`units'") di as error `"Because you typed "`anything'", max(`max') units(`units') will be ignored."'
		local max = regexs(1)
		local units = regexs(2)
	}
	else if !missing(`"`anything'"') {
		di as err `"memmax `anything' is invalid. Syntax (like "set memory") is "' _n `".   memmax #[b|k|m|g] "' 
		error 198
	}
	else if missing("`units'") local units "m"
	
	if       "`units'" == "m"  local scale = 1024
	else if  "`units'" == "b"  local scale = 1 / 1024
	else if  "`units'" == "k"  local scale = 1 
	else if  "`units'" == "g"  {
		// let user specify gibabytes.  I run program as if they specified m
		local scale = 1024
		local min = `min' * 1024
		if ( `max' != 2200 ) local max = `max' * 1024
		local units "m" 
		}
	else {
		di as error "You must choose units(b|k|m|g) (m is used if nothing selected)"
		error 198 
		}
		
	qui query mem
	
	if ( `buffer'==25 & "`units'"!="m") local buffer = floor(25 / `scale' * 1024)

	local start   = floor(`r(memory)' / `scale')
	local initial = floor(`r(memory)' / `scale')
	if ( `min' == 0 )    local min = `start'
	if ( `max' == 2200 ) local max = floor(2200*1024 / `scale')

	cap set memory `max'`units' 
	if _rc { 
	// section - incremental increases
	
	di "Program will attempt to increase memory from `start'`units' " _c 
	if (`min' != `start') di "to at least `min'`units' and " _c
	else                  di "to " _c
	di "a maximum of `max'`units' (1`units' = `scale'k):"
	
	foreach step in 10000000 2500000 1000000 250000 100000 25000 10000 2500 1000 250 100 25 10 1 {
		local loopstart = `min'
		cap {
		forvalues m = `min'(`step')`max' {
			set memory `m'`units'
		}
		}
		quietly query mem
		local min   = floor(r(memory) / `scale')
		if `min' > `loopstart' {
			di as txt "Increased Memory from " ///
			   _column(20) as res "`loopstart'`units'" ///
			   _column(40) as txt " to " as res "`min'`units'" ///
			   _column(60) as txt "(in steps of " as res "`step'" as txt ") "
		}
	}
	
	local final_mem = `min' - `buffer'
	if 	`min' == `max' {
		local one = 1 // do nothing
	}
	else if `final_mem' <= 0 & `buffer' {
		di as txt "Subtract buffer: " as res _column(43) "-`buffer'`units'" 
		di as error "You must choose a buffer such that [maximimum possible memory - buffer > 0] " 
		}
	else if `buffer'  {
		di as txt "Subtract buffer: " as res _column(43) "-`buffer'`units'" 
		quietly set memory `final_mem'`units'
		}
	
	} // section - incremental increases
	
	noisily query mem

end
