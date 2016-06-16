defmodule PhoenixTimeline.Cardset do
  use PhoenixTimeline.Web, :model
  alias PhoenixTimeline.Card

  schema "cardsets" do
    many_to_many :cards, Card, join_through: "cardsets_cards"
    field :name, :string
    field :display_name, :string
    field :description, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
