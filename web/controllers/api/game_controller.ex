defmodule PhoenixTimeline.Api.GameController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player
  alias PhoenixTimeline.Cardset

  #plug :scrub_params, "game" when action in [:create, :update]

  def index(conn, %{"code" => code}) do
    game = Repo.get_by(Game, code: code)
    render(conn, data: game)
  end

  def create(conn, %{
        "game" => %{"code" => code,
                    "initial_card_count" => card_count,
                     "cardset" => cardset_id,
                    "players" => [%{"game" => nil, "name" => player_name}]}
      }) do

    if is_binary(card_count), do: card_count = String.to_integer(card_count)
    if is_binary(cardset_id), do: cardset_id = String.to_integer(cardset_id)
    game_params = %Game{code: code, initial_card_count: card_count}
    game = Repo.insert!(game_params)


    Player.create(conn, game, player_name, true)
    game = Repo.preload(game, [:players, :cardset])

    cardset = Repo.get Cardset, cardset_id
    game
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:cardset, cardset)
    |> Repo.update!

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
