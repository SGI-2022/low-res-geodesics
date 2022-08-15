[Verts, Faces] = readOBJ('data/spot.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, MaxEigenVectors);

% Select some target verticies
TargetVerts = randi(size(Verts, 1), 6, 1);

Mass = massmatrix(Verts, Faces);

GroundTruthDistance = geodesic(Verts, Faces, TargetVerts);
ProjectedDistance = project_to_basis(GroundTruthDistance, Basis);
DirectProjectedDistance = projected_direct_geodesic(Verts, Faces, TargetVerts, Basis);

Error = abs((Basis * ProjectedDistance) - (Basis * DirectProjectedDistance))./abs(Basis * ProjectedDistance);
D = GroundTruthDistance;
D1 = Basis * ProjectedDistance;
D2 = Basis * DirectProjectedDistance;
Error(1, :) = sqrt( (D-D1).' * Mass * (D-D1) ./ (D1.' * Mass * D1) );

render_distance_function(Verts, Faces, Error, TargetVerts);