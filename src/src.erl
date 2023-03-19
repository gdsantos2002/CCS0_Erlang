-module(src).
-import(lexer, [string/1]).
-import(parser, [parse/1]).
-compile(export_all).         


start() -> spawn(src, loop, []).

loop() ->
    receive
        {translateAST, From, AST} -> From ! {response, tree(AST, [])},
        loop();
        {translateCCS0, From, CCS0} -> From ! {response, unwrap_AST(unpack(string(CCS0)))},
        loop();
        {getLTSfromCCS0, From, CCS0} -> From ! {response, call_tree(unpack(string(CCS0)))},
        loop()
    end.

translateAST(Server, AST) -> Server ! {translateAST, self(), AST},
    receive 
        {response, LTS} -> LTS
    end.

translateCCS0(Server, CCS0) -> Server ! {translateCCS0, self(), CCS0},
    receive 
        {response, AST} -> AST
    end.

getLTSfromCCS0(Server, CCS0) -> Server ! {getLTSfromCCS0, self(), CCS0},
    receive 
        {response, LTS} -> LTS
    end.

call_tree({_, K}) -> tree(K, []).

unpack({_, Tokens, _}) -> parse(Tokens). 

unwrap_AST({_, K}) -> K.

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

% test with :
%   c(src).
%   Pid = src:start().
%   src:translateCCSO(Pid, {"a.0 + b.0"}).
%   src:getLTSfromCCS0(Pid, {"a.0 + b.0"}).
%   src:translateAST(Pid, {choice, {prefix, "a", {prefix, "b", zero}}, zero}).
%   src:translateAST(Pid, {choice, {prefix, "a", {choice, {prefix, "c", {prefix, "e", {prefix, "h", zero}}}, {prefix, "d", {prefix, "f", {prefix, "h", zero}}}}}, {prefix, "b", {prefix, "g", zero}}}).
