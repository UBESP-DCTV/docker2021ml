#################################################################
## Example taken from http://www.clinicalpredictionmodels.org/ ##
#################################################################

library(rms)
options(datadist = "dd")

library(mice)
library(foreign)
library(VIM)


TBI <- read.spss('TBI.sav',
  use.value.labels = FALSE,
  to.data.frame = TRUE
)

describe(TBI)

TBI$pupil <- ifelse(TBI$d.pupil == 9, NA, TBI$d.pupil)

## Missing value analysis
par(mfrow = c(1, 1))

na.patterns <- naclus(TBI)
plot(na.patterns, ylab = "Fraction of NAs in common")

aggr <- aggr(TBI,
  col = mdc(1), numbers = TRUE, sortVars = TRUE, labels = names(TBI),
  cex.axis = 0.7, gap = 2,
  ylab = c("Proportion of missingness", "Missingness Pattern"),
  combined = FALSE
)

# Motor in 5 categories: 1/2; 3; 4; 5/6; 9/NA
TBI$motor	<- ifelse(is.na(TBI$d.motor),9,TBI$d.motor)
TBI$motor1	<- ifelse(TBI$motor==1,1,0)
TBI$motor2	<- ifelse(TBI$motor==2,1,0)
TBI$motor3      <- ifelse(TBI$motor==3,1,0)
TBI$motor4  	<- ifelse(TBI$motor==4,1,0)
TBI$motor56	<- ifelse(TBI$motor==5 | TBI$motor==6,1,0)
TBI$motor9	<- ifelse(TBI$motor==9,1,0)
TBI$motorG	<- ifelse(TBI$motor1==1,5,
                     ifelse(TBI$motor2==1,4,
                            ifelse(TBI$motor3==1,3,
                                   ifelse(TBI$motor4==1,2,
                                          ifelse(TBI$motor56==1,1,
                                                 ifelse(TBI$motor9==1,9,NA))))))
TBI$motorG	<- as.factor(TBI$motorG)


# levels(TBI$motorG)	<- c("5/6", "4", "3", "2", "1", "9")

# mort and unfav outcome
TBI$mort    <- ifelse(TBI$d.gos==1,1,ifelse(TBI$d.gos==6,NA,0))
TBI$deadveg <- ifelse(TBI$d.gos<3,1,ifelse(TBI$d.gos==6,NA,0))
TBI$unfav   <- ifelse(TBI$d.gos<4,1,ifelse(TBI$d.gos==6,NA,0))
TBI$good    <- ifelse(TBI$d.gos<5,1,ifelse(TBI$d.gos==6,NA,0))

TBI$ctclass2  <- ifelse(TBI$ctclass==2,1,0)
TBI$ctclass1  <- ifelse(TBI$ctclass==1,1,0)
TBI$ctclass34 <- ifelse(TBI$ctclass==3 | TBI$ctclass==4,1,0)
TBI$ctclass56 <- ifelse(TBI$ctclass==5 | TBI$ctclass==6,1,0)
TBI$ctclassr4 <- ifelse(TBI$ctclass1==1,2,
                        ifelse(TBI$ctclass2==1,1,
                               ifelse(TBI$ctclass34==1,3,
                                      ifelse(TBI$ctclass56==1,4,NA))))

TBI$ctclassr4	<- as.factor(TBI$ctclassr4)
TBI$ctclassr3   <- ifelse(TBI$ctclass1==1 | TBI$ctclass2==1,1,
                          ifelse(TBI$ctclass34==1,2,
                                 ifelse(TBI$ctclass56==1,3,NA)))
TBI$ctclassr4	<- as.factor(TBI$ctclassr4)
TBI$ctclassr3	<- as.factor(TBI$ctclassr3)

TBI1	<- TBI[,Cs(trial, age, hypoxia, hypotens, cisterns, shift,
                tsah, edh, pupil, motorG, ctclassr3,
                d.sysbpt,hbt,glucoset, unfav, mort	)]
TBI1$trial<-as.numeric(TBI1$trial)
TBI1$trial<-as.factor(TBI1$trial)
TBI1$pupil<-as.factor(TBI1$pupil)

names(TBI1) <- Cs(trial, age, hypoxia, hypotens, cisterns, shift,
                  tsah, edh, pupil, motor, ctclass,
                  d.sysbp,hb,glucose, unfav, mort	)
label(TBI1$unfav) <- "GOS6 unfav"


TBI1$Age30  <- ifelse(TBI1$age<30,1,0)
TBI1$cisterns <- ifelse(TBI1$cisterns>1,1,0)
TBI1$pupil<-as.factor(TBI1$pupil)


dd <- datadist(TBI1)
describe(TBI1)

##########################

## Correlation matrix
mat=matrix(0,nrow=dim(TBI1)[2]-3,ncol=dim(TBI1)[2]-3,dimnames=list(names(TBI1)[1:14],names(TBI1)[1:14]))
for (i in 2:14) {
    for (j in 1:14) {
mat[1,j]= round(spearman2(TBI1[,1],TBI1[,j])[1],2)
mat[i,j]=round(spearman(TBI1[,i],TBI1[,j])[1],2)
                          }
}

#### Imputation
### define the matrix pmat for mice   predictorMatrix  A value of '1' means that the column variable is used as a predictor for the target variable (in the rows). The diagonal of 'predictorMatrix' must be zero. In our matrix we don't want 'trial', 'age', 'motor', 'unfav' and 'mort' to be imputed.

dim(TBI1)
TBI1  <- TBI1[, -17]
names(TBI1)

p<-16
pmat  <- matrix(rep(1,p*p),nrow=p,ncol=p,dimnames=list(names(TBI1),names(TBI1)))
diag(pmat)  <- rep(0,p)
pmat[,c(1:2, 10, 15:16)]  <- 0
pmat[ c(1:2, 10, 15:16),] <- 0

## defines data to be used and the imputation method for each column, seed =1
gm <- mice(TBI1, m=5,maxit=5,
           imputationMethod =c("logreg","pmm","logreg","logreg", "logreg","logreg",
                               "logreg","logreg","polyreg","polyreg","polyreg","pmm",
                               "pmm", "pmm","logreg","logreg"),
           predictorMatrix = pmat, seed=1)
gm

## Some diagnostics
densityplot(x = gm,data = ~ hb)
densityplot(x = gm,layout = c(2, 4))

## Adjusted analyses
## MI, n  = 2159

a <- with(gm,
  glm(unfav ~ trial + age + hypoxia + hypotens + tsah + pupil
              + motor + ctclass,
    family = binomial()
  )
)

summary(a)
pool(a)

fit.mult.impute(
  unfav ~ trial + age + hypoxia + hypotens + tsah + pupil
          + motor + ctclass,
  glm, family = binomial(),
  xtrans = gm,
  data = TBI1
)

## pupils original, imputation for other covars, n=2036
TBI2  <- TBI1[!is.na(TBI1$pupil),]
dim(TBI2) # n=2036
fit.mult.impute(
  unfav ~ trial + age + motor + pupil + hypoxia + hypotens
          + ctclass + tsah,
  glm, family = binomial(),
  xtrans = gm,
  data = TBI2
)

# MICE SI, n  = 2159
glm(
  unfav ~  age + motor + pupil + hypoxia + hypotens
             + ctclass + tsah,
  data = complete(gm, 1),
  family = binomial()
)

gm1 <- complete(gm, action = 1)

