defmodule PhoenixTimeline.Api.CardTest do
  use PhoenixTimeline.ModelCase

  alias PhoenixTimeline.Api.Card

  @valid_attrs %{event: "some content", year: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Card.changeset(%Card{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Card.changeset(%Card{}, @invalid_attrs)
    refute changeset.valid?
  end
end
