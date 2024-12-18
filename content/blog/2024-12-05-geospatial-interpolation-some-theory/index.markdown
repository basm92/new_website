---
title: 'Geospatial Interpolation: Some Theory'
author: 'Bas Machielsen'
date: '2024-12-05'
excerpt: Some theory about geospatial interpolation methods
slug: []
categories: []
tags: []
---

### 1. Introduction

Hi all, I want to write about geospatial interpolation methods and the underlying math. Potentially, in a follow-up blog post, I'll also discuss example, but in this post, I'll confine myself to some of the theory, introducing concepts like the _variogram_ and the _kriging_ equations: terms which I wasn't familiar with until very recently. So this post serves as a consolidation of my newly obtained knowledge. It can serve as a background to a text such as [this](https://r-spatial.org/book/12-Interpolation.html). 

### 2. What is Spatial Interpolation?

Spatial interpolation is evaluating/prediction a particular value `\(Z\)` at a point `\(s\)`, denoted `\(Z(s)\)` on the basis of observed data points `\(s_i\)`. As a motivating example, and potentially the simplest form of spatial interpolation, we can give the following:

$$
Z(s) = \frac{\sum_{i=1}^N w_i Z(s_i)}{\sum_{i=1}^N w_i}
$$

with `\( w_i = | s - s_i |^{-p}\)` and usually, the "inverse distance power" `\(p\)` equal to two, or potentially with optimized weights using cross validation. We should think of `\(s\)` as being pixels in a raster data set, for which we have available observable points `\(s_i\)`, which we want to extrapolate to all other points, one such point being denoted as `\(s\)`. This is also the notation that I follow in the remainder of this post: `\(s\)` is an arbitrary pixel we want to extrapolate for. 

### 3. Spatial Covariance and the Variogram

The main method (as far as I get) used to interpolate geospatially is not the preceding method, even though it can be used, sometimes with good results. However, the main method starts with a stationary model such as this:

$$
Z(s) = m + e(s)
$$

where `\(m\)` is the mean of the value `\(Z\)`, and `\(e(s)\)` is a mean-zero error term. One object of interest here is the covariance of the error term `\(e(s)\)`. I referred to the model above as stationary exactly because of the structure imposed on this covariance matrix. In the standard model, it looks like this. For `\(n\)` observed locations `\(s_1, \dots, s_n\)`, the spatial covariance matrix `\(C\)` is an `\(n \times n\)` matrix where each element represents the covariance between `\(e(s_i)\)` and `\(e(s_j)\)`:

$$
\mathbf{C} = \begin{bmatrix}
C(0) & C(h_{12}) & \dots & C(h_{1n}) \\ \newline
C(h_{21}) & C(0) & \dots & C(h_{2n}) \\ \newline
\vdots & \vdots & \ddots & \vdots \\ \newline
C(h_{n1}) & C(h_{n2}) & \dots & C(0) 
\end{bmatrix}
$$

where `\(h_{ij} = ||s_i - s_j||\)` is the distance between locations `\(s_i\)` and `\(s_j\)`. Implicit in this matrix, there is a **covariance function** `\(C(h)\)`, which defines the covariance between two observations squarely as a function of distance between them `\(h\)`. 

The covariance function `\(C(h)\)`, with `\(h\)` being the distance between an arbitrary point `\(s\)` and point `\(s+h\)`, is defined as:

$$
C(h)=\text{Cov}(e(s),e(s+h))=E[e(s)e(s+h)]−E[e(s)]E[e(s+h)]
$$

Since we have imposed that `\(E(e(s))=0\)`, this simplifies to:

$$
C(h)=E[e(s)e(s+h)].
$$

Note also that `\(C(0)\)` represents the variance of `\(e(s)\)`. The **variogram** is a relationship that reflects the difference between `\(C(h)\)` and `\(C(0)\)`. The variogram is defined as:

$$
\gamma (h)=\frac{1}{2} \mathbb{E}[(e(s)−e(s+h))^2]
$$

Essentially, the variogram can be thought of as a continuous function in `\(h\)` that aligns with these sample covariances. The variogram `\(\gamma (h)\)` and covariance `\(\mathbf{C}(h)\)` are mathematically related as:

$$
\gamma(h)=C(0)−C(h).
$$

To see that, expand the square in the definition of the variogram:

$$
\gamma (h)=\frac{1}{2}(E[e(s)^2]−2E[e(s)e(s+h)]+E[e(s+h)^2]).
$$

Under stationarity, the random field e(s)e(s) has:
- Constant variance:

$$
E[e(s)^2]=E[e(s+h)^2]=C(0),
$$
- A covariance function depending only on the distance `\(h\)`, not on `\(s\)`:

$$
E[e(s)e(s+h)]=C(h).
$$

Hence `\(\gamma (h) = \frac{1}{2} (C(0) - 2 C(h) + C(0)) = C(0) - C(h)\)`. 

The variogram is a theoretical construct, but can also be estimated, for example, as follows. Let `\(h_i\)` be a distance interval from `\(h_{i0}\)` to `\(h_{i1}\)`: 

$$
\hat{\gamma}(h) = \frac{1}{2N(h_i)} \sum_{j=1}^{N(h_i)} (z(s_i) - z(s_i + h'))^2 \text{ for } h_{i0} < h' < h_{i1}.
$$
`\(N(h_i)\)` is the number of observations (sample pairs) available for distance interval `\(h_i\)`. 

Why do we need the variogram? The variogram allows you to estimate the covariance matrix `\(C(h)\)` in an easy and convenient way, by fitting a curve to the sample variogram. Additionally, it turns out that when spatial interpolating using a method called **kriging**, the form used in the variogram turns out to be convenient, as we will see.


### 4. The Kriging System Setup

We aim to predict `\(Z(s)\)` as a weighted sum of the observed values `\(Z(s_i)\)`:

$$
Z (s) = \sum_{i=1}^n \lambda_i Z (s_i)
$$

while ensuring two things:
  - The prediction is unbiased, meaning `\(E[Z(s)]=E[Z(s_i)]\)`.
  - The prediction minimizes the variance of the error.

The unbiasedness condition requires that the weights sum to 1, `\(\sum_{i=1}^N \lambda_i = 1\)`.

To minimize the prediction error variance, we use the spatial correlation structure encoded by the variogram. For each to be interpolated observation `\(Z(s)\)`, the kriging weights `\(\lambda_i\)` are chosen such that the variance of the prediction error:

$$
\text{Var}\left(Z(s) - \sum_{i=1}^N \lambda_iZ(s_i)\right)
$$

is minimized.

That leads to the so-called **kriging system**, providing a solution for the weights `\(\lambda_i\)`. I'll first state this system of equations, then explain where it comes from. For each **observed point** `\(s_i\)`, the kriging system requires the following relationship to hold between that observed point `\(s_i\)`, the variogram value corresponding to the distance of that observed point with all other observed points, and the distance between the observed point `\(s_i\)` and the to be interpolated point `\(s*\)`:

$$
\sum_{j=1}^N \lambda_j \gamma (h_{ij}) + \mu = \gamma (h_{i*})
$$

where `\(\gamma (h_{ij})\)` are the variogram value for the distance between `\(s_i\)` and `\(s_j\)`, `\(\gamma (h_{i*})\)` is the variogram value for the distance between `\(s_i\)` and the predicted location `\(s*\)`, and `\(\mu\)` is a Lagrange multiplier enforcing the constraint `\(\sum_{j=1}^N \lambda_j = 1\)`. The constraint `\(\sum_{j=1}^N \lambda_j = 1\)` is the second component of the kriging system. Since this relationship holds for all observed points `\(s_i\)`, we can rewrite this using linear algebra. But mind that this is a _separate_ system for each to be interpolated point `\(s*\)`:

Let `\(\Gamma\)` be a matrix with the variogram values between all observed points:

$$
\Gamma = \begin{bmatrix} \gamma (h_{11}) & \gamma (h_{12}) & \dots & \gamma (h_{1n}) \\ \newline
\gamma (h_{21}) & \gamma (h_{22}) & \dots & \gamma (h_{2n}) \\ \newline
\vdots & \vdots & \ddots & \vdots \\ \newline
\gamma (h_{n1}) & \gamma (h_{n2}) & \dots & \gamma (h_{nn}) 
\end{bmatrix}
$$

Let `\(\gamma_*\)` be a column vector of variogram values between the observed points and the to be interpolated location:

$$
\gamma_* = \begin{bmatrix}
\gamma (h_{1*}) \\ \newline
\gamma (h_{2*}) \\ \newline
\vdots \\ \newline
\gamma (h_{n*})
\end{bmatrix}
$$

Let `\(\lambda\)` be a column vector of `\(n\)` weights, and `\(v\)` be a row vector of `\(n\)` ones. The **kriging** system is then expressed as:

$$
\begin{bmatrix}
\Gamma & v^T \\ \newline
v & 0 
\end{bmatrix} \begin{bmatrix} 
\lambda \\ \newline
\mu \end{bmatrix} = 
\begin{bmatrix} \gamma_* \\ \newline
1 \end{bmatrix}
$$

Intuitively, it makes sense that the distance between any point `\(s_i\)` and a to be interpolated point `\(s*\)` is a _some_ weighted average of all other distances. Since variograms are a function of distances only, the relationship should also hold for variograms. But a more formal derivation is as follows:

Since we're minimizing the variance, we have:

$$
\text{Var}(e(s∗))=\text{Var}(Z(s∗)) + \sum_{i=1}^N \sum_{j=1}^N \lambda_i \lambda_j \text{Cov}(Z(s_i),Z(s_j)) - 2 \sum_{i=1}^N \lambda_i \text{Cov}(Z(s∗),Z(s_i)).
$$

By our stationarity assumptions, we have:

  - `\(\text{Var}(Z(s_∗))=C(0)\)`,
  - `\(\text{Cov}(Z(s_∗),Z(s_i))=C(h_{i∗})\)`
  - `\(\text{Cov}(Z(s_i),Z(s_j))=C(h_{ij})\)`
  
Hence, the objective function simplifies, and combined with the constraint that `\(\sum_{i=1}^N \lambda_i=1\)`, we have the following Lagrangian:

$$
\mathcal{L}(\lambda, \mu)=C(0)+ \sum_{i=1}^N \sum_{j=1}^N \lambda_i \lambda_j C(h_{ij})−2 \sum_{i=1}^N C(h_{i*})+ \mu (1−\sum_{i=1}^n \lambda_i). 
$$


Differentiating this with respect to an arbitrary `\(\lambda_k\)` of our choice variables, and simplifying gives:

$$
\sum_{j=1}^n \lambda_j C(h_{kj})−C(h_{k∗})−\frac{\mu}{2}=0
$$

whereas differentiating with respect to the Lagrange multiplier `\(\mu\)` just gives us back our constraint. Normalizing the Lagrange multiplier, and writing these `\(n\)` equations in a system from combined with the constraint gives us the matrix formulation as seen above. Since all of these things are observed, we can simply solve the kriging system for `\((\lambda, \mu)\)` and find our weights `\(\lambda\)`. 

### 5. Extensions

If you have other variables at your disposal for the _entire grid_, that is, including the points you want to interpolate, you could potentially extend the model with covariates:

$$
Z(s) = \sum_{j=0}^p \beta_j X_j (s) + e(s)
$$

In this case, the strategy boils down to modeling the conditional spatial covariance. Similarly, we can potentially extend the covariance structure by allowing spatial covariance to be a function of time:

$$
Z(s, t) = \mu + e(s, t)
$$

This boils down to estimating a separate variogram for each discrete time point `\(t\)`, and solving the kriging system using that particular variogram. 

### 6. Conclusion

I have attempted to underpin basic geospatial interpolation models and explain the logic on which they're based. I hope this was useful as a more mathematical underpinning of methods that seem arbitrary at first sight. If you have any recommendations or good texts on this subject that might be interesting, make sure to let me know. Thanks for reading!



