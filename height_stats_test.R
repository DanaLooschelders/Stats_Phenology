#repeated measures anova for height data
#growth between cuts (before each cut, on a daily rate)
#growth rate between measurements
#if assumption of sphericty fails do two-way anova with overall growth rate instead
library(tidyverse)
library(MASS)
library(tseries)
setwd("C:/00 Dana/Uni/Internship/Work")
height=read.table("Plant Height Data Collection.csv", sep=";", dec=".", header=T)

growth=read.table("Plant_growth_before_1_cut.csv", sep=";", dec=".", header=T)
growth[growth<0]=NA
str(growth)
growth=cbind(height$Treatment, height$Variety, growth)
colnames(growth)=c("Treatment", "Variety", "One", "Two", "Three", "Four")
str(growth)

growth=read.table("Plant_height_before_1_cut.csv", sep=";", dec=".", header=T)
str(growth)
growth_tidy=cbind.data.frame(growth$Variety, growth$Treatment, growth$Growth_until_first_cut)
colnames(growth_tidy)=c("Variety", "Treatment", "Growth_rate")
mean(growth$Growth_until_first_cut)

#boxplot by treatment
par(mfrow=c(2,2))
boxplot(growth$Growth_until_first_cut[growth$Treatment=="CON"]~
          growth$Variety[growth$Treatment=="CON"],
        main="Growth CON", xlab="Variety", ylab="growth rate [cm/d]")
boxplot(growth$Growth_until_first_cut[growth$Treatment=="WAT"]~
        growth$Variety[growth$Treatment=="WAT"],
        main="Growth WAT", xlab="Variety", ylab="growth rate [cm/d]")
boxplot(growth$Growth_until_first_cut[growth$Treatment=="eCO2"]~
          growth$Variety[growth$Treatment=="eCO2"],
        main="Growth eCO2", xlab="Variety", ylab="growth rate [cm/d]")
boxplot(growth$Growth_until_first_cut[growth$Treatment=="eCO2W"]~
          growth$Variety[growth$Treatment=="eCO2W"],
        main="Growth eCO2W",xlab="Variety", ylab="growth rate [cm/d]")

growth$Growth_until_first_cut[growth$Growth_until_first_cut<0]=0

par(mfrow=c(2,2))
boxplot(growth$Growth_until_first_cut[growth$Treatment=="CON"]~
          growth$Variety[growth$Treatment=="CON"],
        main="Growth CON", xlab="Variety", ylab="growth rate [cm/d]")
boxplot(growth$Growth_until_first_cut[growth$Treatment=="WAT"]~
          growth$Variety[growth$Treatment=="WAT"],
        main="Growth WAT", xlab="Variety", ylab="growth rate [cm/d]")
boxplot(growth$Growth_until_first_cut[growth$Treatment=="eCO2"]~
          growth$Variety[growth$Treatment=="eCO2"],
        main="Growth eCO2", xlab="Variety", ylab="growth rate [cm/d]")
boxplot(growth$Growth_until_first_cut[growth$Treatment=="eCO2W"]~
          growth$Variety[growth$Treatment=="eCO2W"],
        main="Growth eCO2W",xlab="Variety", ylab="growth rate [cm/d]")

View(growth)
#Data exploration
labels=unique(growth_tidy$Variety)
boxplot(growth_tidy$Growth_rate~growth_tidy$Variety,
        main="Growth rate until first cut among varieties",
        ylab="Growth rate [cm/d]",
        xaxt = "n",  xlab = "")
# x axis with ticks but without labels
axis(1, labels = FALSE)
# Plot x labs at default x position
text(x=labels,y = par("usr")[1] - 0.25, srt = 45, adj = 1,
     labels = labels, xpd = TRUE)
boxplot(growth_tidy$Growth_rate~growth_tidy$Treatment)

#change structure of data frame for anova 
#get data frame with columns: Treatment, ID, Observation.No, Value
#each round measurement is numbered -> Observation.No
height_tidy=gather(data=df_test, observation.no, value, -Treatment, -ID, -Variety)
str(height_tidy)
growth=gather(data=growth, observation.no, value, -Treatment, -Variety)
str(growth_tidy)

#Assumptions for anova
  #continous dependent variable -> assumption is met
  #categorial independent variable -> assumption is met
  #no significant outliers -> 

  #normally distributed data 

  #sphericity (homogenity of variance?) -> most likley not met 

#two way anova
  #alpha is 0.05
  #normality
qqnorm(growth_tidy$Growth_rate)
qqline(growth_tidy$Growth_rate)
shapiro.test(growth_tidy$Growth_rate) #p value is 0.039
    #--> not normaly distributed
#independence -> can be assumed
#equality of variance 
#kruskal wallis test
kruskal.test(Growth_rate~Variety, growth_tidy) #p value 1.64*10^-14
kruskal.test(Growth_rate~Treatment, growth_tidy) #p-value 0.0081
interT.V=interaction(growth_tidy$Variety, growth_tidy$Treatment)
kruskal.test(Growth_rate~interT.V, growth_tidy) #p value 2.36*10^-8

#post hoc test
attach(growth_tidy)
posthoc.kruskal.nemenyi.test(x=Growth_rate, g=Treatment, dist="Chisquare")
posthoc.kruskal.nemenyi.test(x=Growth_rate, g=Variety, dist="Chisquare")
test=posthoc.kruskal.nemenyi.test(x=Growth_rate, g=interT.V, dist="Chisquare")

#further data exploration
hist(growth_tidy$Growth_rate)
#two way anova when normality is assumed based on the qqplot
#equality of variance
bartlett.test(Growth_rate~Treatment) #equality of variance cannot be assumed
bartlett.test(Growth_rate~Variety) #equality of variance can be assumed
bartlett.test(Growth_rate~interaction(Treatment, Variety)) #cannot be assumed
anov.height=aov(Growth_rate~Variety) #p avlue 1.09*10^-14 
summary(anov.height)

#t-test bewteen CON+WAT and eCO2+eCO2W
Growth_two=growth_tidy
Growth_two$Treatment[Growth_two$Treatment=="WAT"]="CON"
Growth_two$Treatment[Growth_two$Treatment=="eCO2W"]="eCO2"
Growth_two$Treatment=factor(Growth_two$Treatment)
str(Growth_two)
#data exploration
boxplot(Growth_two$Growth_rate~Growth_two$Treatment)
#t.test assumptions
  #normal distribiution
qqnorm(Growth_two$Growth_rate)
qqline(Growth_two$Growth_rate)
#--> can be assumed
  #equality of variance
bartlett.test(Growth_two$Growth_rate~Growth_two$Treatment)
#equality of variance cannot be assumed
#use welch test as normality can be assumed
t.test(Growth_two$Growth_rate~Growth_two$Treatment, var.equal = F)

lm.growth=lm(Growth_two$Growth_rate~Growth_two$Treatment*Growth_two$Variety)
plot(lm.growth)
boxcox(lm.growth)

