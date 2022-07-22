function ProjectedDistance = projected_direct_geodesic(Verts, Faces, TargetVerts, Basis)
  % Computes the geodesic distance to any member of a target set of 
  % verticies, with geodesic paths not restricted to edges, and projected
  % to a given orthonormal basis.
  %
  % Verts: A list of verticies
  % Faces: A list of faces
  % TargetVerts: In indicies of the target set of verticies
  % Basis: An orthonormal basis

  % Hard-coded dimension
  Dimension = 3;

  % Get the number of verticies
  NumVerts = size(Verts, 1);

  % Get the number of faces
  NumFaces = size(Faces, 1);

  % Get the size of the basis
  NumBasisVectors = size(E, 2);

  % Compute the gradient matrix for the mesh
  Gradient = grad(V, F);

  cvx_begin
    % Let the projected distance be a vector in the basis
    variable ProjectedDistance(NumBasisVectors)
    
    % Maximize the integral of geodesic distance over all verticies
    maximize( sum(sum(Basis * ProjectedDistance) )) 

    % With the following constraints
    subject to

      % The distance to the target set from the target set should be zero
      Basis(TargetVerts, :) * ProjectedDistance <= 0

      % Constrain the gradient of distance to be less than 1
      % Basically: |ΔD| <= 1
      % Note: Gradient is really a tensor, and this call to reshape is
      % makes it behave like a tensor product which spits out a vector 
      % for each face. Then we take the norm of that vector, and this is
      % the quantityt we want to restict to be less than 1.
      norms(reshape(Gradient*Basis*ProjectedDistance, NumFaces, Dimension, NumVerts), 2, 3) <= 1
  cvx_end

end