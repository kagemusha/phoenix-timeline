defmodule PhoenixTimeline.Api.PlayerController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player

  #plug :scrub_params, "game" when action in [:create, :update]
  def index(conn, %{"token"=> token}) do
    player = Repo.get_by( Player, token: token)
             |> Repo.preload(:game)
    conn
    |> render("player_with_game.json", %{player: player})
  end

  def create(conn, %{ "player" => %{"name" => name, "game_code" => game_code} }) do

    game = Repo.get_by Game, code: game_code
    case Player.create(conn, game, name) do
      {:ok, player} ->
        player = Repo.preload player, :game
        conn
        |> put_status(:created)
        |> render("player_with_game.json", %{player: player})
      {:error, _changeset} ->
        IO.puts "ERROR SAVING PLAYER"
    end

  end

end
