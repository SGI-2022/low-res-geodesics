function Distance = load_geodesic(Mesh, Method)
  Distance = load(trcat('./saves/', Mesh, '_', Method, '.geo_dist'));
end