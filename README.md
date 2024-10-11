# wimpmed: A Stata Module for Causal Mediation Analysis Using an Imputation-Based Weighting Estimator

`wimpmed` is a Stata module designed to perform causal mediation analysis using an imputation-based weighting estimator. This approach is suitable for analyses with single or multiple mediators.

## Syntax

```stata
wimpmed depvar mvars, dvar(varname) d(real) dstar(real) yreg(string) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `mvars`: Specifies the mediator(s), which can be a single variable or multivariate.
- `dvar(varname)`: Specifies the treatment (exposure) variable, which must be binary (0/1).
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast of interest.
- `yreg(string)`: Specifies the form of the model for the outcome. Options are `regress` and `logit`.

### Options

- `cvars(varlist)`: List of baseline covariates to include in the analysis. Categorical variables must be dummy coded.
- `nointeraction`: Specifies whether treatment-mediator interactions are included in the outcome model (default is to include interactions).
- `cxd`: Includes all two-way interactions between the treatment and baseline covariates in the outcome models.
- `cxm`: Includes all two-way interactions between the mediators and baseline covariates in the outcome model.
- `sampwts(varname)`: Specifies a variable containing sampling weights to include in the analysis.
- `censor`: Specifies that the inverse probability weights are censored at their 1st and 99th percentiles.
- `detail`: Prints the fitted models for the outcome and exposure used to construct effect estimates.

## Description

`wimpmed` fits three models to construct effect estimates:
1. A model for the outcome conditional on the exposure and baseline covariates.
2. A model for the outcome conditional on the exposure, baseline covariates, and mediator(s).
3. A logit model for the exposure conditional on baseline covariates.

`wimpmed` provides estimates of total, natural direct, and natural indirect effects when a single mediator is specified. When multiple mediators are specified, `wimpmed` estimates multivariate natural direct and indirect effects. Inferential statistics are computed using the nonparametric bootstrap.

`wimpmed` allows sampling weights via the `sampwts` option, but it does not internally rescale them for use with the bootstrap. If using weights from a complex sample design that require rescaling to produce valid boostrap estimates, the user must be sure to appropriately specify the `strata`, `cluster`, and `size` options from the `bootstrap` command so that Nc-1 clusters are sampled within from each stratum, where Nc denotes the number of clusters per stratum. Failure to properly adjust the bootstrap sampling to account for a complex sample design that requires weighting could lead to invalid inferential statistics.

## Examples

```stata
// Load data
use nlsy79.dta

// Single mediator with default settings
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress)

// Single mediator with censored weights at 1st and 99th percentiles
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) censor(1 99)

// Single mediator with all two-way interactions and censored weights
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) cxd cxm censor(1 99)

// Single mediator with all two-way interactions, 1000 bootstrap replications, and detailed output
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) cxd cxm detail reps(1000) 

// Multiple mediators with censored weights and 1000 bootstrap replications
wimpmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) censor(1 99) reps(1000)
```

## Saved Results

`wimpmed` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing direct, indirect, and total effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation.

## Also See

- Help: [regress](#), [logit](#), [bootstrap](#)
