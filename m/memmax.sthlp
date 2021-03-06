{smcl}
{* $Id: personal/m/memmax.sthlp, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $ }
{* $Date$}{...}
{cmd:help memmax}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:memmax }{hline 2}}Set memory to the maximum allowed by your operating system.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 18 2}
{cmdab:memmax} [ #[b|k|m|g] ] [, options ]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mi:n(integer)}}Specify minimum memory you require.{p_end}
{synopt:{opt ma:x(integer)}}Specify maximum memory you require.{p_end}
{synopt:{opt u:nits(b|k|m|g)}}Units of memory specification.{p_end}
{synopt:{opt buf:fer(integer)}}Leave small amount of space for operating system.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Defaults: {opt min(current memory)}, {opt max(2200)}, {opt units(m)}, {opt buffer(25)} (i.e. 2200m and 25m).  {p_end}


{title:Description}

{pstd}{opt memmax} is used to set your memory (RAM) to the maximum allowed by your operating system.  The program repeatedly sends the command ... {p_end}

{phang}{cmd:. set memory {it:N}m }

{pstd}... for ever increasing values of {it:N} until reaching the operating system's limit.
You can set the minimum and/or maximum {it:N} via the {opt min} and {opt max} options. 
Instead of megabytes (m), you can alternatively express numbers in bytes (b), 
kilobytes (k), or gigabytes (g) via the {opt units} option. {p_end}

{pstd}Once the program discovers the {it:maximum} memory that your operating system allows, 
it sets the memory to ({it:maximum} - {it:buffer}), where {it:buffer} is the value set 
by the {opt buffer} option.  (Exceptions: {it:buffer} is not subtracted if (a) the 
memory is not changed or (b) the program does not reach the actual limit of your computer 
because of the {opt max} option.) {p_end}

{pstd}You can the quantity of memory before the comma.  In this case, the entry is parsed into
the max() and units() options. That is, the following two specifications are equivalent: {p_end}

{phang}{cmd:. memmax 200m}{p_end}
{phang}{cmd:. memmax , max(200) units(m)}{p_end}

{title:{error:Use this program at your own risk!!!}}

{pstd}
As a general rule, you should not request more memory than you actually need because 
it slows down your computer a little and also inhibits your operating system from 
running other programs.  However, sometimes your data is really "pushing" your computer to 
the limit, but you don't know exactly how much memory you need.  This program is 
only recommended for these cases.  The stability of your computer may be compromised.
{p_end}

{title:Examples}

{phang}{cmd:. memmax}{p_end}
{phang}{cmd:. memmax , min(150) max(1502) units(k)}{p_end}


{title:Other Information}
{* $Id: personal/m/memmax.sthlp, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $ }
{phang}Author: Keith Kranker{p_end}

{phang}$Date${p_end}


{title:Also see}

{psee}
Help:  
{help set memory}, {help query memory}
{p_end}

{psee}
Online:
{browse "http://www.stata.com/support/faqs/win/winmemory.html":"How do I load large datasets (>1 GB) under 32-bit Windows?"}
{p_end}
