% Load in mesh
[V,F] = readOBJ('../w0_d2/spot.obj');

% Swap forward axis
V = [V(:,1), V(:,3), V(:,2)];

% Number of eigenvalue runs
M = 50;

% E is #Vert x 10
E = mesh_eigen(V, F, M);

% Calculate the true geodesic distance
S = randi(length(V), 3, 1);
D = solve_sparse_geodesic(V, F, S,E);
