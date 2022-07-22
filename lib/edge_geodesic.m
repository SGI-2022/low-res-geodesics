function Distance = edge_geodesic(Verts, Faces, TargetVerts)
  % Computes the geodesic distance to any member of a target set of 
  % verticies, with geodesic paths restricted to the edges of the mesh.
  %
  % Verts: A list of verticies
  % Faces: A list of faces
  % TargetVerts: In indicies of the target set of verticies

  % Get the number of verticies
  NumVerts = size(1, Verts);

  % Get a list of edges
  % Note: Each edge appears only in one direction.
  Edges = edges(Faces);

  % Compute the edge vectors
  EdgeVectors = Verts(Edges(:,1), :) - Verts(Edges(:,2), :);

  % Compute the lengths of the edge vectors
  EdgeLengths = vecnorm(EdgeVectors, 2, 2);

  cvx_begin
    % Let the geodesic take verticies to the real numbers
    variable Distance(NumVerts)
    
    % Maximize the integral of geodesic over all verticies
    maximize( sum(Distance) ) 

    % With the following constraints
    subject to

      % The distance to the target set from the target set should be zero
      Distance(TargetVerts) == 0

      % Add the triangle inequality as a constraint to each edge
      % Basically: |i,k| - |j,k| <= |i,j| or |i,k| <= |i,j| + |j,k|
      % where k is the closest vertex in the target set and i and j are
      % connected by an edge.
      abs(Distance(Edges(:,1)) - Distance(Edges(:, 2))) <= EdgeLengths;

      % Again, this assumes edge lengths are the same in both directions.
      % See `pairwise_edge_geodesic` for an example of what to do when this
      % is not the case
  cvx_end

end