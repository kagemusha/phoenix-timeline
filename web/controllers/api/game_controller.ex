defmodule PhoenixTimeline.Api.GameController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Game

  plug :scrub_params, "game" when action in [:create, :update]

  def index(conn, _params) do
    games = Repo.all(Game)
    render(conn, "index.json", games: games)
  end

  def create(conn, %{"game" => game_params}) do
    changeset = Game.changeset(%Game{}, game_params)

    case Repo.insert(changeset) do
      {:ok, game} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", game_path(conn, :show, game))
        |> render("show.json", game: game)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixTimeline.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)
    render(conn, "show.json", game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Repo.get!(Game, id)
    changeset = Game.changeset(game, game_params)

    case Repo.update(changeset) do
      {:ok, game} ->
        render(conn, "show.json", game: game)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixTimeline.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game)

    send_resp(conn, :no_content, "")
  end
end
