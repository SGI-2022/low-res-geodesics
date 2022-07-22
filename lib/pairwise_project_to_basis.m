function ProjectedDistance = pairwise_project_to_basis(Distance, Basis)
  % Projects a pairwise geodesic distance function on a mesh into a basis 
  % on that mesh.
  %
  % Distance: A pairwise geodesic distance on a mesh
  % EigenBasis: A orthonormal basis of eigenvectors of the laplacian

  % Get the number of verticies
  NumVerts = size(Basis, 1);

  % Get the number of eigenvectors
  NumBasisVectors = size(Basis, 2);

  % Minimize reconstruction error in L_infinity
  cvx_begin
    variable ProjectedDistance(NumEigenVectors, NumVerts) symmetric
    minimize( max( abs( Basis*ProjectedDistance - Distance ) ) )
  cvx_end
end