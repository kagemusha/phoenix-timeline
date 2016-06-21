defmodule PhoenixTimeline.Api.CardsetControllerTest do
  use PhoenixTimeline.ConnCase

  alias PhoenixTimeline.Cardset
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

#  @tag timeout: 600000 useful when PRYing
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cardset_path(conn, :index)
    expected_json = [%{"display_name" => "General history", "id" => 1, "name" => "general"},
                    %{"display_name" => "Peep stack", "id" => 2, "name" => "peep"}]
    assert json_response(conn, 200)["cardsets"] == expected_json
  end

  @tag :skip
  test "shows chosen resource", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = get conn, cardset_path(conn, :show, cardset)
    assert json_response(conn, 200)["data"] == %{"id" => cardset.id}
  end

  @tag :skip
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cardset_path(conn, :show, -1)
    end
  end

  @tag :skip
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, cardset_path(conn, :create), cardset: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Cardset, @valid_attrs)
  end

  @tag :skip
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cardset_path(conn, :create), cardset: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :skip
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = put conn, cardset_path(conn, :update, cardset), cardset: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Cardset, @valid_attrs)
  end

  @tag :skip
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = put conn, cardset_path(conn, :update, cardset), cardset: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :skip
  test "deletes chosen resource", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = delete conn, cardset_path(conn, :delete, cardset)
    assert response(conn, 204)
    refute Repo.get(Cardset, cardset.id)
  end
end
