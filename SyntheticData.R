#================================================================
## R code for the CASEN 2009 for the Synthetic Data
## Author: Sepideh Mosaferi, Spring 2016
#================================================================

require(stats) 
require(graphics)
library(plyr)
library(MASS)
library(lattice)
library(memisc)
library(stargazer)
library(foreign)
library(OpenMx)
library(PracTools)
library(sampling)
library(samplingbook)
library(survey)
library(reshape)
library(nlme)
library(ICC)
require(Rcpp)
library(lme4)
require(faraway)
require(psych)
require(synthpop)
require(stringi)
require(digest)

casendata2009 <- read.spss("Q://Casen 2009//Data 2009//Casen2009Spss.sav")
casendata2009 <- as.data.frame(casendata2009)

######## I) Complex Survey Study (Informative/Non-Informative) ##########

# sort dataset in a descending order of hierarchical geographical area pattern
SORTDATA <- casendata2009[order(casendata2009$REGION,casendata2009$COMUNA,
                                casendata2009$ESTRATO,casendata2009$SEGMENTO),]
SORTDATA <- as.data.frame(SORTDATA)
#Subsetting the Missing Part of dataset based on the CORTE
MISS <- subset(SORTDATA,is.na(SORTDATA$CORTE),
               select=c(SEGMENTO:ESTRATO,EDAD,SEXO,CORTE,YMONEHAJ,YAIMHAJ))
length(unique(MISS$FOLIO))
#Assessing Missing Situation
ASSMISS <- sapply(1:nrow(MISS),
                  function(i){SORTDATA$CORTE[SORTDATA$FOLIO==MISS$FOLIO[i]]})

#Hint: As we realized the situation of CORTE in hhs is missing;
#so, we substituted another observed person's
#CORTE code instead in the same hh
SUBSTITUTE <- sapply(1:length(ASSMISS),
function(i){ASSMISS[[i]][is.na(ASSMISS[[i]])] <- ASSMISS[[i]][1]})
SORTDATA$CORTE[is.na(SORTDATA$CORTE)] <- SUBSTITUTE
##unique housingunit identification
SORTDATA$HUID <- paste(SORTDATA$ESTRATO,
SORTDATA$SEGMENTO,SORTDATA$IDVIV,sep="")
SORDATAnew <- SORTDATA[order(SORTDATA$HUID),]
HHFRAME <- SORDATAnew[!duplicated(SORDATAnew$FOLIO),]
#Poor Indicator Variable (Ipoor indentification for household)

HHFRAME$Ipoor <- ifelse(HHFRAME$CORTE=="No pobre",0,1)
#### 1. Real Data Analysis (National Level)
## Model1) At the National Level
## yij=alpha_i+eij; alpha_i is SEGMENTO random effect
MixModel1 <- lmer(Ipoor ~ 1 + (1|SEGMENTO), HHFRAME)
COR11 <- cor.test(residuals(MixModel1),HHFRAME$EXPR)
COR12 <- cor.test((residuals(MixModel1)^2),HHFRAME$EXPR)
cor.test(HHFRAME$Ipoor,HHFRAME$EXPR)
COR11$statistic; COR11$estimate; COR11$p.value
COR12$statistic; COR12$estimate; COR12$p.value

## Model2) At the National Level
## yijk=alpha_i+beta_ij+eijk; beta_ij is nested in alpha_i (both are random)
## where alpha_i is ESTRATO effect & beta_ij is SEGMENTO effect
MixModel2 <- lmer(Ipoor~1+(1|ESTRATO/SEGMENTO),data=HHFRAME)
COR21 <- cor.test(residuals(MixModel2),HHFRAME$EXPR)
COR22 <- cor.test((residuals(MixModel2)^2),HHFRAME$EXPR)
cor.test(HHFRAME$Ipoor,HHFRAME$EXPR)
COR21$statistic; COR21$estimate; COR21$p.value
COR22$statistic; COR22$estimate; COR22$p.value

## Model3) At the National Level
## yijk=alpha_i+beta_j+eijk:
## alpha_i is ESTRATO effect (fixed) & beta_j is SEGMENTO effect (random)
MixModel3 <- lmer(Ipoor~ESTRATO+(1|SEGMENTO),data=HHFRAME)
COR31 <- cor.test(residuals(MixModel3),HHFRAME$EXPR)
COR32 <- cor.test((residuals(MixModel3)^2),HHFRAME$EXPR)
cor.test(HHFRAME$Ipoor,HHFRAME$EXPR)
COR31$statistic; COR31$estimate; COR31$p.value
COR32$statistic; COR32$estimate; COR32$p.value

## Model4) At the National Level
## yijk=alpha_i+beta_j+eijk:
## alpha_i is ESTRATO effect (random) & beta_j is SEGMENTO effect (random)
MixModel4 <- lmer(Ipoor~(1|ESTRATO)+(1|SEGMENTO),data=HHFRAME)
COR41 <- cor.test(residuals(MixModel4),HHFRAME$EXPR)
COR42 <- cor.test((residuals(MixModel4)^2),HHFRAME$EXPR)
cor.test(HHFRAME$Ipoor,HHFRAME$EXPR)
COR41$statistic; COR41$estimate; COR41$p.value
COR42$statistic; COR42$estimate; COR42$p.value

## Model5) At the National Level
## yijk=alpha_i+beta_ij+eijk:
## alpha_i is ESTRATO effect (fixed) & beta_ij is SEGMENTO effect
## (random & nested in ESTRATO)
## BUT we have a problem here since ESTRATO can be
## considered in both Random effects and
## Fixed effects for the output.
MixModel5 <- lmer(Ipoor~ESTRATO+(1|ESTRATO/SEGMENTO),data=HHFRAME)
COR51 <- cor.test(residuals(MixModel5),HHFRAME$EXPR)
COR52 <- cor.test((residuals(MixModel5)^2),HHFRAME$EXPR)
cor.test(HHFRAME$Ipoor,HHFRAME$EXPR)
COR51$statistic; COR51$estimate; COR51$p.value
COR52$statistic; COR52$estimate; COR52$p.value

## Model6) At the National Level; SEGMENTO is random effect (Logistic Model)
MixModel6 <- glmer(Ipoor ~ 1 + (1 |SEGMENTO), HHFRAME,family = binomial)
COR61 <- cor.test(residuals(MixModel6),HHFRAME$EXPR)
COR62 <- cor.test((residuals(MixModel6)^2),HHFRAME$EXPR)
cor.test(HHFRAME$Ipoor,HHFRAME$EXPR)
COR61$statistic; COR61$estimate; COR61$p.value
COR62$statistic; COR62$estimate; COR62$p.value

################ II) Synthetic Data Study ######################
  ##Subset of Data that we are interested in
SubDATA <- casendata2009[,c("YTOTHAJ","SEXO","EDAD",
                            "NUMPER","CORTE","ASISTE")]

    ##Producing 5 Synthetic Data using Parametric Method 
synthPOP <- syn(SubDATA, method="parametric",m = 5)

########### 1. Comparing univariate distributions of synthesised and observed data ############

compare(synthPOP,SubDATA, vars = c("EDAD","SEXO","CORTE","NUMPER"))


Xtot <- rbind(data.frame(SubDATA,syn=FALSE),data.frame(synthPOP,syn=TRUE))
aggregate(Xtot$YTOTHAJ,by=list(Xtot$syn),mean)

ggplot() + geom_density(aes(x=YTOTHAJ,fill=syn), alpha
                                 = .3, data=Xtot)+scale_x_log10()

############### 2. Model Fitting Study #####################
    #Fitting Model to the Synthetic Data
FitSynth <- lm.synds(log(YTOTHAJ+1)~factor(SEXO)+EDAD+ factor(NUMPER)+
                        factor(CORTE)+factor(ASISTE),
                     data=synthPOP)

summary(FitSynth,population.inference = TRUE)

compare(FitSynth,SubDATA)
compare(FitSynth,SubDATA, plot = "coef")


############### 3. Fitting the same Model to real Data and Comparison Study ###########

FitReal <- lm(log(YTOTHAJ+1)~factor(SEXO)+EDAD+ factor(NUMPER)+
                       factor(CORTE)+factor(ASISTE),
                     data=SubDATA)
summary(FitReal)


FitSynth$mcoefavg
FitReal$coefficients

############## 4. Study the Utility of Synthetic Data ####################

###Distributional comparison of synthesised and observed data using
###propensity score matching:

utility.synds(synthPOP,SubDATA,null.utility=TRUE)


############### 5. Study Disclosure Risk of Synthetic Data ##############

M <- cbind(synthPOP$syn[[1]]$YTOTHAJ,
           synthPOP$syn[[2]]$YTOTHAJ,
           synthPOP$syn[[3]]$YTOTHAJ,
           synthPOP$syn[[4]]$YTOTHAJ,
           synthPOP$syn[[5]]$YTOTHAJ,
           SubDATA$YTOTHAJ)

cor(M[,1],M[,6]);cor(M[,2],M[,6]);cor(M[,3],M[,6])
cor(M[,4],M[,6]);cor(M[,5],M[,6])
par(mfrow=c(2,3))
plot(M[,1],M[,6],ylab="Real Data",xlab="Synthetic Data[1]")
plot(M[,2],M[,6],ylab="Real Data",xlab="Synthetic Data[2]")
plot(M[,3],M[,6],ylab="Real Data",xlab="Synthetic Data[3]")
plot(M[,4],M[,6],ylab="Real Data",xlab="Synthetic Data[4]")
plot(M[,5],M[,6],ylab="Real Data",xlab="Synthetic Data[5]")

M1 <- cbind(M[,1],M[,6])
S1 <- var(M1)
MahDist1 <- mahalanobis(M1,colMeans(M1),S1)

M2 <- cbind(M[,2],M[,6])
S2 <- var(M2)
MahDist2 <- mahalanobis(M2,colMeans(M2),S2)

M3 <- cbind(M[,3],M[,6])
S3 <- var(M3)
MahDist3 <- mahalanobis(M3,colMeans(M3),S3)

M4 <- cbind(M[,4],M[,6])
S4 <- var(M4)
MahDist4 <- mahalanobis(M4,colMeans(M4),S4)

M5 <- cbind(M[,5],M[,6])
S5 <- var(M5)
MahDist5 <- mahalanobis(M5,colMeans(M5),S5)

dev.off()
    ##Q-Q plot
par(mfrow=c(2,3))
qqplot(qchisq(ppoints(nrow(M1)), df = 2), MahDist1,
       main = expression("Mahalanobis" * ~D^2 *
                           " vs. quantiles of" * ~ chi[2]^2))

qqplot(qchisq(ppoints(nrow(M2)), df = 2), MahDist2,
       main = expression("Mahalanobis" * ~D^2 *
                           " vs. quantiles of" * ~ chi[2]^2))

qqplot(qchisq(ppoints(nrow(M3)), df = 2), MahDist3,
       main = expression("Mahalanobis" * ~D^2 *
                           " vs. quantiles of" * ~ chi[2]^2))

qqplot(qchisq(ppoints(nrow(M4)), df = 2), MahDist4,
       main = expression("Mahalanobis" * ~D^2 *
                           " vs. quantiles of" * ~ chi[2]^2))

qqplot(qchisq(ppoints(nrow(M5)), df = 2), MahDist5,
       main = expression("Mahalanobis" * ~D^2 *
                           " vs. quantiles of" * ~ chi[2]^2))


