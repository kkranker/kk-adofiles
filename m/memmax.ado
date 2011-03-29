*! $Id: personal/m/memmax.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
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
	syntax [, min(integer 0) max(integer 2200) units(string) BUFfer(integer 25)]

	if ("`units'" != "") local u "`units'"
	else local u "m"
	if       "`u'" == "m"  local scale = 1024
	else if  "`u'" == "b"  local scale = 1 / 1024
	else if  "`u'" == "k"  local scale = 1 
	else if  "`u'" == "g"  local scale = 1024^2
	else {
		di as error "You must choose units(b|k|m|g) (m is used if nothing selected)"
		error 20742 
		}
		
	qui query mem
	
	if ( `buffer'==25 & "`u'"!="m") local buffer = floor(25 / `scale' * 1024)

	local start   = floor(`r(memory)' / `scale')
	local initial = floor(`r(memory)' / `scale')
	if ( `min' == 0 )    local min = `start'
	if ( `max' == 2200 ) local max = floor(2200*1024 / `scale')
	
	di "Program will attempt to increase memory from `start'`u' " _c 
	if (`min' != `start') di "to at least `min'`u' and " _c
	else                  di "to " _c
	di "a maximum of `max'`u' (1`u' = `scale'k):"
	
	foreach step in 10000000 1000000 100000 10000 1000 100 10 1 {
		local loopstart = `min'
		cap {
		forvalues m = `min'(`step')`max' {
			set memory `m'`u'
		}
		}
		quietly query mem
		local min   = floor(r(memory) / `scale')
		if `min' > `loopstart' {
			di as txt "Increased Memory from " ///
			   _column(20) as res "`loopstart'`u'" ///
			   _column(40) as txt " to " as res "`min'`u'" ///
			   _column(60) as txt "(in steps of " as res "`step'" as txt ") "
		}
	}
	
	local final_mem = `min' - `buffer'
	if 	`min' == `max' {
		local one = 1 // do nothing
	}
	else if `final_mem' <= 0 {
		di as txt "Subtract buffer: " as res _column(43) "-`buffer'`u'" 
		di as error "You must choose a buffer such that [maximimum possible memory - buffer > 0] " 
		}
	else if `min' == `initial' {
		di as txt "(Unchanged)  " _c
	}
	else {
		di as txt "Subtract buffer: " as res _column(43) "-`buffer'`u'" 
		quietly set memory `final_mem'`u'
		}
	
	quietly query mem
	local min   = floor(r(memory) / `scale')
	di as txt "Final Memory: "            as res _column(44) "`min'`u'" 

	if (`min' != `max') & (`final_mem' <= 0)  error 20742 

end
