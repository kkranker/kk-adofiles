{smcl}
{* $Id$ }
{* $Date$}{...}
{cmd:help dropstringvars}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:dropstringvars }{hline 2}}Drop all string variables in a {it:varlist}.{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmdab:dropstringvars} [{varlist}] 

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt -}}There are no options for this command.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
  {opt if} and {opt in} may not be used with {opt dropstringvars}
  {p_end}

  
{title:Description}

{pstd}
{opt dropstringvars} {help extended_fcn:checks} the {help data_types:type} of each variable in {it:{help varlist}}.  If the variable {it:myvar} is a string, it will execute the command: {p_end}

{phang}{cmd:. drop myvar}{p_end}

{pstd}
Please use caution.  If no {it:{help varlist}} is specified, you could delete a lot of things you don't mean to! {p_end}

{title:Examples}

    {cmd:. dropstringvars}
{phang}{cmd:. dropstringvars mpg weight make}{p_end}
{phang}{cmd:. dropstringvars mpg-make}{p_end}


{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}

{title:Also see}

{psee}
Manual:  {hi:[D] drop}

{psee}
Online:  
{help drop},
{help varlist}
{p_end}
