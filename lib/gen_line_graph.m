function G = gen_line_graph(N)
  % Generates a line graph with N verticies
  S = 1:(N-1);
  E = S + 1;

  G = graph(S, E, 1);
end