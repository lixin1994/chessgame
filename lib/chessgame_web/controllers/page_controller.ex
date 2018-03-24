defmodule ChessgameWeb.PageController do
  use ChessgameWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
  def game(conn, params) do
    render conn, "game.html", game: params["game"], user: params["user"]
  end
end
