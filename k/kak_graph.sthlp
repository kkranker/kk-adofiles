{smcl}
{* $Id$ }
{* $Date$}{...}
{cmd:help kak_graph}
{hline}

{title:Title}

{p2colset 5 25 27 2}{...}
{p2col :{hi:[G] kak_graph } {hline 2}}Keith's "helper" programs for graph {p_end}
{p2colreset}{...}

{title:Sub-commands}

{p2colset 9 33 35 2}{...}
{p2col :command}description{p_end}
{p2line}
{p2col :{bf:kak_graph export}}export a graph and save it as a {it:.gph} file{p_end}
{p2col :{bf:kak_graph save}}synonym for {cmd:kak_graph export}{p_end}
{p2line}
{p2colreset}{...}


{title:Export a graph {it:and} save it as a {it:.gph} file}

{pstd}{ul:Synatx}

{p 8 16 2}
{cmdab:kak_graph}
{cmd:export} 
{it:filename} [{cmd:,} {it:options}]

{p 8 16 2}
{cmdab:kak_graph}
{cmd:save}
{it:filename} [{cmd:,} {it:options}]

{pstd}{ul:Description and Options}

{pstd} The command {cmd:kak_graph export} exports the current graph to two files:  
(i) one file exported with {help graph export}
(ii) one {it:.ghp} Stata graph file saved with with {help graph save}.
{cmd:kak_graph save} is synonymous with {cmd:kak_graph export}. 

{pstd}The command passes the filename and options to the {help graph export} and {help graph save} commands.   
You should only use options with these two commands.  

{pstd}If {it:filename} 
includes a file extension (e.g., {it:.emf}) it will be accomodated as it is with {help graph export}.  
(If the extension is missing or is {it:.gph}, {it:.emf} will be used by default.) 

{pstd}{ul:Example}

{pstd}This command...

	{cmd:. kak_graph export} {it:filename.emf} [{cmd:,} replace width(2400)]   

{pstd}... is identical to running the following two commands:

	{cmd:. graph export} {it:filename.emf} {cmd:, replace width(2400)}   
	{cmd:. graph save  } {it:filename.gph} {cmd:, replace}

{pstd}
Either of the following commands would create the files {it:myfile.emf} and {it:myfile.gph}
	
	{cmd:. kak_graph export} "C:\my path\myfile", replace width(1200)
	{cmd:. kak_graph export} myfile.emf



{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}

	
{title:Also see}

{psee}
Manual:  {bf:[G] graph export}

{psee}
Online:  
{it:{help graph}}, 
{it:{help graph export}},
{it:{help graph save}},
{it:{help tif_options}}
{p_end}

