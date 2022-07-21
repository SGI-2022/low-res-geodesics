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

% Compute the mass matrix
M = massmatrix(V, F);

% Find a geodesic to a point on the boundary
cvx_begin
  variable f(N)
  maximize( sum( M * f ) )
  subject to
    f(B) <= 0
    % norms(G*f, 2, 2) <= 1 [Tri, 3]
    norms(reshape(G*f, length(F), 3), 2, 2) <= 1
cvx_end

render_distance(V, F, f)
hold on;

D = reshape(G*f, length(F), 3);
B = barycenter(V, F);
quiver3(B(:, 1), B(:, 2), B(:, 3), D(:, 1), D(:, 2), D(:, 3))
