function Heatmap = generate_heatmap(filename, min, max)
    M=readmatrix(filename);
    Heatmap = heatmap(M, 'ColorLimits',[min, max])
end
