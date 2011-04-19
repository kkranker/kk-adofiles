*! $Id: personal/d/deadline.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*!  Returns an error if the current time is past your "deadline"

// BASIC USE: 
// deadline 18nov2010 06:44:19
// 
// MULTIPLE DEADLINE CHECKS:
// deadline 20nov2010 11:30:19     <-- Sets the deadline and checks if it's expired. saves deadline for later in global $SET_DEADLINE
// yada yada yada 
// deadline                        <-- checks deadline ($SET_DEADLINE, from above) expired 
*!
*! By Keith Kranker
*! $Date$

program define deadline, rclass 
	if !missing(`"`0'"') {
		local parse = regexm(`"`0'"',`"([0-9][0-9][a-z][a-z][a-z][0-9][0-9][0-9][0-9]).*([0-9][0-9]:[0-9][0-9]:[0-9][0-9])+"')
		local d = regexs(1)
		local t = regexs(2)
		di as txt "Deadline: " as res "`d'"     as txt "   (" as res "`t'"   as txt ")" _c
		local d = d(`d')
		_parse_time_for_deadline `t'
		local deadline = `d' + r(frac_of_day)
		global SET_DEADLINE = `deadline'
	}
	else if !missing($SET_DEADLINE) {
		local deadline = $SET_DEADLINE
		di as txt "Deadline: " as res %d `deadline' as txt "   (" as res round((`deadline' - floor(`deadline'))*24,.01)   as txt " hours)" _c
	}
	else {
		di as err "No deadline provided."
		error 198
	}
	
	di as txt _col(40) "Current time: " as res "$S_DATE" as txt " (" as res "$S_TIME" as txt ")" 
	local td = d($S_DATE)
	_parse_time_for_deadline $S_TIME
	local now = `td' + r(frac_of_day)

	if `now' >= `deadline' {
		di as err "Your deadline has expired by " as res floor(`now'-`deadline') as err " day(s) " as res round((`now'-`deadline'-floor(`now'-`deadline'))*24,.01) as err " hours."
		return scalar expired = 1
		error 4321
		}
	else {
		di as txt "There are " as res floor(`deadline'-`now') as txt " day(s) " as res round((`deadline'-`now'-floor(`deadline'-`now'))*24,.01) as txt " hours until your deadline."
		return scalar expired = 0
	}
end

program define _parse_time_for_deadline, rclass
	gettoken h ms : 0, parse(":")
	gettoken c ms : ms, parse(":")
	gettoken m s : ms, parse(":")
	gettoken c s : s, parse(":")
	return scalar h = `h'
	return scalar m = `m'
	return scalar s = `s'
	return scalar hours_of_day =  `h' + (`m' + `s' /60 ) /60 
	return scalar frac_of_day  = (`h' + (`m' + `s' /60 ) /60 ) /24
end
