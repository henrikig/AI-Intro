/*
Persons is presented by consulting this file and then typing the following:
?- solution(Persons), ownerOfFish(Persons, Owner).

Clues:
=======
• the Brit lives in the red house
• the Swede keeps dogs as pets
• the Dane drinks tea
• the green house is on the left of the white house
• the green house’s owner drinks coffee
• the person who smokes Pall Mall rears birds
• the owner of the yellow house smokes Dunhill
• the man living in the center house drinks milk
• the Norwegian lives in the first house
• the man who smokes blends lives next to the one who keeps cats
• the man who keeps horses lives next to the man who smokes Dunhill
• the owner who smokes BlueMaster drinks beer
• the German smokes Prince
• the Norwegian lives next to the blue house
• the man who smokes blend has a neighbor who drinks water
*/

/* layout of house data item */
house(house(HouseNum, Color, Nationality, Beverage, Cigar, Pet),
	HouseNum, Color, Nationality, Beverage, Cigar, Pet).

/*
   field accessors/setters for house data item
   general form: house_<field name>(<amateur data item>, <field value>)
   these predicates can be used both for accessing and for setting the field values
 */
house_HouseNum(house(HouseNum, _Color, _Nationality, _Beverage, _Cigar, _Pet), HouseNum).
house_Color(house(_HouseNum, Color, _Nationality, _Beverage, _Cigar, _Pet), Color).
house_Nationality(house(_HouseNum, _Color, Nationality, _Beverage, _Cigar, _Pet), Nationality).
house_Beverage(house(_HouseNum, _Color, _Nationality, Beverage, _Cigar, _Pet), Beverage).
house_Cigar(house(_HouseNum, _Color, _Nationality, _Beverage, Cigar, _Pet), Cigar).
house_Pet(house(_HouseNum, _Color, _Nationality, _Beverage, _Cigar, Pet), Pet).


/*
    these are the domains (possible values) for the different fields, they were manually
    extracted from the riddle's descriptions

*/
houseNum(['1', '2', '3', '4', '5']).
colors([red, green, white, yellow, blue]).
nationalities([brit, swede, dane, norwegian, german]).
beverages([tea, coffe, milk, beer, water]).
cigars([pallmall, dunhill, blends, bluemaster, prince]).
pets([dogs, birds, cats, horses, fish]).

/*
    Helper predicates for positioning
*/
left_side(X, Y, Z) :- nextto(X, Y, Z).
right_side(X, Y, Z) :- nextto(Y, X, Z).
adjacent(X, Y, Z) :- left_side(X, Y, Z) ; right_side(X, Y, Z).

/*
   This is the actual encoding of the clues
*/
solution(Persons) :-
    /*
      Persons is the variable containing the matrix with
      the different houses

    */

    Persons = [House1, House2, House3, House4, House5],

    /*
      setting up the values that we already know
    */

    house(House1, '1', Color1, Nationality1, Beverage1, Cigar1, Pet1),
    house(House2, '2', Color2, Nationality2, Beverage2, Cigar2, Pet2),
    house(House3, '3', Color3, Nationality3, Beverage3, Cigar3, Pet3),
    house(House4, '4', Color4, Nationality4, Beverage4, Cigar4, Pet4),
    house(House5, '5', Color5, Nationality5, Beverage5, Cigar5, Pet5),
    colors(Colors),
    nationalities(Nationalities),
    beverages(Beverages),
    cigars(Cigars),
    pets(Pets),


    %% CLUES
    %% clue 1: the Brit lives in the red house
    house_Color(Red, red),
    member(Red, Persons),
    house_Nationality(Red, brit),

    %% clue 2: the Swede keeps dogs as pets
    house_Nationality(Swede, swede),
    member(Swede, Persons),
    house_Pet(Swede, dogs),

    %% clue 3: the Dane drinks tea
    house_Nationality(Dane, dane),
    member(Dane, Persons),
    house_Beverage(Dane, tea),

    %% clue 4: the green house is on the left of the white house
    house_Color(Green, green),
    member(Green, Persons),
    house_Color(White, white),
    member(White, Persons),
    left_side(Green, White, Persons),

    %% clue 5: the green house’s owner drinks coffee
    house_Color(Green, green),
    member(Green, Persons),
    house_Beverage(Green, coffee),

    %% clue 6: the person who smokes Pall Mall rears birds
    house_Cigar(PallMall, pallmall),
    member(PallMall, Persons),
    house_Pet(PallMall, birds),

    %%• clue 7: the owner of the yellow house smokes Dunhill
    house_Color(Yellow, yellow),
    member(Yellow, Persons),
    house_Cigar(Yellow, dunhill),

    %%• clue 8: the man living in the center house drinks milk
		house_Beverage(Milk, milk),
		member(Milk, Persons),
		nth1(3, Persons, Milk),

    %%• clue 9: the Norwegian lives in the first house
		house_Nationality(Norwegian, norwegian),
    member(Norwegian, Persons),
		nth1(1, Persons, Norwegian),

    %%• clue 10: the man who smokes blends lives next to the one who keeps cats
    house_Cigar(Blends, blends),
    member(Blends, Persons),
    house_Pet(Cats, cats),
    member(Cats, Persons),
    adjacent(Cats, Blends, Persons),

    %%• clue 11: the man who keeps horses lives next to the man who smokes Dunhill
    house_Pet(Horses, horses),
    member(Horses, Persons),
    house_Cigar(Dunhill, dunhill),
    member(Dunhill, Persons),
    adjacent(Dunhill, Horses, Persons),

    %%• clue 12: the owner who smokes BlueMaster drinks beer
    house_Cigar(BlueMaster, bluemaster),
    member(BlueMaster, Persons),
    house_Beverage(BlueMaster, beer),

    %%• clue 13: the German smokes Prince
    house_Nationality(German, german),
    member(German, Persons),
    house_Cigar(German, prince),

    %%• clue 14: the Norwegian lives next to the blue house
    house_Nationality(Norwegian, norwegian),
    member(Norwegian, Persons),
    house_Color(Blue, blue),
    member(Blue, Persons),
    adjacent(Norwegian, Blue, Persons),

    %%• clue 15: the man who smokes blend has a neighbor who drinks water
    house_Cigar(Blend, blends),
    member(Blend, Persons),
    house_Beverage(Water, water),
    member(Water, Persons),
    adjacent(Blend, Water, Persons),

		% add fish to Persons
		house_Pet(FishOwner, fish),
		member(FishOwner, Persons).


% Extract fish owner
ownerOfFish(Persons, Owner) :-
	house_Pet(FishOwner, fish),
	member(FishOwner, Persons),
	house_Nationality(FishOwner, Owner).
