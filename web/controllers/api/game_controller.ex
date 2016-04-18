defmodule PhoenixTimeline.Api.GameController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player

  #plug :scrub_params, "game" when action in [:create, :update]

  def index(conn, %{"code" => code}) do
    game = Repo.get_by(Game, code: code)
    render(conn, data: game)
  end

  def create(conn, %{
        "game" => %{"code" => code, "players" => [%{"game" => nil, "name" => player_name}]}
      }) do

    game_params = %Game{code: code, status: "not_started"}
    game = Repo.insert!(game_params)             #create game with player as creator
    Repo.insert!(%Player{name: player_name, game_id: game.id,
    is_creator: true, cards_remaining: 10, total_cards: 10})

    game = Repo.preload(game, :players)
    conn
    |> put_status(:created)
    |> render("created_game.json", %{game: game})
  end

  def delete(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)
    Repo.delete!(game)

    send_resp(conn, :no_content, "")
  end
end
