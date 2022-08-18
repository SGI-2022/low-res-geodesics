function Distance = load_geodesic(Mesh, Method)
  Distance = readmatrix(trcat('./saves/', Mesh, '_', Method, '.geo_dist'));
end