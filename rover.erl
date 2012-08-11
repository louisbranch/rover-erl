-module(rover).
-export([init/1,turn/2]).

init(Position) ->
  receive
    {move, Instructions} ->
      Cmds = parse(Position, Instructions),
      io:format("~p~n", [Cmds]),
      init(Position);
    _Else ->
      io:format("unknown command")
  end.

parse(_, []) -> [];
parse(Position, [H|T]) -> [cmd(Position, H)|parse(Position, T)].

cmd(Position, Command) ->
  case Command of
    $R -> turn(right, Position);
    $L -> turn(left, Position);
    $M -> move(foward, Position)
  end.

turn(Direction, Position) ->
  [X,_,Y,_,Cardinal] = Position,
  NewCardinal = case Direction of
    right ->
      case Cardinal of
        $N -> $E;
        $E -> $S;
        $S -> $W;
        $W -> $N
      end;
    left ->
      case Cardinal of
        $N -> $W;
        $W -> $S;
        $S -> $E;
        $E -> $N
      end
  end,
  [X,$ ,Y,$ ,NewCardinal].

move(foward, _) -> "Alright".
