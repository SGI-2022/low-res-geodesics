% Implements a slower version of allpoints_geodesic using the gradient
% Instead of two linear constraints.

% Load in mesh
[V,F] = readOBJ('sphere.obj');

% Swap forward axis
V = [V(:,1), V(:,3), V(:,2)];

% Get the number of verticies
N = length(V);

% Compute the gradient
G = grad(V, F);

% OPTIMIZE
cvx_begin
  variable f(N, N)
  maximize( sum(sum( f )) )
  subject to
    diag(f) == 0
    norms(reshape(G*f, length(F), 3, N), 2, 3) <= 1
cvx_end

render_distance(V, F, f(25,:))
hold on;

D = G*f;
D = reshape(D, length(F), 3, N);
D = D(:, :, 25);
B = barycenter(V, F);
quiver3(B(:, 1), B(:, 2), B(:, 3), D(:, 1), D(:, 2), D(:, 3), 0)