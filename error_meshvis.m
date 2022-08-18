% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_mini.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, 30);

NumVertSamples=100;
NumFaceSamples=50;
NumEigenvectors=10;
% Select some target verticies
NumTargetVerts = 1;
TargetVerts = randi(size(Verts, 1), NumTargetVerts, NumEigenvectors);

<<<<<<< Updated upstream
ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, NumVertSamples, NumFaceSamples);
=======
ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, 30, 30);
>>>>>>> Stashed changes
Distance = Basis * ProjectedDistance * Basis.';

save_geodesic('spot', 'pairwise_projected', Distance);

% Error = abs(Distance - GroundTruthDistance) ./ abs(GroundTruthDistance);
% Error(TargetVerts) = 0;

render_distance_function(Verts, Faces, Distance(TargetVerts, :), TargetVerts);

Headers=['Eigenvectors', 'Faces', 'Error']
writematrix(Headers, 'saved.csv')
%Data = [NumEigenvectors, NumFaces, Error]
%writematrix(Data, 'saved.csv', 'WriteMode', 'append')