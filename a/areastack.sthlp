*! $Id$

areastack
graph command like "twoway area" which "stacks" the over(), instead of overlaying them.

This program is similar to "twoway area",
except that it "stacks" the areas to a cumulative height
(similar to "graph bar ... , stack").

At it's core, this program creates a "cumulative" y-variable
  . bys x_var (over_var) : gen cumulative = sum(x_var)

Then, it executes a command like this:
  . graph twoway
       (area cumulative x_var if over_var==4 )
       (area cumulative x_var if over_var==3 )
       (area cumulative x_var if over_var==2 )
       (area cumulative x_var if over_var==1 )
       , legend(order(4 3 2 1) label(1 "over_var label 1") ... label(4 "over_var label 4"))

Any options are passed along to the graph twoway command.

By Keith Kranker
$Date$

syntax y_var x_var [if] [in] , ///
	over(varname) ///
	[ quietly /// don't show twoway graph command
	*] // other options passed along to graph twoway
