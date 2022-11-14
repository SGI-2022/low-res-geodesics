% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_josue.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

NumFaceSteps=100;
NumVertSamples=100;
NumEigenvectors=30;

% Load the ground truth
GroundTruthDistance = readmatrix('spot_pairwise.csv');

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, NumEigenvectors);

ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, NumVertSamples, NumFaceSamples);
Distance = Basis * ProjectedDistance * Basis.';

Error = abs(Distance - GroundTruthDistance);
Error(1:1+size(Error,1):end) = 0;

render_distance_function(Verts, Faces, max(Error), []);
colormap(copper)