% expand ( Expressions , PExpression ) -
% Expand a expression to a prolog term .
expand([ Expr1 ], Expr1 ).
expand([ Expr1 | RestExpr ], ( Expr1 , Expr2 )) :- 
	expand( RestExpr , Expr2 ).

% solve ( Expression +, Variable +, Solution -) -
% Find a solution to the variable in the expression .
solve( Expr , Variable , Solution ) :-
	expand( Expr , PExpr ) ,
	findall( Variable , PExpr , Solutions ) ,
	member( Solution , Solutions ).

% extract( Expression +, Expression -, Head +, Arguments -) -
% Match a term within a expression and extract the arguments .
extract([ H| T], T , Head , Arguments ) :- 
	H =.. [ Head | Arguments ].
extract([ H| T], [H|R ], Head , Arguments ) :-
	extract(T , R , Head , Arguments ).
	
% command( Expression +) -
% Executes the command given within the expression .
/* Grasp */
command( Expr ) :-
	extract( Expr , NewExpr , grasp , [ Object ]) ,
	!,
	write( '* Grasp ') , write( Object ) , write( ' where ') , write( NewExpr ) , nl ,
	( \+ holding( nil ) -> ( writeln( 'I am already holding something . ') , fail ) ; true ) ,
	/* Find solution */
	solve( NewExpr , Object , Block ) ,
	/* Update state */
	retract( holding( nil ) ) ,
	assert( holding( Block ) ) ,
	ignore( retract( on( Block ,_ ))) ,
	retract( last(_)) ,
	assert( last( Block )) ,
	/* Response */
	write( 'OK - I grasped ') , write( Block ) ,
	nl .
/* Put */
command( Expr ) :-
	extract( Expr , NewExpr , put , [ Object , RelativeObject ]) ,
	!,
	write( '* Put ') , write( Object ) , write( ' -> ') , write( RelativeObject ) ,
	write( ' where ') , write( NewExpr ) , nl ,

	/* Update state */
	(
	(
	extract( NewExpr , NewExpr2 , on , [ Object , RelativeObject ]) ,
	solve( NewExpr2 , Object , Block ) ,
	solve( NewExpr2 , RelativeObject , SupportingBlock ) ,
	can_support( SupportingBlock ) ,
	ignore( retract( on( Block ,_ ))) ,
	ignore( retract( in( Block ,_ ))) ,
	assert( on( Block , SupportingBlock )) ,
	ignore( holding( Block ) -> ( retract( holding( Block )) , assert( holding( nil))) ) ,
	retract( last(_)) ,
	assert( last( Block ))) ;
	(
	extract( NewExpr , NewExpr2 , in , [ Object , RelativeObject ]) ,
	solve( NewExpr2 , Object , Block ) ,
	solve( NewExpr2 , RelativeObject , ContainingBlock ) ,
	can_contain( ContainingBlock ) ,
	ignore( retract( on( Block ,_ ))) ,
	ignore( retract( in( Block ,_ ))) ,
	assert( in( Block , ContainingBlock )) ,
	ignore( holding( Block ) -> ( retract( holding( Block )) , assert( holding( nil))) ) ,
	retract( last(_)) ,
	assert( last( Block ))
	)
	) ,
	/* Response */
	write( 'OK ') ,
	nl .
	
% assertion
/* assertion */
command( Expr ) :-
	extract( Expr , NewExpr , on , [ Object , RelativeObject ]) ,
	!,
	write( '* on ') , write( Object ) , write( ' -> ') , write( RelativeObject ) ,
	write( ' where ') , write( NewExpr ) , nl ,

	/* Update state */
	(
	(
	extract( NewExpr , NewExpr2 , on , [ Object , RelativeObject ]) ,
	solve( NewExpr2 , Object , Block ) ,
	solve( NewExpr2 , RelativeObject , SupportingBlock ) ,
	can_support( SupportingBlock ) ,
	ignore( retract( on( Block ,_ ))) ,
	ignore( retract( in( Block ,_ ))) ,
	assert( on( Block , SupportingBlock )) ,
	ignore( holding( Block ) -> ( retract( holding( Block )) , assert( holding( nil))) ) ,
	retract( last(_)) ,
	assert( last( Block ))) ;
	(
	extract( NewExpr , NewExpr2 , in , [ Object , RelativeObject ]) ,
	solve( NewExpr2 , Object , Block ) ,
	solve( NewExpr2 , RelativeObject , ContainingBlock ) ,
	can_contain( ContainingBlock ) ,
	ignore( retract( on( Block ,_ ))) ,
	ignore( retract( in( Block ,_ ))) ,
	assert( in( Block , ContainingBlock )) ,
	ignore( holding( Block ) -> ( retract( holding( Block )) , assert( holding( nil))) ) ,
	retract( last(_)) ,
	assert( last( Block ))
	)
	) ,
	/* Response */
	write( 'OK ') ,
	nl .

/* Unknown command . */
command(_) :- write( ' Command not understood . ') , nl .

% question( Expression +) -
% Answers the question asked
question( Expr ) :-
	extract( Expr , NewExpr , what , [ Variable ]) ,
	!,
	write( '* What ') , write( Variable ) , write( ' where ') , write( NewExpr ) , nl,
	solve( NewExpr , Variable , Answer ) ,
	(
	(
	/* Answer is a block , produce a " natural " answer . */
	object( Answer , Shape ) ,
	retract( last(_)) ,
	assert( last( Answer )) ,
	color( Answer , Color ) ,
	write( ' The ') , write( Color ) , write( ' ') , write( Shape ) , write( '. ') , nl) ;
	(
	/* Answer is a color , produce a " natural " Answer . */
	color(_ , Answer ) ,
	write( 'It is ') , write( Answer ) , write( '. ') , nl) ;
	(
	/* Otherwise just Answer . */
	writeln( Answer )
	)
	).

/* Unknown question . */
question( _) :- write( ' Question not understood . ') , nl .