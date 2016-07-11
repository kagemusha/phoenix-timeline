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
    broadcast! socket, "game-started", Game.first_turn(game)
    {:reply, :ok, socket}
  end

  def handle_in("get-game-state", _, socket) do
    IO.puts "get-game-state"
    game_id = socket.assigns.game_id
    IO.puts "get-game-state: game #{game_id}"
    game_state = Game.get_state(game_id)
    IO.inspect game_state
    push socket, "game-state", game_state
    {:noreply, socket}
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
    IO.puts "handle_info"
    game_id = String.to_integer(game_id)
    case  Repo.get(Game, game_id) do
      nil ->
        {:stop, "Game no longer exists",  socket}
      game ->
        socket = assign(socket, :game_id, game_id)
        players = View.render(GameView, "players.json", %{game: game} )
        IO.puts "BRC: added-player"
        broadcast! socket, "added-player", players
        {:noreply, socket}
    end
  end

end