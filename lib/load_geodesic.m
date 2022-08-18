function Distance = load_geodesic(Mesh, Method)
  Distance = readmatrix(strcat('./saves/', Mesh, '_', Method, '.csv'));
end