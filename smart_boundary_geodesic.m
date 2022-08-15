% Computes a variant of the geodesic using a smart boundary constraint to
% avoid errors at the target verticies.

% Instead of a constraint at the target vertex 
%
%       D(Target, Target) <= 0 
%
% we constrain the distance along all edges which contain one boundary 
% vertex and one non-boundary vertex, eg.
%
%       D(Target, Neighbor) <= EdgeLength(Target, Neighbor)
%
% for all neighbors of the target point.

% At the moment, this is not pairwise. Creating these constraints for the
% pairwise geodesic may require a little cair.

% Based on `projected_direct_geodesic`

function Distance = smart_boundary_geodesic(Verts, Faces, TargetVerts, Basis)
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
  NumBasisVectors = size(Basis, 2);

  % Compute the gradient matrix for the mesh
  Gradient = grad(Verts, Faces);

  % Compute the compute the 1 ring of each vertex
  Vring = compute_vertex_ring(Faces);

  % Construct minimum-distance information around the target verticies
  NeighborEdgeDist = zeros(NumVerts, 1);

  % Note: There may be a vectorized way to do this, but I'm not sure 
  % what it is.
  % First, iterate over all the target verticies
  for I = 1:length(TargetVerts)
    % Then iterate over the ring of surrounding verticies
    Neighbors = Vring(TargetVerts(I));
    Neighbors = Neighbors{1}; % GPToolbox returns this in a weird format that we have to unwrap
    for J = 1:length(Neighbors)
      Neighbors(J);
      % Compute the distance between the target and the neighbor
      EdgeDist = norm(Verts(TargetVerts(I)) - Verts(Neighbors(J)));
      % If its shorter than the current value, use the new distance
      if NeighborEdgeDist(Neighbors(J)) == 0 || EdgeDist < NeighborEdgeDist(Neighbors(J))
        NeighborEdgeDist(Neighbors(J)) = EdgeDist;
      end
    end
  end

  % To be extra sure that we don't add constraints to the target set,
  % we zero it out in the new list of distances.
  NeighborEdgeDist(TargetVerts) = 0;

  % Now we have a sparse list of distances, containing zeros for verticies
  % which do not surround the target set. To recover the list of neighbor 
  % indicies, we just need the nonzero elements of the list.
  NeighborVerts = find(NeighborEdgeDist)

  cvx_begin
    % Let the projected distance be a vector in the eigen-basis
    variable ProjectedDistance(NumBasisVectors)
    
    % Maximize the integral of geodesic distance over all verticies
    maximize( sum(sum(Basis * ProjectedDistance) )) 

    % With the following constraints
    subject to

      % The distance to the target set from the target set should be zero
      Basis(TargetVerts, :) * ProjectedDistance <= 1 % Weird idea, but its an easy error to correct

      % Introduce our smart constraints here!
      Basis(NeighborVerts, :) * ProjectedDistance >= NeighborEdgeDist(NeighborVerts)

      % Constrain the gradient of distance to be less than 1
      % Basically: |ΔD| <= 1
      % Note: Gradient is really a tensor, and this call to reshape is
      % makes it behave like a tensor product which spits out a vector 
      % for each face. Then we take the norm of that vector, and this is
      % the quantity we want to restict to be less than 1.
      norms(reshape(Gradient*Basis*ProjectedDistance, NumFaces, Dimension, 1), 2, 3) <= 1
  cvx_end

  % Here we can try cheating a little, and modifying the solution after the
  % solver finishes
  Distance = Basis * ProjectedDistance;
  %Distance(TargetVerts) = 0;
  %Distance(NeighborVerts) = NeighborEdgeDist(NeighborVerts);

end