*! $Id$
*! Quick program to "clean up" variable labels for variables created by the [xi : ] command.

* Example: Say you used -xi- to create dummies for "race" (variable 
* label "Race or Ethnicity"), where there is a value label for "2" (Black) 
* and the new variable from xi: is  _racrace_2  with label race==2
*
* .........COMMAND.....................................NEW.LABEL..............
* . xilabel _racrace_2                       "Black"
* . xilabel _racrace_2, is                   "Race or Ethnicity is Black"
* . xilabel _racrace_2, colon                "Race or Ethnicity: Black"
* . xilabel _racrace_2, equals               "Race or Ethnicity=Black"
* . xilabel _racrace_2, pre("Category - ")   "Category - Black"
* . xilabel _racrace_2, is pre("i's ")       "i's Race or Ethnicity is Black"
*
* Recommended: use this command if "xi" input variable has BOTH a variable label and value label.
* This program does not work with interaction terms.  


program define xilabel 

syntax varlist [, Is Equals Colon Other(string) PRefix(string) POst(string)]


*! By Keith Kranker
*! $Date$
