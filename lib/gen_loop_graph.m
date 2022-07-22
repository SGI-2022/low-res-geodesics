function G = gen_loop_graph(N)
  % Generates a loop graph with N verticies
  S = 1:N;
  E = mod(S, N) + 1;

  G = graph(S, E, 1);
end