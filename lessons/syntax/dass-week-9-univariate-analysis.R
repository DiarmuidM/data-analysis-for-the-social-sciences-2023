# Week 9 - R Syntax #
#
# These are the R commands contained in the Week 9 notebook (Univariate Data Analysis).
#
# Open this syntax file in RStudio or create your own file and copy-and-paste syntax as you need it.
#

bsa2019 <- read.table("https://raw.githubusercontent.com/DiarmuidM/data-analysis-for-the-social-sciences-2023/main/lessons/data/bsa2019_poverty_open.tab", header=TRUE, na="NA", sep="\t")
head(bsa2019)
names(bsa2019)

summary(bsa2019$welfare2)

bsa2019$welfare2[bsa2019$welfare2<1 | bsa2019$welfare2>5] <- NA
bsa2019$RSex <- factor(bsa2019$RSex, levels = c(1,2), labels = c("Male", "Female"))

table(bsa2019$RSex)
round(prop.table(table(bsa2019$RSex)) * 100, 0)
barplot(table(bsa2019$RSex))

mean(bsa2019$welfare2, na.rm=TRUE)
median(bsa2019$welfare2, na.rm=TRUE)
summary(bsa2019$welfare2)
hist(bsa2019$welfare2, breaks = seq(1, 5, by=.5))
sd(bsa2019$welfare2, na.rm=TRUE)