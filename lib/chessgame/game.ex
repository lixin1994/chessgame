defmodule Chessgame.Game do

  def new() do
    %{
      users: %{
        black: %{
          name: "",
          turn: false,
          isWinner: false,
          positions: [
            %{name: "rook", position: [7,0]},
            %{name: "knight",position: [7,1]},
            %{name: "bishop", position: [7,2]},
            %{name: "king", position: [7,3]},
            %{name: "queen", position: [7,4]},
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
            %{name: "king", position: [0,3]},
            %{name: "queen", position: [0,4]},
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
    };
  end

  def isValidMove("king", curPos, newPos, game) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    color = findColor(game, curPos)

    hypotheticalState = kingMoveState(game, newPos, color)

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      abs(newX - curX) <= 1 and abs(newY - curY) <= 1 and checkCollisions(game, curPos, newPos, color) and checkKingCheck(hypotheticalState, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("queen", curPos, newPos, game) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      (newX == curX or newY == curY) and checkCollisions(game, curPos, newPos, color) -> true
      abs(newX - curX) == abs(newY - curY) and checkCollisions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("bishop", curPos, newPos, game) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      abs(newX - curX) == abs(newY - curY) and checkCollisions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("knight", curPos, newPos, game) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    color = findColor(game, curPos)

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      abs(newX - curX) == 2 and abs(newY - curY) == 1 and checkKnightCollision(game, newPos, color) -> true
      abs(newY - curY) == 2 and abs(newX - curX) == 1 and checkKnightCollision(game, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("rook", curPos, newPos, game) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      (newX == curX or newY == curY) and checkCollisions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("pawn", curPos, newPos, game) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    color = findColor(game, curPos)

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      checkPawnConditions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def kingMoveState(game, newPos, :white) do
    newPositions = Enum.map(game.users.white.positions, fn(x) -> if x.name == "king" do %{name: "king", position: newPos} else x end end)
    newWhite = %{game.users.white | positions: newPositions}
    newUsers = %{game.users | white: newWhite}
    %{game | users: newUsers}
  end

  def kingMoveState(game, newPos, :black) do
    newPositions = Enum.map(game.users.black.positions, fn(x) -> if x.name == "king" do %{name: "king", position: newPos} else x end end)
    newBlack = %{game.users.black | positions: newPositions}
    newUsers = %{game.users | black: newBlack}
    %{game | users: newUsers}
  end

  def findColor(game, curPos) do
    cond do
      Enum.any?(game[:users][:black][:positions], fn(x) -> x[:position] == curPos end) -> :black
      Enum.any?(game[:users][:white][:positions], fn(x) -> x[:position] == curPos end) -> :white
    end
  end


  def outOfBounds(x, y) do
    if x > 7 or x < 0 or y > 7 or y < 0 do
      true
    end
  end

  def checkCollisions(game, curPos, newPos, :black) do
    not (Enum.any?(game[:users][:black][:positions], fn(x) ->
      distance = dist(curPos, x[:position]) + dist(x[:position], newPos) - dist(curPos, newPos)
      not (x[:position] == curPos)
      and distance > -0.0001 and distance < 0.0001 end) ||
      Enum.any?(game[:users][:white][:positions], fn(x) ->
      distance = dist(curPos, x[:position]) + dist(x[:position], newPos) - dist(curPos, newPos)
      not (x[:position] == newPos)
      and distance > -0.0001 and distance < 0.0001 end))
  end

  def checkCollisions(game, curPos, newPos, :white) do
    not (Enum.any?(game[:users][:white][:positions], fn(x) ->
      distance = dist(curPos, x[:position]) + dist(x[:position], newPos) - dist(curPos, newPos)
      not (x[:position] == curPos)
      and distance > -0.0001 and distance < 0.0001 end) ||
      Enum.any?(game[:users][:black][:positions], fn(x) ->
      distance = dist(curPos, x[:position]) + dist(x[:position], newPos) - dist(curPos, newPos)
      not (x[:position] == newPos)
      and distance > -0.0001 and distance < 0.0001 end))
  end

  def dist(pos1, pos2) do
    x1 = pos1
      |> Enum.at(1)
    y1 = pos1
      |> Enum.at(0)
    x2 = pos2
      |> Enum.at(1)
    y2 = pos2
      |> Enum.at(0)

    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2))
  end

  def checkPawnConditions(game, curPos, newPos, :black) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    allPieces = game.users.black.positions ++ game.users.white.positions
    anyCollision = not Enum.any?(allPieces, fn(x) -> x.position == newPos end)

    cond do
      curY == 6 and (newY == 5 or newY == 4) and curX == newX and anyCollision and checkCollisions(game, curPos, newPos, :black) -> true
      newY == curY - 1 and curX == newX and anyCollision -> true
      newY == curY - 1 and abs(newX - curX) == 1 and Enum.any?(game[:users][:white][:positions], fn(x) -> x[:position] == newPos end) -> true
      true -> false
    end
  end

  def checkPawnConditions(game, curPos, newPos, :white) do
    curX = curPos
      |> Enum.at(1)
    curY = curPos
      |> Enum.at(0)
    newX = newPos
      |> Enum.at(1)
    newY = newPos
      |> Enum.at(0)
    allPieces = game.users.black.positions ++ game.users.white.positions
    anyCollision = not Enum.any?(allPieces, fn(x) -> x.position == newPos end)

    cond do
      curY == 1 and (newY == 2 or newY == 3) and curX == newX and anyCollision and checkCollisions(game, curPos, newPos, :white) -> true
      newY == curY + 1 and curX == newX and anyCollision -> true
      newY == curY + 1 and abs(newX - curX) == 1 and Enum.any?(game[:users][:black][:positions], fn(x) -> x[:position] == newPos end) -> true
      true -> false
    end
  end

  def checkKnightCollision(game, newPos, :black) do
    not Enum.any?(game[:users][:black][:positions], fn(x) -> x[:position] == newPos end)
  end

  def checkKnightCollision(game, newPos, :white) do
    not Enum.any?(game[:users][:white][:positions], fn(x) -> x[:position] == newPos end)
  end

  def checkKingCheck(game, newPos, :black) do
    not Enum.any?(game[:users][:white][:positions], fn(x) -> isValidMove(x[:name], x[:position], newPos, game) end)
  end

  def checkKingCheck(game, newPos, :white) do
    not Enum.any?(game[:users][:black][:positions], fn(x) -> isValidMove(x[:name], x[:position], newPos, game) end)
  end

  def observe(user, game) do
    newObservers = game.observers
    if (Enum.member?(newObservers, user)) || getUser(user, game)  do
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
    Enum.reduce(Enum.map(curr.positions, fn(x) -> Enum.at(x.position, 0) == Enum.at(curr.clicked, 0) && Enum.at(x.position, 1) == Enum.at(curr.clicked,1) end), fn(x, acc) -> x || acc end)
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

  def setSymbolByPos(user, curPos, newPos, game) do
    curr = getOppo(user, game)
    curr = %{curr | turn: false}
    curr = %{curr | positions: Enum.map(curr.positions, fn(x) -> if Enum.at(x.position,0) == Enum.at(curPos, 0) && Enum.at(x.position, 1) == Enum.at(curPos, 1) do %{x | position: newPos} else x end end)}
    newUsers = updateUsers(game.users, getOppoColor(user, game), curr)
    %{game | users: newUsers}
  end

  def getSymbol(user, game) do
    curr = getUser(user, game)
    [head| tail] = Enum.filter(curr.positions, fn(x) -> Enum.at(x.position,0) == Enum.at(curr.clicked, 0) && Enum.at(x.position, 1) == Enum.at(curr.clicked, 1) end)
    head
  end

  def attack(user, key, game) do
    oppo = getOppo(user, game)
    oppo = %{oppo | turn: true}
    newPosition = [div(key, 8), rem(key, 8)]
    oppo = %{oppo | positions: Enum.filter(oppo.positions, fn(x) -> Enum.at(x.position, 0) != Enum.at(newPosition, 0) or Enum.at(x.position, 1) != Enum.at(newPosition, 1) end)}
    newUsers = updateUsers(game.users, getOppoColor(user, game), oppo)
    %{game | users: newUsers}
  end

  def attackByPos(user, newPos, game) do
    oppo = getUser(user, game)
    oppo = %{oppo | turn: true}
    oppo = %{oppo | positions: Enum.filter(oppo.positions, fn(x) -> Enum.at(x.position, 0) != Enum.at(newPos, 0) or Enum.at(x.position, 1) != Enum.at(newPos, 1) end)}
    newUsers = updateUsers(game.users, getUserColor(user, game), oppo)
    %{game | users: newUsers}
  end

  def checkLoseConditions(game, :black, user) do
    allSpaces = permutation([0, 1, 2, 3, 4, 5, 6, 7], 2)
    not Enum.any?(game.users.black.positions, fn(x) -> Enum.any?(allSpaces, fn(y) ->
      if isValidMove(x.name, x.position, y, game) do
        nextGame = attackByPos(user, y, setSymbolByPos(user, x.position, y, game))
        kingPosition = Enum.find(getOppo(user, nextGame).positions, nil, fn(x) -> x.name == "king" end)[:position]
        checkKingCheck(nextGame, kingPosition, :black)
      else
        false
      end
    end) end)
  end

  def checkLoseConditions(game, :white, user) do
    allSpaces = permutation([0, 1, 2, 3, 4, 5, 6, 7], 2)
    not Enum.any?(game.users.white.positions, fn(x) -> Enum.any?(allSpaces, fn(y) ->
      if isValidMove(x.name, x.position, y, game) do
        nextGame = attackByPos(user, y, setSymbolByPos(user, x.position, y, game))
        kingPosition = Enum.find(getOppo(user, nextGame).positions, nil, fn(x) -> x.name == "king" end)[:position]
        checkKingCheck(nextGame, kingPosition, :white)
      else
        false
      end
    end) end)
  end

  def setWinner(game, :white) do
    newWhite = %{game.users.white | isWinner: true}
    newUsers = %{game.users | white: newWhite}
    %{game | users: newUsers}
  end

  def setWinner(game, :black) do
    newBlack = %{game.users.black | isWinner: true}
    newUsers = %{game.users | black: newBlack}
    %{game | users: newUsers}
  end

  def click(user, game, key) do
    if getUser(user, game) do
      curr = getUser(user, game)
      if curr.turn && length(curr.clicked) > 0 && isSymbol(user, game) do
        if isValidMove(getSymbol(user, game).name, curr.clicked, [div(key, 8), rem(key, 8)], game) do
          nextGame = attack(user, key, setSymbol(user, key, game))
          kingPosition = Enum.find(getUser(user, nextGame).positions, nil, fn(x) -> x.name == "king" end)[:position]
          if checkKingCheck(nextGame, kingPosition, getUserColor(user, game)) do
            kingPosition = Enum.find(getOppo(user, nextGame).positions, nil, fn(x) -> x.name == "king" end)[:position]
            if not checkKingCheck(nextGame, kingPosition, getOppoColor(user, game)) and checkLoseConditions(nextGame, getOppoColor(user, game), user) do
              setWinner(nextGame, getUserColor(user, game))
            else
              nextGame
            end
          else
            curr= %{curr | clicked:  [div(key, 8), rem(key, 8)]}
            newUsers = updateUsers(game.users, getUserColor(user, game), curr)
            %{game | users: newUsers}
          end
        else
          curr= %{curr | clicked:  [div(key, 8), rem(key, 8)]}
          newUsers = updateUsers(game.users, getUserColor(user, game), curr)
          %{game | users: newUsers}
        end
      else
        curr= %{curr | clicked:  [div(key, 8), rem(key, 8)]}
        newUsers = updateUsers(game.users, getUserColor(user, game), curr)
        %{game | users: newUsers}
      end
    else
      game
    end
  end

  def permutation(list), do: permutation(list, length(list))
  def permutation([], _), do: [[]]
  def permutation(_,  0), do: [[]]
  def permutation(list, i) do
    for x <- list, y <- permutation(list, i-1), do: [x|y]
  end
end
