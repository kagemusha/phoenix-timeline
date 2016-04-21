defmodule PhoenixTimeline.GameChannel do
  use PhoenixTimeline.Web, :channel
  alias Phoenix.View
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Api.GameView

  def join("game:" <> game_id, params, socket) do
    send self, {:after_join, %{game_id: game_id}}
    {:ok, socket}
  end

  def handle_in("start-game", params, socket) do
    game = socket.assigns.game
            |> Game.start

    broadcast! socket, "game-started", Game.current_turn(game)
    {:reply, :ok, socket}
  end

  def handle_info({:after_join, %{game_id: game_id}}, socket) do
    game_id = String.to_integer(game_id)
    game = Repo.get!(Game, game_id)
    socket = assign(socket, :game, game)
    players = View.render(GameView, "players.json", %{game: game} )
    broadcast! socket, "added-player", players
    {:noreply, socket}
  end

  def handle_in(event, params, socket) do
    {:reply, :ok, socket}
  end
end