*This code was migrated here from [code.google.com](https://code.google.com/archive/p/kk-adofiles/ ) after Google Code shut down.*

*Code by Keith Kranker*

------------------------------------------------------

# Stata Programs #

This project contains Stata .ado and .do files and other code I've written.
Among other programs, you'll find...

* `did3         ` - Create difference-in-differences tables. 
* `mat2txt2     ` - Export matrix to text file. 
* `meantab      ` - Essentially, `mean varlist`, with columns separated by a categorical variable. 
* `memmax       ` - Set memory to the maximum allowed by your operating system. 
* `motionshart  ` - Create graphs of your data, from Stata, as a Google Motion Chart.
* `normdiff     ` - Create a table to compare means of two groups, with a column containing normalized differences. 
* `predlog2     ` - Duan smearing & heteroscedastic smearing retransformation. 

stata.toc has the full list of available packages.

# Access #

You can get to the programs three ways:
1 (Recommended) Use Mercurial to checkout this repository, then install the .ado files.
```stata
    #get files
    hg clone https://keithk@bitbucket.org/keithk/kk-adofiles 
    cd kk-adofiles
```
  If this isn't a folder recognized by Stata, you could use the .toc file to install:
```
    stata
    . net from "`c(pwd)'"
```

2 In Stata, you _should_ be able to type the following (although this doesn't always work due to a bug in Stata) 
```
   . net from https://bitbucket.org/keithk/kk-adofiles/raw/3668170c07edef8ad9f18af25b3e2a39673c62ee/
 
```

3. Download the .zip file with the current source code. 


# Excel & MS office tips #

The WIKI has some useful scripts for Microsoft products