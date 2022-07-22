function Distance = pairwise_geodesic(Verts, Faces)
  % Computes the geodesic distance between all pairs of verticies, 
  % with geodesic paths not restricted to edges.
  %
  % WARNING: Very slow for large models
  %
  % Verts: A list of verticies
  % Faces: A list of faces

  % Hard-coded dimension
  Dimension = 3;

  % Get the number of verticies
  NumVerts = size(Verts, 1);

  % Get the number of faces
  NumFaces = size(Faces, 1);

  % Compute the gradient matrix for the mesh
  Gradient = grad(V, F);

  cvx_begin
    % Let the geodesic distance take all pairs of verticies to the real numbers
    variable Distance(NumVerts, NumVerts)
    
    % Maximize the integral of geodesic distance over all pairs of verticies
    maximize( sum(sum(Distance) )) 

    % With the following constraints
    subject to

      % The distance from a point it itself should be zero
      diag(Distance) <= 0

      % Constrain the gradient of distance to be less than 1
      % Basically: |ΔD| <= 1
      % Note: Gradient is really a tensor, and this call to reshape is
      % makes it behave like a tensor product which spits out a vector 
      % for each face. Then we take the norm of that vector, and this is
      % the quantityt we want to restict to be less than 1.
      norms(reshape(Gradient*Distance, NumFaces, Dimension, NumVerts), 2, 3) <= 1
  cvx_end

end