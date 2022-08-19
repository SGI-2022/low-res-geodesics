function[]= render_geodesic(txtfile_distances, objfile)
    fileID = fopen(txtfile_distances,'r');
    formatSpec = '%f';
    distances = fscanf(fileID,formatSpec);
    
    [V,F]=readOBJ(objfile);
    
    tsurf(F,V,'CData',distances);
    axis off;
    axis equal;
    shading interp;
end