defmodule PhoenixTimeline.GameChannel do
  use PhoenixTimeline.Web, :channel
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Game

  def join("game:" <> game_id, params, socket) do
    IO.puts "in join 'game:#{game_id}' channel"
    game_id = String.to_integer(game_id)
    game = Repo.get!(Game, game_id)
    {:ok, socket}
  end

  def handle_in("start-game", params, socket) do
    IO.puts "start-game REceived"
    broadcast! socket, "game-started", %{}
    {:reply, :ok, socket}
  end

  def handle_in(event, params, socket) do
    IO.puts "Event REceived: #{inspect(event)}"
    {:reply, :ok, socket}
  end
end