*! $Id: personal/k/kak_graph.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/03/29 00:09:46 (revision 4b119ce29a6c by user keith) $ 
*! A "helper" program.

* Quickly save a graph as a ".tif"  and a ."gph" file
* See help file for more info.

* Command:    kak_graph export filename , [any graph export options]
*             kak_graph save   filename , [any graph export options]
			
* kak_graph export is a "helper" program to quickly save a graph as a ".tif" 
* and a ."gph" file.  

* filename should include a valide extension (e.g.,  .emf, .tif, etc. )

*
*! By Keith Kranker
*! $Date$

program define kak_graph , 
  version 9.2
  syntax anything [, replace asis  *]
  gettoken subcmd anything : anything 
  
  * Subcommands of "export" and "save"
  if ("`subcmd'"=="export") | ("`subcmd'"=="save") {
    local filename `anything' // strip quotes off filename
	local reg_expr = regexm(`"`filename'"',"(.*)\.([a-zA-Z0-9]*)$") // split filename and extension
    local extension = regexs(2)
	if "`extension'"=="" local extension "emf"  // default extension
    local filename = trim(itrim(regexs(1))) // trim extra spaces
    
    di as input   "  Keith's helper program -kak_graph- will do the following: " _n ///
      `"  -> .  graph export "`filename'.`extension'" , `replace' `options'  "' _n  ///
      `"  -> .  graph save   "`filename'.gph" , `replace' `asis'"'  

    graph export "`filename'.`extension'" , `replace' `options'
    graph save   "`filename'.gph" , `replace' `asis'
    
  }
  else error 199
end

