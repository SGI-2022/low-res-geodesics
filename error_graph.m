% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_mini.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Number of eigenvalue runs
MaxEigenVectors = 100;

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, MaxEigenVectors);

% Select some target verticies
TargetVerts = randi(size(Verts, 1), 3, 1);

% Compute the ground truth geodesic distance
GroundTruthDistance = geodesic(Verts, Faces, TargetVerts);

Mass = massmatrix(Verts, Faces);

Bar = waitbar(i/MaxEigenVectors, 'Generating graph');

Error = zeros(MaxEigenVectors, 2);
for i=1:MaxEigenVectors
    waitbar(i/MaxEigenVectors, Bar, 'Generating graph');

    StepBasis = Basis(:, 1:i);

    ProjectedDistance = project_to_basis(GroundTruthDistance, StepBasis);
    DirectProjectedDistance = projected_direct_geodesic(Verts, Faces, TargetVerts, StepBasis);

    D = GroundTruthDistance;
    D1 = StepBasis * ProjectedDistance;
    D2 = StepBasis * DirectProjectedDistance;
    Error(i, 1) = sqrt( sum( (D-D1).' * Mass * (D-D1) ./ (D.' * Mass * D) ) );
    Error(i, 2) = sqrt( sum( (D-D2).' * Mass * (D-D2) ./ (D.' * Mass * D) ) );
end

close(Bar)

plot(Error);
%render_distance(V, F, abs(E(:, 1:k)*C - D) / max(abs(D)));