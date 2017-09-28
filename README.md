# HackTheMachine -- Team Unicorn

Welcome to Team Unicorn's stab at [HacktheMachine 2017](hackthemachine.ai)'s Data Science and the Seven Seas challenge, in which we analyzed several US Navy ships' engine data over several years, from various engine components. Each engine component had >30 measures that were collected very frequently each day, going back those several years. 

The labels corresponding to when a ship's engines were (or weren't) operating at full capacity was (understandably) redacted, so we took a more novel approach.

### Our Approach

Our strategy towards the problem hinged on clustering via unsupervised learning; we had no labels with which to train our data, and we had no tolerances for the engine parts (classified info), so we went ahead with looking for clusters with high variance in their measures.

This was based on the assumption that, when things are screwing up with the engine mechanics, there is no 'normal' when it comes to how the engine component will break; this is as opposed to normal operations, in which you would expect the ship's engine data to 'cluster' around several points (IE moving fast and not turning, moving slow and turning, in port, etc.). 

To quantify 'distance' between different timepoints of the ships' engines, we used a measure called [Dynamic Time Warping](https://www.mathworks.com/help/signal/ref/dtw.html?requestedDomain=www.mathworks.com) (DTW), which is used to minimize the distance between related but temporally distinct events by 'warping' time so that the Euclidian distances between normalized versions of the two events is minimized.

DTW is super well suited to signal data from engines (IE if a engine starts to overheat and steam pressure builds up, and then someone releases some steam, reducing both pressure and temperature, those two signals are related, if not temporally aligned).

We then used k-means clustering on the graph we produced using DTW, producing 'clusters' which we visualized on a scatterplot, using PCA to reduce the dimensionality of the data to two dimensions.

[TOADD: Graph; analysis of clusters + variance]
