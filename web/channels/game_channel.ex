defmodule PhoenixTimeline.GameChannel do
  use PhoenixTimeline.Web, :channel
  alias Phoenix.View
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Api.GameView

  def join("game:" <> game_id, _params, socket) do
    send self, {:after_join, %{game_id: game_id}}
    {:ok, socket}
  end

  def handle_in("start-game", _params, socket) do
    IO.puts "MESSAGE: start-game"
    # check if game already started
    game = socket.assigns.game_id
            |> Game.start

    IO.puts "BRC: start-game"
    broadcast! socket, "game-started", Game.next_turn(game.id, nil, true)
    {:reply, :ok, socket}
  end

  def handle_in("place-card", params, socket) do
    %{"position"=> position} = params
    game = socket.assigns.game_id
    IO.puts "BRC: turn-result"
    broadcast! socket, "turn-result", Game.card_placed(game, position)
    {:reply, :ok, socket}
  end

  def handle_in(event, _params, socket) do
    IO.puts "MESSAGE RECEIVED event: #{event}"
    {:reply, :ok, socket}
  end

  def handle_info({:after_join, %{game_id: game_id}}, socket) do
    game_id = String.to_integer(game_id)
    game = Repo.get!(Game, game_id)
    socket = assign(socket, :game_id, game_id)
    players = View.render(GameView, "players.json", %{game: game} )
    IO.puts "BRC: added-player"
    broadcast! socket, "added-player", players
    {:noreply, socket}
  end

end