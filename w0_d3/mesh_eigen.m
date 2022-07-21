function E = mesh_eigen(V, F, K)
  
  % Compute the Laplacian using the cotangent-matrix.
  C = -cotmatrix(V,F);
 
  % Compute the mass matrix.
  M = massmatrix(V,F);

  [E, D] = eigs(C, M, K, 'smallestabs'); % Returns the K smallest eigenfunctions

  % Solve
  % cotan_lapplace * c = lambda * mass_matrix * x
  % w/ eigs()
end