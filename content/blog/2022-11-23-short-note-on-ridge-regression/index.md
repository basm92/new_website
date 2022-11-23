---
title: Short Note on Ridge Regression
author: 'Bas Machielsen'
date: '2022-11-23'
slug: []
categories: []
mathjax: true
tags: []
---

## Introduction

I am doing a couple of assignments involving penalized estimators such as Ridge regression, and I wanted to do a short derivation of its asymptotic covariance. In comparison to the existing resources which I could find, some details are left out, which I wanted to recapitulate more clearly. I'll also contrast the variance of the Ridge estimator to the variance of the OLS estimator, illustrating a fact that also comes to the surface in many other resources, namely that the variance of the Ridge estimator is smaller than that of the OLS estimator. 

## Setting

I assume non-stochastic regressors \\(X\\), and a model with \\(Y = X\beta + \epsilon\\), \\(\epsilon \sim \mathcal{N}(0, \sigma^2 I)\\) with \\( \mathbb{E}[X^T \epsilon] = 0 \\). 

The ridge estimator can be expressed as:

$$
\hat{\beta}_{R} = (X^T X + \lambda I)^{-1} X^T y
$$

It is easy to show that the Ridge estimator is biased for \\(\lambda \neq 0\\) by evaluating the expected value.

## Consistency of the Ridge Estimator

Doing so also allows us to express \\( \hat{\beta}_{R} \\) as:

$$
\hat{\beta}_R = (X^T X + \lambda I)^{-1} X^T X \beta
$$

Taking the \\( \text{plim} \\) of this expression and applying Slutsky's theorem then gives:

$$
\text{plim} \left((X^T X + \lambda I)^{-1} X^T X \beta \right) = \text{plim} (\frac{1}{n} X^T X + \frac{1}{n} \lambda I)^{-1} \cdot \text{plim} (\frac{1}{n} X^T X) \beta
$$

After realizing that

$$
\text{plim} ( \frac{1}{n} \lambda I) = 0
$$

the above expression simplifies to \\(\beta\\), thus showing consistency. 


## Asymptotic Variance of the Ridge Estimator

The asymptotic variance variance of the Ridge regression around its \\(\text{plim}\\) can be obtained by rewriting the estimator in the following form:

$$
\hat{\beta}_R = (X^T X + \lambda I)^{-1} X^T y 
$$

$$
= (X^TX + \lambda I)^{-1} X^T (X\beta + \epsilon)
$$

$$
= (X^TX + \lambda I)^{-1} X^T \beta + (X^T X + \lambda I)^{-1} X^T \epsilon
$$

Which by the CLT converges to its \\(\text{plim}\\). The variance is then determined by its second part, since the first part is stochastic. 

- First, then, according to the (a) CLT, \\( X^T \epsilon \\) converges to its \\(\text{plim}\\) , which is zero by assumption, with a variance being equal to \\(\sigma^2 X^T X\\). Then, by the product limit normal rule (Cameron & Trivedi, 2005, Theorem A.17),  the variance of \\(\hat{\beta}_R\\) is then equal to:

$$
\text{Var} (\hat{\beta}_R) = \sigma^2 (X^T X + \lambda I)^{-1} X^T X (X^T X + \lambda I)^{-1}
$$

which can also be expressed as:

$$
\text{Var} (\hat{\beta}_R) = \sigma^2 (X^T X + \lambda I)^{-1} X^T X  (X^T X)^{-1} X^T X (X^T X + \lambda I)^{-1}
$$

## Comparison of Variance with OLS Estimator

Now, I show the positive semidefiniteness of the matrix Var \\( \beta_{OLS} \\) - Var \\( \beta_{R} \\): 

- Taking the previous expression, and defining \\( W = X^T X (X^T X + \lambda I )^{-1}\\), we can rewrite Var \\( \hat{\beta}_{R}\\) in a simple form:

$$
\text{Var} ( \hat{\beta}_{R} ) = \sigma^2 W^T (X^T X)^{-1} W
$$

The difference between Var \\( \beta_{OLS} \\) - Var \\( \beta_{R} \\) is then:

$$
\text{Var} (\hat{\beta_{OLS}}) - \text{Var} (\hat{\beta}_{R}) = \sigma^2 (X^T X)^{-1} - \sigma^2 W^T (X^T X)^{-1} W \newline
= \sigma^2 \left( (X^T X)^{-1} - W^T (X^T X)^{-1} W \right)
$$ 

It remains to show that 

$$
\left( (X^T X)^{-1} - W^T (X^T X)^{-1} W \right)
$$

is a positive semi-definite matrix. First, since \\( X^T X \\) is p.s.d., \\( (X^T X)^{-1}\\) is also p.s.d. (A short proof is comparing the eigenvalues of a matrix and its inverse). Also, if you add \\( \lambda I \\) to a matrix, its eigenvalues increase with \\( \lambda \\). Hence with \\( \lambda > 0 \\), we increase the already positive eigenvalues, and \\( W \\) is also p.s.d. 

After some derivation, we can show that the different in variances is equal to the following quadratic form:

$$
\sigma^2 (X^T X + \lambda I)^{-1} \left[ 2 \lambda I + \lambda^2 (X^T X)^{-1} \right] (X^T X + \lambda I)^{-1}
$$

Since, by the preceding discussion, all matrices here are p.s.d., the final variance is positive semi-definite and the variance of the OLS estimator is larger than the variance of the Ridge estimator. 

## Conclusion

In this post, I have set out some properties of the Ridge estimator, arguably the easiest to understand shrinkage estimator. I have focused on some standard theoretical results, and try to explain this in a way that works for me. Thank you for reading! 

