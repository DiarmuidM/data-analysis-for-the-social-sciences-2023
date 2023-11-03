# Week 10 - R Syntax #
#
# These are the R commands contained in the Week 10 notebook (Bivariate Data Analysis).
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

table(bsa2019$HEdQual3)

barplot(table(bsa2019$HEdQual3))

table(bsa2019$RAgeCat, bsa2019$HEdQual3)

ed_age_table <- table(bsa2019$RAgeCat, bsa2019$HEdQual3) # store the results of the `table()` command in an object called 'relig_age_table'

round(prop.table(ed_age_table, 1)* 100, 0) # display row percentages

ed_age_perc_table <- round(prop.table(ed_age_table, 1)* 100, 0)

barplot(ed_age_perc_table, main="Highest qualification by age group",
  xlab="Type of qualification", ylab="% of respondents", col = c("grey", "grey", "grey", "grey","grey", "grey", "red"), 
  legend = rownames(ed_age_perc_table), beside=TRUE, args.legend=list(x="topleft"))

#install.packages("DescTools") # install the necessary package - only needs to be done once

library(DescTools) # import the package containing the `GoodmanKruskalGamma()` command

GoodmanKruskalGamma(bsa2019$RAgeCat, bsa2019$HEdQual3) # the order of the variables does not matter

cor.test(as.numeric(bsa2019$RAgeCat), as.numeric(bsa2019$HEdQual3), method="kendall") # Kendall's tau-B

rstat_sex_table <- table(bsa2019$RSex, bsa2019$Married) # store the results of the `table()` command in an object called 'relig_age_table'
round(prop.table(rstat_sex_table, 1)* 100, 0) # row percentages

CramerV(bsa2019$RSex, bsa2019$Married)

summary(bsa2019$welfare2)

sd(bsa2019$welfare2, na.rm=TRUE)

hist(bsa2019$welfare2)

aggregate(welfare2 ~ RAgeCat, data = bsa2019, mean)

aggregate(welfare2 ~ RAgeCat, data = bsa2019, median)

aggregate(welfare2 ~ RAgeCat, data = bsa2019, sd)

aggregate(welfare2 ~ RAgeCat, data = bsa2019, min)

aggregate(welfare2 ~ RAgeCat, data = bsa2019, max)

boxplot(welfare2 ~ RAgeCat,
    data = bsa2019,
    main = "Attitude to Welfare by Age",
    xlab = "Age Group",
    ylab = "Attitude Score",
    col = "steelblue",
    border = "black")

#install.packages("lsr") # install the necessary package - only needs to be done once

library(lsr) # import the package containing the `etaSquared()` command

model <- aov(welfare2 ~ RAgeCat, data = bsa2019)
etaSquared(model)

# create a figure with two plots
# set graphical parameters for a figure of one row, two columns
par(mfrow = c(1, 2))

hist(bsa2019$welfare2)
hist(bsa2019$NatFrEst)

plot(bsa2019$NatFrEst, bsa2019$welfare2) # X variable (axis) is listed first, Y variable (axis) second

cor(bsa2019$NatFrEst, bsa2019$welfare2, use = "complete.obs")

plot(bsa2019$NatFrEst, bsa2019$welfare2)
abline(lm(bsa2019$welfare2 ~ bsa2019$NatFrEst))
