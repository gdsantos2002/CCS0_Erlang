Nonterminals P.
Terminals plus dot lparen rparen atom zr.
Rootsymbol P.
Right 100 plus.
Right 200 dot.


P -> zr : zero.   
P -> P plus P : {choice, '$1', '$3'}.  % {choice, P, P}
P -> lparen P rparen : '$2'.
P -> atom dot P : {prefix, unwrap('$1'), '$3'}.   % {prefix, atom, P}

Erlang code.

unwrap({_,_,V}) -> V.
