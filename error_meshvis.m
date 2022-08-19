% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_mini.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

NumVertSamples=100;
NumFaceSamples=100;
NumEigenvectors=10;

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, NumEigenvectors);

% Select some target verticies
NumTargetVerts = 1;
TargetVerts = randi(size(Verts, 1), NumTargetVerts);

ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, NumVertSamples, NumFaceSamples);
Distance = Basis * ProjectedDistance * Basis.';

save_geodesic('spot_mini', 'pairwise_projected', Distance);

% Error = abs(Distance - GroundTruthDistance) ./ abs(GroundTruthDistance);
% Error(TargetVerts) = 0;

render_distance_function(Verts, Faces, Distance(TargetVerts, :), TargetVerts);