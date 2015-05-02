function [idx1,centroid1,sumdist1, idx2,centroid2,sumdist2] = KMeansClustering(T101,T201)

% No.of clusters
minClusters = 2;
finalNoOfKCluster = minClusters;
maxClusters = 10;
oldMeanSilhouetteValue = 0;

% Decide on the number of clusters to use.
for k = minClusters:maxClusters;
    X = T101;

    % Some points have small relative magnitudes, making them effectively zero.
    % Either remove those points, or choose a distance other than 'cosine'.
    [idx,centroid,sumdist] = kmeans(X,k,'Distance','cityblock',...
                           'Display','final','Replicates',5);

    % Use Silhouette Plots to decide the correct number of clusters.                   
    % The silhouette value for each point is a measure of how similar that point is to points in its own cluster, when compared to points in other clusters. 
    % The silhouette value ranges from -1 to +1. A high silhouette value indicates that i is well-matched to its own cluster, and poorly-matched to neighboring clusters.
    % If most points have a high silhouette value, then the clustering solution is appropriate.
    % If many points have a low or negative silhouette value, then the clustering solution may have either too many or too few clusters.

    %figure;
    [silh,h] = silhouette(X,idx,'cityblock');
    h = gca;
    h.Children.EdgeColor = [.8 .8 1];
    xlabel 'Silhouette Value';
    ylabel 'Cluster';
    newMeanSilhouetteValue = mean(silh);

    % Decide if the current cluster 
    if(newMeanSilhouetteValue>oldMeanSilhouetteValue)
        oldMeanSilhouetteValue = newMeanSilhouetteValue;
        finalNoOfKCluster = k;
    else
        break;
end

X1 = T101;
[idx1,centroid1,sumdist1] = kmeans(X1,finalNoOfKCluster,'Distance','cityblock',...
                           'Display','iter','Replicates',5);

X2 = T201;
[idx2,centroid2,sumdist2] = kmeans(X2,finalNoOfKCluster,'Distance','cityblock',...
                           'Display','iter','Replicates',5);
    
end
