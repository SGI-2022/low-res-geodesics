function ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, NumVertSamples, NumFaceSamples)
  % Computes the geodesic distance between all pairs of verticies, with 
  % geodesic paths not restricted to edges, and projected to a given 
  % orthonormal basis.
  %
  % Verts: A list of verticies
  % Faces: A list of faces
  % Basis: An orthonormal basis

  % Hard-coded dimension
  Dimension = 3;

  % Get the number of verticies
  NumVerts = size(Verts, 1);

  % Get the number of faces
  NumFaces = size(Faces, 1);

  % Get the size of the basis
  NumBasisVectors = size(Basis, 2);

  % Sample a random number of faces.
  FaceSamples = randperm(NumFaces, NumFaceSamples);
  VertSamples = randperm(NumVerts, NumVertSamples);

  % Precompute the gradient matrix for the mesh
  Gradient = grad(Verts, Faces);  
  GradientSamples = [ FaceSamples, FaceSamples + NumFaces, FaceSamples + 2*NumFaces ];
  MiniGrad = Gradient(GradientSamples, VertSamples);

  MiniBasis = Basis(VertSamples, :);

  % Precompute the summation matrix
  OneVec = ones(NumVerts);
  S = (Basis.' * OneVec) * (OneVec.' * Basis);

  cvx_begin

    variable ProjectedDistance(NumBasisVectors, NumBasisVectors) symmetric
    
    % Maximize the integral of geodesic distance over all verticies
    maximize( trace( ProjectedDistance * S ) )

    % With the following constraints
    subject to

      % The distance to the target set from the target set should be zero
      % Note: Should be more efficent than `diag` for large matricies
      for i = 1:NumVerts
        Basis(i,:)*ProjectedDistance*Basis(i,:).' <= 0
      end

      % Constrain the gradient of distance to be less than 1
      % Basically: |ΔD| <= 1
      % Note: Gradient is really a tensor, and this call to reshape is
      % makes it behave like a tensor product which spits out a vector 
      % for each face. Then we take the norm of that vector, and this is
      % the quantity we want to restict to be less than 1.
      MiniDist = MiniBasis*ProjectedDistance*MiniBasis.';
      norms(reshape(MiniGrad*MiniDist, NumFaceSamples, Dimension, NumVertSamples), 2, 2) <= 1
  cvx_end

end