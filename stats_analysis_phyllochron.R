#stats analysis phyllochron 1-2
#stats analysis phyllochron 1-3
#by Dana Looschelders
library(agricolae)
library(PMCMRplus)
library(PMCMR)
library(tidyverse)
library(MASS)

setwd("C:/00 Dana/Uni/Internship/Work")
dat=read.table("Phyllochron.csv", sep=";", dec=" ", header=T)
names(dat)=c("ID", "Variety", "Treatment", "Chamber", "Phyllo12", "Phyllo13", "Phyllo14", "Phyllo23", "Phyllo24", "Phyllo34", "Phyllo1S", "Type")
str(dat)
phyllo=cbind.data.frame("Variety"=dat$Variety, 
                        "Treatment"=dat$Treatment, 
                        "Phyllochron"=dat$Phyllo12,
                        "type"=dat$Type)
str(phyllo)

#write Master Table with signficance results (only kruskal, not posthoc)
master_stats=data.frame(names(dat[,5:11]), "sig_treatment"=NA, "sig_Variety"=NA, "sig_type"=NA)
master_stats=master_stats[-7,]
#data exploration
boxplot(phyllo$Phyllochron~phyllo$type,
        main="Phyllochron 1-2 among types", 
        xlab="Treatment", ylab="Phyllochron [d]")
boxplot(phyllo$Phyllochron~phyllo$Treatment, 
        main="Phyllochron 1-2 among Treatments", 
        xlab="Treatment", ylab="Phyllochron [d]")
boxplot(phyllo$Phyllochron~phyllo$Variety)

#test for normality
qqnorm(phyllo$Phyllochron)
qqline(phyllo$Phyllochron)
shapiro.test(phyllo$Phyllochron) #p-value is 8.838*10^-7
#data is not normally distributed
#use kruskal test
kruskal.test(phyllo$Phyllochron~phyllo$type) #p-value = 0.02205
master_stats$sig_type[master_stats$names.dat...5.11..=="Phyllo12"]=0.02205
kruskal.test(phyllo$Phyllochron~phyllo$Variety) #p-value = 2.181e-06
master_stats$sig_Variety[master_stats$names.dat...5.11..=="Phyllo12"]=2.18e-06
kruskal.test(phyllo$Phyllochron~phyllo$Treatment) #p-value = 0.03885
master_stats$sig_treatment[master_stats$names.dat...5.11..=="Phyllo12"]=0.0389

#posthoc test
posthoc.kruskal.nemenyi.test(phyllo$Phyllochron~phyllo$type, dist="Chisquare")
posthoc.kruskal.nemenyi.test(phyllo$Phyllochron~phyllo$Treatment, dist="Chisquare") #no significance
posthoc.kruskal.nemenyi.test(phyllo$Phyllochron~phyllo$Variety, dist="Chisquare")

#glm
phyllo_glm=glm(phyllo$Phyllochron~phyllo$type+phyllo$Treatment+phyllo$Variety) 
summary(phyllo_glm)
plot(phyllo_glm)
#glm
glm(phyllo$Phyllochron~phyllo$type)
#*******************************************************************************************************
#phyllochron 1-3
phyllo13=cbind.data.frame("Variety"=dat$Variety, 
                        "Treatment"=dat$Treatment, 
                        "Phyllochron"=dat$Phyllochron.1.3,
                        "type"=dat$type)
str(phyllo13)

#data exploration
hist(phyllo13$Phyllochron)
boxplot(phyllo13$Phyllochron~phyllo13$Treatment)
boxplot(phyllo13$Phyllochron~phyllo13$Variety)
boxplot(phyllo13$Phyllochron~phyllo13$type)

#test assumptions
qqnorm(phyllo13$Phyllochron)
qqline(phyllo13$Phyllochron)
shapiro.test(phyllo13$Phyllochron) #not normally distributed p-value: 0.00013

#kruskal test
kruskal.test(phyllo13$Phyllochron~phyllo13$Variety) #significant: p value 1.664e-06
master_stats$sig_type[master_stats$names.dat...5.11..=="Phyllo13"]=1.66e-06
kruskal.test(phyllo13$Phyllochron~phyllo13$Treatment) #significant: p value 0.0005
master_stats$sig_Variety[master_stats$names.dat...5.11..=="Phyllo13"]=0.0005
kruskal.test(phyllo13$Phyllochron~phyllo13$type) ##significant: p-value = 0.02428
master_stats$sig_treatment[master_stats$names.dat...5.11..=="Phyllo13"]=0.02428
#posthoc tests
posthoc.kruskal.nemenyi.test(phyllo13$Phyllochron~phyllo13$Variety, dist="Chisquare")
posthoc.kruskal.nemenyi.test(phyllo13$Phyllochron~phyllo13$Treatment, dist="Chisquare")
posthoc.kruskal.nemenyi.test(phyllo13$Phyllochron~phyllo13$type, dist="Chisquare")

#fit a glm
summary(glm(phyllo13$Phyllochron~phyllo13$Treatment*phyllo13$Variety))

#try a boxcox transformation
test.lm=lm(phyllo13$Phyllochron~phyllo13$Treatment*phyllo13$Variety)
plot(test.lm)
bc=boxcox(test.lm)

#phyllochron 2-3
hist(dat$Phyllo23)
boxplot(dat$Phyllo23~dat$Variety)
boxplot(dat$Phyllo23~dat$Treatment)
boxplot(dat$Phyllo23~dat$Type)
#test for normality
qqnorm(dat$Phyllo23)
qqline(dat$Phyllo23)
shapiro.test(dat$Phyllo23)
#not normally distributed

kruskal.test(dat$Phyllo23~dat$Variety) #not significant
kruskal.test(dat$Phyllo23~dat$Treatment) #barely significant
kruskal.test(dat$Phyllo23~dat$Type) #not significant
master_stats$sig_treatment[master_stats$names.dat...5.11..=="Phyllo23"]=0.0469
master_stats$sig_Variety[master_stats$names.dat...5.11..=="Phyllo23"]="NOT"
master_stats$sig_type[master_stats$names.dat...5.11..=="Phyllo23"]="NOT"


posthoc.kruskal.nemenyi.test(dat$Phyllo23~dat$Treatment) #no significane

#phyllo 34
hist(dat$Phyllo34)
boxplot(dat$Phyllo34~dat$Variety)
boxplot(dat$Phyllo34~dat$Treatment)
boxplot(dat$Phyllo34~dat$Type)

qqnorm(dat$Phyllo34)
qqline(dat$Phyllo34)
shapiro.test(dat$Phyllo34)

kruskal.test(dat$Phyllo34~dat$Variety) #significant
kruskal.test(dat$Phyllo34~dat$Treatment) #not significant
kruskal.test(dat$Phyllo34~dat$Type) #not significant
master_stats$sig_treatment[master_stats$names.dat...5.11..=="Phyllo34"]="NOT"
master_stats$sig_Variety[master_stats$names.dat...5.11..=="Phyllo34"]=0.0117
master_stats$sig_type[master_stats$names.dat...5.11..=="Phyllo34"]="NOT"

#pyhllo 14
hist(dat$Phyllo14)
boxplot(dat$Phyllo14~dat$Variety)
boxplot(dat$Phyllo14~dat$Treatment)
boxplot(dat$Phyllo14~dat$Type)

qqnorm(dat$Phyllo14)
qqline(dat$Phyllo14)
shapiro.test(dat$Phyllo14) #not normally distributed

kruskal.test(dat$Phyllo14~dat$Variety) #significant 4.29e-06
kruskal.test(dat$Phyllo14~dat$Treatment) #not significant
kruskal.test(dat$Phyllo14~dat$Type) #not significant
master_stats$sig_treatment[master_stats$names.dat...5.11..=="Phyllo14"]="NOT"
master_stats$sig_Variety[master_stats$names.dat...5.11..=="Phyllo14"]=4.29e-06
master_stats$sig_type[master_stats$names.dat...5.11..=="Phyllo14"]="NOT"

#phyllo 24
hist(dat$Phyllo24)
boxplot(dat$Phyllo24~dat$Variety)
boxplot(dat$Phyllo24~dat$Treatment)
boxplot(dat$Phyllo24~dat$Type)

qqnorm(dat$Phyllo24)
qqline(dat$Phyllo24)
shapiro.test(dat$Phyllo24) #not normally distributed

kruskal.test(dat$Phyllo24~dat$Variety) #significant
kruskal.test(dat$Phyllo24~dat$Treatment) #not significant
kruskal.test(dat$Phyllo24~dat$Type) #not significant
master_stats$sig_treatment[master_stats$names.dat...5.11..=="Phyllo24"]="NOT"
master_stats$sig_Variety[master_stats$names.dat...5.11..=="Phyllo24"]=0.00144
master_stats$sig_type[master_stats$names.dat...5.11..=="Phyllo24"]="NOT"

write.csv(x=master_stats, file="master_stats.csv")
#write master table to aggregate data for all phyllochrons
agg_data_mean=aggregate(cbind(Phyllo12, Phyllo13, Phyllo14, Phyllo23, Phyllo24, Phyllo34)~Variety+Treatment, data=dat, FUN =mean)
agg_data_sd=aggregate(cbind(Phyllo12, Phyllo13, Phyllo14, Phyllo23, Phyllo24, Phyllo34)~Variety+Treatment, data=dat, FUN =sd)
names=names(agg_data_sd)
names_new=paste("sd_",names)
names(agg_data_sd)=names_new
names2=names(agg_data_mean)
names(agg_data_mean)=paste("mean_",names2)
agg_data=cbind(agg_data_mean, agg_data_sd)
str(agg_data)
agg_data=agg_data[,-9]
agg_data=agg_data[,-9]
str(agg_data)
plot(agg_data$Variety[agg_data$Treatment=="CON"], agg_data$Phyllo12[agg_data$Treatment=="CON"],"l")
summary(agg_data)
write.csv(agg_data, file="agg_data.csv")

