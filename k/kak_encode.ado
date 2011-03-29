*! $Id: personal/k/kak_encode.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! A "helper" program.  
*
* Quickly run an encode command, except overwrites old (not-encoded) variable with the new variable
* 
*Syntax: 
*   kak_encode varname [if] [in] , [label(name) noextend]
*!
*! By Keith Kranker
*! $Date$

program define kak_encode, rclass

	syntax varname [if] [in] , [Label(passthru) noExtend]
	
	tempvar tempvariable 
	
	if "`label'"=="" local label "label(`varlist')"

	di as txt "  Keith's helper program -kak_encode- will do the following: " _n ///
       as input "  -> . encode  `varlist' `if' `in', gen(`tempvariable') `label' `extend'" _n ///
                "  -> . move `tempvariable' `varlist' " _n ///
                "  -> . drop `varlist'" _n ///
                "  -> . rename `tempvariable' `varlist'" 

	encode  `varlist' `if' `in', gen(`tempvariable') `label' `extend'
	move `tempvariable' `varlist'
	drop `varlist'
	rename `tempvariable' `varlist'

	   
end 
