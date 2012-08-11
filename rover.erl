-module(rover).
-export([start/1,init/1]).

start(Position) ->
  spawn(rover, init, [Position]).

init(Position) ->
  receive
    {move, Instructions} ->
      NewPosition = parse(Position, Instructions),
      io:format("~p~n", [NewPosition]),
      init(NewPosition);
    _Else ->
      io:format("unknown command~n"),
      init(Position)
  end.

parse(Position, []) -> Position;
parse(Position, [H|T]) ->
  NewPosition = cmd(Position, H),
  parse(NewPosition, T).

cmd(Position, Command) ->
  [X,_S,Y,_S,Cardinal] = Position,
  case Command of
    $R ->
      NewCardinal = turn(right, Cardinal),
      [X,_S,Y,_S,NewCardinal];
    $L ->
      NewCardinal = turn(left, Cardinal),
      [X,_S,Y,_S,NewCardinal];
    $M ->
      [NewX, NewY] = move(foward,X,Y,Cardinal),
      [NewX,_S,NewY,_S,Cardinal]
  end.

turn(right, Cardinal) ->
  case Cardinal of
    $N -> $E;
    $E -> $S;
    $S -> $W;
    $W -> $N
  end;
turn(left, Cardinal) ->
  case Cardinal of
    $N -> $W;
    $W -> $S;
    $S -> $E;
    $E -> $N
  end.

move(foward,X,Y,Cardinal) ->
  case Cardinal of
    $N ->
      NewY = Y+1,
      [X,NewY];
    $E ->
      NewX = X+1,
      [NewX,Y];
    $S ->
      NewY = Y-1,
      [X,NewY];
    $W ->
      NewX = X-1,
      [NewX,Y]
  end.
