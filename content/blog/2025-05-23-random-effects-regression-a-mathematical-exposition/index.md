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

Imagine you have data for N individuals (or firms, countries, etc.), denoted by \\(i = 1, \dots, N\\), observed over \\(T\\) time periods, denoted by \\(t = 1, \dots, T\\). (For simplicity, we'll assume a balanced panel, meaning each individual is observed for all \\(T\\) periods, though RE can handle unbalanced panels.)

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
y_{it} = \beta_0 + \beta_1 x_{1it} + \dots + \beta_k x_{kit} + u_i + \epsilon_{it}
$$

We can also write the model by combining \\(\beta_0\\) and \\(u_i\\) into an individual-specific intercept:

$$
y_{it} = (\beta_0 + u_i) + \beta_1 x_{1it} + \dots + \beta_k x_{kit} + \epsilon_{it}
$$

Here, \\(\alpha_i = \beta_0 + u_i\\) is the random intercept for individual \\(i\\).


## Assumptions

We assume the following things about \\(u_i\\), \\(\epsilon_{it}\\) and their relationship:

Random Effect \\(u_i\\):

 - \\(E[u_i] = 0\\) (The mean of the individual effects is zero; any non-zero mean is absorbed into \beta_0).

 - \\(\text{Var}(u_i) = \sigma^2_u\\) (The variance of the individual effects is constant).

 - \\(\text{Cov}(u_i, u_j) = 0 \text{ for } i \neq j\\) (Individual effects are uncorrelated across individuals).


Idiosyncratic Error \\(\epsilon_{it}\\):

 - \\(E[\epsilon_{it}] = 0\\).

 - \\(\text{Var}(\epsilon_{it}) = \sigma^2_\epsilon\\) (The variance of the idiosyncratic errors is constant – homoscedasticity).

 - \\(\text{Cov}(\epsilon_{it}, \epsilon_{is}) = 0 \text{ for } t \neq s\\) (No serial correlation in idiosyncratic errors for a given individual, after accounting for \\(u_i\\)).

 - \\(\text{Cov}(\epsilon_{it}, \epsilon_{js}) = 0 \text{ for } i \neq j\\) (Idiosyncratic errors are uncorrelated across individuals).


No correlation between \\(u_i\\) and \\(\epsilon_{it}\\):

 - \\(\text{Cov}(u_i, \epsilon_{jt}) = 0 \text{ for all } i, j, t\\). The individual random effects are uncorrelated with the idiosyncratic errors.


## The Structure of the Composite Error Term

The composite error term is \\(v_{it} = u_i + \epsilon_{it}\\). Let's look at its properties:

 - \\(E[v_it] = E[u_i] + E[\epsilon_{it}] = 0 + 0 = 0\\).

 - \\(\text{Var}(v_{it}) = \text{Var}(u_i) + \text{Var}(\epsilon_{it}) + 2 \text{Cov}(u_i, \epsilon_{it}) = \sigma^2_u + \sigma^2_\epsilon\\) (due to the third assumption).

Now, consider the covariance of the composite error terms for the same individual i but at different time periods \\(t\\) and \\(s\\) (\\(t \neq s\\)):

$$
\begin{aligned}
\text{Cov}(v_{it}, v_{is}) 
&= \text{Cov}(u_i + ε_{it}, u_i + ε_{is}) \newline
&= \text{Cov}(u_i, u_i) + \text{Cov}(u_i, ε_{is}) + \text{Cov}(ε_{it}, u_i) + \text{Cov}(ε_{it}, ε_{is}) \newline
&\text{which equals, using all three assumptions:} \newline
&\text{Var}(u_i) + 0 + 0 + 0 = σ_u^2
\end{aligned}
$$


This is a key result: For a given individual \\(i\\), the error terms \\(v_{it}\\) and \\(v_{is}\\) are correlated 
across time because they share the same \\(u_i\\) component. The correlation is:

$$
\text{Cor}(v_{it}, v_{is}) = \frac{\text{Cov}(v_{it}, v_{is})}{\sqrt{(\text{Var}(v_{it})\text{Var}(v_{is}))}}
= \frac{ \sigma_u^2 }{ (\sigma_u^2 + \sigma_\epsilon^2)}
$$


This correlation is often called the intra-class correlation coefficient (ICC), denoted by \\(\rho\\). 
It represents the proportion of the total variance in the error term that is attributable to the individual-specific effect \\(u_i\\).

$$
\rho = \frac{\sigma_u^2}{(\sigma_u^2 + \sigma_\epsilon^2)}
$$

If \\(\sigma_u^2 = 0\\), then \\(\rho = 0\\), and there's no individual-specific random effect, so OLS on pooled data would be appropriate.

## Estimation: Generalized Least Squares (GLS)

Because of the serial correlation in the composite error term \\(v_{it}\\) (i.e., \\(\text{Cov}(v_{it}, v_{is}) = \sigma_u^2 \neq 0\\)), 
Ordinary Least Squares (OLS) applied to the pooled data \\(y_{it} = X_{it}'\beta + v_{it}\\) will still 
be unbiased and consistent, but it will be inefficient, and the standard errors will be incorrect.

The efficient estimator is Generalized Least Squares (GLS). This is because the setting is OLS with heteroskedastic data, for which the optimal estimator normalizes the variance again. Then, by the Gauss-Markov theorem, that estimator is efficient. The GLS estimator is:

$$
\beta_{GLS} = (X'\Omega^{-1}X)^{-1} X'\Omega^{-1}Y
$$

where $\Omega$ is the variance-covariance matrix of the composite error vector \\(v\\). 
For panel data, \\(\Omega\\) has a block-diagonal structure, with each block \\(\Omega_i\\) corresponding to individual \\(i\\).
\\(\Omega_i\\) (a \\(T \times T\\) matrix for individual i) has:

  - \\(\sigma_u^2 + \sigma_\epsilon^2\\) on the diagonal.
  - \\(\sigma_u^2\\) on the off-diagonals.

In practice, \\(\sigma_u^2\\) and \\(\sigma_\epsilon^2\\) are unknown. So, we have to use a Feasible GLS (FGLS) procedure:
  - Estimate \\(\sigma_u^2\\) and \\(\sigma_\epsilon^2\\) (e.g., from OLS residuals.)
    - How to do this?
    - The overall variance of the OLS residuals is a natural estimator for \\(\text{Var}(v_{it}) = \sigma_u^2 + \sigma_\epsilon^2\\). This is the first equation we need.
    - Consider the average residual for each individual \\(i\\):
    - \\(\bar{e_i} = (1/T) \sum_t\hat{e}_{it}\\). 
    - These \\(\hat{e_i}\\) are estimates of \\(\hat{v_i} = (1/T) \sum_t v_{it} = (1/T) \sum_t (u_i + \epsilon_{it}) = u_i + \bar{\epsilon}_i\\). (Since \\(u_i\\) is constant for individual \\(i\\)).
    - Now, let's find the variance of these individual-average residuals across individuals:
    - \\(\text{Var}(\hat{e_i}) = Var(u_i + \bar{\epsilon_i})\\)
    - Assuming \\(u_i \text{ and } \epsilon_{it}\\) are uncorrelated, and \\(\epsilon_{it}\\) are serially uncorrelated for a given \\i\\):
    - \\(\text{Var}(u_i + \bar{\epsilon_i}) = \text{Var}(u_i) + \text{Var}(\bar{\epsilon_i}) = \sigma_u^2 + \text{Var}( (1/T) \sum_t \epsilon_{it} ) \\)
    - \\(= \sigma_u^2 + (1/T^2) \sum_t \text{Var}(\epsilon_{it}) = \sigma_u^2 + (1/T^2) \cdot T \cdot \sigma_\epsilon^2 = \sigma_u^2 + \sigma^2_\epsilon / T \\)
    - So, the sample variance of the \\(\bar{e_i}\\) values, let's call it \\( s_{\bar{e_i}^2}\\) estimates \\(\sigma_u^2 + \sigma_\epsilon^2 /T \\).
    - Hence, our second equation is: \\(\sigma^2_u + \sigma^2_\epsilon /T = s_{\bar{e_i}^2}\\)
    - We have two equations and two unknowns and solve for \\(\sigma^2_u \text{ and } \sigma^2_\epsilon\\). 
  - Construct an estimate of \\(\hat{\Omega}\\) using  \\(\hat{\sigma_u^2}\\) and \\(\hat{\sigma_\epsilon^2}\\)
  - Compute \\(\beta^{FGLS} = (X'\hat{\Omega}^{-1}X)^{-1} X'\hat{\Omega}^{-1}Y\\).

The FGLS transformation (often called "quasi-demeaning" or "partial demeaning") for the random effects model can be written as:

$$
y_{it} - \theta \bar{y_i}  = \beta_1( x_{1it} -\theta\bar{x_{1i}}) +\dots + \beta_k(x_{kit} - \theta\bar{x_{ki}}) + (v_{it} -\theta \bar{v}_i)
$$

where:
  - \\(\bar{y_i} = (1/T) \sum_t y_{it}\\) (the mean of \\(y\\) for individual \\(i\\)). Similar for \\(\bar{x_{ji}}\\).
  - \\(\theta = 1 - \sqrt{\frac{\sigma^2\epsilon}{(T_i \sigma^2_u + \sigma^2_\epsilon)}}\\)
  - \\(T_i\\) is the no. of observations for individual \\(i.\\) If balanced, \\(T_i = T\\).

The reason for this is the following:

1.  The transformation \\(y_{it} - \theta \bar{y_i}\\) (and similarly for X's) aims to create a new error term \\(v_{it*} = (u_i + \epsilon_{it}) - \theta(u_i + \bar{\epsilon_i})\\).
2.  We choose \\(\theta = 1 - \sqrt{\frac{\sigma^2\epsilon}{(T_i \sigma^2_u + \sigma^2_\epsilon)}}\\) because this specific value makes the covariance between transformed errors for the same individual at different times, \\(\text{Cov}(v_{it*}, v_{is*})\\) (for \\(t \neq s\\)), equal to zero.
3.  With this \\(\theta\\), the variance of the transformed errors also simplifies to \\(\text{Var}(v_{it*}) = \sigma^2_\epsilon\\), meaning they are homoscedastic and serially uncorrelated.
4.  Applying OLS to this "quasi-demeaned" data is equivalent to GLS on the original data, yielding efficient estimates.

## Interpretation

Observe the behavior of \\(\theta\\):
  - If \\(\sigma_u^2 = 0\\) (no random effect), then \\(\theta = 0\\). The RE model becomes pooled OLS.
  - If \\(T_i \rightarrow \infty\\), then \\(\theta \rightarrow 1\\). The RE model behaves like the Fixed Effects (FE) model (which uses full demeaning).
  - If \\(\sigma_\epsilon^2 = 0\\) (all variation is due to \\(u_i\\)), then \\(\theta \rightarrow 1 \\) (if \\(T_i > 0\\)), also behaving like FE.

So, the RE estimator is a weighted average of the between-estimator (using \\(\bar{y_i} \text{ and } \bar{x_i}\\)) and the within-estimator (FE, using \\(y_{it} - \bar{y_i} \text{ and } x_{it} - \bar{x_i}\\)).

