defmodule ChessgameWeb.GamesChannel do
  use ChessgameWeb, :channel
  alias Chessgame.Game
  alias Chessgame.Backup
  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Backup.load(name) || Game.new()
      game = Game.observe(payload["user"], game)
      socket = assign(socket,name, game)
      Backup.save(name, game)
      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("joinGame", %{"name" => name, "user" => user }, socket) do
    game = Game.joinGame(user, Backup.load(name))
    Backup.save(name, game)
    socket = assign(socket, name, game)
    broadcast! socket, "joinGame", %{"game" => game}
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("click", %{"name" => name, "user" => user, "ii" => key }, socket) do
    game = Game.click(user, Backup.load(name), key)
    Backup.save(name, game)
    socket = assign(socket, name, game)
    broadcast! socket, "click", %{"game" => game}
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
