*! $Id: personal/c/csvvars.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Export variable names and labels to text file.
*
*! By Keith Kranker
*! $Date$

* This use to be a file, now I just sent commands to txtvarlist

program define csvvars
	version 9.2
	syntax [varlist] using [, NOLabels NOIsily Timestamp Replace Append]
	tempname myfile

	local opt `"`replace' parse(",")"'
	if !missing("`append'")      local opt `"`opt' "'  // txtvarlist has append by default
	else if missing("`replace'") local opt `"`opt' noappend"'
	else error 198

	if missing("`labels'")       local opt 	"`opt' labels"'  // txtvarlist has nolabels by default	
	if !missing("`noisily'")     di "-noisily- option no longer available; it was ignored."
	if !missing("`timestamp'")   local opt `"`opt' suffix("$S_DATE $S_TIME") "'
	
	txtvarlist `varlist' `using' , `opt'
	
end
