defmodule PhoenixTimeline.PlayerTest do
  use PhoenixTimeline.ModelCase

  alias PhoenixTimeline.Player

  @valid_attrs %{cards_remaining: 42, name: "some content", total_cards: 42, turn_position: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
