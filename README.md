# Synthetic Data 

This is an R code for the model of synthetic data in general and handling the complex survey features in particular.

## Introduction to Appropriate Model for Producing the Synthetic Data

The idea of synthetic data is related to the multiple imputation. However, multiple imputation 
is related to multivariate distribution. Another easier approach instead of multiple
imputation is sequential regression multivariate imputation (SRMI) that some packages of
producing synthetic data including [synthpop](https://cran.r-project.org/web/packages/synthpop/index.html) in R 
is based on. The SRMI has the advantage of reducing the multivariate missing problem into the univariate missing 
problem for each variable, but we might have the problem of model misspecification. However, it
brings other felexibilities in the model including putting the interaction terms in the model,
logistic regression for the binary variable and so on.
Another disadvantage of SRMI is that it is a parametric method, and it might
be beneficial to think about a robust method which is not completely parametric such as
some semi-parametric methods. 

Another kind of modeling is using the penalized spline of propensity prediction, where
![\Large y_i|p^{*}_i(\psi),x_{i1},...,x_{ip};\psi,\beta,\phi,\sigma^2 \sim \mathcal{N}(spl(p^{*}_i(\psi),\beta)+g(p^*_i,x_{i2},...,x_{ip};\phi),\sigma^2)](https://latex.codecogs.com/svg.latex?x%3D%5Cfrac%7B-b%5Cpm%5Csqrt%7Bb%5E2-4ac%7D%7D%7B2a%7D)
