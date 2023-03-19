Definitions.
WS = [\s\t]
LB = \n|\r\n|\r
Atoms = [a-z][0-9a-zA-Z_]*

Rules. 
{Atoms} : {token, {atom, TokenLine, list_to_atom(TokenChars)}}.
\+          : {token, {plus, TokenLine}}.
\(          : {token, {lparen, TokenLine}}.
\)          : {token, {rparen, TokenLine}}.
\.          : {token, {dot, TokenLine}}.
\0       : {token, {zr, TokenLine}}.
{WS}        : skip_token.
{LB}        : skip_token.

Erlang code.