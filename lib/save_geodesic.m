function save_geodesic(Mesh, Method, Distance)
  save(strcat('./saves/', Mesh, '_', Method, '.geo_dist'), 'Distance')
end