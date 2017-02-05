/* tokenize ( String +, Atoms -) -
 Convers a string and to a list of atoms .
 String is the input string .
 Sentence is the output list of atom tokens .

 Example :
[104 , 101 , 108 , 108 , 111 , 32 , 119 , 111 , 114 , 108 , 100] converts to [this, is , prolog ]. */

tokenize( String , Atoms ) :-
	tokenize_charcodes( String , Tokens ) ,
	tokens_to_atoms( Tokens , Atoms ).

/* All functors below are ’internal ’ and should not be called from outside . */

% tokenize_charcodes( Chars +, Tokens -) -
% Convers a list of character codes into a list of tokens codes .
% Chars is the input character codes .
% Tokens is the output list of token codes .

tokenize_charcodes( Chars , [ Token | RestTokens ]) :-
	append( Token , [32| RestChars ] , Chars ) , ! ,
	tokenize_charcodes( RestChars , RestTokens ).

tokenize_charcodes( Chars , [ Chars ]) .

% tokens_to_atoms( Tokens +, Atoms -) -
% Convers a list of tokens into a list of atoms .
% Tokens is the input list of tokens .
% Atoms is the output list of atoms .

tokens_to_atoms([ Token | RestTokens ], [ Atom | RestAtoms ]) :-
	token_to_lower( Token , TokenLower ) ,
	atom_codes( Atom , TokenLower ) ,
	tokens_to_atoms( RestTokens , RestAtoms ).

tokens_to_atoms([] , []) .

% token_to_lower (T+, L -) -
% Convers a token of character codes into a lower case token of character codes
% and strips any non - letter characters .
% T is the input token .
% L is the output token .

token_to_lower([] , []) .

token_to_lower([ T | TS ] , [ T| LS ]) :-
	between(97 , 122 , T ) ,
	!,
	token_to_lower(TS , LS ).

token_to_lower([ T | TS ] , [ L| LS ]) :-
	between(65 , 90 , T) ,
	!,
	L is T + 32 ,
	token_to_lower(TS , LS ).

token_to_lower([ _ | TS ] , LS ) :-
	token_to_lower(TS , LS ).