
[V,F] = readOBJ('spot.obj');

N = length(V);

E = edges(F);

L = V(E(:,1)) - V(E(:,2));

cvx_begin
  variable f(N, N)
  maximize( sum(sum( f )))
  subject to
    diag(f) == 0
    for k=1:N
      f(E(:,1), k) - f(E(:,2), k) <= L(:)
      % f(E(:,2), k) - f(E(:,1), k) <= L
    end
cvx_end