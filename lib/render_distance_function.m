function render_distance_function(Verts, Faces, Distance, TargetVerts)
  % Renders a distance function on a surface, and plots the target
  % points.

  tsurf(Faces, Verts, 'CData', Distance);
  shading interp;
  axis equal;
  axis off;
  axis auto;
  shading interp;
  camproj('perspective');
  hold on;
  scatter3(Verts(TargetVerts, 1), Verts(TargetVerts, 2), Verts(TargetVerts, 3), 'red', 'filled');
end