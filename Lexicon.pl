/* DETERMINERS */
/* Interrogative */
lex( what , (s( wq ) /( s( dcl )\ np(X)) )/n(X ) , [ what(X) ]) .
lex( what , (s( wq ) /( s( dcl )\ np(X)) )/n(X ,Y) , [ what(Y ) ]) .

/* Articles */
lex(the , np(X)/n(X) , []) .
lex(a , np(X)/ n(X) , []) .

/* NOUNS */
/* Pronouns */
lex( it , np(X) , [ last(X) ]) .
/* Relative Pronouns */
lex( that , (np(X)\ np(X) ) /( s(dcl) \ np(X)) , []) .
lex( that , (np(X)\ np(X) ) /( s(dcl) / np(X)) , []) .

/* Common Nouns */
lex( color , n(X ,Y) , [ color(X ,Y) ]) .
lex( object , n(X) , [ object(X ,_) ]) .
lex( table , n(X) , [ object(X , table ) ]) .
lex( block , n(X) , [ object(X , block ) ]) .

/* VERBS */
/* Imperative */
lex( grasp , s( cmd ) / np(X) , [ grasp(X) ]) .
/* Imperative with preposition */
lex( put , (s( cmd )/ pp(X , Y))/ np(X) , [ put(X ,Y) ]) .
lex( grasp , (s( cmd )/ pp(X ,_)) / np( X) , [ grasp(X ) ]) .
/* Transitive */
lex( is , (s( dcl )\ np(X)) / np(X ) , []) .
lex( supports , (s( dcl )\ np(Y) )/ np(X) , [ on(X ,Y ) ]) .

/* ADJECTIVES */
lex( yellow , n(X)/ n(X) , [ color(X , yellow ) ]) .
lex( blue , n(X)/n(X) , [ color(X , blue ) ]) .

/* PREPOSITION */
lex( from , pp(X ,Y) / np(Y) , [ in(X ,Y) ]) .
lex( from , pp(X ,Y) / np(Y) , [ on(X ,Y) ]) .
lex( in , pp(X , Y)/ np(Y) , [ in(X ,Y ) ]) .
lex( into , pp(X ,Y) / np(Y) , [ in(X ,Y) ]) .
lex( on , pp(X , Y)/ np(Y) , [ on(X ,Y ) ]) .
lex( onto , pp(X ,Y) / np(Y ) , [ on(X ,Y) ]) .