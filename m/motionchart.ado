*! $Id: personal/m/motionchart.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/14 20:38:06 (revision ca0de793b584 by user keith) $
*! Create graphs of your data, from Stata, as a Google Motion Chart

* Create an HTML file that will graph your data as a Google Motion Chart.  
*
* Reference:  
* Google API:  http://code.google.com/apis/visualization/documentation/gallery/motionchart.html 
*
* To do : make code more flexible with date variables.  Right now, it only takes years (integers).
*!
*! .ado file by Keith Kranker
*! $Date$

program define motionchart , sortpreserve

version 9.2
syntax varlist(min=2)							///  first variable must be the ID of the unit (as a number), 2nd must be a date, other variables serve as y-axis or categorical variables
	using 										///  filename
	[if] [in]   								///  restrict data
	[ ,     									///  options
	REPlace 									///  replace using output file
	TITle(str) SUBTitle(str)                    ///  Add titles or notes to output file
	TEXt(str) NOTe(str) TIMestamp               ///  
	Height(integer 400) Width(integer 600)		///  Height/Width of the chart in pixels.
	State(string)							    ///  Initial state for getState()
	HIDEpanel  									///  hides the right hand panel.
	TYpe 										///  print output on screen after running command
	]

tempvar  touse
gen     `touse' = 0 
replace `touse' = 1 `if' `in'
cap duplicates report `varlist' if `touse'
if  r(unique_value) !=  r(N) {
	duplicates report `varlist' if `touse'
	di as error "-motionchart- can not use data with duplicate observations." 
	error 20742
	}

gettoken id   varlist : varlist
gettoken date varlist : varlist

* Open file
tempname   myfile
file open `myfile' `using' , write text `replace'

* HTML Header Information
file write `myfile' ///
		`"<html> "' _n  ///
		`"  <head> "' _n ///
		`"    <style type="text/css">"' _n ///
		`"        body{font-family:Helvetica,Arial,sans-serif;}"' _n ///
		`"        h1{font-size:1.15em;}"' _n ///
		`"        h1{font-size:1.075em;}"' _n ///
		`"    </style>"' _n ///
		`"    <script type="text/javascript" src="https://www.google.com/jsapi"></script>"' _n ///
		`"    <script type="text/javascript">"' _n ///
		`"      google.load('visualization', '1', {'packages':['motionchart']});"' _n ///
		`"      google.setOnLoadCallback(drawChart);"' _n ///
		`"      function drawChart() { "' _n ///
		`"        var data = new google.visualization.DataTable(); "' _n 
 

* Data - Column defininitions
foreach v of var `id' `date' `varlist' {
	local v_label : variable label `v'
	if length("`v_label'")==0 local v_label "`v'"
	
	local v_fmt  : format `v' 
	local v_type : type `v' 

	local isstring = (substr("`v_type'",1,3) == "str")
	local isdate  = (substr("`v_fmt'",1,2) == "%d" | substr("`v_fmt'",1,2) == "%t")
		
	if      `isstring' | "`v'"=="`id'"   local v_type = "string"
	else if `isdate'   | "`v'"=="`date'" local v_type = "number"
	else                                 local v_type = "number"
	
	capture local val_label : value label `v'
	local v_has_val_label = _rc
		
	file write `myfile' ///	
		`"        data.addColumn('`v_type'', '`v_label''); "' _n ///
	
}

* Data - Rows of Data 
qui count 
local total_rows = r(N)

tempvar row_number
egen `row_number' = group(`id' `date' `varlist') if `touse'
summ `row_number', meanonly
local last_row = r(max)

file write `myfile' `"        data.addRows([ "' 
forvalues k = 1/`total_rows' {
	if `touse'[`k']==0 continue

	file write `myfile' _n ///
		`"            ["'  
	
	foreach v of var `id' `date' `varlist' {
		local v_fmt  : format `v' 
		local v_type : type `v' 
		local isstring = (substr("`v_type'",1,3) == "str")
		
		if "`v'"!="`id'" file write `myfile' ","
		
		if `isstring' | "`v'"=="`id'" file write `myfile' _char(39)  (`v'[`k']) _char(39)
		else                          file write `myfile'            (`v'[`k']) 
		}
	
	file write `myfile' "]"
	
	if `row_number'[`k'] < `last_row'  file write `myfile' ","
	
}
file write `myfile' _n ///
		`"          ]); "' _n 	
	
	
* Continue HTML Header Information	
file write `myfile' ///	
		`"        var chart = new google.visualization.MotionChart(document.getElementById('chart_div')); "' _n ///
		`"        var options = {}; "' _n ///
		`"        options['width'] = `width'; "' _n ///
		`"        options['height'] = `height'; "' _n 
if length(`"`state'"') {
	file write `myfile' ///
		`"        options['state'] = '`state'';"' _n     // State Option
}
else if length(`"`hidepanel'"') {
	file write `myfile' ///
		`"        options['showSidePanel'] = 'false';"' _n   // Hidepanel Option
	}
file write `myfile' ///		
	`"        chart.draw(data, options); "' _n ///
	`"      } "' _n ///
	`"    </script> "' _n ///
	`"  </head> "' _n ///
	`"   "' _n ///
	`"  <body> "' _n 
  
  
* Insert Title
if !missing(`"`title'"')     file write `myfile' `"   <h1>`title'</h1>"' _n  
if !missing(`"`subtitle'"')  file write `myfile' `"   <h2>`subtitle'</h2>"' _n  
	
* Insert Text 
if !missing(`"`text'"')      file write `myfile' `"   <p>`text'</p>"' _n   

* Insert Chart	
file write `myfile' `"   <div id="chart_div" style="width: `width'px; height: `height'px;"></div> "' _n

* Insert Note 
if !missing(`"`note'"')      file write `myfile' `"   <p>`note'</p>"' _n   

* Insert Timestamp 
if !missing(`"`timestamp'"') file write `myfile' `"   <p><small><i>$S_DATE $S_TIME</i></small></p>"' _n
	
* HTML Footer 
file write `myfile' ///	
	`"  </body> "' _n  ///
	`"</html> "' _n ///	
	
	
* Done with file
file close `myfile'


* Type option 
if length(`"`type'"') {
	gettoken ucmd filename : using 
	di as text `"Contents of`filename'"'
	type `filename', asi
	}

	
* Link to file
gettoken ucmd filename : using 
local         filename `filename'
di as txt "Open output file: " `"{browse `"`filename'"'}"'
di as txt "View output file: " `"{view `""`filename'""':view "`filename'"}"'	

end
