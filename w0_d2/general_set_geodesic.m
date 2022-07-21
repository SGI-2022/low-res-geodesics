% Computes the geodesic distance to an arbitrary subset of verticies
% using the gradient. Could also be implemented with linear solvers.

% Load in mesh
[V,F] = readOBJ('spot.obj');

% Swap axes
V = [V(:,1), V(:,3), V(:,2)];

% Get the number of verticies
N = length(V);

% Select a subset of target verticies for set distance
S = randi(N, 3, 1);

% Compute the gradient
G = grad(V, F);

% Compute the mass matrix
% M = massmatrix(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  cvx_precision low
  variable f(N)
  maximize( sum( f ) )
  subject to
    f(S) <= 0
    norms(reshape(G*f, size(F,1), 3), 2, 2) <= 1
cvx_end

render_distance(V, F, f)
hold on;

D = reshape(G*f, size(F,1), 3);
B = barycenter(V, F);
quiver3(B(:, 1), B(:, 2), B(:, 3), D(:, 1), D(:, 2), D(:, 3))
