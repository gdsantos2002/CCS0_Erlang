-module(src).
-export([deadlock/1, rm_spaces/1, clean/1, join_words/1,
            clean_input/1, translate/2, check_AST/1, loop/0, start/0]).
% -import(string, [replace/4]).
% -compile(export_all).         % avoid warnings


start() -> spawn(src, loop, []).


% Define an alphabet?       A = {a, b} 

% Remove all ' ' characters from the AST
rm_spaces(AST) -> string:replace(AST, " ", "", all).

% Remove all [] from a list
clean(List) -> lists:filter(fun(X) -> X /= [] end, List).

% Join a list of strings
join_words(List) -> lists:concat(List).

% Returns the AST without spaces (" " caracters)
clean_input(AST) -> join_words(clean(rm_spaces(AST))).
% test with: src:clean_input("a.0 + b.0").

% just for testing
loop() ->
    receive
        {translate, From, AST} -> From ! {response, check_AST(AST)},
        loop()
    end.

translate(Server, AST) -> Server ! {translate, self(), AST},
    receive 
        {response, LTS} -> LTS
    end.

check_AST("a.0 + b.0") -> true.

% Deadlock case
deadlock(zero) -> 0.
