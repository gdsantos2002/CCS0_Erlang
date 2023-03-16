-module(src).
-export([rm_spaces/1, clean/1, join_words/1, clean_input/1,
    translate/2, tree/2, loop/0, start/0]).
% -compile(export_all).         % avoid warnings


%           Maybe it will be useful for the Parser


% Remove all ' ' characters from the AST
rm_spaces(AST) -> string:replace(AST, " ", "", all).

% Remove all [] from a list
clean(List) -> lists:filter(fun(X) -> X /= [] end, List).

% Join a list of strings
join_words(List) -> lists:concat(List).

% Returns the AST without spaces (" " caracters)
clean_input(AST) -> join_words(clean(rm_spaces(AST))).
% test with: src:clean_input("a.0 + b.0").


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


start() -> spawn(src, loop, []).

loop() ->
    receive
        {translate, From, AST} -> From ! {response, tree(AST, [])},
        loop()
    end.

translate(Server, AST) -> Server ! {translate, self(), AST},
    receive 
        {response, LTS} -> LTS
    end.

count_final_state_transitions([], N) -> N;
count_final_state_transitions([{_, _, "sf"}|R], N) -> count_final_state_transitions(R, N+1);
count_final_state_transitions([_|R], N) -> count_final_state_transitions(R, N).

tree(zero, List) -> List;
tree({prefix, X, zero}, List) -> List ++ [{string:concat("s", integer_to_list(length(List) - count_final_state_transitions(List, 0))), X, "sf"}]; 
tree({prefix, X, R}, List) -> tree(R, List ++ [{string:concat("s", integer_to_list(length(List) - count_final_state_transitions(List, 0))), X, string:concat("s", integer_to_list(length(List) - count_final_state_transitions(List, 0) + 1))}]);

tree({choice, R, zero}, List) -> tree(R, List);
tree({choice, zero, R}, List) -> tree(R, List);

tree({choice, R, {_, Y, zero}}, List) -> L1 = tree(R, List),
    L1 ++ [{string:concat("s", integer_to_list(length(List))), Y, "sf"}];

tree({choice, R, {_, Y, Rest}}, List) -> L1 = tree(R, List),
    tree(Rest, L1 ++ [{string:concat("s", integer_to_list(length(List) - count_final_state_transitions(List, 0))), Y, string:concat("s", integer_to_list(length(L1) - count_final_state_transitions(L1, 0) + 1))}]).

% test with: src:tree({prefix, "a", {prefix, "b", zero}}, []).
% test with: src:tree({choice, {prefix, "a", {prefix, "b", zero}}, zero}, []).
% test with: src:tree({choice, {prefix, "a", {choice, {prefix, "c", {prefix, "e", {prefix, "h", zero}}}, {prefix, "d", {prefix, "f", {prefix, "h", zero}}}}}, {prefix, "b", {prefix, "g", zero}}}, []).
% test with: src:tree({choice, {prefix, "a", {prefix, "c", zero}}, {prefix, "b", {prefix, "c", zero}}}, []).
