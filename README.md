# Synthetic Data 
Author: Sepideh Mosaferi (Spring, 2016)

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

For more details we refer to ([Little,2011])(https://projecteuclid.org/euclid.ss/1312204002).


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


Developing a good model is a huge challenge specifically when we want to use the
Bayesian paradigm as our model might suffer from the model misspecification and
considering a vague prior which does not lead to an improper posterior is another part of
the challenge.
We have realized so far, producing an effective model is important. This might
again brings some struggles among model-based practitioners and design-based ones and
frequentists and Bayesians in particular. Bayesian approaches can be more applicable and
straightforward for inference and producing model. On the other hand, it is clear to every
one that frequentists' evaluation techniques such as unbiasedness and Rao-Blackwellization,
and so on are more powerful for improving the models. During the recent decades, an idea
of Calibrated Bayes emerged by some statisticians including Rubin and Little as the first
pioneers to combine the idea of Bayes and frequentists in a way that model be based on
the Bayes and developing be based on the frequentist.


As another example, it is good that we use hierarchical Bayes for modeling specifically for 
longitudinal data set with different waves that each level of hierarchical model
might be explained a specific wave of the data set instead of considering some pure frequentist 
modeling such as log-linear model and estimating its parameters via MLE. Because in the HB and MCMC, 
we can directly and automatically consider all possibilities of uncertainties of parameters in the model. 
But, we can use Rao-Blackwellization theorem to improve our model by conditioning the outcome of the model 
on the observed sufficient statistic without providing it to the data intruder to reduce the variation of the 
synthesized data set.


To further evaluate the model, it is not appropriate to consider the posterior
predictive p-value to see whether the synthetic model holds or not as this p-value suffers
from the double use of the data set. So, in order to see whether the synthetic model fits
the observed real data, it is better that we directly look at the residuals.
If we put all fixed-effects in the model, the utility of synthetic data is 100%; on
the other hand, putting random effects in the model brings some uncertainty to the model
and decrease the utility. The United Sates Census Bureau does not provide the model for
the SAIPE released synthetic data set. This might put a question mark on their model in
a way that if there are many fixed effects in the model, then of-course the disclosure risk
would be high and it might be easy for a data intruder to detect the real data.


When we start to put randomization in the model, we diverge from the observed
values (truth) and we can inject noises to the model. Otherwsie, if we just have fixed effects
in the model, there might not be any problems. In other words, by putting random effects
in the model, we are able to mask the real data or to protect each person or individual
identification. As a result this makes the utility of data set decreases. A good model can
effectively mask the truth and analysis based on the produced data under the model is
appropriate.
To improve the inference based on the model, we can release some true summeries from the real 
data set without jeopardizing the confidentiality such as providing the
marginals or the mean and the variance for continuous or discrete data set.

## Complex Survey and Its Features

The first feature to define a complex sample is that the population members do
not receive an equal probability of selection. Surveys usually involve combination of different
stages as sometimes we might not have the list of units or some auxiliary variables are
available and bring the situation of stratification. Therefore, a survey might be stratified
with several stages of clustering to make the probability of inclusion and as a consequence
the survey weighting more complicated.


When we would like to make a decision about the effects of clustering, stratification, etc.
we can benefit from the design effect (Deff) defined by the var(.)complex-design/var(.)srs and 
its square root is the design factor. The other feature that should be always kept in mind is 
the kind of estimator that we are looking such as the ratio estimator, regression estimator, etc. 
This brings another layer of complication in surveys. Therefore, when we want to produce a model 
for creating the synthetic data set we need to satisfy these features of complex design and many others 
that are related to our goals.

### Informative and Non-Informative Sampling

Based on the paper by ([Pfeffermann and Sverchkov,1999])(http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.596.4915&rep=rep1&type=pdf), the informative sampling means
that we need to consider the design features in the model and without doing that our
estimators are biased. In this situation the distribution of population and sample are
different. So, in informative sampling, we need to account for sample selection effects. To
test the sampling ignorability, we can try
