defmodule PhoenixTimeline.CardControllerTest do
  use PhoenixTimeline.ConnCase

  alias PhoenixTimeline.Card
  @valid_attrs %{event: "some content", year: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, card_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cards"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, card_path(conn, :new)
    assert html_response(conn, 200) =~ "New card"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, card_path(conn, :create), card: @valid_attrs
    assert redirected_to(conn) == card_path(conn, :index)
    assert Repo.get_by(Card, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, card_path(conn, :create), card: @invalid_attrs
    assert html_response(conn, 200) =~ "New card"
  end

  test "shows chosen resource", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = get conn, card_path(conn, :show, card)
    assert html_response(conn, 200) =~ "Show card"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, card_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = get conn, card_path(conn, :edit, card)
    assert html_response(conn, 200) =~ "Edit card"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = put conn, card_path(conn, :update, card), card: @valid_attrs
    assert redirected_to(conn) == card_path(conn, :show, card)
    assert Repo.get_by(Card, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = put conn, card_path(conn, :update, card), card: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit card"
  end

  test "deletes chosen resource", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = delete conn, card_path(conn, :delete, card)
    assert redirected_to(conn) == card_path(conn, :index)
    refute Repo.get(Card, card.id)
  end
end
