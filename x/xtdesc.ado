*! $Id: personal/x/xtdesc.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Synonym for xtdes

* I always make the typo of typing "xtdesc" instead of "xtdes."  Now, no longer...

program define xtdesc
	di as input   "  Keith's helper program -xtdesc- will do the following: " _n ///
	              `"  -> . xtdes `0' "'
	xtdes `0'   
end
