defmodule Chessgame.Game do
<<<<<<< HEAD

=======
>>>>>>> master
  def new() do
    %{
      users: %{
        black: %{
          name: "user1",
          turn: false,
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
<<<<<<< HEAD
=======

>>>>>>> master
          ],
          clicked: []
        },
        white: %{
          name: "",
<<<<<<< HEAD
          turn: true,
=======
          turn: false,
>>>>>>> master
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
<<<<<<< HEAD
=======

>>>>>>> master
          ],
          clicked: []
        }
      },
      observers: [],
<<<<<<< HEAD
    };
  end

  def client_view(game) do
    %{

    };
  end

  def isValidMove("king", curPos, newPos, game) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      abs(newX - curX) <= 1 and abs(newY - curY) <= 1 and checkCollisions(game, curPos, newPos, color)-> true
      true -> false
    end
  end

  def isValidMove("queen", curPos, newPos, game) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      newX == curX or newY == curY and checkCollisions(game, curPos, newPos, color) -> true
      newX - curX == newY - curY and checkCollisions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("bishop", curPos, newPos, game) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      newX - curX == newY - curY and checkCollisions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("knight", curPos, newPos, game) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
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
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
    color = findColor(game, curPos)


    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      newX == curX or newY == curY and checkCollisions(game, curPos, newPos, color) -> true
      true -> false
    end
  end

  def isValidMove("pawn", curPos, newPos, game) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
    color = findColor(game, curPos)

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      checkPawnConditions(game, curPos, newPos, color) -> true
      true -> false
    end
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
    not (Enum.any?(game[:users][:black][:positions], fn(x) -> not x[:position] == curPos
      and dist(curPos, x[:position]) + dist(x[:position], newPos) == dist(curPos, newPos) end) ||
      Enum.any?(game[:users][:white][:positions], fn(x) -> not x[:position] == newPos
      and dist(curPos, x[:position]) + dist(x[:position], newPos) == dist(curPos, newPos) end))
  end

  def checkCollisions(game, curPos, newPos, :white) do
    not (Enum.any?(game[:users][:white][:positions], fn(x) -> not x[:position] == curPos
      and dist(curPos, x[:position]) + dist(x[:position], newPos) == dist(curPos, newPos) end) ||
      Enum.any?(game[:users][:black][:positions], fn(x) -> not x[:position] == newPos
      and dist(curPos, x[:position]) + dist(x[:position], newPos) == dist(curPos, newPos) end))
  end

  def dist(pos1, pos2) do
    x1 = pos1
      |> elem(0)
    y1 = pos1
      |> elem(1)
    x2 = pos2
      |> elem(0)
    y2 = pos2
      |> elem(1)

    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2))
  end

  def checkPawnConditions(game, curPos, newPos, :black) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      curY == 6 and (newY == 5 or newY == 4) and curX == newX and checkCollisions(game, curPos, newPos, :black) -> true
      newY == curY - 1 and curX == newX and checkCollisions(game, curPos, newPos, :black) -> true
      newY == curY - 1 and abs(newX - curX) == 1 and Enum.any?(game[:users][:white][:positions], fn(x) -> x[:position] == newPos end) -> true
      true -> false
    end
  end

  def checkPawnConditions(game, curPos, newPos, :white) do
    curX = curPos
      |> elem(0)
    curY = curPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      curY == 6 and (newY == 5 or newY == 4) and curX == newX and checkCollisions(game, curPos, newPos, :white) -> true
      newY == curY - 1 and curX == newX and checkCollisions(game, curPos, newPos, :white) -> true
      newY == curY - 1 and abs(newX - curX) == 1 and Enum.any?(game[:users][:black][:positions], fn(x) -> x[:position] == newPos end) -> true
      true -> false
    end
  end

  def checkKnightCollision(game, newPos, :black) do
    Enum.any?(game[:users][:black][:positions], fn(x) -> x[:position] == newPos end)
  end

  def checkKnightCollision(game, newPos, :white) do
    Enum.any?(game[:users][:white][:positions], fn(x) -> x[:position] == newPos end)
=======
    }
  end
  def joinGame(user, game) do
>>>>>>> master
  end
end
