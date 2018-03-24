defmodule Chessgame.Game do
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

          ],
          clicked: []
        },
        white: %{
          name: "",
          turn: false,
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
  def joinGame(user, game) do
  end
end
