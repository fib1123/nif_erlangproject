nif_erlangproject
=================

NIF demonstration for Programming in Erlang class

Provides comparison of sorting between: built-in lists:sort, NIF implementation, ports implementation.
Also shows behaviour of NIFs during crash when executing c part.

Build instructions:

1) Use makefile:

```
make
```

2) Run erl on ./ebin

```
erl -pa ./ebin
```

3) Load implemented modules

```
l(sort_nif).
l(port_driver).
l(test).
```