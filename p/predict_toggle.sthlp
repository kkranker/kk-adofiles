$Id: personal/p/predict_toggle.sthlp, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:04:57 (revision 9f1d00439570 by user keith) $
After a regression, predict with X1=0, X1=1, then calculate the difference


--------------------------
predict_toggle
--------------------------


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
	predict_toggle varlist [if] [in] [fweight pweight aweight iweight] ///
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

		

Predict Toggle  was used before the margins command was added to Stata. 
The only thing it is needed any longer is the arraytreatments option (and predict_toggle_cum, below)

This code demonstrates that margins and predict_toggle are identical with one independent variable.

	// margins
	webuse margex
	logit outcome i1.treatment i.group age c.age#c.age
	estimates store hold
	margins , dydx(treatment) predict(pr) post
	estimates restore hold
	margins , dydx(treatment) predict(pr) over(treatment) post

	// margins results above are identical to predict_toggle results, except it gives standard errors from the delta-method
	qui logit outcome treatment i.group age c.age#c.age  // no i. before treatment
	predict_toggle treatment 

	// and margins can handle interaction terms too
	logit outcome i1.treatment##i.group i.group#c.age c.age#c.age 
	margins, dydx(treatment) over( treatment group ) post



--------------------------
predict_toggle_cum
--------------------------
		
Cumlative probabity for predict_toggle.

This is command that can be used only afte predict_toggle  
when the regression predicts the probability of an event.
This command uses the i()/t() variables to identify a panel.
The second command calculates a cumulative probability within each obs/time period.
It then take the average of the last (cumulative) probability for each obs.

oneminus calculates cumulative (1-probability) instead.

Note: Make sure you understand this program's actual code before
      you use weights!  If weights are changing for each i, you will
      need to force this program to use the right weight.

SYNTAX
	predict_toggle_cum [if] [in]        ///
		[fweight pweight aweight iweight], ///
	    i(varname)          /// id variable
	    t(varname numeric)  /// time variable   
	  [ MATName(name)       /// a matrix name to store the output in
		svy                 /// prefix "mean ___ " with "svy:" 		
		PREFix(string)      /// prefix new variables with this string.  Default is inherited from predict_toggle or "_"
	    ONEMinus            /// subtract from one before creating cumulative probability
		at(string)          /// program calculate means using "by i (t) : gen include = `at'", and then it calculates the "mean ... if include ..."
		                    /// by default, `at' == (_n==_N), the last observation in the panel, but this can be changed with this option.  For example, at(age==10)
		   *                /// other options passed to predict 
	  ]	                    
		
      
EXAMPLE
probit y x z t 
predict_toggle x ,  pr codebook
predict_toggle_cum , i(id) t(t) oneminus


By Keith Kranker
$Date$
