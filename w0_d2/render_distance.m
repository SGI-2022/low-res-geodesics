function render_distance(V, F, D)
  tsurf(F, V, 'CData', D);
  shading interp;
  axis equal;
  axis off;
  shading interp;
  camproj('perspective')
end