defmodule PhoenixTimeline.Api.PlayerController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player

  #plug :scrub_params, "game" when action in [:create, :update]

  def create(conn, %{ "player" => %{"name" => name, "game_code" => game_code} }) do

    game = Repo.get_by Game, code: game_code
    changeset =
      build_assoc(game, :players)
      |> Player.changeset(%{name: name})

    case Repo.insert(changeset) do
      {:ok, player} ->
        player = Repo.preload player, :game
        conn
        |> put_status(:created)
        |> render("player.json", %{player: player})
      {:error, _changeset} ->
        IO.puts "ERROR SAVING PLAYER"
    end

  end

end
