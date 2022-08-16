% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, 50);

% Select some target verticies
NumTargetVerts = 1;
TargetVerts = randi(size(Verts, 1), NumTargetVerts, 1);

ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, 300, 100);
Distance = Basis * ProjectedDistance * Basis.';

save_geodesic('spot', 'pairwise_projected', Distance);

% Error = abs(Distance - GroundTruthDistance) ./ abs(GroundTruthDistance);
% Error(TargetVerts) = 0;

render_distance_function(Verts, Faces, Distance(TargetVerts, :), TargetVerts);