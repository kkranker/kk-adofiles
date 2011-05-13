{smcl}
{* $Id$ }
{* $Date$}{...}
{cmd:help foldercodebook}, {cmd:help foldercodebook_sub}
{hline}

{title:Title}

{p2colset 5 23 20 2}{...}
{p2col:{hi:foldercodebook }{hline 2}}Automatic codebook creation.{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmd:foldercodebook} 
[{it:filespec} [{it:filespec} [ ... ]]]
[, {it:options}]

{p 8 17 2}
{cmd:foldercodebook_sub} 

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt f:ast}}Run program faster by spliting the results into two tables per file.{p_end}
{synopt:{opt v:eryfast}}Just {help describe} each file.{p_end}
{synopt:{opt file:(filename)}}Specify an alternative {it:filename} destination for the output file.{p_end}
{synopt:{opt nolab:els}}Omit the output of the {cmd:label list _all}.{p_end}
{synoptline}
{p 8 17 2}{opt file()} is not allowed with foldercodebook_sub.

{title:Description}

{p 4 4 2}{cmd:foldercodebook} puts a description of the contents 
of files (in a directory) into a log "codebook" file.

{p 4 4 2}For each file in {it:filespec}, {cmd:foldercodebook} will 
first load the file into memory.  (Be careful you have your 
{help memory} large enough to handle the file.)  The program then 
performs the following commands:

{p 13 13 2}{cmd:. describe, short}{break}
           {cmd:. codebook, compact}{break} 
		   {cmd:. notes}{break} 
   		   {cmd:. label list _all}   {tab}{it:(except w/ nolabels)}{break}
		   
{p 4 4 2}It will repeat this process for all of the files.		   

{p 4 4 2}Because the previous commands can be very slow with large datasets, 
there is a "shortcut": the option {opt fast}.  If this option is declared, 
the program instead performs the following commands:

{p 13 13 2}{cmd:. describe, fullnames}{break}
           {cmd:. notes}{break} 
           {cmd:. summarize}{break} 
   		   {cmd:. label list _all}*   {tab}{it:(except w/ nolabels)}{break}
		   
{p 4 4 2}To run this even faster, you can use the option {opt veryfast}.
If this option is declared, the program does not load the dataset into memory. 
Instead it just runs performs the following command for each file:

{p 13 13 2}{cmd:. describe using [filename]}{break}


{p 4 4 2}Output is stored in your current directory in a log file named 
"{it:! Codebook of dta files in folder.txt}".  This filename can be 
overridden with {opt file:(filename)}.

{p 4 4 2}With no arguments, {cmd:foldercodebook}
includes all {cmd:.dta} files in the current folder (directory). Otherwise, it
follows the file specification declared with {it:filespec}.  See {help fs} for more details on {it:filespec}.
Regardless of which files you specify, the program will only include files with
the *.dta extension.   Note that files do not include sub-folders or directories. 


{title:Sub-folders}

{p 4 4 2}The command {cmd:foldercodebook_sub} is eqivalent to typing the command

{p 13 13 2}{cmd:. foldercodebook, fast}{break}

{p 4 4 2}for the current directory and each of its sub-folders. 
Sub-sub-folders are not included because the underlying code simply uses
the {help folders} command by Nicholas J. Cox 
(wich MUST be {net search folders:installed} before using).  

{title:Examples}

{p 4 4 2}{cmd:. foldercodebook}

{p 4 4 2}{cmd:. foldercodebook myfile.dta, f}{break}

{p 4 4 2}{cmd:. foldercodebook *.gph}{break}
         {cmd:. foreach f in `r(files)' {c -(}}{break} 
         {cmd:. {space 8}use "`f'", clear}{break} 
		 {cmd:. {space 8}describe}{break} 
         {cmd:. {c )-}} 


{title:Acknowledgements}

{p 4 4 2}
This is built off the {net search fs, filenames:fs} / {net search folders:folders} program by 
Nicholas J. Cox. I thank him for the more complicated code related to the
{it:filespec} file specification.

{title:Other Information}
{* $Id$ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}


{title:Also see}

{p 4 13 2}Manual:  {hi:[D] dir}

{p 4 13 2}Online:  
See help on {help dir} or {help ls} for listing the names of files
with more detailed information.{break}
{help codebook}, {help describe}, {help summarize}{break}
{help fs} and {help folders} (if already {net search fs, filenames:installed})

