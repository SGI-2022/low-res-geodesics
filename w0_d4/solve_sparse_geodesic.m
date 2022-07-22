function c = solve_sparse_geodesic(V, F, S, E)

% Get the number of verticies
N = length(V);

% Compute the gradient
G = grad(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  variable c(size(E, 2))
  variable D(N)
  maximize( sum( D ) )
  subject to
    D(S) <= 0
    norms(reshape(G*D, length(F), 3), 2, 2) <= 1
    D == E * c
    % TODO: Require this to be in a specific basis
cvx_end

end