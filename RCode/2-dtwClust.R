# In this file, we aim to cluster the observed changes in the ship functionality
# through the distance metric of 'Dynamic Time Warping', which itself minimizes the 
# 'distance' between co-related changes in variables where the time series don't exactly
# overlap.

# For this, we use the dtwclust package

library(ggplot2)
library(dtwclust)
library(imputets)
library(dplyr)

# Load series
data(uciCT)

# Reinterpolate series to equal length and normalize
series <- zscore(series)

classB_ship2_GTM$`PCL PORT BCU POS` <- NULL
classB_ship2_GTM$`PCL PORT PACC POS` <- NULL
classB_ship2_GTM$`PCL PORT SCU POS` <- NULL
classB_ship2_GTM$`PORT ACT SHAFT SPD` <- NULL
classB_ship2_GTM$`PORT ACTUAL PITCH` <- NULL
classB_ship2_GTM$`PORT PITCH COMMAND` <- NULL
classB_ship2_GTM$`PORT SHAFT TORQUE` <- NULL

# But, some data is missing values, so we try to interpolate the variables in the in between using
# a linear model (but I don't -- to figure out later)

classB_ship2_GTM <- na.omit(classB_ship2_GTM) #huge assumption, maybe should input guess values

B2GTMSample <- sample_n(classB_ship2_GTM, 100)

# Using DTW with help of lower bounds and PAM centroids
pc.dtwlb <- tsclust(classB_ship2_GTM, k = 6L, 
                    distance = "dtw_lb", centroid = "pam", 
                    seed = 3247, trace = TRUE,
                    control = partitional_control(pam.precompute = FALSE),
                    args = tsclust_args(dist = list(window.size = 20L)))
#> Repetition 1 for k = 20
#> Iteration 1: Changes / Distsum = 100 / 3214.899
#> Iteration 2: Changes / Distsum = 16 / 2684.667
#> Iteration 3: Changes / Distsum = 7 / 2617.178
#> Iteration 4: Changes / Distsum = 0 / 2611.894
#> 
#>  Elapsed time is 2.083 seconds.

plot(pc.dtwlb)
