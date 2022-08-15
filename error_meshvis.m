% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, 50);

% Select some target verticies
TargetVerts = randi(size(Verts, 1), 20, 1);

% Compute the ground truth geodesic distance
GroundTruthDistance = geodesic(Verts, Faces, TargetVerts);

ProjectedDistance = projected_direct_geodesic(Verts, Faces, TargetVerts, Basis);

Error = abs((Basis*ProjectedDistance) - GroundTruthDistance) ./ abs(GroundTruthDistance);
Error(TargetVerts) = 0;

render_distance_function(Verts, Faces, Error, TargetVerts);