N = 20;
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
    % TODO: f(i,k) - f(j,k) <= G(i,j) if G(i,j) > 0

    % ( f(i,k) - f(j,k) ) * (1 - kron(G(i,j), 0)) < G(i,j)
    % F*A - F*B < G

%     for k=1:N
%       % something(f, k) * (1 - kron(G, 0)) <= G
%       for i=1:N
%         for j=1:N
%           
%         end
%       end
%     end

    for k=1:N
      for i=1:size(Edges,1)
        f(Edges.EndNodes(i,1), k) - f(Edges.EndNodes(i,2), k) <= Edges.Weight(i)
        f(Edges.EndNodes(i,2), k) - f(Edges.EndNodes(i,1), k) <= Edges.Weight(i)
      end
    end
cvx_end