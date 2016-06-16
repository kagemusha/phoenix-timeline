defmodule PhoenixTimeline.CardsetTest do
  use PhoenixTimeline.ModelCase

  alias PhoenixTimeline.Cardset

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cardset.changeset(%Cardset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cardset.changeset(%Cardset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
