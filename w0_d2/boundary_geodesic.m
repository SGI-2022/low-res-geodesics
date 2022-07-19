% Load in mesh
[V,F] = readOBJ('sphere.obj');

% Get the number of verticies
N = length(V);

% Compute the boundary verticies
O = outline(F);
B = unique(O(:));

% Get the number of verticies in the boundary
NB = length(B);

% Compute intenior verticies
I = setdiff(1:N, B);

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
