/* Load Blocks World */
:- consult('BlocksWorld.pl').

/* Load Tokenizer */
:- consult('Tokenizer.pl').

/* Load Parser */
:- consult('Parser.pl').

/* Load Interpreter */
:- consult('Interpreter.pl').

/* read_string ( String -) -
Reads line from the terminal .*/
read_string(String) :-
	get0(Char) ,
	fix_string(Char, String).

/* fix_string( Char +, String -) -
% Checks Char for line breaks or read next charecter . */
fix_string( -1 , []) :- !. % end of file
fix_string(10 , []) :- !. % end of line ( Unix )
fix_string(13 , []) :- !. % end of line ( Dos )
fix_string( Char , [ Char | Rest ]) :-
	read_string( Rest ).

/* welcome -
Prints welcome message .*/
welcome :-
	nl ,
	nl ,
	writeln('Natural Language in Blocks World - AI HW') ,
	writeln(' ============================================').

/* handle_input ( Tokens +) -
Parses the input tokens , and call interpretation .*/
handle_input(Tokens) :-
/* Check for special quit or state token sequence . */
Tokens=[quit] -> ( writeln('exit the program') , halt ) ;
Tokens=[state] -> print_state ;
/* Otherwise just parse it. */
(parse( Tokens , Root , Expr) ,(
/* Identyfy parsed sentence type , and let the
specified interpreser handle it. */
Root=s( cmd ) -> (command(Expr) , !) ;
Root=s( wq ) -> (question(Expr) , !) ;
( writeln('Only commands and questions please!') , !));
( writeln('I don not understand or cannot do what you are asking!') , !)).
/* main_loop -
Program main loop . */
main_loop :-
	repeat ,
	flush ,
	nl ,
	write( '> ') ,
	read_string( String ) ,
	tokenize( String , Tokens ) ,
	handle_input( Tokens ) ,
	fail .

run :- welcome , main_loop .

:- run.