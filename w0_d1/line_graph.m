function G = line_graph(N)
  % Generates a line graph with N verticies
  S = 1:N;
  E = mod(S, N) + 1;

  G = graph(S, E, 1);
end