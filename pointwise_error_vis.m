% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_josue.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

NumVertSamples=50;
NumEigenvectors=20;

% Load the ground truth
GroundTruthDistance = readmatrix('pairwise_distance.csv');

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, NumEigenvectors);

ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, NumVertSamples);
Distance = Basis * ProjectedDistance * Basis.';

save_geodesic('spot_josue', 'pairwise_projected', Distance);

Error = abs(Distance - GroundTruthDistance);
Error(1:1+size(Error,1):end) = 0;

render_distance_function(Verts, Faces, max(Error), []);
colormap(copper)