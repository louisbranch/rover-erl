-module(rover).
-export([init/1]).

init(Loc) ->
  receive
    Instructions ->
      Cmds = parse(Instructions),
      io:format("~p~n", [Cmds]),
      init(Loc)
  end.

parse([]) -> [];
parse([H|T]) -> [cmd(H)|parse(T)].

cmd(77) -> foward;
cmd(82) -> right;
cmd(76) -> left.
