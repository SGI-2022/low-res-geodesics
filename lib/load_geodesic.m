function Distance = load_geodesic(Mesh, Method)
  Distance = readmatrix(trcat('./saves/', Mesh, '_', Method, '.csv'));
end