# Week 11 - Inferential Analysis - R Syntax #
#
# These are the R commands contained in the Week 11 notebook (Inferential Analysis).
#
# Open this syntax file in RStudio or create your own file and copy-and-paste syntax as you need it.
#

bsa2019 <- read.table("https://raw.githubusercontent.com/DiarmuidM/data-analysis-for-the-social-sciences-2023/main/lessons/data/bsa2019_poverty_open.tab", header=TRUE, na="NA", sep="\t")
head(bsa2019) # view the first six observations

nrow(bsa2019) # number of rows (observations) in the dataset

bsa2019$welfare2[bsa2019$welfare2<1 | bsa2019$welfare2>5] <- NA # convert "-1" and "9" to missing

bsa2019$NatFrEst[bsa2019$NatFrEst>100] <- NA # convert "998" and "999" to missing

bsa2019$RSex <- factor(bsa2019$RSex, levels = c(1,2), labels = c("Male", "Female"))

bsa2019$RAgeCat <- factor(bsa2019$RAgeCat, levels = c(1,2,3,4,5,6,7), labels = c("18-24", "25-34", "35-44", "45-54", "55-59", "60-64", "65+"))

bsa2019$Married <- factor(bsa2019$Married, levels = c(1,2,3,4), labels = c("Married/living as married", 
                                                                               "Separated/divorced", 
                                                                               "Widowed", 
                                                                               "Never married"))

bsa2019$HEdQual3 <- factor(bsa2019$HEdQual3, levels = c(1,2,3,4), labels = c("Degree", "Below degree / A level", "O level", "No qual"))

summary(bsa2019$NatFrEst)

t.test(bsa2019$NatFrEst, na.rm = TRUE)$conf.int # calculate 95% confidence intervals for the mean of `NatFrEst`

mean(bsa2019$welfare2, na.rm = TRUE)

t.test(bsa2019$welfare2, na.rm = TRUE)$conf.int # calculate 95% confidence intervals for the mean of `welfare2`

round(prop.table(table(bsa2019$HEdQual3)) * 100, 0)

install.packages("DescTools") # install the necessary package - only needs to be done once

library(DescTools) # import the package containing the `MultinomCI` command

MultinomCI(table(bsa2019$HEdQual3)) # 95% confidence interval is the default

CramerV(bsa2019$RSex, bsa2019$Married)

CramerV(bsa2019$RSex, bsa2019$Married)

options(scipen=999) # suppress scientific notation
chisq.test(bsa2019$RSex, bsa2019$Married)

bsa2019_samp <- bsa2019[sample(nrow(bsa2019), 100), ] # randomly sample 100 observations from the dataset

CramerV(bsa2019_samp$RSex, bsa2019_samp$Married)

options(scipen=999) # suppress scientific notation
chisq.test(bsa2019_samp$RSex, bsa2019_samp$Married)

install.packages("lsr") # install the necessary package - only needs to be done once

library(lsr) # import the package containing the `etaSquared()` command

model <- aov(welfare2 ~ RAgeCat, data = bsa2019)
etaSquared(model)

summary(model)

plot(bsa2019$NatFrEst, bsa2019$welfare2) # X variable (axis) is listed first, Y variable (axis) second

cor(bsa2019$NatFrEst, bsa2019$welfare2, use = "complete.obs")

cor.test(bsa2019$NatFrEst, bsa2019$welfare2, use = "complete.obs")
