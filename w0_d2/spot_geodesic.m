
% Load in mesh
[V,F] = readOBJ('spot.obj');

% Get the number of verticies
N = length(V);

% Get a list of edges
E = edges(F);

% Compute the length of each edge
L = V(E(:,1)) - V(E(:,2));

f = zeros(N, N);

% OPTIMIZE
cvx_begin
  variable f(N, N)
  maximize( sum(sum( f )))
  subject to
    diag(f) == 0
    f(E(:,2), :) - f(E(:, 1), :) <= repmat(L, 1, N)
%     for k=1:N
%       f(E(:,1), k) - f(E(:,2), k) <= L(:)
%       % f(E(:,2), k) - f(E(:,1), k) <= L
%     end
cvx_end