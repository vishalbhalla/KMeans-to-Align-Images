function KMeansClustering()

niiT1 = load_nii(fullfile('Dataset', 'T1_01.nii'));
niiT2 = load_nii(fullfile('Dataset', 'T2_01.nii'));

% No.of clusters
k = 4;

% Some points have small relative magnitudes, making them effectively zero.
% Either remove those points, or choose a distance other than 'cosine'.

X1 = double(niiT1.img);
[idx1,centroid1,sumdist1] = kmeans(X1,k,'Distance','cityblock',...
                           'Display','iter','Replicates',5);

X2 = double(niiT2.img);
[idx2,centroid2,sumdist2] = kmeans(X2,k,'Distance','cityblock',...
                           'Display','iter','Replicates',5);
    
end
