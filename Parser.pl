/* Define operators . */
:- op(630 , xfy , /). /* Forward slash ( combines on right ) */
:- op(620 , xfy , \). /* Backward slash ( combines on left ) */

/* Load lexicon */
:- consult( 'Lexicon.pl' ).

% parse( Tokens + , Root ?, Expr ?) -
% True if tokens can be parsed to a tree with root Root , and resulting
% expression Expr .
parse( Tokens , Root , Expr ) :- shift_reduce([] , Tokens ,[] ,0 , Root , Expr ).

/* The following ar " private " method , and should not be called from outside. */

% shift_reduce ( Stack +, Sentence +) -
% The actual parsing algorithm using the bottom -up shift / reduce paradigm .
% Stack is the current category stack .
% Sentence is the remainding seantence .

/* Terminal states . */
% shift_reduce ([ np(X)\np(X)],_,Exprs ,_) :- !, write ( Exprs ), halt .
shift_reduce([ s(X) ] ,[] ,[ Expr ],_ ,s(X ) , Expr ).

/* Shift rule */
shift_reduce( Stack ,[ Word | Words ], Expr , Depth , Root , OutExpr ) :-
lex( Word , Cat , NewExpr ) ,
shift_reduce([ Cat | Stack ], Words ,[ NewExpr | Expr ], Depth , Root , OutExpr ).

/* Reduce Functional application > */
shift_reduce([Y ,X /Y| Stack ] , Words ,[ Expr1 , Expr2 | RestExpr ], Depth , Root , OutExpr ) :-
	append( Expr1 , Expr2 , Expr3 ) ,
	shift_reduce([ X| Stack ], Words ,[ Expr3 | RestExpr ], Depth , Root , OutExpr ).

/* Reduce Functional application < */
shift_reduce([ X\Y ,Y| Stack ] , Words ,[ Expr1 , Expr2 | RestExpr ], Depth , Root , OutExpr ) :-
	append( Expr1 , Expr2 , Expr3 ) ,
	shift_reduce([ X| Stack ], Words ,[ Expr3 | RestExpr ], Depth , Root , OutExpr ).

/* Reduce Forward composition >B */
shift_reduce([ Y/Z ,X/Y | Stack ], Words ,[ Expr1 , Expr2 | RestExpr ], Depth , Root , OutExpr ) :-
	append( Expr1 , Expr2 , Expr3 ) ,
	shift_reduce([ X/ Z| Stack ], Words ,[ Expr3 | RestExpr ], Depth , Root , OutExpr ).

/* Reduce Backward composition <B */
shift_reduce([ X\Y ,Y\Z | Stack ], Words , Expr , Depth , Root , OutExpr ) :-
	shift_reduce([ X\ Z| Stack ], Words , Expr , Depth , Root , OutExpr ).

/* Expand Forward type raising */
shift_reduce([ np( X)| Stack ] , Words , Expr , Depth , Root , OutExpr ) :-
	Depth < 2,
	NewDepth is Depth +1 ,
	shift_reduce([ s(Y) /( s(Y)\ np(X) )| Stack ], Words , Expr , NewDepth , Root , OutExpr).