defmodule PhoenixTimeline.GameTest do
  use PhoenixTimeline.ModelCase

  alias PhoenixTimeline.Game

  @valid_attrs %{code: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
