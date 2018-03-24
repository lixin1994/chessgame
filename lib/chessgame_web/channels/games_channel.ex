defmodule ChessgameWeb.GamesChannel do
  use ChessgameWeb, :channel
  alias ChessgameWeb.Game
  alias Chessgame.Backup
  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
      game = Memory.Backup.load(name) || Game.new()
      socket = assign(socket,name, game)
      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
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
