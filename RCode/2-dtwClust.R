# In this file, we aim to cluster the observed changes in the ship functionality
# through the distance metric of 'Dynamic Time Warping', which itself minimizes the 
# 'distance' between co-related changes in variables where the time series don't exactly
# overlap.

# For this, we use the dtwclust package

library(ggplot2)
library(dtwclust)
library(dplyr)

# Deletes data that are always (or seemingly always) null
classB_ship2_GTM$`PCL PORT BCU POS` <- NULL
classB_ship2_GTM$`PCL PORT PACC POS` <- NULL
classB_ship2_GTM$`PCL PORT SCU POS` <- NULL
classB_ship2_GTM$`PORT ACT SHAFT SPD` <- NULL
classB_ship2_GTM$`PORT ACTUAL PITCH` <- NULL
classB_ship2_GTM$`PORT PITCH COMMAND` <- NULL
classB_ship2_GTM$`PORT SHAFT TORQUE` <- NULL

# But, some data is missing values, so we try to interpolate the variables in the in between using
# a linear model (but I don't -- to figure out later) - using tsinterp or something

classB_ship2_GTM <- na.omit(classB_ship2_GTM) #huge assumption, maybe should input guess values

# Partitions into the two different motors
B2GTM1A <- filter(classB_ship2_GTM, indicator == "GTM1A")
B2GTM1B <- filter(classB_ship2_GTM, indicator == "GTM1B")

B2GTMSample <- sample_n(classB_ship2_GTM, 2000)
B2GTMSample$indicator <- NULL
B2GTMSample$DateTime  <- NULL

B2GTMSample <- na.omit(B2GTMSample)



b2gtmz <- scale(B2GTMSample)
# Using DTW with help of lower bounds and PAM centroids
clusterResult <- tsclust(b2gtmz, k = 5L,
                    distance = "dtw_lb", centroid = "pam", 
                    seed = 3247, trace = TRUE,
                    control = partitional_control(pam.precompute = FALSE),
                    args = tsclust_args(dist = list(window.size = 5L)))

B2GTMSample$cluster <- clusterResult@cluster

C1A <- filter(B2GTMSample, cluster == 1)
C2A <- filter(B2GTMSample, cluster == 2)
C3A <- filter(B2GTMSample, cluster == 3)
C4A <- filter(B2GTMSample, cluster == 4)
C5A <- filter(B2GTMSample, cluster == 5)

C1B <- filter(B2GTMSample, cluster == 1)
C2B <- filter(B2GTMSample, cluster == 2)
C3B <- filter(B2GTMSample, cluster == 3)
C4B <- filter(B2GTMSample, cluster == 4)
C5B <- filter(B2GTMSample, cluster == 5)

