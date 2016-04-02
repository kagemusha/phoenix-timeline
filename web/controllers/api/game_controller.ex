defmodule PhoenixTimeline.Api.GameController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player

  #plug :scrub_params, "game" when action in [:create, :update]

  def index(conn, %{"code" => code}) do
    game = Repo.get_by(Game, code: code)
    render(conn, data: game)
  end

  def show(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)
    render(conn, data: game)
  end

  def create(conn, %{
      "data" => %{"attributes" => %{"code" => code},
      "creator"=> %{"data"=> %{"attributes" => creator_attrs}}}
   }) do
    creator_changes = Player.changeset(%Player{}, creator_attrs)

    case Repo.insert(creator_changes) do
      {:ok, creator} ->
        game_params = %{code: code, status: "not_started"}
        # this really should be atomic with game creation, but waiting
        # on ecto 2.0 where better assoc support expected
        game_changes = Ecto.build_assoc(creator, :created_game, game_params)
        game = Repo.insert!(game_changes)
        add_creator_as_player = Ecto.build_assoc(game, :players, Map.from_struct(creator))
        game = Repo.update!(add_creator_as_player)

        conn
        |> put_status(:created)
        |> render(:show, data: game)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def requestJoinGame do
    #tell game creator someone has joined
    # Endpoint.broadcast
  end

#  def update(conn, %{"id" => id, "game" => game_params}) do
#    game = Repo.get!(Game, id)
#    changeset = Game.changeset(game, game_params)
#
#    case Repo.update(changeset) do
#      {:ok, game} ->
#        render(conn, "show.json", game: game)
#      {:error, changeset} ->
#        conn
#        |> put_status(:unprocessable_entity)
#        |> render(PhoenixTimeline.ChangesetView, "error.json", changeset: changeset)
#    end
#  end

  def delete(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game)

    send_resp(conn, :no_content, "")
  end
end
