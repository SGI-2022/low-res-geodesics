NumFaceSteps = 5;
FacesStepSize = 5;

NumBasisSteps = 5;
BasisStepSize = 5;

NumBasisVectors = NumBasisSteps * BasisStepSize;

NumVertSamples = 100;

meshname= 'spot_josue'
% Load in mesh
[Verts, Faces] = readOBJ(strcat('data/', meshname, '.obj'));

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
FullBasis = laplacian_eigenbasis(Verts, Faces, NumBasisVectors);

% Select some target vertices
TargetVert = 1;

for FaceStep = 1:NumFaceSteps
  for BasisStep = 1:NumBasisSteps
    
    Basis = FullBasis(:, 1:BasisStep*BasisStepSize);
    ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, 130, FaceStep * FacesStepSize);
    ApproxDistance = Basis * ProjectedDistance * Basis.';
    writematrix(ApproxDistance, strcat('./ApproxDistance/', meshname, '_B',int2str(BasisStep*BasisStepSize) , '_V', int2str(NumVertSamples), '_F', int2str(FaceStep * FacesStepSize), '.csv'))
  end
end

