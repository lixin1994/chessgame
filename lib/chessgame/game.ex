defmodule Chessgame.Game do
  def new() do
    %{
      users: %{
        black: %{
          name: "",
          turn: true,
          isWinner: false,
          positions: [
            %{name: "rook", position: [7,0]},
            %{name: "knight",position: [7,1]},
            %{name: "bishop", position: [7,2]},
            %{name: "queen", position: [7,3]},
            %{name: "king", position: [7,4]},
            %{name: "bishop", position: [7,5]},
            %{name: "knight", position: [7,6]},
            %{name: "rook", position: [7,7]},
            %{name: "pawn", position: [6,0]},
            %{name: "pawn", position: [6,1]},
            %{name: "pawn", position: [6,2]},
            %{name: "pawn", position: [6,3]},
            %{name: "pawn", position: [6,4]},
            %{name: "pawn", position: [6,5]},
            %{name: "pawn", position: [6,6]},
            %{name: "pawn", position: [6,7]}

          ],
          clicked: []
        },
        white: %{
          name: "",
          turn: true,
          isWinner: false,
          positions: [
            %{name: "rook", position: [0,0]},
            %{name: "knight",position: [0,1]},
            %{name: "bishop", position: [0,2]},
            %{name: "queen", position: [0,3]},
            %{name: "king", position: [0,4]},
            %{name: "bishop", position: [0,5]},
            %{name: "knight", position: [0,6]},
            %{name: "rook", position: [0,7]},
            %{name: "pawn", position: [1,0]},
            %{name: "pawn", position: [1,1]},
            %{name: "pawn", position: [1,2]},
            %{name: "pawn", position: [1,3]},
            %{name: "pawn", position: [1,4]},
            %{name: "pawn", position: [1,5]},
            %{name: "pawn", position: [1,6]},
            %{name: "pawn", position: [1,7]}

          ],
          clicked: []
        }
      },
      observers: [],
    }
  end

  def observe(user, game) do
    newObservers = game.observers
    if (Enum.member?(newObservers, user)) do
      game
    else
      newObservers = [user| newObservers]
      %{game | observers: newObservers}
    end
  end
  def joinGame(user, game) do
    cond do
      game.users.black.name == "" ->
        newObservers = game.observers
        newObservers = List.delete(newObservers, user)
        newBlack = %{game.users.black | name: user}
        newUsers = %{game.users | black: newBlack}
        %{game | users: newUsers, observers: newObservers}
      game.users.white.name == "" ->
        newObservers = game.observers
        newObservers = List.delete(newObservers, user)
        newWhite = %{game.users.white | name: user}
        newUsers = %{game.users | white: newWhite}
        %{game | users: newUsers, observers: newObservers}
      true ->
        game
    end
  end

  def getUser(user, game) do
    cond do
      game.users.white.name == user ->
        game.users.white
      game.users.black.name == user ->
        game.users.black
      true ->
        false
    end
  end
  def getOppo(user, game) do
    cond do
      game.users.white.name == user ->
        game.users.black
      game.users.black.name == user ->
        game.users.white
      true ->
        false
    end
  end
  def getUserColor(user, game) do
    cond do
      game.users.white.name == user ->
        :white
      game.users.black.name == user ->
        :black
      true ->
        false
    end
  end
  def getOppoColor(user, game) do
    cond do
      game.users.white.name == user ->
        :black
      game.users.black.name == user ->
        :white
      true ->
        false
    end
  end
  def isSymbol(user, game) do
    curr = getUser(user, game)
    IO.puts(Enum.reduce(Enum.map(curr.positions, fn(x) -> Enum.at(x.position, 0) == Enum.at(curr.clicked, 0) && Enum.at(x.position, 1) == Enum.at(curr.clicked,1) end), fn(x, acc) -> x || acc end))
  end


  def updateUsers(users, color, newUser) do
    if color == :black do
      %{users | black: newUser}
    else
      %{users | white: newUser}
    end
  end
  def setSymbol(user, key, game) do
    curr = getUser(user, game)
    curr = %{curr | turn: false}
    newPosition = [div(key, 8), rem(key, 8)]
    curr = %{curr | positions: Enum.map(curr.positions, fn(x) -> if Enum.at(x.position,0) == Enum.at(curr.clicked, 0) && Enum.at(x.position, 1) == Enum.at(curr.clicked, 1) do %{x | position: newPosition} else x end end), clicked: []}
    newUsers = updateUsers(game.users, getUserColor(user, game), curr)
    %{game | users: newUsers}
  end

  def attack(user, key, game) do
    oppo = getOppo(user, game)
    oppo = %{oppo | turn: true}
    newPosition = [div(key, 8), rem(key, 8)]
    oppo = %{oppo | positions: Enum.filter(oppo.positions, fn(x) -> Enum.at(x.position, 0) != Enum.at(newPosition, 0) or Enum.at(x.position, 1) != Enum.at(newPosition, 1) end)}
    newUsers = updateUsers(game.users, getOppoColor(user, game), oppo)
    %{game | users: newUsers}
  end

  
  def click(user, game, key) do
    if getUser(user, game) do
      curr = getUser(user, game)
      if curr.turn && length(curr.clicked) > 0 && isSymbol(user, game)do
        game = setSymbol(user, key, game)
        attack(user, key, game)
      else
        curr= %{curr | clicked:  [div(key, 8), rem(key, 8)]}
        newUsers = updateUsers(game.users, getUserColor(user, game), curr)
        %{game | users: newUsers}
      end
    else
      game
    end
  end
end
