function ImageAlignment()

niiT1 = load_nii(fullfile('Dataset', 'T1_01.nii'));
niiT2 = load_nii(fullfile('Dataset', 'T2_01.nii'));

% Step 1: Read Image
% Bring an image into the workspace.
%figure;
Modality1 = image(niiT1.img);
saveas(image(niiT1.img),'T1_01.png');
%figure;
Modality2 = image(niiT2.img);
saveas(Modality2,'T2_01.png');

T101 = rgb2gray(imread('T1_01.png'));
T201 = rgb2gray(imread('T2_01.png'));

% Step 2: Compute clusters for each of the images to pick the cluster centroids as the Control Points

[idx1,centroid1,sumdist1, idx2,centroid2,sumdist2] = KMeansClustering(double(T101),double(T201));

% Step 3: Select Control Points
% Pick the cluster centroids as the Control Points

[clusterSize, maxElements] = size(centroid1);
stepsize = maxElements/clusterSize;

movingPoints = zeros(clusterSize,2);
fixedPoints = zeros(clusterSize,2);
i=1;
for k = 1:stepsize:maxElements
    movingPoints(:,i) = centroid1(:,k);
    fixedPoints(:,i) = centroid2(:,k);
    i = i+1;
end

cpselect(double(Modality2),double(Modality1),movingPoints,fixedPoints);


% Step 4: Estimate Transformation
% Fit a nonreflective similarity transformation to your control points.

tform = fitgeotrans(movingPoints,fixedPoints,'nonreflectivesimilarity');


% Step 5: Solve for Scale and Angle
% The geometric transformation, tform, contains a transformation matrix in tform.T.
% Since the transformation includes only rotation and scaling, the math is relatively simple to recover the scale and angle.
% Let sc = s*cos(theta)
% Let ss = s*sin(theta)

tformInv = invert(tform);
Tinv = tformInv.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc)
theta_recovered = atan2(ss,sc)*180/pi


% Step 6: Recover Original Image
% Recover the Modality1 image by transforming Modality2, the rotated-and-scaled image, using the geometric transformation tform and what you know about the spatial referencing of Modality1. 
% The 'OutputView' Name/Value pair is used to specify the resolution and grid size of the resampled output image.

Roriginal = imref2d(size(Modality1));
recovered = imwarp(double(Modality2),tform,'OutputView',Roriginal);

% Compare recovered to Modality1 by looking at them side-by-side in a montage.
figure, imshowpair(double(Modality1),recovered,'montage')

end