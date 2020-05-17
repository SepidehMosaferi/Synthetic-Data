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

<a href="https://www.codecogs.com/eqnedit.php?latex=y_i|p^{*}_i(\psi),x_{i1},...,x_{ip};\psi,\beta,\phi,\sigma^2&space;\sim&space;\mathcal{N}(spl(p^{*}_i(\psi),\beta)&plus;g(p^*_i,x_{i2},...,x_{ip};\phi),\sigma^2)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_i|p^{*}_i(\psi),x_{i1},...,x_{ip};\psi,\beta,\phi,\sigma^2&space;\sim&space;\mathcal{N}(spl(p^{*}_i(\psi),\beta)&plus;g(p^*_i,x_{i2},...,x_{ip};\phi),\sigma^2)" title="y_i|p^{*}_i(\psi),x_{i1},...,x_{ip};\psi,\beta,\phi,\sigma^2 \sim \mathcal{N}(spl(p^{*}_i(\psi),\beta)+g(p^*_i,x_{i2},...,x_{ip};\phi),\sigma^2)" /></a>
<a href="https://www.codecogs.com/eqnedit.php?latex=spl(p^{*}_i(\psi),\beta)=\beta_0&plus;\beta_1p^{*}_i(\psi)&plus;\sum_{k=1}^{K}\beta_{k&plus;1}(p^{*}_i(\psi)-\kappa_k)_{&plus;}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?spl(p^{*}_i(\psi),\beta)=\beta_0&plus;\beta_1p^{*}_i(\psi)&plus;\sum_{k=1}^{K}\beta_{k&plus;1}(p^{*}_i(\psi)-\kappa_k)_{&plus;}" title="spl(p^{*}_i(\psi),\beta)=\beta_0+\beta_1p^{*}_i(\psi)+\sum_{k=1}^{K}\beta_{k+1}(p^{*}_i(\psi)-\kappa_k)_{+}" /></a>

For more details we refer to ([Little](https://projecteuclid.org/euclid.ss/1312204002), 2011).


Generally speaking, a suitable model as a synthesizer is the key issue, and it
is important that we put the goals that we are interested in the model. For example,
if we have complex survey, we need to consider the stages related to the survey in the
model by considering suitable fixed and random effects in the model. If we want to use
the data set for the logistic regression purpose, we should provide a model in a way that
logistic regression be captured in the model. To illustrate it more, assume that we have a
dichotomous variable for the outcome, so the natural synthesizer could be Beta-binomial
distribution. To extend it to the categorical variable with different levels, we might use the
Dirichlet-multinomial synthesizer since this synthesizer can capture the dependencies
between cells of a contingency table if we coceptualize the categorical data in a multi-way
contingency table. In addition, as the cells are related, the natural prior for the multi-
dimensional probability of cells is Dirichlet distribution (a multivariate version of Beta
distribution) in the Synthetic modeling.


