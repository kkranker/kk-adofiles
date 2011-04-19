*! $Id: personal/k/kak_add_return.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! A "helper" program to quickly add "return" scalars and locals 

* Multiple entries are allowed, and entries are parsed with blanks
*   
*!
*! By Keith Kranker
*! $Date$

/*
Syntax: 
         kak_add_return name1 entry1 [ name2 entry2 [ name3 entry3 .... ] ] 

For example, 
         .  kak_add_return  k1 123    k2 somethinghere      k3 567.5679    k4 yadayada
		 
yields the output		
		scalars:
		                r(k3) =  567.5679
		                r(k1) =  123
		macros:
		                r(k4) : "yadayada"
		                r(k2) : "somethinghere"
*/

program define kak_add_return, rclass

	while "`0'"!="" {
		gettoken rname 0 : 0 
		gettoken entry 0 : 0 , quotes
		if real(`"`entry'"')!=. return scalar `rname' = `entry'
		else                    return local  `rname' `"`entry'"'
		}
	  
	di as txt "Click to {stata return list}"

end 
