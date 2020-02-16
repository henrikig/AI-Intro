:- use_module(library(lists)).

notStartState(State,StartState):-
not(State=StartState).

% state_visitingCity(State, StartData),
h(State,RoadNetwork,HValue) :-
(length(RoadNetwork,LR),LR=0 ->  HValue=0);(
state_visitingCity(State, StartCity),
StartData = [StartCity:0],
dict_create(Dict, Tag, StartData),
Visited = [],
h2(State,RoadNetwork,Dict,Visited,[State],HValue)).

h2(State,RoadNetwork,Dict,Visited,AddedNodes,HValue):-
(length(RoadNetwork,LenRN), length(Visited,VLen), VLen=LenRN -> addUp(Dict,AddedNodes,HValue));(
member((NewNode,NewEdges),RoadNetwork), not(member(NewNode,Visited)),
addAllAdj(State,NewEdges,[],Dict,AddedNodes,FinAddedNodes,NewDict),
append([NewNode],Visited,NewVisited),
h2(State,RoadNetwork,NewDict,NewVisited,FinAddedNodes,HValue)).

addAllAdj(State,NewEdges,VisitedAdj,Dict,IntAdd,AddedNodes,NewDict):-
((numOfNonInt(NewEdges,LenNE),length(VisitedAdj,VisAL),LenNE=VisAL) -> AddedNodes=IntAdd, NewDict = Dict);(
((member((NewAdjNode,NewCost),NewEdges), not(member(NewAdjNode,VisitedAdj)),
notStartState(NewAdjNode,State),not(member(NewAdjNode,IntAdd))) ->  Data = [NewAdjNode:NewCost],
append([NewAdjNode],IntAdd,NewAdded),put_dict(Data,Dict,NewDictOut), append([NewAdjNode],VisitedAdj,NewVisitedAdj),
addAllAdj(State,NewEdges,NewVisitedAdj,NewDictOut,NewAdded,AddedNodes,NewDict));
(( member((NewAdjNode,NewCost),NewEdges), not(member(NewAdjNode,VisitedAdj)),
notStartState(NewAdjNode,State),get_dict(NewAdjNode,Dict,Value),NewCost<Value) ->
Data = [NewAdjNode:NewCost],
put_dict(Data,Dict,NewDictOut), append([NewAdjNode],VisitedAdj,NewVisitedAdj),
addAllAdj(State,NewEdges,NewVisitedAdj,NewDictOut,IntAdd,AddedNodes,NewDict));(
append([NewAdjNode],VisitedAdj,NewVisitedAdj),addAllAdj(State,NewEdges,NewVisitedAdj,Dict,IntAdd,AddedNodes,NewDict))).

numOfNonInt(Xs,Num):-
numOfNonInt(Xs,0,Num).

numOfNonInt([],Num,Num).
numOfNonInt([X|Xs],Int,Num):-
(not(integer(X))->
IntInt is Int + 1,
numOfNonInt(Xs, IntInt, Num));
numOfNonInt(Xs,Int,Num).

addUp(Dict,AddedNodes,Sum):-
addUp2(Dict,AddedNodes,[],0,Sum).

addUp2(Dict,AddedNodes,Traversed,IntSum,Sum):-
(length(Traversed,LenTrav),length(AddedNodes,LenPN), LenPN=LenTrav ->  Sum=IntSum);(
member(Node,AddedNodes), not(member(Node,Traversed)),
state_visitingCity(Node, City),
get_dict(City,Dict,Value) -> append([City],Traversed,NewTrav),NewSum is IntSum + Value,addUp2(Dict,AddedNodes,NewTrav,NewSum,Sum)).
