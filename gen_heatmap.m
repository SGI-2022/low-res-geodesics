
NumFaceSteps = 5;
FacesStepSize = 5;

NumBasisSteps = 5;
BasisStepSize = 5;

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_mini.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
FullBasis = laplacian_eigenbasis(Verts, Faces, NumBasisSteps * BasisStepSize);

% Select some target verticies
TargetVerts = 1;

% Compute the ground truth geodesic distance
GroundTruthDistance = geodesic(Verts, Faces, TargetVerts);

MeanError = zeros(NumFaceSteps, NumBasisSteps);

for FaceStep = 1:NumFaceSteps
  for BasisStep = 1:NumBasisSteps
    
    Basis = FullBasis(:, 1:BasisStep*BasisStepSize);
    ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, 100, FaceStep * FacesStepSize);
    AproxDistance = Basis(:, :) * ProjectedDistance * Basis(TargetVerts, :).';

    % Drop the distance at the target vert, it won't worth with relitive
    % error
    PinpointGroundTruthDistance = GroundTruthDistance(1:end ~= TargetVerts);
    PinpointAproxDistance = AproxDistance(1:end ~= TargetVerts);
    ErrorVec = abs((PinpointGroundTruthDistance - PinpointAproxDistance) ./ PinpointGroundTruthDistance);
    MeanError(FaceStep, BasisStep) = sum(ErrorVec) / size(Verts, 1);
  end
end