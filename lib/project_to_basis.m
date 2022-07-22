function ProjectedDistance = project_to_basis(Distance, Basis)
  % Projects a geodesic distance function on a mesh into a basis on that 
  % mesh.
  %
  % Distance: A geodesic distance on a mesh
  % EigenBasis: A orthonormal basis of eigenvectors of the laplacian

  % Get the number of eigenvectors
  NumEigenVectors = size(Basis, 2);

  % Minimize reconstruction error in L_infinity
  cvx_begin
    variable ProjectedDistance(NumEigenVectors, 1)
    minimize( max( abs( Basis*ProjectedDistance - Distance ) ) )
  cvx_end
end