
NumFaceSteps = 10;
FacesStepSize = 5;

NumBasisSteps = 10;
BasisStepSize = 5;

% Load in mesh
[Verts, Faces] = readOBJ('data/spot_mini.obj');

% Swap forward axis
Verts = [Verts(:,1), Verts(:,3), Verts(:,2)];

% Compute a basis on the mesh
FullBasis = laplacian_eigenbasis(Verts, Faces, NumBasisSteps * BasisStepSize);

% Select some target vertices
TargetVerts = 1;

% Compute the ground truth geodesic distance
GroundTruthDistance = geodesic(Verts, Faces, TargetVerts);

MeanError = zeros(NumFaceSteps, NumBasisSteps);

for FaceStep = 1:NumFaceSteps
  for BasisStep = 1:NumBasisSteps
    
    Basis = FullBasis(:, 1:BasisStep*BasisStepSize);
    ProjectedDistance = pairwise_sparse_geodesic(Verts, Faces, Basis, 130, FaceStep * FacesStepSize);
    ApproxDistance = Basis(:, :) * ProjectedDistance * Basis(TargetVerts, :).';

    Method = strcat('heatmap', string(FaceStep), '-', string(BasisStep));
    %save_geodesic('spot_mini', Method, ApproxDistance);

    % Drop the distance at the target vert, it won't work with relative
    % error
    PinpointGroundTruthDistance = GroundTruthDistance(1:end ~= TargetVerts);
    PinpointAproxDistance = ApproxDistance(1:end ~= TargetVerts);
    ErrorVec = abs((PinpointGroundTruthDistance - PinpointAproxDistance) ./ PinpointGroundTruthDistance);
    MeanError(FaceStep, BasisStep) = sum(ErrorVec) / size(Verts, 1);
  end
end

save_error_matrix('spot_mini', Method, MeanError)
h=heatmap(MeanError, 'ColorLimits', [0, 1.5])
generate_heatmap('Error_Matrices/spot_mini_heatmap10-10.csv', 0, 1.5)

%imagesc(MeanError)