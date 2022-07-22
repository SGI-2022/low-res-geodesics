% Runs several different geodesic solvers for benchmarking

% Load in mesh
[Verts,Faces] = readOBJ('data/spot_mini.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Number of eigenvalue runs
MinEigenVectors = 10;
MaxEigenVectors = 300;
EigenVectorStep = 10;

% Compute a basis on the mesh
Basis = laplacian_eigenbasis(Verts, Faces, MaxEigenVectors);

% Select some target verticies
TargetVerts = randi(size(Verts, 1), 3);

% Compute the ground truth geodesic distance
GroundTruthDistance = solve_geodesic(V, F, S);

Error = zeros(M, 1);
for k=1:M
    C = solve_sparse_geodesic(V, F, S, E(:, 1:k));

    Error(k) = max(abs(E(:, 1:k)*C - D)) / max(abs(D));
end

plot(Error);
%render_distance(V, F, abs(E(:, 1:k)*C - D) / max(abs(D)));