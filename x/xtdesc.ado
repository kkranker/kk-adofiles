*! $Id: personal/x/xtdesc.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Synonym for xtdes

* I always make the typo of typing "xtdesc" instead of "xtdes."  Now, no longer...

program define xtdesc
	di as input   "  Keith's helper program -xtdesc- will do the following: " _n ///
	              `"  -> . xtdes `0' "'
	xtdes `0'   
end
