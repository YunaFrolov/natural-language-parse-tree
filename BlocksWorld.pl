print_state_line :-
	object(B , block ) ,
	write(B) ,
	write( '\t ') ,
	( on(B , S) -> write(S) ; write(' ')) ,
	write( '\t ') ,
	( in(B , C) -> write(C) ; write( ' ')) ,
	write( '\t ') ,
	( holding(B) -> write( '* ') ; write( ' ')) ,
	nl ,
	fail .

print_state_line.

print_state :-
	writeln( ' block \t On \t In \t Hold ') ,
	writeln( ' ============================ ') ,
	print_state_line.

/* Static facts */
object(t , table ).
object(a , block ).
object(b , block ).
object(c , block ).
object(d , block ).
color(c , yellow ).
color(a , blue ).
color(b , yellow ).
color(d , blue ).

can_support(t ).
can_support( a ).
can_support( b ).
can_support( c ).
can_support( d ).

/* Initial dynamic facts */
:- assert( on(a , t )).
:- assert( on(b , t )).
:- assert( on(nil , c )).
:- assert( on(nil , d )).
:- assert( on(c , a )).
:- assert( on(d , b )).
:- assert( last( nil )).
:- assert( holding( nil )).