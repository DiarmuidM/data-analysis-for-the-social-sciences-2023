# Week 11 - Multivariate Analysis - R Syntax #
#
# These are the R commands contained in the Week 11 notebook (Multivariate Data Analysis).
#
# Open this syntax file in RStudio or create your own file and copy-and-paste syntax as you need it.
#

bsa2019 <- read.table("https://raw.githubusercontent.com/DiarmuidM/data-analysis-for-the-social-sciences-2023/main/lessons/data/bsa2019_poverty_open.tab", header=TRUE, na="NA", sep="\t")
head(bsa2019) # view the first six observations

names(bsa2019)

bsa2019$welfare2[bsa2019$welfare2<1 | bsa2019$welfare2>5] <- NA # convert "-1" and "9" to missing

bsa2019$NatFrEst[bsa2019$NatFrEst>100] <- NA # convert "998" and "999" to missing

bsa2019$RSex <- factor(bsa2019$RSex, levels = c(1,2), labels = c("Male", "Female"))

bsa2019$RAgeCat <- factor(bsa2019$RAgeCat, levels = c(1,2,3,4,5,6,7), labels = c("18-24", "25-34", "35-44", "45-54", "55-59", "60-64", "65+"))

bsa2019$Married <- factor(bsa2019$Married, levels = c(1,2,3,4), labels = c("Married/living as married", 
                                                                               "Separated/divorced", 
                                                                               "Widowed", 
                                                                               "Never married"))

bsa2019$HEdQual3 <- factor(bsa2019$HEdQual3, levels = c(1,2,3,4), labels = c("Degree", "Below degree / A level", "O level", "No qual"))

summary(bsa2019$welfare2)

sd(bsa2019$welfare2, na.rm=TRUE)

hist(bsa2019$welfare2)

aggregate(welfare2 ~ RAgeCat, data = bsa2019, mean)

aggregate(welfare2 ~ RSex, data = bsa2019, mean)

aggregate(welfare2 ~ RAgeCat + RSex, data = bsa2019, mean)

bsa2019_18_24 <- bsa2019[bsa2019$RAgeCat=="18-24",]
bsa2019_25_34 <- bsa2019[bsa2019$RAgeCat=="25-34",]
bsa2019_35_44 <- bsa2019[bsa2019$RAgeCat=="35-44",]
bsa2019_45_54 <- bsa2019[bsa2019$RAgeCat=="45-54",]
bsa2019_55_59 <- bsa2019[bsa2019$RAgeCat=="55-59",]
bsa2019_60_64 <- bsa2019[bsa2019$RAgeCat=="60-64",]
bsa2019_65_over <- bsa2019[bsa2019$RAgeCat=="65+",]

install.packages("lsr") # install the necessary package - only needs to be done once

library(lsr) # import the package containing the `etaSquared()` command

model <- aov(welfare2 ~ RSex, data = bsa2019_18_24)
etaSquared(model)

model <- aov(welfare2 ~ RSex, data = bsa2019_25_34)
etaSquared(model)

model <- aov(welfare2 ~ RSex, data = bsa2019_35_44)
etaSquared(model)

model <- aov(welfare2 ~ RSex, data = bsa2019_45_54)
etaSquared(model)

model <- aov(welfare2 ~ RSex, data = bsa2019_55_59)
etaSquared(model)

model <- aov(welfare2 ~ RSex, data = bsa2019_60_64)
etaSquared(model)

model <- aov(welfare2 ~ RSex, data = bsa2019_65_over)
etaSquared(model)

plot(bsa2019$NatFrEst, bsa2019$welfare2) # X variable (axis) is listed first, Y variable (axis) second

cor(bsa2019$NatFrEst, bsa2019$welfare2, use = "complete.obs")

bsa2019_males <- bsa2019[bsa2019$RSex=="Male",] # create a dataset containing only males
bsa2019_females <- bsa2019[bsa2019$RSex=="Female",] # create a dataset containing only females

# create a figure with two plots
# set graphical parameters for a figure of one row, two columns
par(mfrow = c(1, 2))

plot(bsa2019_males$NatFrEst, bsa2019_males$welfare2)
plot(bsa2019_females$NatFrEst, bsa2019_females$welfare2) # X variable (axis) is listed first, Y variable (axis) second

cor(bsa2019_males$NatFrEst, bsa2019_males$welfare2, use = "complete.obs")
cor(bsa2019_females$NatFrEst, bsa2019_females$welfare2, use = "complete.obs")

round(prop.table(table(bsa2019$HEdQual3)) * 100, 0)

qual_age_table <- table(bsa2019$RAgeCat, bsa2019$HEdQual3)
round(prop.table(qual_age_table, 1)* 100, 0) # row percentages

qual_sex_table <- table(bsa2019$RSex, bsa2019$HEdQual3)
round(prop.table(qual_sex_table, 1)* 100, 0) # row percentages

qas_table <- table(bsa2019$RSex, bsa2019$RAgeCat, bsa2019$HEdQual3) # create crosstabulation - variable 1 is the control variable,
# variable 2 is the X (predictor) variable, variable 3 is the Y (outcome) variable.

qas_prop_table <- addmargins(prop.table(qas_table, c(1,2)), 3) # calculate proportions

qas_perc_table <- round(ftable(qas_prop_table) * 100, 0) # convert proportions to percentages

qas_perc_table # display table

install.packages("DescTools") # install the necessary package - only needs to be done once
library(DescTools) # import the package containing the `CramerV()` command

CramerV(bsa2019_males$HEdQual3, bsa2019_males$RAgeCat)
CramerV(bsa2019_females$HEdQual3, bsa2019_females$RAgeCat)
