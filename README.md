nif_erlangproject
=================

NIF demonstration for Programming in Erlang class


using NIF part:
1) cd nif/
2) Compile c files:

    gcc -o c_src/sort_nif.so -fpic -shared c_src/quicksort.c c_src/sort_nif.c
3) Run erl and there type c(sort_nif).
4) You can sort list like that:

    sort_nif:sort([5,4,3,2,1]).
