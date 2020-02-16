one_city(RoadNetwork) :-
  [(a, [])] = RoadNetwork.


six_cities(RoadNetwork) :-
  [
    (a, [(b, 5), (f, 6)]),
    (b, [(a, 5), (e, 1), (c, 4)]),
    (c, [(b, 4), (f, 9), (d, 2)]),
    (d, [(e, 3), (c, 2), (f, 7)]),
    (e, [(b, 1), (d, 2)]),
    (f, [(a, 6), (c, 9), (d, 7)])
  ] = RoadNetwork.

% six_cities(R), member( (a, Edges), R), member((Edge, Cost), Edges).
% Edges = [(b, 5),  (f, 6)],
% Edge = b,
% Cost = 5
% ...

two_cities(RoadNetwork):-
  [
    (a, [(b, 2)]),
    (b, [(a,1)])
  ] = RoadNetwork.


solution(Path, RoadNetwork, SolutionCost, SolutionPath):-
  length(Path, 1),
  [FirstCity] = Path,
  member((FirstCity, Edges), RoadNetwork),
  member((Edge, Cost), Edges),
  \+member(Edge, Path),
  SolutionCost is 0 + Cost,
  NewPath = [FirstCity | Edge],
  solution(NewPath, RoadNetwork, SolutionCost, SolutionPath).

solution(Path, RoadNetwork, SolutionCost, SolutionPath):-
  [FirstCity] = Path,
  member((FirstCity, Edges), RoadNetwork),
  member((Edge, Cost), Edges),
  SolutionCost is 0 + Cost.
