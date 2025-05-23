---
title: 'Random Effects Regression: A Mathematical Exposition'
author: 'Bas Machielsen'
date: '2025-05-23'
slug: []
excerpt: A post on random effects regression, comparing it to OLS and FE.
categories: []
tags: []
---

## Introduction

Hi all, I wanted to write a short primer on random effects regression, since I'm working on this for a course I'm teaching,
and I think the exposition in most textbooks isn't that clear. 
To improve this, I present a mathematical derivation of the random effects model here. 
I should note that I'm not a fan of the random effects model _at all_. I think it should be seen as a curiosity rather than a solution in many cases. 
However, for didactical purposes, it makes sense to analyze the random effects model and observe it is a weighted average of OLS and FE models. 

## Set-up

Imagine you have data for N individuals (or firms, countries, etc.), denoted by i = 1, ..., N, observed over T time periods, denoted by t = 1, ..., T. (For simplicity, we'll assume a balanced panel, meaning each individual is observed for all T periods, though RE can handle unbalanced panels.)

A generic linear model for such data could be:

$$
y_{it} = \beta_0 + \beta_1 x_{1it} + \beta_2 x_{2it} + \dots + \beta_k x_{kit} + v_{it}
$$

Where:

  - \\(y_{it}\\) is the dependent variable for individual i at time t.

  - \\(x_{jit}\\) is the j-th independent variable for individual i at time t.

  - \\(\beta_0\\) is the overall intercept.

  - \\(\beta_1, \dots, \beta_k\\) are the coefficients for the independent variables.

  - \\(v_{it}\\) is the error term for individual i at time t.

The problem is that \\(v_{it}\\) likely contains unobserved individual-specific characteristics that are constant over time
(e.g., innate ability, firm culture) and also purely random noise.

## The Random Effects Model

The random effects model explicitly decomposes the error term v_it into two components:

$$v_{it} = u_{i} + \epsilon_{it}$$

So, the model becomes:

$$
y_it = β_0 + β_1*x_1it + ... + β_k*x_kit + u_i + ε_it
$$


We can also write the model by combining \\(\beta_0\\) and \\(u_i\\) into an individual-specific intercept:

$$
y_it = (β_0 + u_i) + β_1*x_1it + ... + β_k*x_kit + ε_it
$$

Here, \\(\alpha_i = \beta_0 + u_i\\) is the random intercept for individual $i$.


## Assumptions

We assume the following things about \\(u_i\\), \\(\epsilon_{it}\\) and their relationship:

Random Effect \\(u_i\\):

 - E[u_i] = 0 (The mean of the individual effects is zero; any non-zero mean is absorbed into β_0).

 - Var(u_i) = σ_u² (The variance of the individual effects is constant).

 - Cov(u_i, u_j) = 0 for i ≠ j (Individual effects are uncorrelated across individuals).


Idiosyncratic Error \\(\epsilon_{it}\\):

 - E[ε_it] = 0.

 - Var(ε_it) = σ_ε² (The variance of the idiosyncratic errors is constant – homoscedasticity).

 - Cov(ε_it, ε_is) = 0 for \\(t \neq s\\) (No serial correlation in idiosyncratic errors for a given individual, after accounting for u_i).

 - Cov(ε_it, ε_js) = 0 for \\(i \neq j\\) (Idiosyncratic errors are uncorrelated across individuals).


No correlation between u_i and ε_it:

 - Cov(u_i, ε_jt) = 0 for all \\(i, j, t\\). The individual random effects are uncorrelated with the idiosyncratic errors.


## The Structure of the Composite Error Term

The composite error term is \\(v_{it} = u_i + \epsilon_{it}\\). Let's look at its properties:

 - E[v_it] = E[u_i] + E[ε_it] = 0 + 0 = 0.

 - Var(v_it) = Var(u_i) + Var(ε_it) + 2*Cov(u_i, ε_it) = σ_u² + σ_ε² (due to the third assumption).

Now, consider the covariance of the composite error terms for the same individual i but at different time periods \\(t\\) and \\(s\\) (\\(t \neq s\\)):

$$
Cov(v_{it}, v_{is}) \newline
= Cov(u_i + ε_{it}, u_i + ε_{is}) \newline
= Cov(u_i, u_i) + Cov(u_i, ε_{is}) + Cov(ε_{it}, u_i) + Cov(ε_{it}, ε_{is}) \newline
\text{which equals, using all three assumptions:} \newline
Var(u_i) + 0 + 0 + 0 = σ_u^2
$$


This is a key result: For a given individual i, the error terms \\(v_{it}\\) and \\(v_{is}\\) are correlated 
across time because they share the same \\(u_i\\) component. The correlation is:

$$
Corr(v_{it}, v_{is}) = \frac{Cov(v_{it}, v_{is})}{\sqrt{(Var(v_{it})Var(v_{is}))}}
= \frac{ σ_u² }{ (σ_u² + σ_ε²)}
$$


This correlation is often called the intra-class correlation coefficient (ICC), denoted by \\(\rho\\). 
It represents the proportion of the total variance in the error term that is attributable to the individual-specific effect \\(u_i\\).

$$
ρ = \frac{σ_u^2}{(σ_u^2 + σ_ε^2)}
$$

If \\(σ_u^2 = 0\\), then \\(\rho = 0\\), and there's no individual-specific random effect, so OLS on pooled data would be appropriate.

## Estimation: Generalized Least Squares (GLS)

Because of the serial correlation in the composite error term v_it (i.e., Cov(v_it, v_is) = σ_u² ≠ 0), 
Ordinary Least Squares (OLS) applied to the pooled data \\(y_{it} = X_{it}'\beta + v_{it}\\) will still 
be unbiased and consistent, but it will be inefficient, and the standard errors will be incorrect.

The efficient estimator is Generalized Least Squares (GLS). The GLS estimator is:

$$
β_{GLS} = (X'\Omega^{-1}X)^{-1} X'\Omega^{-1}Y
$$

where Ω is the variance-covariance matrix of the composite error vector \\(v\\). 
For panel data, \\(\Omega\\) has a block-diagonal structure, with each block \\(\Omega_i\\) corresponding to individual i.
\\(\Omega_i\\) (a \\(T \times T\\) matrix for individual i) has:

    σ_u² + σ_ε² on the diagonal.

    σ_u² on the off-diagonals.

In practice, σ_u² and σ_ε² are unknown. So, we use Feasible GLS (FGLS):

    Estimate σ_u² and σ_ε² (e.g., from OLS residuals, or ANOVA methods on residuals from a preliminary regression like fixed effects or between effects).

    Construct an estimate Ω̂ using σ̂_u² and σ̂_ε².

    Compute β̂_FGLS = (X'Ω̂⁻¹X)⁻¹ X'Ω̂⁻¹Y.

The FGLS transformation (often called "quasi-demeaning" or "partial demeaning") for the random effects model can be written as:
y_it - θ * ȳ_i = β_1(x_1it - θ * x̄_1i) + ... + β_k(x_kit - θ * x̄_ki) + (v_it - θ * v̄_i)
where:

    ȳ_i = (1/T) Σ_t y_it (the mean of y for individual i). Similar for x̄_ji.

    θ = 1 - sqrt(σ_ε² / (T_i * σ_u² + σ_ε²))
    (Note: T_i is the number of observations for individual i. If balanced, T_i = T).

Observe the behavior of θ:

    If σ_u² = 0 (no random effect), then θ = 0. The RE model becomes pooled OLS: y_it = ....

    If T_i → ∞, then θ → 1. The RE model behaves like the Fixed Effects (FE) model (which uses full demeaning: y_it - ȳ_i).

    If σ_ε² = 0 (all variation is due to u_i), then θ → 1 (if T_i > 0), also behaving like FE.

So, the RE estimator is a weighted average of the between-estimator (using ȳ_i and x̄_i) and the within-estimator (FE, using y_it - ȳ_i and x_it - x̄_i).

