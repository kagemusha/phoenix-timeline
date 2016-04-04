defmodule PhoenixTimeline.Api.GameControllerTest do
  use PhoenixTimeline.ConnCase

  alias PhoenixTimeline.Game
  @valid_attrs %{"attributes" => %{"code" => "guma"},
      "creator"=> %{"data"=> %{"attributes" => %{"name"=>"yolo"}}}}
  @invalid_attrs %{}

  setup %{conn: conn} do
   conn =
        conn
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

#  test "join game", %{conn: conn} do
#    assert_error_sent 404, fn ->
#      get conn, game_path(conn, :show, -1)
#    end
#  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    IO.inspect "game_path: #{game_path(conn, :create)}"
    params = Poison.encode!(%{data: @valid_attrs})
    conn = post conn, game_path(conn, :create), params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Game, @valid_attrs)
  end

#  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
#    conn = post conn, game_path(conn, :create), data: @invalid_attrs
#    assert json_response(conn, 422)["errors"] != %{}
#  end
#
#
#  test "deletes chosen resource", %{conn: conn} do
#    game = Repo.insert! %Game{}
#    conn = delete conn, game_path(conn, :delete, game)
#    assert response(conn, 204)
#    refute Repo.get(Game, game.id)
#  end
  defp create_game_json(player_name, game_code) do

  @valid_attrs %{"attributes" => %{"code" => "guma"},
      "creator"=> %{"data"=> %{"attributes" => %{"name"=>"yolo"}}}}
  end

end
