{smcl}
{* $Id$ }
{* $Date$}{...}
{cmd:help foldergraphexport}
{hline}

{title:Title}

{p2colset 5 23 20 2}{...}
{p2col:{hi:foldergraphexport }{hline 2}}Convert graph files in a folder to another format.{p_end}
{p2colreset}{...}


{title:Syntax}

{p 4 17 2}
{cmd:. foldergraphexport} [{it:foldername}] [, {opt f:ind(filespec)} {opt as(ext)} {opt nodrop noisily  *}]

{p 4 17 2}
{cmd:. foldergraphexport} [{it:foldername}] [, {opt undo} {opt f:ind(filespec)} {opt as(ext)}]


{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt f:ind(filespec)}}Search for filenames in folder. Include a {it:filespec} string
for  would for the {help dir} command. The default is {bf:find(}"*.gph"{bf:)}.{p_end}
{synopt:{opt as(ext)}}Extensions for {help graph export}. More than one extension is allowed, 
such as {opt as(png emf)}.  The default is {opt as(png)}.{p_end}
{synopt:{opt nodrop}}graphs remain open in Stata{p_end}
{synopt:{opt n:oisily}}Displays additional output.{p_end}
{synoptline}
{synopt:{opt undo}}Undo does the opposite, it deletes any {it:ext} files where there's a .gph 
file in the same directory with the same filename.{p_end}
{synoptline}
{synopt:{opt *}}Any other options are passed to the {bf:graph export} command. scheme() is also allowed.{p_end}
{synoptline}

{title:Description}

{p 4 4 2}{cmd:foldergraphexport} is designed to open each .gph file in {it:foldername}, and then 
export it to another file format by calling the {help graph export} command.

{p 4 4 2}If a {it:foldername} is not provides, it searched for files in the working directory.

{p 4 4 2}You can use the {opt -find-} option to select a subset of files to be converted.  
This option performs a "search" for matching file names in the directory.  Wildcards are allowed.
Hint: Be careful that your search only returns filenames that are actually Stata graphs 
(perhaps, by including "*.gph" in your search).

{title:Examples}

{p 4 4 2}Basic usage:

{p 4 4 2}{cmd:. foldergraphexport }

{p 4 4 2}{cmd:. foldergraphexport} ..\Graphs, {opt as(png emf)}

{p 4 4 2}Remove files png/emf files:

{p 4 4 2}{cmd:. foldergraphexport}, {opt as(png emf)} {opt undo}

{p 4 4 2}Pass other options to graph export:

{p 4 4 2}{cmd:. foldergraphexport} "C:\myfolder\", replace {opt as(tif)} {opt width(800)} {opt height(600)}

{p 4 4 2}Find:

{p 4 4 2}{cmd:. foldergraphexport} "C:\myfolder\", {opt find("Figure-1.gph")}

{p 4 4 2}{cmd:. foldergraphexport}, {opt find("Figure*.gph")}

{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}

{title:Also see}

{p 4 13 2}{help graph export}, {help graph save}, {help graph use}, {help dir}{break}
