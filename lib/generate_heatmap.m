function Heatmap = generate_heatmap()
    tbl = readtable('saved.csv')
    Heatmap = heatmap(tbl, 'Eigenvectors', 'Faces', 'ColorVariable','Error');
end
