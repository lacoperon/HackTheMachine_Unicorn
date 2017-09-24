# In this file, we aim to cluster the observed changes in the ship functionality
# through the distance metric of 'Dynamic Time Warping', which itself minimizes the 
# 'distance' between co-related changes in variables where the time series don't exactly
# overlap.

# For this, we use the dtwclust package

install.packages(
  "ggplot2",
  "dwtclust",
  "dplyr"
)

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

classB_ship2_GTM <- na.omit(classB_ship2_GTM) #huge assumption, maybe should input inferred values

# Partitions into the two different motors
B2GTM1A <- filter(classB_ship2_GTM, indicator == "GTM1A")
B2GTM1B <- filter(classB_ship2_GTM, indicator == "GTM1B")

B2GTMSampleA <- sample_n(B2GTM1A, 2000)
B2GTMSampleB <- sample_n(B2GTM1B, 2000)
B2GTMSampleA$indicator <- NULL
B2GTMSampleB$indicator <- NULL
B2GTMSampleA$DateTime  <- NULL
B2GTMSampleB$DateTime  <- NULL

B2GTMSampleA <- na.omit(B2GTMSampleA)
B2GTMSampleB <- na.omit(B2GTMSampleB)

engineData_A <- scale(B2GTMSampleA)
engineData_B <- scale(B2GTMSampleB)

# Using DTW with help of lower bounds and PAM centroids
clusterResultA <- tsclust(engineData_A, k = 4L,
                    distance = "dtw_lb", centroid = "pam", 
                    seed = 3247, trace = TRUE,
                    control = partitional_control(pam.precompute = FALSE),
                    args = tsclust_args(dist = list(window.size = 4L)))

clusterResultB <- tsclust(engineData_B, k = 4L,
                          distance = "dtw_lb", centroid = "pam", 
                          seed = 3247, trace = TRUE,
                          control = partitional_control(pam.precompute = FALSE),
                          args = tsclust_args(dist = list(window.size = 4L)))

B2GTMSampleA$cluster <- clusterResultA@cluster
B2GTMSampleB$cluster <- clusterResultB@cluster

library(ggfortify)


# Applies PCA to flatten 48-dim space to 2-dim space for graphing,
# then graphs it (for both A)
pcaEngineA <- prcomp(B2GTMSampleA)
B2GTMSampleA$cluster <- as.factor(B2GTMSampleA$cluster)
PCiA<-data.frame(pcaEngineA$x,Cluster=B2GTMSampleA$cluster)
ggplot(PCiA,aes(x=PC1,y=PC2,col=Cluster))+
  geom_point(size=1.5,alpha=0.8)+ #Size and alpha just for fun
  scale_color_manual(values = c("red","blue","orange","green"))+
  theme_classic()+
  labs(title="PCA 2-D Projection of GTM Engine A States")


# ... and B
pcaEngineB <- prcomp(B2GTMSampleB)
B2GTMSampleB$cluster <- as.factor(B2GTMSampleB$cluster)
PCiB<-data.frame(pcaEngineB$x,Cluster=B2GTMSampleB$cluster)
ggplot(PCiB,aes(x=PC1,y=PC2,col=Cluster))+
  geom_point(size=1.5,alpha=0.8)+ #Size and alpha just for fun
  scale_color_manual(values = c("darkblue","purple","firebrick3","green3"))+
  theme_classic()+
  labs(title="PCA 2-D Projection of GTM Engine B States")

C1A <- (filter(B2GTMSampleA, cluster == 1))
C1A$cluster <- NULL
C2A <- filter(B2GTMSampleA, cluster == 2)
C2A$cluster <- NULL
C3A <- filter(B2GTMSampleA, cluster == 3)
C3A$cluster <- NULL
C4A <- filter(B2GTMSampleA, cluster == 4)
C4A$cluster <- NULL

C1B <- filter(B2GTMSampleB, cluster == 1)
C1B$cluster <- NULL
C2B <- filter(B2GTMSampleB, cluster == 2)
C2B$cluster <- NULL
C3B <- filter(B2GTMSampleB, cluster == 3)
C3B$cluster <- NULL
C4B <- filter(B2GTMSampleB, cluster == 4)
C4B$cluster <- NULL