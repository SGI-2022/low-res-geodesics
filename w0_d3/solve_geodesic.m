function d = solve_geodesic(V, F, S)

% Get the number of verticies
N = length(V);

% Compute the gradient
G = grad(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  variable d(N)
  maximize( sum( d ) )
  subject to
    d(S) <= 0
    norms(reshape(G*d, length(F), 3), 2, 2) <= 1
    % TODO: Require this to be in a specific basis
cvx_end

end