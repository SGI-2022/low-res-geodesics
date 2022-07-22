function Distance = pairwise_edge_geodesic(Verts, Faces)
  % Computes the geodesic distance between all pairs of verticies, 
  % with geodesic paths restricted to the edges of the mesh.
  %
  % Verts: A list of verticies
  % Faces: A list of faces

  % Get the number of verticies
  NumVerts = size(Verts, 1);

  % Get a list of edges
  % Note: Each edge appears only in one direction.
  Edges = edges(Faces);

  % Compute the edge vectors
  EdgeVectors = Verts(Edges(:,1), :) - Verts(Edges(:,2), :);

  % Compute the lengths of the edge vectors
  EdgeLengths = vecnorm(EdgeVectors, 2, 2);

  cvx_begin
    % Let the geodesic distance take all pairs of verticies to the real numbers
    variable Distance(NumVerts, NumVerts)
    
    % Maximize the integral of geodesic distance over all pairs of verticies
    maximize( sum(sum(Distance) )) 

    % With the following constraints
    subject to

      % The distance from a point it itself should be zero
      diag(Distance) == 0

      % Add the triangle inequality as a constraint to each edge
      % Basically: |i,k| - |j,k| <= |i,j| or |i,k| <= |i,j| + |j,k|
      % where k is an arbitrary vertex, and i and j are verticies connected
      % by an edge.
      % Note: repmat just repeats the edge-length vector, and is what makes
      % this work for all verticies 'k'.
      abs(Distance(Edges(:,1), :) - Distance(Edges(:, 2), :)) <= repmat(EdgeLengths, 1, NumVerts);

      % Note: In a previous version we did this. The following is required
      % if the weighting (or 'length') from i to j is different from the
      % weighting from j to i
      % Distance(Edges(:,1), :) - Distance(Edges(:, 2), :) <= repmat(EdgeLengths, 1, N)
      % Distance(Edges(:,2), :) - Distance(Edges(:, 1), :) <= repmat(EdgeLengths, 1, N)
  cvx_end

end