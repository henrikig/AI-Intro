:- use_module(library(lists)).  %% to load permutation/2

/*
Clues:
=======
1. Mr. Masters got a terrific picture of the Ring Nebula.
Felix didn’t get a picture of the Orion Nebula.

2. Nick Spade didn’t get a picture of the Crab Nebula
but he left two hours later than the one who got a picture of Saturn.

3. Janet, whose last name wasn’t West, left two hours after the one who photographed Jupiter.

4. The friend who took a picture of Venus also got a picture of the Cat’s Eye Nebula.
Ms. Carter got a picture of the Omega Nebula.

5. The five amateur astronomers were Elliot,
the one who photographed Neptune,
the one who left at 2am,
Ms. Packet,
and the one who photographed the Omega Nebula.

6. Felix left at 4am but he didn’t get a photograph of Mars.
Sheila’s last name wasn’t Packet and she didn’t leave at 3am.
The friend who got a picture of the Orion Nebula left at 1am.
*/

/* layout of amateur data item */
amateur(amateur(FirstName, LastName, TimeLeft, Planet, Nebula),
	FirstName, LastName, TimeLeft, Planet, Nebula).

/*
   field accessors/setters for amateur data item
   general form: amateur_<field name>(<amateur data item>, <field value>)
   these predicates can be used both for accessing and for setting the field values
 */
amateur_FirstName(amateur(FirstName, _LastName, _TimeLeft, _Planet, _Nebula), FirstName).
amateur_LastName(amateur(_FirstName, LastName, _TimeLeft, _Planet, _Nebula), LastName).
amateur_TimeLeft(amateur(_FirstName, _LastName, TimeLeft, _Planet, _Nebula), TimeLeft).
amateur_Planet(amateur(_FirstName, _LastName, _TimeLeft, Planet, _Nebula), Planet).
amateur_Nebula(amateur(_FirstName, _LastName, _TimeLeft, _Planet, Nebula), Nebula).


/*
    these are the domains (possible values) for the different fields, they were manually
    extracted from the puzzle descriptions

*/
firstName([felix, nick, janet, elliot, sheila]).
lastNames([packet, masters, spade, west, carter]).
timesLeft([0, 1, 3, 2, 4]).
planets([saturn, jupiter, neptune, venus, mars]).
nebulas([ring, crab, orion, catsEye, omega]).

/*
   This is the actual encoding of the clues
*/
solve(Solution) :-
    /*
      Solution is the variable containing the amateur data items for
      each person in the puzzle
      */
    Solution = [Felix, Nick, Janet, Elliot, Sheila],

    /*
      setting up the values that we already know
    */
    amateur(Felix, felix,
	    FelixLastName, FelixTimeLeft, FelixPlanet, FelixNebula),
    amateur(Nick, nick, NickLastName, NickTimeLeft, NickPlanet,
	    NickNebula),
    amateur(Janet, janet, JanetLastName, JanetTimeLeft, JanetPlanet,
	    JaneNebula),
    amateur(Elliot, elliot, ElliotLastName, ElliotTimeLeft,
	    ElliotPlanet, ElliotNebula),
    amateur(Sheila, sheila, SheilaLastName, SheilaTimeLeft,
	    SheilaPlanet, SheilaNebula),
    lastNames(LastNames),
    timesLeft(TimesLeft),
    planets(Planets),
    nebulas(Nebulas),

    %% POSITIVE CLUES
    %% clue 1 Mr. Masters got a terrific picture of the Ring Nebula.
    amateur_LastName(Masters, masters),
    member(Masters, Solution),
    amateur_Nebula(Masters, ring),
    %% clue 2 Nick Spade
    amateur_LastName(Nick, spade),
    %% clue 2 Nick left two hours later than the one who got a picture of Saturn.
    amateur_Planet(Saturn, saturn),
    member(Saturn, Solution),
    amateur_TimeLeft(Saturn, SaturnTimeLeft),
    member(NickTimeLeft, TimesLeft),
    SaturnTimeLeft is NickTimeLeft - 2,
    member(SaturnTimeLeft, TimesLeft),
    %% clue 3 Janet left two hours after the one who photographed Jupiter.
    amateur_Planet(Jupiter, jupiter),
    member(Jupiter, Solution),
    amateur_TimeLeft(Jupiter, JupiterTimeLeft),
    member(JupiterTimeLeft, TimesLeft),
    amateur_TimeLeft(Janet, JanetTimeLeft),
    JanetTimeLeft is JupiterTimeLeft+ 2,
    member(JanetTimeLeft, TimesLeft),
    %% clue 4 took a picture of Venus also got a picture of the Cat’s Eye Nebula.
    amateur_Planet(Venus, venus),
    member(Venus, Solution),
    amateur_Nebula(Venus, catsEye),
    %% clue 4 Ms. Carter got a picture of the Omega Nebula.
    amateur_LastName(Carter, carter),
    member(Carter, Solution),
    amateur_Nebula(Carter, omega),
    %% clue 6 Felix left at 4am
    amateur_TimeLeft(Felix, 4),
    %% clue 6 who got a picture of the Orion Nebula left at 1am.
    amateur_Nebula(Orion, orion),
    member(Orion, Solution),
    amateur_TimeLeft(Orion, 1),
    %%% instantiate rest of solution structure
    permutation(LastNames,
		[FelixLastName, NickLastName, JanetLastName, ElliotLastName, SheilaLastName]),
    permutation(TimesLeft,
		[FelixTimeLeft, NickTimeLeft, JanetTimeLeft, ElliotTimeLeft, SheilaTimeLeft]),
    permutation(Planets,
		[FelixPlanet, NickPlanet, JanetPlanet, ElliotPlanet, SheilaPlanet]),
    permutation(Nebulas,
		[FelixNebula, NickNebula, JaneNebula, ElliotNebula
		 , SheilaNebula]),

    %% NEGATIVE CLUES
    %% clue 1 Felix didn’t get a picture of the Orion Nebula.
    \+ amateur_Nebula(Felix, orion),
    %% clue 2 Nick Spade didn’t get a picture of the Crab Nebula
    \+ amateur_Nebula(Nick, crab),
    %% clue 3 Janet, whose last name wasn’t West
    \+ amateur_LastName(Janet, west),
    %% clue 5
    %% Elliot: didn't do neptune, didn't leave at 2, not Ms. Packet, didn't do omega
    \+ amateur_Planet(Elliot, neptune),
    \+ amateur_TimeLeft(Elliot, 2),
    \+ amateur_LastName(Elliot, packet),
    \+ amateur_Nebula(Elliot, omega),
    %% neptune photopher: didn't leave at 2, not Ms Packet, didn't do omega
    amateur_Planet(Neptune, neptune),
    member(Neptune, Solution),
    \+ amateur_TimeLeft(Neptune, 2),
    \+ amateur_LastName(Neptune, packet),
    \+ amateur_Nebula(Neptune, omega),
    %% person left at 2: not Ms Packet, didn't do omega
    amateur_TimeLeft(TwoAM, 2),
    member(TwoAM, Solution),
    \+ amateur_LastName(TwoAM, packet),
    \+ amateur_Nebula(TwoAM, omega),
    %% Ms Packet: didn't do omega
    amateur_LastName(Packet, packet),
    member(Packet, Solution),
    \+ amateur_Nebula(Packet, nebula),

    %% clue 6 Felix didn’t get a photograph of Mars.
    \+ amateur_Planet(Felix, mars),
    %% clue 6 Sheila’s last name wasn’t Packet
    \+ amateur_LastName(Sheila, packet),
    %% clue 6 Sheila didn’t leave at 3am.
    \+ amateur_TimeLeft(Sheila, 3).
