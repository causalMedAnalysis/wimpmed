*!TITLE: WIMPMED - causal mediation analysis using an imputation-based weighting estimator
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define wimpmed, eclass

	version 15	
	
	syntax varlist(min=2 numeric) [if][in], ///
		dvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		yreg(string) ///
		[cvars(varlist numeric)] ///
		[NOINTERaction] ///
		[cxd] ///
		[cxm] ///
		[sampwts(varname numeric)] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)] ///
		[detail]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	gettoken yvar mvars : varlist
	
	local num_mvars = wordcount("`mvars'")

	confirm variable `dvar'
	qui levelsof `dvar', local(levels)
	if "`levels'" != "0 1" & "`levels'" != "1 0" {
		display as error "The variable `dvar' is not binary and coded 0/1"
		error 198
		}
	
	if ("`yreg'"=="logit") {
		confirm variable `yvar'
		qui levelsof `yvar', local(levels)
		if "`levels'" != "0 1" & "`levels'" != "1 0" {
			display as error "The outcome variable `yvar' is not binary and coded 0/1"
			error 198
		}
	}

	/***REPORT MODELS AND SAVE WEIGHTS IF REQUESTED***/
	if ("`detail'" != "") {
		wimpmedbs `yvar' `mvars' if `touse', ///
			dvar(`dvar') cvars(`cvars') yreg(`yreg') sampwts(`sampwts') ///
			d(`d') dstar(`dstar') `cxd' `cxm' `nointeraction' `detail'
	}
	
	/***COMPUTE POINT AND INTERVAL ESTIMATES FOR NDE/NIE***/
	if (`num_mvars'==1) {
	
		if ("`saving'" != "") {
			bootstrap ///
				ATE = (r(YdMd) - r(YdstarMdstar)) ///
				NDE = (r(YdMdstar) - r(YdstarMdstar)) ///
				NIE = (r(YdMd) - r(YdMdstar)), force ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
				saving(`saving', replace) noheader notable: ///
				wimpmedbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') yreg(`yreg') sampwts(`sampwts') ///
					d(`d') dstar(`dstar') `cxd' `cxm' `nointeraction'
		}

		if ("`saving'" == "") {
			bootstrap ///
				ATE = (r(YdMd) - r(YdstarMdstar)) ///
				NDE = (r(YdMdstar) - r(YdstarMdstar)) ///
				NIE = (r(YdMd) - r(YdMdstar)), force ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
				noheader notable: ///
				wimpmedbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') yreg(`yreg') sampwts(`sampwts') ///
					d(`d') dstar(`dstar') `cxd' `cxm' `nointeraction'
		}
	}
	
	if (`num_mvars'>1) {
	
		if ("`saving'" != "") {
			bootstrap ///
				ATE = (r(YdMd) - r(YdstarMdstar)) ///
				MNDE = (r(YdMdstar) - r(YdstarMdstar)) ///
				MNIE = (r(YdMd) - r(YdMdstar)), force ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
				saving(`saving', replace) noheader notable: ///
				wimpmedbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') yreg(`yreg') sampwts(`sampwts') ///
					d(`d') dstar(`dstar') `cxd' `cxm' `nointeraction'
		}

		if ("`saving'" == "") {
			bootstrap ///
				ATE = (r(YdMd) - r(YdstarMdstar)) ///
				MNDE = (r(YdMdstar) - r(YdstarMdstar)) ///
				MNIE = (r(YdMd) - r(YdMdstar)), force ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
				noheader notable: ///
				wimpmedbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') yreg(`yreg') sampwts(`sampwts') ///
					d(`d') dstar(`dstar') `cxd' `cxm' `nointeraction'
		}
	}
		
	estat bootstrap, p noheader
	
end wimpmed
