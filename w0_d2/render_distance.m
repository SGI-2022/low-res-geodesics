function render_distance(V, F, D)
  % Renders a distance function on a surface

  tsurf(F, V, 'CData', D);
  shading interp;
  axis equal;
  axis off;
  axis auto;
  shading interp;
  camproj('perspective')
end