{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for wimpmed}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:wimpmed} {hline 2}}causal mediation analysis using an imputation-based weighting estimator {p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:impmed} {depvar} {help indepvars:mvars} {ifin} {cmd:,} 
dvar({varname}) d({it:real}) dstar({it:real}) yreg(string)
[cvars({varlist}) {opt nointer:action} {opt cxd} {opt cxm}
reps({it:integer}) strata({varname}) cluster({varname}) level(cilevel) seed({it:passthru}) sampwts({varname}) detail]

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt mvars} - this specifies the mediator(s), which can be multivariate.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable. This variable must be binary (0/1).

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{phang}{opt yreg}{cmd:(}{it:string}{cmd:)}} - this specifies the form of the models to be estimated for the outcome. 
Options are {opt regress} and {opt logit}.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt nointer:action} - this option specifies whether treatment-mediator interactions are not to be
included in the appropriate outcome model (the default assumes interactions are present).

{phang}{opt cxd} - this option specifies that all two-way interactions between the treatment and baseline covariates are
included in the outcome models.

{phang}{opt cxm} - this option specifies that all two-way interactions between the mediators and baseline covariates are
included in the appropriate outcome model.

{phang}{opt sampwts(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt reps(integer)} - this option specifies the number of replications for bootstrap resampling (the default is 200).

{phang}{opt strata(varname)} - this option specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{phang}{opt cluster(varname)} - this option specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{phang}{opt level(cilevel)} - this option specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{phang}{opt seed(passthru)} - this option specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. {p_end}

{phang}{opt detail} - this option prints the fitted models for the outcome and the exposure used to construct effect estimates. {p_end}

{title:Description}

{pstd}{cmd:wimpmed} performs causal mediation analysis using an imputation-based weighting estimator. Three models 
are estimated to construct the effect estimates: a model for the outcome conditional on the exposure and 
baseline covariates (if specified), a model for the outcome conditional on the exposure, baseline covariates,
and the mediator(s), and a logit model for the exposure conditional on the baseline covariates.

{pstd}{cmd:wimpmed} provides estimates of the total, natural direct, and natural indirect effects when a single
mediator is specified. When multiple mediators are specified, it provides estimates for the multivariate natural 
direct and indirect effects operating through the entire set of mediators considered together. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

 
{pstd} percentile bootstrap CIs with default settings, single mediator: {p_end}
 
{phang2}{cmd:. wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) reps(1000)} {p_end}

 
{pstd} percentile bootstrap CIs with default settings, single mediator, all two-way interactions: {p_end}
 
{phang2}{cmd:. wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) cxd cxm reps(1000)} {p_end}

{pstd} percentile bootstrap CIs with default settings, single mediator, all two-way interactions, print outcome and exposure models: {p_end}
 
{phang2}{cmd:. wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) cxd cxm reps(1000) detail}  {p_end}

{pstd} percentile bootstrap CIs with default settings, multiple mediators: {p_end}
 
{phang2}{cmd:. wimpmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) reps(1000)} {p_end}

{title:Saved results}

{pstd}{cmd:wimpmed} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing direct, indirect, and total effect estimates{p_end}


{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp regress R}, {manhelp logit R}, {manhelp bootstrap R}
{p_end}
