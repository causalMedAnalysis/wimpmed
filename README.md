# wimpmed: Causal Mediation Analysis Using an Imputation-Based Weighting Estimator

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
- `reps(integer)`: Number of replications for bootstrap resampling (default is 200).
- `strata(varname)`: Identifies resampling strata.
- `cluster(varname)`: Identifies resampling clusters.
- `level(cilevel)`: Confidence level for constructing bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Seed for replicable bootstrap resampling.
- `detail`: Prints the fitted models for the outcome and exposure used to construct effect estimates.

## Description

`wimpmed` fits three models to construct effect estimates:
1. A model for the outcome conditional on the exposure and baseline covariates.
2. A model for the outcome conditional on the exposure, baseline covariates, and mediator(s).
3. A logit model for the exposure conditional on baseline covariates.

`wimpmed` provides estimates of total, natural direct, and natural indirect effects when a single mediator is specified. When multiple mediators are specified, `wimpmed` estimates multivariate natural direct and indirect effects.

## Examples

```stata
// Load data
use nlsy79.dta

// Single mediator with default settings
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) reps(1000)

// Single mediator with all two-way interactions
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) cxd cxm reps(1000)

// Single mediator with all two-way interactions and detailed output
wimpmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) cxd cxm reps(1000) detail

// Multiple mediators with default settings
wimpmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) yreg(regress) reps(1000)
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

- Help: [regress R](#), [logit R](#), [bootstrap R](#)
