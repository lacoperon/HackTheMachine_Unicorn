library(ddplyr)
library(ggplot2)
library(tidyr)
library(reshape2)
library(ggplot2)
library(Hmisc)

plotHistOfDf <- function(df) {
d <- melt(classA_ship1_GTG)
ggplot(d,aes(x = value)) + 
  facet_wrap(~variable,scales = "free_x") + 
  geom_histogram()
}

phod <- plotHistOfDf

plotHistOfDf(classA_ship1_GTG)



Aship1GTGHist <- phod(classA_ship1_GTG)
Aship1GTGSummary <- summary(classA_ship1_GTG)



