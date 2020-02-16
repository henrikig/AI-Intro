% Example:
% ?- solution([a], [(a, [(b, 5), (f, 6)]), (b, [(a, 5), (e, 1), (c, 4)]), (c, [(b, 4), (f, 9), (d, 2)]), (d, [(e, 3), (c, 2), (f, 7)]), (e, [(b, 1), (d, 2)]), (f, [(a, 6), (c, 9), (d, 7)])], SolutionCost, SolutionPath).

% Solution for RoadNetwork with only one city
solution(Path, RoadNetwork, SolutionCost, SolutionPath):-
  length(RoadNetwork, 1),
  SolutionCost = 0,
  append(Path, Path, SolutionPath).


% Solving when RoadNetwork > 1 and Path only contains starting city
solution(Path, RoadNetwork, SolutionCost, SolutionPath):-
  length(Path, 1),
  [City] = Path,
  member((City, Roads), RoadNetwork),
  member((Road, _), Roads),
  solution([Road | Path], RoadNetwork, SolutionCost, SolutionPath).


% Finding next city when Path > 1 and not all cities have been visited
solution(Path, RoadNetwork, SolutionCost, SolutionPath):-
  [City | _Tail] = Path,
  member((City, Roads), RoadNetwork),
  member((Road, _), Roads),
  \+member(Road, Path),
  solution([Road | Path], RoadNetwork, SolutionCost, SolutionPath).


% Finding way back to starting city when all cities have been visited
solution(Path, RoadNetwork, SolutionCost, SolutionPath):-
  length(Path, Length),
  length(RoadNetwork, Length),
  reverse(Path, FinalPath),
  [FinalCity | _] = Path,
  member((FinalCity, Roads), RoadNetwork),
  member((Road, _), Roads),
  [StartingCity | _] = FinalPath,
  Road == StartingCity,
  append(FinalPath, [StartingCity], SolutionPath),
  find_solution_cost(SolutionPath, RoadNetwork, SolutionCost).


% Base case of SolutionCost calculation when only two cities are left in calculation path
find_solution_cost([CityOne, CityTwo], RoadNetwork, Sum):-
  member((CityOne, Roads), RoadNetwork),
  member((CityTwo, RoadCost), Roads),
  Sum is  0 + RoadCost.


% Recursive calculation of SolutionPath
find_solution_cost(FinalPath, RoadNetwork, Sum) :-
  [FirstCity, SecondCity | RestCities] = FinalPath,
  member((FirstCity, Roads), RoadNetwork),
  member((SecondCity, RoadCost), Roads),
  find_solution_cost([SecondCity | RestCities], RoadNetwork, Rest),
  Sum is RoadCost + Rest.
