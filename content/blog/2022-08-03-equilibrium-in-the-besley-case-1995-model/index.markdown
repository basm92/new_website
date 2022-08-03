---
title: Equilibrium in the Besley-Case (1995) Model
author: 'Bas Machielsen'
date: '2022-05-19'
draft: false
excerpt: A post about the Besley & Case (1995) Model. It explains my view on how to computationally calculate the equilibrium, which is left undetailed in the paper. 
layout: single
series: null
subtitle: ""
tags: null
---




## Introduction

Besley and Case (1995) have a paper about the influence of term limits for politicians on policy behavior. They use a dynamic game. Politicians can serve either 1, or 2, periods, depending on whether they are retained. In these periods, politicians choose to put in effort. Putting in more or less effort is costly to different extents, according to their type. The chosen effort probabilistically affects a policy outcome. An infinitely-lived voter makes decisions to retain or dismiss the politician after observing the outcome. Their solution, based on Banks and Sundaram (1998) involves a _cut-off equilibrium_, with voters reelecting an incumbent policy if the probabilistically-influenced policy variable realization is higher than some threshold `\(r_{min}\)`. 

One of their predictions is that the equilibrium amount of effort put in by the politicians who are in their first period is higher than in their last period, irrespective of the politician's type. Also, politicians who are in their second period are more likely to be high-type politicians, so that cross-sectionally, it seems that politicians in the second period have put in more effort than politicians in the first period, even though, if one looks at a "panel" of politicians over two periods, the first period effort is higher than the second period. The interpretation is that the policy outcome is better when there is politicians who do not face a term limit, irrespective of the type (ability) of the politicians. As they put it:

> If two terms are allowed, then incumbents who give higher first-term payoffs to voters are more likely to be retained to serve a second term. Those in their last term put in less effort and give lower payoffs to voters, on average, compared with their first term in office.

Their model is fairly general, so in this blog post, I wanted to give an easier to understand version for a specific case using Python to solve for some expressions that are not analytically soluble. I also want to demonstrate how to use standard computational techniques in macro for this specific case. 

## Set-up

In the Besley and Case (1995) model, there can be `\(k\)` types of politicians, ordered by ability `\(\omega_1 < \dots < \omega_k\)`. They occur with probabilities `\(\pi_1, \dots, \pi_k\)`. In my setup, there are only two types, `\(\omega_1 < \omega_2\)` with `\(\omega_1 = 3\)` and `\(\omega_2 = 9\)`. `\(\omega_1\)` occurs with probability `\(\pi_1 = 0.2\)` and `\(\omega_2\)` with probability `\(\pi_2 = 0.8\)`. The politicians per-period utility is:

$$
v(\alpha, \omega_i) = \alpha - \frac{\alpha^2}{\omega_i}
$$
If the politician is in power, otherwise, utility is zero. This reflects an expected reward proportional to effort, and the utility is negative in effort, meaning that effort is costly, but less negative for higher-quality types.

Effort is mapped into policy outcomes, `\(r\)`, probabilistically via `\(F(\alpha, r)\)`. In the Besley and Coate (1995) setting, this can be any distribution satisfying the monotone likelihood ratio property. In my setting, I take `\(F(\alpha, r)\)` to be `\(\Phi(\alpha)\)`, meaning `\(R \sim \mathcal{N}(\alpha, 1)\)`. The voter's one-period utility is simply the realized outcome `\(r\)`. 

## Optimization of the politician

In the second period, when retained, the politician will simply optimize their one-period utility:

$$
a^s_i = \frac{w_i}{4}
$$

In the first period, the politician will optimize:

$$
a^l\_i={\arg\max} \\{ v(\alpha,\omega\_i) +\delta \cdot [ \text{Pr} (r \in R(\sigma) | \alpha) \cdot v(a\_s(\omega\_i), \omega\_i)] \\}
$$


In words, this means the politician will take into account their second-period optimal strategy, and the likelihood that their realized `\(r\)` is greater than the voter's retention `\(r\)`. Given a _retention rule_, that probability is further specified as Pr(\\( r > r\_{\min} \\)). 

## Optimization of the voter

After observing the realized `\(r\)` after one period, the voter computes the belief that the incumbent is of type 1 (the low type) as follows:

$$
\beta_1 (r) = \frac{\pi_1 \cdot f(r; a_l (\omega_1))}{\pi_1 \cdot f(r; a_l (\omega_1)) + \pi_2 \cdot f(r; a_l(\omega_2))}
$$
The expected utility to the voter of retention is then:

$$
v_2 (r, \alpha^s, \alpha^l) = \sum_{i=1}^2 \int \beta_i (r) v(\hat{r})f(\hat{r}|\alpha^s_i) d\hat{r}
$$
which corresponds to the probability that the player is of type `\(i\)`, and then integrating over the entire range of potential `\(r\)`s, weighted by the density, given that they put in the optimal second period effort corresponding to their type. 

Banks and Sundaram (1993) then show that the Bellman equation for the voter's problem is:


$$
W(1, r, p) = \max \left\\{v_2 (r, \alpha^s, \alpha^l) + \alpha W(0, r, \pi), W(0, r, \pi) \right\\}
$$
where the state vector consists of `\(\{ 0, 1\}\)`, meaning how many periods the politician can still be retained, the realized `\(r\)` in the period, and the beliefs of the voter regarding the incumbent type `\(p\)`. In general, the last element of the tripe `\((\{0,1\}, r, p)\)` is the `\(n\)`-dimensional simplex, but because there are only 2 types, it is now summarized by `\(\beta_1 (r)\)`. 

The Bellman equation for the state `\(W(0,r,p)\)` is equal to the expected immediate reward plus the probability-weighted discounted future reward for each `\(W(1,r,p)\)`:

$$
W(0, r, p) = \sum_{i=1}^2 \pi_i \cdot \int \hat{r} f(\hat{r}|a^s_i) d\hat{r} + \delta \int W(1, \hat{r}, \beta_1 (\hat{r})) \cdot \sum_{k=1}^2 \pi_k \cdot f(\hat{r} | \alpha^s_k) d \hat{r}
$$
Now that we have the Bellman, we can use value-function iteration to derive the optimal `\(r\)`. We also need to take into account equilibrium conditions, so that (i) the voters respond to the optimal retention `\(r\)` according to the value function, and (ii) the politicians always set the best retention `\(r\)` given a particular estimate of the value function. Sundaram and Banks (1993) also prove that the dynamic programming theorems for this to be a contraction mapping hold. 


## Implementation

Below, I load the libraries, and I store a Python class called `RetentionModel`. 


```python
#%matplotlib inline
import matplotlib.pyplot as plt
plt.rcParams["figure.figsize"] = (11, 5)  #set default figure size
import numpy as np
from interpolation import interp
from scipy.optimize import minimize_scalar, bisect
from scipy.stats import norm
import scipy.integrate as integrate
import scipy.interpolate as interpolate

from numba import jit, njit, prange, float64, int32
from numba.experimental import jitclass

from tqdm import tqdm
```



```python
class RetentionModel:
  
    def __init__(self,delta=0.95,alpha=0.2,types=(3, 9),types_freq=(0.2, 0.8),up=6,low=2):
        self.delta, self.alpha, self.types, self.types_freq, self.up, self.low = delta, alpha, types, types_freq, up, low
    
        #'create a 3-dimensional grid'
        #'optimal r probably somewhere in between the means' of the efforts
        self.x_grid = np.mgrid[0:2, 2.5:3.5:0.1, 0:1.05:0.1].reshape(3, -1).T
        
    def evaluated_int(self, draws, value_f, typ, retention_r):
        """Evaluate an integral"""
        beta_1 = self.beta_1
        types_freq = self.types_freq
        
        n = len(draws)
        realization = [value_f([1, i, beta_1(i, retention_r)])[0] for i in draws]
        samples = np.dot(draws, realization)
    
        return types_freq[typ]*np.mean(realization)
  
    def vot_util(self, x):
        """voter utility function"""
        return x

    def f(self, r, effort):
        """normal pdf of r according to exerted effort"""
        return norm.pdf(r, loc = effort, scale = 1)
    
    def F(self, r, effort):
        """normal cdf of r according to exerted effort"""
        return norm.cdf(r, loc = effort, scale = 1)

    def expected_utility(self,effort, typ, retention_r, delta):
        F = self.F
        delta = self.delta
        """
        Return the total expected utility a priori from 
        the second period and then from the first period 
        as a function of the retention r, discount rate and exterted effort
        """
        out = effort - (effort**2)/typ + delta*(1-F(retention_r, effort))*typ/4
        return out

    def effort_first_period(self, typ, retention_r):
        """optimal effort in the first period given type"""
        #changed upper limit to typ, from 5
        return maximize(self.expected_utility, 1e-15, typ, (typ, retention_r, self.delta))[0]

    def effort_second_period(self, typ):
        """optimal effort in the second period given type and realized r"""
        return typ/2
    
    def beta_1(self, r, retention_r):
        """
        probability that type = type_1 after observing a specific r
        """
        f = self.f
        types = self.types
        types_freq = self.types_freq
        
        num = types_freq[0]*f(r, self.effort_first_period(types[0], retention_r))
        denom = num + types_freq[1]*f(r, self.effort_first_period(types[1], retention_r))
        
        return num/denom

    def v_2(self, r, retention_r, eff_sp_t1, eff_sp_t2):
        """
        Calculate the second period expected utility given a certain realized r
        and the optimal efforts by the players
        """
        types, types_freq, f, vot_util = self.types, self.types_freq, self.f, self.vot_util
        beta_1 = self.beta_1

        def integrand(x, e):
            return vot_util(x)*f(x, e)
            
        #'under linear utility, this just simplifies to the expected value'
        out1 = beta_1(r, retention_r)*integrate.quad(integrand, a=-np.inf, b=np.inf, args=eff_sp_t1)[0]
        out2 = (1-beta_1(r, retention_r))*integrate.quad(integrand, a=-np.inf, b=np.inf, args=eff_sp_t2)[0]
        
        return out1 + out2
    
    
    def state_action_value(self, action, state, v_array, retention_r):
        """
        Given state x_grid=[{0,1}, r, beliefs], and choice actions (k,d) and a guess v,
        what is the maximum (RHS bellman equation)
        """
        v_2, types, types_freq, beta_1, delta, alpha, f = self.v_2, self.types, self.types_freq, self.beta_1, self.delta, self.alpha, self.f
        vot_util, effort_first_period = self.vot_util, self.effort_first_period
        evaluated_int = self.evaluated_int
        
        #a multidimensional linear interpolator - make v a function 
        v = interpolate.LinearNDInterpolator(self.x_grid, v_array, fill_value=0)
        
        if state[0] == 0:            
        # return is eq. to instantaneous reward + expectation over all future 1 states 
        
            out1 = types_freq[0]*effort_first_period(types[0], retention_r)
            out2 = types_freq[1]*effort_first_period(types[1], retention_r)
            
            def integrand(x, *args): #v, beta_1, types, types_freq, effort_first_period, retention_r):
                f = self.f
                
                term1 = types_freq[0]*f(x, effort_first_period(types[0], retention_r))
                term2 = types_freq[1]*f(x, effort_first_period(types[1], retention_r))
                out = v([1, x, beta_1(x, retention_r)])[0]*(term1 + term2)
                
                return out
            
            def calc_integral(func, a, b, n, *args):
                delta = (b-a)/n
                points = np.linspace(a, b, n)
                
                values = [func(i, *args) for i in points]
                #values = func(points, *args)
    
                return delta*np.sum(values)

            
            out3 = calc_integral(integrand, 0, 13, 30, 
                                 v, 
                                 beta_1, 
                                 types, 
                                 types_freq, 
                                 effort_first_period,
                                 retention_r)
                                  
            return out1 + out2 + alpha*(out3)
        
        elif state[0] == 1:
        #both dismiss and keep are possible    
            if action == "k":
                one = alpha*v([0, state[1], types_freq[0]])[0]
                two = v_2(state[1], 
                          retention_r, 
                          self.effort_second_period(types[0]), 
                          self.effort_second_period(types[1]))
                
                return one + two 
            
            elif action == "d":
                return v([0, state[1], types_freq[0]])[0]
            
            else:
                raise ValueError("No action chosen")
        
```

I also define a custom maximizer, to take into account that the voter maximizes over a dichotomous \\( \\{ \text{dismiss, retain} \\} \\) decision. The politician uses a normal (continuous) maximizer, which I also implement. Finally, I use a Monte Carlo approximation for most complicated integrals I calculate:


```python
def maximize(g, a, b, args):
    """
    Maximize the function g over the interval [a, b].

    We use the fact that the maximizer of g on any interval is
    also the minimizer of -g.  The tuple args collects any extra
    arguments to g.

    Returns the maximal value and the maximizer.
    """

    objective = lambda x: -g(x, *args)
    result = minimize_scalar(objective, bounds=(a, b), method='bounded')
    maximizer, maximum = result.x, -result.fun
    return maximizer, maximum
  
# Write a maximizer like the concept maximizer above to find the optimal value for each point on the grid

def maximize_sav(function, args):
    """
    a function that maximizes the sav for a given state, v_array, and retention_r
    and on the basis of choices k,v
    
    returns the maximizer (the best action) and the maximum
    """
    state = args[0]
    v_array = args[1]
    retention_r = args[2]
    
    if state[0] == 0:
        action = "d"
        maximum = function("d", state, v_array, retention_r)
        
    elif state[0] == 1:
        
        dismiss = function("d", state, v_array, retention_r)
        keep = function("k", state, v_array, retention_r)
        if  dismiss > keep:
            action = "d"
            maximum = dismiss
        else:
            action = "k"
            maximum = keep
        
    return action, maximum


def monte_carlo_uniform(func,
                       a=-10,
                       b=10,
                       n=150):
    
    subsets = np.arange(0, n+1, n/10)
    steps = n/10
    u = np.zeros(n)
    for i in range(10):
        start = int(subsets[i])
        end = int(subsets[i+1])
        u[start:end] = np.random.uniform(low=i/10, high=(i+1)/10, size=end-start)
    np.random.shuffle(u)
    u_func = func(a+(b-a)*u)
    s = ((b-a)/n)*u_func.sum()
    
    return s
```


## Value Function Iteration

Then, I instantiate an instance of the model and apply value function iteration:


```python
model = RetentionModel(delta=0.99, alpha = 0.2)
```


```python
def T(v, rm, retention_r):
    """
    The Bellman operator.  Updates the guess of the value function.

    * ce is an instance of CakeEating
    * v is an array representing a guess of the value function

    """
    v_new = np.empty_like(v)
    p_new = [None]*len(v_new)

    for i, x in enumerate(rm.x_grid):
        # Maximize RHS of Bellman equation at state x
        #replace by my custom maximize function
        sol = maximize_sav(rm.state_action_value, args=(x, v, retention_r))
        p_new[i] = sol[0]
        v_new[i] = sol[1]
        
    new_retention_r = rm.x_grid[p_new.index('k')][1]

    return p_new, v_new, new_retention_r
```


```python
def compute_value_function(rm,
                           tol=1e-3,
                           max_iter=200,
                           verbose=True,
                           print_skip=1):

    # Set up loop
    v = np.zeros(len(rm.x_grid)) # Initial guess
    rr = 2 # Initial guess
    
    i = 0
    error = tol + 1

    while i < max_iter and error > tol:
        update = T(v, rm, rr)
        
        p_new = update[0]
        v_new = update[1]
        rr_new = update[2]
        
        error = np.max(np.abs(v - v_new))
        i += 1

        if verbose and i % print_skip == 0:
            print(f"Error at iteration {i} is {error}.")

        v = v_new
        rr = rr_new

    if i == max_iter:
        print("Failed to converge!")

    if verbose and i < max_iter:
        print(f"\nConverged in {i} iterations.")

    return p_new, v_new, rr_new
```

## Solution

The procedure converges and the model is saved under `out`:


```python
out = compute_value_function(model)
```

```
## Error at iteration 1 is 4.09024743100576.
## Error at iteration 2 is 1.608588398221574.
## Error at iteration 3 is 0.17448573956574087.
## Error at iteration 4 is 0.14479551187642237.
## Error at iteration 5 is 0.06623950959972902.
## Error at iteration 6 is 0.03690126342482625.
## Error at iteration 7 is 0.03690126342482625.
## Error at iteration 8 is 0.0003930360580230996.
## 
## Converged in 8 iterations.
```

and the optimal retention `\(r\)` for this specific case is:


```python
out[2]
```

```
## 3.3
```

.. which is an interior solution to the problem. It is also easily verifiable that this solution satisfies the characterization by Banks and Sundaram (1993), in that there is a cut-off \\( r \\), with no lower \\( r \\) being used for retention. 

I hope this has been useful! If you have any tips or remarks, let me know, and thanks for reading. 
