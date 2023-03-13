# Primeiro Trabalho Prático de Programação Concorrente

Programa em Erlang para traduzir termos do CCS0 (deadlock, prefixo e escolha não determinística) para o labelled transition system (LTS) correspondente.

-> 1) (valorização: 2,5 valores) Escreva um tradutor que tem como input a abstract syntax tree (AST) do termo CCS0.

Por exemplo, o termo a.0 + b.0 pode ser representado pela AST {choice {prefix 'a' zero} {prefix &#180;b&#180; zero}}.

-> 2) (valorização: 1 valor) Use a função anterior para implementar um server Erlang que recebe a AST de um termo CCS0 e envia de volta ao cliente o LTS correspondente ao termo.

-> 3) (valorização: 0,5 valores) Escreva um parser que converte a string correspondente ao termo CCS0 na sua AST, e nesse caso envie a string ao server. Pode implementar o parser diretamente em Erlang ou utilizar um gerador de parsers (ex: https://www.erlang.org/doc/man/yecc.html).