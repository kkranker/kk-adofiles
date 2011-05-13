{smcl}
{* $Id$ }
{* $Date$}{...}
{cmd:help normdiff}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:normdiff }{hline 2}}Create a table to compare two groups, including normalized differences.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab:normdiff} {varlist} 
{ifin} 
, over({it:catvarname})
[{it:options}] 

{synoptset 17 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main options}
{synopt:{opt d:ifference}}Add a column with difference between means (not normalized).{p_end}
{synopt:{opt t:stat}}Add a column with t-statistic for the null hypothesis of equal means.{p_end}
{synopt:{opt c:asewise}}Perform casewise deletion of observations.{p_end}

{syntab:Display options}
{synopt:{opt n(string)}}Specify location of sample size.  {it:string} must belong to {below|over|total|off}. Default is n(below). {p_end}
{synopt:{opt f:ormat(%fmt)}}Specify the {help format} for display. {p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}{cmd:normdiff} is used to create a summary statistics table with a row for each variable in 
{varlist}, comparing the subsamples identified by the categorical
variable ({it:catvarname}).  

{pstd}Columns (1) and (2) are simply means for observations with {it:catvarname} ==0 and ==1, respectively 
(other values are not allowed). When data is missing, the behavior is identical to my
{help meantab} command:  the mean for each variable in {it:varlist} is calculated seperately.

{pstd}The third column calculates the normalized difference between 
the sample means in columns (1) and (2).  This forumla is given in Formula 3 in 
Imbens & Wooldridge (2009, p24).  

{pmore} Delta_x = [ x_1 - x_0 ] / sqrt( S2_1 + S2_0 )  {break}{space 2}{break}
{break} Where x_w is a sample mean and S2_w is the sample varience of the 
{break} the variabe x, for the subsample with  {it:catvarname}==w.

{pstd}You can also add other columns via the options (see below). The main table is displayed on screen 
and is stored in a matrix named {cmd:e(table)}.  Sample sizes are stored in a matrix named cmd(e(_n)).  

{pstd}If you have installed
my other program, {cmd:mat2txt2}, the matrix can be easily exported to a text file for insertion into 
a word processor or spreadsheet.  If you do not want normalized differences, I recommend my other program,
{help meantab}.

{title:Options}

{dlgtab:Main Options}

{phang}
{opt difference} adds a column w/ difference between means (not-normalized). {break}
Column (3) = Column (2) - Column (1)

{phang}
{opt tstat} adds a column with a t-statistic for the null hypothesis of equal means.  Formula 4 in 
Imbens & Wooldridge (2009, p24).  

{pmore} {space 4}T = [ x_1 - x_0 ] / sqrt( S2_1/N_1 + S2_0/N_0 )  
{break}{space 2}{break}{space 4}where N_w refers to the size of the subsample with data for the variable x.

{phang}
{opt casewise} specifies casewise deletion of observations.  Statistics
are to be computed for the sample that is not missing for any of the
variables in {varlist}.  

{dlgtab:Display options}

{phang}
{opt n(below|over|total|off)} specifies the location of sample sizes in the table.

{p 8 15 2}{bf:below}:{space 1}the default, below the table  
{break}(automatically changed to n(over) if N changes by row)

{p 8 15 2}{bf:over}:{space 2}N_0 and N_1 as two additional columns 

{p 8 15 2}{bf:total}:{space 1}N = (N_0 + N_1) as one additional column 

{p 8 15 2}{bf:off}:{space 3}Sample size not displayed

{phang}
{opt format(%fmt)} specifies the {help format} for the display of e(table).  
The default is ususally {opt format(%10.0g)}.


{title:Reference}

{phang} Imbens & Wooldridge  (2009) "Recent Developments in the Econometrics of Program Evaluation."
{it:Journal of Economic Literature}.  March 2009, Volume XLVII, Number 1. ({browse www.aeaweb.org/articles.php?doi=10.1257/jel.47.1.5:link})

{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}

{title:Example}

{pstd}
An meaningless example with nlsw88.dta: 

	{cmd}. sysuse lifeexp, clear
	{cmd}. gen regionSA = (region == 3)

	{cmd}. normdiff popgrowth lexp if region!=2, over(regionSA)
		
	{cmd}. normdiff popgrowth lexp gnppc safewater, over(regionSA) diff tstat n(below) f(%16.4gc)
	
	{cmd}. mat2txt2 e(table) e(_n) using "normdiff_example.csv", matnames replace    {text}  {it:(if installed)}

	  {it:({stata normdiff_example:click to run})}
{* normdiff_example}{...}

{title:Also see}

{psee}
Manual:  {hi:[R] summarize}

{psee}
Online:  
{help mean}, {help regress}, {help xi} {break}
{help meantab}, {help mat2txt2} {it:(if installed)}
{p_end}
