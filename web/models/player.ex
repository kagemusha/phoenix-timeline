defmodule PhoenixTimeline.Player do
  use PhoenixTimeline.Web, :model

  schema "players" do
    field :name, :string
    field :total_cards, :integer
    field :cards_remaining, :integer
    field :turn_position, :integer
    has_one :victory, PhoenixTimeline.Game, foreign_key: :winner_id
    has_one :created_game, PhoenixTimeline.Game, foreign_key: :creator_id

    belongs_to :game, PhoenixTimeline.Game

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(total_cards cards_remaining turn_position)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
