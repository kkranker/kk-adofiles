$Id$

Help for pub2web.ado

Input a list of your .ado programs
For each program "package_name"
1. create a package_name.pkg file for a stata usersite
2. search for files named package_name* (in PERSONSAL or another directory)
2. copy files to "using" directory
3. description for .pkg file comes from all lines at top of .ado file beginning with "//" or "*"
4. add files to a all.pkg package.
Then, create a stata.toc "table of contents" file for a stata usersite w/ links to all the packages
  
required packages: fs 

See {help usersite} for more info

SYNTAX: 

pub2web 
  anything(name=pck_list)     list of packages
  [using/ ]                   folder that will contain output files
   , 
    Author(string)            author's name (required option)
    [
    From(string asis)         folder containing packages. Default is c(sysdir_personal). 
                                Files should be in `from' or in `from'/x  
                                (where x is the first letter in package's name)
    replace                   overwrite files
    noSUBfolders              don't put files in subfolders.
    noCopy                    do not copy files
    noTimestamp               do not put a timestamp in .pkg files
    Intro(string)             add an introduction to your stata.toc file
    Width(integer 80)         max width of text files
    Cline(integer 2)          comment line #__ of .ado file has title of package
                                cline is first line printed into .pkg file
    maxintro(integer 40)      max number of intro lines in .pkg file
    ]  


By Keith Kranker
$Date: 2011/03/28 16:36:00 $
