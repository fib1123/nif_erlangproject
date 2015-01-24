%%%-------------------------------------------------------------------
%%% @author damian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. sty 2015 23:53
%%%-------------------------------------------------------------------
-module(test).
-author("damian").

%% API
-export([sort_test/0, start/0, stop/0]).

test_avg(M, F, A, N) when N > 0 ->
  L = test_loop(M, F, A, N, []),
  Length = length(L),
  Min = lists:min(L),
  Max = lists:max(L),
  Med = lists:nth(round((Length / 2)), lists:sort(L)),
  Avg = round(lists:foldl(fun(X, Sum) -> X + Sum end, 0, L) / Length),
  io:format("Range: ~b - ~b mics~n"
  "Median: ~b mics~n"
  "Average: ~b mics~n",
    [Min, Max, Med, Avg]),
  Avg.

test_loop(_M, _F, _A, 0, List) ->
  List;
test_loop(M, F, A, N, List) ->
  {T, _Result} = timer:tc(M, F, A),
  test_loop(M, F, A, N - 1, [T|List]).

start() ->
  port_driver:start().

stop() ->
  port_driver:stop().

sort_test() ->
  List = lists:map(fun(_X) -> random:uniform(100000) end, lists:seq(1, 10000)),
  io:format("~nLISTS:SORT~n"),
  Sorted = lists:sort(List),
  test_avg(lists, sort, [List], 100),
  io:format("___________________________________~n~n"),
  io:format("NIF~n"),
  Sorted = sort_nif:sort(List),
  test_avg(sort_nif, sort, [List], 100),
  io:format("___________________________________~n~n"),
  io:format("PORTY~n"),
  Sorted = port_driver:port_sort_list(List),
  test_avg(port_driver, port_sort_list, [List], 100),
  io:format("___________________________________~n~n").

