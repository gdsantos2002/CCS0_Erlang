-module(src).
-export([deadlock/0, rm_spaces/1, clean/1, join_words/1, clean_input/1]).
% -import(string, [replace/4]).
% -compile(export_all).         % avoid warnings


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


% Deadlock case
deadlock() -> 0.
