
% Load in mesh
[V,F] = readOBJ('spot_mini.obj');

% Get the number of verticies
N = length(V);

% Get a list of edges
E = edges(F);

% Compute the length of each edge
L = V(E(:,1), :) - V(E(:,2), :);
L = sqrt(sum(L.^2, 2));

% OPTIMIZE
cvx_begin
  variable f(N, N)
  maximize( sum(sum( f )))
  subject to
    diag(f) == 0
    f(E(:,1), :) - f(E(:, 2), :) <= repmat(L, 1, N)
    f(E(:,2), :) - f(E(:, 1), :) <= repmat(L, 1, N)
cvx_end

tsurf(F, V, 'CData', f(2, :));
shading interp;
axis off;