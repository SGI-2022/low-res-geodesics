function EigenBasis = laplacian_eigenbasis(Verts, Faces, NumEigenVectors)
  
  % Compute the Laplacian using the cotangent-matrix for the mesh.
  Cot = -cotmatrix(Verts, Faces);
 
  % Compute the mass matrix for the mesh.
  Mass = massmatrix(Verts, Faces);

  % Returns the the smallest k eigenvectors of the Lapplacian
  [EigenBasis, ~] = eigs(Cot, Mass, NumEigenVectors, 'smallestabs'); 
end