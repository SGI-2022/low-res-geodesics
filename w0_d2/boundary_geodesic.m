% Calculates geodesic distance to the boundary of a mesh using the gradient.

% Load in mesh
[V,F] = readOBJ('monkey.obj');

% Swap axes
V = [V(:,1), V(:,3), V(:,2)];

% Get the number of verticies
N = length(V);

% Compute the boundary verticies
O = outline(F);
B = unique(O(:));

% Compute the gradient
G = grad(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  variable f(N)
  maximize( sum( f ) )
  subject to
    f(B) <= 0
    norm(G*f) <= 1
cvx_end

render_distance(V, F, f)
