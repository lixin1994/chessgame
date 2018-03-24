defmodule Memory.Game do

  def new() do
    %{

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
    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      abs(newX - curX) <= 1 and abs(newY - curY) <= 1 -> true
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

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      newX == curX or newY == curY and checkStraightCollisions(game, curPos, newPos) -> true
      newX - curX == newY - curY and checkDiagonalCollisions(game, curPos, newPos) -> true
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

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      newX - curX == newY - curY and checkDiagonalCollisions(game, curPos, newPos) -> true
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

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      abs(newX - curX) == 2 and abs(newY - curY) == 1 -> true
      abs(newY - curY) == 2 and abs(newX - curX) == 1 -> true
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

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      newX == curX or newY == curY and checkStraightCollisions(game, curPos, newPos) -> true
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

    cond do
      outOfBounds(newX, newY) -> false
      newX == curX and newY == curY -> false
      checkPawnConditions(game, curPos, newPos) -> true
      true -> false
    end
  end

  def outOfBounds(x, y) do
    if x > 7 or x < 0 or y > 7 or y < 0 do
      true
    end
  end

  def checkDiagonalCollisions(game, curPos, newPos) do
    true
  end

  def checkStraightCollisions(game, curPos, newPos) do
    true
  end

  def checkPawnConditions(game, curPos, newPos) do
    true
  end

  def generateTiles() do
    letters = "ABCDEFGH"
    lettersList = String.split(letters, "", trim: true)

    lettersList
    |> Enum.concat(lettersList)
    |> Enum.shuffle()
    |> Enum.with_index()
    |> Enum.map(fn x ->
      %{
        index: elem(x, 1),
        value: elem(x, 0),
        flipped: false,
        matched: false
      }
    end)
  end
end
