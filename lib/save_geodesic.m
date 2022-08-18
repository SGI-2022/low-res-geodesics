function save_geodesic(Mesh, Method, Distance)
  writematrix(Distance, strcat('./saves/', Mesh, '_', Method, '.geo_dist'))
end