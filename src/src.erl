-module(src).
-export([rm_spaces/1, clean/1, join_words/1, clean_input/1,
    translate/2, tree/2, loop/0, start/0]).
% -import(string, [replace/4]).
% -import(lists, [filter/2]).
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
        {translate, From, AST} -> From ! {response, tree(AST, [])},
        loop()
    end.

translate(Server, AST) -> Server ! {translate, self(), AST},
    receive 
        {response, LTS} -> LTS
    end.

% check_AST("a.0 + b.0") -> true. 

tree(zero, List) -> List;
tree({prefix, X, zero}, List) -> List ++ [{string:concat("s", integer_to_list(length(List))), X, "sf"}]; 
tree({prefix, X, R}, List) -> tree(R, List ++ [{string:concat("s", integer_to_list(length(List))), X, string:concat("s", integer_to_list(length(List) + 1))}]);

tree({choice, R, zero}, List) -> tree(R, List);
tree({choice, zero, R}, List) -> tree(R, List);

tree({choice, R, {_, Y, zero}}, List) -> L1 = tree(R, List),
    L1 ++ [{string:concat("s", integer_to_list(length(List))), Y, "sf"}];

tree({choice, R, {_, Y, Rest}}, List) -> L1 = tree(R, List),
    tree(Rest, L1 ++ [{string:concat("s", integer_to_list(length(List))), Y, string:concat("s", integer_to_list(length(L1) - length(List) + 1))}]).
% tree({choice, C1, C2}, List) -> tree(C1, List) ++ tree(C2, List).

% test with: src:tree({prefix, "a", {prefix, "b", zero}}, []).
% test with: src:tree({choice, {prefix, "a", {prefix, "b", zero}}, zero}, []).
 