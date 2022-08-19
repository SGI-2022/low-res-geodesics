function ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis,NumVertSamples, NumFaceSamples)
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

  % Precompute the summation matrix
  OneVec = ones(NumVerts);
  S = (Basis.' * OneVec) * (OneVec.' * Basis);

  cvx_begin

    variable ProjectedDistance(NumBasisVectors, NumBasisVectors) symmetric
    
    % Maximize the integral of geodesic distance over all verticies
    maximize( sum(sum( ProjectedDistance .* S )) ) 
    % According to the following, this is the most efficent way to do this
    % https://stackoverflow.com/questions/8031628/octave-matlab-efficient-calc-of-frobenius-inner-product

    % With the following constraints
    subject to

      % Smart/stupid extra constraint idea: Enforce the triangle inequality
%       for i = 1:NumVertSamples
%         for j = (i+1):NumVertSamples
%           u = VertSamples(i);
%           v = VertSamples(j);
%           n = VertSamples([1:i i:j j:end]);
%           % Calculate distance from u to every other sample point
%           UDist = Basis(u, :)*ProjectedDistance*Basis(n, :).';
%           % Calculate distance from v to every other sample point
%           VDist = Basis(v, :)*ProjectedDistance*Basis(n, :).';
%           % Calculate the current distance between u and v
%           UVDist = Basis(u, :)*ProjectedDistance*Basis(v, :).';
%           % Bound that distance with the Triangle Inequality
%           UVDist <= UDist + VDist;
%         end
%       end

      % The distance to the target set from the target set should be zero
      % Note: Should be more efficent than `diag` for large matricies
      % for i = 1:NumVerts
      %   Basis(i,:)*ProjectedDistance*Basis(i,:).' <= 0
      % end
      sum(Basis*ProjectedDistance.*Basis, 2) <= 0 
      % See https://www.mathworks.com/matlabcentral/answers/31864-calculating-diagonal-elements-of-a-matrix-product-without-a-loop-or-redundant-calculations

      % Constrain the gradient of distance to be less than 1
      % Basically: |ΔD| <= 1
      % Note: Gradient is really a tensor, and this call to reshape is
      % makes it behave like a tensor product which spits out a vector 
      % for each face. Then we take the norm of that vector, and this is
      % the quantity we want to restict to be less than 1.
      DistGrad = (Gradient(GradientSamples, :) * Basis) * (ProjectedDistance * Basis(VertSamples, :).');
      GradNorm=norms(reshape(DistGrad, NumFaceSamples, Dimension, NumVertSamples), 2, 2);
      V=GradNorm(:);
      samples= randperm(size(V,1), 100);
      V_samples= V(samples);
      V_samples<=1;

  cvx_end

end