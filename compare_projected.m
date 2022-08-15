% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, 50);

% Select some target verticies
TargetVerts = randi(size(Verts, 1), 3, 1);

tic
ProjectedDistance1 = projected_constraint_geodesic(Verts, Faces, TargetVerts, Basis);
toc

tic
ProjectedDistance2 = projected_direct_geodesic(Verts, Faces, TargetVerts, Basis);
toc

Error = abs((Basis*ProjectedDistance2) - (Basis*ProjectedDistance2));

render_distance_function(Verts, Faces, Error, TargetVerts);