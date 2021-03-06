*! $Id: personal/a/areastack.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! graph command like "twoway area" which "stacks" the over(), instead of overlaying them.

* This program is similar to "twoway area",
* except that it "stacks" the areas to a cumulative height
* (similar to "graph bar ... , stack").
*
* At it's core, this program creates a "cumulative" y-variable
*   . bys x_var (over_var) : gen cumulative = sum(x_var)
*
* Then, it executes a command like this:
*   . graph twoway
*        (area cumulative x_var if over_var==4 )
*        (area cumulative x_var if over_var==3 )
*        (area cumulative x_var if over_var==2 )
*        (area cumulative x_var if over_var==1 )
*        , legend(order(4 3 2 1) label(1 "over_var label 1") ... label(4 "over_var label 4"))
*
* Any options are passed along to the graph twoway command.
*
*! By Keith Kranker
*! $Date$

program define areastack, sortpreserve
  version 9
  syntax varlist(min=2 max=2 numeric) [if] [in] , ///
    over(varname) ///
    [ quietly /// don't show twoway graph command
    *] // other options passed along to graph twoway

  marksample touse
  gettoken y x : varlist

  tempvar index
  egen `index' = group( `over' ), missing label
  
  summ `index' , meanonly
  local min = r(min)
  local max = r(max)
  assert r(min)==1

  cap assert `y'>0 & !missing(`y')
  if _rc {
    di as error "`y' must be >0 & !missing()"
    error 198
  }

  tempvar cum
  bys `x' (`index') : gen `cum' = sum(`y') if `touse'
  lab var `cum' "`:var lab `y''"
  // browse `index' `over' `y' `cum'

  di as txt  "-areastack- will execute the following command:"
  di as input _col(4) ". graph twoway"

  local c=`max'
  while `c'>=1 {
    local clab : label ( `index' ) `c'
	local clab = subinstr(`"`clab'"',`"""',"",.)

    local g`c'          `"(area `cum' `x' if `touse' & `index'==`c' )"'

    di as input _col(8) `"(area stacked[`y'] `x' if \`touse' & `over'=="' as res `"`clab'"' as input ")"

    local labels `"label(`=`max'+1-`c'' "`clab'") `labels'"'
    local ord    : list ord | c

    local graphlist "`graphlist' \`g`c''"

    local --c
  }

  di as input _col(8)   `", legend(order(`ord') `labels')"' _n _col(10) `"`options'"'

  graph twoway `graphlist', legend(order(`ord') `labels') `options'
end
