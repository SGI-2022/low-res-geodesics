function G = load_graph(N)
  % Takes in a number of edges and generates
  % a weighted undirected graph (by first creating
  % a random positive-definite triangular matrix).
  t = triu(2*randn(N,N),1);
  A = max(t+t.', 0);
  G = graph(A);
end