/*
This file  is used to load all the files needed to load the files
necessary to run the blind search, you can modify it to add whatever
testfiles you want loaded.

*/
:- [solution, tsp, h].

nativeProblem(domainProblem([a,
			     [(a, [(b, 5), (f, 6)]),
			      (b, [(a, 5), (e, 1), (c, 4)]),
			      (c, [(b, 4), (f, 9), (d, 2)]),
			      (d, [(e, 3), (c, 2), (f, 7)]),
			      (e, [(b, 1), (d, 2)]),
			      (f, [(a, 6), (c, 9), (d, 7)])]])).

exampleA(Cost, Path) :-
    nativeProblem(NativeProblem),
    solution(NativeProblem, Cost, Path).

exampleB(C,P) :-
    solution(domainProblem([a, [(a, [])]]), C, P).

exampleC(C, P) :-
    solution(domainProblem([a,[(a, [(b, 2)]),(b, [(a,1)])]]), C, P).

example1(
    [(a, [(b, 12), (c, 10), (d, 19), (e, 8)]),
    (b, [(a, 12), (c, 3), (d, 7), (e, 2)]),
    (c, [(a, 10), (b, 3), (d, 6), (e, 20)]),
    (d, [(a, 19), (b, 7), (c, 6), (e, 4)]),
    (e, [(a, 8), (b, 2), (c, 20), (d, 4)])]).

example2(
    [(a, [(b, 14), (c, 15), (d, 4), (e, 9)]),
    (b, [(a, 14), (c, 18), (d, 5), (e, 13)]),
    (c, [(a, 15), (b, 18), (d, 19), (e, 10)]),
    (d, [(a, 4), (b, 5), (c, 19), (e, 12)]),
    (e, [(a, 9), (b, 13), (c, 10), (d, 12)])]).

example3(
    [(a, [(b, 5), (c, 7), (d, 7), (e, 10)]),
    (b, [(a, 5), (c, 2), (d, 3), (e, 3)]),
    (c, [(a, 7), (b, 2), (d, 5), (e, 10)]),
    (d, [(a, 7), (b, 3), (c, 5), (e, 4)]),
    (e, [(a, 10), (b, 3), (c, 10), (d, 4)])]).

example4(
    [(a, [(b, 12), (c, 29), (d, 22), (e, 13), (f, 24)]),
    (b, [(a, 12), (c, 19), (d, 3), (e, 25), (f, 6)]),
    (c, [(a, 29), (b, 19), (d, 21), (e, 23), (f, 28)]),
    (d, [(a, 22), (b, 3), (c, 21), (e, 4), (f, 5)]),
    (e, [(a, 13), (b, 25), (c, 23), (d, 4), (f, 16)]),
    (f, [(a, 24), (b, 6), (c, 28), (d, 5), (e, 16)])]).

example5(
    [(a, [(b, 12), (c, 14), (d, 17)]),
    (b, [(a, 12), (c, 15), (d, 18)]),
    (c, [(a, 14), (b, 15), (d, 29)]),
    (d, [(a, 17), (b, 18), (c, 29)])]).

runExample(ExName, SolutionCost, SolutionPath, NodesExpanded) :-
    Example =.. [ExName, RoadNetwork],
    call(Example),
    solution(domainProblem([a, RoadNetwork]),
	     SolutionCost,
	     SolutionPath),
    counter(expanded, NodesExpanded).
