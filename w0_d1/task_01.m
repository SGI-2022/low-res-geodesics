N = 100;
G = line_graph(N);

% Select a random edge to be Gamma
% Gamma = randi(N, 1);

S = randi(N, 1);
E = randi(N, 1);

shortest_path(G, S, E)

Edges = G.Edges

% Make computer to optimization good
cvx_begin
  variable f(N, N)
  maximize( sum(sum( f )) )
  subject to
    diag(f) == 0
    for k=1:N
      f(Edges.EndNodes(:,1), k) - f(Edges.EndNodes(:,2), k) <= Edges.Weight(:)
      f(Edges.EndNodes(:,2), k) - f(Edges.EndNodes(:,1), k) <= Edges.Weight(:)
    end
cvx_end