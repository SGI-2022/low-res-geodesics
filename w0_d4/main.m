% Load in mesh
[V,F] = readOBJ('../w0_d2/monkey.obj');

% Swap forward axis
V = [V(:,1), V(:,3), V(:,2)];

% Number of eigenvalue runs
M = 50;

% E is #Vert x 10
E = mesh_eigen(V, F, M);

O = outline(F);
S = unique(O(:));
D = solve_geodesic(V, F, S);

Error = zeros(M, 1);

for k=1:M
    C = solve_sparse_geodesic(V, F, S, E(:, 1:k));

    Error(k) = max(abs(E(:, 1:k)*C - D)) / max(abs(D));
end

plot(Error);
%render_distance(V, F, abs(E(:, 1:k)*C - D) / max(abs(D)));