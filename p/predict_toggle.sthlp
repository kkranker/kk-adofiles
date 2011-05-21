$Id$
After a regression, predict with X1=0, X1=1, then calculate the difference

This is a post-estimation command.  
Suppose you have a dummy variable X. 
The program will: 
1. calculate model prediction with X        (i.e., the -predict- command)
2. calculate model prediction with X = 0
3. calculate model prediction with X = 1
4. calculate difference between 3/4
5. return X to original state

arraytreatments option:
  calculate treatment effect on treated:
  where "untreated" is 0 for all variables in varlist
  treatment is the "actual" treatment.  
  I do not turn on treat=1 for the whole array


EXAMPLE
reg y x x2 z 
predict_toggle x , keep
predict_toggle x x2, keep
predict_toggle x x2, arraytreatments

replace y = .25 if y<.25
tobit y x x2 z , ll
predict_toggle x , ystar(.25,.)           // these two specifications are identical
predict_toggle x , predict(ystar(.25,.))


SYNTAX
	syntax varlist [if] [in] [fweight pweight aweight iweight] ///
		[, ARraytreatments  /// turn all varlist vars off for untreated; not one at a time
		   svy              /// prefix "mean ___ " with "svy:"  (survey is turned on automatically if previous regression also used survey)
		   MEANOpts(string) /// options to pass to mean ___
		   Keep             /// create a set of te_y variables for all varables (automatically on if only 1 variable)
		   MATName(name)    /// a matrix name to store the output in
		   PREFix(string)   /// prefix te_* variables with this string.  Default is "_"
		   noREPlace        /// don't overwrite  _yhat variables (if they exist)
		   Quietly          /// display less output
		   NOIsily          /// display more output
		   CODEBook         /// dsplay codebook, compact for new variables
		   PREDict(string)  /// other options passed to predict (similar to mfx syntax)
		   *                /// other options passed to predict 
		]		
		
By Keith Kranker
$Date$
