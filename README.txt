**This code was migrated here from [code.google.com](https://code.google.com/archive/p/kk-adofiles/ ) after Google Code shut down.

Code by Keith Kranker**

------------------------------------------------------

# Stata Programs #

This project contains Stata .ado and .do files and other code I've written.
Among other programs, you'll find...

  * {{{did3         }}} - Create difference-in-differences tables. 
  * {{{mat2txt2     }}} - Export matrix to text file. 
  * {{{meantab      }}} - `mean varlist`, with columns separated by a categorical variable. 
  * {{{memmax       }}} - Set memory to the maximum allowed by your operating system. 
  * {{{motionshart  }}} - Create graphs of your data, from Stata, as a [http://code.google.com/apis/visualization/documentation/gallery/motionchart.html Google Motion Chart]
  * {{{normdiff     }}} - Create a table to compare means of two groups, with a column containing normalized differences. 
  * {{{predlog2     }}} - Duan smearing & heteroscedastic smearing retransformation. 

[http://code.google.com/p/kk-adofiles/source/browse/stata.toc Here is a full list] of available packages.

# Access #

You can get to the programs three ways:
  # (Recommended) Use Mercurial to [http://code.google.com/p/kk-adofiles/source/checkout checkout] this repository, then install the .ado files.
{{{
    #get files
    hg clone https://kk-adofiles.googlecode.com/hg/kk-adofiles 
    cd kk-adofiles

    #if this isn't a folder recognized by Stata, you could use the .toc file to install:
    stata
    . net from "`c(pwd)'"
}}}
  # In Stata, you _should_ be able to type the following (although this doesn't always work due to a bug in Stata) 
{{{ 
    net from http://kk-adofiles.googlecode.com/hg/
 
    net describe pub2web, from("http://kk-adofiles.googlecode.com/hg/")
    net install  pub2web, from("http://kk-adofiles.googlecode.com/hg/")
}}}
  # Click [http://code.google.com/p/kk-adofiles/source/browse/ browse] link above. When you click on a file, you'll see a "View raw file" link in the box on the right. (Notice that you can download a .zip or .tar file with all files.) Download file and save into your "personal" or "plus" directo=.


# Excel & MS office #
  * [http://code.google.com/p/kk-adofiles/wiki/ExcelPasteValuesEtc Excel macro to "Paste as Values" or "Paste as Unformatted Text"]