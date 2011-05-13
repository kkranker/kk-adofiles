{smcl}
{* $Id$ }
{* $Date$}{...}
{cmd:help exceldesc}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:exceldesc }{hline 2}}Summary statistics in a Microsoft Excel file.{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmdab:exceldesc} [{varlist}] 
{ifin}
[, {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt t:able}}Display tables from {help summarize} and {help codebook} commands.{p_end}
{synopt:{opt n:oisily}}Display data that is written into the excel file.{p_end}
{synopt:{opt file:(filename)}}Specify an alternative {it:filename} destination for the text output file.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
  Please use caution when {it:varlist} contains time-series operators, as this command was not designed for this purpose ({help tsvarlist}).
  {p_end}
{p 4 6 2}
  {opt by} may not be used with {opt exceldesc}.
  {p_end}
{p 4 6 2}
  {opt weight}s are not allowed.  
  {p_end}

  
{title:Description}

{pstd}
{opt exceldesc} calculates a variety of univariate summary statistics and imports them into a Microsoft Excel file with "pretty" formatting.  {p_end}

{pstd}
Once the file is finished, click on the hyperlink to open the excel file.  It should update the data automatically when the Excel file opens.  If the Excel file is already open, you will need to refresh the data by (1) locating your cursor in a cell inside the data range, and then (2) selecting {it:Tools} - {it:Refresh Data} (or use the External Data toolbar).{p_end}

{pstd}
If no {it:{help varlist}} is specified, summary statistics are calculated for all the variables in the dataset.{p_end}

{pstd}
The output data is basically statistics from the {help summarize} command.  In addition, the {help tabulate oneway} command is used to count the number of unique observations (and the total number of observations in the case that the variable is not numeric).{p_end}

{pstd}
When {opt file()} is spedified. It will store the file in your current working directory unless a filepath is also defined.

{title:Examples}

    {cmd:. exceldesc}
{phang}{cmd:. exceldesc mpg weight, table noisily}{p_end}
{phang}{cmd:. exceldesc mpg weight if mpg > 25}{p_end}


{title:Other Information}

{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}


{title:Also see}

{psee}
Manual:  {hi:[R] summarize}

{psee}
Online:  
{help codebook},
{help describe},
{helpb summarize},
{helpb tabulate oneway}
{p_end}
