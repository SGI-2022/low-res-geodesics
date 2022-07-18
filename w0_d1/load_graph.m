function G = load_graph(N)
  t = triu(2*randn(N,N),1);
  A = max(t+t.', 0);
  G = graph(A);
end