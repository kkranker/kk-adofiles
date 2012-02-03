*! $Id: personal/s/scatter_hist.ado, by Keith Kranker <keith.kranker@gmail.com> on 2012/01/07 18:15:06 (revision ef3e55439b13 by user keith) $
*! Scatter plot with bordering histograms
*
* Implementation of graph(s) in 
*   . help graph combine
*
*! By Keith Kranker
*! $Date$

program define scatter_hist
version 9.2
syntax varlist(min=2 max=2 numeric) [if] [in] ///
	[, ///
	/* Combine: title  options */ TItle(passthru) SUBtitle(passthru) note(passthru) CAPtion(passthru) T1title(passthru) T2title(passthru) B1title(passthru) B2title(passthru) L1title(passthru) L2title(passthru) R1title(passthru) R2title(passthru) ///
	/* Combine: region options */ YSIZe(passthru) XSIZe(passthru) PLOTRegion(passthru) ///
	/* Combine: other options  */ iscale(passthru) altshrink COMmonscheme SCHeme(passthru) nodraw name(passthru) saving(passthru) ///
	/* Histogram type */ DENsity FRACtion FREQuency percent ///
	/* Histogram: barlook options */ COLor(passthru) FColor(passthru) FIntensity(passthru) LColor(passthru) LWidth(passthru) LPattern(passthru) LSTYle(passthru) BSTYle(passthru) PSTYle(passthru) ///
	/* Y-axis */ YSCale(string) YLABel(passthru) YTICk(passthru) YMLABel(passthru) YMTIck(passthru) YTItle(passthru) ///
	/* X-axis */ XSCale(string) XLABel(string) XTICk(passthru) XMLABel(passthru) XMTIck(passthru) XTItle(passthru) ///
	* /// options passed to scatter command
	]
	
* Set up program
marksample touse 
tokenize `varlist'

* Histogram option
if "`histogram'" == "" local histogram "percent" // the default
else if (("`histogram'"!="density") | ("`histogram'"!="fraction") | ("`histogram'"!="frequency") | ("`histogram'"!="percent")) {
	di as error "hist(.) option is invalid. Choose hist({density | fraction | frequency | percent})"
	exit
	}

* Parse the {x|y}label options
macro drop temp temp2 xlabel_opt xlabel_subopt
gettoken (local) xlabel_opt (local) temp : (local) xlabel , parse(",")                   // these are used to break the {x|y}label options before/after the comma" 
if "`temp'"!="" gettoken (local) temp2 (local) xlabel_subopt : (local) temp , parse(",") // these are used to break the {x|y}label options before/after the comma" 

* Locals to save graphs temporarily
tempname gxy ghy ghx

* Scatter Plot
scatter `1' `2' if `touse', `options' ///
		yscale(alt `yscale') `ylabel'                                         `ytick' `ymlabel' `ymtick' `ytitle' ///
		xscale(alt `xscale') xlabel( `xlabel_opt', `xlabel_subopt' grid gmax) `xtick' `xmlabel' `xmtick' `xtitle'  ///			
		name(`gxy') nodraw

* X-axis histogram		
twoway histogram `2' if `touse', ///
		`density' `fraction' `frequency' `percent' `color' `fcolor' `fintensity' `lcolor' `lwidth' `lpattern' `lstyle' `bstyle' `pstyle' ///	
		ylabel(#4,nogrid) yscale(alt reverse) ///       
		xlabel( `xlabel_opt', `xlabel_subopt' grid gmax) xsca(`xscale') `xtick' `xmlabel' `xmtick' `xtitle' ///
		fysize(20) name(`ghx') nodraw

* Y-axis histogram
twoway histogram `1' if `touse', ///
		`density' `fraction' `frequency' `percent' horiz `color' `fcolor' `fintensity' `lcolor' `lwidth' `lpattern' `lstyle' `bstyle' `pstyle' ///
		xlabel(#4,nogrid) xscale(alt reverse)   ///
		`ylabel' yscale(`yscale') `ytick' `ymlabel' `ymtick' `ytitle' /// 
		fxsize(20) name(`ghy') nodraw

* Combined graphs
graph combine `ghy' `gxy' `ghx', hole(3) col(2)  /// 
		imargin(0 0 0 0) graphregion(margin(l=22 r=22))  ///
		`iscale' `altshrink' `commonscheme' `scheme' `nodraw' `name' `saving' ///
		`title' `subtitle' `note' `caption' `t1title' `t2title' `b1title' `b2title' `l1title' `l2title' `r1title' `r2title' ///
		`ysize' `xsize'  `plotregion'

end

