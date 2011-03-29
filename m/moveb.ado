*! $Id: personal/m/moveb.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! move below

* moveb stands for "move below"
* Identical to the move command, move varname1 varname2
* but it will move varname1 BELOW varname2, not above varname2
*!
*! By Keith Kranker
*! $Date$

program define moveb
	syntax varlist(min=2 max=2)
	gettoken  var1 var2 : varlist

	di as input "  Keith's helper program -moveb- will do the following: " _n ///
                "  -> . move  `var1' `var2' " _n ///
                "  -> . move `var2'  `var1' "
	
	move `var1' `var2'		 
	move `var2' `var1'
end
