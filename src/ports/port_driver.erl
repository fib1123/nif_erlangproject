%%%-------------------------------------------------------------------
%%% @author damian
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. gru 2014 19:34
%%%-------------------------------------------------------------------
-module(port_driver).
-author("damian").

%% API
-export([start/0, stop/0, init/1, port_sort_list/1]).


start() ->
  erl_ddll:load_driver("./c_so", "ports.so"),
  spawn(?MODULE, init, ["./c_so/ports.so"]).

init(SharedLib) ->
  register(port_sort, self()),
  Port = open_port({spawn, SharedLib}, [{packet, 4}]),
  loop(Port).

stop() ->
  port_sort ! stop.

port_sort_list(List) ->
  call_port(List).

call_port(Msg) ->
  port_sort ! {call, self(), Msg},
  receive
    {port_sort, Result} ->
      Result;
    _ -> error
  end.

loop(Port) ->
  receive
    {call, Caller, Msg} ->
      Port ! {self(), {command, encode(Msg)}},
      receive
        {Port, {data, Data}} ->
          Caller ! {port_sort, decode(Data)}
      end,
      loop(Port);
    stop ->
      Port ! {self(), close},
      receive
        {Port, closed} ->
          exit(normal)
      end;
    {'EXIT', Port, Reason} ->
      exit({port_terminated, Reason})
  end.

encode(List) ->
  << <<X:32>> || X <- List>>.

decode([]) -> [];
decode([B3, B2, B1, B0 | T]) ->
  <<Int:32>> = <<B3, B2, B1, B0>>,
  [Int| decode(T)].