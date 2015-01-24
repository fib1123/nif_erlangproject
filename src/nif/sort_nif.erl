%%%-------------------------------------------------------------------
%%% @author Stanislaw Robak
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. sty 2015 11:16
%%%-------------------------------------------------------------------
-module(sort_nif).
-author("fib1123").

%% API
-export([sort/1, crash/1]).
-on_load(init/0).

init() ->
  ok = erlang:load_nif("./c_so/sort_nif", 0).

sort(_List) ->
  exit(nif_library_not_loaded).

crash(_Int) ->
  exit(nif_library_not_loaded).