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

Based on the paper by ([Pfeffermann and Sverchkov](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.596.4915&rep=rep1&type=pdf), 1999) the informative sampling means
that we need to consider the design features in the model and without doing that our
estimators are biased. In this situation the distribution of population and sample are
different. So, in informative sampling, we need to account for sample selection effects. To
test the sampling ignorability, we can try

<a href="https://www.codecogs.com/eqnedit.php?latex=H_{0k}:&space;\textit{Corr}_s(\e_i^k,w_i)=0&space;\quad&space;k=1,2,..." target="_blank"><img src="https://latex.codecogs.com/gif.latex?H_{0k}:&space;\textit{Corr}_s(\e_i^k,w_i)=0&space;\quad&space;k=1,2,..." title="H_{0k}: \textit{Corr}_s(\epsilon_i^k,w_i)=0 \quad k=1,2,..." /></a>

where Corr is the correlation under the sample distribution and e comes from the model
that we consider for the y_i's as observations. In practice, usually testing the first 2 or 3
correlations suffices, but the authors mentioned that the good performance of statistic
associated to the first order correlation and employing the higher order of the residual
terms perform poorly and need more investigation.

They provided an example according to

<a href="https://www.codecogs.com/eqnedit.php?latex=y_i=1&plus;x_i&plus;\epsilon_i;&space;\quad&space;\epsilon_i&space;\sim&space;\mathcal{N}(0,1),&space;\quad&space;i=1,...,N" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_i=1&plus;x_i&plus;\epsilon_i;&space;\quad&space;\epsilon_i&space;\sim&space;\mathcal{N}(0,1),&space;\quad&space;i=1,...,N" title="y_i=1+x_i+\epsilon_i; \quad \epsilon_i \sim \mathcal{N}(0,1), \quad i=1,...,N" /></a>

with three different size variables:

<a href="https://www.codecogs.com/eqnedit.php?latex=[1]&space;z_i=\textit{exp}(-.1y_i-.08y_i^2&plus;.08x_i^2&plus;.3u_i)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?[1]&space;z_i=\textit{exp}(-.1y_i-.08y_i^2&plus;.08x_i^2&plus;.3u_i)" title="[1] z_i=\textit{exp}(-.1y_i-.08y_i^2+.08x_i^2+.3u_i)" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex=[2]&space;z_i=5&plus;5y_i&plus;3y_i^2&plus;10x_i&plus;3x_i^2&plus;u_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?[2]&space;z_i=5&plus;5y_i&plus;3y_i^2&plus;10x_i&plus;3x_i^2&plus;u_i" title="[2] z_i=5+5y_i+3y_i^2+10x_i+3x_i^2+u_i" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex=[3]&space;z_i=10x_i&plus;3x_i^2&plus;u_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?[3]&space;z_i=10x_i&plus;3x_i^2&plus;u_i" title="[3] z_i=10x_i+3x_i^2+u_i" /></a>

with u_i ~ U(0,1). The w_i = f(z_i) for the first two ones (1 & 2) are related to e_i. So,
the estimators based on (1 & 2) are not ignorable, and we need to consider the design
features in our estimators. In other words, the Corr NOT= 0 for the first two ones and the
Corr=0 for (3), which is non-informative (c.f., ([Pfeffermann and Sverchkov](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.596.4915&rep=rep1&type=pdf), 1999)).

#### A Short Illustration Based on the Chile National Socioeconomic Characterization Survey (Casen) Survey

Here, we illustrate the informative and non-informative sampling via the [Casen](http://ghdx.healthdata.org/record/chile-national-socioeconomic-characterization-survey-2009) 2009 survey,
which is publicly available. The Casen survey design is a stratified two stage sampling. The
strata are ESTRATO which is the combination of COMUNA and ZONA together. The
first stage sampling unit (or PSU) is SEGMENTO. The total number of PSUs is 4117. The
PSUs are selected with probability proportional to size measured in terms of the number
of occupied housing units. Finally, the second stage sampling unit (or SSU) is housing
unit which were selected with equal probability using a systematic sampling algorithm
with a random start within each selected PSU. Within each housing unit interviews were
attempted with all households (i.e. no subsampling was implemented beyond the selection
of the housing units). We consider different models at the national level for household frame
to see how the informative sampling works without considering any simulation study.

At the National Level (for CORTE v.):
In all of the following model, we study the relationship of the e from model with the weight
*EXPR*.


a) Model 1: 

<a href="https://www.codecogs.com/eqnedit.php?latex=y_{ij}=\alpha_i&plus;e_{ij}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_{ij}=\alpha_i&plus;e_{ij}" title="y_{ij}=\alpha_i+e_{ij}" /></a> 

where the first term is **SEGMENTO** random effect.

```
MixModel1 <- lmer(Ipoor ~ 1 + (1|SEGMENTO), HHFRAME)
t-test_1:-4.816267 ; corr_1:-0.01801419 ; P-value_1: 1.465679e-06
t-test_2:-7.09896 ; corr_2:-0.02654705 ; P-value_2: 1.268644e-12
```

b) Model 2:

<a href="https://www.codecogs.com/eqnedit.php?latex=y_{ijk}=\alpha_i&plus;\beta_{ij}&plus;e_{ijk}$&space;where&space;$\beta_{ij}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_{ijk}=\alpha_i&plus;\beta_{ij}&plus;e_{ijk}$&space;where&space;$\beta_{ij}" title="y_{ijk}=\alpha_i+\beta_{ij}+e_{ijk}$ where $\beta_{ij}" /></a>

where the second term is nested in i and both are random effects. The first term
is **ESTRATO** effect and the second term is **SEGMENTO** effect.

```
MixModel2 <- lmer(Ipoor~1+(1|ESTRATO/SEGMENTO),data=HHFRAME)
t-test_1:-2.154523 ; corr_1:-0.008059567 ; P-value_1:0.03120248
t-test_2:-6.876418 ; corr_2: -0.0257154 ; P-value_2:6.18781e-12
```

c) Model 3:

<a href="https://www.codecogs.com/eqnedit.php?latex=y_{ijk}=\alpha_i&plus;\beta_j&plus;e_{ijk}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_{ijk}=\alpha_i&plus;\beta_j&plus;e_{ijk}" title="y_{ijk}=\alpha_i+\beta_j+e_{ijk}" /></a>

where the first term is **ESTRATO** effect (fixed) and the second term is **SEGMENTO** effect (random).

```
MixModel3 <- lmer(Ipoor~ESTRATO+(1|SEGMENTO),data=HHFRAME)
t-test_1:-4.868832 ; corr_1:-0.01821073 ; P-value_1:1.124988e-06
t-test_2:-7.091298 ; corr_2: -0.02651841 ; P-value_2:1.340866e-12
```

d) Model 4:

<a href="https://www.codecogs.com/eqnedit.php?latex=y_{ijk}=\alpha_i&plus;\beta_j&plus;e_{ijk}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_{ijk}=\alpha_i&plus;\beta_j&plus;e_{ijk}" title="y_{ijk}=\alpha_i+\beta_j+e_{ijk}" /></a>

where the first term is **ESTRATO** effect (random) and the second term is **SEGMENTO** effect (random).

```
MixModel4 <- lmer(Ipoor~(1|ESTRATO)+(1|SEGMENTO),data=HHFRAME)
t-test_1:-2.154523 ; corr_1:-0.008059567 ; P-value_1:0.03120248
t-test_2:-6.876418 ; corr_2: -0.0257154 ; P-value_2:6.18781e-12
```

e) Model 5:

<a href="https://www.codecogs.com/eqnedit.php?latex=y_{ijk}=\alpha_i&plus;\beta_{ij}&plus;e_{ijk}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y_{ijk}=\alpha_i&plus;\beta_{ij}&plus;e_{ijk}" title="y_{ijk}=\alpha_i+\beta_{ij}+e_{ijk}" /></a>

where the first term is **ESTRATO** effect (fixed) and the second term is **SEGMENTO**
effect (random and nested in ESTRATO). we have a problem here since ESTRATO can be considered in both Random
effects and Fixed effects for the output.

```
MixModel5 <- lmer(Ipoor~ESTRATO+(1|ESTRATO/SEGMENTO),data=HHFRAME)
t-test_1:-2.216879 ; corr_1:-0.00829281 ; P-value_1:0.02663447
t-test_2:-6.872541 ; corr_2: -0.02570091 ; P-value_2:6.358293e-12
```

f) Model 6: 
**SEGMENTO** is random effect (Logistic Model)

```
MixModel6 <- glmer(Ipoor ~ 1 + (1 |SEGMENTO), HHFRAME,family = binomial)
t-test_1:-4.839996 ; corr_1:-0.01810291 ; P-value_1:1.301122e-06
t-test_2:-7.329264 ; corr_2: -0.02740765 ; P-value_2:2.338534e-13
```

Based on these data analysis, we can conclude:

1. When we put more features of the design in the model, the correlation between e_i
and w_i decreases.

2. By adding more random effects to the model, the correlation decreases as well.

### How to Model the Complex Survey Features in the Synthetic Data?

We need to think carefully about how to model the survey data for producing the synthetic data.
Many of the keys of sampling including stratification and multi-stages should be taken into
the model. Modeling of them is a challenge. However, survey statisticians usually do
not trust models. As Box said: "*All Models Are Wrong!!*". We might also have different
kinds of modeling:

- Superpopulation Modeling P(Y|\theta) where \theta is fixed,

- Bayesian Modeling: By considering a priori on \theta.

First we need to pay attention to which steps of complex survey are related to one another. For
example, if we have a design that sampling or design in each stratum is independent and
different, we might consider separate model for each stratum. Also as the synthesizer data
is a model-based approach, model checking is important. So, we can compare the first or
first and second order of moments from some variables based on the synthetic data set and
real data set.

We can produce models for survey data conditional on all sufficient statistics
of variables depending on which kind of function of parameters we are interested in. In
addition, considering weights in the model is another challenge. As weights are not simply
the inverse of inclusion probability and it contains other factors including non-response
adjustment, etc. Survey weights depend on the design weights and if we do not consider
design features in modeling, the results based on the model synthesizer is biased. Sometimes
putting interactions in the model might make the model more complicated but it can
explain some of the steps of design which are confounded. Inserting lots of parameters in
the model is not important; we rather should put some connections between the model
and the quantities of interest. Therefore, we should know how to put all of these in a
hierarchical way in the model. For example, a full hierarchical modeling approach should
be able to handle cluster sampling.

If in our modeling, we take large samples from the real population and conse-
quently take large samples from the produced synthetic populations and consider nonin-
formative or weakly flat prior distributions for the hyperparameters, results can be parallel
to those from the design-based inference perspective view of point. We refer to examples
1.1 and 2.1 in the case of stratified and post-stratified sampling in ([Little](https://journals.sagepub.com/doi/abs/10.1177/0008068320080301?casa_token=5CB57k2vLSwAAAAA:UBOLAyVo0NgukHF9WZeCEWHiBv8IkbHlE_xE4Q2_9EXueiPBxHPR7-E59bK_vno7j_jt_Hlxr2si_w), 2008). The
Bayesian approach can easily handle complex design features such as clustering through
random cluster models, and stratification through covariates. As a last advice, we need to
keep in mind that some synthetic data set might produce extreme estimates, which can be
handled by considering some constrains in the synthesizer model.
