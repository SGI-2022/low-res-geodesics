% Computes the geodesic distance to an arbitrary subset of verticies
% using the gradient. Could also be implemented with linear solvers.

% Load in mesh
[V,F] = readOBJ('spot.obj');

% Swap axes
V = [V(:,1), V(:,3), V(:,2)];

% Get the number of verticies
N = length(V);

% Select a subset of target verticies for set distance
S = randi(N, 50, 1);

% Compute the gradient
G = grad(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  variable f(N)
  maximize( sum( f ) )
  subject to
    f(S) <= 0
    norms(reshape(G*f, length(F), 3), 2, 2) <= 1
cvx_end

render_distance(V, F, f)
