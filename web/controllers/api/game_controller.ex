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
      "creator"=> %{"data"=> %{"attributes" => %{"name"=>name}}}} }) do

    game_params = %Game{code: code, status: "not_started"}
    creator = Repo.insert!(game_params)             #create game with player as creator
            |> build_assoc(:players, %{name: name})
            |> Repo.insert!                         #add creator as player

    creator = Repo.preload(creator, :game)
    game = creator.game

    conn
    |> put_status(:created)
    |> render(:show, data: game)
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
