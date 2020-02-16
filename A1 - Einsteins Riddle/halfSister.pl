female(ann).
female(mary).

parent(sue, ann).
parent(ed, ann).
parent(sue, mary).
parent(sam, mary).

halfSisterOf(HalfSister, Person) :-
  female(HalfSister),
  parent(P1, HalfSister),
  parent(P1, Person),
  parent(P2, HalfSister),
  \+parent(P2, Person).
