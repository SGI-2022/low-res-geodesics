% Calculates the geodesic distance between all points on a mesh.
% Uses an alternative to the gradient constraint that is _much_ faster.

% Load in mesh
[V,F] = readOBJ('monkey.obj');

% Swap forward axis
V = [V(:,1), V(:,3), V(:,2)];

% Get the number of verticies
N = length(V);

% Get a list of edges
E = edges(F);

% Compute the length of each edge
L = V(E(:,1), :) - V(E(:,2), :);
L = vecnorm(L, 2, 2);

% OPTIMIZE
cvx_begin
  variable f(N, N)
  maximize( sum(sum( f )))
  subject to
    diag(f) == 0
    f(E(:,1), :) - f(E(:, 2), :) <= repmat(L, 1, N)
    f(E(:,2), :) - f(E(:, 1), :) <= repmat(L, 1, N)
cvx_end

render_distance(V, F, f(25,:))