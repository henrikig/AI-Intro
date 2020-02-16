:- use_module(library(record)).


/* ******************  load domain ************************
used to load the domain.pl file which contains information about
static and metaLevel predicates and the domain operators
to load the file contains problems
and to load the heuristic
*/

loadDomain(DomainName, ProblemId, HeuristicFile) :-
    string_concat(DomainName, "/domain", DomainPath),
    [DomainPath],
    string_concat(DomainName, "/problems", ProblemPath),
    [ProblemPath],
    ld_problem(ProblemId),
    string_concat(DomainName, "/", DomainDir),
    string_concat(DomainDir, HeuristicFile, HeuristicPath),
    [HeuristicPath].
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*             -- plan --
a plan is list of steps
*/
/*             -- step --
a step is an instantiated operator which has
- opName
- opParams
- stepCost
*/
:- record step(opName, opParams, stepCost).



/*              -- state --
states are ordset lists, they need to be duplicate free so that adding
 * & removing a term to a state is predicatable (if duplicates are
 *allowed then sometimes removing a term may not remove all occurences
 *of that term),  specifically states need to have a
 *canonical (i.e., a unique) representation so that they can be used
 *to access items in the closed list.
*/

make_State(Conditions, State) :-
    list_to_ord_set(Conditions, State).


/* satisfy(+Goals, +State)

Goals is a (possibly empty) list of Goal
each Goal has a GoalPred, an Arity, and Arguments

if GoalPred is positive
then if GoalPred is metaLevel
     then we can test it by directly executing its definition
     elseif GoalPred is static
     then look in initial state
     else look in current state
else Goal = not(InnerGoal)
     test InnerGoal
*/

%%% ***** this is where you put your satisfy(+Goals, +State) code *****

satisfy([],_).

satisfy([Goal | Rest], State) :-
  satisfies(Goal, State),
  satisfy(Rest, State).

/* Checks for meta level goal */
satisfies(Goal, State) :-
  functor(Goal, Name, Arity),
  A =.. [/, Name, Arity],
  metaLevelPreds(Preds),
  member(A, Preds),
  call(Goal).

/* Checks for positive static goal */
satisfies(Goal, State) :-
  functor(Goal, Name, Arity),
  A =.. [/, Name, Arity],
  staticPreds(Preds),
  member(A, Preds),
  problem_initState(InitState),
  member(Goal, InitState).


/* Checks for negative goal */
satisfies(Goal, State):-
  Goal = not(A),
  \+satisfies(A, State).

/* Checks for positive fluent goal */
satisfies(Goal, State):-
  \+(Goal = not(A)),
  member(Goal, State).


/* satisfyGoal(State)

Tests whether State satisfies this problem's goal
*/

%%% ***** this is where you put your satisfyGoal(+State) code *****

satisfyGoal(State) :-
  problem_goals(Goals),
  satisfy(Goals, State).


/*fluentsOutFrom(+Conditions, -Fluents)

Removes the fluents from list of conditions
*/
/* Base case */
fluentsOutFrom([], Fluents):-
  append([], [], Fluents).

/* Case where the current condition is fluent */
fluentsOutFrom([FirstCondition | Rest], Fluents):-
  staticPreds(Preds),
  functor(FirstCondition, Name, Arity),
  A =.. [/, Name, Arity],
  member(A, Preds),
  fluentsOutFrom(Rest, FluentsRest),
  Fluents = FluentsRest.

/* Case where the current condition is not fluent */
fluentsOutFrom([FirstCondition | Rest], Fluents):-
  staticPreds(Preds),
  functor(FirstCondition, Name, Arity),
  A =.. [/, Name, Arity],
  \+ member(A, Preds),
  fluentsOutFrom(Rest, FluentsRest),
  Fluents = [FirstCondition | FluentsRest].




/* %%%%%%%%%%%%%%%%%%%%

problem data structure

%%%:- record problem(name, initState, goals).

currently the current problem is stored in the prolog database
so that it is easily accessible from various parts of the program
without needing to pass it as a parameter

*/
make_Problem(Name, InitConds, Goals, problem(Name, InitState, Goals)) :-
    list_to_ord_set(InitConds, InitState).

problem_name(Name) :- problem(Name, _,_).
problem_initState(InitState) :- problem(_,InitState, _).
problem_goals(Goals) :- problem(_,_, Goals).

/* ld_problem(+ProbName)

actually loads the named problem into the prolog database as a problem
 with that name
*/
ld_problem(ProbName) :-
    prob(ProbName, InitState, Goals),
    list_to_ord_set(InitState, OrdInitState),
    retractall(problem(_,_,_)),
    make_Problem(ProbName, OrdInitState, Goals, Prob),
    assert(Prob),
    write('** problem '),
    write(ProbName),
    writeln(' has been loaded.').




/* %%%%%%%%%%%%%%%%%%%%

operators are asserted into the Prolog d/b as op(OperatorDataStructure)

are queried directly using OperatorDataStructure format below

operator OperatorDataStructure format
- name
- params
- preconditions
- effects
- cost
*/
%%:-  op(name, params, preconditions, effects, cost).
op_record(Name, Params, Preconds, Effects, Cost) :-
    op(Name, Params, Preconds, Effects, Cost).

op_name(Name) :- op(Name, _,_,_,_).
op_params(Name, Params) :- op(Name, Params, _, _, _).
op_preconds(Name, Params, Preconds) :- op(Name, Params, Preconds, _, _).
op_effects(Name, Params, Effects) :- op(Name, Params, _, Effects, _).
op_cost(Name, Params, Cost) :- op(Name, Params, _, _, Cost).

op_CleanUp() :-
    retractall(op(_,_,_,_,_)).

op_Load([]).
op_Load([Op | Rest]) :-
	assertz(op(Op)),
	op_Load(Rest).

%% op_Applicable(+State, ?OpName, ?Params)
/*
this code requires that any negated preconditions in an operator get
tested only after all variables have been bound.  This is the responsibility
of the domain designer, who must order the preconditions so that happens naturally.
*/



%%% ***** this is where you put your op_Applicable(+State, ?OpName, ?Params) code *****

op_Applicable(State, OpName, Params):-
  op_preconds(OpName, Params, Preconds),
  satisfy(Preconds, State).


%% op_ApplyOp(+OldState, +Step, ?NewState)

%%% ***** this is where you put your op_ApplyOp(+OldState, +Step, ?NewState) code *****



op_ApplyOp(OldState, Step, NewState) :-
  step_opName(Step, OpName),
  step_opParams(Step, OpParams),
  op_Applicable(OldState, OpName, OpParams),
  op_effects(OpName, OpParams, Effects),
  apply_effects(Effects, OldState, NewState).

/* Base case for empty list of effects */
apply_effects([], OldState, NewState):-
  NewState = OldState.

/* Removes negative effects to state */
apply_effects([FirstEffect | Rest], OldState, NewState) :-
  FirstEffect = not(A),
  ord_del_element(OldState, A, TempState),
  apply_effects(Rest, TempState, NewState).

/* Adds positive effects to state */
apply_effects([FirstEffect | Rest], OldState, NewState) :-
  \+(FirstEffect = not(A)),
  ord_add_element(OldState, FirstEffect, TempState),
  apply_effects(Rest, TempState, NewState).
