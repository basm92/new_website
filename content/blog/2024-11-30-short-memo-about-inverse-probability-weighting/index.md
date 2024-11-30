---
title: Short Memo About Inverse Probability Weighting
author: 'Bas Machielsen'
excerpt: A small derivation of the inverse probability-weighted estimator of the Average Treatment Effect on the Treated (ATT)
date: '2024-11-30'
slug: []
categories: []
tags: []
---

## Introduction

I want to briefly have on paper the logic behind using inverse probability-weighted estimators of the ATT (average treatment effect on the treated) in a causal inference context. 

## Setup

- Let `\(Y(1)\)` and `\(Y(0)\)` denote the potential outcomes under treatment and no treatment, respectively.

- The ATT is defined as:

$$
ATT=\mathbb{E}[Y(1)−Y(0)∣T=1]
$$

where `\(T \in \{0,1\}\)` indicates treatment status.

We assume that conditional on covariates `\(X\)`, the treatment is independent of `\(Y(0)\)`, an assumption known as unconfoundedness. 

The IPW estimator uses weights to adjust for the selection bias in treatment assignment. The weights are derived from the propensity score, $$e(X)=P(T=1∣X)$$ which is the probability of receiving treatment given covariates `\(X\)`. 

## Idea

The first part of the `\(ATT\)`, `\(\mathbb{E}[Y(1) | T=1]\)` is identified. The idea is to estimate `\(\mathbb{E}[Y(0)|T=1]\)` using the observed outcomes from the untreated group, for which `\(T=0\)`. The IPW Estimator for `\(\mathbb{E}[Y(0)|T=1]\)` is:

$$
\frac{\mathbb{E}[Y \times 1(T=0) \times \frac{e(X)}{1−e(X)}]}{\mathbb{E}[1(T=0) \times \frac{e(X)}{1−e(X)}]}.
$$

where `\(\mathbb{E}(.)\)` are now in-sample operations.

## Unbiasedness Proof

I evaluate this estimator and show that the expected value equals `\(\mathbb{E}[Y(0)|T=1]\)`. 


1. For `\(T=0\)`, the observed outcome `\(Y\)` equals `\(Y(0)\)`. Thus, the numerator of the IPW estimator becomes:

$$
\mathbb{E}\left[Y \times 1(T=0)\times \frac{e(X)}{1−e(X)}\right]=\mathbb{E}\left[Y(0)\times 1(T=0)\times \frac{e(X)}{1−e(X)}\right].
$$

Using the law of iterated expectations, and making use of independence between `\(Y(0)\)` and `\(T\)` conditional on `\(X\)`, we condition on `\(X\)`:

$$
\mathbb{E} \left[Y(0) \times 1(T=0) \times \frac{e(X)}{1−e(X)}\right]=\mathbb{E}[\mathbb{E}[Y(0)∣X] \times \mathbb{E}[1(T=0) \times \frac{e(X)}{1−e(X)}∣X]].
$$


The indicator `\(1(T=0)\)` ensures `\(P(T=0∣X)=1−e(X)\)`. Substituting the following:

`\(\mathbb{E}[1(T=0) \times \frac{e(X)}{1−e(X)}∣X]=e(X)\)`

into the numerator makes it that the numerator simplifies to:

$$
\mathbb{E}[Y(0) \cdot e(X)].
$$

2. Using the law of iterated expectation again (while conditioning again on `\(X\)`), the denominator of the IPW estimator normalizes the weights:

$$
\mathbb{E}[1(T=0)\times \frac{e(X)}{1−e(X)}]=E[e(X)].
$$

3. Combining Terms now makes it that the IPW estimator becomes:

$$
\frac{\mathbb{E}[Y(0) \times e(X)]}{E[e(X)]}
$$

Now note that the denominator is `\(P(T=1)\)` and the nominator is the event that `\(P(T=1) \cap Y(0)\)`. Thus, by the definition of conditional probability*, this equals `\(\mathbb{E}[Y(0)|T=1]\)`. 

*: For an explicit derivation of this, see below

## Conclusion

This derivation showed that the inverse probability-weighted estimator is an unbiased estimator for the counterfactual outcome `\(Y(0)\)` for the treated group. The derivation is fundamental and pops up a lot in the treatment evaluation literature. I have loosely based it on Imbens and Rubin (2015). 



### Appendix: Explicit Deriviation 

Here is an explicit derivation why the estimator `\( \frac{\mathbb{E}[Y(0) \times e(X)]}{E[e(X)]}
\)` recovers `\( \mathbb{E}[Y(0) \mid T = 1] \)`. 

#### 1. Using the Law of Total Probability:

The expectation `\( \mathbb{E}[Y(0) \mid T = 1] \)` can be expressed using the law of total probability:

$$
\mathbb{E}[Y(0) \mid T = 1] = \int \mathbb{E}[Y(0) \mid X] \cdot P(X \mid T = 1)  dX.
$$

Here:`\( \mathbb{E}[Y(0) \mid X] \)` is the expected potential outcome for untreated individuals at a given `\( X \)`.

`\( P(X \mid T = 1) \)` is the distribution of `\( X \)` in the treated group.


#### 2. Reweighting the Untreated Group to Match `\( P(X \mid T = 1) \)`:

We can rewrite `\( P(X \mid T = 1) \)` in terms of `\( P(X) \)` and `\( e(X) \)` using Bayes' rule:

$$
P(X \mid T = 1) = \frac{P(T = 1 \mid X) \cdot P(X)}{P(T = 1)} = \frac{e(X) \cdot P(X)}{\mathbb{E}[e(X)]}.
$$

Substituting this into the formula for `\( \mathbb{E}[Y(0) \mid T = 1] \)`, we have:

$$
\mathbb{E}[Y(0) \mid T = 1] = \int \mathbb{E}[Y(0) \mid X] \cdot \frac{e(X) \cdot P(X)}{\mathbb{E}[e(X)]}  dX.
$$

#### 3. Expressing as a Weighted Expectation:

Recognizing  that the integral over `\( P(X) \)` represents the total expectation over the population distribution of `\( X \)`, we have:

$$
\mathbb{E}[Y(0) \mid T = 1] = \frac{\int \mathbb{E}[Y(0) \mid X] \cdot e(X) \cdot P(X)  dX}{\mathbb{E}[e(X)]}.
$$

The numerator,`\( \int \mathbb{E}[Y(0) \mid X] \cdot e(X) \cdot P(X) \, dX \)`, is equivalent to `\( \mathbb{E}[Y(0) \cdot e(X)] \)`, the expectation of `\( Y(0) \cdot e(X) \)` over the population. Hence:

$$
\mathbb{E}[Y(0) \mid T = 1] = \frac{\mathbb{E}[Y(0) \cdot e(X)]}{\mathbb{E}[e(X)]}.
$$

