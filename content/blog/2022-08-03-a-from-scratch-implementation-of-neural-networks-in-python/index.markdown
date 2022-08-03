---
title: A From-Scratch Implementation of Neural Networks in Python
author: 'Bas Machielsen'
date: '2021-06-01'
draft: false
excerpt: Working out the underlying mathematical details of standard neural networks.
layout: single
series: null
subtitle: ""
tags: null
---


## Introduction

In this blog post, I wanted to write down an easy implementation of neural networks in Python. The model architecture of neural networks contains three pillars:

- The actual model (Multi-layer perceptron network), with inputs, layers, and outputs, and weights connecting these.
- Forward propagation - the loop from inputs to subsequent layers and finally, the output, using given weights. 
- Backward propagation - updating the weights with gradient descent to minimize the loss. 
    
In this blog post, I want to write about all three of them. I am borrowing heavily from two good resources: first, the [video series on Neural Networks](https://www.youtube.com/watch?v=aircAruvnKk) by 3blue1brown on Youtube, and secondly, [a tutorial](https://www.youtube.com/watch?v=fMqL5vckiU0&list=PL-wATfeyAMNrtbkCNsLcpoAyBBRJZVlnf&index=2) by Valerio Velardo. If you take the effort to watch these videos, you can see that Valerio's series provides the implementation architecture of neural networks in Python, but I think the notation by 3blue1brown is a little bit clearer. I will therefore slightly change the code, so that it matches the notation used in the 3blue1brown videos. Another good resource is [this book and accompanying code](http://neuralnetworksanddeeplearning.com/chap2.html#the_code_for_backpropagation), which also contains a Python-implementation of neural networks, which is virtually equivalent to mine, although it uses some operators with which I am less familiar. 


## Multilayer perceptron architecture and forward propagation

Our goal is to write a function that takes an `\(n\)`-dimensional vector as an input ($n_1, \dots, n_n$), transforms it to `\(Z > 1\)` intermediate layers, and finally transforms it into a `\(k\)`-dimensional output. Suppose the second layer `\(j\)` has `\(a_1, \dots, a_l\)` perceptrons in layer 2. Then, there have to be `\(n \cdot l\)` weights connecting `\(n\)` input perceptrons to `\(l\)` perceptrons. Following the notation of 3blue1brown, we take element `\((i,j)\)` of the matrix to be the weight _to_ `\(l\)` from `\(n\)`: in other words, if `\(i\)` changes, the layer to which the weight goes is changed, and when `\(j\)` changes, the layer _from_ which the weight goes is changed. In yet other words, different rows represent different destination nodes, and different columns represent different origin nodes: 

$$
W_{layer 1 \rightarrow layer 2} = \begin{bmatrix}
w_{n_1 \rightarrow a_1} & w_{n_2 \rightarrow a_1} & \dots & w_{n_n \rightarrow a_1} \newline
w_{n_1 \rightarrow a_2} & w_{n_2 \rightarrow a_2} & \dots & w_{n_n \rightarrow a_2} \newline
\vdots & & \ddots & \vdots \newline
w_{n_1 \rightarrow a_l} & w_{n_2 \rightarrow a_l} & \dots & w_{n_n \rightarrow a_l}
\end{bmatrix}
$$

This `\(l\)` x `\(n\)` matrix is then multiplied with a `\(n\)` x `\(1\)` vector to obtain a `\(l\)` x `\(1\)` vector, which represent all the perceptrons in layer 2. Multiplying out the above matrix with an input vector `\(x = (n_1, \dots, n_n)^T\)` gives:

$$
W\mathbb{x} = \begin{bmatrix}
w_{n_1 \rightarrow a_1} & w_{n_2 \rightarrow a_1} & \dots & w_{n_n \rightarrow a_1} \newline
w_{n_1 \rightarrow a_2} & w_{n_2 \rightarrow a_2} & \dots & w_{n_n \rightarrow a_2} \newline
\vdots & & \ddots & \vdots \newline
w_{n_1 \rightarrow a_l} & w_{n_2 \rightarrow a_l} & \dots & w_{n_n \rightarrow a_l}
\end{bmatrix} 
\begin{bmatrix} n_1 \newline \vdots \newline  \newline n_n \end{bmatrix} = \newline
\begin{bmatrix}
n_1 \cdot w_{n_1 \rightarrow a_1} + \dots + n_n \cdot w_{n_n \rightarrow a_1} \newline
\vdots \newline
n_1 \cdot w_{n_1 \rightarrow a_l} + \dots + n_n \cdot w_{n_n \rightarrow a_l}
\end{bmatrix}
$$

So that each entry in `\(a_l\)` is a product of the weights and the initial entries. This represents the first step in 'forward propagation' - the multiplication of weights and inputs. Subsequent steps involve only changing the dimensions, that is, changing the matrix `\(\mathbb{W}\)` to proceed from `\(l\)` perceptrons to the next intermediate layer, or output layer. In general, if layer `\(L-1\)` has `\(l\)` elements and layer `\(L\)` has `\(k\)` elements, then the weight matrix should have `\(k\)` x `\(l\)` elements, each element `\((i,j)\)` linking element `\(i\)` in layer `\(L\)` to element `\(j\)` in layer `\(L-1\)`. Of course, this new layer should be subject to an activation function (e.g. sigmoid), which I don't want to pay too much attention to. 

Implementation in Python looks as follows, where num_inputs and num_outputs represent the dimensions of input and output layers, and hidden layers is a list of numbers, indicating (i) how many hidden layers there should be (the length of the list), and (ii) how many perceptrons (nodes) each of them should have:



```python

import numpy as np


class MLP(object):

    def __init__(self, num_inputs=3, hidden_layers=[3, 3], num_outputs=2):

        self.num_inputs = num_inputs
        self.hidden_layers = hidden_layers
        self.num_outputs = num_outputs

        # create a list that saves the dimensions of the layers
        layers = [num_inputs] + hidden_layers + [num_outputs]

        # fill in random weights with the correct dimensions
        # if layer i has k elements, layer i+1 has j elements, the matrix should have j x k elements
        weights = []
        for i in range(len(layers)-1):
            w = np.random.rand(layers[i+1], layers[i])
            weights.append(w)
        self.weights = weights

    def forward_propagate(self, inputs):

        # the input layer activation is just the input itself
        activations = inputs

        # iterate through the network layers
        for w in self.weights:

            # calculate matrix multiplication between previous activation and weight matrix
            net_inputs = w @ activations

            # apply sigmoid activation function
            activations = self._sigmoid(net_inputs)

        # return output layer activation
        return activations

    def _sigmoid(self, x):
        
        y = 1.0 / (1 + np.exp(-x))
        return y
```

Forward propagation is achieved by a loop that multiplies subsequent layers (that start with the input layer) by the respective weights. This implementation overwrites the values of the subsequent layers every time, to save memory. Of course, it could have been possible to save the product `w @ activations` for each iteration in the for loop. Next, we look at backward propagation, and we incorporate that insight into the algorithm. 

## Backward propagation

Backward propagation calculates the partial derivatives with respect to all weight matrices. We find those in a recursive way, as implemented in the following algorithm. We then use a gradient descent algorithm to change the weight matrices in the direction in which the cost function decreases the most. Mathematically, what we attempt to implement is a gradient function consisting of the derivates of the Cost function with respect to the weights:

$$
\frac{\partial C}{\partial w^{(l)}\_{jk}} = a^{l-1}\_k \cdot \sigma'(z^{(l)}\_j) \cdot \frac{\partial C}{\partial a^{(l)}\_j} \text{ where: } \newline
\frac{\partial C}{\partial a^{(l)}\_j} = \begin{cases} \sum\_{j=1}^{n\_{l+1}} w^{(l+1)}\_{jk} \cdot \sigma'(z\_j^{(l+1)}) \cdot \frac{\partial C}{\partial a\_j^{(l+1)}} &\text{ if } l \neq L \newline
(a^{(L)}\_j - y\_j) &\text{ if } l = L \end{cases}
$$

In Python, the following code would implement the network with backpropagation using the same notational logic as we've used before. First, we define the MLP object and forward propagation, now saving all the activations and raw inputs (named z's):


```python

import numpy as np
from random import random


class MLP(object):

    def __init__(self, num_inputs=3, hidden_layers=[3, 3], num_outputs=2):
        
        self.num_inputs = num_inputs
        self.hidden_layers = hidden_layers
        self.num_outputs = num_outputs

        # create a generic representation of the layers
        layers = [num_inputs] + hidden_layers + [num_outputs]

        # create random connection weights for the layers
        weights = []
        for i in range(len(layers) - 1):
            w = np.random.rand(layers[i+1], layers[i])
            weights.append(w)
        self.weights = weights
        
        # save derivatives per layer
        derivatives = []
        for i in range(len(layers) - 1):
            d = np.zeros((layers[i+1], layers[i]))
            derivatives.append(d)
        self.derivatives = derivatives

        # save activations per layer
        activations = []
        for i in range(len(layers)):
            a = np.zeros(layers[i])
            activations.append(a)
        self.activations = activations
        
        # save raw inputs per layer
        zs = []
        for i in range(len(layers)):
            z = np.zeros(layers[i])
            zs.append(z)
        self.zs = zs
```

Then, we redefine forward propagation while saving the activations and raw inputs:


```python

def forward_propagate(self, inputs):

    # the input layer activation is just the input itself
    activations = inputs

    # save the activations for backpropogation
    self.activations[0] = activations

    # iterate through the network layers
    for i, w in enumerate(self.weights):
        # calculate matrix multiplication between previous activation and weight matrix
        z = np.dot(w, activations)

        # apply sigmoid activation function
        activations = self._sigmoid(z)

        # save the activations for backpropogation
        self.zs[i + 1] = z
        self.activations[i + 1] = activations

        # return output layer activation
    return activations, zs
```

Finally, we implement backward propagation as defined previously. We start with an 'error', meaning `\((a^L - y) \cdot \sigma'(z^L)\)`. We then compute the `\(\delta^L = (a^L - y) \cdot \sigma'(z^L)\)`. Afterwards, we implement the derivatives as `\(\frac{\partial C}{\partial w^l_{jk}} = \delta^l_j \cdot a^{(l-1)}_k\)` in matrix form. In this code, `\(i = l-1\)`. Finally, we update the error by redefining `\(\delta^l = ((w^{(l+1)})^T \delta^{(l+1)}) \cdot \sigma'(z^l)\)`. 


```python

def back_propagate(self, error):
    # iterate backwards through the network layers
    for i in reversed(range(len(self.derivatives))):
           
        # get activation for previous layer
        activations = self.activations[i+1]
        zs = self.zs[i+1]
        
        # apply sigmoid derivative function - * denotes Hadamard product
        delta = error * self._sigmoid_derivative(zs)

        # get activations for current layer
        current_activations = self.activations[i]

        # save derivative after applying matrix multiplication
        self.derivatives[i] = np.dot(delta, current_activations.transpose())
        
        # backpropagate the next error
        error = np.dot(self.weights[i].transpose(), delta)

```


## Conclusion

These code chunks represent the core of the neural networks architecture. I have not emphasized gradient descent, which is a way to update the weights given the current weights and the derivatives. All the auxilary functions, including gradient descent, are included in the following chunk:


```python
def gradient_descent(self, learningRate=1):
    # update the weights by stepping down the gradient
    for i in range(len(self.weights)):
        weights = self.weights[i]
        derivatives = self.derivatives[i]
        weights += derivatives * learningRate

def _sigmoid(self, x):
    y = 1.0 / (1 + np.exp(-x))
    return y

def _sigmoid_derivative(self, x):
    return x * (1.0 - x)

def _mse(self, target, output):
    return np.average((target - output) ** 2)


def train(self, inputs, targets, epochs, learning_rate):
    # now enter the training loop
    for i in range(epochs):
        sum_errors = 0
            # iterate through all the training data
        for j, input in enumerate(inputs):
            target = targets[j]
                # activate the network!
            output = self.forward_propagate(input)
            error = target - output
            self.back_propagate(error)

            # now perform gradient descent on the derivatives
            # (this will update the weights
            self.gradient_descent(learning_rate)

            # keep track of the MSE for reporting later
            sum_errors += self._mse(target, output)

        # Epoch complete, report the training error
        print("Error: {} at epoch {}".format(sum_errors / len(items), i+1))

    print("Training complete!")
```

I hope all of this was useful, thanks for reading!


