defmodule Memory.Game do

  def new() do
    %{
      users: generateTiles(),
      firstGuessIndex: -1,
      secondGuessIndex: -1,
      disabled: false
    };
  end

  def client_view(game) do
    %{
      tiles: game.tiles,
      guesses: game.guesses,
      firstGuessIndex: -1,
      secondGuessIndex: -1,
      disabled: false
    };
  end

  def isValidMove("king", currPos, newPos) do
    currX = currPos
      |> elem(0)
    currY = currPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)
    cond do
      outOfBounds(newX, newY) -> false
      newX == currX and newY == currY -> false
      abs(newX - currX) <= 1 and abs(newY - currY) <= 1 -> true
      true -> false
    end
  end

  def isValidMove("queen", currentPos, newPos) do
    currX = currPos
      |> elem(0)
    currY = currPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      outOfBounds(newX, newY) -> false
      newX == currX and newY == currY -> false
      newX == currX or newY == currY -> true
      newX - currX == newY - currY -> true
      true -> false
    end
  end

  def isValidMove("bishop", currentPos, newPos) do
    currX = currPos
      |> elem(0)
    currY = currPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      outOfBounds(newX, newY) -> false
      newX == currX and newY == currY -> false
      newX - currX == newY - currY -> true
      true -> false
    end
  end

  def isValidMove("knight", currentPos, newPos) do
    currX = currPos
      |> elem(0)
    currY = currPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      outOfBounds(newX, newY) -> false
      newX == currX and newY == currY -> false
      abs(newX - currX) == 2 and abs(newY - currY) == 1 -> true
      abs(newY - currY) == 2 and abs(newX - currX) == 1 -> true
      true -> false
    end
  end

  def isValidMove("rook", currentPos, newPos) do
    currX = currPos
      |> elem(0)
    currY = currPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      outOfBounds(newX, newY) -> false
      newX == currX and newY == currY -> false
      newX == currX or newY == currY -> true
      true -> false
    end
  end

  def isValidMove("pawn", currentPos, newPos) do
    currX = currPos
      |> elem(0)
    currY = currPos
      |> elem(1)
    newX = newPos
      |> elem(0)
    newY = newPos
      |> elem(1)

    cond do
      outOfBounds(newX, newY) -> false
      newX == currX and newY == currY -> false
      newX == currX or newY == currY -> true
      true -> false
    end
  end

  def outOfBounds(x, y) do
    if x > 7 or x < 0 or y > 7 or y < 0 do
      true
    end
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


  def handleClick(game, id) do
    if game.disabled == true do
      IO.puts "ahhhh"
      game
    else
      tiles = game.tiles
      guesses = game.guesses
      firstGuessIndex = game.firstGuessIndex
      secondGuessIndex = game.secondGuessIndex
      disabled = game.disabled

      if firstGuessIndex != -1 do
        disabled = true
        secondGuessIndex = id
        newTiles =
          tiles
          |> Enum.map(fn x ->
            if x.index == id do
              Map.put(x, :flipped, true)
            else
              x
            end
          end)
      else
        firstGuessIndex = id
        newTiles =
          tiles
          |> Enum.map(fn x ->
            if x.index == id do
              Map.put(x, :flipped, true)
            else
              x
            end
          end)
      end

      %{
        tiles: newTiles,
        guesses: guesses,
        firstGuessIndex: firstGuessIndex,
        secondGuessIndex: secondGuessIndex,
        disabled: disabled
      }
    end
  end

  def handleMatch(game) do
    tiles = game.tiles
    guesses = game.guesses
    firstGuessIndex = game.firstGuessIndex
    secondGuessIndex = game.secondGuessIndex
    disabled = game.disabled

    guesses = guesses + 1
    firstTile = elem(Enum.fetch(tiles, firstGuessIndex), 1)
    secondTile = elem(Enum.fetch(tiles, secondGuessIndex), 1)


    if firstTile.value == secondTile.value do
      newTiles =
        tiles
        |> Enum.map(fn x ->
          if x.index == firstGuessIndex || x.index == secondGuessIndex do
            Map.put(x, :matched, true)
          else
            x
          end
        end)
    else
      newTiles =
        tiles
        |> Enum.map(fn x ->
          if x.index == firstGuessIndex || x.index == secondGuessIndex do
            Map.put(x, :flipped, false)
          else
            x
          end
        end)
    end

    %{
      tiles: newTiles,
      guesses: guesses,
      firstGuessIndex: -1,
      secondGuessIndex: -1,
      disabled: false
    }
  end
end
