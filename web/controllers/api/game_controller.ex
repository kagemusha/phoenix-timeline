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
        "game" => %{"code" => code, "initial_card_count" => card_count, "players" => [%{"game" => nil, "name" => player_name}]}
      }) do

    if is_binary(card_count), do: card_count = String.to_integer(card_count)
    game_params = %Game{code: code, initial_card_count: card_count}
    game = Repo.insert!(game_params)             #create game with player as creator

    Player.create(conn, game, player_name, true)

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
