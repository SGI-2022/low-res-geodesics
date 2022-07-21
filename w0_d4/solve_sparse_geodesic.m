function d = solve_sparse_geodesic(V, F, S, E)

% Get the number of verticies
N = length(V);

% Compute the gradient
G = grad(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  variable d(N)
  variable C(size(E,2))
  maximize( sum( d ) )
  subject to
    d(S) <= 0
    norms(reshape(G*d, length(F), 3), 2, 2) <= 1
   % d==E(:, 1:size(E,2))*C
    % TODO: Require this to be in a specific basis
cvx_end

end