*! $Id: personal/s/scatter_hist_example.ado, by Keith Kranker <keith.kranker@gmail.com> on 2011/04/19 20:56:24 (revision b8ba72488bca by user keith) $
*! Scatter plot with bordering histograms
*
*! By Keith Kranker
*! $Date$

program scatter_hist_example
    preserve
        sysuse lifeexp, clear 
        qui gen loggnp = log10(gnppc)
        label var loggnp "Log base 10 of GNP per capita"
		tempname example1 example2
		
        scatter_hist lexp loggnp, name(`example1')
		scatter_hist lexp loggnp, percent color(dkorange) m(s) msize(small)  xtitle("GNP per capita (log)") name(`example2')
    restore
end

