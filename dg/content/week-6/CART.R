library(rpart)
library(randomForest)
library(gam)
library(Boruta)

data(stagec)
w <- as.data.frame(stagec[complete.cases(stagec),])
progstat <- factor(w$pgstat, levels = 0:1, labels = c("No", "Prog"))

set.seed(992)

cfit <- rpart(progstat ~ age + eet + g2 + grade + gleason + ploidy,
              data = w,
              method = 'class')
cfit

par(mar = rep(0.1, 4))
plot(cfit)
text(cfit)

fit9 <- prune(cfit, cp = 0.02)

printcp(cfit)
summary(cfit, cp = 0.06)


rf.c <- randomForest(progstat ~ g2 + grade + gleason + ploidy,
                     data = w,
                     classwt = c(1, 1),
                     na.action = na.gam.replace,
                     ntree = 500,
                     corr.bias = TRUE,
                     importance = TRUE,
                     do.trace = TRUE,
                     proximity = T,
                     nPerm=100)
rf.c
varImpPlot(rf.c)

bo.c <- Boruta(progstat ~ age + eet + g2 + grade + gleason + ploidy,
               data = w,
               doTrace = 2,
               ntree = 500)
bo.c
plot(bo.c)
plotImpHistory(bo.c)
