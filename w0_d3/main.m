% Load in mesh
[V,F] = readOBJ('../w0_d2/spot.obj');

% Swap forward axis
V = [V(:,1), V(:,3), V(:,2)];

% Number of eigenvalue runs
M = 200;

% E is #Vert x 10
E = mesh_eigen(V, F, M);

% Calculate the true geodesic distance
S = randi(length(V), 3, 1);
D = solve_geodesic(V, F, S);

% render_distance(V, F, E(:, 10));
231
% Now we iterate 
Error = zeros(M, 1);

for k=1:M

  % Project geodesic onto eigenvector space
  C = project(D, E(:, 1:k));

  Error(k) = max(abs(E(:, 1:k)*C - D)) / max(abs(D));
  
end

plot(Error);
render_distance(V, F, E(:, 1:k)*C);

