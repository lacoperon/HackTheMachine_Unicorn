install.packages(c("ddplyr",
                   "ggplot2",
                   "tidyr",
                   "reshape2",
                   "ggplot2",
                   "Hmisc",
                   "dtwclust"))

library(ddplyr)
library(ggplot2)
library(tidyr)
library(reshape2)
library(ggplot2)
library(Hmisc)
library(dtwclust)

i# Makes histogram for all data in the dataframe
plotHistOfDf <- function(df) {
d <- melt(classA_ship1_GTG)
return(ggplot(d,aes(x = value)) + 
  facet_wrap(~variable,scales = "free_x") + 
  geom_histogram())
}

phod <- plotHistOfDf

histAndSum <- function(df) {
  return(list(phod(df),summary(df)))
}

has <- histAndSum

# Plotting all of the data

A1GTG_HaS <- has(classA_ship1_GTG)
A1MRG_HaS <- has(classA_ship1_MRG)
B2GTM_HaS <- has(classB_ship2_GTM)
B2MRG_HaS <- has(classB_ship2_MRG)
C1MPDE_HaS<- has(classC_ship1_MPDE)
C1MRG_HaS <- has(classC_ship1_MRG)
C1SSDG_HaS<- has(classC_ship1_SSDG)
C2MPDE_HaS<- has(classC_ship2_MPDE)
C2MRG_HaS <- has(classC_ship2_MRG)
C2SSDG_HaS<- has(classC_ship2_SSDG)






