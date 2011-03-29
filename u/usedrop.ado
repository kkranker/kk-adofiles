*! $Id: personal/u/usedrop.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $
*! Use Stata dataset, excluding selected variables
*
*! By Keith Kranker
*! $Date$


program define usedrop, rclass 
    version 9.2
    syntax anything(name=dropvars) using [ , clear nolabel if(string) in(string) ]
	
qui {
        use in 1 `using' , `clear' nolabel  
        drop `dropvars'
        local drop keepvars 
        foreach v of var _all {
            local keepvars `keepvars' `v'
        }
    }
    di as txt `"The following command will be run:"' _n ///
       as input "use " as res `"`keepvars'"' _n as text "> " as txt `"`if' `in' `using', `clear' `label'"'
    use `keepvars' `if' `in' `using' , clear `label'
    
    return local vars `keepvars'
    return local dropped_vars `dropvars'

end


