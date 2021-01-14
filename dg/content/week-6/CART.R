

library(rpart)
data(stagec)


cfit <- rpart(progstat ~ age + eet + g2 + grade + gleason + ploidy, data = stagec, method = 'class')
print(cfit)

par(mar = rep(0.1, 4))
plot(cfit)
text(cfit)

fit9 <- prune(cfit, cp = 0.02)

printcp(cfit)
summary(cfit, cp = 0.06)


library(randomForest)
library(gam)
rf.c<-randomForest(progstat ~ g2 + grade + gleason + ploidy, data=w,classwt=c(1,1), na.action=na.gam.replace,ntree=500,corr.bias=T,importance=T,do.trace=T,proximity=T,nPerm=100)
print(rf.c)
varImpPlot(rf.c)

library(Boruta)
set.seed(992)
w<-as.data.frame(stagec[complete.cases(stagec),])
progstat <- factor(w$pgstat, levels = 0:1, labels = c("No", "Prog"))
bo.c <- Boruta(progstat ~ age + eet + g2 + grade + gleason + ploidy, data=w, doTrace = 2, ntree = 500)
print(bo.c)
plot(bo.c)
plotImpHistory(bo.c);