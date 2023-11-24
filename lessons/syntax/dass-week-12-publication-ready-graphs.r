name <- readline(prompt="Enter name: ")
print(paste("Hi,", name, "enjoy learning more about R and multivariate analysis!"))

x * 5

x <- 10 # create an object called 'x' and give it the value '10'

x * 5 # multiply 'x' by 5

# install.packages("RColorBrewer")
# install.packages("ggplot2")
# install.packages("cowplot")

library(RColorBrewer)
display.brewer.all() # view available colour palettes

library(ggplot2)

library(cowplot)

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

he_table <- prop.table(table(bsa2019$HEdQual3)) # frequency table of higher education qualifications
he_table

bar_colors <- RColorBrewer::brewer.pal(4, "Blues")
bar_colors

png("hed-plot-2023-11-28.png", width = 500, height = 500) # open a file to save your plot = play around with width and height if needed

barplot(he_table, main = "HE Qualifications",
        xlab = "Qualification type", ylab = "Proportion of sample",
        col = bar_colors)

dev.off() # close the file to save your plot

p <- ggplot(data = bsa2019,
       mapping = aes(x = Married))

p + geom_bar(mapping = aes(y = after_stat(prop), , group = 1)) # graph proportions instead of counts

fig1 <- p + geom_bar(mapping = aes(y = after_stat(prop), , group = 1)) +
    coord_flip() + # flip the graph from vertical to horizontal
    theme_cowplot() + # select a visualisation theme - others include theme_bw(), theme_classic()
    labs(x = "Relationship status", y = "Proportion of sample", title = "Distribution of relationship status", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig1

ggsave("married-plot-2023-11-28.png", plot = fig1, height = 4, width = 8)

h = hist(bsa2019$welfare2, plot=FALSE)
h$density = h$counts/sum(h$counts)

plot(h, freq = FALSE, col = "steelblue", main = "Distribution of attitude to welfare",
    xlab = "Welfare score (1-5)", ylab = "Proportion of sample")

summary(bsa2019$welfare2)

p <- ggplot(data = bsa2019,
       mapping = aes(x = welfare2))

fig2 <- p + geom_histogram(bins = 8, binwidth=.5, color = "black", fill="lightgrey", aes(y=..count../sum(..count..))) + # 
    theme_cowplot() +
    labs(x = "Attitude to welfare", y = "Proportion of sample", title = "Distribution of attitude to welfare", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig2

ggsave("welfare-plot-2023-11-28.png", plot = fig2, height = 4, width = 8)

ed_age_table <- round(prop.table(table(bsa2019$RAgeCat, bsa2019$HEdQual3), 1)* 100, 0)
ed_age_table

bar_colors <- RColorBrewer::brewer.pal(7, "Blues")
bar_colors

barplot(ed_age_perc_table, main="Highest qualification by age group",
  xlab="Type of qualification", ylab="% of sample", col = bar_colors, 
  legend = rownames(ed_age_table), beside=TRUE, args.legend=list(x="topleft", box.lty = 0, cex = 0.8))

p <- ggplot(data = bsa2019[!(is.na(bsa2019$HEdQual3)),],
       mapping = aes(x = RAgeCat))

fig3 <- p + geom_bar(mapping = aes(y = after_stat(prop), , group = 1)) +
    facet_wrap(~ HEdQual3) + guides(fill = "none") +
    theme_cowplot() +
    labs(x = "Age group", y = "Proportion of sample", title = "Distribution of qualifications across age groups", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc
    

fig3

ggsave("hed-age-plot-2023-11-28.png", plot = fig3, height = 6, width = 8)

boxplot(welfare2 ~ RAgeCat,
    data = bsa2019,
    main = "Attitude to Welfare by Age",
    xlab = "Age Group",
    ylab = "Attitude Score",
    col = "steelblue",
    border = "black")

p <- ggplot(data = bsa2019[!(is.na(bsa2019$RAgeCat)),],
       mapping = aes(x = RAgeCat, y = welfare2))

fig4 <- p + geom_boxplot() + 
    theme_cowplot() +
    labs(x = "Age group", y = "Attitude Score", title = "Distribution of welfare attitudes across age groups", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig4

ggsave("wel-age-plot-2023-11-28.png", plot = fig4, height = 6, width = 8)

plot(bsa2019$NatFrEst, bsa2019$welfare2, main = "Distribution of Attitude to Welfare and Fraud",
    xlab = "Benefit fraud estimate",
    ylab = "Attitude Score",
    col = "steelblue")

p <- ggplot(data = bsa2019,
       mapping = aes(x = NatFrEst, y = welfare2))

fig5 <- p + geom_point() + 
    theme_cowplot() +
    labs(x = "Benefit fraud estimate", y = "Attitude Score", title = "Distribution of welfare attitudes and benefit fraud estimate", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig5

ggsave("wel-ben-plot-2023-11-28.png", plot = fig5, height = 6, width = 8)

boxplot(welfare2 ~ RAgeCat + RSex,
    data = bsa2019,
    main = "Attitude to Welfare by Age",
    xlab = "Age Group",
    ylab = "Attitude Score",
    col = "steelblue",
    border = "black")

p <- ggplot(bsa2019[!(is.na(bsa2019$RAgeCat)),], aes(x=RAgeCat, y=welfare2, fill=RSex)) # the fill option is your third variable

fig6 <- p + geom_boxplot() +
    theme_cowplot() +
    facet_wrap(~RSex) + 
    labs(x = "Age Group", y = "Attitude Score", title = "Distribution of welfare attitudes", subtitle = "By age and sex", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig6

ggsave("wel-age-sex-plot-2023-11-28.png", plot = fig6, height = 6, width = 8)

bsa2019_males <- bsa2019[bsa2019$RSex=="Male",] # create a dataset containing only males
bsa2019_females <- bsa2019[bsa2019$RSex=="Female",] # create a dataset containing only females

# create a figure with two plots
# set graphical parameters for a figure of one row, two columns
par(mfrow = c(1, 2))

plot(bsa2019_males$NatFrEst, bsa2019_males$welfare2, main = "Males",
    xlab = "Benefit fraud estimate",
    ylab = "Attitude Score",
    col = "steelblue")
plot(bsa2019_females$NatFrEst, bsa2019_females$welfare2, main = "Females",
    xlab = "Benefit fraud estimate",
    ylab = "Attitude Score",
    col = "red") 

p <- ggplot(data = bsa2019,
       mapping = aes(x = NatFrEst, y = welfare2))

fig7 <- p + geom_point() + 
    facet_wrap(~RSex) +
    theme_cowplot() +
    labs(x = "Benefit fraud estimate", y = "Attitude Score", title = "Distribution of welfare attitudes and benefit fraud estimate", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig7

p <- ggplot(data = bsa2019[!(is.na(bsa2019$HEdQual3)),],
       mapping = aes(x = RAgeCat))

fig8 <- p + geom_bar(mapping = aes(y = after_stat(prop), , group = 1)) +
    facet_wrap(~ HEdQual3 + RSex) + guides(fill = "none") +
    theme_cowplot() +
    labs(x = "Age group", y = "Proportion of sample", title = "Distribution of qualifications across age groups and sexes", subtitle = "", 
         caption = "British Social Attitudes survey 2019, n=3,224") # add labels, titles, notes etc

fig8
