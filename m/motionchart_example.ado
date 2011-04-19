*! $Id: personal/m/motionchart_example.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Create graphs of your data, from Stata, as a Google Motion Chart
* Example for help file

program define motionchart_example 
version 9.2
preserve

sysuse bplong.dta , clear
gen  year = 2007+when
gen  id = "patient" + string(patient)
decode sex , gen(gender)

cap {
	findfile motionchart_example.ado
	local file_loc_name = subinstr((substr(r(fn),1,(length(r(fn))-4))),"/","\",100)
	local file_full_name `"`file_loc_name'.html"'
	}

di as txt `"(File saved: `file_full_name')"'
motionchart id year bp gender using `"`file_full_name'"' in 115/124 , replace title("Blood Pressure") subtitle("Example motionchart: created in Stata with motionchart.ado") state(`"{"duration":{"timeUnit":"Y","multiplier":1},"nonSelectedAlpha":0.4,"yZoomedDataMin":142,"time":"2008","yZoomedDataMax":172,"iconKeySettings":[{"key":{"dim0":"patient60"},"trailStart":"2008"}],"yZoomedIn":false,"xZoomedDataMin":1199145600000,"xLambda":1,"playDuration":4111.1111111111095,"orderedByX":false,"xZoomedIn":false,"uniColorForNonSelected":false,"sizeOption":"_UNISIZE","iconType":"BUBBLE","dimensions":{"iconDimensions":["dim0"]},"xZoomedDataMax":1230768000000,"yLambda":1,"yAxisOption":"2","colorOption":"3","showTrails":true,"xAxisOption":"_TIME","orderedByY":false}"')

restore
end
