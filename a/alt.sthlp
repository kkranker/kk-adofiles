{smcl}
{* $Id$ }
{* $Date$}{...}
{hline}
help for {hi:alt}
{hline}

{title:alt - alter (demean, normalize, and scale) vaiables. }

{p 8 17 2} {cmd:alt {it:subcommand}} {varlist} {ifin} [,{it:options}] 


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:subcommands}
{synopt:{opt dem:ean}}Subract mean(varname) from varname.{break}X2 = X1-mean(X1){p_end}
{synopt:{opt stand:ardize}}Standardize to mean=0, std. dev.=1.{break}X2 = ( X1-mean(X1) ) / sd(X1){p_end}
{synopt:{opt sc:ale}}Rescale to range [0,1]{break} X2 = (X1-min(X1))/(max(X1)-min(X1)) {p_end}

{syntab:Variables Names*}
{synopt:{opt r:eplace}}Variable is overwritten by altered variable.{p_end}
{synopt:{opt g:enerate(namelist)}}Provide a list of new variable names.  {it:namelist} must be same length as {it:varlist}.{p_end}
{synopt:{opt pre:fix(string)}}New variable names in the form {it:[prefix]varname}.{p_end}
{synopt:{opt suf:fix(string)}}New variable names in the form {it:varname[suffix]}.{p_end}

{syntab:Variable Labels}
{synopt:{opt nol:abel}}No variable label{p_end}
{synopt:{opt add:tolabel(string)}}New variable label of the form {it:"[current label] [string]"}.{p_end}

{syntab:Other}
{synopt:{opt c:asewise}}Casewise row selection.  If one row is missing a value for any 
variable in {it:varlist}, it will be dropped for all variables in {it:varlist}.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:by} {it:...} {cmd::} may be used with {cmd:alt} (see {help by:help by}).{p_end}
{p 4 6 2}* You must choose one and only one of these options.{p_end}
  
  
{title:Description}

{p 4 4 2} {cmd:alt {it:subcommand}} de-means, standardizes, or scales the
variables in {it:varlist}. Use the {help by} prefix to perform this calculation groupwise.


{title:Examples}

{phang}. sysuse auto

{phang}. alt demean mpg , gen(weight_mean0)

{phang}. alt standard mpg price weight, replace

{phang}. bysort rep78 : alt scale length if foreign, suffix(_scaled) casewise


{title:References}

{p 4 8 2} This command is similar to the {help center} command from SSC.


{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}


{title:Also see}

{p 4 13 2}
On-line:  help for {help center}, {help by}, {help egen}{p_end}
