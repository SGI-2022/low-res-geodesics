function C = project(D, E)
  % D: geodesic distance [#Verts] 
  % E: eigenvector space [#verts x #eigenvectors]

  % Var C(#Eigenfunctions)
  % Minimize Err = max(abs(E*C - D))

  N = size(E, 2);

  cvx_begin
    variable C(N, 1) % [eigenvectors]
    minimize( max( abs( E*C - D ) ) )
  cvx_end
end